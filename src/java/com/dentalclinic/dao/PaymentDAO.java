package com.dentalclinic.dao;

import com.dentalclinic.model.Payment;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface PaymentDAO {

    int create(
            Payment payment
    ) throws SQLException;

    Optional<Payment> findById(
            int paymentId
    ) throws SQLException;

    List<Payment> findByInvoiceId(
            int invoiceId
    ) throws SQLException;

    Optional<Payment> findLatestCompletedByInvoiceId(
            int invoiceId
    ) throws SQLException;
}