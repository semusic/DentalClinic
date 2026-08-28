package com.dentalclinic.dao;

import com.dentalclinic.model.User;
import java.sql.SQLException;
import java.util.Optional;

public interface UserDAO {

    Optional<User> findByUsername(String username) throws SQLException;

    Optional<User> findByEmail(String email) throws SQLException;

    boolean existsByUsername(String username) throws SQLException;

    boolean existsByEmail(String email) throws SQLException;

    int save(User user) throws SQLException;
}