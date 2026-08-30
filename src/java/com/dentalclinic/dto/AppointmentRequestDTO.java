package com.dentalclinic.dto;

import java.time.LocalDate;
import java.time.LocalTime;

public class AppointmentRequestDTO {

    private int patientId;
    private int serviceId;
    private Integer doctorId;
    private int requestingUserId;

    private LocalDate requestedDate;
    private LocalTime requestedTime;
    
    

    private String patientReason;

    public AppointmentRequestDTO() {
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public int getServiceId() {
        return serviceId;
    }
    
    public int getRequestingUserId() {
    return requestingUserId;
}

    public void setRequestingUserId(int requestingUserId) {
        this.requestingUserId = requestingUserId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public Integer getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(Integer doctorId) {
        this.doctorId = doctorId;
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
}