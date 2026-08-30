package com.dentalclinic.pattern.chain;

import com.dentalclinic.dto.AppointmentRequestDTO;
import com.dentalclinic.exception.ValidationException;

public class BasicAppointmentValidationHandler
        extends AbstractAppointmentValidationHandler {

    @Override
    protected void performValidation(
            AppointmentRequestDTO request
    ) throws ValidationException {

        if (request == null) {
            throw new ValidationException(
                    "Appointment request is required."
            );
        }

        if (request.getPatientId() <= 0) {
            throw new ValidationException(
                    "A valid patient is required."
            );
        }

        if (request.getRequestingUserId() <= 0) {
            throw new ValidationException(
                    "Authenticated user information is required."
            );
        }
        
        if (request.getServiceId() <= 0) {
            throw new ValidationException(
                    "A valid dental service is required."
            );
        }

        if (request.getDoctorId() == null
                || request.getDoctorId() <= 0) {

            throw new ValidationException(
                    "A doctor must be selected."
            );
        }

        if (request.getRequestedDate() == null) {
            throw new ValidationException(
                    "Appointment date is required."
            );
        }

        if (request.getRequestedDate().isBefore(
                java.time.LocalDate.now())) {

            throw new ValidationException(
                    "Appointment date cannot be in the past."
            );
        }

        if (request.getRequestedTime() == null) {
            throw new ValidationException(
                    "Appointment time is required."
            );
        }

        if (request.getPatientReason() != null
                && request.getPatientReason().length() > 2000) {

            throw new ValidationException(
                    "Reason cannot exceed 2000 characters."
            );
        }
    }
}