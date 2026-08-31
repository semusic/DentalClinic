package com.dentalclinic.service;

import com.dentalclinic.dto.DoctorApprovalReviewDTO;
import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.model.DoctorApprovalToken;

import java.sql.SQLException;
import java.util.Optional;

public interface DoctorApprovalService {
    
    DoctorApprovalToken createApproval(
        int appointmentId,
        int assistantUserId
    ) throws SQLException, ValidationException;

    Optional<DoctorApprovalReviewDTO> getApprovalByToken(
            String rawToken
    ) throws SQLException, ValidationException;

    void approve(
            String rawToken,
            String decisionNote
    ) throws SQLException, ValidationException;

    void reject(
            String rawToken,
            String decisionNote
    ) throws SQLException, ValidationException;

    void requestReschedule(
            String rawToken,
            String decisionNote
    ) throws SQLException, ValidationException;
}