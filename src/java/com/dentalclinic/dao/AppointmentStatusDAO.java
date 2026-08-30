package com.dentalclinic.dao;

import java.sql.SQLException;
import java.util.Optional;

public interface AppointmentStatusDAO {

    Optional<Integer> findStatusIdByCode(
            String statusCode
    ) throws SQLException;
}