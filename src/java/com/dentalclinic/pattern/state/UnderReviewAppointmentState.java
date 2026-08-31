package com.dentalclinic.pattern.state;

public class UnderReviewAppointmentState
        implements AppointmentState {

    @Override
    public String getStatusCode() {
        return "UNDER_REVIEW";
    }

    @Override
    public boolean canTransitionTo(
            String targetStatus) {

        return "AWAITING_DOCTOR_APPROVAL".equals(
                targetStatus
        );
    }
}