package com.dentalclinic.service;

import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.service.impl.DoctorApprovalServiceImpl;
import org.junit.Test;

import static org.junit.Assert.*;

public class DoctorApprovalServiceTest {

    private final DoctorApprovalService service =
            new DoctorApprovalServiceImpl();

    @Test(expected = ValidationException.class)
    public void shouldRejectInvalidAppointmentId()
            throws Exception {

        service.createApproval(
                0,
                1
        );
    }

    @Test(expected = ValidationException.class)
    public void shouldRejectInvalidAssistantUserId()
            throws Exception {

        service.createApproval(
                1,
                0
        );
    }

    @Test(expected = ValidationException.class)
    public void shouldRejectNullApprovalToken()
            throws Exception {

        service.getApprovalByToken(null);
    }

    @Test(expected = ValidationException.class)
    public void shouldRejectBlankApprovalToken()
            throws Exception {

        service.getApprovalByToken("   ");
    }

    @Test(expected = ValidationException.class)
    public void shouldRejectOverlyLongApprovalToken()
            throws Exception {

        String longToken = "A".repeat(501);

        service.getApprovalByToken(longToken);
    }
}