package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.VisitMedicationDAO;
import com.dentalclinic.model.VisitMedication;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class VisitMedicationDAOImpl
        implements VisitMedicationDAO {

    private static final String INSERT_MEDICATION = """
        INSERT INTO visit_medications
        (
            visit_id,
            prescribed_by_doctor_id,
            medication_name,
            dosage,
            quantity,
            instructions,
            provided_to_patient
        )
        VALUES (?, ?, ?, ?, ?, ?, ?)
        """;

    private static final String FIND_BY_VISIT_ID = """
        SELECT
            visit_medication_id,
            visit_id,
            prescribed_by_doctor_id,
            medication_name,
            dosage,
            quantity,
            instructions,
            provided_to_patient,
            prescribed_at,
            created_at
        FROM visit_medications
        WHERE visit_id = ?
        ORDER BY prescribed_at ASC,
                 visit_medication_id ASC
        """;

    private static final String MARK_PROVIDED = """
        UPDATE visit_medications
        SET provided_to_patient = TRUE
        WHERE visit_medication_id = ?
        """;

    private static final String DELETE_MEDICATION = """
        DELETE FROM visit_medications
        WHERE visit_medication_id = ?
        """;

    @Override
    public int create(
            VisitMedication medication
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             INSERT_MEDICATION,
                             java.sql.Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(
                    1,
                    medication.getVisitId()
            );

            statement.setInt(
                    2,
                    medication.getPrescribedByDoctorId()
            );

            statement.setString(
                    3,
                    medication.getMedicationName()
            );

            statement.setString(
                    4,
                    medication.getDosage()
            );

            if (medication.getQuantity() != null) {

                statement.setInt(
                        5,
                        medication.getQuantity()
                );

            } else {

                statement.setNull(
                        5,
                        java.sql.Types.INTEGER
                );
            }

            statement.setString(
                    6,
                    medication.getInstructions()
            );

            statement.setBoolean(
                    7,
                    medication.isProvidedToPatient()
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
                "Unable to create visit medication."
        );
    }

    @Override
    public List<VisitMedication> findByVisitId(
            int visitId
    ) throws SQLException {

        List<VisitMedication> medications =
                new ArrayList<>();

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_BY_VISIT_ID)) {

            statement.setInt(
                    1,
                    visitId
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {

                    medications.add(
                            mapMedication(
                                    resultSet
                            )
                    );
                }
            }
        }

        return medications;
    }

    @Override
    public boolean markProvided(
            int visitMedicationId
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             MARK_PROVIDED)) {

            statement.setInt(
                    1,
                    visitMedicationId
            );

            return statement.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(
            int visitMedicationId
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             DELETE_MEDICATION)) {

            statement.setInt(
                    1,
                    visitMedicationId
            );

            return statement.executeUpdate() > 0;
        }
    }

    private VisitMedication mapMedication(
            ResultSet resultSet
    ) throws SQLException {

        VisitMedication medication =
                new VisitMedication();

        medication.setVisitMedicationId(
                resultSet.getInt(
                        "visit_medication_id"
                )
        );

        medication.setVisitId(
                resultSet.getInt(
                        "visit_id"
                )
        );

        medication.setPrescribedByDoctorId(
                resultSet.getInt(
                        "prescribed_by_doctor_id"
                )
        );

        medication.setMedicationName(
                resultSet.getString(
                        "medication_name"
                )
        );

        medication.setDosage(
                resultSet.getString(
                        "dosage"
                )
        );

        int quantity =
                resultSet.getInt(
                        "quantity"
                );

        if (resultSet.wasNull()) {
            medication.setQuantity(null);
        } else {
            medication.setQuantity(quantity);
        }

        medication.setInstructions(
                resultSet.getString(
                        "instructions"
                )
        );

        medication.setProvidedToPatient(
                resultSet.getBoolean(
                        "provided_to_patient"
                )
        );

        Timestamp prescribedAt =
                resultSet.getTimestamp(
                        "prescribed_at"
                );

        if (prescribedAt != null) {
            medication.setPrescribedAt(
                    prescribedAt.toLocalDateTime()
            );
        }

        Timestamp createdAt =
                resultSet.getTimestamp(
                        "created_at"
                );

        if (createdAt != null) {
            medication.setCreatedAt(
                    createdAt.toLocalDateTime()
            );
        }

        return medication;
    }
}