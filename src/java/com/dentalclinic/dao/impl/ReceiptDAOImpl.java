package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.ReceiptDAO;
import com.dentalclinic.model.Receipt;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Optional;

public class ReceiptDAOImpl
        implements ReceiptDAO {

    private static final String INSERT_RECEIPT = """
        INSERT INTO receipts
        (
            payment_id,
            receipt_number,
            issued_at,
            issued_by_user_id
        )
        VALUES (?, ?, ?, ?)
        """;

    private static final String FIND_BY_ID = """
        SELECT
            receipt_id,
            payment_id,
            receipt_number,
            issued_at,
            issued_by_user_id,
            created_at
        FROM receipts
        WHERE receipt_id = ?
        """;

    private static final String FIND_BY_PAYMENT_ID = """
        SELECT
            receipt_id,
            payment_id,
            receipt_number,
            issued_at,
            issued_by_user_id,
            created_at
        FROM receipts
        WHERE payment_id = ?
        """;

    @Override
    public int create(
            Receipt receipt
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             INSERT_RECEIPT,
                             java.sql.Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(
                    1,
                    receipt.getPaymentId()
            );

            statement.setString(
                    2,
                    receipt.getReceiptNumber()
            );

            if (receipt.getIssuedAt() != null) {

                statement.setTimestamp(
                        3,
                        Timestamp.valueOf(
                                receipt.getIssuedAt()
                        )
                );

            } else {

                statement.setTimestamp(
                        3,
                        new Timestamp(
                                System.currentTimeMillis()
                        )
                );
            }

            statement.setInt(
                    4,
                    receipt.getIssuedByUserId()
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
                "Unable to create receipt."
        );
    }

    @Override
    public Optional<Receipt> findById(
            int receiptId
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_BY_ID)) {

            statement.setInt(
                    1,
                    receiptId
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {

                    return Optional.of(
                            mapReceipt(resultSet)
                    );
                }
            }
        }

        return Optional.empty();
    }

    @Override
    public Optional<Receipt>
    findByPaymentId(
            int paymentId
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_BY_PAYMENT_ID)) {

            statement.setInt(
                    1,
                    paymentId
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {

                    return Optional.of(
                            mapReceipt(resultSet)
                    );
                }
            }
        }

        return Optional.empty();
    }

    private Receipt mapReceipt(
            ResultSet resultSet
    ) throws SQLException {

        Receipt receipt =
                new Receipt();

        receipt.setReceiptId(
                resultSet.getInt(
                        "receipt_id"
                )
        );

        receipt.setPaymentId(
                resultSet.getInt(
                        "payment_id"
                )
        );

        receipt.setReceiptNumber(
                resultSet.getString(
                        "receipt_number"
                )
        );

        Timestamp issuedAt =
                resultSet.getTimestamp(
                        "issued_at"
                );

        if (issuedAt != null) {

            receipt.setIssuedAt(
                    issuedAt.toLocalDateTime()
            );
        }

        receipt.setIssuedByUserId(
                resultSet.getInt(
                        "issued_by_user_id"
                )
        );

        Timestamp createdAt =
                resultSet.getTimestamp(
                        "created_at"
                );

        if (createdAt != null) {

            receipt.setCreatedAt(
                    createdAt.toLocalDateTime()
            );
        }

        return receipt;
    }
}