package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.DoctorDAO;
import com.dentalclinic.model.Doctor;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class DoctorDAOImpl implements DoctorDAO {

    private static final String FIND_ALL = """
        SELECT doctor_id, first_name, last_name, specialization, registration_no, phone, email, is_active
        FROM doctors
        ORDER BY first_name, last_name
        """;

    private static final String FIND_ACTIVE_DOCTORS = """
        SELECT doctor_id, first_name, last_name, specialization, registration_no, phone, email, is_active
        FROM doctors
        WHERE is_active = TRUE
        ORDER BY first_name, last_name
        """;

    private static final String FIND_BY_SERVICE = """
        SELECT DISTINCT d.doctor_id, d.first_name, d.last_name, d.specialization, d.registration_no, d.phone, d.email, d.is_active
        FROM doctors d
        INNER JOIN doctor_services ds ON d.doctor_id = ds.doctor_id
        WHERE ds.service_id = ? AND d.is_active = TRUE
        ORDER BY d.first_name, d.last_name
        """;

    private static final String FIND_BY_ID = """
        SELECT doctor_id, first_name, last_name, specialization, registration_no, phone, email, is_active
        FROM doctors
        WHERE doctor_id = ?
        """;

    private static final String CREATE_DOCTOR = """
        INSERT INTO doctors (first_name, last_name, specialization, registration_no, phone, email, is_active)
        VALUES (?, ?, ?, ?, ?, ?, ?)
        """;

    private static final String UPDATE_DOCTOR = """
        UPDATE doctors
        SET first_name = ?, last_name = ?, specialization = ?, registration_no = ?, phone = ?, email = ?
        WHERE doctor_id = ?
        """;

    private static final String UPDATE_STATUS = """
        UPDATE doctors SET is_active = ? WHERE doctor_id = ?
        """;

    private static final String FIND_ASSIGNED_SERVICES = """
        SELECT service_id FROM doctor_services WHERE doctor_id = ?
        """;

    private static final String DELETE_ASSIGNED_SERVICES = """
        DELETE FROM doctor_services WHERE doctor_id = ?
        """;

    private static final String INSERT_ASSIGNED_SERVICE = """
        INSERT INTO doctor_services (doctor_id, service_id) VALUES (?, ?)
        """;

    @Override
    public List<Doctor> findAll() throws SQLException {
        List<Doctor> doctors = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(FIND_ALL);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                doctors.add(mapDoctor(resultSet));
            }
        }
        return doctors;
    }

    @Override
    public List<Doctor> findActiveDoctors() throws SQLException {
        List<Doctor> doctors = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(FIND_ACTIVE_DOCTORS);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                doctors.add(mapDoctor(resultSet));
            }
        }
        return doctors;
    }

    @Override
    public List<Doctor> findByServiceId(int serviceId) throws SQLException {
        List<Doctor> doctors = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(FIND_BY_SERVICE)) {
            statement.setInt(1, serviceId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    doctors.add(mapDoctor(resultSet));
                }
            }
        }
        return doctors;
    }

    @Override
    public Optional<Doctor> findById(int doctorId) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(FIND_BY_ID)) {
            statement.setInt(1, doctorId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return Optional.of(mapDoctor(resultSet));
                }
            }
        }
        return Optional.empty();
    }

    @Override
    public int create(Doctor doctor) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(CREATE_DOCTOR, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, doctor.getFirstName());
            statement.setString(2, doctor.getLastName());
            statement.setString(3, doctor.getSpecialization());
            statement.setString(4, doctor.getRegistrationNo());
            statement.setString(5, doctor.getPhone());
            statement.setString(6, doctor.getEmail());
            statement.setBoolean(7, doctor.isActive());

            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        throw new SQLException("Failed to create doctor record.");
    }

    @Override
    public boolean update(Doctor doctor) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_DOCTOR)) {
            statement.setString(1, doctor.getFirstName());
            statement.setString(2, doctor.getLastName());
            statement.setString(3, doctor.getSpecialization());
            statement.setString(4, doctor.getRegistrationNo());
            statement.setString(5, doctor.getPhone());
            statement.setString(6, doctor.getEmail());
            statement.setInt(7, doctor.getDoctorId());

            return statement.executeUpdate() > 0;
        }
    }

    @Override
    public boolean updateStatus(int doctorId, boolean active) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_STATUS)) {
            statement.setBoolean(1, active);
            statement.setInt(2, doctorId);
            return statement.executeUpdate() > 0;
        }
    }

    @Override
    public List<Integer> findAssignedServiceIds(int doctorId) throws SQLException {
        List<Integer> serviceIds = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(FIND_ASSIGNED_SERVICES)) {
            statement.setInt(1, doctorId);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    serviceIds.add(rs.getInt("service_id"));
                }
            }
        }
        return serviceIds;
    }

    @Override
    public boolean assignServices(int doctorId, List<Integer> serviceIds) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection()) {
            connection.setAutoCommit(false);
            try {
                try (PreparedStatement delStmt = connection.prepareStatement(DELETE_ASSIGNED_SERVICES)) {
                    delStmt.setInt(1, doctorId);
                    delStmt.executeUpdate();
                }

                if (serviceIds != null && !serviceIds.isEmpty()) {
                    try (PreparedStatement insStmt = connection.prepareStatement(INSERT_ASSIGNED_SERVICE)) {
                        for (int serviceId : serviceIds) {
                            insStmt.setInt(1, doctorId);
                            insStmt.setInt(2, serviceId);
                            insStmt.addBatch();
                        }
                        insStmt.executeBatch();
                    }
                }

                connection.commit();
                return true;
            } catch (SQLException e) {
                connection.rollback();
                throw e;
            } finally {
                connection.setAutoCommit(true);
            }
        }
    }

    private Doctor mapDoctor(ResultSet resultSet) throws SQLException {
        Doctor doctor = new Doctor();
        doctor.setDoctorId(resultSet.getInt("doctor_id"));
        doctor.setFirstName(resultSet.getString("first_name"));
        doctor.setLastName(resultSet.getString("last_name"));
        doctor.setSpecialization(resultSet.getString("specialization"));
        doctor.setRegistrationNo(resultSet.getString("registration_no"));
        doctor.setPhone(resultSet.getString("phone"));
        doctor.setEmail(resultSet.getString("email"));
        doctor.setActive(resultSet.getBoolean("is_active"));
        return doctor;
    }
}