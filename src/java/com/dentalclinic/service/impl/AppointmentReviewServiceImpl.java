package com.dentalclinic.service.impl;

import com.dentalclinic.dao.AppointmentDAO;
import com.dentalclinic.dao.AppointmentReviewDAO;
import com.dentalclinic.dao.AppointmentStatusDAO;
import com.dentalclinic.dao.impl.AppointmentDAOImpl;
import com.dentalclinic.dao.impl.AppointmentReviewDAOImpl;
import com.dentalclinic.dao.impl.AppointmentStatusDAOImpl;
import com.dentalclinic.dto.AppointmentReviewDTO;
import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.pattern.state.AppointmentState;
import com.dentalclinic.pattern.state.AppointmentStateContext;
import com.dentalclinic.pattern.state.AppointmentStateFactory;
import com.dentalclinic.service.AppointmentReviewService;

import com.dentalclinic.model.DoctorApprovalToken;
import com.dentalclinic.service.DoctorApprovalService;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class AppointmentReviewServiceImpl
        implements AppointmentReviewService {

    private final AppointmentReviewDAO reviewDAO;
    private final AppointmentDAO appointmentDAO;
    private final AppointmentStatusDAO statusDAO;
    private final AppointmentStateFactory stateFactory;
    private final DoctorApprovalService doctorApprovalService;

    public AppointmentReviewServiceImpl() {

        this.reviewDAO =
                new AppointmentReviewDAOImpl();

        this.appointmentDAO =
                new AppointmentDAOImpl();

        this.statusDAO =
                new AppointmentStatusDAOImpl();

        this.stateFactory =
                new AppointmentStateFactory();
        
        this.doctorApprovalService =
                new DoctorApprovalServiceImpl();
    }

    @Override
    public List<AppointmentReviewDTO> getPendingReviews()
            throws SQLException {

        return reviewDAO.findPendingReviews();
    }

    @Override
    public Optional<AppointmentReviewDTO> getReviewById(
            int appointmentId
    ) throws SQLException {

        return reviewDAO.findReviewById(
                appointmentId
        );
    }

    @Override
    public void startReview(
            int appointmentId,
            int assistantUserId
    ) throws SQLException, ValidationException {

        transitionAppointment(
                appointmentId,
                assistantUserId,
                "UNDER_REVIEW",
                "Assistant started appointment review."
        );
    }

    @Override
    public String sendToDoctor(
            int appointmentId,
            int assistantUserId
    ) throws SQLException, ValidationException {

        /*
         * The state machine requires PENDING → UNDER_REVIEW → AWAITING_DOCTOR_APPROVAL.
         * If the appointment is still PENDING, automatically move it to
         * UNDER_REVIEW first so the assistant can skip that manual step.
         */
        AppointmentReviewDTO currentReview =
                reviewDAO.findReviewById(appointmentId)
                        .orElseThrow(() -> new ValidationException(
                                "Appointment could not be found."
                        ));

        if ("PENDING".equals(currentReview.getStatusCode())) {
            transitionAppointment(
                    appointmentId,
                    assistantUserId,
                    "UNDER_REVIEW",
                    "Assistant automatically moved appointment to review."
            );
        }

        transitionAppointment(
                appointmentId,
                assistantUserId,
                "AWAITING_DOCTOR_APPROVAL",
                "Appointment sent to doctor for approval."
        );

        DoctorApprovalToken token =
                doctorApprovalService.createApproval(
                        appointmentId,
                        assistantUserId
                );

        try {
            Optional<AppointmentReviewDTO> reviewOpt = reviewDAO.findReviewById(appointmentId);
            if (reviewOpt.isPresent()) {
                AppointmentReviewDTO review = reviewOpt.get();
                String publicBaseUrl = com.dentalclinic.pattern.bridge.EmailNotificationDelivery.getPublicBaseUrl();
                String approvalUrl = publicBaseUrl + "/doctor/approval?token=" + java.net.URLEncoder.encode(token.getRawToken(), java.nio.charset.StandardCharsets.UTF_8);

                com.dentalclinic.model.Notification notification = new com.dentalclinic.model.Notification();
                // Assign to system / assistant or doctor user
                notification.setRecipientUserId(assistantUserId);
                notification.setAppointmentId(appointmentId);
                notification.setNotificationType("DOCTOR_APPROVAL_REQUEST");
                notification.setChannel("EMAIL");
                notification.setSubject("DentalCare Approval Request: " + review.getServiceName() + " (" + review.getRequestedDate() + ")");

                String emailBody = String.format(
                        "Dear %s,\n\n" +
                        "A new patient appointment requires your clinical review and approval.\n\n" +
                        "Patient Name: %s\n" +
                        "Requested Service: %s\n" +
                        "Date: %s\n" +
                        "Time Slot: %s\n" +
                        "Symptoms / Notes: %s\n\n" +
                        "Please click the secure link below to review and approve/reject this request:\n" +
                        "%s\n\n" +
                        "Security Notice: This link is temporary, single-use, and valid for 24 hours.\n\n" +
                        "DentalCare Clinic Management System",
                        review.getDoctorName() != null ? review.getDoctorName() : "Doctor",
                        review.getPatientName() != null ? review.getPatientName() : "Patient",
                        review.getServiceName(),
                        review.getRequestedDate(),
                        review.getRequestedTime() != null ? review.getRequestedTime().toString() : "Flexible",
                        review.getPatientReason() != null ? review.getPatientReason() : "None provided",
                        approvalUrl
                );

                notification.setMessage(emailBody);

                com.dentalclinic.service.NotificationService notificationService = new com.dentalclinic.service.impl.NotificationServiceImpl();
                notificationService.send(notification);
            }
        } catch (Exception e) {
            System.err.println("Failed to dispatch doctor email notification: " + e.getMessage());
        }

        return token.getRawToken();
    }

    @Override
    public String resendApprovalLink(
            int appointmentId,
            int assistantUserId
    ) throws SQLException, ValidationException {

        /*
         * Verify the appointment is in AWAITING_DOCTOR_APPROVAL.
         * We do NOT change the status — just generate a fresh token.
         */
        AppointmentReviewDTO review =
                reviewDAO.findReviewById(appointmentId)
                        .orElseThrow(() -> new ValidationException(
                                "Appointment could not be found."
                        ));

        if (!"AWAITING_DOCTOR_APPROVAL".equals(review.getStatusCode())) {
            throw new ValidationException(
                    "Cannot resend approval link: appointment is not awaiting doctor approval."
            );
        }

        /*
         * Generate a brand-new token (additional row in doctor_approvals).
         * The doctor can use any active, non-expired token for this appointment.
         */
        DoctorApprovalToken token =
                doctorApprovalService.createApproval(
                        appointmentId,
                        assistantUserId
                );

        return token.getRawToken();
    }

    private void transitionAppointment(
            int appointmentId,
            int changedByUserId,
            String targetStatus,
            String reason
    ) throws SQLException, ValidationException {

        AppointmentReviewDTO review =
                reviewDAO.findReviewById(
                        appointmentId
                ).orElseThrow(() ->
                        new ValidationException(
                                "Appointment could not be found."
                        )
                );

        AppointmentState currentState =
                stateFactory.create(
                        review.getStatusCode()
                );

        AppointmentStateContext context =
                new AppointmentStateContext(
                        currentState
                );

        if (!context.canTransitionTo(
                targetStatus
        )) {

            throw new ValidationException(
                    "Invalid appointment transition: "
                    + review.getStatusCode()
                    + " → "
                    + targetStatus
            );
        }

        int targetStatusId =
                statusDAO
                        .findStatusIdByCode(
                                targetStatus
                        )
                        .orElseThrow(() ->
                                new SQLException(
                                        "Appointment status is not configured: "
                                        + targetStatus
                                )
                        );

        boolean updated =
                appointmentDAO.updateStatus(
                        appointmentId,
                        targetStatusId,
                        changedByUserId,
                        reason
                );

        if (!updated) {
            throw new SQLException(
                    "Appointment status could not be updated."
            );
        }
    }
}