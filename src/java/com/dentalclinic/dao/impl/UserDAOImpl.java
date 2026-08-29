package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.UserDAO;
import com.dentalclinic.model.User;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Optional;

public class UserDAOImpl implements UserDAO {

    private static final String FIND_BY_USERNAME = """
        SELECT
            u.user_id,
            u.role_id,
            r.role_name,
            u.username,
            u.email,
            u.password_hash,
            u.first_name,
            u.last_name,
            u.phone,
            u.is_active
        FROM users u
        INNER JOIN roles r ON u.role_id = r.role_id
        WHERE u.username = ?
        """;

    private static final String FIND_BY_EMAIL = """
        SELECT
            u.user_id,
            u.role_id,
            r.role_name,
            u.username,
            u.email,
            u.password_hash,
            u.first_name,
            u.last_name,
            u.phone,
            u.is_active
        FROM users u
        INNER JOIN roles r ON u.role_id = r.role_id
        WHERE u.email = ?
        """;

    private static final String EXISTS_USERNAME =
            "SELECT COUNT(*) FROM users WHERE username = ?";

    private static final String EXISTS_EMAIL =
            "SELECT COUNT(*) FROM users WHERE email = ?";

    private static final String INSERT_USER = """
        INSERT INTO users
        (
            role_id,
            username,
            email,
            password_hash,
            first_name,
            last_name,
            phone,
            is_active
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;

    @Override
    public Optional<User> findByUsername(String username)
            throws SQLException {

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(FIND_BY_USERNAME)) {

            statement.setString(1, username);

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {
                    return Optional.of(mapUser(resultSet));
                }
            }
        }

        return Optional.empty();
    }

    @Override
    public Optional<User> findByEmail(String email)
            throws SQLException {

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(FIND_BY_EMAIL)) {

            statement.setString(1, email);

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {
                    return Optional.of(mapUser(resultSet));
                }
            }
        }

        return Optional.empty();
    }

    @Override
    public boolean existsByUsername(String username)
            throws SQLException {

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(EXISTS_USERNAME)) {

            statement.setString(1, username);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() && resultSet.getInt(1) > 0;
            }
        }
    }

    @Override
    public boolean existsByEmail(String email)
            throws SQLException {

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(EXISTS_EMAIL)) {

            statement.setString(1, email);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() && resultSet.getInt(1) > 0;
            }
        }
    }

    @Override
    public int save(User user) throws SQLException {

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             INSERT_USER,
                             Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(1, user.getRoleId());
            statement.setString(2, user.getUsername());
            statement.setString(3, user.getEmail());
            statement.setString(4, user.getPasswordHash());
            statement.setString(5, user.getFirstName());
            statement.setString(6, user.getLastName());
            statement.setString(7, user.getPhone());
            statement.setBoolean(8, user.isActive());

            statement.executeUpdate();

            try (ResultSet keys = statement.getGeneratedKeys()) {

                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }

        throw new SQLException("Unable to create user.");
    }
    
    @Override
public int save(
        User user,
        Connection connection
) throws SQLException {

    try (PreparedStatement statement =
                 connection.prepareStatement(
                         INSERT_USER,
                         Statement.RETURN_GENERATED_KEYS)) {

        statement.setInt(
                1,
                user.getRoleId()
        );

        statement.setString(
                2,
                user.getUsername()
        );

        statement.setString(
                3,
                user.getEmail()
        );

        statement.setString(
                4,
                user.getPasswordHash()
        );

        statement.setString(
                5,
                user.getFirstName()
        );

        statement.setString(
                6,
                user.getLastName()
        );

        statement.setString(
                7,
                user.getPhone()
        );

        statement.setBoolean(
                8,
                user.isActive()
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
            "Unable to create user."
    );
}

    private User mapUser(ResultSet resultSet)
            throws SQLException {

        User user = new User();

        user.setUserId(resultSet.getInt("user_id"));
        user.setRoleId(resultSet.getInt("role_id"));
        user.setRoleName(resultSet.getString("role_name"));
        user.setUsername(resultSet.getString("username"));
        user.setEmail(resultSet.getString("email"));
        user.setPasswordHash(resultSet.getString("password_hash"));
        user.setFirstName(resultSet.getString("first_name"));
        user.setLastName(resultSet.getString("last_name"));
        user.setPhone(resultSet.getString("phone"));
        user.setActive(resultSet.getBoolean("is_active"));

        return user;
    }
}