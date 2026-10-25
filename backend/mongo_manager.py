
import os

import pandas as pd
from dotenv import load_dotenv
from pymongo import MongoClient
from pymongo.errors import PyMongoError

from db_scripts.aggregation_pipeline import build_pipeline

load_dotenv("atlas-credentials.env")


class MongoConnector:

    def __init__(self):
        self.client = None
        self.database = None

    def connect(self):
        try:
            uri = os.getenv("MONGODB_URI")
            database_name = os.getenv(
                "MONGODB_DATABASE", "ecocompute"
            )

            if not uri or "replace_with_your_own_uri" in uri:
                print("Configure MONGODB_URI in your .env file.")
                return False

            self.client = MongoClient(
                uri, serverSelectionTimeoutMS=5000
            )
            self.client.admin.command("ping")
            self.database = self.client[database_name]

            print("MongoDB connected successfully!")
            return True

        except PyMongoError as error:
            print("MongoDB connection failed:", error)
            self.close()
            return False

    def get_hourly_telemetry(self, hours=48):
        if self.database is None:
            print("Please connect to MongoDB first.")
            return pd.DataFrame()

        if not isinstance(hours, int) or hours < 1:
            print("Hours must be a positive integer.")
            return pd.DataFrame()

        try:
            pipeline = build_pipeline(hours)
            results = list(
                self.database["telemetry_logs"].aggregate(pipeline)
            )

            rows = []

            for result in results:
                group = result["_id"]

                rows.append({
                    "hour": group["hour"],
                    "rack_id": group["rack_id"],
                    "rack_name": group["rack_name"],
                    "zone_name": group["zone_name"],
                    "avg_temperature_c": result["avg_temperature_c"],
                    "avg_power_draw_kw": result["avg_power_draw_kw"],
                    "avg_cpu_usage_pct": result["avg_cpu_usage_pct"],
                    "reading_count": result["reading_count"]
                })

            return pd.DataFrame(rows)

        except (PyMongoError, KeyError, TypeError, ValueError) as error:
            print("Telemetry query failed:", error)
            return pd.DataFrame()

    def close(self):
        if self.client is not None:
            self.client.close()
            self.client = None
            self.database = None
            print("MongoDB connection closed.")
