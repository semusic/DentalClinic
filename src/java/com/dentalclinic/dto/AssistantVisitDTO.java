package com.dentalclinic.dto;

import com.dentalclinic.model.PatientVisit;

import java.time.LocalDate;
import java.time.LocalTime;

public class AssistantVisitDTO {

    private int appointmentId;

    private int patientId;
    private String patientName;

    private int serviceId;
    private String serviceName;

    private Integer doctorId;
    private String doctorName;

    private LocalDate appointmentDate;
    private LocalTime appointmentTime;

    private String appointmentStatus;

    private PatientVisit patientVisit;

    public AssistantVisitDTO() {
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId =
                appointmentId;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId =
                patientId;
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(
            String patientName) {

        this.patientName =
                patientName;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId =
                serviceId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(
            String serviceName) {

        this.serviceName =
                serviceName;
    }

    public Integer getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(
            Integer doctorId) {

        this.doctorId =
                doctorId;
    }

    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(
            String doctorName) {

        this.doctorName =
                doctorName;
    }

    public LocalDate getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(
            LocalDate appointmentDate) {

        this.appointmentDate =
                appointmentDate;
    }

    public LocalTime getAppointmentTime() {
        return appointmentTime;
    }

    public void setAppointmentTime(
            LocalTime appointmentTime) {

        this.appointmentTime =
                appointmentTime;
    }

    public String getAppointmentStatus() {
        return appointmentStatus;
    }

    public void setAppointmentStatus(
            String appointmentStatus) {

        this.appointmentStatus =
                appointmentStatus;
    }

    public PatientVisit getPatientVisit() {
        return patientVisit;
    }

    public void setPatientVisit(
            PatientVisit patientVisit) {

        this.patientVisit =
                patientVisit;
    }
}