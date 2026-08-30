package com.dentalclinic.pattern.chain;

import com.dentalclinic.dto.AppointmentRequestDTO;
import com.dentalclinic.exception.ValidationException;

public interface AppointmentValidationHandler {

    void setNext(AppointmentValidationHandler next);

    void validate(
            AppointmentRequestDTO request
    ) throws ValidationException;
}