package com.dentalclinic.service.impl;

import com.dentalclinic.dao.ServiceDAO;
import com.dentalclinic.dao.impl.ServiceDAOImpl;
import com.dentalclinic.model.Service;
import com.dentalclinic.model.ServiceCategory;
import com.dentalclinic.pattern.composite.DentalServiceCatalogBuilder;
import com.dentalclinic.pattern.composite.DentalServiceComponent;
import com.dentalclinic.service.ServiceCatalogService;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class ServiceCatalogServiceImpl implements ServiceCatalogService {

    private final ServiceDAO serviceDAO;
    private final DentalServiceCatalogBuilder catalogBuilder;

    public ServiceCatalogServiceImpl() {
        this.serviceDAO = new ServiceDAOImpl();
        this.catalogBuilder = new DentalServiceCatalogBuilder();
    }

    @Override
    public List<Service> getActiveServices() throws SQLException {
        return serviceDAO.findAllActive();
    }

    @Override
    public List<Service> getAllServices() throws SQLException {
        return serviceDAO.findAll();
    }

    @Override
    public List<ServiceCategory> getAllCategories() throws SQLException {
        return serviceDAO.findAllCategories();
    }

    @Override
    public Optional<Service> getServiceById(int serviceId) throws SQLException {
        return serviceDAO.findById(serviceId);
    }

    @Override
    public DentalServiceComponent getServiceCatalog() throws SQLException {
        List<Service> services = serviceDAO.findAllActive();
        return catalogBuilder.build(services);
    }

    @Override
    public void createService(Service service) throws SQLException {
        serviceDAO.create(service);
    }

    @Override
    public void updateService(Service service) throws SQLException {
        serviceDAO.update(service);
    }

    @Override
    public void toggleServiceStatus(int serviceId) throws SQLException {
        Optional<Service> opt = serviceDAO.findById(serviceId);
        if (opt.isPresent()) {
            boolean currentStatus = opt.get().isActive();
            serviceDAO.updateStatus(serviceId, !currentStatus);
        }
    }
}