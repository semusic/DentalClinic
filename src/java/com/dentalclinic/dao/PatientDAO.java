package com.dentalclinic.dao;

import com.dentalclinic.model.Patient;
import java.sql.Connection;
import java.util.Optional;

import java.sql.SQLException;

public interface PatientDAO {

    int save(Patient patient) throws SQLException;
    
    int save(
        Patient patient,
        Connection connection
) throws SQLException;
    
    Optional<Patient> findById(int patientId) throws SQLException;
}