package com.dentalclinic.pattern.chain;

import com.dentalclinic.dao.AppointmentDAO;
import com.dentalclinic.dao.impl.AppointmentDAOImpl;
import com.dentalclinic.dto.AppointmentRequestDTO;
import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.model.Service;

import java.sql.SQLException;
import java.time.LocalDateTime;

public class AppointmentConflictValidationHandler
        extends AbstractAppointmentValidationHandler {

    private final AppointmentDAO appointmentDAO;

    private final com.dentalclinic.dao.ServiceDAO serviceDAO;

    public AppointmentConflictValidationHandler() {
        this.appointmentDAO =
                new AppointmentDAOImpl();

        this.serviceDAO =
                new com.dentalclinic.dao.impl.ServiceDAOImpl();
    }

    @Override
    protected void performValidation(
            AppointmentRequestDTO request
    ) throws ValidationException {

        if (request.getDoctorId() == null
                || request.getRequestedDate() == null
                || request.getRequestedTime() == null) {

            throw new ValidationException(
                    "Doctor, date and time are required "
                    + "to check availability."
            );
        }

        try {

            Service service =
                    serviceDAO.findById(
                            request.getServiceId()
                    ).orElseThrow(() ->
                            new ValidationException(
                                    "Selected service was not found."
                            )
                    );

            LocalDateTime start =
                    LocalDateTime.of(
                            request.getRequestedDate(),
                            request.getRequestedTime()
                    );

            LocalDateTime end =
                    start.plusMinutes(
                            service.getDurationMinutes()
                    );

            boolean conflict =
                    appointmentDAO.hasScheduleConflict(
                            request.getDoctorId(),
                            start,
                            end,
                            null
                    );

            if (conflict) {
                throw new ValidationException(
                        "The selected appointment time "
                        + "conflicts with another appointment."
                );
            }

        } catch (SQLException e) {

            throw new ValidationException(
                    "Unable to check appointment availability."
            );

        } catch (ValidationException e) {

            throw e;
        }
    }
}