package com.dentalclinic.service.impl;

import com.dentalclinic.dao.DoctorScheduleDAO;
import com.dentalclinic.dao.impl.DoctorScheduleDAOImpl;
import com.dentalclinic.model.DoctorSchedule;
import com.dentalclinic.service.DoctorAvailabilityService;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public class DoctorAvailabilityServiceImpl
        implements DoctorAvailabilityService {

    private final DoctorScheduleDAO scheduleDAO;

    public DoctorAvailabilityServiceImpl() {
        this.scheduleDAO =
                new DoctorScheduleDAOImpl();
    }

    @Override
    public List<DoctorSchedule> getSchedules(
            int doctorId,
            LocalDate date
    ) throws SQLException {

        if (date == null) {
            return List.of();
        }

        return scheduleDAO.findByDoctorIdAndDay(
                doctorId,
                date.getDayOfWeek()
        );
    }

    @Override
    public boolean isWithinWorkingHours(
            int doctorId,
            LocalDate date,
            LocalTime time
    ) throws SQLException {

        if (date == null || time == null) {
            return false;
        }

        List<DoctorSchedule> schedules =
                getSchedules(doctorId, date);

        for (DoctorSchedule schedule : schedules) {

            if (!time.isBefore(schedule.getStartTime())
                    && time.isBefore(
                            schedule.getEndTime()
                    )) {

                return true;
            }
        }

        return false;
    }
}