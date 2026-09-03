package com.dentalclinic.pattern.state;

import org.junit.Test;

import static org.junit.Assert.*;

public class AppointmentStateTest {

    private final AppointmentStateFactory factory =
            new AppointmentStateFactory();

    @Test
    public void shouldCreatePendingState() {

        AppointmentState state =
                factory.create("PENDING");

        assertNotNull(state);
        assertEquals(
                "PENDING",
                state.getStatusCode()
        );
    }

    @Test
    public void shouldAllowPendingToUnderReview() {

        AppointmentState state =
                factory.create("PENDING");

        assertTrue(
                state.canTransitionTo("UNDER_REVIEW")
        );
    }

    @Test
    public void shouldAllowUnderReviewToDoctorApproval() {

        AppointmentState state =
                factory.create("UNDER_REVIEW");

        assertTrue(
                state.canTransitionTo(
                        "AWAITING_DOCTOR_APPROVAL"
                )
        );
    }

    @Test
    public void shouldAllowDoctorApprovalToReschedule() {

        AppointmentState state =
                factory.create(
                        "AWAITING_DOCTOR_APPROVAL"
                );

        assertTrue(
                state.canTransitionTo(
                        "RESCHEDULE_REQUIRED"
                )
        );
    }

    @Test
    public void shouldAllowDoctorApprovalToDoctorApproved() {

        AppointmentState state =
                factory.create(
                        "AWAITING_DOCTOR_APPROVAL"
                );

        assertTrue(
                state.canTransitionTo(
                        "DOCTOR_APPROVED"
                )
        );
    }

    @Test
    public void shouldNotAllowPendingDirectlyToConfirmed() {

        AppointmentState state =
                factory.create("PENDING");

        assertFalse(
                state.canTransitionTo(
                        "CONFIRMED"
                )
        );
    }

    @Test
    public void shouldNotAllowUnderReviewDirectlyToConfirmed() {

        AppointmentState state =
                factory.create("UNDER_REVIEW");

        assertFalse(
                state.canTransitionTo(
                        "CONFIRMED"
                )
        );
    }

    @Test(expected = IllegalArgumentException.class)
    public void shouldRejectNullState() {

        factory.create(null);
    }

    @Test
    public void contextShouldTrackCurrentState() {

        AppointmentState initialState =
                factory.create("PENDING");

        AppointmentStateContext context =
                new AppointmentStateContext(
                        initialState
                );

        assertEquals(
                "PENDING",
                context.getCurrentStatus()
        );
    }

    @Test
    public void contextShouldTransitionToValidState() {

        AppointmentStateContext context =
                new AppointmentStateContext(
                        factory.create("PENDING")
                );

        context.transitionTo(
                factory.create("UNDER_REVIEW")
        );

        assertEquals(
                "UNDER_REVIEW",
                context.getCurrentStatus()
        );
    }

    @Test(expected = IllegalStateException.class)
    public void contextShouldRejectInvalidTransition() {

        AppointmentStateContext context =
                new AppointmentStateContext(
                        factory.create("PENDING")
                );

        context.transitionTo(
                factory.create("CONFIRMED")
        );
    }
}