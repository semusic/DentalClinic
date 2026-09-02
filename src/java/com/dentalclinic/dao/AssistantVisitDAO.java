package com.dentalclinic.dao;

import com.dentalclinic.dto.AssistantVisitDTO;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface AssistantVisitDAO {

    List<AssistantVisitDTO> findConfirmedAppointments(
            LocalDate date
    ) throws SQLException;

    Optional<AssistantVisitDTO> findByAppointmentId(
            int appointmentId
    ) throws SQLException;
}