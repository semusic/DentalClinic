package com.dentalclinic.dao;

import com.dentalclinic.dto.AppointmentReviewDTO;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface AppointmentReviewDAO {

    List<AppointmentReviewDTO> findPendingReviews()
            throws SQLException;

    Optional<AppointmentReviewDTO> findReviewById(
            int appointmentId
    ) throws SQLException;
}