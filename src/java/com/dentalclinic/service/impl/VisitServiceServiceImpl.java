package com.dentalclinic.service.impl;

import com.dentalclinic.dao.AppointmentDAO;
import com.dentalclinic.dao.ServiceDAO;
import com.dentalclinic.dao.VisitServiceDAO;
import com.dentalclinic.dao.impl.AppointmentDAOImpl;
import com.dentalclinic.dao.impl.ServiceDAOImpl;
import com.dentalclinic.dao.impl.VisitServiceDAOImpl;
import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.model.Appointment;
import com.dentalclinic.model.Service;
import com.dentalclinic.model.VisitService;
import com.dentalclinic.service.VisitServiceService;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public class VisitServiceServiceImpl
        implements VisitServiceService {

    private final VisitServiceDAO visitServiceDAO;
    private final ServiceDAO serviceDAO;
    private final AppointmentDAO appointmentDAO;

    public VisitServiceServiceImpl() {

        this.visitServiceDAO =
                new VisitServiceDAOImpl();

        this.serviceDAO =
                new ServiceDAOImpl();

        this.appointmentDAO =
                new AppointmentDAOImpl();
    }

    @Override
    public int addService(
            int visitId,
            int serviceId,
            int assistantUserId,
            int quantity,
            String treatmentNotes
    ) throws SQLException, ValidationException {

        if (visitId <= 0) {
            throw new ValidationException(
                    "Invalid patient visit."
            );
        }

        if (serviceId <= 0) {
            throw new ValidationException(
                    "Please select a service."
            );
        }

        if (assistantUserId <= 0) {
            throw new ValidationException(
                    "Authenticated assistant is required."
            );
        }

        if (quantity <= 0) {
            throw new ValidationException(
                    "Quantity must be greater than zero."
            );
        }

        /*
         * The service must exist and be active.
         */
        Service service =
                serviceDAO.findById(
                        serviceId
                ).orElseThrow(() ->
                        new ValidationException(
                                "Selected service could not be found."
                        )
                );

        /*
         * The appointment linked to the visit is used
         * to identify the doctor who performed/authorized
         * the treatment.
         */
        Appointment appointment =
                appointmentDAO.findByVisitId(
                        visitId
                ).orElseThrow(() ->
                        new ValidationException(
                                "Appointment for this visit could not be found."
                        )
                );

        if (appointment.getDoctorId() == null
                || appointment.getDoctorId() <= 0) {

            throw new ValidationException(
                    "A doctor must be assigned to the appointment."
            );
        }

        BigDecimal unitPrice =
                service.getStandardPrice();

        if (unitPrice == null
                || unitPrice.compareTo(
                        BigDecimal.ZERO
                ) < 0) {

            throw new ValidationException(
                    "The selected service does not have a valid price."
            );
        }

        BigDecimal lineTotal =
                unitPrice.multiply(
                        BigDecimal.valueOf(quantity)
                );

        String cleanNotes =
                treatmentNotes == null
                        ? null
                        : treatmentNotes.trim();

        if (cleanNotes != null
                && cleanNotes.length() > 1000) {

            throw new ValidationException(
                    "Treatment notes cannot exceed 1000 characters."
            );
        }

        VisitService visitService =
                new VisitService();

        visitService.setVisitId(
                visitId
        );

        visitService.setServiceId(
                serviceId
        );

        visitService.setPerformedByDoctorId(
                appointment.getDoctorId()
        );

        visitService.setQuantity(
                quantity
        );

        visitService.setUnitPrice(
                unitPrice
        );

        visitService.setLineTotal(
                lineTotal
        );

        visitService.setTreatmentNotes(
                cleanNotes
        );

        /*
         * The assistant is the operational user who
         * entered the record, but the doctor associated
         * with the visit remains the clinical actor.
         */
        return visitServiceDAO.create(
                visitService
        );
    }

    @Override
    public List<VisitService> getVisitServices(
            int visitId
    ) throws SQLException {

        if (visitId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid patient visit."
            );
        }

        return visitServiceDAO.findByVisitId(
                visitId
        );
    }

    @Override
    public void removeService(
            int visitServiceId
    ) throws SQLException, ValidationException {

        if (visitServiceId <= 0) {
            throw new ValidationException(
                    "Invalid visit service."
            );
        }

        boolean deleted =
                visitServiceDAO.delete(
                        visitServiceId
                );

        if (!deleted) {
            throw new ValidationException(
                    "Visit service could not be removed."
            );
        }
    }
}