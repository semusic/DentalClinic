package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.PatientVisitDAO;
import com.dentalclinic.model.PatientVisit;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Optional;

public class PatientVisitDAOImpl
        implements PatientVisitDAO {

    private static final String INSERT_VISIT = """
        INSERT INTO patient_visits
        (
            appointment_id,
            recorded_by_user_id
        )
        VALUES (?, ?)
        """;

    private static final String FIND_BY_ID = """
        SELECT
            visit_id,
            appointment_id,
            checked_in_at,
            consultation_started_at,
            consultation_completed_at,
            visit_notes,
            medicine_prescribed,
            recorded_by_user_id,
            created_at,
            updated_at
        FROM patient_visits
        WHERE visit_id = ?
        """;

    private static final String FIND_BY_APPOINTMENT_ID = """
        SELECT
            visit_id,
            appointment_id,
            checked_in_at,
            consultation_started_at,
            consultation_completed_at,
            visit_notes,
            medicine_prescribed,                                             
            recorded_by_user_id,
            created_at,
            updated_at
        FROM patient_visits
        WHERE appointment_id = ?
        """;

    private static final String UPDATE_CHECK_IN = """
        UPDATE patient_visits
        SET checked_in_at = CURRENT_TIMESTAMP
        WHERE visit_id = ?
        """;

    private static final String UPDATE_CONSULTATION_STARTED = """
        UPDATE patient_visits
        SET consultation_started_at = CURRENT_TIMESTAMP
        WHERE visit_id = ?
        """;

    private static final String COMPLETE_VISIT = """
        UPDATE patient_visits
        SET
            consultation_completed_at =
                CURRENT_TIMESTAMP,
            visit_notes = ?
        WHERE visit_id = ?
        """;
    
    private static final String UPDATE_MEDICINE_PRESCRIBED = """
        UPDATE patient_visits
        SET medicine_prescribed = ?
        WHERE visit_id = ?
        """;

    @Override
    public int create(
            PatientVisit visit
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             INSERT_VISIT,
                             java.sql.Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(
                    1,
                    visit.getAppointmentId()
            );

            statement.setInt(
                    2,
                    visit.getRecordedByUserId()
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
                "Unable to create patient visit."
        );
    }

    @Override
    public Optional<PatientVisit> findById(
            int visitId
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_BY_ID)) {

            statement.setInt(
                    1,
                    visitId
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {

                    return Optional.of(
                            mapVisit(resultSet)
                    );
                }
            }
        }

        return Optional.empty();
    }

    @Override
    public Optional<PatientVisit>
    findByAppointmentId(
            int appointmentId
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_BY_APPOINTMENT_ID)) {

            statement.setInt(
                    1,
                    appointmentId
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {

                    return Optional.of(
                            mapVisit(resultSet)
                    );
                }
            }
        }

        return Optional.empty();
    }

    @Override
    public boolean updateCheckIn(
            int visitId
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             UPDATE_CHECK_IN)) {

            statement.setInt(
                    1,
                    visitId
            );

            return statement.executeUpdate() > 0;
        }
    }

    @Override
    public boolean updateConsultationStarted(
            int visitId
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             UPDATE_CONSULTATION_STARTED)) {

            statement.setInt(
                    1,
                    visitId
            );

            return statement.executeUpdate() > 0;
        }
    }

    @Override
    public boolean completeVisit(
            int visitId,
            String visitNotes
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             COMPLETE_VISIT)) {

            statement.setString(
                    1,
                    visitNotes
            );

            statement.setInt(
                    2,
                    visitId
            );

            return statement.executeUpdate() > 0;
        }
    }

    private PatientVisit mapVisit(
            ResultSet resultSet
    ) throws SQLException {

        PatientVisit visit =
                new PatientVisit();

        visit.setVisitId(
                resultSet.getInt("visit_id")
        );

        visit.setAppointmentId(
                resultSet.getInt("appointment_id")
        );

        Timestamp checkedIn =
                resultSet.getTimestamp(
                        "checked_in_at"
                );

        if (checkedIn != null) {
            visit.setCheckedInAt(
                    checkedIn.toLocalDateTime()
            );
        }

        Timestamp started =
                resultSet.getTimestamp(
                        "consultation_started_at"
                );

        if (started != null) {
            visit.setConsultationStartedAt(
                    started.toLocalDateTime()
            );
        }

        Timestamp completed =
                resultSet.getTimestamp(
                        "consultation_completed_at"
                );

        if (completed != null) {
            visit.setConsultationCompletedAt(
                    completed.toLocalDateTime()
            );
        }

        visit.setVisitNotes(
                resultSet.getString(
                        "visit_notes"
                )
        );
        
        visit.setMedicinePrescribed(
                resultSet.getBoolean(
                        "medicine_prescribed"
                )
        );

        visit.setRecordedByUserId(
                resultSet.getInt(
                        "recorded_by_user_id"
                )
        );

        Timestamp createdAt =
                resultSet.getTimestamp(
                        "created_at"
                );

        if (createdAt != null) {
            visit.setCreatedAt(
                    createdAt.toLocalDateTime()
            );
        }

        Timestamp updatedAt =
                resultSet.getTimestamp(
                        "updated_at"
                );

        if (updatedAt != null) {
            visit.setUpdatedAt(
                    updatedAt.toLocalDateTime()
            );
        }

        return visit;
    }
    
    @Override
    public boolean updateMedicinePrescribed(
            int visitId,
            boolean prescribed
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             UPDATE_MEDICINE_PRESCRIBED)) {

            statement.setBoolean(
                    1,
                    prescribed
            );

            statement.setInt(
                    2,
                    visitId
            );

            return statement.executeUpdate() > 0;
        }
    }
}