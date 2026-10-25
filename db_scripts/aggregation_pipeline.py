
import os
import argparse
from datetime import datetime, timedelta, timezone

from dotenv import load_dotenv
from pymongo import MongoClient


def build_pipeline(hours):
    """Calculate hourly averages for each rack in the selected time window."""
    cutoff = datetime.now(timezone.utc) - timedelta(hours=hours)

    return [
        {
            "$match": {
                "timestamp": {"$gte": cutoff},
                "temperature_c": {"$type": "number"},
            }
        },
        {
            "$group": {
                "_id": {
                    "hour": {
                        "$dateTrunc": {
                            "date": "$timestamp",
                            "unit": "hour",
                        }
                    },
                    "rack_id": "$rack_id",
                    "rack_name": "$rack_name",
                    "zone_name": "$zone_name",
                },
                "avg_temperature_c": {"$avg": "$temperature_c"},
                "avg_power_draw_kw": {"$avg": "$power_draw_kw"},
                "avg_cpu_usage_pct": {"$avg": "$cpu_usage_pct"},
                "reading_count": {"$sum": 1},
            }
        },
        {
            "$sort": {
                "_id.hour": 1,
                "_id.rack_id": 1,
            }
        },
    ]


def main():
    parser = argparse.ArgumentParser(
        description="Calculate hourly EcoCompute telemetry averages"
    )
    parser.add_argument("--hours", type=int, default=48)
    args = parser.parse_args()

    if args.hours < 1:
        parser.error("--hours must be positive")

    load_dotenv()

    uri = os.getenv("MONGODB_URI")
    database_name = os.getenv("MONGODB_DATABASE", "ecocompute")

    if not uri or "replace_with_your_own_uri" in uri:
        raise SystemExit(
            "MONGODB_URI is missing or still a placeholder in your local .env file."
        )

    client = MongoClient(uri, serverSelectionTimeoutMS=10000)

    try:
        client.admin.command("ping")
        collection = client[database_name]["telemetry_logs"]

        results = list(collection.aggregate(build_pipeline(args.hours)))

        print(f"Hourly telemetry averages for the last {args.hours} hours")
        print("-" * 100)

        if not results:
            print("No telemetry records found in the selected time window.")
            return

        for result in results:
            group = result["_id"]
            hour = group["hour"].strftime("%Y-%m-%d %H:%M UTC")

            print(
                f"{hour} | {group['rack_name']} | {group['zone_name']} | "
                f"Avg temperature: {result['avg_temperature_c']:.2f} C | "
                f"Avg power: {result['avg_power_draw_kw']:.2f} kW | "
                f"Avg CPU: {result['avg_cpu_usage_pct']:.2f}% | "
                f"Readings: {result['reading_count']}"
            )

        print("-" * 100)
        print(f"Total hourly rack groups: {len(results)}")

    finally:
        client.close()


if __name__ == "__main__":
    main()
