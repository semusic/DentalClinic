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

@WebServlet("/patient/notifications")
public class NotificationServlet
        extends HttpServlet {

    private NotificationService notificationService;

    @Override
    public void init() {

        notificationService =
                new NotificationServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login"
            );

            return;
        }

        Object userIdObject =
                session.getAttribute("userId");

        if (!(userIdObject instanceof Integer)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login"
            );

            return;
        }

        int userId =
                (Integer) userIdObject;

        try {

            List<Notification> notifications =
                    notificationService
                            .getUserNotifications(userId);

            request.setAttribute(
                    "notifications",
                    notifications
            );

            request.getRequestDispatcher(
                    "/patient/notifications.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to load notifications.",
                    e
            );
        }
    }
}