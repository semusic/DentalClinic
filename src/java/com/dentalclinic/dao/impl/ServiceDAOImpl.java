package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.ServiceDAO;
import com.dentalclinic.model.Service;
import com.dentalclinic.model.ServiceCategory;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ServiceDAOImpl implements ServiceDAO {

    private static final String FIND_ALL_ACTIVE = """
        SELECT
            s.service_id,
            s.category_id,
            c.category_name,
            s.service_name,
            s.description,
            s.duration_minutes,
            s.standard_price,
            s.is_active
        FROM services s
        INNER JOIN service_categories c
            ON s.category_id = c.category_id
        WHERE s.is_active = TRUE
        ORDER BY c.category_name, s.service_name
        """;

    private static final String FIND_ALL = """
        SELECT
            s.service_id,
            s.category_id,
            c.category_name,
            s.service_name,
            s.description,
            s.duration_minutes,
            s.standard_price,
            s.is_active
        FROM services s
        INNER JOIN service_categories c
            ON s.category_id = c.category_id
        ORDER BY c.category_name, s.service_name
        """;

    private static final String FIND_BY_ID = """
        SELECT
            s.service_id,
            s.category_id,
            c.category_name,
            s.service_name,
            s.description,
            s.duration_minutes,
            s.standard_price,
            s.is_active
        FROM services s
        INNER JOIN service_categories c
            ON s.category_id = c.category_id
        WHERE s.service_id = ?
        """;

    private static final String FIND_ALL_CATEGORIES = """
        SELECT category_id, category_name, description
        FROM service_categories
        ORDER BY category_name
        """;

    private static final String INSERT_SERVICE = """
        INSERT INTO services (category_id, service_name, description, duration_minutes, standard_price, is_active)
        VALUES (?, ?, ?, ?, ?, ?)
        """;

    private static final String UPDATE_SERVICE = """
        UPDATE services
        SET category_id = ?, service_name = ?, description = ?, duration_minutes = ?, standard_price = ?, is_active = ?
        WHERE service_id = ?
        """;

    private static final String UPDATE_STATUS = """
        UPDATE services
        SET is_active = ?
        WHERE service_id = ?
        """;

    @Override
    public List<Service> findAllActive() throws SQLException {
        List<Service> services = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(FIND_ALL_ACTIVE);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                services.add(mapService(resultSet));
            }
        }
        return services;
    }

    @Override
    public List<Service> findAll() throws SQLException {
        List<Service> services = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(FIND_ALL);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                services.add(mapService(resultSet));
            }
        }
        return services;
    }

    @Override
    public Optional<Service> findById(int serviceId) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(FIND_BY_ID)) {
            statement.setInt(1, serviceId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return Optional.of(mapService(resultSet));
                }
            }
        }
        return Optional.empty();
    }

    @Override
    public List<ServiceCategory> findAllCategories() throws SQLException {
        List<ServiceCategory> categories = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(FIND_ALL_CATEGORIES);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                ServiceCategory cat = new ServiceCategory();
                cat.setCategoryId(resultSet.getInt("category_id"));
                cat.setCategoryName(resultSet.getString("category_name"));
                cat.setDescription(resultSet.getString("description"));
                categories.add(cat);
            }
        }
        return categories;
    }

    @Override
    public int create(Service service) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(INSERT_SERVICE, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, service.getCategoryId());
            statement.setString(2, service.getServiceName());
            statement.setString(3, service.getDescription());
            statement.setInt(4, service.getDurationMinutes());
            statement.setBigDecimal(5, service.getStandardPrice());
            statement.setBoolean(6, service.isActive());
            statement.executeUpdate();

            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        throw new SQLException("Failed to create new dental service.");
    }

    @Override
    public void update(Service service) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_SERVICE)) {
            statement.setInt(1, service.getCategoryId());
            statement.setString(2, service.getServiceName());
            statement.setString(3, service.getDescription());
            statement.setInt(4, service.getDurationMinutes());
            statement.setBigDecimal(5, service.getStandardPrice());
            statement.setBoolean(6, service.isActive());
            statement.setInt(7, service.getServiceId());
            statement.executeUpdate();
        }
    }

    @Override
    public void updateStatus(int serviceId, boolean active) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_STATUS)) {
            statement.setBoolean(1, active);
            statement.setInt(2, serviceId);
            statement.executeUpdate();
        }
    }

    private Service mapService(ResultSet resultSet) throws SQLException {
        Service service = new Service();
        service.setServiceId(resultSet.getInt("service_id"));
        service.setCategoryId(resultSet.getInt("category_id"));
        service.setCategoryName(resultSet.getString("category_name"));
        service.setServiceName(resultSet.getString("service_name"));
        service.setDescription(resultSet.getString("description"));
        service.setDurationMinutes(resultSet.getInt("duration_minutes"));
        service.setStandardPrice(resultSet.getBigDecimal("standard_price"));
        service.setActive(resultSet.getBoolean("is_active"));
        return service;
    }
}