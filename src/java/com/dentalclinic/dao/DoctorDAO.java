package com.dentalclinic.dao;

import com.dentalclinic.model.Doctor;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface DoctorDAO {

    List<Doctor> findActiveDoctors()
            throws SQLException;

    List<Doctor> findByServiceId(int serviceId)
            throws SQLException;

    Optional<Doctor> findById(int doctorId)
            throws SQLException;
}