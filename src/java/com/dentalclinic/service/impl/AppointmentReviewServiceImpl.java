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

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class AppointmentReviewServiceImpl
        implements AppointmentReviewService {

    private final AppointmentReviewDAO reviewDAO;
    private final AppointmentDAO appointmentDAO;
    private final AppointmentStatusDAO statusDAO;
    private final AppointmentStateFactory stateFactory;

    public AppointmentReviewServiceImpl() {

        this.reviewDAO =
                new AppointmentReviewDAOImpl();

        this.appointmentDAO =
                new AppointmentDAOImpl();

        this.statusDAO =
                new AppointmentStatusDAOImpl();

        this.stateFactory =
                new AppointmentStateFactory();
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
    public void sendToDoctor(
            int appointmentId,
            int assistantUserId
    ) throws SQLException, ValidationException {

        transitionAppointment(
                appointmentId,
                assistantUserId,
                "AWAITING_DOCTOR_APPROVAL",
                "Appointment sent to doctor for approval."
        );
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