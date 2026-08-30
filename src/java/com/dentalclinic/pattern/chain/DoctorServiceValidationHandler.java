package com.dentalclinic.pattern.chain;

import com.dentalclinic.dao.DoctorDAO;
import com.dentalclinic.dao.impl.DoctorDAOImpl;
import com.dentalclinic.dao.ServiceDAO;
import com.dentalclinic.dao.impl.ServiceDAOImpl;
import com.dentalclinic.dto.AppointmentRequestDTO;
import com.dentalclinic.exception.ValidationException;

import java.sql.SQLException;

public class DoctorServiceValidationHandler
        extends AbstractAppointmentValidationHandler {

    private final DoctorDAO doctorDAO;
    private final ServiceDAO serviceDAO;

    public DoctorServiceValidationHandler() {
        this.doctorDAO = new DoctorDAOImpl();
        this.serviceDAO = new ServiceDAOImpl();
    }

    @Override
    protected void performValidation(
            AppointmentRequestDTO request
    ) throws ValidationException {

        if (request.getDoctorId() == null) {
            throw new ValidationException(
                    "A doctor must be selected."
            );
        }

        try {

            boolean doctorExists =
                    doctorDAO.findById(
                            request.getDoctorId()
                    ).isPresent();

            if (!doctorExists) {
                throw new ValidationException(
                        "Selected doctor does not exist or is inactive."
                );
            }

            boolean serviceExists =
                    serviceDAO.findById(
                            request.getServiceId()
                    ).isPresent();

            if (!serviceExists) {
                throw new ValidationException(
                        "Selected dental service does not exist."
                );
            }

            boolean doctorProvidesService =
                    doctorDAO.findByServiceId(
                            request.getServiceId()
                    )
                    .stream()
                    .anyMatch(
                            doctor ->
                                    doctor.getDoctorId()
                                            == request.getDoctorId()
                    );

            if (!doctorProvidesService) {
                throw new ValidationException(
                        "Selected doctor does not provide the selected service."
                );
            }

        } catch (SQLException e) {

            throw new ValidationException(
                    "Unable to verify doctor and service information."
            );
        }
    }
}