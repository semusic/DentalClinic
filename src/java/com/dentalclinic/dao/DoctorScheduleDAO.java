package com.dentalclinic.dao;

import com.dentalclinic.model.DoctorSchedule;

import java.sql.SQLException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.List;

public interface DoctorScheduleDAO {

    List<DoctorSchedule> findByDoctorIdAndDay(
            int doctorId,
            DayOfWeek dayOfWeek
    ) throws SQLException;

    boolean hasSchedule(
            int doctorId,
            LocalDate date
    ) throws SQLException;
}