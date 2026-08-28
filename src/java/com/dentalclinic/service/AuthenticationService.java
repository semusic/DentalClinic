package com.dentalclinic.service;

import com.dentalclinic.model.User;

import java.sql.SQLException;
import java.util.Optional;

public interface AuthenticationService {

    Optional<User> authenticate(
            String username,
            String password
    ) throws SQLException;
}