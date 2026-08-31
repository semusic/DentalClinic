package com.dentalclinic.service;

import com.dentalclinic.dto.AppointmentReviewDTO;
import com.dentalclinic.exception.ValidationException;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface AppointmentReviewService {

    List<AppointmentReviewDTO> getPendingReviews()
            throws SQLException;

    Optional<AppointmentReviewDTO> getReviewById(
            int appointmentId
    ) throws SQLException;
    
    void startReview(
        int appointmentId,
        int assistantUserId
    ) throws SQLException, ValidationException;

    void sendToDoctor(
            int appointmentId,
            int assistantUserId
    ) throws SQLException, ValidationException;
}