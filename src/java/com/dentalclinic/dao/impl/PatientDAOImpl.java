package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.PatientDAO;
import com.dentalclinic.model.Patient;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class PatientDAOImpl implements PatientDAO {

    private static final String INSERT_PATIENT = """
        INSERT INTO patients
        (
            user_id,
            date_of_birth,
            gender,
            address,
            emergency_contact_name,
            emergency_contact_phone,
            medical_notes
        )
        VALUES (?, ?, ?, ?, ?, ?, ?)
        """;

    @Override
public int save(
        Patient patient,
        Connection connection
) throws SQLException {

    try (PreparedStatement statement =
                 connection.prepareStatement(
                         INSERT_PATIENT,
                         Statement.RETURN_GENERATED_KEYS)) {

        statement.setInt(
                1,
                patient.getUserId()
        );

        if (patient.getDateOfBirth() != null) {
            statement.setDate(
                    2,
                    java.sql.Date.valueOf(
                            patient.getDateOfBirth()
                    )
            );
        } else {
            statement.setNull(
                    2,
                    java.sql.Types.DATE
            );
        }

        statement.setString(
                3,
                patient.getGender()
        );

        statement.setString(
                4,
                patient.getAddress()
        );

        statement.setString(
                5,
                patient.getEmergencyContactName()
        );

        statement.setString(
                6,
                patient.getEmergencyContactPhone()
        );

        statement.setString(
                7,
                patient.getMedicalNotes()
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
            "Unable to create patient profile."
    );
}
    
    
    @Override
    public int save(Patient patient) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             INSERT_PATIENT,
                             Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(1, patient.getUserId());

            if (patient.getDateOfBirth() != null) {
                statement.setDate(
                        2,
                        java.sql.Date.valueOf(
                                patient.getDateOfBirth()
                        )
                );
            } else {
                statement.setNull(2, java.sql.Types.DATE);
            }

            statement.setString(3, patient.getGender());
            statement.setString(4, patient.getAddress());
            statement.setString(
                    5,
                    patient.getEmergencyContactName()
            );
            statement.setString(
                    6,
                    patient.getEmergencyContactPhone()
            );
            statement.setString(
                    7,
                    patient.getMedicalNotes()
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
                "Unable to create patient profile."
        );
    }
}