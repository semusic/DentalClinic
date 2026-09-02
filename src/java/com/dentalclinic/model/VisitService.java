package com.dentalclinic.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class VisitService {

    private int visitServiceId;
    private int visitId;
    private int serviceId;
    private int performedByDoctorId;

    private int quantity;

    private BigDecimal unitPrice;
    private BigDecimal lineTotal;

    private String treatmentNotes;

    private LocalDateTime performedAt;
    private LocalDateTime createdAt;

    public VisitService() {
    }

    public int getVisitServiceId() {
        return visitServiceId;
    }

    public void setVisitServiceId(int visitServiceId) {
        this.visitServiceId = visitServiceId;
    }

    public int getVisitId() {
        return visitId;
    }

    public void setVisitId(int visitId) {
        this.visitId = visitId;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public int getPerformedByDoctorId() {
        return performedByDoctorId;
    }

    public void setPerformedByDoctorId(
            int performedByDoctorId) {
        this.performedByDoctorId =
                performedByDoctorId;
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

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public BigDecimal getLineTotal() {
        return lineTotal;
    }

    public void setLineTotal(BigDecimal lineTotal) {
        this.lineTotal = lineTotal;
    }

    public String getTreatmentNotes() {
        return treatmentNotes;
    }

    public void setTreatmentNotes(String treatmentNotes) {
        this.treatmentNotes = treatmentNotes;
    }

    public LocalDateTime getPerformedAt() {
        return performedAt;
    }

    public void setPerformedAt(
            LocalDateTime performedAt) {
        this.performedAt = performedAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(
            LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}