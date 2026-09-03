package com.dentalclinic.service.impl;

import com.dentalclinic.dao.AppointmentDAO;
import com.dentalclinic.dao.AppointmentStatusDAO;
import com.dentalclinic.dao.PatientVisitDAO;
import com.dentalclinic.dao.impl.AppointmentDAOImpl;
import com.dentalclinic.dao.impl.AppointmentStatusDAOImpl;
import com.dentalclinic.dao.impl.PatientVisitDAOImpl;
import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.model.Appointment;
import com.dentalclinic.model.PatientVisit;
import com.dentalclinic.service.PatientVisitService;

import java.sql.SQLException;
import java.util.Optional;

public class PatientVisitServiceImpl
        implements PatientVisitService {

    private final PatientVisitDAO patientVisitDAO;
    private final AppointmentDAO appointmentDAO;
    private final AppointmentStatusDAO statusDAO;

    public PatientVisitServiceImpl() {

        this.patientVisitDAO =
                new PatientVisitDAOImpl();

        this.appointmentDAO =
                new AppointmentDAOImpl();

        this.statusDAO =
                new AppointmentStatusDAOImpl();
    }

    @Override
    public int createVisit(
            int appointmentId,
            int recordedByUserId
    ) throws SQLException, ValidationException {

        if (appointmentId <= 0) {
            throw new ValidationException(
                    "Invalid appointment."
            );
        }

        if (recordedByUserId <= 0) {
            throw new ValidationException(
                    "Recording user is required."
            );
        }

        /*
         * The appointment must exist.
         */
        Appointment appointment =
                appointmentDAO.findById(
                        appointmentId
                ).orElseThrow(() ->
                        new ValidationException(
                                "Appointment could not be found."
                        )
                );

        /*
         * Only CONFIRMED or DOCTOR_APPROVED appointments can become
         * patient visits.
         */
        if (!"CONFIRMED".equals(appointment.getStatusCode())
                && !"DOCTOR_APPROVED".equals(appointment.getStatusCode())) {

            throw new ValidationException(
                    "Only confirmed appointments can be checked in."
            );
        }

        /*
         * Prevent duplicate visit records.
         */
        Optional<PatientVisit> existingVisit =
                patientVisitDAO.findByAppointmentId(
                        appointmentId
                );

        if (existingVisit.isPresent()) {

            throw new ValidationException(
                    "A patient visit already exists for this appointment."
            );
        }

        PatientVisit visit =
                new PatientVisit();

        visit.setAppointmentId(
                appointmentId
        );

        visit.setRecordedByUserId(
                recordedByUserId
        );

        return patientVisitDAO.create(
                visit
        );
    }

    @Override
    public Optional<PatientVisit> getVisitById(
            int visitId
    ) throws SQLException {

        return patientVisitDAO.findById(
                visitId
        );
    }

    @Override
    public Optional<PatientVisit>
    getVisitByAppointmentId(
            int appointmentId
    ) throws SQLException {

        return patientVisitDAO.findByAppointmentId(
                appointmentId
        );
    }

    @Override
    public void checkIn(
            int visitId
    ) throws SQLException, ValidationException {

        PatientVisit visit =
                getVisitOrThrow(visitId);

        if (visit.getCheckedInAt() != null) {

            throw new ValidationException(
                    "Patient is already checked in."
            );
        }

        boolean updated =
                patientVisitDAO.updateCheckIn(
                        visitId
                );

        if (!updated) {

            throw new SQLException(
                    "Patient check-in could not be recorded."
            );
        }
    }

    @Override
    public void startConsultation(
            int visitId
    ) throws SQLException, ValidationException {

        PatientVisit visit =
                getVisitOrThrow(visitId);

        if (visit.getCheckedInAt() == null) {

            throw new ValidationException(
                    "Patient must be checked in before consultation starts."
            );
        }

        if (visit.getConsultationStartedAt() != null) {

            throw new ValidationException(
                    "Consultation has already started."
            );
        }

        if (visit.getConsultationCompletedAt() != null) {

            throw new ValidationException(
                    "This consultation has already been completed."
            );
        }

        boolean updated =
                patientVisitDAO
                        .updateConsultationStarted(
                                visitId
                        );

        if (!updated) {

            throw new SQLException(
                    "Consultation start could not be recorded."
            );
        }
    }

    @Override
    public void completeConsultation(
            int visitId,
            String visitNotes
    ) throws SQLException, ValidationException {

        PatientVisit visit =
                getVisitOrThrow(visitId);

        if (visit.getCheckedInAt() == null) {

            throw new ValidationException(
                    "Patient must be checked in."
            );
        }

        if (visit.getConsultationStartedAt() == null) {

            throw new ValidationException(
                    "Consultation must be started before it can be completed."
            );
        }

        if (visit.getConsultationCompletedAt() != null) {

            throw new ValidationException(
                    "Consultation has already been completed."
            );
        }

        String cleanNotes =
                visitNotes == null
                        ? null
                        : visitNotes.trim();

        if (cleanNotes != null
                && cleanNotes.length() > 5000) {

            throw new ValidationException(
                    "Visit notes cannot exceed 5000 characters."
            );
        }

        boolean updated =
                patientVisitDAO.completeVisit(
                        visitId,
                        cleanNotes
                );

        if (!updated) {

            throw new SQLException(
                    "Consultation could not be completed."
            );
        }
    }

    private PatientVisit getVisitOrThrow(
            int visitId
    ) throws SQLException, ValidationException {

        if (visitId <= 0) {

            throw new ValidationException(
                    "Invalid visit."
            );
        }

        return patientVisitDAO.findById(
                visitId
        ).orElseThrow(() ->
                new ValidationException(
                        "Patient visit could not be found."
                )
        );
    }
    
    @Override
    public void recordMedicinePrescribed(
            int visitId,
            boolean prescribed
    ) throws SQLException, ValidationException {

        getVisitOrThrow(visitId);

        boolean updated =
                patientVisitDAO.updateMedicinePrescribed(
                        visitId,
                        prescribed
                );

        if (!updated) {

            throw new SQLException(
                    "Medicine information could not be recorded."
            );
        }
    }
}