package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.PaymentDAO;
import com.dentalclinic.model.Payment;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class PaymentDAOImpl
        implements PaymentDAO {

    private static final String INSERT_PAYMENT = """
        INSERT INTO payments
        (
            invoice_id,
            payment_reference,
            amount,
            payment_method,
            payment_status,
            transaction_date,
            processed_by_user_id,
            notes
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;

    private static final String FIND_BY_ID = """
        SELECT
            payment_id,
            invoice_id,
            payment_reference,
            amount,
            payment_method,
            payment_status,
            transaction_date,
            processed_by_user_id,
            notes,
            created_at
        FROM payments
        WHERE payment_id = ?
        """;

    private static final String FIND_BY_INVOICE_ID = """
        SELECT
            payment_id,
            invoice_id,
            payment_reference,
            amount,
            payment_method,
            payment_status,
            transaction_date,
            processed_by_user_id,
            notes,
            created_at
        FROM payments
        WHERE invoice_id = ?
        ORDER BY transaction_date DESC
        """;

    private static final String FIND_LATEST_COMPLETED = """
        SELECT
            payment_id,
            invoice_id,
            payment_reference,
            amount,
            payment_method,
            payment_status,
            transaction_date,
            processed_by_user_id,
            notes,
            created_at
        FROM payments
        WHERE invoice_id = ?
          AND payment_status = 'COMPLETED'
        ORDER BY transaction_date DESC
        LIMIT 1
        """;

    @Override
    public int create(
            Payment payment
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             INSERT_PAYMENT,
                             java.sql.Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(
                    1,
                    payment.getInvoiceId()
            );

            statement.setString(
                    2,
                    payment.getPaymentReference()
            );

            statement.setBigDecimal(
                    3,
                    payment.getAmount()
            );

            statement.setString(
                    4,
                    payment.getPaymentMethod()
            );

            statement.setString(
                    5,
                    payment.getPaymentStatus()
            );

            if (payment.getTransactionDate() != null) {

                statement.setTimestamp(
                        6,
                        Timestamp.valueOf(
                                payment.getTransactionDate()
                        )
                );

            } else {

                statement.setTimestamp(
                        6,
                        new Timestamp(
                                System.currentTimeMillis()
                        )
                );
            }

            statement.setInt(
                    7,
                    payment.getProcessedByUserId()
            );

            statement.setString(
                    8,
                    payment.getNotes()
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
                "Unable to create payment."
        );
    }

    @Override
    public Optional<Payment> findById(
            int paymentId
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_BY_ID)) {

            statement.setInt(
                    1,
                    paymentId
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {

                    return Optional.of(
                            mapPayment(resultSet)
                    );
                }
            }
        }

        return Optional.empty();
    }

    @Override
    public List<Payment> findByInvoiceId(
            int invoiceId
    ) throws SQLException {

        List<Payment> payments =
                new ArrayList<>();

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_BY_INVOICE_ID)) {

            statement.setInt(
                    1,
                    invoiceId
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {

                    payments.add(
                            mapPayment(resultSet)
                    );
                }
            }
        }

        return payments;
    }

    @Override
    public Optional<Payment>
    findLatestCompletedByInvoiceId(
            int invoiceId
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_LATEST_COMPLETED)) {

            statement.setInt(
                    1,
                    invoiceId
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {

                    return Optional.of(
                            mapPayment(resultSet)
                    );
                }
            }
        }

        return Optional.empty();
    }

    private Payment mapPayment(
            ResultSet resultSet
    ) throws SQLException {

        Payment payment =
                new Payment();

        payment.setPaymentId(
                resultSet.getInt(
                        "payment_id"
                )
        );

        payment.setInvoiceId(
                resultSet.getInt(
                        "invoice_id"
                )
        );

        payment.setPaymentReference(
                resultSet.getString(
                        "payment_reference"
                )
        );

        payment.setAmount(
                resultSet.getBigDecimal(
                        "amount"
                )
        );

        payment.setPaymentMethod(
                resultSet.getString(
                        "payment_method"
                )
        );

        payment.setPaymentStatus(
                resultSet.getString(
                        "payment_status"
                )
        );

        Timestamp transactionDate =
                resultSet.getTimestamp(
                        "transaction_date"
                );

        if (transactionDate != null) {

            payment.setTransactionDate(
                    transactionDate.toLocalDateTime()
            );
        }

        payment.setProcessedByUserId(
                resultSet.getInt(
                        "processed_by_user_id"
                )
        );

        payment.setNotes(
                resultSet.getString(
                        "notes"
                )
        );

        Timestamp createdAt =
                resultSet.getTimestamp(
                        "created_at"
                );

        if (createdAt != null) {

            payment.setCreatedAt(
                    createdAt.toLocalDateTime()
            );
        }

        return payment;
    }
}