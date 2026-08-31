package com.dentalclinic.pattern.state;

public class AppointmentStateContext {

    private AppointmentState currentState;

    public AppointmentStateContext(
            AppointmentState initialState) {

        if (initialState == null) {
            throw new IllegalArgumentException(
                    "Initial appointment state is required."
            );
        }

        this.currentState = initialState;
    }

    public String getCurrentStatus() {
        return currentState.getStatusCode();
    }

    public boolean canTransitionTo(
            String targetStatus) {

        return currentState.canTransitionTo(
                targetStatus
        );
    }

    public void transitionTo(
            AppointmentState nextState) {

        if (nextState == null) {
            throw new IllegalArgumentException(
                    "Next appointment state is required."
            );
        }

        if (!currentState.canTransitionTo(
                nextState.getStatusCode()
        )) {

            throw new IllegalStateException(
                    "Invalid appointment transition: "
                    + currentState.getStatusCode()
                    + " -> "
                    + nextState.getStatusCode()
            );
        }

        currentState = nextState;
    }
}