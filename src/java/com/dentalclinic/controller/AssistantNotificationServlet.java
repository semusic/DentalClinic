package com.dentalclinic.controller;

import com.dentalclinic.model.Notification;
import com.dentalclinic.service.NotificationService;
import com.dentalclinic.service.impl.NotificationServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/assistant/notifications")
public class AssistantNotificationServlet extends HttpServlet {

    private NotificationService notificationService;

    @Override
    public void init() {
        notificationService = new NotificationServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Object userIdObject = session.getAttribute("userId");

        if (!(userIdObject instanceof Integer)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) userIdObject;

        String readIdParam = request.getParameter("readId");
        String appointmentIdParam = request.getParameter("appointmentId");

        try {
            /*
             * If marking a notification as read and redirecting to visit detail
             */
            if (readIdParam != null && !readIdParam.isBlank()) {
                try {
                    int readId = Integer.parseInt(readIdParam);
                    notificationService.markAsRead(readId, userId);
                } catch (NumberFormatException ignored) {}

                if (appointmentIdParam != null && !appointmentIdParam.isBlank()) {
                    response.sendRedirect(request.getContextPath() + "/assistant/visits?appointmentId=" + appointmentIdParam);
                    return;
                }
            }

            String markAllRead = request.getParameter("markAllRead");
            if ("true".equalsIgnoreCase(markAllRead)) {
                List<Notification> all = notificationService.getUserNotifications(userId);
                for (Notification n : all) {
                    if (n.getReadAt() == null) {
                        notificationService.markAsRead(n.getNotificationId(), userId);
                    }
                }
                response.sendRedirect(request.getContextPath() + "/assistant/notifications");
                return;
            }

            List<Notification> notifications = notificationService.getUserNotifications(userId);

            request.setAttribute("notifications", notifications);

            request.getRequestDispatcher("/assistant/notifications.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load assistant notifications.", e);
        }
    }
}
