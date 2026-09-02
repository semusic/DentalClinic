package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.VisitServiceDAO;
import com.dentalclinic.model.VisitService;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class VisitServiceDAOImpl
        implements VisitServiceDAO {

    private static final String INSERT_VISIT_SERVICE = """
        INSERT INTO visit_services
        (
            visit_id,
            service_id,
            performed_by_doctor_id,
            quantity,
            unit_price,
            line_total,
            treatment_notes
        )
        VALUES (?, ?, ?, ?, ?, ?, ?)
        """;

    private static final String FIND_BY_VISIT_ID = """
        SELECT
            visit_service_id,
            visit_id,
            service_id,
            performed_by_doctor_id,
            quantity,
            unit_price,
            line_total,
            treatment_notes,
            performed_at,
            created_at
        FROM visit_services
        WHERE visit_id = ?
        ORDER BY performed_at ASC, visit_service_id ASC
        """;

    private static final String DELETE_VISIT_SERVICE = """
        DELETE FROM visit_services
        WHERE visit_service_id = ?
        """;

    @Override
    public int create(
            VisitService visitService
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             INSERT_VISIT_SERVICE,
                             java.sql.Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(
                    1,
                    visitService.getVisitId()
            );

            statement.setInt(
                    2,
                    visitService.getServiceId()
            );

            statement.setInt(
                    3,
                    visitService.getPerformedByDoctorId()
            );

            statement.setInt(
                    4,
                    visitService.getQuantity()
            );

            statement.setBigDecimal(
                    5,
                    visitService.getUnitPrice()
            );

            statement.setBigDecimal(
                    6,
                    visitService.getLineTotal()
            );

            statement.setString(
                    7,
                    visitService.getTreatmentNotes()
            );

            statement.executeUpdate();

            try (ResultSet keys =
                         statement.getGeneratedKeys()) {

                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }

        throw new SQLException(
                "Unable to create visit service."
        );
    }

    @Override
    public List<VisitService> findByVisitId(
            int visitId
    ) throws SQLException {

        List<VisitService> services =
                new ArrayList<>();

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_BY_VISIT_ID)) {

            statement.setInt(
                    1,
                    visitId
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {

                    services.add(
                            mapVisitService(
                                    resultSet
                            )
                    );
                }
            }
        }

        return services;
    }

    @Override
    public boolean delete(
            int visitServiceId
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             DELETE_VISIT_SERVICE)) {

            statement.setInt(
                    1,
                    visitServiceId
            );

            return statement.executeUpdate() > 0;
        }
    }

    private VisitService mapVisitService(
            ResultSet resultSet
    ) throws SQLException {

        VisitService visitService =
                new VisitService();

        visitService.setVisitServiceId(
                resultSet.getInt(
                        "visit_service_id"
                )
        );

        visitService.setVisitId(
                resultSet.getInt(
                        "visit_id"
                )
        );

        visitService.setServiceId(
                resultSet.getInt(
                        "service_id"
                )
        );

        visitService.setPerformedByDoctorId(
                resultSet.getInt(
                        "performed_by_doctor_id"
                )
        );

        visitService.setQuantity(
                resultSet.getInt(
                        "quantity"
                )
        );

        visitService.setUnitPrice(
                resultSet.getBigDecimal(
                        "unit_price"
                )
        );

        visitService.setLineTotal(
                resultSet.getBigDecimal(
                        "line_total"
                )
        );

        visitService.setTreatmentNotes(
                resultSet.getString(
                        "treatment_notes"
                )
        );

        Timestamp performedAt =
                resultSet.getTimestamp(
                        "performed_at"
                );

        if (performedAt != null) {

            visitService.setPerformedAt(
                    performedAt.toLocalDateTime()
            );
        }

        Timestamp createdAt =
                resultSet.getTimestamp(
                        "created_at"
                );

        if (createdAt != null) {

            visitService.setCreatedAt(
                    createdAt.toLocalDateTime()
            );
        }

        return visitService;
    }
}