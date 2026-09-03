package com.dentalclinic.service;

import com.dentalclinic.dto.TimeSlotDTO;
import com.dentalclinic.service.impl.DoctorAvailabilityServiceImpl;
import org.junit.Test;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import static org.junit.Assert.*;

public class DoctorAvailabilityServiceTest {

    private final DoctorAvailabilityService service =
            new DoctorAvailabilityServiceImpl();

    @Test
    public void shouldReturnFalseWhenDateIsNull()
            throws Exception {

        boolean result =
                service.isWithinWorkingHours(
                        1,
                        null,
                        LocalTime.of(10, 0)
                );

        assertFalse(result);
    }

    @Test
    public void shouldReturnFalseWhenTimeIsNull()
            throws Exception {

        boolean result =
                service.isWithinWorkingHours(
                        1,
                        LocalDate.of(2026, 9, 4),
                        null
                );

        assertFalse(result);
    }

    @Test
    public void shouldReturnEmptySlotsForInvalidDoctorId()
            throws Exception {

        List<TimeSlotDTO> slots =
                service.getAvailableSlots(
                        0,
                        1,
                        LocalDate.of(2026, 9, 4),
                        null
                );

        assertNotNull(slots);
        assertTrue(slots.isEmpty());
    }

    /**
     * Integration test:
     *
     * Doctor 3 (Kavitha Raj)
     * Friday: 09:30 - 15:30
     *
     * Service 4 (Teeth Whitening)
     * Duration: 60 minutes
     *
     * Existing appointment for Doctor 3:
     * 10:30 AM on 2026-09-04
     *
     * Therefore:
     * 10:00 AM -> 11:00 AM
     *
     * overlaps:
     * 10:30 AM -> 11:30 AM
     *
     * Therefore 10:00 AM must be unavailable.
     */
    @Test
    public void shouldMarkOverlappingSlotAsUnavailable()
            throws Exception {

        List<TimeSlotDTO> slots =
                service.getAvailableSlots(
                        3,
                        4,
                        LocalDate.of(2026, 9, 4),
                        null
                );

        assertNotNull(slots);

        TimeSlotDTO tenAmSlot =
                slots.stream()
                        .filter(slot ->
                                "10:00".equals(
                                        slot.getTime()
                                )
                        )
                        .findFirst()
                        .orElse(null);

        assertNotNull(
                "10:00 slot should exist.",
                tenAmSlot
        );

        assertFalse(
                "10:00 should be unavailable because it overlaps the existing appointment.",
                tenAmSlot.isAvailable()
        );

        assertEquals(
                "Already booked",
                tenAmSlot.getReason()
        );
    }
    
        @Test
    public void shouldAllowSlotWhenItStartsAtPreviousAppointmentEnd()
            throws Exception {

        List<TimeSlotDTO> slots =
                service.getAvailableSlots(
                        3,
                        4,
                        LocalDate.of(2026, 9, 4),
                        null
                );

        assertNotNull(slots);

        TimeSlotDTO twoThirtyPmSlot =
                slots.stream()
                        .filter(slot ->
                                "14:30".equals(slot.getTime()))
                        .findFirst()
                        .orElse(null);

        assertNotNull(
                "14:30 slot should exist.",
                twoThirtyPmSlot
        );

        assertTrue(
                "14:30 should be available because it starts exactly when the 13:30–14:30 appointment ends.",
                twoThirtyPmSlot.isAvailable()
        );
    }
    
    @Test
public void shouldRejectSlotThatExtendsBeyondDoctorWorkingHours()
        throws Exception {

    List<TimeSlotDTO> slots =
            service.getAvailableSlots(
                    3,
                    4,
                    LocalDate.of(2026, 9, 4),
                    null
            );

    assertNotNull(slots);

    TimeSlotDTO threePmSlot =
            slots.stream()
                    .filter(slot ->
                            "15:00".equals(slot.getTime()))
                    .findFirst()
                    .orElse(null);

    assertNotNull(
            "03:00 PM slot should exist.",
            threePmSlot
    );

    assertFalse(
            "03:00 PM should be unavailable because a 60-minute service would end at 04:00 PM, after the doctor's 03:30 PM closing time.",
            threePmSlot.isAvailable()
    );

    assertEquals(
            "Outside working hours",
            threePmSlot.getReason()
    );
}
}