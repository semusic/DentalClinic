package com.dentalclinic.service.impl;

import com.dentalclinic.dao.PatientDAO;
import com.dentalclinic.dao.RoleDAO;
import com.dentalclinic.dao.UserDAO;
import com.dentalclinic.dao.impl.PatientDAOImpl;
import com.dentalclinic.dao.impl.RoleDAOImpl;
import com.dentalclinic.dao.impl.UserDAOImpl;
import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.model.Patient;
import com.dentalclinic.model.User;
import com.dentalclinic.service.PatientRegistrationService;
import com.dentalclinic.util.DatabaseConnection;
import com.dentalclinic.util.PasswordHasher;

import java.sql.Connection;
import java.sql.SQLException;

public class PatientRegistrationServiceImpl
        implements PatientRegistrationService {

    private final UserDAO userDAO;
    private final PatientDAO patientDAO;
    private final RoleDAO roleDAO;

    public PatientRegistrationServiceImpl() {
        this.userDAO = new UserDAOImpl();
        this.patientDAO = new PatientDAOImpl();
        this.roleDAO = new RoleDAOImpl();
    }

    @Override
    public int register(
            User user,
            Patient patient,
            String plainPassword
    ) throws SQLException, ValidationException {

        validate(user, patient, plainPassword);

        if (userDAO.existsByUsername(
                user.getUsername())) {

            throw new ValidationException(
                    "Username is already registered."
            );
        }

        if (userDAO.existsByEmail(
                user.getEmail())) {

            throw new ValidationException(
                    "Email address is already registered."
            );
        }

        int patientRoleId =
                roleDAO.findRoleIdByName("PATIENT")
                        .orElseThrow(() ->
                                new SQLException(
                                        "PATIENT role is not configured."
                                )
                        );

        user.setRoleId(patientRoleId);

        user.setPasswordHash(
                PasswordHasher.hashPassword(
                        plainPassword
                )
        );

        user.setActive(true);

        try (Connection connection =
                     DatabaseConnection.getConnection()) {

            try {
                connection.setAutoCommit(false);

                int userId =
                        userDAO.save(
                                user,
                                connection
                        );

                patient.setUserId(userId);

                int patientId =
                        patientDAO.save(
                                patient,
                                connection
                        );

                connection.commit();

                return patientId;

            } catch (SQLException | RuntimeException e) {

                try {
                    connection.rollback();
                } catch (SQLException rollbackError) {
                    e.addSuppressed(rollbackError);
                }

                throw e;

            } finally {
                connection.setAutoCommit(true);
            }
        }
    }

    private void validate(
            User user,
            Patient patient,
            String plainPassword
    ) throws ValidationException {

        if (user == null || patient == null) {
            throw new ValidationException(
                    "Registration information is required."
            );
        }

        if (isBlank(user.getUsername())) {
            throw new ValidationException(
                    "Username is required."
            );
        }

        if (user.getUsername().length() > 50) {
            throw new ValidationException(
                    "Username must not exceed 50 characters."
            );
        }

        if (isBlank(user.getEmail())) {
            throw new ValidationException(
                    "Email is required."
            );
        }

        if (!user.getEmail().matches(
                "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {

            throw new ValidationException(
                    "Enter a valid email address."
            );
        }

        if (isBlank(plainPassword)
                || plainPassword.length() < 8) {

            throw new ValidationException(
                    "Password must contain at least 8 characters."
            );
        }

        if (isBlank(user.getFirstName())) {
            throw new ValidationException(
                    "First name is required."
            );
        }

        if (isBlank(user.getLastName())) {
            throw new ValidationException(
                    "Last name is required."
            );
        }

        if (patient.getDateOfBirth() != null
                && patient.getDateOfBirth()
                           .isAfter(
                                   java.time.LocalDate.now()
                           )) {

            throw new ValidationException(
                    "Date of birth cannot be in the future."
            );
        }
    }

    private boolean isBlank(String value) {
        return value == null
                || value.isBlank();
    }
}