package com.dentalclinic.pattern.chain;

import com.dentalclinic.dao.ServiceDAO;
import com.dentalclinic.dao.impl.ServiceDAOImpl;
import com.dentalclinic.dto.AppointmentRequestDTO;
import com.dentalclinic.exception.ValidationException;

import java.sql.SQLException;

public class ServiceAvailabilityValidationHandler
        extends AbstractAppointmentValidationHandler {

    private final ServiceDAO serviceDAO;

    public ServiceAvailabilityValidationHandler() {
        this.serviceDAO =
                new ServiceDAOImpl();
    }

    @Override
    protected void performValidation(
            AppointmentRequestDTO request
    ) throws ValidationException {

        try {

            var service =
                    serviceDAO.findById(
                            request.getServiceId()
                    );

            if (service.isEmpty()) {
                throw new ValidationException(
                        "Selected dental service does not exist."
                );
            }

            if (!service.get().isActive()) {
                throw new ValidationException(
                        "Selected dental service is currently unavailable."
                );
            }

        } catch (SQLException e) {

            throw new ValidationException(
                    "Unable to verify the selected dental service."
            );
        }
    }
}