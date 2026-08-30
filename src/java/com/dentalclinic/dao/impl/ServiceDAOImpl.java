package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.ServiceDAO;
import com.dentalclinic.model.Service;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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

    @Override
    public List<Service> findAllActive()
            throws SQLException {

        List<Service> services = new ArrayList<>();

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_ALL_ACTIVE);
             ResultSet resultSet =
                     statement.executeQuery()) {

            while (resultSet.next()) {
                services.add(mapService(resultSet));
            }
        }

        return services;
    }

    @Override
    public Optional<Service> findById(int serviceId)
            throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_BY_ID)) {

            statement.setInt(1, serviceId);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {
                    return Optional.of(
                            mapService(resultSet)
                    );
                }
            }
        }

        return Optional.empty();
    }

    private Service mapService(ResultSet resultSet)
            throws SQLException {

        Service service = new Service();

        service.setServiceId(
                resultSet.getInt("service_id"));

        service.setCategoryId(
                resultSet.getInt("category_id"));

        service.setCategoryName(
                resultSet.getString("category_name"));

        service.setServiceName(
                resultSet.getString("service_name"));

        service.setDescription(
                resultSet.getString("description"));

        service.setDurationMinutes(
                resultSet.getInt("duration_minutes"));

        service.setStandardPrice(
                resultSet.getBigDecimal("standard_price"));

        service.setActive(
                resultSet.getBoolean("is_active"));

        return service;
    }
}