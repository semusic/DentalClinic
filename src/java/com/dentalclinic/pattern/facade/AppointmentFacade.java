package com.dentalclinic.pattern.facade;

import com.dentalclinic.dto.AppointmentRequestDTO;
import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.model.Appointment;
import com.dentalclinic.service.AppointmentService;
import com.dentalclinic.service.impl.AppointmentServiceImpl;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class AppointmentFacade {

    private final AppointmentService appointmentService;

    public AppointmentFacade() {
        this.appointmentService =
                new AppointmentServiceImpl();
    }

    public int requestAppointment(
            AppointmentRequestDTO request
    ) throws SQLException, ValidationException {

        return appointmentService.requestAppointment(
                request
        );
    }

    public Optional<Appointment> getAppointment(
            int appointmentId
    ) throws SQLException {

        return appointmentService.findById(
                appointmentId
        );
    }

    public List<Appointment> getPatientAppointments(
            int patientId
    ) throws SQLException {

        return appointmentService.getPatientAppointments(
                patientId
        );
    }

    public List<Appointment> getPendingRequests()
            throws SQLException {

        return appointmentService.getPendingRequests();
    }

    public void rescheduleAppointment(
            int appointmentId,
            java.time.LocalDate newDate,
            java.time.LocalTime newTime,
            int requestingUserId
    ) throws SQLException, ValidationException {

        appointmentService.rescheduleAppointment(
                appointmentId,
                newDate,
                newTime,
                requestingUserId
        );
    }
}