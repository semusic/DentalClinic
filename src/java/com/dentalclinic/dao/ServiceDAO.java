package com.dentalclinic.dao;

import com.dentalclinic.model.Service;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface ServiceDAO {

    List<Service> findAllActive()
            throws SQLException;

    Optional<Service> findById(int serviceId)
            throws SQLException;
}