package com.dentalclinic.service;

import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.model.VisitService;

import java.sql.SQLException;
import java.util.List;

public interface VisitServiceService {

    int addService(
            int visitId,
            int serviceId,
            int assistantUserId,
            int quantity,
            String treatmentNotes
    ) throws SQLException, ValidationException;

    List<VisitService> getVisitServices(
            int visitId
    ) throws SQLException;

    void removeService(
            int visitServiceId
    ) throws SQLException, ValidationException;
}