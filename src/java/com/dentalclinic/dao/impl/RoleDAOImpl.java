package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.RoleDAO;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Optional;

public class RoleDAOImpl implements RoleDAO {

    private static final String FIND_ROLE_ID = """
        SELECT role_id
        FROM roles
        WHERE role_name = ?
        """;

    @Override
    public Optional<Integer> findRoleIdByName(
            String roleName
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_ROLE_ID)) {

            statement.setString(
                    1,
                    roleName
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {
                    return Optional.of(
                            resultSet.getInt("role_id")
                    );
                }
            }
        }

        return Optional.empty();
    }
}