USE dental_clinic;

DELIMITER $$

DROP TRIGGER IF EXISTS trg_appointments_validate_date_insert$$
DROP TRIGGER IF EXISTS trg_appointments_validate_date_update$$
DROP TRIGGER IF EXISTS trg_appointments_status_insert$$
DROP TRIGGER IF EXISTS trg_appointments_status_update$$
DROP TRIGGER IF EXISTS trg_payments_after_insert$$
DROP TRIGGER IF EXISTS trg_payments_after_update$$


CREATE TRIGGER trg_appointments_validate_date_insert
BEFORE INSERT ON appointments
FOR EACH ROW
BEGIN
    IF NEW.requested_date < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Appointment request date cannot be in the past';
    END IF;
END$$


CREATE TRIGGER trg_appointments_validate_date_update
BEFORE UPDATE ON appointments
FOR EACH ROW
BEGIN
    IF NEW.requested_date < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Appointment request date cannot be in the past';
    END IF;
END$$


CREATE TRIGGER trg_appointments_status_insert
AFTER INSERT ON appointments
FOR EACH ROW
BEGIN
    INSERT INTO appointment_status_history
    (
        appointment_id,
        old_status_id,
        new_status_id,
        changed_by_user_id,
        change_reason
    )
    VALUES
    (
        NEW.appointment_id,
        NULL,
        NEW.status_id,
        NEW.last_modified_by_user_id,
        'Initial appointment request'
    );
END$$


CREATE TRIGGER trg_appointments_status_update
AFTER UPDATE ON appointments
FOR EACH ROW
BEGIN
    IF NOT (OLD.status_id <=> NEW.status_id) THEN

        INSERT INTO appointment_status_history
        (
            appointment_id,
            old_status_id,
            new_status_id,
            changed_by_user_id,
            change_reason
        )
        VALUES
        (
            NEW.appointment_id,
            OLD.status_id,
            NEW.status_id,
            NEW.last_modified_by_user_id,
            'Appointment status changed'
        );

    END IF;
END$$


CREATE TRIGGER trg_payments_after_insert
AFTER INSERT ON payments
FOR EACH ROW
BEGIN

    UPDATE invoices
    SET invoice_status =
        CASE
            WHEN (
                SELECT COALESCE(SUM(amount), 0)
                FROM payments
                WHERE invoice_id = NEW.invoice_id
                  AND payment_status = 'COMPLETED'
            ) = 0
                THEN 'UNPAID'

            WHEN (
                SELECT COALESCE(SUM(amount), 0)
                FROM payments
                WHERE invoice_id = NEW.invoice_id
                  AND payment_status = 'COMPLETED'
            ) < total_amount
                THEN 'PARTIALLY_PAID'

            ELSE 'PAID'
        END
    WHERE invoice_id = NEW.invoice_id;

END$$


CREATE TRIGGER trg_payments_after_update
AFTER UPDATE ON payments
FOR EACH ROW
BEGIN

    UPDATE invoices
    SET invoice_status =
        CASE
            WHEN (
                SELECT COALESCE(SUM(amount), 0)
                FROM payments
                WHERE invoice_id = NEW.invoice_id
                  AND payment_status = 'COMPLETED'
            ) = 0
                THEN 'UNPAID'

            WHEN (
                SELECT COALESCE(SUM(amount), 0)
                FROM payments
                WHERE invoice_id = NEW.invoice_id
                  AND payment_status = 'COMPLETED'
            ) < total_amount
                THEN 'PARTIALLY_PAID'

            ELSE 'PAID'
        END
    WHERE invoice_id = NEW.invoice_id;

END$$

DELIMITER ;
