package com.dentalclinic.pattern.state;

public class AppointmentStateFactory {

    public AppointmentState create(
            String statusCode) {

        if (statusCode == null) {
            throw new IllegalArgumentException(
                    "Appointment status is required."
            );
        }

        return switch (statusCode) {

            case "PENDING" ->
                    new PendingAppointmentState();

            case "UNDER_REVIEW" ->
                    new UnderReviewAppointmentState();

            case "AWAITING_DOCTOR_APPROVAL" ->
                    new AwaitingDoctorApprovalState();
                
            case "DOCTOR_APPROVED" ->
                    new DoctorApprovedAppointmentState();

            default ->
                    new UnsupportedAppointmentState(
                            statusCode
                    );
        };
    }
}