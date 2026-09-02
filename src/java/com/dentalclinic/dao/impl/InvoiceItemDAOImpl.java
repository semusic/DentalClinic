package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.InvoiceItemDAO;
import com.dentalclinic.model.InvoiceItem;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class InvoiceItemDAOImpl
        implements InvoiceItemDAO {

    private static final String INSERT_ITEM = """
        INSERT INTO invoice_items
        (
            invoice_id,
            service_id,
            item_description,
            quantity,
            unit_price,
            line_total
        )
        VALUES (?, ?, ?, ?, ?, ?)
        """;

    private static final String FIND_BY_INVOICE_ID = """
        SELECT
            invoice_item_id,
            invoice_id,
            service_id,
            item_description,
            quantity,
            unit_price,
            line_total,
            created_at
        FROM invoice_items
        WHERE invoice_id = ?
        ORDER BY invoice_item_id ASC
        """;

    @Override
    public int create(
            InvoiceItem item
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             INSERT_ITEM,
                             java.sql.Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(
                    1,
                    item.getInvoiceId()
            );

            if (item.getServiceId() != null) {

                statement.setInt(
                        2,
                        item.getServiceId()
                );

            } else {

                statement.setNull(
                        2,
                        java.sql.Types.INTEGER
                );
            }

            statement.setString(
                    3,
                    item.getItemDescription()
            );

            statement.setInt(
                    4,
                    item.getQuantity()
            );

            statement.setBigDecimal(
                    5,
                    item.getUnitPrice()
            );

            statement.setBigDecimal(
                    6,
                    item.getLineTotal()
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
                "Unable to create invoice item."
        );
    }

    @Override
    public List<InvoiceItem> findByInvoiceId(
            int invoiceId
    ) throws SQLException {

        List<InvoiceItem> items =
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

                    items.add(
                            mapInvoiceItem(
                                    resultSet
                            )
                    );
                }
            }
        }

        return items;
    }

    private InvoiceItem mapInvoiceItem(
            ResultSet resultSet
    ) throws SQLException {

        InvoiceItem item =
                new InvoiceItem();

        item.setInvoiceItemId(
                resultSet.getInt(
                        "invoice_item_id"
                )
        );

        item.setInvoiceId(
                resultSet.getInt(
                        "invoice_id"
                )
        );

        int serviceId =
                resultSet.getInt(
                        "service_id"
                );

        if (resultSet.wasNull()) {

            item.setServiceId(null);

        } else {

            item.setServiceId(serviceId);
        }

        item.setItemDescription(
                resultSet.getString(
                        "item_description"
                )
        );

        item.setQuantity(
                resultSet.getInt(
                        "quantity"
                )
        );

        item.setUnitPrice(
                resultSet.getBigDecimal(
                        "unit_price"
                )
        );

        item.setLineTotal(
                resultSet.getBigDecimal(
                        "line_total"
                )
        );

        Timestamp createdAt =
                resultSet.getTimestamp(
                        "created_at"
                );

        if (createdAt != null) {

            item.setCreatedAt(
                    createdAt.toLocalDateTime()
            );
        }

        return item;
    }
}