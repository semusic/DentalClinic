package com.dentalclinic.service.impl;

import com.dentalclinic.dao.CashierVisitDAO;
import com.dentalclinic.dao.impl.CashierVisitDAOImpl;
import com.dentalclinic.dto.CashierVisitDTO;
import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.service.CashierVisitService;

import java.sql.SQLException;
import java.util.List;

public class CashierVisitServiceImpl
        implements CashierVisitService {

    private final CashierVisitDAO cashierVisitDAO;

    public CashierVisitServiceImpl() {

        this.cashierVisitDAO =
                new CashierVisitDAOImpl();
    }

    @Override
    public List<CashierVisitDTO>
    getVisitsReadyForBilling()
            throws SQLException {

        return cashierVisitDAO
                .findVisitsReadyForBilling();
    }

    @Override
    public CashierVisitDTO getVisitForBilling(
            int visitId
    ) throws SQLException, ValidationException {

        if (visitId <= 0) {

            throw new ValidationException(
                    "Invalid visit."
            );
        }

        return cashierVisitDAO
                .findByVisitId(
                        visitId
                )
                .orElseThrow(() ->
                        new ValidationException(
                                "Patient visit could not be found."
                        )
                );
    }
}