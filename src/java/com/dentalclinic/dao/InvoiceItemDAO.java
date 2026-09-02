package com.dentalclinic.dao;

import com.dentalclinic.model.InvoiceItem;

import java.sql.SQLException;
import java.util.List;

public interface InvoiceItemDAO {

    int create(
            InvoiceItem item
    ) throws SQLException;

    List<InvoiceItem> findByInvoiceId(
            int invoiceId
    ) throws SQLException;
}