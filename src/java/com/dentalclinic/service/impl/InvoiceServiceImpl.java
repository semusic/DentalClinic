package com.dentalclinic.service.impl;

import com.dentalclinic.dao.AppointmentDAO;
import com.dentalclinic.dao.InvoiceDAO;
import com.dentalclinic.dao.InvoiceItemDAO;
import com.dentalclinic.dao.PatientVisitDAO;
import com.dentalclinic.dao.ServiceDAO;

import com.dentalclinic.dao.impl.AppointmentDAOImpl;
import com.dentalclinic.dao.impl.InvoiceDAOImpl;
import com.dentalclinic.dao.impl.InvoiceItemDAOImpl;
import com.dentalclinic.dao.impl.PatientVisitDAOImpl;
import com.dentalclinic.dao.impl.ServiceDAOImpl;

import com.dentalclinic.exception.ValidationException;

import com.dentalclinic.model.Appointment;
import com.dentalclinic.model.Invoice;
import com.dentalclinic.model.InvoiceItem;
import com.dentalclinic.model.PatientVisit;
import com.dentalclinic.model.Service;
import com.dentalclinic.model.VisitService;
import com.dentalclinic.service.QrTokenService;

import com.dentalclinic.service.InvoiceService;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public class InvoiceServiceImpl
        implements InvoiceService {

    private final InvoiceDAO invoiceDAO;
    private final InvoiceItemDAO invoiceItemDAO;
    private final PatientVisitDAO patientVisitDAO;
    private final AppointmentDAO appointmentDAO;
    private final ServiceDAO serviceDAO;
    private final VisitServiceServiceImpl visitServiceService;

    private final QrTokenService qrTokenService;
    
    
    public InvoiceServiceImpl() {

        this.invoiceDAO =
                new InvoiceDAOImpl();

        this.invoiceItemDAO =
                new InvoiceItemDAOImpl();

        this.patientVisitDAO =
                new PatientVisitDAOImpl();

        this.appointmentDAO =
                new AppointmentDAOImpl();

        this.serviceDAO =
                new ServiceDAOImpl();

        this.visitServiceService =
                new VisitServiceServiceImpl();
        
        this.qrTokenService =
                new QrTokenService();
    }

    @Override
    public int generateInvoice(
            int visitId,
            int cashierUserId
    ) throws SQLException, ValidationException {

        if (visitId <= 0) {

            throw new ValidationException(
                    "Invalid patient visit."
            );
        }

        if (cashierUserId <= 0) {

            throw new ValidationException(
                    "Invalid cashier user."
            );
        }

        /*
         * The visit must exist.
         */
        PatientVisit visit =
                patientVisitDAO.findById(
                        visitId
                ).orElseThrow(() ->
                        new ValidationException(
                                "Patient visit could not be found."
                        )
                );

        /*
         * Invoice can only be generated after
         * consultation is completed.
         */
        if (visit.getConsultationCompletedAt()
                == null) {

            throw new ValidationException(
                    "Invoice can only be generated after the consultation is completed."
            );
        }

        /*
         * Prevent duplicate invoices for the
         * same visit.
         */
        Optional<Invoice> existingInvoice =
                invoiceDAO.findByVisitId(
                        visitId
                );

        if (existingInvoice.isPresent()) {

            throw new ValidationException(
                    "An invoice already exists for this visit."
            );
        }

        /*
         * Find the appointment linked to the visit.
         */
        Appointment appointment =
                appointmentDAO.findByVisitId(
                        visitId
                ).orElseThrow(() ->
                        new ValidationException(
                                "Appointment for this visit could not be found."
                        )
                );

        if (appointment.getPatientId() <= 0) {

            throw new ValidationException(
                    "Patient information could not be determined."
            );
        }

        /*
         * Read all services actually performed.
         */
        List<VisitService> visitServices =
                visitServiceService.getVisitServices(
                        visitId
                );

        if (visitServices.isEmpty()) {

            throw new ValidationException(
                    "No billable services have been recorded for this visit."
            );
        }

        BigDecimal subtotal =
                BigDecimal.ZERO;

        List<InvoiceItem> items =
                new ArrayList<>();

        for (VisitService visitService :
                visitServices) {

            if (visitService.getQuantity() <= 0) {

                throw new ValidationException(
                        "Invalid service quantity."
                );
            }

            if (visitService.getUnitPrice()
                    == null) {

                throw new ValidationException(
                        "A service is missing its unit price."
                );
            }

            if (visitService.getLineTotal()
                    == null) {

                throw new ValidationException(
                        "A service is missing its line total."
                );
            }

            Service service =
                    serviceDAO.findById(
                            visitService
                                    .getServiceId()
                    ).orElseThrow(() ->
                            new ValidationException(
                                    "A billed service could not be found."
                            )
                    );

            BigDecimal lineTotal =
                    visitService.getLineTotal();

            subtotal =
                    subtotal.add(
                            lineTotal
                    );

            InvoiceItem item =
                    new InvoiceItem();

            item.setServiceId(
                    visitService.getServiceId()
            );

            item.setItemDescription(
                    service.getServiceName()
            );

            item.setQuantity(
                    visitService.getQuantity()
            );

            item.setUnitPrice(
                    visitService.getUnitPrice()
            );

            item.setLineTotal(
                    lineTotal
            );

            items.add(item);
        }

        BigDecimal discountAmount =
                BigDecimal.ZERO;

        BigDecimal taxAmount =
                BigDecimal.ZERO;

        BigDecimal totalAmount =
                subtotal
                        .subtract(discountAmount)
                        .add(taxAmount);

        /*
         * Generate a unique human-readable
         * invoice number.
         */
        String invoiceNumber =
                generateInvoiceNumber();

        Invoice invoice =
                new Invoice();

        invoice.setVisitId(
                visitId
        );

        invoice.setPatientId(
                appointment.getPatientId()
        );

        invoice.setInvoiceNumber(
                invoiceNumber
        );

        invoice.setSubtotal(
                subtotal
        );

        invoice.setDiscountAmount(
                discountAmount
        );

        invoice.setTaxAmount(
                taxAmount
        );

        invoice.setTotalAmount(
                totalAmount
        );

        invoice.setInvoiceStatus(
                "UNPAID"
        );

        invoice.setDueDate(
                LocalDate.now()
        );

        invoice.setCreatedByUserId(
                cashierUserId
        );

        /*
         * Create invoice header.
         */
        int invoiceId =
                invoiceDAO.create(
                        invoice
                );

        /*
         * Create invoice lines.
         */
        for (InvoiceItem item :
                items) {

            item.setInvoiceId(
                    invoiceId
            );

            invoiceItemDAO.create(
                    item
            );
        }

        return invoiceId;
    }

    @Override
    public Invoice getInvoice(
            int invoiceId
    ) throws SQLException, ValidationException {

        if (invoiceId <= 0) {

            throw new ValidationException(
                    "Invalid invoice."
            );
        }

        return invoiceDAO.findById(
                invoiceId
        ).orElseThrow(() ->
                new ValidationException(
                        "Invoice could not be found."
                )
        );
    }

    @Override
    public List<InvoiceItem> getInvoiceItems(
            int invoiceId
    ) throws SQLException {

        return invoiceItemDAO.findByInvoiceId(
                invoiceId
        );
    }

    private String generateInvoiceNumber() {

        String date =
                LocalDateTime.now()
                        .format(
                                DateTimeFormatter
                                        .ofPattern(
                                                "yyyyMMdd"
                                        )
                        );

        String uniquePart =
                UUID.randomUUID()
                        .toString()
                        .replace(
                                "-",
                                ""
                        )
                        .substring(
                                0,
                                8
                        )
                        .toUpperCase();

        return "INV-"
                + date
                + "-"
                + uniquePart;
    }
    
    @Override
public List<Invoice> getInvoiceHistory()
        throws SQLException {

    return invoiceDAO.findAll();
}

    @Override
public void voidInvoice(
            int invoiceId,
            int cashierUserId,
            String reason
    ) throws SQLException, ValidationException {

        if (invoiceId <= 0) {

            throw new ValidationException(
                    "Invalid invoice."
            );
        }

        if (cashierUserId <= 0) {

            throw new ValidationException(
                    "Invalid cashier user."
            );
        }

        String cleanReason =
                reason == null
                        ? ""
                        : reason.trim();

        if (cleanReason.isBlank()) {

            throw new ValidationException(
                    "A reason is required when voiding an invoice."
            );
        }

        if (cleanReason.length() > 500) {

            throw new ValidationException(
                    "Void reason cannot exceed 500 characters."
            );
        }

        Invoice invoice =
                invoiceDAO.findById(
                        invoiceId
                ).orElseThrow(() ->
                        new ValidationException(
                                "Invoice could not be found."
                        )
                );

        /*
         * Only an unpaid invoice can be voided.
         *
         * Paid invoices must remain as financial history.
         */
        if (!"UNPAID".equalsIgnoreCase(
                invoice.getInvoiceStatus())) {

            throw new ValidationException(
                    "Only unpaid invoices can be voided."
            );
        }

        boolean voided =
                invoiceDAO.voidInvoice(
                        invoiceId,
                        cashierUserId,
                        cleanReason
                );

        if (!voided) {

            throw new ValidationException(
                    "Invoice could not be voided. It may have already been paid or voided."
            );
        }
    }
        @Override
    public String generateQrToken(
            int invoiceId
    ) throws SQLException, ValidationException {

        if (invoiceId <= 0) {

            throw new ValidationException(
                    "Invalid invoice."
            );
        }

        Invoice invoice =
                invoiceDAO.findById(
                        invoiceId
                ).orElseThrow(() ->
                        new ValidationException(
                                "Invoice could not be found."
                        )
                );

        /*
         * QR should only be issued for a paid bill.
         */
        if (!"PAID".equalsIgnoreCase(
                invoice.getInvoiceStatus())) {

            throw new ValidationException(
                    "A patient QR can only be generated after payment is completed."
            );
        }

        /*
         * Generate a fresh random token.
         */
        String rawToken =
                qrTokenService.generateToken();

        String hash =
                qrTokenService.hashToken(
                        rawToken
                );

        boolean saved =
        invoiceDAO.saveQrToken(
                invoiceId,
                rawToken,
                hash
        );

        if (!saved) {

            throw new SQLException(
                    "Unable to save QR token."
            );
        }

        /*
         * Return the raw token only to the current
         * receipt-generation request.
         */
        return rawToken;
    }

}