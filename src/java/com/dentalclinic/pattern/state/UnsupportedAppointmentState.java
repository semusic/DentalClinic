package com.dentalclinic.pattern.state;

public class UnsupportedAppointmentState
        implements AppointmentState {

    private final String statusCode;

    public UnsupportedAppointmentState(
            String statusCode) {

        this.statusCode = statusCode;
    }

    @Override
    public String getStatusCode() {
        return statusCode;
    }

    @Override
    public boolean canTransitionTo(
            String targetStatus) {

        return false;
    }
}