package com.dentalclinic.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class DoctorApprovalReviewDTO {

    private int approvalId;
    private int appointmentId;
    private int doctorId;

    private String doctorName;
    private String doctorSpecialization;

    private String patientName;
    private String patientPhone;
    private String patientEmail;
    private int patientUserId;

    private String serviceName;
    private String serviceDescription;

    private LocalDate requestedDate;
    private LocalTime requestedTime;

    private String patientReason;

    private String approvalTokenHash;
    private LocalDateTime tokenExpiresAt;
    private LocalDateTime tokenUsedAt;

    private String currentStatus;

    public DoctorApprovalReviewDTO() {
    }

    public int getApprovalId() {
        return approvalId;
    }

    public void setApprovalId(int approvalId) {
        this.approvalId = approvalId;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public int getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }

    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }

    public String getDoctorSpecialization() {
        return doctorSpecialization;
    }

    public void setDoctorSpecialization(
            String doctorSpecialization) {
        this.doctorSpecialization =
                doctorSpecialization;
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

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getServiceDescription() {
        return serviceDescription;
    }

    public void setServiceDescription(
            String serviceDescription) {
        this.serviceDescription =
                serviceDescription;
    }

    public LocalDate getRequestedDate() {
        return requestedDate;
    }

    public void setRequestedDate(LocalDate requestedDate) {
        this.requestedDate = requestedDate;
    }

    public LocalTime getRequestedTime() {
        return requestedTime;
    }

    public void setRequestedTime(LocalTime requestedTime) {
        this.requestedTime = requestedTime;
    }

    public String getPatientReason() {
        return patientReason;
    }

    public void setPatientReason(String patientReason) {
        this.patientReason = patientReason;
    }

    public String getApprovalTokenHash() {
        return approvalTokenHash;
    }

    public void setApprovalTokenHash(
            String approvalTokenHash) {
        this.approvalTokenHash =
                approvalTokenHash;
    }

    public LocalDateTime getTokenExpiresAt() {
        return tokenExpiresAt;
    }

    public void setTokenExpiresAt(
            LocalDateTime tokenExpiresAt) {
        this.tokenExpiresAt =
                tokenExpiresAt;
    }

    public LocalDateTime getTokenUsedAt() {
        return tokenUsedAt;
    }

    public void setTokenUsedAt(
            LocalDateTime tokenUsedAt) {
        this.tokenUsedAt = tokenUsedAt;
    }

    public String getCurrentStatus() {
        return currentStatus;
    }

    public void setCurrentStatus(
            String currentStatus) {
        this.currentStatus = currentStatus;
    }
    
    public int getPatientUserId() {
    return patientUserId;
    
    }

    public void setPatientUserId(int patientUserId) {
        this.patientUserId = patientUserId;
    }
}