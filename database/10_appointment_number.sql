USE dental_clinic;

-- 1. Add appointment_number column if it does not exist
SET @dbname = DATABASE();
SET @tablename = "appointments";
SET @columnname = "appointment_number";
SET @preparedStatement = (SELECT IF(
    (
        SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
        WHERE (table_name = @tablename)
        AND (table_schema = @dbname)
        AND (column_name = @columnname)
    ) > 0,
    "SELECT 1",
    "ALTER TABLE appointments ADD COLUMN appointment_number VARCHAR(50) NULL AFTER appointment_id;"
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- 2. Backfill existing appointments with formatted numbers
UPDATE appointments
SET appointment_number = CONCAT('APT-', YEAR(COALESCE(created_at, NOW())), '-', LPAD(appointment_id, 6, '0'))
WHERE appointment_number IS NULL OR appointment_number = '';

-- 3. Add UNIQUE constraint if not already constrained
SET @preparedStatement = (SELECT IF(
    (
        SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        WHERE (table_name = @tablename)
        AND (table_schema = @dbname)
        AND (constraint_name = 'uk_appointments_number')
    ) > 0,
    "SELECT 1",
    "ALTER TABLE appointments ADD CONSTRAINT uk_appointments_number UNIQUE (appointment_number);"
));
PREPARE addUniqueIfNotExists FROM @preparedStatement;
EXECUTE addUniqueIfNotExists;
DEALLOCATE PREPARE addUniqueIfNotExists;

-- 4. Create trigger to auto-generate appointment_number before insert
DELIMITER $$

DROP TRIGGER IF EXISTS trg_appointments_number_before_insert$$

CREATE TRIGGER trg_appointments_number_before_insert
BEFORE INSERT ON appointments
FOR EACH ROW
BEGIN
    IF NEW.appointment_number IS NULL OR NEW.appointment_number = '' THEN
        -- Temporary fallback, will be replaced with next auto_increment ID in application or post-insert format
        SET NEW.appointment_number = CONCAT('APT-', YEAR(CURDATE()), '-', LPAD(FLOOR(RAND() * 899999 + 100000), 6, '0'));
    END IF;
END$$

DELIMITER ;
