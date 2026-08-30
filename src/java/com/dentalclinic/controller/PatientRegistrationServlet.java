package com.dentalclinic.controller;

import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.model.Patient;
import com.dentalclinic.model.User;
import com.dentalclinic.service.PatientRegistrationService;
import com.dentalclinic.service.impl.PatientRegistrationServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.sql.SQLException;

@WebServlet("/register")
public class PatientRegistrationServlet extends HttpServlet {

    private PatientRegistrationService registrationService;

    @Override
    public void init() {
        registrationService =
                new PatientRegistrationServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/auth/register.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword =
                request.getParameter("confirmPassword");

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");

        String dateOfBirthString =
                request.getParameter("dateOfBirth");

        String gender = request.getParameter("gender");
        String address = request.getParameter("address");

        String emergencyContactName =
                request.getParameter("emergencyContactName");

        String emergencyContactPhone =
                request.getParameter("emergencyContactPhone");

        String medicalNotes =
                request.getParameter("medicalNotes");

        try {

            if (password == null
                    || !password.equals(confirmPassword)) {

                throw new ValidationException(
                        "Passwords do not match."
                );
            }

            LocalDate dateOfBirth = null;

            if (dateOfBirthString != null
                    && !dateOfBirthString.isBlank()) {

                try {
                    dateOfBirth =
                            LocalDate.parse(dateOfBirthString);

                } catch (DateTimeParseException e) {

                    throw new ValidationException(
                            "Enter a valid date of birth."
                    );
                }
            }

            User user = new User();

            user.setUsername(username);
            user.setEmail(email);
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setPhone(phone);

            Patient patient = new Patient();

            patient.setDateOfBirth(dateOfBirth);
            patient.setGender(gender);
            patient.setAddress(address);
            patient.setEmergencyContactName(
                    emergencyContactName
            );
            patient.setEmergencyContactPhone(
                    emergencyContactPhone
            );
            patient.setMedicalNotes(medicalNotes);

            int patientId =
                    registrationService.register(
                            user,
                            patient,
                            password
                    );

            response.sendRedirect(
                    request.getContextPath()
                    + "/login?registered=true"
            );

        } catch (ValidationException e) {

            request.setAttribute(
                    "error",
                    e.getMessage()
            );

            request.getRequestDispatcher(
                    "/auth/register.jsp"
            ).forward(request, response);

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to register patient.",
                    e
            );
        }
    }
}