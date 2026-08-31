package com.dentalclinic.pattern.state;

public interface AppointmentState {

    String getStatusCode();

    boolean canTransitionTo(String targetStatus);
}