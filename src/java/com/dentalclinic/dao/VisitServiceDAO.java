package com.dentalclinic.dao;

import com.dentalclinic.model.VisitService;

import java.sql.SQLException;
import java.util.List;

public interface VisitServiceDAO {

    int create(
            VisitService visitService
    ) throws SQLException;

    List<VisitService> findByVisitId(
            int visitId
    ) throws SQLException;

    boolean delete(
            int visitServiceId
    ) throws SQLException;
}