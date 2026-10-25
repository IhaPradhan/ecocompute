USE ecocompute;

-- 1. INNER JOIN across four tables
SELECT
    ml.log_id,
    c.client_name,
    sz.zone_name,
    sr.rack_name,
    ml.issue_type,
    ml.status,
    ml.maintenance_date
FROM maintenance_logs AS ml
INNER JOIN server_racks AS sr
    ON ml.rack_id = sr.rack_id
INNER JOIN server_zones AS sz
    ON sr.zone_id = sz.zone_id
INNER JOIN clients AS c
    ON sr.client_id = c.client_id
ORDER BY ml.maintenance_date;

-- 2. Correlated subquery: racks above their zone's average power draw
SELECT
    sr.rack_name,
    sz.zone_name,
    sr.power_draw_kw
FROM server_racks AS sr
INNER JOIN server_zones AS sz
    ON sr.zone_id = sz.zone_id
WHERE sr.power_draw_kw > (
    SELECT AVG(sr2.power_draw_kw)
    FROM server_racks AS sr2
    WHERE sr2.zone_id = sr.zone_id
)
ORDER BY sz.zone_name, sr.power_draw_kw DESC;

-- 3. Count maintenance logs by status
SELECT
    status,
    COUNT(*) AS total_logs
FROM maintenance_logs
GROUP BY status
ORDER BY total_logs DESC;

-- 4. HAVING: show statuses with at least three logs
SELECT
    status,
    COUNT(*) AS total_logs
FROM maintenance_logs
GROUP BY status
HAVING COUNT(*) >= 3;

-- 5. Stored procedure: validate the rack before inserting a log
DROP PROCEDURE IF EXISTS log_maintenance;

DELIMITER //

CREATE PROCEDURE log_maintenance(
    IN p_rack_id INT,
    IN p_issue_type VARCHAR(100),
    IN p_description TEXT,
    IN p_status VARCHAR(20),
    IN p_technician VARCHAR(100)
)
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM server_racks
        WHERE rack_id = p_rack_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Rack does not exist';
    ELSE
        INSERT INTO maintenance_logs (
            rack_id,
            maintenance_date,
            issue_type,
            description,
            status,
            technician
        )
        VALUES (
            p_rack_id,
            NOW(),
            p_issue_type,
            p_description,
            p_status,
            p_technician
        );
    END IF;
END //

DELIMITER ;
