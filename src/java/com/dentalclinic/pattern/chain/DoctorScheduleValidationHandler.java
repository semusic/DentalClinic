package com.dentalclinic.pattern.chain;

import com.dentalclinic.dto.AppointmentRequestDTO;
import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.service.DoctorAvailabilityService;
import com.dentalclinic.service.impl.DoctorAvailabilityServiceImpl;

import java.sql.SQLException;

public class DoctorScheduleValidationHandler
        extends AbstractAppointmentValidationHandler {

    private final DoctorAvailabilityService
            availabilityService;

    public DoctorScheduleValidationHandler() {
        this.availabilityService =
                new DoctorAvailabilityServiceImpl();
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

        if (request.getRequestedDate() == null) {
            throw new ValidationException(
                    "Appointment date is required."
            );
        }

        if (request.getRequestedTime() == null) {
            throw new ValidationException(
                    "Appointment time is required."
            );
        }

        try {

            boolean withinWorkingHours =
                    availabilityService.isWithinWorkingHours(
                            request.getDoctorId(),
                            request.getRequestedDate(),
                            request.getRequestedTime()
                    );

            if (!withinWorkingHours) {
                throw new ValidationException(
                        "The selected doctor is not available "
                        + "at the requested date and time."
                );
            }

        } catch (SQLException e) {

            throw new ValidationException(
                    "Unable to verify the doctor's schedule."
            );
        }
    }
}