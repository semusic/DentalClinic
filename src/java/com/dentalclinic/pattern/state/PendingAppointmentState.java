package com.dentalclinic.pattern.state;

public class PendingAppointmentState
        implements AppointmentState {

    @Override
    public String getStatusCode() {
        return "PENDING";
    }

    @Override
    public boolean canTransitionTo(
            String targetStatus) {

        return "UNDER_REVIEW".equals(targetStatus);
    }
}