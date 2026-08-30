package com.dentalclinic.service.impl;

import com.dentalclinic.dao.ServiceDAO;
import com.dentalclinic.dao.impl.ServiceDAOImpl;
import com.dentalclinic.model.Service;
import com.dentalclinic.pattern.composite.DentalServiceCatalogBuilder;
import com.dentalclinic.pattern.composite.DentalServiceComponent;
import com.dentalclinic.service.ServiceCatalogService;

import java.sql.SQLException;
import java.util.List;

public class ServiceCatalogServiceImpl
        implements ServiceCatalogService {

    private final ServiceDAO serviceDAO;
    private final DentalServiceCatalogBuilder catalogBuilder;

    public ServiceCatalogServiceImpl() {
        this.serviceDAO = new ServiceDAOImpl();
        this.catalogBuilder =
                new DentalServiceCatalogBuilder();
    }

    @Override
    public List<Service> getActiveServices()
            throws SQLException {

        return serviceDAO.findAllActive();
    }

    @Override
    public DentalServiceComponent getServiceCatalog()
            throws SQLException {

        List<Service> services =
                serviceDAO.findAllActive();

        return catalogBuilder.build(services);
    }
}