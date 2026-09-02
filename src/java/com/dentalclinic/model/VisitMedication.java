package com.dentalclinic.model;

import java.time.LocalDateTime;

public class VisitMedication {

    private int visitMedicationId;
    private int visitId;
    private int prescribedByDoctorId;

    private String medicationName;
    private String dosage;

    private Integer quantity;

    private String instructions;

    private boolean providedToPatient;

    private LocalDateTime prescribedAt;
    private LocalDateTime createdAt;

    public VisitMedication() {
    }

    public int getVisitMedicationId() {
        return visitMedicationId;
    }

    public void setVisitMedicationId(
            int visitMedicationId) {
        this.visitMedicationId =
                visitMedicationId;
    }

    public int getVisitId() {
        return visitId;
    }

    public void setVisitId(int visitId) {
        this.visitId = visitId;
    }

    public int getPrescribedByDoctorId() {
        return prescribedByDoctorId;
    }

    public void setPrescribedByDoctorId(
            int prescribedByDoctorId) {
        this.prescribedByDoctorId =
                prescribedByDoctorId;
    }

    public String getMedicationName() {
        return medicationName;
    }

    public void setMedicationName(
            String medicationName) {
        this.medicationName =
                medicationName;
    }

    public String getDosage() {
        return dosage;
    }

    public void setDosage(String dosage) {
        this.dosage = dosage;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public String getInstructions() {
        return instructions;
    }

    public void setInstructions(
            String instructions) {
        this.instructions =
                instructions;
    }

    public boolean isProvidedToPatient() {
        return providedToPatient;
    }

    public void setProvidedToPatient(
            boolean providedToPatient) {
        this.providedToPatient =
                providedToPatient;
    }

    public LocalDateTime getPrescribedAt() {
        return prescribedAt;
    }

    public void setPrescribedAt(
            LocalDateTime prescribedAt) {
        this.prescribedAt =
                prescribedAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(
            LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}