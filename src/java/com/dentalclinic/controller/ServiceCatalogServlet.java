package com.dentalclinic.controller;

import com.dentalclinic.pattern.composite.DentalServiceComponent;
import com.dentalclinic.service.ServiceCatalogService;
import com.dentalclinic.service.impl.ServiceCatalogServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/services")
public class ServiceCatalogServlet extends HttpServlet {

    private ServiceCatalogService serviceCatalogService;

    @Override
    public void init() {
        serviceCatalogService =
                new ServiceCatalogServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            DentalServiceComponent catalog =
                    serviceCatalogService.getServiceCatalog();

            request.setAttribute(
                    "serviceCatalog",
                    catalog
            );

            request.getRequestDispatcher(
        "/services/services.jsp"
        ).forward(request, response);

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to load dental services.",
                    e
            );
        }
    }
}