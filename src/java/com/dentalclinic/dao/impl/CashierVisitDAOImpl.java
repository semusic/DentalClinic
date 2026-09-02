package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.CashierVisitDAO;
import com.dentalclinic.dto.CashierVisitDTO;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class CashierVisitDAOImpl
        implements CashierVisitDAO {

    private static final String FIND_READY_FOR_BILLING = """
        SELECT
            pv.visit_id,
            pv.appointment_id,
            a.patient_id,

            CONCAT(
                u.first_name,
                ' ',
                u.last_name
            ) AS patient_name,

            CASE
                WHEN d.doctor_id IS NOT NULL THEN
                    CONCAT(
                        'Dr. ',
                        d.first_name,
                        ' ',
                        d.last_name
                    )
                ELSE 'Not assigned'
            END AS doctor_name,

            pv.consultation_completed_at

        FROM patient_visits pv

        INNER JOIN appointments a
            ON pv.appointment_id = a.appointment_id

        INNER JOIN patients p
            ON a.patient_id = p.patient_id

        INNER JOIN users u
            ON p.user_id = u.user_id

        LEFT JOIN doctors d
            ON a.doctor_id = d.doctor_id

        LEFT JOIN invoices i
            ON pv.visit_id = i.visit_id

        WHERE pv.consultation_completed_at IS NOT NULL
          AND i.invoice_id IS NULL

        ORDER BY pv.consultation_completed_at DESC
        """;

    private static final String FIND_BY_VISIT_ID = """
        SELECT
            pv.visit_id,
            pv.appointment_id,
            a.patient_id,

            CONCAT(
                u.first_name,
                ' ',
                u.last_name
            ) AS patient_name,

            CASE
                WHEN d.doctor_id IS NOT NULL THEN
                    CONCAT(
                        'Dr. ',
                        d.first_name,
                        ' ',
                        d.last_name
                    )
                ELSE 'Not assigned'
            END AS doctor_name,

            pv.consultation_completed_at

        FROM patient_visits pv

        INNER JOIN appointments a
            ON pv.appointment_id = a.appointment_id

        INNER JOIN patients p
            ON a.patient_id = p.patient_id

        INNER JOIN users u
            ON p.user_id = u.user_id

        LEFT JOIN doctors d
            ON a.doctor_id = d.doctor_id

        WHERE pv.visit_id = ?
        """;

    @Override
    public List<CashierVisitDTO>
    findVisitsReadyForBilling()
            throws SQLException {

        List<CashierVisitDTO> visits =
                new ArrayList<>();

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_READY_FOR_BILLING);
             ResultSet resultSet =
                     statement.executeQuery()) {

            while (resultSet.next()) {

                visits.add(
                        mapVisit(resultSet)
                );
            }
        }

        return visits;
    }

    @Override
    public Optional<CashierVisitDTO>
    findByVisitId(
            int visitId
    ) throws SQLException {

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

                if (resultSet.next()) {

                    return Optional.of(
                            mapVisit(resultSet)
                    );
                }
            }
        }

        return Optional.empty();
    }

    private CashierVisitDTO mapVisit(
            ResultSet resultSet
    ) throws SQLException {

        CashierVisitDTO visit =
                new CashierVisitDTO();

        visit.setVisitId(
                resultSet.getInt("visit_id")
        );

        visit.setAppointmentId(
                resultSet.getInt("appointment_id")
        );

        visit.setPatientId(
                resultSet.getInt("patient_id")
        );

        visit.setPatientName(
                resultSet.getString(
                        "patient_name"
                )
        );

        visit.setDoctorName(
                resultSet.getString(
                        "doctor_name"
                )
        );

        Timestamp completedAt =
                resultSet.getTimestamp(
                        "consultation_completed_at"
                );

        if (completedAt != null) {

            visit.setConsultationCompletedAt(
                    completedAt.toLocalDateTime()
            );
        }

        return visit;
    }
}