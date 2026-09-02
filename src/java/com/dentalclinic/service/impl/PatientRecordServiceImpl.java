package com.dentalclinic.service.impl;

import com.dentalclinic.dao.PatientRecordDAO;
import com.dentalclinic.dao.impl.PatientRecordDAOImpl;
import com.dentalclinic.dto.PatientRecordDTO;
import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.service.QrTokenService;
import com.dentalclinic.service.PatientRecordService;

import java.sql.SQLException;

public class PatientRecordServiceImpl
        implements PatientRecordService {

    private final PatientRecordDAO patientRecordDAO;
    private final QrTokenService qrTokenService;

    public PatientRecordServiceImpl() {

        this.patientRecordDAO =
                new PatientRecordDAOImpl();

        this.qrTokenService =
                new QrTokenService();
    }

    @Override
    public PatientRecordDTO getByQrToken(
            String rawToken
    ) throws SQLException, ValidationException {

        if (rawToken == null
                || rawToken.isBlank()) {

            throw new ValidationException(
                    "QR token is required."
            );
        }

        if (rawToken.length() > 500) {

            throw new ValidationException(
                    "Invalid QR token."
            );
        }

        String tokenHash =
                qrTokenService.hashToken(
                        rawToken
                );

        return patientRecordDAO
                .findByQrTokenHash(
                        tokenHash
                )
                .orElseThrow(() ->
                        new ValidationException(
                                "This patient record link is invalid or no longer available."
                        )
                );
    }
}