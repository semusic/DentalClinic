package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.AppointmentStatusDAO;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Optional;

public class AppointmentStatusDAOImpl
        implements AppointmentStatusDAO {

    private static final String FIND_STATUS_ID = """
        SELECT status_id
        FROM appointment_statuses
        WHERE status_code = ?
        """;

    @Override
    public Optional<Integer> findStatusIdByCode(
            String statusCode
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_STATUS_ID)) {

            statement.setString(1, statusCode);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {
                    return Optional.of(
                            resultSet.getInt("status_id")
                    );
                }
            }
        }

        return Optional.empty();
    }
}