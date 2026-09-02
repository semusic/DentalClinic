package com.dentalclinic.dao;

import com.dentalclinic.model.Service;
import com.dentalclinic.model.ServiceCategory;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface ServiceDAO {

    List<Service> findAllActive() throws SQLException;

    List<Service> findAll() throws SQLException;

    Optional<Service> findById(int serviceId) throws SQLException;

    List<ServiceCategory> findAllCategories() throws SQLException;

    int create(Service service) throws SQLException;

    void update(Service service) throws SQLException;

    void updateStatus(int serviceId, boolean active) throws SQLException;
}