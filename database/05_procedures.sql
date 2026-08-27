USE dental_clinic;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_record_payment$$


CREATE PROCEDURE sp_record_payment(
    IN p_invoice_id INT,
    IN p_amount DECIMAL(10,2),
    IN p_payment_method VARCHAR(30),
    IN p_user_id INT
)
BEGIN
    DECLARE v_balance DECIMAL(10,2);

    IF NOT EXISTS (
        SELECT 1
        FROM invoices
        WHERE invoice_id = p_invoice_id
    ) THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invoice does not exist';

    ELSEIF NOT EXISTS (
        SELECT 1
        FROM users
        WHERE user_id = p_user_id
          AND is_active = TRUE
    ) THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Processing user does not exist or is inactive';

    ELSEIF p_amount <= 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Payment amount must be greater than zero';

    ELSEIF p_payment_method NOT IN (
        'CASH',
        'CARD',
        'BANK_TRANSFER',
        'ONLINE'
    ) THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Invalid payment method';

    ELSE

        SET v_balance = fn_get_invoice_balance(p_invoice_id);

        IF v_balance <= 0 THEN

            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Invoice is already fully paid';

        ELSEIF p_amount > v_balance THEN

            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Payment cannot exceed outstanding balance';

        ELSE

            INSERT INTO payments
            (
                invoice_id,
                payment_reference,
                amount,
                payment_method,
                payment_status,
                processed_by_user_id
            )
            VALUES
            (
                p_invoice_id,
                CONCAT(
                    'PAY-',
                    REPLACE(UUID(), '-', '')
                ),
                p_amount,
                p_payment_method,
                'COMPLETED',
                p_user_id
            );

        END IF;

    END IF;

END$$

DELIMITER ;
