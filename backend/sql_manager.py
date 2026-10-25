
import os
import mysql.connector
import pandas as pd
from dotenv import load_dotenv

load_dotenv()


class SQLConnector:

    def __init__(self):
        self.connection = None

    def connect(self):
        try:
            self.connection = mysql.connector.connect(
                host=os.getenv("SQL_HOST", "localhost"),
                user=os.getenv("SQL_USER", "root"),
                password=os.getenv("SQL_PASSWORD", ""),
                database=os.getenv("SQL_DATABASE", "ecocompute"),
                port=int(os.getenv("SQL_PORT", "3306"))
            )
            print("MySQL connected successfully!")

        except mysql.connector.Error as e:
            print("Connection failed:", e)
            self.connection = None

    def fetch_dataframe(self, query):
        cursor = None

        if not self.connection or not self.connection.is_connected():
            print("Please connect to MySQL first.")
            return pd.DataFrame()

        try:
            cursor = self.connection.cursor(dictionary=True)
            cursor.execute(query)
            return pd.DataFrame(cursor.fetchall())

        except mysql.connector.Error as e:
            print("Query failed:", e)
            return pd.DataFrame()

        finally:
            if cursor:
                cursor.close()

    def get_maintenance_details(self):
        query = """
            SELECT ml.log_id, c.client_name, sz.zone_name,
                   sr.rack_name, ml.issue_type, ml.status,
                   ml.maintenance_date
            FROM maintenance_logs AS ml
            INNER JOIN server_racks AS sr ON ml.rack_id = sr.rack_id
            INNER JOIN server_zones AS sz ON sr.zone_id = sz.zone_id
            INNER JOIN clients AS c ON sr.client_id = c.client_id
            ORDER BY ml.maintenance_date;
        """
        return self.fetch_dataframe(query)

    def get_high_power_racks(self):
        query = """
            SELECT sr.rack_name, sz.zone_name, sr.power_draw_kw
            FROM server_racks AS sr
            INNER JOIN server_zones AS sz ON sr.zone_id = sz.zone_id
            WHERE sr.power_draw_kw > (
                SELECT AVG(sr2.power_draw_kw)
                FROM server_racks AS sr2
                WHERE sr2.zone_id = sr.zone_id
            )
            ORDER BY sz.zone_name, sr.power_draw_kw DESC;
        """
        return self.fetch_dataframe(query)

    def get_logs_by_status(self):
        query = """
            SELECT status, COUNT(*) AS total_logs
            FROM maintenance_logs
            GROUP BY status
            ORDER BY total_logs DESC;
        """
        return self.fetch_dataframe(query)

    def get_busy_statuses(self):
        query = """
            SELECT status, COUNT(*) AS total_logs
            FROM maintenance_logs
            GROUP BY status
            HAVING COUNT(*) >= 3;
        """
        return self.fetch_dataframe(query)

    def log_maintenance(self, rack_id, issue_type, description,
                        status, technician):
        if not self.connection or not self.connection.is_connected():
            print("Please connect to MySQL first.")
            return

        cursor = None

        try:
            cursor = self.connection.cursor()
            cursor.callproc("log_maintenance", (
                rack_id, issue_type, description, status, technician
            ))
            self.connection.commit()
            print("Maintenance log added successfully!")

        except mysql.connector.Error as e:
            self.connection.rollback()
            print("Could not add maintenance log:", e)

        finally:
            if cursor:
                cursor.close()

    def close(self):
        if self.connection:
            self.connection.close()
            print("Connection closed.")
            self.connection = None
