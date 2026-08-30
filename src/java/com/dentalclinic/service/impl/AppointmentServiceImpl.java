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

        /*
         * STEP 1
         * Validate the appointment request using
         * the Chain of Responsibility.
         */
        validationChain
                .getFirstHandler()
                .validate(request);

        /*
         * STEP 2
         * Convert the DTO into the Appointment entity.
         */
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

        /*
         * STEP 3
         * Retrieve PENDING status from the database.
         *
         * We do NOT hard-code:
         * statusId = 1
         */
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

        /*
         * STEP 4
         *
         * We intentionally leave this null for now.
         *
         * The authenticated user ID will be supplied
         * from the HTTP session by the AppointmentServlet.
         */
        appointment.setLastModifiedByUserId(
                null
        );

        /*
         * STEP 5
         * Save the appointment.
         */
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