USE dental_clinic;

DELIMITER $$

DROP FUNCTION IF EXISTS fn_calculate_invoice_subtotal$$
DROP FUNCTION IF EXISTS fn_get_invoice_balance$$


CREATE FUNCTION fn_calculate_invoice_subtotal(
    p_invoice_id INT
)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_subtotal DECIMAL(10,2) DEFAULT 0.00;

    SELECT COALESCE(SUM(line_total), 0.00)
    INTO v_subtotal
    FROM invoice_items
    WHERE invoice_id = p_invoice_id;

    RETURN v_subtotal;
END$$


CREATE FUNCTION fn_get_invoice_balance(
    p_invoice_id INT
)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2) DEFAULT 0.00;
    DECLARE v_paid DECIMAL(10,2) DEFAULT 0.00;

    SELECT COALESCE(total_amount, 0.00)
    INTO v_total
    FROM invoices
    WHERE invoice_id = p_invoice_id;

    SELECT COALESCE(SUM(amount), 0.00)
    INTO v_paid
    FROM payments
    WHERE invoice_id = p_invoice_id
      AND payment_status = 'COMPLETED';

    RETURN GREATEST(v_total - v_paid, 0.00);
END$$

DELIMITER ;
