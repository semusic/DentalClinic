package com.dentalclinic.service;

import com.dentalclinic.dto.AppointmentRequestDTO;
import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.model.Appointment;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface AppointmentService {

    int requestAppointment(
            AppointmentRequestDTO request
    ) throws SQLException, ValidationException;

    Optional<Appointment> findById(
            int appointmentId
    ) throws SQLException;

    List<Appointment> getPatientAppointments(
            int patientId
    ) throws SQLException;

    List<Appointment> getPendingRequests()
            throws SQLException;

    void rescheduleAppointment(
            int appointmentId,
            java.time.LocalDate newDate,
            java.time.LocalTime newTime,
            int requestingUserId
    ) throws SQLException, ValidationException;
}