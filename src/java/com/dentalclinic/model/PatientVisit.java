package com.dentalclinic.model;

import java.time.LocalDateTime;

public class PatientVisit {

    private int visitId;
    private int appointmentId;

    private LocalDateTime checkedInAt;
    private LocalDateTime consultationStartedAt;
    private LocalDateTime consultationCompletedAt;
    private boolean medicinePrescribed;

    private String visitNotes;

    private int recordedByUserId;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public PatientVisit() {
    }

    public int getVisitId() {
        return visitId;
    }

    public void setVisitId(int visitId) {
        this.visitId = visitId;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
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

    public String getVisitNotes() {
        return visitNotes;
    }

    public void setVisitNotes(String visitNotes) {
        this.visitNotes = visitNotes;
    }
    
    public boolean isMedicinePrescribed() {
    return medicinePrescribed;
    }

    public void setMedicinePrescribed(
            boolean medicinePrescribed) {

        this.medicinePrescribed =
                medicinePrescribed;
    }

    public int getRecordedByUserId() {
        return recordedByUserId;
    }

    public void setRecordedByUserId(
            int recordedByUserId) {
        this.recordedByUserId =
                recordedByUserId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(
            LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(
            LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}