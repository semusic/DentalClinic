USE dental_clinic;

-- 1. Ensure audit_logs table has proper index for quick entity lookup
SET @dbname = DATABASE();
SET @tablename = "audit_logs";
SET @preparedStatement = (SELECT IF(
    (
        SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
        WHERE (table_name = @tablename)
        AND (table_schema = @dbname)
        AND (index_name = 'idx_audit_logs_entity')
    ) > 0,
    "SELECT 1",
    "CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id);"
));
PREPARE addIndexIfNotExists FROM @preparedStatement;
EXECUTE addIndexIfNotExists;
DEALLOCATE PREPARE addIndexIfNotExists;

-- 2. Audit trigger on appointments status change
DELIMITER $$

DROP TRIGGER IF EXISTS trg_appointments_audit_update$$

CREATE TRIGGER trg_appointments_audit_update
AFTER UPDATE ON appointments
FOR EACH ROW
BEGIN
    IF NOT (OLD.status_id <=> NEW.status_id) THEN
        INSERT INTO audit_logs (user_id, action, entity_type, entity_id, old_data, new_data, severity)
        VALUES (
            NEW.last_modified_by_user_id,
            'APPOINTMENT_STATUS_CHANGE',
            'APPOINTMENT',
            CAST(NEW.appointment_id AS CHAR),
            CONCAT('StatusID:', OLD.status_id),
            CONCAT('StatusID:', NEW.status_id),
            'INFO'
        );
    END IF;
END$$

DELIMITER ;
