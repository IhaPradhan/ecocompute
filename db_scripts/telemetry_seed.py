
import os
import uuid
import random
import argparse
from datetime import datetime, timedelta, timezone

from dotenv import load_dotenv
from pymongo import MongoClient, ASCENDING


def generate_telemetry(count, hours):
    """Generate mock telemetry readings for EcoCompute server racks."""
    random.seed(42)

    racks = [
        {"rack_id": 1, "rack_name": "Rack A1", "zone_id": 1, "zone_name": "Zone A"},
        {"rack_id": 2, "rack_name": "Rack A2", "zone_id": 1, "zone_name": "Zone A"},
        {"rack_id": 3, "rack_name": "Rack B1", "zone_id": 2, "zone_name": "Zone B"},
        {"rack_id": 4, "rack_name": "Rack B2", "zone_id": 2, "zone_name": "Zone B"},
        {"rack_id": 5, "rack_name": "Rack C1", "zone_id": 3, "zone_name": "Zone C"},
        {"rack_id": 6, "rack_name": "Rack C2", "zone_id": 3, "zone_name": "Zone C"},
        {"rack_id": 7, "rack_name": "Rack D1", "zone_id": 4, "zone_name": "Zone D"},
        {"rack_id": 8, "rack_name": "Rack D2", "zone_id": 4, "zone_name": "Zone D"},
        {"rack_id": 9, "rack_name": "Rack E1", "zone_id": 5, "zone_name": "Zone E"},
    ]

    now = datetime.now(timezone.utc)
    start = now - timedelta(hours=hours)
    records = []

    for _ in range(count):
        rack = random.choice(racks)
        timestamp = start + timedelta(
            seconds=random.randint(0, max(1, int((now - start).total_seconds())))
        )

        temperature = round(random.gauss(32, 7), 2)
        temperature = max(18, min(75, temperature))
        power = round(random.uniform(5, 35), 2)
        cpu = round(random.uniform(10, 98), 2)

        if temperature >= 60:
            status = "critical"
        elif temperature >= 45:
            status = "warning"
        else:
            status = "normal"

        records.append({
            "event_id": str(uuid.uuid4()),
            "timestamp": timestamp,
            "rack_id": rack["rack_id"],
            "rack_name": rack["rack_name"],
            "zone_id": rack["zone_id"],
            "zone_name": rack["zone_name"],
            "temperature_c": temperature,
            "power_draw_kw": power,
            "cpu_usage_pct": cpu,
            "status": status,
        })

    return records


def main():
    parser = argparse.ArgumentParser(
        description="Seed EcoCompute MongoDB telemetry data"
    )
    parser.add_argument("--count", type=int, default=1200)
    parser.add_argument("--hours", type=int, default=48)
    args = parser.parse_args()

    if args.count < 1 or args.hours < 1:
        parser.error("--count and --hours must both be positive")

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
        database = client[database_name]
        collection = database["telemetry_logs"]

        records = generate_telemetry(args.count, args.hours)
        result = collection.insert_many(records)

        collection.create_index([("timestamp", ASCENDING)])
        collection.create_index([
            ("rack_id", ASCENDING),
            ("timestamp", ASCENDING)
        ])

        print("MongoDB connection successful.")
        print(f"Database: {database_name}")
        print("Collection: telemetry_logs")
        print(f"Inserted this run: {len(result.inserted_ids)}")
        print(f"Total documents: {collection.count_documents({})}")
        print("Indexes created: timestamp; rack_id + timestamp")

    finally:
        client.close()


if __name__ == "__main__":
    main()
