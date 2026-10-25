-- EcoCompute demonstration data.
-- Safe to run after schema.sql on an empty database.
-- IDs are explicit to keep the sample relationships easy to follow.

INSERT INTO clients (client_id, client_name, contact_email) VALUES
(1, 'GreenGrid Analytics', 'ops@greengrid.example'),
(2, 'Northstar Cloud', 'support@northstar.example'),
(3, 'TerraCompute Labs', 'admin@terracompute.example')
ON CONFLICT (client_id) DO NOTHING;

INSERT INTO server_zones (zone_id, zone_name, location, cooling_type) VALUES
(1, 'Zone A', 'Building 1 - Floor 1', 'Air Cooling'),
(2, 'Zone B', 'Building 1 - Floor 2', 'Liquid Cooling'),
(3, 'Zone C', 'Building 2 - Floor 1', 'Hybrid Cooling')
ON CONFLICT (zone_id) DO NOTHING;

INSERT INTO server_racks (rack_id, rack_name, zone_id, client_id, power_draw_kw, installed_on) VALUES
(1, 'RACK-A01', 1, 1, 12.50, '2024-02-10'),
(2, 'RACK-A02', 1, 2, 15.20, '2024-05-18'),
(3, 'RACK-B01', 2, 1, 18.40, '2023-11-02'),
(4, 'RACK-B02', 2, 3, 10.80, '2025-01-15'),
(5, 'RACK-C01', 3, 2, 16.10, '2024-08-21'),
(6, 'RACK-C02', 3, 3, 9.60, '2025-03-12')
ON CONFLICT (rack_id) DO NOTHING;

INSERT INTO maintenance_logs
(log_id, rack_id, maintenance_date, issue_type, description, status, technician) VALUES
(1, 1, '2026-10-01', 'High Temperature', 'Temperature exceeded preferred operating range.', 'Resolved', 'A. Shah'),
(2, 2, '2026-10-03', 'Fan Warning', 'Cooling fan vibration detected during inspection.', 'In Progress', 'R. Patil'),
(3, 3, '2026-10-04', 'Power Spike', 'Unexpected increase in rack power draw.', 'Open', 'S. Rao'),
(4, 4, '2026-10-06', 'Routine Inspection', 'Scheduled inspection and dust removal.', 'Resolved', 'A. Shah'),
(5, 5, '2026-10-08', 'High Temperature', 'Thermal alert received from monitoring system.', 'Open', 'M. Joshi'),
(6, 6, '2026-10-10', 'Sensor Check', 'Temperature sensor calibration required.', 'In Progress', 'R. Patil'),
(7, 1, '2026-10-12', 'Routine Inspection', 'Checked airflow and cable placement.', 'Resolved', 'M. Joshi'),
(8, 3, '2026-10-14', 'Fan Warning', 'Fan speed fluctuated during peak load.', 'Open', 'S. Rao'),
(9, 5, '2026-10-16', 'Power Spike', 'Power draw briefly crossed normal threshold.', 'Resolved', 'A. Shah'),
(10, 2, '2026-10-18', 'Routine Inspection', 'Monthly rack inspection completed.', 'Resolved', 'R. Patil')
ON CONFLICT (log_id) DO NOTHING;

-- Keep identity sequences in sync after explicit IDs.
SELECT setval(pg_get_serial_sequence('clients', 'client_id'),
              COALESCE((SELECT MAX(client_id) FROM clients), 1));
SELECT setval(pg_get_serial_sequence('server_zones', 'zone_id'),
              COALESCE((SELECT MAX(zone_id) FROM server_zones), 1));
SELECT setval(pg_get_serial_sequence('server_racks', 'rack_id'),
              COALESCE((SELECT MAX(rack_id) FROM server_racks), 1));
SELECT setval(pg_get_serial_sequence('maintenance_logs', 'log_id'),
              COALESCE((SELECT MAX(log_id) FROM maintenance_logs), 1));
