package com.dentalclinic.dao;

import com.dentalclinic.model.Invoice;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface InvoiceDAO {

    int create(
            Invoice invoice
    ) throws SQLException;

    Optional<Invoice> findById(
            int invoiceId
    ) throws SQLException;

    Optional<Invoice> findByVisitId(
            int visitId
    ) throws SQLException;

    List<Invoice> findUnpaidInvoices()
            throws SQLException;

    List<Invoice> findAll()
            throws SQLException;

    boolean voidInvoice(
            int invoiceId,
            int voidedByUserId,
            String voidReason
    ) throws SQLException;
}