package com.dentalclinic.pattern.chain;

import com.dentalclinic.dao.PatientDAO;
import com.dentalclinic.dao.impl.PatientDAOImpl;
import com.dentalclinic.dto.AppointmentRequestDTO;
import com.dentalclinic.exception.ValidationException;

import java.sql.SQLException;

public class PatientExistenceValidationHandler
        extends AbstractAppointmentValidationHandler {

    private final PatientDAO patientDAO;

    public PatientExistenceValidationHandler() {
        this.patientDAO =
                new PatientDAOImpl();
    }

    @Override
    protected void performValidation(
            AppointmentRequestDTO request
    ) throws ValidationException {

        try {

            boolean exists =
                    patientDAO.findById(
                            request.getPatientId()
                    ).isPresent();

            if (!exists) {
                throw new ValidationException(
                        "Patient account could not be found."
                );
            }

        } catch (SQLException e) {

            throw new ValidationException(
                    "Unable to verify patient information."
            );
        }
    }
}