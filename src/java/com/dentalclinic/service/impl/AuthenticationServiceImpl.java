package com.dentalclinic.service.impl;

import com.dentalclinic.dao.UserDAO;
import com.dentalclinic.dao.impl.UserDAOImpl;
import com.dentalclinic.model.User;
import com.dentalclinic.service.AuthenticationService;
import com.dentalclinic.util.PasswordHasher;

import java.sql.SQLException;
import java.util.Optional;

public class AuthenticationServiceImpl
        implements AuthenticationService {

    private final UserDAO userDAO;

    public AuthenticationServiceImpl() {
        this.userDAO = new UserDAOImpl();
    }

    @Override
    public Optional<User> authenticate(
            String username,
            String password
    ) throws SQLException {

        if (username == null
                || username.isBlank()
                || password == null
                || password.isBlank()) {

            return Optional.empty();
        }

        Optional<User> user =
                userDAO.findByUsername(username.trim());

        if (user.isEmpty()) {
            return Optional.empty();
        }

        User existingUser = user.get();

        if (!existingUser.isActive()) {
            return Optional.empty();
        }

        boolean valid =
                PasswordHasher.verifyPassword(
                        password,
                        existingUser.getPasswordHash()
                );

        if (!valid) {
            return Optional.empty();
        }

        return Optional.of(existingUser);
    }
}