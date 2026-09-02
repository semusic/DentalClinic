package com.dentalclinic.dto;

import java.time.LocalDateTime;

public class CashierVisitDTO {

    private int visitId;
    private int appointmentId;
    private int patientId;

    private String patientName;
    private String doctorName;

    private LocalDateTime consultationCompletedAt;

    public CashierVisitDTO() {
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

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }

    public LocalDateTime getConsultationCompletedAt() {
        return consultationCompletedAt;
    }

    public void setConsultationCompletedAt(
            LocalDateTime consultationCompletedAt) {
        this.consultationCompletedAt =
                consultationCompletedAt;
    }
}