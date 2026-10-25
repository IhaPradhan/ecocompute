USE ecocompute;

INSERT INTO clients (client_id, client_name, contact_email) VALUES
(1, 'TechNova Solutions', 'contact@technova.example'),
(2, 'GreenCloud Systems', 'info@greencloud.example'),
(3, 'DataSphere Analytics', 'support@datasphere.example'),
(4, 'ByteBridge Technologies', 'hello@bytebridge.example'),
(5, 'NexGen Computing', 'admin@nexgen.example');

INSERT INTO server_zones (zone_id, zone_name, location, cooling_type) VALUES
(1, 'Zone A', 'Pune', 'Air Cooling'),
(2, 'Zone B', 'Mumbai', 'Liquid Cooling'),
(3, 'Zone C', 'Bengaluru', 'Hybrid Cooling');

INSERT INTO server_racks
(rack_id, rack_name, zone_id, client_id, power_draw_kw, installed_on) VALUES
(1, 'Rack A1', 1, 1, 12.50, '2025-01-15'),
(2, 'Rack A2', 1, 2, 18.20, '2025-02-10'),
(3, 'Rack A3', 1, 3, 15.75, '2025-03-05'),
(4, 'Rack B1', 2, 1, 22.40, '2025-01-20'),
(5, 'Rack B2', 2, 4, 19.60, '2025-04-12'),
(6, 'Rack B3', 2, 5, 25.10, '2025-05-18'),
(7, 'Rack C1', 3, 2, 14.80, '2025-02-22'),
(8, 'Rack C2', 3, 3, 21.30, '2025-06-08'),
(9, 'Rack C3', 3, 4, 17.90, '2025-07-14');

INSERT INTO maintenance_logs
(log_id, rack_id, maintenance_date, issue_type, description, status, technician) VALUES
(1, 1, '2026-10-01 09:00:00', 'Overheating', 'Temperature exceeded threshold', 'Resolved', 'Amit'),
(2, 2, '2026-10-02 10:30:00', 'Power fluctuation', 'Unstable power supply', 'In Progress', 'Neha'),
(3, 3, '2026-10-03 11:00:00', 'Cooling failure', 'Cooling unit needs inspection', 'Open', 'Rahul'),
(4, 4, '2026-10-04 14:15:00', 'Overheating', 'Rack temperature above normal', 'Resolved', 'Priya'),
(5, 5, '2026-10-05 15:00:00', 'Fan failure', 'Cooling fan not operating', 'Open', 'Amit'),
(6, 6, '2026-10-06 09:45:00', 'Power fluctuation', 'Intermittent power variation', 'In Progress', 'Neha'),
(7, 7, '2026-10-07 12:00:00', 'Cooling failure', 'Cooling system inspection required', 'Resolved', 'Rahul'),
(8, 8, '2026-10-08 13:30:00', 'Hardware fault', 'Server component needs replacement', 'Open', 'Priya'),
(9, 9, '2026-10-09 16:00:00', 'Overheating', 'High operating temperature', 'Resolved', 'Amit'),
(10, 1, '2026-10-10 10:00:00', 'Routine maintenance', 'Scheduled preventive maintenance', 'Resolved', 'Neha'),
(11, 3, '2026-10-11 11:30:00', 'Fan failure', 'Fan performance below expected level', 'In Progress', 'Rahul'),
(12, 5, '2026-10-12 14:00:00', 'Hardware fault', 'Diagnostic check required', 'Open', 'Priya');

INSERT INTO maintenance_logs
(rack_id, maintenance_date, issue_type, description, status, technician) VALUES
(2, '2026-10-13 09:00:00', 'Overheating', 'Temperature rising above normal', 'Open', 'Amit'),
(4, '2026-10-13 10:00:00', 'Fan failure', 'Cooling fan requires replacement', 'Resolved', 'Neha'),
(6, '2026-10-13 11:00:00', 'Cooling failure', 'Cooling unit inspection required', 'In Progress', 'Rahul'),
(8, '2026-10-13 12:00:00', 'Power fluctuation', 'Power supply needs inspection', 'Open', 'Priya'),
(9, '2026-10-13 13:00:00', 'Hardware fault', 'Server hardware diagnostic required', 'Resolved', 'Amit'),
(1, '2026-10-14 09:00:00', 'Cooling failure', 'Cooling system needs cleaning', 'Resolved', 'Neha'),
(3, '2026-10-14 10:00:00', 'Overheating', 'Rack temperature exceeded limit', 'In Progress', 'Rahul'),
(5, '2026-10-14 11:00:00', 'Routine maintenance', 'Preventive system check', 'Resolved', 'Priya'),
(7, '2026-10-14 12:00:00', 'Fan failure', 'Fan performance is low', 'Open', 'Amit'),
(2, '2026-10-14 13:00:00', 'Hardware fault', 'Component inspection required', 'In Progress', 'Neha'),
(4, '2026-10-15 09:00:00', 'Power fluctuation', 'Voltage variation detected', 'Resolved', 'Rahul'),
(6, '2026-10-15 10:00:00', 'Overheating', 'High rack temperature detected', 'Open', 'Priya'),
(8, '2026-10-15 11:00:00', 'Cooling failure', 'Cooling performance reduced', 'Resolved', 'Amit'),
(9, '2026-10-15 12:00:00', 'Routine maintenance', 'Scheduled inspection completed', 'Resolved', 'Neha'),
(1, '2026-10-15 13:00:00', 'Fan failure', 'Fan requires servicing', 'In Progress', 'Rahul'),
(3, '2026-10-16 09:00:00', 'Power fluctuation', 'Power variation under observation', 'Open', 'Priya'),
(5, '2026-10-16 10:00:00', 'Hardware fault', 'Hardware diagnostic completed', 'Resolved', 'Amit'),
(7, '2026-10-16 11:00:00', 'Overheating', 'Temperature above operating range', 'In Progress', 'Neha'),
(2, '2026-10-16 12:00:00', 'Cooling failure', 'Cooling unit requires servicing', 'Resolved', 'Rahul'),
(4, '2026-10-16 13:00:00', 'Routine maintenance', 'Preventive maintenance check', 'Resolved', 'Priya'),
(6, '2026-10-17 09:00:00', 'Fan failure', 'Cooling fan replacement required', 'Open', 'Amit'),
(8, '2026-10-17 10:00:00', 'Power fluctuation', 'Power supply checked', 'Resolved', 'Neha'),
(9, '2026-10-17 11:00:00', 'Cooling failure', 'Cooling unit performance issue', 'In Progress', 'Rahul'),
(1, '2026-10-17 12:00:00', 'Hardware fault', 'Server component inspected', 'Resolved', 'Priya'),
(5, '2026-10-17 13:00:00', 'Overheating', 'Rack temperature requires monitoring', 'Open', 'Amit');