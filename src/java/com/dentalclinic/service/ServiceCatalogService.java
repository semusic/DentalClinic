package com.dentalclinic.service;

import com.dentalclinic.model.Service;
import com.dentalclinic.model.ServiceCategory;
import com.dentalclinic.pattern.composite.DentalServiceComponent;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface ServiceCatalogService {

    List<Service> getActiveServices() throws SQLException;

    List<Service> getAllServices() throws SQLException;

    List<ServiceCategory> getAllCategories() throws SQLException;

    Optional<Service> getServiceById(int serviceId) throws SQLException;

    DentalServiceComponent getServiceCatalog() throws SQLException;

    void createService(Service service) throws SQLException;

    void updateService(Service service) throws SQLException;

    void toggleServiceStatus(int serviceId) throws SQLException;
}