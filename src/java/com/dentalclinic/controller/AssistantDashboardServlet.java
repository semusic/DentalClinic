package com.dentalclinic.controller;

import com.dentalclinic.dto.AppointmentReviewDTO;
import com.dentalclinic.dto.AssistantVisitDTO;
import com.dentalclinic.model.Notification;
import com.dentalclinic.service.AppointmentReviewService;
import com.dentalclinic.service.AssistantVisitService;
import com.dentalclinic.service.NotificationService;
import com.dentalclinic.service.impl.AppointmentReviewServiceImpl;
import com.dentalclinic.service.impl.AssistantVisitServiceImpl;
import com.dentalclinic.service.impl.NotificationServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;

@WebServlet("/assistant/dashboard")
public class AssistantDashboardServlet extends HttpServlet {

    private NotificationService notificationService;
    private AppointmentReviewService reviewService;
    private AssistantVisitService visitService;

    @Override
    public void init() {
        notificationService = new NotificationServiceImpl();
        reviewService = new AppointmentReviewServiceImpl();
        visitService = new AssistantVisitServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = 0;
        if (session != null && session.getAttribute("userId") instanceof Integer) {
            userId = (Integer) session.getAttribute("userId");
        }

        try {
            List<Notification> notifications = Collections.emptyList();
            if (userId > 0) {
                notifications = notificationService.getUserNotifications(userId);
            }

            List<AppointmentReviewDTO> pendingReviews = reviewService.getPendingReviews();
            List<AssistantVisitDTO> confirmedVisits = visitService.getConfirmedAppointments(null);

            request.setAttribute("notifications", notifications);
            request.setAttribute("pendingCount", pendingReviews.size());
            request.setAttribute("confirmedCount", confirmedVisits.size());

            request.getRequestDispatcher("/assistant/dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load assistant dashboard data.", e);
        }
    }
}