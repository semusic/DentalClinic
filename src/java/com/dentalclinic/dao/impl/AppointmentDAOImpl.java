package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.AppointmentDAO;
import com.dentalclinic.model.Appointment;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class AppointmentDAOImpl implements AppointmentDAO {

    private static final String INSERT_APPOINTMENT = """
        INSERT INTO appointments
        (
            patient_id,
            service_id,
            doctor_id,
            requested_date,
            requested_time,
            scheduled_start,
            scheduled_end,
            status_id,
            patient_reason,
            reviewed_by_user_id,
            reviewed_at,
            cancellation_reason,
            last_modified_by_user_id
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

    private static final String FIND_BY_ID = """
        SELECT
            a.appointment_id,
            a.patient_id,
            a.service_id,
            a.doctor_id,
            a.requested_date,
            a.requested_time,
            a.scheduled_start,
            a.scheduled_end,
            a.status_id,
            s.status_code,
            a.patient_reason,
            a.reviewed_by_user_id,
            a.reviewed_at,
            a.cancellation_reason,
            a.last_modified_by_user_id,
            a.created_at,
            a.updated_at
        FROM appointments a
        INNER JOIN appointment_statuses s
            ON a.status_id = s.status_id
        WHERE a.appointment_id = ?
        """;

    private static final String FIND_BY_PATIENT = """
        SELECT
            a.appointment_id,
            a.patient_id,
            a.service_id,
            a.doctor_id,
            a.requested_date,
            a.requested_time,
            a.scheduled_start,
            a.scheduled_end,
            a.status_id,
            s.status_code,
            a.patient_reason,
            a.reviewed_by_user_id,
            a.reviewed_at,
            a.cancellation_reason,
            a.last_modified_by_user_id,
            a.created_at,
            a.updated_at
        FROM appointments a
        INNER JOIN appointment_statuses s
            ON a.status_id = s.status_id
        WHERE a.patient_id = ?
        ORDER BY a.created_at DESC
        """;

    private static final String FIND_PENDING_REQUESTS = """
        SELECT
            a.appointment_id,
            a.patient_id,
            a.service_id,
            a.doctor_id,
            a.requested_date,
            a.requested_time,
            a.scheduled_start,
            a.scheduled_end,
            a.status_id,
            s.status_code,
            a.patient_reason,
            a.reviewed_by_user_id,
            a.reviewed_at,
            a.cancellation_reason,
            a.last_modified_by_user_id,
            a.created_at,
            a.updated_at
        FROM appointments a
        INNER JOIN appointment_statuses s
            ON a.status_id = s.status_id
        WHERE s.status_code IN (
            'PENDING',
            'UNDER_REVIEW',
            'AWAITING_DOCTOR_APPROVAL'
        )
        ORDER BY a.created_at ASC
        """;

    private static final String EXISTS_REQUESTED_SLOT = """
        SELECT COUNT(*)
        FROM appointments a
        INNER JOIN appointment_statuses s
            ON a.status_id = s.status_id
        WHERE a.doctor_id = ?
          AND a.requested_date = ?
          AND a.requested_time = ?
          AND s.status_code NOT IN (
              'REJECTED',
              'CANCELLED',
              'NO_SHOW',
              'COMPLETED',
              'PAID'
          )
        """;

    private static final String HAS_SCHEDULE_CONFLICT = """
        SELECT COUNT(*)
        FROM appointments a
        INNER JOIN appointment_statuses s
            ON a.status_id = s.status_id
        WHERE a.doctor_id = ?
          AND s.status_code IN (
              'DOCTOR_APPROVED',
              'CONFIRMED',
              'CHECKED_IN',
              'IN_PROGRESS'
          )
          AND a.scheduled_start < ?
          AND a.scheduled_end > ?
          AND (
              ? IS NULL
              OR a.appointment_id <> ?
          )
        """;
    
    private static final String UPDATE_STATUS = """
    UPDATE appointments
    SET
        status_id = ?,
        last_modified_by_user_id = ?,
        reviewed_by_user_id = ?,
        reviewed_at = CURRENT_TIMESTAMP
    WHERE appointment_id = ?
    """;

    
    private static final String UPDATE_STATUS_EXTERNAL = """
    UPDATE appointments
    SET
        status_id = ?,
        last_modified_by_user_id = NULL
    WHERE appointment_id = ?
    """;
    
    @Override
    public int save(Appointment appointment)
            throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             INSERT_APPOINTMENT,
                             java.sql.Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(
                    1,
                    appointment.getPatientId()
            );

            statement.setInt(
                    2,
                    appointment.getServiceId()
            );

            if (appointment.getDoctorId() != null) {
                statement.setInt(
                        3,
                        appointment.getDoctorId()
                );
            } else {
                statement.setNull(
                        3,
                        java.sql.Types.INTEGER
                );
            }

            statement.setDate(
                    4,
                    java.sql.Date.valueOf(
                            appointment.getRequestedDate()
                    )
            );

            if (appointment.getRequestedTime() != null) {
                statement.setTime(
                        5,
                        Time.valueOf(
                                appointment.getRequestedTime()
                        )
                );
            } else {
                statement.setNull(
                        5,
                        java.sql.Types.TIME
                );
            }

            if (appointment.getScheduledStart() != null) {
                statement.setTimestamp(
                        6,
                        Timestamp.valueOf(
                                appointment.getScheduledStart()
                        )
                );
            } else {
                statement.setNull(
                        6,
                        java.sql.Types.TIMESTAMP
                );
            }

            if (appointment.getScheduledEnd() != null) {
                statement.setTimestamp(
                        7,
                        Timestamp.valueOf(
                                appointment.getScheduledEnd()
                        )
                );
            } else {
                statement.setNull(
                        7,
                        java.sql.Types.TIMESTAMP
                );
            }

            statement.setInt(
                    8,
                    appointment.getStatusId()
            );

            statement.setString(
                    9,
                    appointment.getPatientReason()
            );

            if (appointment.getReviewedByUserId() != null) {
                statement.setInt(
                        10,
                        appointment.getReviewedByUserId()
                );
            } else {
                statement.setNull(
                        10,
                        java.sql.Types.INTEGER
                );
            }

            if (appointment.getReviewedAt() != null) {
                statement.setTimestamp(
                        11,
                        Timestamp.valueOf(
                                appointment.getReviewedAt()
                        )
                );
            } else {
                statement.setNull(
                        11,
                        java.sql.Types.TIMESTAMP
                );
            }

            statement.setString(
                    12,
                    appointment.getCancellationReason()
            );

            if (appointment.getLastModifiedByUserId() != null) {
                statement.setInt(
                        13,
                        appointment.getLastModifiedByUserId()
                );
            } else {
                statement.setNull(
                        13,
                        java.sql.Types.INTEGER
                );
            }

            statement.executeUpdate();

            try (ResultSet keys =
                         statement.getGeneratedKeys()) {

                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }

        throw new SQLException(
                "Unable to create appointment."
        );
    }

    @Override
    public Optional<Appointment> findById(
            int appointmentId
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(FIND_BY_ID)) {

            statement.setInt(1, appointmentId);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {
                    return Optional.of(
                            mapAppointment(resultSet)
                    );
                }
            }
        }

        return Optional.empty();
    }

    @Override
    public List<Appointment> findByPatientId(
            int patientId
    ) throws SQLException {

        List<Appointment> appointments =
                new ArrayList<>();

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(FIND_BY_PATIENT)) {

            statement.setInt(1, patientId);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {
                    appointments.add(
                            mapAppointment(resultSet)
                    );
                }
            }
        }

        return appointments;
    }

    @Override
    public List<Appointment> findPendingRequests()
            throws SQLException {

        List<Appointment> appointments =
                new ArrayList<>();

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_PENDING_REQUESTS);
             ResultSet resultSet =
                     statement.executeQuery()) {

            while (resultSet.next()) {
                appointments.add(
                        mapAppointment(resultSet)
                );
            }
        }

        return appointments;
    }

    @Override
    public boolean existsRequestedSlot(
            int doctorId,
            java.time.LocalDate requestedDate,
            java.time.LocalTime requestedTime
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             EXISTS_REQUESTED_SLOT)) {

            statement.setInt(1, doctorId);
            statement.setDate(
                    2,
                    java.sql.Date.valueOf(requestedDate)
            );
            statement.setTime(
                    3,
                    Time.valueOf(requestedTime)
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                return resultSet.next()
                        && resultSet.getInt(1) > 0;
            }
        }
    }

    @Override
    public boolean hasScheduleConflict(
            int doctorId,
            java.time.LocalDateTime scheduledStart,
            java.time.LocalDateTime scheduledEnd,
            Integer excludeAppointmentId
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             HAS_SCHEDULE_CONFLICT)) {

            statement.setInt(1, doctorId);

            statement.setTimestamp(
                    2,
                    Timestamp.valueOf(scheduledEnd)
            );

            statement.setTimestamp(
                    3,
                    Timestamp.valueOf(scheduledStart)
            );

            if (excludeAppointmentId != null) {
                statement.setInt(
                        4,
                        excludeAppointmentId
                );

                statement.setInt(
                        5,
                        excludeAppointmentId
                );
            } else {
                statement.setNull(
                        4,
                        java.sql.Types.INTEGER
                );

                statement.setNull(
                        5,
                        java.sql.Types.INTEGER
                );
            }

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                return resultSet.next()
                        && resultSet.getInt(1) > 0;
            }
        }
    }

    private Appointment mapAppointment(
            ResultSet resultSet
    ) throws SQLException {

        Appointment appointment =
                new Appointment();

        appointment.setAppointmentId(
                resultSet.getInt("appointment_id")
        );

        appointment.setPatientId(
                resultSet.getInt("patient_id")
        );

        appointment.setServiceId(
                resultSet.getInt("service_id")
        );

        int doctorId =
                resultSet.getInt("doctor_id");

        if (resultSet.wasNull()) {
            appointment.setDoctorId(null);
        } else {
            appointment.setDoctorId(doctorId);
        }

        appointment.setRequestedDate(
                resultSet.getDate("requested_date")
                        .toLocalDate()
        );

        Time requestedTime =
                resultSet.getTime("requested_time");

        if (requestedTime != null) {
            appointment.setRequestedTime(
                    requestedTime.toLocalTime()
            );
        }

        Timestamp scheduledStart =
                resultSet.getTimestamp(
                        "scheduled_start"
                );

        if (scheduledStart != null) {
            appointment.setScheduledStart(
                    scheduledStart.toLocalDateTime()
            );
        }

        Timestamp scheduledEnd =
                resultSet.getTimestamp(
                        "scheduled_end"
                );

        if (scheduledEnd != null) {
            appointment.setScheduledEnd(
                    scheduledEnd.toLocalDateTime()
            );
        }

        appointment.setStatusId(
                resultSet.getInt("status_id")
        );

        appointment.setStatusCode(
                resultSet.getString("status_code")
        );

        appointment.setPatientReason(
                resultSet.getString("patient_reason")
        );

        int reviewedBy =
                resultSet.getInt(
                        "reviewed_by_user_id"
                );

        if (resultSet.wasNull()) {
            appointment.setReviewedByUserId(null);
        } else {
            appointment.setReviewedByUserId(reviewedBy);
        }

        Timestamp reviewedAt =
                resultSet.getTimestamp("reviewed_at");

        if (reviewedAt != null) {
            appointment.setReviewedAt(
                    reviewedAt.toLocalDateTime()
            );
        }

        appointment.setCancellationReason(
                resultSet.getString(
                        "cancellation_reason"
                )
        );

        int lastModifiedBy =
                resultSet.getInt(
                        "last_modified_by_user_id"
                );

        if (resultSet.wasNull()) {
            appointment.setLastModifiedByUserId(null);
        } else {
            appointment.setLastModifiedByUserId(
                    lastModifiedBy
            );
        }

        Timestamp createdAt =
                resultSet.getTimestamp("created_at");

        if (createdAt != null) {
            appointment.setCreatedAt(
                    createdAt.toLocalDateTime()
            );
        }

        Timestamp updatedAt =
                resultSet.getTimestamp("updated_at");

        if (updatedAt != null) {
            appointment.setUpdatedAt(
                    updatedAt.toLocalDateTime()
            );
        }

        return appointment;
    }
    
    @Override
public boolean updateStatus(
        int appointmentId,
        int statusId,
        int changedByUserId,
        String reason
) throws SQLException {

    /*
     * The reason is recorded by the database trigger
     * when the status changes. It is accepted here
     * for future workflow/audit extensions.
     */
    try (Connection connection =
                 DatabaseConnection.getConnection();
         PreparedStatement statement =
                 connection.prepareStatement(
                         UPDATE_STATUS)) {

        statement.setInt(1, statusId);
        statement.setInt(2, changedByUserId);
        statement.setInt(3, changedByUserId);
        statement.setInt(4, appointmentId);

        return statement.executeUpdate() > 0;
    }
}

@Override
public boolean updateStatusAsExternalActor(
        int appointmentId,
        int statusId
) throws SQLException {

    try (Connection connection =
                 DatabaseConnection.getConnection();
         PreparedStatement statement =
                 connection.prepareStatement(
                         UPDATE_STATUS_EXTERNAL)) {

        statement.setInt(
                1,
                statusId
        );

        statement.setInt(
                2,
                appointmentId
        );

        return statement.executeUpdate() > 0;
    }
}
}