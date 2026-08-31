package com.dentalclinic.pattern.state;

public class DoctorApprovedAppointmentState
        implements AppointmentState {

    @Override
    public String getStatusCode() {
        return "DOCTOR_APPROVED";
    }

    @Override
    public boolean canTransitionTo(
            String targetStatus) {

        return "CONFIRMED".equals(targetStatus)
                || "CANCELLED".equals(targetStatus);
    }
}