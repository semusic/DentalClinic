package com.dentalclinic.dao;

import com.dentalclinic.model.VisitMedication;

import java.sql.SQLException;
import java.util.List;

public interface VisitMedicationDAO {

    int create(
            VisitMedication medication
    ) throws SQLException;

    List<VisitMedication> findByVisitId(
            int visitId
    ) throws SQLException;

    boolean markProvided(
            int visitMedicationId
    ) throws SQLException;

    boolean delete(
            int visitMedicationId
    ) throws SQLException;
}