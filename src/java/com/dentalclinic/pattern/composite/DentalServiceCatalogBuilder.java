package com.dentalclinic.pattern.composite;

import com.dentalclinic.model.Service;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class DentalServiceCatalogBuilder {

    public DentalServiceComponent build(
            List<Service> services) {

        DentalServiceComposite root =
                new DentalServiceComposite(
                        "Dental Services",
                        "Available dental treatments"
                );

        Map<String, DentalServiceComposite> categories =
                new LinkedHashMap<>();

        for (Service service : services) {

            String categoryName =
                    service.getCategoryName();

            DentalServiceComposite category =
                    categories.computeIfAbsent(
                            categoryName,
                            name -> {

                                DentalServiceComposite composite =
                                        new DentalServiceComposite(
                                                name,
                                                name + " dental services"
                                        );

                                root.add(composite);

                                return composite;
                            }
                    );

            category.add(
                    new DentalServiceLeaf(service)
            );
        }

        return root;
    }
}