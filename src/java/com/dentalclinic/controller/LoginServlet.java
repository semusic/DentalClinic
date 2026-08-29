package com.dentalclinic.controller;

import com.dentalclinic.model.User;
import com.dentalclinic.service.AuthenticationService;
import com.dentalclinic.service.impl.AuthenticationServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private AuthenticationService authenticationService;

    @Override
    public void init() {
        authenticationService =
                new AuthenticationServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/auth/login.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String username =
                request.getParameter("username");

        String password =
                request.getParameter("password");

        if (username == null || username.isBlank()
                || password == null || password.isBlank()) {

            request.setAttribute(
                    "error",
                    "Username and password are required."
            );

            request.getRequestDispatcher(
                    "/auth/login.jsp"
            ).forward(request, response);

            return;
        }

        try {

            Optional<User> authenticatedUser =
                    authenticationService.authenticate(
                            username,
                            password
                    );

            if (authenticatedUser.isEmpty()) {

                request.setAttribute(
                        "error",
                        "Invalid username or password."
                );

                request.getRequestDispatcher(
                        "/auth/login.jsp"
                ).forward(request, response);

                return;
            }

            User user = authenticatedUser.get();

            HttpSession session =
                    request.getSession(true);

            /*
             * Prevent session fixation by creating a new session
             * after successful authentication.
             */
            session.invalidate();

            session = request.getSession(true);

            session.setAttribute(
                    "authenticatedUser",
                    user
            );

            session.setAttribute(
                    "userId",
                    user.getUserId()
            );

            session.setAttribute(
                    "role",
                    user.getRoleName()
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/dashboard"
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to authenticate user.",
                    e
            );
        }
    }
}