package com.dentalclinic.controller;

import com.dentalclinic.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null
                || session.getAttribute(
                        "authenticatedUser") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login"
            );

            return;
        }

        User user =
                (User) session.getAttribute(
                        "authenticatedUser"
                );

        String role =
                user.getRoleName();

        switch (role) {

            case "PATIENT":
                response.sendRedirect(
                        request.getContextPath()
                        + "/patient/dashboard"
                );
                break;

            case "ASSISTANT":
                response.sendRedirect(
                        request.getContextPath()
                        + "/assistant/dashboard"
                );
                break;

            case "CASHIER":
                response.sendRedirect(
                        request.getContextPath()
                        + "/cashier/dashboard"
                );
                break;

            case "ADMIN":
                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/dashboard"
                );
                break;

            default:
                session.invalidate();

                response.sendRedirect(
                        request.getContextPath()
                        + "/login?error=role"
                );
        }
    }
}