package com.dentalclinic.pattern.composite;

import com.dentalclinic.model.Service;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

public class DentalServiceLeaf
        implements DentalServiceComponent {

    private final Service service;

    public DentalServiceLeaf(Service service) {
        this.service = service;
    }

    public Service getService() {
        return service;
    }

    @Override
    public String getName() {
        return service.getServiceName();
    }

    @Override
    public String getDescription() {
        return service.getDescription();
    }

    @Override
    public BigDecimal getPrice() {
        return service.getStandardPrice();
    }

    @Override
    public List<DentalServiceComponent> getChildren() {
        return Collections.emptyList();
    }

    @Override
    public boolean isComposite() {
        return false;
    }
}