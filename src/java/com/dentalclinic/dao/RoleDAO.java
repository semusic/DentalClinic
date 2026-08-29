package com.dentalclinic.dao;

import java.sql.SQLException;
import java.util.Optional;

public interface RoleDAO {

    Optional<Integer> findRoleIdByName(
            String roleName
    ) throws SQLException;
}