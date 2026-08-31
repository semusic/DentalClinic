package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.AppointmentReviewDAO;
import com.dentalclinic.dto.AppointmentReviewDTO;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class AppointmentReviewDAOImpl
        implements AppointmentReviewDAO {

    private static final String BASE_QUERY = """
        SELECT
            a.appointment_id,

            p.patient_id,

            CONCAT(
                u.first_name,
                ' ',
                u.last_name
            ) AS patient_name,

            u.phone AS patient_phone,
            u.email AS patient_email,

            a.service_id,
            s.service_name,

            a.doctor_id,

            CASE
                WHEN d.doctor_id IS NOT NULL THEN
                    CONCAT(
                        'Dr. ',
                        d.first_name,
                        ' ',
                        d.last_name
                    )
                ELSE NULL
            END AS doctor_name,

            d.specialization AS doctor_specialization,

            a.requested_date,
            a.requested_time,

            st.status_code,

            a.patient_reason,
            a.created_at

        FROM appointments a

        INNER JOIN patients p
            ON a.patient_id = p.patient_id

        INNER JOIN users u
            ON p.user_id = u.user_id

        INNER JOIN services s
            ON a.service_id = s.service_id

        LEFT JOIN doctors d
            ON a.doctor_id = d.doctor_id

        INNER JOIN appointment_statuses st
            ON a.status_id = st.status_id
        """;

    private static final String FIND_PENDING =
            BASE_QUERY + """
        WHERE st.status_code IN (
            'PENDING',
            'UNDER_REVIEW',
            'AWAITING_DOCTOR_APPROVAL'
        )
        ORDER BY a.created_at ASC
        """;

    private static final String FIND_BY_ID =
            BASE_QUERY + """
        WHERE a.appointment_id = ?
        """;

    @Override
    public List<AppointmentReviewDTO>
    findPendingReviews()
            throws SQLException {

        List<AppointmentReviewDTO> reviews =
                new ArrayList<>();

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_PENDING);
             ResultSet resultSet =
                     statement.executeQuery()) {

            while (resultSet.next()) {
                reviews.add(
                        mapReview(resultSet)
                );
            }
        }

        return reviews;
    }

    @Override
    public Optional<AppointmentReviewDTO>
    findReviewById(
            int appointmentId
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_BY_ID)) {

            statement.setInt(1, appointmentId);

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

    private AppointmentReviewDTO mapReview(
            ResultSet resultSet
    ) throws SQLException {

        AppointmentReviewDTO dto =
                new AppointmentReviewDTO();

        dto.setAppointmentId(
                resultSet.getInt("appointment_id")
        );

        dto.setPatientId(
                resultSet.getInt("patient_id")
        );

        dto.setPatientName(
                resultSet.getString("patient_name")
        );

        dto.setPatientPhone(
                resultSet.getString("patient_phone")
        );

        dto.setPatientEmail(
                resultSet.getString("patient_email")
        );

        dto.setServiceId(
                resultSet.getInt("service_id")
        );

        dto.setServiceName(
                resultSet.getString("service_name")
        );

        int doctorId =
                resultSet.getInt("doctor_id");

        if (resultSet.wasNull()) {
            dto.setDoctorId(null);
        } else {
            dto.setDoctorId(doctorId);
        }

        dto.setDoctorName(
                resultSet.getString("doctor_name")
        );

        dto.setDoctorSpecialization(
                resultSet.getString(
                        "doctor_specialization"
                )
        );

        dto.setRequestedDate(
                resultSet.getDate("requested_date")
                        .toLocalDate()
        );

        Time requestedTime =
                resultSet.getTime("requested_time");

        if (requestedTime != null) {
            dto.setRequestedTime(
                    requestedTime.toLocalTime()
            );
        }

        dto.setStatusCode(
                resultSet.getString("status_code")
        );

        dto.setPatientReason(
                resultSet.getString("patient_reason")
        );

        if (resultSet.getTimestamp("created_at") != null) {
            dto.setCreatedAt(
                    resultSet.getTimestamp("created_at")
                            .toLocalDateTime()
            );
        }

        return dto;
    }
}