package com.dentalclinic.dao;

import com.dentalclinic.dto.PatientRecordDTO;

import java.sql.SQLException;
import java.util.Optional;

public interface PatientRecordDAO {

    Optional<PatientRecordDTO> findByQrTokenHash(
            String qrTokenHash
    ) throws SQLException;
}