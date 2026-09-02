package com.dentalclinic.dao;

import com.dentalclinic.model.DoctorSchedule;

import java.sql.SQLException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface DoctorScheduleDAO {

    List<DoctorSchedule> findAllSchedules() throws SQLException;

    List<DoctorSchedule> findByDoctorId(int doctorId) throws SQLException;

    List<DoctorSchedule> findByDoctorIdAndDay(int doctorId, DayOfWeek dayOfWeek) throws SQLException;

    boolean hasSchedule(int doctorId, LocalDate date) throws SQLException;

    int createSchedule(DoctorSchedule schedule) throws SQLException;

    boolean updateSchedule(DoctorSchedule schedule) throws SQLException;

    boolean toggleScheduleStatus(int scheduleId, boolean active) throws SQLException;

    boolean deleteSchedule(int scheduleId) throws SQLException;

    boolean hasOverlappingSchedule(int doctorId, int dayOfWeek, LocalTime startTime, LocalTime endTime, Integer excludeScheduleId) throws SQLException;
}