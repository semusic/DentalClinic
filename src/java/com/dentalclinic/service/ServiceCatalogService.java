package com.dentalclinic.service;

import com.dentalclinic.model.Service;
import com.dentalclinic.pattern.composite.DentalServiceComponent;

import java.sql.SQLException;
import java.util.List;

public interface ServiceCatalogService {

    List<Service> getActiveServices()
            throws SQLException;

    DentalServiceComponent getServiceCatalog()
            throws SQLException;
}