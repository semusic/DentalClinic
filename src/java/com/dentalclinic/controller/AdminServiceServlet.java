package com.dentalclinic.controller;

import com.dentalclinic.model.Service;
import com.dentalclinic.model.ServiceCategory;
import com.dentalclinic.service.ServiceCatalogService;
import com.dentalclinic.service.impl.ServiceCatalogServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/services")
public class AdminServiceServlet extends HttpServlet {

    private ServiceCatalogService serviceCatalogService;

    @Override
    public void init() {
        serviceCatalogService = new ServiceCatalogServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Service> services = serviceCatalogService.getAllServices();
            List<ServiceCategory> categories = serviceCatalogService.getAllCategories();

            request.setAttribute("services", services);
            request.setAttribute("categories", categories);

            request.getRequestDispatcher("/admin/service-catalog.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load administrative service catalog.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("create".equalsIgnoreCase(action)) {
                handleCreate(request, response);
            } else if ("update".equalsIgnoreCase(action)) {
                handleUpdate(request, response);
            } else if ("toggleStatus".equalsIgnoreCase(action)) {
                handleToggleStatus(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/services");
            }
        } catch (SQLException e) {
            throw new ServletException("Error processing service catalog modification.", e);
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String serviceName = request.getParameter("serviceName");
        String categoryIdStr = request.getParameter("categoryId");
        String description = request.getParameter("description");
        String durationStr = request.getParameter("durationMinutes");
        String priceStr = request.getParameter("standardPrice");
        String isActiveStr = request.getParameter("isActive");

        if (serviceName == null || serviceName.isBlank() ||
            categoryIdStr == null || durationStr == null || priceStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/services?error=missing_fields");
            return;
        }

        int categoryId = Integer.parseInt(categoryIdStr);
        int duration = Integer.parseInt(durationStr);
        BigDecimal price = new BigDecimal(priceStr);
        boolean isActive = "true".equalsIgnoreCase(isActiveStr) || "on".equalsIgnoreCase(isActiveStr);

        Service service = new Service();
        service.setCategoryId(categoryId);
        service.setServiceName(serviceName.trim());
        service.setDescription(description != null ? description.trim() : "");
        service.setDurationMinutes(duration);
        service.setStandardPrice(price);
        service.setActive(isActive);

        serviceCatalogService.createService(service);
        response.sendRedirect(request.getContextPath() + "/admin/services?success=created");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String serviceIdStr = request.getParameter("serviceId");
        String serviceName = request.getParameter("serviceName");
        String categoryIdStr = request.getParameter("categoryId");
        String description = request.getParameter("description");
        String durationStr = request.getParameter("durationMinutes");
        String priceStr = request.getParameter("standardPrice");
        String isActiveStr = request.getParameter("isActive");

        if (serviceIdStr == null || serviceName == null || serviceName.isBlank() ||
            categoryIdStr == null || durationStr == null || priceStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/services?error=missing_fields");
            return;
        }

        int serviceId = Integer.parseInt(serviceIdStr);
        int categoryId = Integer.parseInt(categoryIdStr);
        int duration = Integer.parseInt(durationStr);
        BigDecimal price = new BigDecimal(priceStr);
        boolean isActive = "true".equalsIgnoreCase(isActiveStr) || "on".equalsIgnoreCase(isActiveStr);

        Service service = new Service();
        service.setServiceId(serviceId);
        service.setCategoryId(categoryId);
        service.setServiceName(serviceName.trim());
        service.setDescription(description != null ? description.trim() : "");
        service.setDurationMinutes(duration);
        service.setStandardPrice(price);
        service.setActive(isActive);

        serviceCatalogService.updateService(service);
        response.sendRedirect(request.getContextPath() + "/admin/services?success=updated");
    }

    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String serviceIdStr = request.getParameter("serviceId");
        if (serviceIdStr != null) {
            int serviceId = Integer.parseInt(serviceIdStr);
            serviceCatalogService.toggleServiceStatus(serviceId);
            response.sendRedirect(request.getContextPath() + "/admin/services?success=status_toggled");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/services");
        }
    }
}
