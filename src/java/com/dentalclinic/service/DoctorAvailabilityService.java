package com.dentalclinic.service;

import com.dentalclinic.model.DoctorSchedule;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface DoctorAvailabilityService {

    List<DoctorSchedule> getSchedules(int doctorId, LocalDate date) throws SQLException;

    boolean isWithinWorkingHours(int doctorId, LocalDate date, LocalTime time) throws SQLException;

    boolean isWithinWorkingHours(int doctorId, LocalDate date, LocalTime time, int durationMinutes) throws SQLException;
}