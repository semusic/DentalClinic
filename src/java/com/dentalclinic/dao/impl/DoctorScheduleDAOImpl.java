package com.dentalclinic.dao.impl;

import com.dentalclinic.dao.DoctorScheduleDAO;
import com.dentalclinic.model.DoctorSchedule;
import com.dentalclinic.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class DoctorScheduleDAOImpl
        implements DoctorScheduleDAO {

    private static final String FIND_BY_DOCTOR_AND_DAY = """
        SELECT
            schedule_id,
            doctor_id,
            day_of_week,
            start_time,
            end_time,
            max_appointments,
            is_active
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

    @Override
    public List<DoctorSchedule> findByDoctorIdAndDay(
            int doctorId,
            DayOfWeek dayOfWeek
    ) throws SQLException {

        List<DoctorSchedule> schedules =
                new ArrayList<>();

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_BY_DOCTOR_AND_DAY)) {

            statement.setInt(1, doctorId);

            /*
             * java.time.DayOfWeek:
             * MONDAY = 1 ... SUNDAY = 7
             *
             * This matches the database design.
             */
            statement.setInt(
                    2,
                    dayOfWeek.getValue()
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {

                    DoctorSchedule schedule =
                            new DoctorSchedule();

                    schedule.setScheduleId(
                            resultSet.getInt(
                                    "schedule_id"
                            )
                    );

                    schedule.setDoctorId(
                            resultSet.getInt(
                                    "doctor_id"
                            )
                    );

                    schedule.setDayOfWeek(
                            resultSet.getInt(
                                    "day_of_week"
                            )
                    );

                    schedule.setStartTime(
                            resultSet.getTime(
                                    "start_time"
                            ).toLocalTime()
                    );

                    schedule.setEndTime(
                            resultSet.getTime(
                                    "end_time"
                            ).toLocalTime()
                    );

                    schedule.setMaxAppointments(
                            resultSet.getInt(
                                    "max_appointments"
                            )
                    );

                    schedule.setActive(
                            resultSet.getBoolean(
                                    "is_active"
                            )
                    );

                    schedules.add(schedule);
                }
            }
        }

        return schedules;
    }

    @Override
    public boolean hasSchedule(
            int doctorId,
            LocalDate date
    ) throws SQLException {

        try (Connection connection =
                     DatabaseConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             HAS_SCHEDULE)) {

            statement.setInt(1, doctorId);

            statement.setInt(
                    2,
                    date.getDayOfWeek().getValue()
            );

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                return resultSet.next()
                        && resultSet.getInt(1) > 0;
            }
        }
    }
}