package com.dentalclinic.service;

import com.dentalclinic.model.Patient;
import com.dentalclinic.model.User;
import com.dentalclinic.exception.ValidationException;

import java.sql.SQLException;

public interface PatientRegistrationService {

    int register(
            User user,
            Patient patient,
            String plainPassword
    ) throws SQLException, ValidationException;
}