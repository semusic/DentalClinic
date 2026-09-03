package com.dentalclinic.service.impl;

import com.dentalclinic.dao.AssistantVisitDAO;
import com.dentalclinic.dao.PatientVisitDAO;
import com.dentalclinic.dao.impl.AssistantVisitDAOImpl;
import com.dentalclinic.dao.impl.PatientVisitDAOImpl;
import com.dentalclinic.dto.AssistantVisitDTO;
import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.model.PatientVisit;
import com.dentalclinic.service.AssistantVisitService;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public class AssistantVisitServiceImpl
        implements AssistantVisitService {

    private final AssistantVisitDAO assistantVisitDAO;
    private final PatientVisitDAO patientVisitDAO;

    private final PatientVisitServiceImpl patientVisitService;
    private final VisitServiceServiceImpl visitServiceService;

    public AssistantVisitServiceImpl() {

        this.assistantVisitDAO =
                new AssistantVisitDAOImpl();

        this.patientVisitDAO =
                new PatientVisitDAOImpl();

        this.patientVisitService =
                new PatientVisitServiceImpl();

        this.visitServiceService =
                new VisitServiceServiceImpl();
    }

    @Override
    public List<AssistantVisitDTO>
    getConfirmedAppointments(
            LocalDate date
    ) throws SQLException {

        return assistantVisitDAO
                .findConfirmedAppointments(date);
    }

    @Override
    public Optional<AssistantVisitDTO>
    getAppointment(
            int appointmentId
    ) throws SQLException {

        if (appointmentId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid appointment."
            );
        }

        return assistantVisitDAO
                .findByAppointmentId(
                        appointmentId
                );
    }

    @Override
    public int createVisit(
            int appointmentId,
            int assistantUserId
    ) throws SQLException, ValidationException {

        if (appointmentId <= 0) {

            throw new ValidationException(
                    "Invalid appointment."
            );
        }

        if (assistantUserId <= 0) {

            throw new ValidationException(
                    "Invalid assistant user."
            );
        }

        /*
         * Create the actual patient visit.
         */
        int visitId =
                patientVisitService.createVisit(
                        appointmentId,
                        assistantUserId
                );

        /*
         * Retrieve the appointment so that the
         * originally booked service can be recorded
         * as the first service of the visit.
         */
        AssistantVisitDTO appointment =
                assistantVisitDAO
                        .findByAppointmentId(
                                appointmentId
                        )
                        .orElseThrow(() ->
                                new ValidationException(
                                        "Appointment could not be found."
                                )
                        );

        /*
         * The booked service becomes the initial
         * service performed for this visit.
         *
         * Additional services can then be added later
         * by the assistant when authorized/performed
         * by the doctor.
         */
        visitServiceService.addService(
                visitId,
                appointment.getServiceId(),
                assistantUserId,
                1,
                "Originally booked service"
        );

        return visitId;
    }

    @Override
    public void checkIn(
            int visitId
    ) throws SQLException, ValidationException {

        patientVisitService.checkIn(
                visitId
        );
    }

    @Override
    public void startConsultation(
            int visitId
    ) throws SQLException, ValidationException {

        patientVisitService.startConsultation(
                visitId
        );
    }

    @Override
    public void addAdditionalService(
            int visitId,
            int serviceId,
            int assistantUserId,
            int quantity,
            String notes
    ) throws SQLException, ValidationException {

        /*
         * The assistant records the service that the
         * doctor authorized/performed.
         *
         * The doctor is determined from the appointment
         * linked to this visit.
         */
        visitServiceService.addService(
                visitId,
                serviceId,
                assistantUserId,
                quantity,
                notes
        );
    }

    @Override
    public void recordMedicinePrescribed(
            int visitId,
            boolean prescribed
    ) throws SQLException, ValidationException {

        patientVisitService
                .recordMedicinePrescribed(
                        visitId,
                        prescribed
                );
    }

    @Override
    public void completeConsultation(
            int visitId,
            String visitNotes
    ) throws SQLException, ValidationException {

        patientVisitService.completeConsultation(
                visitId,
                visitNotes
        );
    }

    @Override
    public Optional<PatientVisit> getVisit(
            int visitId
    ) throws SQLException {

        if (visitId <= 0) {

            throw new IllegalArgumentException(
                    "Invalid visit."
            );
        }

        return patientVisitDAO.findById(
                visitId
        );
    }
}