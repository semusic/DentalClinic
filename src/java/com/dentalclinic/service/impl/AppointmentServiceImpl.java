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
}