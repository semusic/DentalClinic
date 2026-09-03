package com.dentalclinic.pattern.state;

public class RescheduleRequiredAppointmentState
        implements AppointmentState {

    @Override
    public String getStatusCode() {
        return "RESCHEDULE_REQUIRED";
    }

    @Override
    public boolean canTransitionTo(
            String targetStatus) {

        return "PENDING".equals(targetStatus)
                || "UNDER_REVIEW".equals(targetStatus)
                || "AWAITING_DOCTOR_APPROVAL".equals(targetStatus);
    }
}
