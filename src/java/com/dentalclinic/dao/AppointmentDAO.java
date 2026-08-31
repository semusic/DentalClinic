package com.dentalclinic.dao;

import com.dentalclinic.model.Appointment;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface AppointmentDAO {

    int save(Appointment appointment) throws SQLException;

    Optional<Appointment> findById(int appointmentId)
            throws SQLException;

    List<Appointment> findByPatientId(int patientId)
            throws SQLException;

    List<Appointment> findPendingRequests()
            throws SQLException;

    boolean existsRequestedSlot(
            int doctorId,
            LocalDate requestedDate,
            java.time.LocalTime requestedTime
    ) throws SQLException;

    boolean hasScheduleConflict(
            int doctorId,
            LocalDateTime scheduledStart,
            LocalDateTime scheduledEnd,
            Integer excludeAppointmentId
    ) throws SQLException;
    
    boolean updateStatus(
        int appointmentId,
        int statusId,
        int changedByUserId,
        String reason
) throws SQLException;
}