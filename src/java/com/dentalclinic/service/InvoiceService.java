package com.dentalclinic.service;

import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.model.Invoice;
import com.dentalclinic.model.InvoiceItem;

import java.sql.SQLException;
import java.util.List;

public interface InvoiceService {

    int generateInvoice(
            int visitId,
            int cashierUserId
    ) throws SQLException, ValidationException;

    Invoice getInvoice(
            int invoiceId
    ) throws SQLException, ValidationException;

    List<InvoiceItem> getInvoiceItems(
            int invoiceId
    ) throws SQLException;

    List<Invoice> getInvoiceHistory()
            throws SQLException;

    void voidInvoice(
            int invoiceId,
            int cashierUserId,
            String reason
    ) throws SQLException, ValidationException;
}