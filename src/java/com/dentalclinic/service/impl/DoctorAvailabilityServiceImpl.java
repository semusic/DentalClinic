package com.dentalclinic.service.impl;

import com.dentalclinic.dao.AppointmentDAO;
import com.dentalclinic.dao.DoctorDAO;
import com.dentalclinic.dao.DoctorScheduleDAO;
import com.dentalclinic.dao.ServiceDAO;
import com.dentalclinic.dao.impl.AppointmentDAOImpl;
import com.dentalclinic.dao.impl.DoctorDAOImpl;
import com.dentalclinic.dao.impl.DoctorScheduleDAOImpl;
import com.dentalclinic.dao.impl.ServiceDAOImpl;
import com.dentalclinic.dto.TimeSlotDTO;
import com.dentalclinic.model.Doctor;
import com.dentalclinic.model.DoctorSchedule;
import com.dentalclinic.model.Service;
import com.dentalclinic.service.DoctorAvailabilityService;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class DoctorAvailabilityServiceImpl implements DoctorAvailabilityService {

    private final DoctorScheduleDAO scheduleDAO;
    private final ServiceDAO serviceDAO;
    private final DoctorDAO doctorDAO;
    private final AppointmentDAO appointmentDAO;

    public DoctorAvailabilityServiceImpl() {
        this.scheduleDAO = new DoctorScheduleDAOImpl();
        this.serviceDAO = new ServiceDAOImpl();
        this.doctorDAO = new DoctorDAOImpl();
        this.appointmentDAO = new AppointmentDAOImpl();
    }

    @Override
    public List<DoctorSchedule> getSchedules(int doctorId, LocalDate date) throws SQLException {
        if (date == null) {
            return List.of();
        }
        return scheduleDAO.findByDoctorIdAndDay(doctorId, date.getDayOfWeek());
    }

    @Override
    public boolean isWithinWorkingHours(int doctorId, LocalDate date, LocalTime time) throws SQLException {
        return isWithinWorkingHours(doctorId, date, time, 0);
    }

    @Override
    public boolean isWithinWorkingHours(int doctorId, LocalDate date, LocalTime time, int durationMinutes) throws SQLException {
        if (date == null || time == null) {
            return false;
        }

        List<DoctorSchedule> schedules = getSchedules(doctorId, date);
        if (schedules.isEmpty()) {
            return false;
        }

        LocalTime endTime = durationMinutes > 0 ? time.plusMinutes(durationMinutes) : time;

        for (DoctorSchedule schedule : schedules) {
            if (!time.isBefore(schedule.getStartTime()) && !endTime.isAfter(schedule.getEndTime())) {
                return true;
            }
        }

        return false;
    }

    @Override
    public List<TimeSlotDTO> getAvailableSlots(int doctorId, int serviceId, LocalDate date, Integer excludeAppointmentId) throws SQLException {
        List<TimeSlotDTO> slots = new ArrayList<>();

        if (doctorId <= 0 || serviceId <= 0 || date == null) {
            return slots;
        }

        Optional<Doctor> doctorOpt = doctorDAO.findById(doctorId);
        if (doctorOpt.isEmpty() || !doctorOpt.get().isActive()) {
            return slots;
        }

        Optional<Service> serviceOpt = serviceDAO.findById(serviceId);
        if (serviceOpt.isEmpty() || !serviceOpt.get().isActive()) {
            return slots;
        }

        int durationMinutes = serviceOpt.get().getDurationMinutes();
        if (durationMinutes <= 0) {
            durationMinutes = 30; // fallback
        }

        List<DoctorSchedule> schedules = getSchedules(doctorId, date);
        if (schedules.isEmpty()) {
            return slots;
        }

        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
        DateTimeFormatter displayFormatter = DateTimeFormatter.ofPattern("hh:mm a");
        LocalTime nowTime = LocalTime.now();
        boolean isToday = date.isEqual(LocalDate.now());

        for (DoctorSchedule schedule : schedules) {
            LocalTime startTime = schedule.getStartTime();
            LocalTime endTime = schedule.getEndTime();

            LocalTime current = startTime;
            while (current != null && !current.isAfter(endTime)) {
                LocalTime candidateStart = current;
                LocalTime candidateEnd = candidateStart.plusMinutes(durationMinutes);

                boolean available = true;
                String reason = "Available";

                // Check 1: Must fit within doctor's working schedule
                if (candidateEnd.isAfter(endTime) || candidateStart.isBefore(startTime)) {
                    available = false;
                    reason = "Outside working hours";
                }

                // Check 2: Must not be in the past for today
                if (available && isToday && candidateStart.isBefore(nowTime)) {
                    available = false;
                    reason = "Past time";
                }

                // Check 3: Must not conflict with existing appointments
                if (available) {
                    LocalDateTime startDateTime = LocalDateTime.of(date, candidateStart);
                    LocalDateTime endDateTime = LocalDateTime.of(date, candidateEnd);

                    boolean conflict = appointmentDAO.hasScheduleConflict(
                            doctorId,
                            startDateTime,
                            endDateTime,
                            excludeAppointmentId
                    );

                    if (conflict) {
                        available = false;
                        reason = "Already booked";
                    }
                }

                // Add slot if it starts within working hours
                if (!candidateStart.isAfter(endTime.minusMinutes(15))) {
                    slots.add(new TimeSlotDTO(
                            candidateStart.format(timeFormatter),
                            candidateStart.format(displayFormatter),
                            available,
                            reason
                    ));
                }

                current = current.plusMinutes(30);

                // Prevent infinite loop if wrap-around
                if (current.isBefore(startTime)) {
                    break;
                }
            }
        }

        return slots;
    }
}