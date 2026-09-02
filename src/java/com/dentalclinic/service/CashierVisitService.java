package com.dentalclinic.service;

import com.dentalclinic.dto.CashierVisitDTO;
import com.dentalclinic.exception.ValidationException;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface CashierVisitService {

    List<CashierVisitDTO> getVisitsReadyForBilling()
            throws SQLException;

    CashierVisitDTO getVisitForBilling(
            int visitId
    ) throws SQLException, ValidationException;
}