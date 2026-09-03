package com.dentalclinic.service.impl;

import com.dentalclinic.dao.AppointmentDAO;
import com.dentalclinic.dao.AppointmentStatusDAO;
import com.dentalclinic.dao.impl.AppointmentDAOImpl;
import com.dentalclinic.dao.impl.AppointmentStatusDAOImpl;
import com.dentalclinic.dto.AppointmentRequestDTO;
import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.model.Appointment;
import com.dentalclinic.pattern.chain.AppointmentValidationChain;
import com.dentalclinic.service.AppointmentService;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class AppointmentServiceImpl
        implements AppointmentService {

    private final AppointmentDAO appointmentDAO;
    private final AppointmentStatusDAO statusDAO;
    private final AppointmentValidationChain validationChain;

    public AppointmentServiceImpl() {

        this.appointmentDAO =
                new AppointmentDAOImpl();

        this.statusDAO =
                new AppointmentStatusDAOImpl();

        this.validationChain =
                new AppointmentValidationChain();
    }

    @Override
    public int requestAppointment(
            AppointmentRequestDTO request
    ) throws SQLException, ValidationException {

        
        validationChain
                .getFirstHandler()
                .validate(request);

        
        Appointment appointment =
                new Appointment();

        appointment.setPatientId(
                request.getPatientId()
        );

        appointment.setServiceId(
                request.getServiceId()
        );

        appointment.setDoctorId(
                request.getDoctorId()
        );

        appointment.setRequestedDate(
                request.getRequestedDate()
        );

        appointment.setRequestedTime(
                request.getRequestedTime()
        );

        appointment.setPatientReason(
                request.getPatientReason()
        );

     
        int pendingStatusId =
                statusDAO
                        .findStatusIdByCode("PENDING")
                        .orElseThrow(() ->
                                new SQLException(
                                        "PENDING appointment status is not configured."
                                )
                        );

        appointment.setStatusId(
                pendingStatusId
        );

       
        appointment.setLastModifiedByUserId(
        request.getRequestingUserId()
        );

        return appointmentDAO.save(
                appointment
        );
    }

    @Override
    public Optional<Appointment> findById(
            int appointmentId
    ) throws SQLException {

        return appointmentDAO.findById(
                appointmentId
        );
    }

    @Override
    public List<Appointment> getPatientAppointments(
            int patientId
    ) throws SQLException {

        return appointmentDAO.findByPatientId(
                patientId
        );
    }

    @Override
    public List<Appointment> getPendingRequests()
            throws SQLException {

        return appointmentDAO.findPendingRequests();
    }

    @Override
    public void rescheduleAppointment(
            int appointmentId,
            java.time.LocalDate newDate,
            java.time.LocalTime newTime,
            int requestingUserId
    ) throws SQLException, ValidationException {

        if (appointmentId <= 0) {
            throw new ValidationException("Invalid appointment ID.");
        }
        if (newDate == null || newTime == null) {
            throw new ValidationException("New date and time are required for rescheduling.");
        }

        Appointment existing = appointmentDAO.findById(appointmentId).orElseThrow(() ->
                new ValidationException("Appointment could not be found.")
        );

        if (!"RESCHEDULE_REQUIRED".equalsIgnoreCase(existing.getStatusCode())
                && !"PENDING".equalsIgnoreCase(existing.getStatusCode())
                && !"AWAITING_DOCTOR_APPROVAL".equalsIgnoreCase(existing.getStatusCode())) {
            throw new ValidationException("Only appointments requiring reschedule or pending review can be rescheduled.");
        }

        AppointmentRequestDTO requestDTO = new AppointmentRequestDTO();
        requestDTO.setPatientId(existing.getPatientId());
        requestDTO.setDoctorId(existing.getDoctorId());
        requestDTO.setServiceId(existing.getServiceId());
        requestDTO.setRequestedDate(newDate);
        requestDTO.setRequestedTime(newTime);
        requestDTO.setRequestingUserId(requestingUserId);
        requestDTO.setPatientReason(existing.getPatientReason());

        // Validate new slot
        validationChain.getFirstHandler().validate(requestDTO);

        int pendingStatusId = statusDAO.findStatusIdByCode("PENDING")
                .orElseThrow(() -> new SQLException("PENDING status not configured."));

        boolean updated = appointmentDAO.rescheduleAppointment(
                appointmentId,
                newDate,
                newTime,
                pendingStatusId,
                requestingUserId
        );

        if (!updated) {
            throw new SQLException("Unable to update appointment for rescheduling.");
        }
    }
}