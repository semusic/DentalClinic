package com.dentalclinic.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class PatientRecordDTO {

    private String patientName;
    private String patientPhone;
    private String patientEmail;

    private int visitId;

    private LocalDateTime appointmentDateTime;
    private LocalDateTime checkedInAt;
    private LocalDateTime consultationStartedAt;
    private LocalDateTime consultationCompletedAt;

    private String doctorName;

    private String invoiceNumber;
    private BigDecimal invoiceTotal;
    private BigDecimal totalPaid;

    private boolean medicinePrescribed;
    private String visitNotes;

    private String latestReceiptNumber;

    private List<ServiceRecord> services =
            new ArrayList<>();

    private List<PaymentRecord> payments =
            new ArrayList<>();

    public PatientRecordDTO() {
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public String getPatientPhone() {
        return patientPhone;
    }

    public void setPatientPhone(String patientPhone) {
        this.patientPhone = patientPhone;
    }

    public String getPatientEmail() {
        return patientEmail;
    }

    public void setPatientEmail(String patientEmail) {
        this.patientEmail = patientEmail;
    }

    public int getVisitId() {
        return visitId;
    }

    public void setVisitId(int visitId) {
        this.visitId = visitId;
    }

    public LocalDateTime getAppointmentDateTime() {
        return appointmentDateTime;
    }

    public void setAppointmentDateTime(
            LocalDateTime appointmentDateTime) {

        this.appointmentDateTime =
                appointmentDateTime;
    }

    public LocalDateTime getCheckedInAt() {
        return checkedInAt;
    }

    public void setCheckedInAt(
            LocalDateTime checkedInAt) {

        this.checkedInAt = checkedInAt;
    }

    public LocalDateTime getConsultationStartedAt() {
        return consultationStartedAt;
    }

    public void setConsultationStartedAt(
            LocalDateTime consultationStartedAt) {

        this.consultationStartedAt =
                consultationStartedAt;
    }

    public LocalDateTime getConsultationCompletedAt() {
        return consultationCompletedAt;
    }

    public void setConsultationCompletedAt(
            LocalDateTime consultationCompletedAt) {

        this.consultationCompletedAt =
                consultationCompletedAt;
    }

    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }

    public String getInvoiceNumber() {
        return invoiceNumber;
    }

    public void setInvoiceNumber(String invoiceNumber) {
        this.invoiceNumber = invoiceNumber;
    }

    public BigDecimal getInvoiceTotal() {
        return invoiceTotal;
    }

    public void setInvoiceTotal(
            BigDecimal invoiceTotal) {

        this.invoiceTotal = invoiceTotal;
    }

    public BigDecimal getTotalPaid() {
        return totalPaid;
    }

    public void setTotalPaid(
            BigDecimal totalPaid) {

        this.totalPaid = totalPaid;
    }

    public boolean isMedicinePrescribed() {
        return medicinePrescribed;
    }

    public void setMedicinePrescribed(
            boolean medicinePrescribed) {

        this.medicinePrescribed =
                medicinePrescribed;
    }

    public String getVisitNotes() {
        return visitNotes;
    }

    public void setVisitNotes(
            String visitNotes) {

        this.visitNotes = visitNotes;
    }

    public String getLatestReceiptNumber() {
        return latestReceiptNumber;
    }

    public void setLatestReceiptNumber(
            String latestReceiptNumber) {

        this.latestReceiptNumber =
                latestReceiptNumber;
    }

    public List<ServiceRecord> getServices() {
        return services;
    }

    public void setServices(
            List<ServiceRecord> services) {

        this.services = services;
    }

    public List<PaymentRecord> getPayments() {
        return payments;
    }

    public void setPayments(
            List<PaymentRecord> payments) {

        this.payments = payments;
    }

    public static class ServiceRecord {

        private String serviceName;
        private int quantity;
        private BigDecimal unitPrice;
        private BigDecimal lineTotal;

        public ServiceRecord() {
        }

        public String getServiceName() {
            return serviceName;
        }

        public void setServiceName(
                String serviceName) {

            this.serviceName = serviceName;
        }

        public int getQuantity() {
            return quantity;
        }

        public void setQuantity(int quantity) {
            this.quantity = quantity;
        }

        public BigDecimal getUnitPrice() {
            return unitPrice;
        }

        public void setUnitPrice(
                BigDecimal unitPrice) {

            this.unitPrice = unitPrice;
        }

        public BigDecimal getLineTotal() {
            return lineTotal;
        }

        public void setLineTotal(
                BigDecimal lineTotal) {

            this.lineTotal = lineTotal;
        }
    }

    public static class PaymentRecord {

        private String paymentReference;
        private BigDecimal amount;
        private String paymentMethod;
        private String paymentStatus;
        private LocalDateTime transactionDate;
        private String receiptNumber;

        public PaymentRecord() {
        }

        public String getPaymentReference() {
            return paymentReference;
        }

        public void setPaymentReference(
                String paymentReference) {

            this.paymentReference =
                    paymentReference;
        }

        public BigDecimal getAmount() {
            return amount;
        }

        public void setAmount(
                BigDecimal amount) {

            this.amount = amount;
        }

        public String getPaymentMethod() {
            return paymentMethod;
        }

        public void setPaymentMethod(
                String paymentMethod) {

            this.paymentMethod =
                    paymentMethod;
        }

        public String getPaymentStatus() {
            return paymentStatus;
        }

        public void setPaymentStatus(
                String paymentStatus) {

            this.paymentStatus =
                    paymentStatus;
        }

        public LocalDateTime getTransactionDate() {
            return transactionDate;
        }

        public void setTransactionDate(
                LocalDateTime transactionDate) {

            this.transactionDate =
                    transactionDate;
        }

        public String getReceiptNumber() {
            return receiptNumber;
        }

        public void setReceiptNumber(
                String receiptNumber) {

            this.receiptNumber =
                    receiptNumber;
        }
    }
}