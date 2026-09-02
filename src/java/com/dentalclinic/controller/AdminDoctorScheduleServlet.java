package com.dentalclinic.controller;

import com.dentalclinic.dao.DoctorDAO;
import com.dentalclinic.dao.DoctorScheduleDAO;
import com.dentalclinic.dao.impl.DoctorDAOImpl;
import com.dentalclinic.dao.impl.DoctorScheduleDAOImpl;
import com.dentalclinic.model.Doctor;
import com.dentalclinic.model.DoctorSchedule;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/doctor-schedules")
public class AdminDoctorScheduleServlet extends HttpServlet {

    private DoctorScheduleDAO scheduleDAO;
    private DoctorDAO doctorDAO;

    @Override
    public void init() {
        scheduleDAO = new DoctorScheduleDAOImpl();
        doctorDAO = new DoctorDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<DoctorSchedule> schedules = scheduleDAO.findAllSchedules();
            List<Doctor> doctors = doctorDAO.findActiveDoctors();

            Map<Integer, Doctor> doctorMap = new HashMap<>();
            for (Doctor d : doctors) {
                doctorMap.put(d.getDoctorId(), d);
            }

            request.setAttribute("schedules", schedules);
            request.setAttribute("doctors", doctors);
            request.setAttribute("doctorMap", doctorMap);

            request.getRequestDispatcher("/admin/doctor-schedules.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load doctor schedule management page.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("delete".equalsIgnoreCase(action)) {
                int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
                scheduleDAO.deleteSchedule(scheduleId);
                request.getSession().setAttribute("flashMessage", "Schedule slot deleted successfully.");
            } else if ("toggleStatus".equalsIgnoreCase(action)) {
                int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
                boolean currentActive = Boolean.parseBoolean(request.getParameter("active"));
                scheduleDAO.toggleScheduleStatus(scheduleId, !currentActive);
                request.getSession().setAttribute("flashMessage", "Schedule status updated.");
            } else if ("add".equalsIgnoreCase(action)) {
                int doctorId = Integer.parseInt(request.getParameter("doctorId"));
                int dayOfWeek = Integer.parseInt(request.getParameter("dayOfWeek"));
                LocalTime startTime = LocalTime.parse(request.getParameter("startTime"));
                LocalTime endTime = LocalTime.parse(request.getParameter("endTime"));
                int maxAppointments = Integer.parseInt(request.getParameter("maxAppointments"));

                if (!endTime.isAfter(startTime)) {
                    request.getSession().setAttribute("flashError", "Schedule Error: End time must be after start time.");
                    response.sendRedirect(request.getContextPath() + "/admin/doctor-schedules");
                    return;
                }

                if (scheduleDAO.hasOverlappingSchedule(doctorId, dayOfWeek, startTime, endTime, null)) {
                    request.getSession().setAttribute("flashError", "Schedule Error: Overlapping active schedule already exists for this doctor on selected day.");
                    response.sendRedirect(request.getContextPath() + "/admin/doctor-schedules");
                    return;
                }

                DoctorSchedule schedule = new DoctorSchedule();
                schedule.setDoctorId(doctorId);
                schedule.setDayOfWeek(dayOfWeek);
                schedule.setStartTime(startTime);
                schedule.setEndTime(endTime);
                schedule.setMaxAppointments(maxAppointments);
                schedule.setActive(true);

                scheduleDAO.createSchedule(schedule);
                request.getSession().setAttribute("flashMessage", "Doctor working schedule added successfully!");
            }
        } catch (DateTimeParseException | NumberFormatException e) {
            request.getSession().setAttribute("flashError", "Invalid schedule format: " + e.getMessage());
        } catch (SQLException e) {
            request.getSession().setAttribute("flashError", "Database Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/doctor-schedules");
    }
}
