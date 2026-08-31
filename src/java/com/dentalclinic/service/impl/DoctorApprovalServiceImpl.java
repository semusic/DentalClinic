package com.dentalclinic.service.impl;

import com.dentalclinic.dao.AppointmentDAO;
import com.dentalclinic.dao.AppointmentStatusDAO;
import com.dentalclinic.dao.DoctorApprovalDAO;
import com.dentalclinic.dao.impl.AppointmentDAOImpl;
import com.dentalclinic.dao.impl.AppointmentStatusDAOImpl;
import com.dentalclinic.dao.impl.DoctorApprovalDAOImpl;
import com.dentalclinic.dto.DoctorApprovalReviewDTO;
import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.pattern.state.AppointmentState;
import com.dentalclinic.pattern.state.AppointmentStateContext;
import com.dentalclinic.pattern.state.AppointmentStateFactory;
import com.dentalclinic.security.ApprovalTokenGenerator;
import com.dentalclinic.service.DoctorApprovalService;
import com.dentalclinic.model.DoctorApprovalToken;
import com.dentalclinic.model.Appointment;
import com.dentalclinic.pattern.observer.AppointmentConfirmationObserver;
import com.dentalclinic.pattern.observer.NotificationSubject;
import com.dentalclinic.model.Notification;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.Optional;

public class DoctorApprovalServiceImpl
        implements DoctorApprovalService {

    private final DoctorApprovalDAO approvalDAO;
    private final AppointmentDAO appointmentDAO;
    private final AppointmentStatusDAO statusDAO;
    private final ApprovalTokenGenerator tokenGenerator;
    private final AppointmentStateFactory stateFactory;
    private final NotificationSubject notificationSubject;
    private final AppointmentConfirmationObserver confirmationObserver;

    public DoctorApprovalServiceImpl() {

        this.approvalDAO =
                new DoctorApprovalDAOImpl();

        this.appointmentDAO =
                new AppointmentDAOImpl();

        this.statusDAO =
                new AppointmentStatusDAOImpl();

        this.tokenGenerator =
                new ApprovalTokenGenerator();

        this.stateFactory =
                new AppointmentStateFactory();
        
        this.notificationSubject =
                new NotificationSubject();

        this.confirmationObserver =
                new AppointmentConfirmationObserver();

        this.notificationSubject.attach(
                confirmationObserver
        );
    }

   @Override
public DoctorApprovalToken createApproval(
        int appointmentId,
        int assistantUserId
) throws SQLException, ValidationException {

    if (appointmentId <= 0) {
        throw new ValidationException(
                "Invalid appointment."
        );
    }

    if (assistantUserId <= 0) {
        throw new ValidationException(
                "Invalid assistant user."
        );
    }

    /*
     * Retrieve the actual appointment.
     * We must NOT look for a doctor_approvals record
     * here because we are creating that record now.
     */
    Appointment appointment =
            appointmentDAO.findById(
                    appointmentId
            ).orElseThrow(() ->
                    new ValidationException(
                            "Appointment could not be found."
                    )
            );

    /*
     * The appointment must already be in the
     * AWAITING_DOCTOR_APPROVAL state.
     */
    if (!"AWAITING_DOCTOR_APPROVAL".equals(
            appointment.getStatusCode())) {

        throw new ValidationException(
                "This appointment is not awaiting doctor approval."
        );
    }

    /*
     * The appointment must have a doctor assigned.
     */
    if (appointment.getDoctorId() == null
            || appointment.getDoctorId() <= 0) {

        throw new ValidationException(
                "A doctor is required for approval."
        );
    }

    /*
     * Generate a secure, one-time token.
     */
    DoctorApprovalToken token =
            tokenGenerator.generate();

    /*
     * NOW create the approval record.
     */
    approvalDAO.createApproval(
            appointmentId,
            appointment.getDoctorId(),
            token.getTokenHash(),
            token.getExpiresAt(),
            assistantUserId
    );

    return token;
}
    
    @Override
    public Optional<DoctorApprovalReviewDTO>
    getApprovalByToken(
            String rawToken
    ) throws SQLException, ValidationException {

        DoctorApprovalReviewDTO approval =
                findAndValidateToken(rawToken);

        return Optional.of(approval);
    }

    @Override
    public void approve(
            String rawToken,
            String decisionNote
    ) throws SQLException, ValidationException {

        processDecision(
                rawToken,
                "APPROVED",
                "DOCTOR_APPROVED",
                decisionNote
        );
    }

    @Override
    public void reject(
            String rawToken,
            String decisionNote
    ) throws SQLException, ValidationException {

        processDecision(
                rawToken,
                "REJECTED",
                "REJECTED",
                decisionNote
        );
    }

    @Override
    public void requestReschedule(
            String rawToken,
            String decisionNote
    ) throws SQLException, ValidationException {

        processDecision(
                rawToken,
                "RESCHEDULE_REQUIRED",
                "RESCHEDULE_REQUIRED",
                decisionNote
        );
    }

    private DoctorApprovalReviewDTO findAndValidateToken(
            String rawToken
    ) throws SQLException, ValidationException {

        validateRawToken(rawToken);

        String tokenHash =
                tokenGenerator.hash(rawToken);

        Optional<DoctorApprovalReviewDTO> result =
                approvalDAO.findByTokenHash(
                        tokenHash
                );

        if (result.isEmpty()) {

            throw new ValidationException(
                    "This doctor approval link is invalid."
            );
        }

        DoctorApprovalReviewDTO approval =
                result.get();

        if (approval.getTokenUsedAt() != null) {

            throw new ValidationException(
                    "This doctor approval link has already been used."
            );
        }

        LocalDateTime expiresAt =
                approval.getTokenExpiresAt();

        if (expiresAt == null
                || !LocalDateTime.now()
                        .isBefore(expiresAt)) {

            throw new ValidationException(
                    "This doctor approval link has expired."
            );
        }

        if (!"AWAITING_DOCTOR_APPROVAL".equals(
                approval.getCurrentStatus())) {

            throw new ValidationException(
                    "This appointment is no longer awaiting doctor approval."
            );
        }

        return approval;
    }

    private void processDecision(
        String rawToken,
        String decision,
        String targetStatus,
        String decisionNote
    ) throws SQLException, ValidationException {

        DoctorApprovalReviewDTO approval =
                findAndValidateToken(rawToken);

        AppointmentState currentState =
                stateFactory.create(
                        approval.getCurrentStatus()
                );

        AppointmentStateContext context =
                new AppointmentStateContext(
                        currentState
                );

        /*
         * First validate the doctor's requested
         * transition from the current appointment state.
         */
        if (!context.canTransitionTo(targetStatus)) {

            throw new ValidationException(
                    "Invalid appointment transition: "
                    + approval.getCurrentStatus()
                    + " -> "
                    + targetStatus
            );
        }

        String cleanNote =
                decisionNote == null
                        ? null
                        : decisionNote.trim();

        if (cleanNote != null
                && cleanNote.length() > 1000) {

            throw new ValidationException(
                    "Decision note cannot exceed 1000 characters."
            );
        }

        /*
         * Record the doctor's actual decision.
         */
        boolean decisionRecorded =
                approvalDAO.recordDecision(
                        approval.getApprovalId(),
                        decision,
                        cleanNote
                );

        if (!decisionRecorded) {

            throw new SQLException(
                    "Doctor decision could not be recorded."
            );
        }

        /*
         * APPROVED has two business stages:
         *
         * AWAITING_DOCTOR_APPROVAL
         *          ↓
         * DOCTOR_APPROVED
         *          ↓
         * CONFIRMED
         *
         * We keep DOCTOR_APPROVED in the history because
         * it proves the doctor approved the appointment.
         */
        if ("DOCTOR_APPROVED".equals(targetStatus)) {

            updateExternalAppointmentStatus(
                    approval.getAppointmentId(),
                    "DOCTOR_APPROVED"
            );

            updateExternalAppointmentStatus(
                    approval.getAppointmentId(),
                    "CONFIRMED"
            );

            
            publishConfirmationNotification(
                    approval
            );

        } else {

            /*
             * REJECTED and RESCHEDULE_REQUIRED
             * are final outcomes for this approval cycle.
             */
            updateExternalAppointmentStatus(
                    approval.getAppointmentId(),
                    targetStatus
            );
        }

        /*
         * Invalidate the secure doctor link after the
         * decision has been processed.
         */
        boolean tokenUsed =
                approvalDAO.markTokenUsed(
                        approval.getApprovalId()
                );

        if (!tokenUsed) {

            throw new ValidationException(
                    "This approval link has already been used."
            );
        }
    }

    private void validateRawToken(
            String rawToken
    ) throws ValidationException {

        if (rawToken == null
                || rawToken.isBlank()) {

            throw new ValidationException(
                    "Approval token is required."
            );
        }

        if (rawToken.length() > 500) {

            throw new ValidationException(
                    "Invalid approval token."
            );
        }
    }
    
    private void updateExternalAppointmentStatus(
        int appointmentId,
        String statusCode
    ) throws SQLException, ValidationException {

        int statusId =
                statusDAO
                        .findStatusIdByCode(statusCode)
                        .orElseThrow(() ->
                                new SQLException(
                                        "Appointment status is not configured: "
                                        + statusCode
                                )
                        );

        boolean updated =
                appointmentDAO
                        .updateStatusAsExternalActor(
                                appointmentId,
                                statusId
                        );

        if (!updated) {

            throw new SQLException(
                    "Appointment status could not be updated to "
                    + statusCode
            );
        }
    }
    
        private void publishConfirmationNotification(
            DoctorApprovalReviewDTO approval
    ) {

        Notification notification =
                new Notification();

        notification.setRecipientUserId(
                approval.getPatientUserId()
        );

        notification.setAppointmentId(
                approval.getAppointmentId()
        );

        notification.setNotificationType(
                "APPOINTMENT_CONFIRMED"
        );

        notification.setChannel(
                "IN_APP"
        );

        notification.setSubject(
                "Appointment Confirmed"
        );

        String doctorName =
                approval.getDoctorName() == null
                        ? "your selected doctor"
                        : approval.getDoctorName();

        String serviceName =
                approval.getServiceName() == null
                        ? "dental service"
                        : approval.getServiceName();

        String date =
                approval.getRequestedDate() == null
                        ? ""
                        : approval.getRequestedDate().toString();

        String time =
                approval.getRequestedTime() == null
                        ? ""
                        : approval.getRequestedTime().toString();

        notification.setMessage(
                "Your appointment for "
                + serviceName
                + " with "
                + doctorName
                + " has been confirmed for "
                + date
                + " at "
                + time
                + "."
        );

        notification.setNotificationStatus(
                "PENDING"
        );

        notificationSubject.notifyObservers(
                notification
        );
    }
}