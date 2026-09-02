package com.dentalclinic.service;

import com.dentalclinic.model.PatientVisit;
import com.dentalclinic.exception.ValidationException;

import java.sql.SQLException;
import java.util.Optional;

public interface PatientVisitService {

    int createVisit(
            int appointmentId,
            int recordedByUserId
    ) throws SQLException, ValidationException;

    Optional<PatientVisit> getVisitById(
            int visitId
    ) throws SQLException;

    Optional<PatientVisit> getVisitByAppointmentId(
            int appointmentId
    ) throws SQLException;

    void checkIn(
            int visitId
    ) throws SQLException, ValidationException;

    void startConsultation(
            int visitId
    ) throws SQLException, ValidationException;

    void completeConsultation(
            int visitId,
            String visitNotes
    ) throws SQLException, ValidationException;
    
    void recordMedicinePrescribed(
            int visitId,
            boolean prescribed
    ) throws SQLException, ValidationException;
}