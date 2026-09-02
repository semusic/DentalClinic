package com.dentalclinic.service;

import com.dentalclinic.dto.PatientRecordDTO;
import com.dentalclinic.exception.ValidationException;

import java.sql.SQLException;

public interface PatientRecordService {

    PatientRecordDTO getByQrToken(
            String rawToken
    ) throws SQLException, ValidationException;
}