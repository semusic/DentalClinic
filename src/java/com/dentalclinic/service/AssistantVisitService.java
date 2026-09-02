package com.dentalclinic.service;

import com.dentalclinic.dto.AssistantVisitDTO;
import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.model.PatientVisit;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface AssistantVisitService {

    List<AssistantVisitDTO> getConfirmedAppointments(
            LocalDate date
    ) throws SQLException;

    Optional<AssistantVisitDTO> getAppointment(
            int appointmentId
    ) throws SQLException;

    int createVisit(
            int appointmentId,
            int assistantUserId
    ) throws SQLException, ValidationException;

    void checkIn(
            int visitId
    ) throws SQLException, ValidationException;

    void startConsultation(
            int visitId
    ) throws SQLException, ValidationException;

    void addAdditionalService(
            int visitId,
            int serviceId,
            int assistantUserId,
            int quantity,
            String notes
    ) throws SQLException, ValidationException;

    void recordMedicinePrescribed(
            int visitId,
            boolean prescribed
    ) throws SQLException, ValidationException;

    void completeConsultation(
            int visitId,
            String visitNotes
    ) throws SQLException, ValidationException;

    Optional<PatientVisit> getVisit(
            int visitId
    ) throws SQLException;
}