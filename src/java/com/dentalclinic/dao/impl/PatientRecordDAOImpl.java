package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.PatientRecordDAO;
import com.dentalclinic.dto.PatientRecordDTO;
import com.dentalclinic.util.DatabaseConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Optional;

public class PatientRecordDAOImpl
        implements PatientRecordDAO {

    private static final String FIND_RECORD = """
        SELECT
            i.invoice_id,
            i.invoice_number,
            i.total_amount,

            pv.visit_id,
            pv.checked_in_at,
            pv.consultation_started_at,
            pv.consultation_completed_at,
            pv.medicine_prescribed,
            pv.visit_notes,

            a.scheduled_start,
            a.requested_date,
            a.requested_time,

            CONCAT(
                u.first_name,
                ' ',
                u.last_name
            ) AS patient_name,

            u.phone AS patient_phone,
            u.email AS patient_email,

            CASE
                WHEN d.doctor_id IS NOT NULL THEN
                    CONCAT(
                        'Dr. ',
                        d.first_name,
                        ' ',
                        d.last_name
                    )
                ELSE 'Not assigned'
            END AS doctor_name

        FROM invoices i

        INNER JOIN patient_visits pv
            ON i.visit_id = pv.visit_id

        INNER JOIN appointments a
            ON pv.appointment_id = a.appointment_id

        INNER JOIN patients p
            ON a.patient_id = p.patient_id

        INNER JOIN users u
            ON p.user_id = u.user_id

        LEFT JOIN doctors d
            ON a.doctor_id = d.doctor_id

        WHERE i.qr_token_hash = ?
          AND i.invoice_status = 'PAID'
        """;

    private static final String FIND_SERVICES = """
        SELECT
            item_description,
            quantity,
            unit_price,
            line_total
        FROM invoice_items
        WHERE invoice_id = ?
        ORDER BY invoice_item_id ASC
        """;

    private static final String FIND_PAYMENTS = """
        SELECT
            p.payment_reference,
            p.amount,
            p.payment_method,
            p.payment_status,
            p.transaction_date,

            r.receipt_number

        FROM payments p

        LEFT JOIN receipts r
            ON p.payment_id = r.payment_id

        WHERE p.invoice_id = ?

        ORDER BY p.transaction_date ASC
        """;

    @Override
    public Optional<PatientRecordDTO>
    findByQrTokenHash(
            String qrTokenHash
    ) throws SQLException {

        if (qrTokenHash == null
                || qrTokenHash.isBlank()) {

            return Optional.empty();
        }

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_RECORD)) {

            statement.setString(
                    1,
                    qrTokenHash
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (!resultSet.next()) {
                    return Optional.empty();
                }

                PatientRecordDTO record =
                        mapBaseRecord(resultSet);

                int invoiceId =
                        resultSet.getInt(
                                "invoice_id"
                        );

                loadServices(
                        connection,
                        invoiceId,
                        record
                );

                loadPayments(
                        connection,
                        invoiceId,
                        record
                );

                return Optional.of(record);
            }
        }
    }

    private PatientRecordDTO mapBaseRecord(
            ResultSet resultSet
    ) throws SQLException {

        PatientRecordDTO record =
                new PatientRecordDTO();

        record.setPatientName(
                resultSet.getString(
                        "patient_name"
                )
        );

        record.setPatientPhone(
                resultSet.getString(
                        "patient_phone"
                )
        );

        record.setPatientEmail(
                resultSet.getString(
                        "patient_email"
                )
        );

        record.setVisitId(
                resultSet.getInt(
                        "visit_id"
                )
        );

        record.setDoctorName(
                resultSet.getString(
                        "doctor_name"
                )
        );

        record.setInvoiceNumber(
                resultSet.getString(
                        "invoice_number"
                )
        );

        record.setInvoiceTotal(
                resultSet.getBigDecimal(
                        "total_amount"
                )
        );

        record.setMedicinePrescribed(
                resultSet.getBoolean(
                        "medicine_prescribed"
                )
        );

        record.setVisitNotes(
                resultSet.getString(
                        "visit_notes"
                )
        );

        Timestamp scheduledStart =
                resultSet.getTimestamp(
                        "scheduled_start"
                );

        if (scheduledStart != null) {

            record.setAppointmentDateTime(
                    scheduledStart
                            .toLocalDateTime()
            );

        } else {

            java.sql.Date requestedDate =
                    resultSet.getDate(
                            "requested_date"
                    );

            java.sql.Time requestedTime =
                    resultSet.getTime(
                            "requested_time"
                    );

            if (requestedDate != null) {

                java.time.LocalDate date =
                        requestedDate.toLocalDate();

                java.time.LocalTime time =
                        requestedTime == null
                                ? java.time.LocalTime.MIDNIGHT
                                : requestedTime
                                        .toLocalTime();

                record.setAppointmentDateTime(
                        java.time.LocalDateTime.of(
                                date,
                                time
                        )
                );
            }
        }

        Timestamp checkedIn =
                resultSet.getTimestamp(
                        "checked_in_at"
                );

        if (checkedIn != null) {

            record.setCheckedInAt(
                    checkedIn.toLocalDateTime()
            );
        }

        Timestamp started =
                resultSet.getTimestamp(
                        "consultation_started_at"
                );

        if (started != null) {

            record.setConsultationStartedAt(
                    started.toLocalDateTime()
            );
        }

        Timestamp completed =
                resultSet.getTimestamp(
                        "consultation_completed_at"
                );

        if (completed != null) {

            record.setConsultationCompletedAt(
                    completed.toLocalDateTime()
            );
        }

        return record;
    }

    private void loadServices(
            Connection connection,
            int invoiceId,
            PatientRecordDTO record
    ) throws SQLException {

        try (PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_SERVICES)) {

            statement.setInt(
                    1,
                    invoiceId
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {

                    PatientRecordDTO.ServiceRecord
                            service =
                            new PatientRecordDTO
                                    .ServiceRecord();

                    service.setServiceName(
                            resultSet.getString(
                                    "item_description"
                            )
                    );

                    service.setQuantity(
                            resultSet.getInt(
                                    "quantity"
                            )
                    );

                    service.setUnitPrice(
                            resultSet.getBigDecimal(
                                    "unit_price"
                            )
                    );

                    service.setLineTotal(
                            resultSet.getBigDecimal(
                                    "line_total"
                            )
                    );

                    record.getServices()
                            .add(service);
                }
            }
        }
    }

    private void loadPayments(
            Connection connection,
            int invoiceId,
            PatientRecordDTO record
    ) throws SQLException {

        BigDecimal totalPaid =
                BigDecimal.ZERO;

        PatientRecordDTO.PaymentRecord latest =
                null;

        try (PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_PAYMENTS)) {

            statement.setInt(
                    1,
                    invoiceId
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {

                    PatientRecordDTO.PaymentRecord
                            payment =
                            new PatientRecordDTO
                                    .PaymentRecord();

                    payment.setPaymentReference(
                            resultSet.getString(
                                    "payment_reference"
                            )
                    );

                    payment.setAmount(
                            resultSet.getBigDecimal(
                                    "amount"
                            )
                    );

                    payment.setPaymentMethod(
                            resultSet.getString(
                                    "payment_method"
                            )
                    );

                    payment.setPaymentStatus(
                            resultSet.getString(
                                    "payment_status"
                            )
                    );

                    Timestamp transactionDate =
                            resultSet.getTimestamp(
                                    "transaction_date"
                            );

                    if (transactionDate != null) {

                        payment.setTransactionDate(
                                transactionDate
                                        .toLocalDateTime()
                        );
                    }

                    payment.setReceiptNumber(
                            resultSet.getString(
                                    "receipt_number"
                            )
                    );

                    record.getPayments()
                            .add(payment);

                    if ("COMPLETED".equalsIgnoreCase(
                            payment.getPaymentStatus())) {

                        if (payment.getAmount() != null) {

                            totalPaid =
                                    totalPaid.add(
                                            payment.getAmount()
                                    );
                        }

                        latest = payment;
                    }
                }
            }
        }

        record.setTotalPaid(
                totalPaid
        );

        if (latest != null) {

            record.setLatestReceiptNumber(
                    latest.getReceiptNumber()
            );
        }
    }
}