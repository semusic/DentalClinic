package com.dentalclinic.dao;

import com.dentalclinic.dto.DoctorApprovalReviewDTO;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.Optional;

public interface DoctorApprovalDAO {

    int createApproval(
            int appointmentId,
            int doctorId,
            String tokenHash,
            LocalDateTime tokenExpiresAt,
            int recordedByUserId
    ) throws SQLException;
    
    Optional<DoctorApprovalReviewDTO> findByAppointmentId(
        int appointmentId
    ) throws SQLException;

    Optional<DoctorApprovalReviewDTO> findByTokenHash(
            String tokenHash
    ) throws SQLException;

    boolean markTokenUsed(
            int approvalId
    ) throws SQLException;

    boolean recordDecision(
            int approvalId,
            String decision,
            String decisionNote
    ) throws SQLException;
}