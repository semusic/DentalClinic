package com.dentalclinic.controller;

import com.dentalclinic.dao.AppointmentDAO;
import com.dentalclinic.dao.PatientDAO;
import com.dentalclinic.dao.ServiceDAO;
import com.dentalclinic.dao.DoctorDAO;
import com.dentalclinic.dao.impl.AppointmentDAOImpl;
import com.dentalclinic.dao.impl.PatientDAOImpl;
import com.dentalclinic.dao.impl.ServiceDAOImpl;
import com.dentalclinic.dao.impl.DoctorDAOImpl;
import com.dentalclinic.model.Appointment;
import com.dentalclinic.model.Patient;
import com.dentalclinic.model.Service;
import com.dentalclinic.model.Doctor;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

@WebServlet("/assistant/appointments/search")
public class AppointmentSearchServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;
    private PatientDAO patientDAO;
    private ServiceDAO serviceDAO;
    private DoctorDAO doctorDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAOImpl();
        patientDAO = new PatientDAOImpl();
        serviceDAO = new ServiceDAOImpl();
        doctorDAO = new DoctorDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String query = request.getParameter("query");

        if (query != null && !query.isBlank()) {
            try {
                Optional<Appointment> appointmentOpt = appointmentDAO.findByAppointmentNumber(query.trim());
                if (appointmentOpt.isPresent()) {
                    Appointment app = appointmentOpt.get();
                    request.setAttribute("appointment", app);

                    Optional<Patient> patientOpt = patientDAO.findById(app.getPatientId());
                    patientOpt.ifPresent(p -> request.setAttribute("patient", p));

                    Optional<Service> serviceOpt = serviceDAO.findById(app.getServiceId());
                    serviceOpt.ifPresent(s -> request.setAttribute("service", s));

                    if (app.getDoctorId() != null) {
                        Optional<Doctor> doctorOpt = doctorDAO.findById(app.getDoctorId());
                        doctorOpt.ifPresent(d -> request.setAttribute("doctor", d));
                    }
                } else {
                    request.setAttribute("notFound", true);
                }
            } catch (SQLException e) {
                throw new ServletException("Unable to search appointment.", e);
            }
        }

        request.getRequestDispatcher("/assistant/appointment-search.jsp").forward(request, response);
    }
}
