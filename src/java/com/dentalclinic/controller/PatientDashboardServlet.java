package com.dentalclinic.controller;

import com.dentalclinic.dao.PatientDAO;
import com.dentalclinic.dao.impl.PatientDAOImpl;
import com.dentalclinic.model.Appointment;
import com.dentalclinic.model.Patient;
import com.dentalclinic.model.User;
import com.dentalclinic.pattern.facade.AppointmentFacade;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/patient/dashboard")
public class PatientDashboardServlet extends HttpServlet {

    private PatientDAO patientDAO;
    private AppointmentFacade appointmentFacade;

    @Override
    public void init() {
        patientDAO = new PatientDAOImpl();
        appointmentFacade = new AppointmentFacade();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("authenticatedUser") instanceof User user) {
            try {
                Optional<Patient> patientOpt = patientDAO.findByUserId(user.getUserId());
                if (patientOpt.isPresent()) {
                    List<Appointment> appointments = appointmentFacade.getPatientAppointments(patientOpt.get().getPatientId());
                    request.setAttribute("appointments", appointments);
                }
            } catch (Exception e) {
                System.err.println("Unable to load patient appointments for dashboard: " + e.getMessage());
            }
        }

        request.getRequestDispatcher("/patient/dashboard.jsp").forward(request, response);
    }
}