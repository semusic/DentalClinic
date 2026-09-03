package com.dentalclinic.controller;

import com.dentalclinic.dao.DoctorApprovalDAO;
import com.dentalclinic.dao.DoctorDAO;
import com.dentalclinic.dao.PatientDAO;
import com.dentalclinic.dao.ServiceDAO;
import com.dentalclinic.dao.impl.DoctorApprovalDAOImpl;
import com.dentalclinic.dao.impl.DoctorDAOImpl;
import com.dentalclinic.dao.impl.PatientDAOImpl;
import com.dentalclinic.dao.impl.ServiceDAOImpl;
import com.dentalclinic.dto.AppointmentRequestDTO;
import com.dentalclinic.dto.DoctorApprovalReviewDTO;
import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.model.Appointment;
import com.dentalclinic.model.Doctor;
import com.dentalclinic.model.Patient;
import com.dentalclinic.model.Service;
import com.dentalclinic.model.User;
import com.dentalclinic.pattern.facade.AppointmentFacade;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Optional;

@WebServlet("/patient/appointments/request")
public class AppointmentRequestServlet extends HttpServlet {

    private PatientDAO patientDAO;
    private ServiceDAO serviceDAO;
    private DoctorDAO doctorDAO;
    private AppointmentFacade appointmentFacade;
    private DoctorApprovalDAO approvalDAO;

    @Override
    public void init() {
        patientDAO = new PatientDAOImpl();
        serviceDAO = new ServiceDAOImpl();
        doctorDAO = new DoctorDAOImpl();
        appointmentFacade = new AppointmentFacade();
        approvalDAO = new DoctorApprovalDAOImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Service> services = serviceDAO.findAllActive();
            request.setAttribute("services", services);

            String rescheduleIdParam = request.getParameter("rescheduleId");
            if (rescheduleIdParam != null && !rescheduleIdParam.isBlank()) {
                try {
                    int rescheduleId = Integer.parseInt(rescheduleIdParam);
                    Optional<Appointment> appOpt = appointmentFacade.getAppointment(rescheduleId);
                    if (appOpt.isPresent()) {
                        Appointment app = appOpt.get();
                        request.setAttribute("rescheduleAppointment", app);
                        request.setAttribute("selectedServiceId", app.getServiceId());
                        request.setAttribute("doctors", doctorDAO.findByServiceId(app.getServiceId()));

                        Optional<DoctorApprovalReviewDTO> reviewOpt = approvalDAO.findByAppointmentId(rescheduleId);
                        if (reviewOpt.isPresent()) {
                            request.setAttribute("doctorReview", reviewOpt.get());
                        }
                    }
                } catch (Exception ignored) {}
            } else {
                String serviceIdParameter = request.getParameter("serviceId");

                if (serviceIdParameter != null && !serviceIdParameter.isBlank()) {
                    try {
                        int serviceId = Integer.parseInt(serviceIdParameter);
                        List<Doctor> doctors = doctorDAO.findByServiceId(serviceId);
                        request.setAttribute("selectedServiceId", serviceId);
                        request.setAttribute("doctors", doctors);
                    } catch (NumberFormatException e) {
                        request.setAttribute("error", "Invalid service selection.");
                    }
                } else {
                    request.setAttribute("doctors", List.of());
                }
            }

            request.getRequestDispatcher("/patient/appointment-request.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load appointment form.", e);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User authenticatedUser = (User) session.getAttribute("authenticatedUser");
        if (authenticatedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Optional<Patient> patient = patientDAO.findByUserId(authenticatedUser.getUserId());
            if (patient.isEmpty()) {
                request.setAttribute("error", "Patient profile could not be found.");
                doGet(request, response);
                return;
            }

            String rescheduleIdParam = request.getParameter("rescheduleId");
            String serviceIdParameter = request.getParameter("serviceId");
            String doctorIdParameter = request.getParameter("doctorId");
            String requestedDateParameter = request.getParameter("requestedDate");
            String requestedTimeParameter = request.getParameter("requestedTime");
            String patientReason = request.getParameter("patientReason");

            LocalDate requestedDate = LocalDate.parse(requestedDateParameter);
            LocalTime requestedTime = LocalTime.parse(requestedTimeParameter);

            if (rescheduleIdParam != null && !rescheduleIdParam.isBlank()) {
                int rescheduleId = Integer.parseInt(rescheduleIdParam);

                appointmentFacade.rescheduleAppointment(
                        rescheduleId,
                        requestedDate,
                        requestedTime,
                        authenticatedUser.getUserId()
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/patient/appointments/success?id="
                        + rescheduleId
                        + "&rescheduled=true"
                );
                return;
            }

            int serviceId = Integer.parseInt(serviceIdParameter);
            int doctorId = Integer.parseInt(doctorIdParameter);

            AppointmentRequestDTO appointmentRequest = new AppointmentRequestDTO();
            appointmentRequest.setPatientId(patient.get().getPatientId());
            appointmentRequest.setRequestingUserId(authenticatedUser.getUserId());
            appointmentRequest.setServiceId(serviceId);
            appointmentRequest.setDoctorId(doctorId);
            appointmentRequest.setRequestedDate(requestedDate);
            appointmentRequest.setRequestedTime(requestedTime);
            appointmentRequest.setPatientReason(patientReason);

            int appointmentId = appointmentFacade.requestAppointment(appointmentRequest);

            response.sendRedirect(
                    request.getContextPath()
                    + "/patient/appointments/success?id="
                    + appointmentId
            );

        } catch (NumberFormatException | DateTimeParseException e) {
            request.setAttribute("error", "Please enter valid appointment details.");
            doGet(request, response);
        } catch (ValidationException e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to submit appointment request.", e);
        }
    }
}