package com.dentalclinic.pattern.chain;

import com.dentalclinic.dao.ServiceDAO;
import com.dentalclinic.dao.impl.ServiceDAOImpl;
import com.dentalclinic.dto.AppointmentRequestDTO;
import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.model.Service;
import com.dentalclinic.service.DoctorAvailabilityService;
import com.dentalclinic.service.impl.DoctorAvailabilityServiceImpl;

import java.sql.SQLException;
import java.util.Optional;

public class DoctorScheduleValidationHandler extends AbstractAppointmentValidationHandler {

    private final DoctorAvailabilityService availabilityService;
    private final ServiceDAO serviceDAO;

    public DoctorScheduleValidationHandler() {
        this.availabilityService = new DoctorAvailabilityServiceImpl();
        this.serviceDAO = new ServiceDAOImpl();
    }

    @Override
    protected void performValidation(AppointmentRequestDTO request) throws ValidationException {
        if (request.getDoctorId() == null) {
            throw new ValidationException("A doctor must be selected.");
        }
        if (request.getRequestedDate() == null) {
            throw new ValidationException("Appointment date is required.");
        }
        if (request.getRequestedTime() == null) {
            throw new ValidationException("Appointment time is required.");
        }

        try {
            int durationMinutes = 30; // default
            Optional<Service> serviceOpt = serviceDAO.findById(request.getServiceId());
            if (serviceOpt.isPresent()) {
                durationMinutes = serviceOpt.get().getDurationMinutes();
            }

            boolean withinWorkingHours = availabilityService.isWithinWorkingHours(
                    request.getDoctorId(),
                    request.getRequestedDate(),
                    request.getRequestedTime(),
                    durationMinutes
            );

            if (!withinWorkingHours) {
                throw new ValidationException(
                        "The selected doctor is unavailable at the requested time slot " +
                        "(the procedure duration extends outside the doctor's working schedule)."
                );
            }

        } catch (SQLException e) {
            throw new ValidationException("Unable to verify the doctor's schedule.");
        }
    }
}