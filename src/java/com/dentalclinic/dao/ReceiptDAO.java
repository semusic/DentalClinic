package com.dentalclinic.dao;

import com.dentalclinic.model.Receipt;

import java.sql.SQLException;
import java.util.Optional;

public interface ReceiptDAO {

    int create(
            Receipt receipt
    ) throws SQLException;

    Optional<Receipt> findById(
            int receiptId
    ) throws SQLException;

    Optional<Receipt> findByPaymentId(
            int paymentId
    ) throws SQLException;
}