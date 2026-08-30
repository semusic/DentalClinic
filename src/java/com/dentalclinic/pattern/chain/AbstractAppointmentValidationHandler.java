 package com.dentalclinic.pattern.chain;

import com.dentalclinic.dto.AppointmentRequestDTO;
import com.dentalclinic.exception.ValidationException;

public abstract class AbstractAppointmentValidationHandler
        implements AppointmentValidationHandler {

    private AppointmentValidationHandler next;

    @Override
    public void setNext(
            AppointmentValidationHandler next) {

        this.next = next;
    }

    @Override
    public void validate(
            AppointmentRequestDTO request
    ) throws ValidationException {

        performValidation(request);

        if (next != null) {
            next.validate(request);
        }
    }

    protected abstract void performValidation(
            AppointmentRequestDTO request
    ) throws ValidationException;
}