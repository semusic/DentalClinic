package com.dentalclinic.dao;

import com.dentalclinic.model.Doctor;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface DoctorDAO {

    List<Doctor> findAll() throws SQLException;

    List<Doctor> findActiveDoctors() throws SQLException;

    List<Doctor> findByServiceId(int serviceId) throws SQLException;

    Optional<Doctor> findById(int doctorId) throws SQLException;

    int create(Doctor doctor) throws SQLException;

    boolean update(Doctor doctor) throws SQLException;

    boolean updateStatus(int doctorId, boolean active) throws SQLException;

    List<Integer> findAssignedServiceIds(int doctorId) throws SQLException;

    boolean assignServices(int doctorId, List<Integer> serviceIds) throws SQLException;
}