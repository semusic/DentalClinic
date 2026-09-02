package com.dentalclinic.controller;

import com.dentalclinic.dao.DoctorDAO;
import com.dentalclinic.dao.ServiceDAO;
import com.dentalclinic.dao.impl.DoctorDAOImpl;
import com.dentalclinic.dao.impl.ServiceDAOImpl;
import com.dentalclinic.model.Doctor;
import com.dentalclinic.model.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@WebServlet("/admin/doctors")
public class AdminDoctorServlet extends HttpServlet {

    private DoctorDAO doctorDAO;
    private ServiceDAO serviceDAO;

    @Override
    public void init() {
        doctorDAO = new DoctorDAOImpl();
        serviceDAO = new ServiceDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Doctor> doctors = doctorDAO.findAll();
            List<Service> services = serviceDAO.findAllActive();

            Map<Integer, List<Integer>> doctorServicesMap = new HashMap<>();
            for (Doctor d : doctors) {
                List<Integer> assignedIds = doctorDAO.findAssignedServiceIds(d.getDoctorId());
                doctorServicesMap.put(d.getDoctorId(), assignedIds);
            }

            request.setAttribute("doctors", doctors);
            request.setAttribute("allServices", services);
            request.setAttribute("doctorServicesMap", doctorServicesMap);

            String editIdStr = request.getParameter("editId");
            if (editIdStr != null && !editIdStr.isBlank()) {
                try {
                    int editId = Integer.parseInt(editIdStr);
                    Optional<Doctor> editDoc = doctorDAO.findById(editId);
                    editDoc.ifPresent(d -> request.setAttribute("editDoctor", d));
                    request.setAttribute("editAssignedServices", doctorDAO.findAssignedServiceIds(editId));
                } catch (NumberFormatException ignored) {}
            }

            request.getRequestDispatcher("/admin/doctors.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load doctor management page.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("toggleStatus".equalsIgnoreCase(action)) {
                int doctorId = Integer.parseInt(request.getParameter("doctorId"));
                boolean currentActive = Boolean.parseBoolean(request.getParameter("active"));
                doctorDAO.updateStatus(doctorId, !currentActive);
                request.getSession().setAttribute("flashMessage", "Doctor status updated successfully.");
            } else if ("add".equalsIgnoreCase(action) || "edit".equalsIgnoreCase(action)) {
                String firstName = request.getParameter("firstName");
                String lastName = request.getParameter("lastName");
                String specialization = request.getParameter("specialization");
                String registrationNo = request.getParameter("registrationNo");
                String phone = request.getParameter("phone");
                String email = request.getParameter("email");
                String[] selectedServices = request.getParameterValues("services");

                List<Integer> serviceIds = new ArrayList<>();
                if (selectedServices != null) {
                    for (String sId : selectedServices) {
                        try { serviceIds.add(Integer.parseInt(sId)); } catch (NumberFormatException ignored) {}
                    }
                }

                if ("add".equalsIgnoreCase(action)) {
                    Doctor newDoc = new Doctor();
                    newDoc.setFirstName(firstName);
                    newDoc.setLastName(lastName);
                    newDoc.setSpecialization(specialization);
                    newDoc.setRegistrationNo(registrationNo);
                    newDoc.setPhone(phone);
                    newDoc.setEmail(email);
                    newDoc.setActive(true);

                    int doctorId = doctorDAO.create(newDoc);
                    doctorDAO.assignServices(doctorId, serviceIds);
                    request.getSession().setAttribute("flashMessage", "Doctor Dr. " + firstName + " " + lastName + " created successfully!");
                } else {
                    int doctorId = Integer.parseInt(request.getParameter("doctorId"));
                    Doctor doc = new Doctor();
                    doc.setDoctorId(doctorId);
                    doc.setFirstName(firstName);
                    doc.setLastName(lastName);
                    doc.setSpecialization(specialization);
                    doc.setRegistrationNo(registrationNo);
                    doc.setPhone(phone);
                    doc.setEmail(email);

                    doctorDAO.update(doc);
                    doctorDAO.assignServices(doctorId, serviceIds);
                    request.getSession().setAttribute("flashMessage", "Doctor Dr. " + firstName + " " + lastName + " updated successfully!");
                }
            }
        } catch (SQLException e) {
            request.getSession().setAttribute("flashError", "Database Error: " + e.getMessage());
        } catch (Exception e) {
            request.getSession().setAttribute("flashError", "Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/doctors");
    }
}
