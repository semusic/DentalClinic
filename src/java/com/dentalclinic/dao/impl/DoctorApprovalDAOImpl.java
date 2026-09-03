package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.DoctorApprovalDAO;
import com.dentalclinic.dto.DoctorApprovalReviewDTO;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Optional;

public class DoctorApprovalDAOImpl
        implements DoctorApprovalDAO {

    private static final String INSERT_APPROVAL = """
        INSERT INTO doctor_approvals
        (
            appointment_id,
            doctor_id,
            decision,
            decision_note,
            recorded_by_user_id,
            approval_token_hash,
            token_expires_at
        )
        VALUES (?, ?, 'PENDING', NULL, ?, ?, ?)
        """;

    private static final String FIND_BY_TOKEN_HASH = """
        SELECT
            da.approval_id,
            da.appointment_id,
            da.doctor_id,

            CONCAT(
                'Dr. ',
                d.first_name,
                ' ',
                d.last_name
            ) AS doctor_name,

            d.specialization
                AS doctor_specialization,

            u.user_id AS patient_user_id,

            CONCAT(
                u.first_name,
                ' ',
                u.last_name
            ) AS patient_name,

            u.phone AS patient_phone,
            u.email AS patient_email,

            s.service_name,
            s.description AS service_description,

            a.requested_date,
            a.requested_time,

            a.patient_reason,

            da.approval_token_hash,
            da.token_expires_at,
            da.token_used_at,
            da.recorded_by_user_id,

            st.status_code AS current_status

        FROM doctor_approvals da

        INNER JOIN appointments a
            ON da.appointment_id = a.appointment_id

        INNER JOIN doctors d
            ON da.doctor_id = d.doctor_id

        INNER JOIN patients p
            ON a.patient_id = p.patient_id

        INNER JOIN users u
            ON p.user_id = u.user_id

        INNER JOIN services s
            ON a.service_id = s.service_id

        INNER JOIN appointment_statuses st
            ON a.status_id = st.status_id

        WHERE da.approval_token_hash = ?
        """;

    private static final String FIND_BY_APPOINTMENT_ID =
            FIND_BY_TOKEN_HASH.replace(
                    "WHERE da.approval_token_hash = ?",
                    "WHERE da.appointment_id = ?"
            );

    private static final String MARK_TOKEN_USED = """
        UPDATE doctor_approvals
        SET token_used_at = CURRENT_TIMESTAMP
        WHERE approval_id = ?
          AND token_used_at IS NULL
        """;

    private static final String RECORD_DECISION = """
        UPDATE doctor_approvals
        SET
            decision = ?,
            decision_note = ?,
            decision_at = CURRENT_TIMESTAMP
        WHERE approval_id = ?
        """;

    @Override
    public int createApproval(
            int appointmentId,
            int doctorId,
            String tokenHash,
            LocalDateTime tokenExpiresAt,
            int recordedByUserId
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             INSERT_APPROVAL,
                             java.sql.Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(
                    1,
                    appointmentId
            );

            statement.setInt(
                    2,
                    doctorId
            );

            statement.setInt(
                    3,
                    recordedByUserId
            );

            statement.setString(
                    4,
                    tokenHash
            );

            statement.setTimestamp(
                    5,
                    Timestamp.valueOf(
                            tokenExpiresAt
                    )
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
                "Unable to create doctor approval request."
        );
    }

    @Override
    public Optional<DoctorApprovalReviewDTO>
    findByTokenHash(
            String tokenHash
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_BY_TOKEN_HASH)) {

            statement.setString(
                    1,
                    tokenHash
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {

                    return Optional.of(
                            mapReview(resultSet)
                    );
                }
            }
        }

        return Optional.empty();
    }

    @Override
    public Optional<DoctorApprovalReviewDTO>
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
                            mapReview(resultSet)
                    );
                }
            }
        }

        return Optional.empty();
    }

    @Override
    public boolean markTokenUsed(
            int approvalId
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             MARK_TOKEN_USED)) {

            statement.setInt(
                    1,
                    approvalId
            );

            return statement.executeUpdate() > 0;
        }
    }

    @Override
    public boolean recordDecision(
            int approvalId,
            String decision,
            String decisionNote
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             RECORD_DECISION)) {

            statement.setString(
                    1,
                    decision
            );

            statement.setString(
                    2,
                    decisionNote
            );

            statement.setInt(
                    3,
                    approvalId
            );

            return statement.executeUpdate() > 0;
        }
    }

    private DoctorApprovalReviewDTO mapReview(
            ResultSet resultSet
    ) throws SQLException {

        DoctorApprovalReviewDTO dto =
                new DoctorApprovalReviewDTO();

        dto.setApprovalId(
                resultSet.getInt(
                        "approval_id"
                )
        );

        dto.setAppointmentId(
                resultSet.getInt(
                        "appointment_id"
                )
        );

        dto.setDoctorId(
                resultSet.getInt(
                        "doctor_id"
                )
        );

        
        dto.setPatientUserId(
                resultSet.getInt(
                        "patient_user_id"
                )
        );

        dto.setDoctorName(
                resultSet.getString(
                        "doctor_name"
                )
        );

        dto.setDoctorSpecialization(
                resultSet.getString(
                        "doctor_specialization"
                )
        );

        dto.setPatientName(
                resultSet.getString(
                        "patient_name"
                )
        );

        dto.setPatientPhone(
                resultSet.getString(
                        "patient_phone"
                )
        );

        dto.setPatientEmail(
                resultSet.getString(
                        "patient_email"
                )
        );

        dto.setServiceName(
                resultSet.getString(
                        "service_name"
                )
        );

        dto.setServiceDescription(
                resultSet.getString(
                        "service_description"
                )
        );

        Timestamp requestedDate =
                resultSet.getTimestamp(
                        "requested_date"
                );

        if (requestedDate != null) {

            dto.setRequestedDate(
                    requestedDate.toLocalDateTime()
                            .toLocalDate()
            );
        }

        java.sql.Time requestedTime =
                resultSet.getTime(
                        "requested_time"
                );

        if (requestedTime != null) {

            dto.setRequestedTime(
                    requestedTime.toLocalTime()
            );
        }

        dto.setPatientReason(
                resultSet.getString(
                        "patient_reason"
                )
        );

        dto.setApprovalTokenHash(
                resultSet.getString(
                        "approval_token_hash"
                )
        );

        Timestamp expiresAt =
                resultSet.getTimestamp(
                        "token_expires_at"
                );

        if (expiresAt != null) {

            dto.setTokenExpiresAt(
                    expiresAt.toLocalDateTime()
            );
        }

        Timestamp usedAt =
                resultSet.getTimestamp(
                        "token_used_at"
                );

        if (usedAt != null) {

            dto.setTokenUsedAt(
                    usedAt.toLocalDateTime()
            );
        }

        dto.setCurrentStatus(
                resultSet.getString(
                        "current_status"
                )
        );

        int recordedBy = resultSet.getInt("recorded_by_user_id");
        if (resultSet.wasNull()) {
            dto.setRecordedByUserId(null);
        } else {
            dto.setRecordedByUserId(recordedBy);
        }

        return dto;
    }
}