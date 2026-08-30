package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.DoctorDAO;
import com.dentalclinic.model.Doctor;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class DoctorDAOImpl implements DoctorDAO {

    private static final String FIND_ACTIVE_DOCTORS = """
        SELECT
            doctor_id,
            first_name,
            last_name,
            specialization,
            registration_no,
            phone,
            email,
            is_active
        FROM doctors
        WHERE is_active = TRUE
        ORDER BY first_name, last_name
        """;

    private static final String FIND_BY_SERVICE = """
        SELECT DISTINCT
            d.doctor_id,
            d.first_name,
            d.last_name,
            d.specialization,
            d.registration_no,
            d.phone,
            d.email,
            d.is_active
        FROM doctors d
        INNER JOIN doctor_services ds
            ON d.doctor_id = ds.doctor_id
        WHERE ds.service_id = ?
          AND d.is_active = TRUE
        ORDER BY d.first_name, d.last_name
        """;

    private static final String FIND_BY_ID = """
        SELECT
            doctor_id,
            first_name,
            last_name,
            specialization,
            registration_no,
            phone,
            email,
            is_active
        FROM doctors
        WHERE doctor_id = ?
          AND is_active = TRUE
        """;

    @Override
    public List<Doctor> findActiveDoctors()
            throws SQLException {

        List<Doctor> doctors = new ArrayList<>();

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_ACTIVE_DOCTORS);
             ResultSet resultSet =
                     statement.executeQuery()) {

            while (resultSet.next()) {
                doctors.add(mapDoctor(resultSet));
            }
        }

        return doctors;
    }

    @Override
    public List<Doctor> findByServiceId(int serviceId)
            throws SQLException {

        List<Doctor> doctors = new ArrayList<>();

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_BY_SERVICE)) {

            statement.setInt(1, serviceId);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {
                    doctors.add(mapDoctor(resultSet));
                }
            }
        }

        return doctors;
    }

    @Override
    public Optional<Doctor> findById(int doctorId)
            throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_BY_ID)) {

            statement.setInt(1, doctorId);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {
                    return Optional.of(
                            mapDoctor(resultSet)
                    );
                }
            }
        }

        return Optional.empty();
    }

    private Doctor mapDoctor(ResultSet resultSet)
            throws SQLException {

        Doctor doctor = new Doctor();

        doctor.setDoctorId(
                resultSet.getInt("doctor_id"));

        doctor.setFirstName(
                resultSet.getString("first_name"));

        doctor.setLastName(
                resultSet.getString("last_name"));

        doctor.setSpecialization(
                resultSet.getString("specialization"));

        doctor.setRegistrationNo(
                resultSet.getString("registration_no"));

        doctor.setPhone(
                resultSet.getString("phone"));

        doctor.setEmail(
                resultSet.getString("email"));

        doctor.setActive(
                resultSet.getBoolean("is_active"));

        return doctor;
    }
}