package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.AssistantVisitDAO;
import com.dentalclinic.dto.AssistantVisitDTO;
import com.dentalclinic.model.PatientVisit;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Time;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class AssistantVisitDAOImpl
        implements AssistantVisitDAO {

    private static final String FIND_CONFIRMED =
            """
            SELECT
                a.appointment_id,
                a.patient_id,

                CONCAT(
                    u.first_name,
                    ' ',
                    u.last_name
                ) AS patient_name,

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

                a.requested_date,
                a.requested_time,

                st.status_code,

                pv.visit_id,
                pv.checked_in_at,
                pv.consultation_started_at,
                pv.consultation_completed_at,
                pv.visit_notes,
                pv.recorded_by_user_id,
                pv.created_at AS visit_created_at,
                pv.updated_at AS visit_updated_at

            FROM appointments a

            INNER JOIN appointment_statuses st
                ON a.status_id = st.status_id

            INNER JOIN patients p
                ON a.patient_id = p.patient_id

            INNER JOIN users u
                ON p.user_id = u.user_id

            INNER JOIN services s
                ON a.service_id = s.service_id

            LEFT JOIN doctors d
                ON a.doctor_id = d.doctor_id

            LEFT JOIN patient_visits pv
                ON a.appointment_id = pv.appointment_id

            WHERE st.status_code = 'CONFIRMED'
              AND a.requested_date = ?

            ORDER BY a.requested_time ASC
            """;

    private static final String FIND_BY_APPOINTMENT =
            """
            SELECT
                a.appointment_id,
                a.patient_id,

                CONCAT(
                    u.first_name,
                    ' ',
                    u.last_name
                ) AS patient_name,

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

                a.requested_date,
                a.requested_time,

                st.status_code,

                pv.visit_id,
                pv.checked_in_at,
                pv.consultation_started_at,
                pv.consultation_completed_at,
                pv.visit_notes,
                pv.recorded_by_user_id,
                pv.created_at AS visit_created_at,
                pv.updated_at AS visit_updated_at

            FROM appointments a

            INNER JOIN appointment_statuses st
                ON a.status_id = st.status_id

            INNER JOIN patients p
                ON a.patient_id = p.patient_id

            INNER JOIN users u
                ON p.user_id = u.user_id

            INNER JOIN services s
                ON a.service_id = s.service_id

            LEFT JOIN doctors d
                ON a.doctor_id = d.doctor_id

            LEFT JOIN patient_visits pv
                ON a.appointment_id = pv.appointment_id

            WHERE a.appointment_id = ?
            """;

    @Override
    public List<AssistantVisitDTO>
    findConfirmedAppointments(
            LocalDate date
    ) throws SQLException {

        List<AssistantVisitDTO> results =
                new ArrayList<>();

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_CONFIRMED)) {

            statement.setDate(
                    1,
                    java.sql.Date.valueOf(date)
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {

                    results.add(
                            mapResult(resultSet)
                    );
                }
            }
        }

        return results;
    }

    @Override
    public Optional<AssistantVisitDTO>
    findByAppointmentId(
            int appointmentId
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_BY_APPOINTMENT)) {

            statement.setInt(
                    1,
                    appointmentId
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {

                    return Optional.of(
                            mapResult(resultSet)
                    );
                }
            }
        }

        return Optional.empty();
    }

    private AssistantVisitDTO mapResult(
            ResultSet resultSet
    ) throws SQLException {

        AssistantVisitDTO dto =
                new AssistantVisitDTO();

        dto.setAppointmentId(
                resultSet.getInt(
                        "appointment_id"
                )
        );

        dto.setPatientId(
                resultSet.getInt(
                        "patient_id"
                )
        );

        dto.setPatientName(
                resultSet.getString(
                        "patient_name"
                )
        );

        dto.setServiceId(
                resultSet.getInt(
                        "service_id"
                )
        );

        dto.setServiceName(
                resultSet.getString(
                        "service_name"
                )
        );

        int doctorId =
                resultSet.getInt(
                        "doctor_id"
                );

        if (resultSet.wasNull()) {
            dto.setDoctorId(null);
        } else {
            dto.setDoctorId(doctorId);
        }

        dto.setDoctorName(
                resultSet.getString(
                        "doctor_name"
                )
        );

        dto.setAppointmentDate(
                resultSet.getDate(
                        "requested_date"
                ).toLocalDate()
        );

        Time requestedTime =
                resultSet.getTime(
                        "requested_time"
                );

        if (requestedTime != null) {

            dto.setAppointmentTime(
                    requestedTime.toLocalTime()
            );
        }

        dto.setAppointmentStatus(
                resultSet.getString(
                        "status_code"
                )
        );

        /*
         * Existing patient visit, if one exists.
         */
        int visitId =
                resultSet.getInt(
                        "visit_id"
                );

        if (!resultSet.wasNull()) {

            PatientVisit visit =
                    new PatientVisit();

            visit.setVisitId(visitId);

            visit.setAppointmentId(
                    dto.getAppointmentId()
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

            visit.setRecordedByUserId(
                    resultSet.getInt(
                            "recorded_by_user_id"
                    )
            );

            Timestamp createdAt =
                    resultSet.getTimestamp(
                            "visit_created_at"
                    );

            if (createdAt != null) {
                visit.setCreatedAt(
                        createdAt.toLocalDateTime()
                );
            }

            Timestamp updatedAt =
                    resultSet.getTimestamp(
                            "visit_updated_at"
                    );

            if (updatedAt != null) {
                visit.setUpdatedAt(
                        updatedAt.toLocalDateTime()
                );
            }

            dto.setPatientVisit(visit);
        }

        return dto;
    }
}