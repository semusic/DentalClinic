package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.DoctorScheduleDAO;
import com.dentalclinic.model.DoctorSchedule;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class DoctorScheduleDAOImpl implements DoctorScheduleDAO {

    private static final String FIND_ALL_SCHEDULES = """
        SELECT schedule_id, doctor_id, day_of_week, start_time, end_time, max_appointments, is_active
        FROM doctor_schedules
        ORDER BY doctor_id, day_of_week, start_time
        """;

    private static final String FIND_BY_DOCTOR = """
        SELECT schedule_id, doctor_id, day_of_week, start_time, end_time, max_appointments, is_active
        FROM doctor_schedules
        WHERE doctor_id = ?
        ORDER BY day_of_week, start_time
        """;

    private static final String FIND_BY_DOCTOR_AND_DAY = """
        SELECT schedule_id, doctor_id, day_of_week, start_time, end_time, max_appointments, is_active
        FROM doctor_schedules
        WHERE doctor_id = ?
          AND day_of_week = ?
          AND is_active = TRUE
        ORDER BY start_time
        """;

    private static final String HAS_SCHEDULE = """
        SELECT COUNT(*)
        FROM doctor_schedules
        WHERE doctor_id = ?
          AND day_of_week = ?
          AND is_active = TRUE
        """;

    private static final String CREATE_SCHEDULE = """
        INSERT INTO doctor_schedules (doctor_id, day_of_week, start_time, end_time, max_appointments, is_active)
        VALUES (?, ?, ?, ?, ?, ?)
        """;

    private static final String UPDATE_SCHEDULE = """
        UPDATE doctor_schedules
        SET doctor_id = ?, day_of_week = ?, start_time = ?, end_time = ?, max_appointments = ?
        WHERE schedule_id = ?
        """;

    private static final String TOGGLE_STATUS = """
        UPDATE doctor_schedules SET is_active = ? WHERE schedule_id = ?
        """;

    private static final String DELETE_SCHEDULE = """
        DELETE FROM doctor_schedules WHERE schedule_id = ?
        """;

    private static final String HAS_OVERLAPPING_SCHEDULE = """
        SELECT COUNT(*)
        FROM doctor_schedules
        WHERE doctor_id = ?
          AND day_of_week = ?
          AND is_active = TRUE
          AND start_time < ?
          AND end_time > ?
          AND (? IS NULL OR schedule_id <> ?)
        """;

    @Override
    public List<DoctorSchedule> findAllSchedules() throws SQLException {
        List<DoctorSchedule> schedules = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(FIND_ALL_SCHEDULES);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                schedules.add(mapSchedule(resultSet));
            }
        }
        return schedules;
    }

    @Override
    public List<DoctorSchedule> findByDoctorId(int doctorId) throws SQLException {
        List<DoctorSchedule> schedules = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(FIND_BY_DOCTOR)) {
            statement.setInt(1, doctorId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    schedules.add(mapSchedule(resultSet));
                }
            }
        }
        return schedules;
    }

    @Override
    public List<DoctorSchedule> findByDoctorIdAndDay(int doctorId, DayOfWeek dayOfWeek) throws SQLException {
        List<DoctorSchedule> schedules = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(FIND_BY_DOCTOR_AND_DAY)) {
            statement.setInt(1, doctorId);
            statement.setInt(2, dayOfWeek.getValue());

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    schedules.add(mapSchedule(resultSet));
                }
            }
        }
        return schedules;
    }

    @Override
    public boolean hasSchedule(int doctorId, LocalDate date) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(HAS_SCHEDULE)) {
            statement.setInt(1, doctorId);
            statement.setInt(2, date.getDayOfWeek().getValue());

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() && resultSet.getInt(1) > 0;
            }
        }
    }

    @Override
    public int createSchedule(DoctorSchedule schedule) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(CREATE_SCHEDULE, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, schedule.getDoctorId());
            statement.setInt(2, schedule.getDayOfWeek());
            statement.setTime(3, Time.valueOf(schedule.getStartTime()));
            statement.setTime(4, Time.valueOf(schedule.getEndTime()));
            statement.setInt(5, schedule.getMaxAppointments() > 0 ? schedule.getMaxAppointments() : 10);
            statement.setBoolean(6, schedule.isActive());

            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        throw new SQLException("Failed to create doctor schedule.");
    }

    @Override
    public boolean updateSchedule(DoctorSchedule schedule) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_SCHEDULE)) {
            statement.setInt(1, schedule.getDoctorId());
            statement.setInt(2, schedule.getDayOfWeek());
            statement.setTime(3, Time.valueOf(schedule.getStartTime()));
            statement.setTime(4, Time.valueOf(schedule.getEndTime()));
            statement.setInt(5, schedule.getMaxAppointments());
            statement.setInt(6, schedule.getScheduleId());

            return statement.executeUpdate() > 0;
        }
    }

    @Override
    public boolean toggleScheduleStatus(int scheduleId, boolean active) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(TOGGLE_STATUS)) {
            statement.setBoolean(1, active);
            statement.setInt(2, scheduleId);
            return statement.executeUpdate() > 0;
        }
    }

    @Override
    public boolean deleteSchedule(int scheduleId) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_SCHEDULE)) {
            statement.setInt(1, scheduleId);
            return statement.executeUpdate() > 0;
        }
    }

    @Override
    public boolean hasOverlappingSchedule(int doctorId, int dayOfWeek, LocalTime startTime, LocalTime endTime, Integer excludeScheduleId) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(HAS_OVERLAPPING_SCHEDULE)) {
            statement.setInt(1, doctorId);
            statement.setInt(2, dayOfWeek);
            statement.setTime(3, Time.valueOf(endTime));
            statement.setTime(4, Time.valueOf(startTime));
            if (excludeScheduleId != null) {
                statement.setInt(5, excludeScheduleId);
                statement.setInt(6, excludeScheduleId);
            } else {
                statement.setNull(5, java.sql.Types.INTEGER);
                statement.setNull(6, java.sql.Types.INTEGER);
            }

            try (ResultSet rs = statement.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    private DoctorSchedule mapSchedule(ResultSet resultSet) throws SQLException {
        DoctorSchedule schedule = new DoctorSchedule();
        schedule.setScheduleId(resultSet.getInt("schedule_id"));
        schedule.setDoctorId(resultSet.getInt("doctor_id"));
        schedule.setDayOfWeek(resultSet.getInt("day_of_week"));
        schedule.setStartTime(resultSet.getTime("start_time").toLocalTime());
        schedule.setEndTime(resultSet.getTime("end_time").toLocalTime());
        schedule.setMaxAppointments(resultSet.getInt("max_appointments"));
        schedule.setActive(resultSet.getBoolean("is_active"));
        return schedule;
    }
}