package com.dentalclinic.pattern.composite;

import java.math.BigDecimal;
import java.util.List;

public interface DentalServiceComponent {

    String getName();

    String getDescription();

    BigDecimal getPrice();

    List<DentalServiceComponent> getChildren();

    boolean isComposite();
}