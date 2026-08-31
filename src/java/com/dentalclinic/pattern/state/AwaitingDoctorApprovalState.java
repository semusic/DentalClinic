package com.dentalclinic.pattern.state;

public class AwaitingDoctorApprovalState
        implements AppointmentState {

    @Override
    public String getStatusCode() {
        return "AWAITING_DOCTOR_APPROVAL";
    }

    @Override
    public boolean canTransitionTo(
            String targetStatus) {

        return "DOCTOR_APPROVED".equals(targetStatus)
                || "REJECTED".equals(targetStatus)
                || "RESCHEDULE_REQUIRED".equals(
                        targetStatus
                );
    }
}