package com.dentalclinic.service;

import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.model.Payment;
import com.dentalclinic.model.Receipt;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public interface PaymentService {

    Receipt makePayment(
            int invoiceId,
            BigDecimal amount,
            String paymentMethod,
            String notes,
            int cashierUserId
    ) throws SQLException, ValidationException;

    List<Payment> getPayments(
            int invoiceId
    ) throws SQLException, ValidationException;

    Payment getPayment(
            int paymentId
    ) throws SQLException, ValidationException;

    Receipt getReceiptByPaymentId(
            int paymentId
    ) throws SQLException, ValidationException;
}