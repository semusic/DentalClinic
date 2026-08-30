package com.dentalclinic.pattern.composite;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;

public class DentalServiceComposite
        implements DentalServiceComponent {

    private final String name;
    private final String description;

    private final List<DentalServiceComponent> children =
            new ArrayList<>();

    public DentalServiceComposite(
            String name,
            String description) {

        this.name = name;
        this.description = description;
    }

    public void add(
            DentalServiceComponent component) {

        if (component != null) {
            children.add(component);
        }
    }

    public void remove(
            DentalServiceComponent component) {

        children.remove(component);
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public String getDescription() {
        return description;
    }

    @Override
    public BigDecimal getPrice() {

        return children.stream()
                .map(DentalServiceComponent::getPrice)
                .filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    @Override
    public List<DentalServiceComponent> getChildren() {
        return Collections.unmodifiableList(children);
    }

    @Override
    public boolean isComposite() {
        return true;
    }
}