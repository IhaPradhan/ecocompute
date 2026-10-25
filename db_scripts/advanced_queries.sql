-- EcoCompute advanced SQL examples (PostgreSQL)
-- Run each query separately to inspect its output.

-- 1. INNER JOIN: maintenance logs with rack, zone, and client details.
SELECT
    ml.log_id,
    ml.maintenance_date,
    ml.issue_type,
    ml.status,
    sr.rack_name,
    sz.zone_name,
    c.client_name
FROM maintenance_logs AS ml
INNER JOIN server_racks AS sr ON ml.rack_id = sr.rack_id
INNER JOIN server_zones AS sz ON sr.zone_id = sz.zone_id
INNER JOIN clients AS c ON sr.client_id = c.client_id
ORDER BY ml.maintenance_date DESC;

-- 2. Nested subquery: racks whose power draw is above the average
-- power draw of racks in their own zone.
SELECT rack_name, zone_id, power_draw_kw
FROM server_racks AS sr
WHERE power_draw_kw > (
    SELECT AVG(power_draw_kw)
    FROM server_racks
    WHERE zone_id = sr.zone_id
)
ORDER BY zone_id, power_draw_kw DESC;

-- 3. Stored procedure: log a maintenance event for an existing rack.
-- PostgreSQL procedure; execute using CALL log_maintenance(...).
CREATE OR REPLACE PROCEDURE log_maintenance(
    p_rack_id INTEGER,
    p_maintenance_date DATE,
    p_issue_type VARCHAR(100),
    p_description TEXT,
    p_technician VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM server_racks WHERE rack_id = p_rack_id) THEN
        RAISE EXCEPTION 'Rack ID % does not exist', p_rack_id;
    END IF;

    INSERT INTO maintenance_logs
        (rack_id, maintenance_date, issue_type, description, status, technician)
    VALUES
        (p_rack_id, p_maintenance_date, p_issue_type, p_description, 'Open', p_technician);
END;
$$;

-- Example procedure call (uncomment to test; inserts a new row):
-- CALL log_maintenance(1, CURRENT_DATE, 'Test Event', 'Procedure test', 'Demo Technician');

-- 4. Grouping query: count maintenance events by status.
SELECT status, COUNT(*) AS total_logs
FROM maintenance_logs
GROUP BY status
ORDER BY total_logs DESC;
