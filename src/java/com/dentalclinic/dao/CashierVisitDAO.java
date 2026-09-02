package com.dentalclinic.dao;

import com.dentalclinic.dto.CashierVisitDTO;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface CashierVisitDAO {

    List<CashierVisitDTO> findVisitsReadyForBilling()
            throws SQLException;

    Optional<CashierVisitDTO> findByVisitId(
            int visitId
    ) throws SQLException;
}