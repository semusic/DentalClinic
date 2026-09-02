package com.dentalclinic.dao;

import com.dentalclinic.model.PatientVisit;

import java.sql.SQLException;
import java.util.Optional;

public interface PatientVisitDAO {

    int create(
            PatientVisit visit
    ) throws SQLException;

    Optional<PatientVisit> findById(
            int visitId
    ) throws SQLException;

    Optional<PatientVisit> findByAppointmentId(
            int appointmentId
    ) throws SQLException;

    boolean updateCheckIn(
            int visitId
    ) throws SQLException;

    boolean updateConsultationStarted(
            int visitId
    ) throws SQLException;

    boolean completeVisit(
            int visitId,
            String visitNotes
    ) throws SQLException;
    
    boolean updateMedicinePrescribed(
            int visitId,
            boolean prescribed
    ) throws SQLException;
}