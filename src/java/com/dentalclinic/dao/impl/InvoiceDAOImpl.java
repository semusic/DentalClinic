package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.InvoiceDAO;
import com.dentalclinic.model.Invoice;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class InvoiceDAOImpl
        implements InvoiceDAO {

    private static final String INSERT_INVOICE = """
        INSERT INTO invoices
        (
            visit_id,
            patient_id,
            invoice_number,
            subtotal,
            discount_amount,
            tax_amount,
            total_amount,
            invoice_status,
            due_date,
            created_by_user_id
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, 'UNPAID', ?, ?)
        """;

    private static final String FIND_BY_ID = """
        SELECT
            invoice_id,
            visit_id,
            patient_id,
            invoice_number,
            subtotal,
            discount_amount,
            tax_amount,
            total_amount,
            invoice_status,
            issued_at,
            due_date,
            created_by_user_id,
            voided_at,
            voided_by_user_id,
            void_reason,
            qr_token,
            qr_token_hash,
            qr_generated_at,                                 
            created_at,
            updated_at
        FROM invoices
        WHERE invoice_id = ?
        """;

    private static final String FIND_BY_VISIT_ID = """
        SELECT
            invoice_id,
            visit_id,
            patient_id,
            invoice_number,
            subtotal,
            discount_amount,
            tax_amount,
            total_amount,
            invoice_status,
            issued_at,
            due_date,
            created_by_user_id,
            voided_at,
            voided_by_user_id,
            void_reason,
            qr_token,
            qr_token_hash,
            qr_generated_at,                                                   
            created_at,
            updated_at
        FROM invoices
        WHERE visit_id = ?
        """;

    private static final String FIND_UNPAID = """
        SELECT
            invoice_id,
            visit_id,
            patient_id,
            invoice_number,
            subtotal,
            discount_amount,
            tax_amount,
            total_amount,
            invoice_status,
            issued_at,
            due_date,
            created_by_user_id,
            voided_at,
            voided_by_user_id,
            void_reason,
            qr_token,
            qr_token_hash,
            qr_generated_at,
            created_at,
            updated_at
        FROM invoices
        WHERE invoice_status IN (
            'UNPAID',
            'PARTIALLY_PAID'
        )
        ORDER BY issued_at ASC
        """;

    private static final String FIND_ALL = """
        SELECT
            invoice_id,
            visit_id,
            patient_id,
            invoice_number,
            subtotal,
            discount_amount,
            tax_amount,
            total_amount,
            invoice_status,
            issued_at,
            due_date,
            created_by_user_id,
            voided_at,
            voided_by_user_id,
            void_reason,
            qr_token,
            qr_token_hash,
            qr_generated_at,                                           
            created_at,
            updated_at
        FROM invoices
        ORDER BY issued_at DESC
        """;

    /*
     * Only an UNPAID invoice can be voided.
     *
     * This protects invoices that already have a
     * financial transaction associated with them.
     */
    private static final String VOID_INVOICE = """
        UPDATE invoices
        SET
            invoice_status = 'VOID',
            voided_at = CURRENT_TIMESTAMP,
            voided_by_user_id = ?,
            void_reason = ?
        WHERE invoice_id = ?
          AND invoice_status = 'UNPAID'
        """;
    
    private static final String SAVE_QR_TOKEN = """
    UPDATE invoices
    SET
        qr_token = ?,
        qr_token_hash = ?,
        qr_generated_at = CURRENT_TIMESTAMP
    WHERE invoice_id = ?
    """;

    private static final String FIND_BY_QR_TOKEN_HASH = """
        SELECT
            invoice_id,
            visit_id,
            patient_id,
            invoice_number,
            subtotal,
            discount_amount,
            tax_amount,
            total_amount,
            invoice_status,
            issued_at,
            due_date,
            created_by_user_id,
            voided_at,
            voided_by_user_id,
            void_reason,
            qr_token,
            qr_token_hash,
            qr_generated_at,
            created_at,
            updated_at
        FROM invoices
        WHERE qr_token_hash = ?
        """;

    @Override
    public int create(
            Invoice invoice
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             INSERT_INVOICE,
                             java.sql.Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(
                    1,
                    invoice.getVisitId()
            );

            statement.setInt(
                    2,
                    invoice.getPatientId()
            );

            statement.setString(
                    3,
                    invoice.getInvoiceNumber()
            );

            statement.setBigDecimal(
                    4,
                    invoice.getSubtotal()
            );

            statement.setBigDecimal(
                    5,
                    invoice.getDiscountAmount()
            );

            statement.setBigDecimal(
                    6,
                    invoice.getTaxAmount()
            );

            statement.setBigDecimal(
                    7,
                    invoice.getTotalAmount()
            );

            if (invoice.getDueDate() != null) {

                statement.setDate(
                        8,
                        java.sql.Date.valueOf(
                                invoice.getDueDate()
                        )
                );

            } else {

                statement.setNull(
                        8,
                        java.sql.Types.DATE
                );
            }

            statement.setInt(
                    9,
                    invoice.getCreatedByUserId()
            );

            statement.executeUpdate();

            try (ResultSet keys =
                         statement.getGeneratedKeys()) {

                if (keys.next()) {

                    return keys.getInt(1);
                }
            }
        }

        throw new SQLException(
                "Unable to create invoice."
        );
    }

    @Override
    public Optional<Invoice> findById(
            int invoiceId
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_BY_ID)) {

            statement.setInt(
                    1,
                    invoiceId
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {

                    return Optional.of(
                            mapInvoice(resultSet)
                    );
                }
            }
        }

        return Optional.empty();
    }

    @Override
    public Optional<Invoice>
    findByVisitId(
            int visitId
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_BY_VISIT_ID)) {

            statement.setInt(
                    1,
                    visitId
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {

                    return Optional.of(
                            mapInvoice(resultSet)
                    );
                }
            }
        }

        return Optional.empty();
    }

    @Override
    public List<Invoice>
    findUnpaidInvoices()
            throws SQLException {

        List<Invoice> invoices =
                new ArrayList<>();

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_UNPAID);
             ResultSet resultSet =
                     statement.executeQuery()) {

            while (resultSet.next()) {

                invoices.add(
                        mapInvoice(resultSet)
                );
            }
        }

        return invoices;
    }

    @Override
    public List<Invoice>
    findAll()
            throws SQLException {

        List<Invoice> invoices =
                new ArrayList<>();

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_ALL);
             ResultSet resultSet =
                     statement.executeQuery()) {

            while (resultSet.next()) {

                invoices.add(
                        mapInvoice(resultSet)
                );
            }
        }

        return invoices;
    }

    @Override
    public boolean voidInvoice(
            int invoiceId,
            int voidedByUserId,
            String voidReason
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             VOID_INVOICE)) {

            statement.setInt(
                    1,
                    voidedByUserId
            );

            statement.setString(
                    2,
                    voidReason
            );

            statement.setInt(
                    3,
                    invoiceId
            );

            return statement.executeUpdate() > 0;
        }
    }

    private Invoice mapInvoice(
            ResultSet resultSet
    ) throws SQLException {

        Invoice invoice =
                new Invoice();

        invoice.setInvoiceId(
                resultSet.getInt(
                        "invoice_id"
                )
        );

        invoice.setVisitId(
                resultSet.getInt(
                        "visit_id"
                )
        );

        invoice.setPatientId(
                resultSet.getInt(
                        "patient_id"
                )
        );

        invoice.setInvoiceNumber(
                resultSet.getString(
                        "invoice_number"
                )
        );

        invoice.setSubtotal(
                resultSet.getBigDecimal(
                        "subtotal"
                )
        );

        invoice.setDiscountAmount(
                resultSet.getBigDecimal(
                        "discount_amount"
                )
        );

        invoice.setTaxAmount(
                resultSet.getBigDecimal(
                        "tax_amount"
                )
        );

        invoice.setTotalAmount(
                resultSet.getBigDecimal(
                        "total_amount"
                )
        );

        invoice.setInvoiceStatus(
                resultSet.getString(
                        "invoice_status"
                )
        );

        Timestamp issuedAt =
                resultSet.getTimestamp(
                        "issued_at"
                );

        if (issuedAt != null) {

            invoice.setIssuedAt(
                    issuedAt.toLocalDateTime()
            );
        }

        java.sql.Date dueDate =
                resultSet.getDate(
                        "due_date"
                );

        if (dueDate != null) {

            invoice.setDueDate(
                    dueDate.toLocalDate()
            );
        }

        invoice.setCreatedByUserId(
                resultSet.getInt(
                        "created_by_user_id"
                )
        );

        Timestamp voidedAt =
                resultSet.getTimestamp(
                        "voided_at"
                );

        if (voidedAt != null) {

            invoice.setVoidedAt(
                    voidedAt.toLocalDateTime()
            );
        }

        int voidedByUserId =
                resultSet.getInt(
                        "voided_by_user_id"
                );

        if (resultSet.wasNull()) {

            invoice.setVoidedByUserId(
                    null
            );

        } else {

            invoice.setVoidedByUserId(
                    voidedByUserId
            );
        }

        invoice.setVoidReason(
                resultSet.getString(
                        "void_reason"
                )
        );
        
        invoice.setQrToken(
        resultSet.getString(
                "qr_token"
        )
        );

        invoice.setQrTokenHash(
                resultSet.getString(
                        "qr_token_hash"
                )
            );

        Timestamp qrGeneratedAt =
                resultSet.getTimestamp(
                        "qr_generated_at"
                );

        if (qrGeneratedAt != null) {

            invoice.setQrGeneratedAt(
                    qrGeneratedAt.toLocalDateTime()
            );
        }

        Timestamp createdAt =
                resultSet.getTimestamp(
                        "created_at"
                );

        if (createdAt != null) {

            invoice.setCreatedAt(
                    createdAt.toLocalDateTime()
            );
        }

        Timestamp updatedAt =
                resultSet.getTimestamp(
                        "updated_at"
                );

        if (updatedAt != null) {

            invoice.setUpdatedAt(
                    updatedAt.toLocalDateTime()
            );
        }

        return invoice;
    }
    
            @Override
         public boolean saveQrToken(
                 int invoiceId,
                 String qrToken,
                 String qrTokenHash
         ) throws SQLException {

             try (Connection connection =
                          DatabaseConnection.getConnection();
                  PreparedStatement statement =
                          connection.prepareStatement(
                                  SAVE_QR_TOKEN)) {

                 statement.setString(
                         1,
                         qrToken
                 );

                 statement.setString(
                         2,
                         qrTokenHash
                 );

                 statement.setInt(
                         3,
                         invoiceId
                 );

                 return statement.executeUpdate() > 0;
             }
         }

        @Override
        public Optional<Invoice>
        findByQrTokenHash(
                String qrTokenHash
        ) throws SQLException {

            try (Connection connection =
                         DatabaseConnection.getConnection();
                 PreparedStatement statement =
                         connection.prepareStatement(
                                 FIND_BY_QR_TOKEN_HASH)) {

                statement.setString(
                        1,
                        qrTokenHash
                );

                try (ResultSet resultSet =
                             statement.executeQuery()) {

                    if (resultSet.next()) {

                        return Optional.of(
                                mapInvoice(resultSet)
                        );
                    }
                }
            }

            return Optional.empty();
        }
    
}
