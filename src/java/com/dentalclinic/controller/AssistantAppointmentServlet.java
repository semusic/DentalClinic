package com.dentalclinic.controller;

import com.dentalclinic.dto.AppointmentReviewDTO;
import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.service.AppointmentReviewService;
import com.dentalclinic.service.impl.AppointmentReviewServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

@WebServlet("/assistant/appointments")
public class AssistantAppointmentServlet extends HttpServlet {

    private AppointmentReviewService appointmentReviewService;

    @Override
    public void init() {
        appointmentReviewService =
                new AppointmentReviewServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action =
                request.getParameter("action");

        String idParameter =
                request.getParameter("id");

        try {

            /*
             * No action:
             * Display the appointment queue.
             */
            if (action == null || action.isBlank()) {

                loadQueue(request, response);
                return;
            }

            /*
             * Review action:
             * Open one appointment for review.
             */
            if ("review".equalsIgnoreCase(action)) {

                int appointmentId =
                        parseId(idParameter);

                Optional<AppointmentReviewDTO> review =
                        appointmentReviewService
                                .getReviewById(
                                        appointmentId
                                );

                if (review.isEmpty()) {

                    response.sendError(
                            HttpServletResponse.SC_NOT_FOUND,
                            "Appointment request not found."
                    );

                    return;
                }

                request.setAttribute(
                        "appointmentReview",
                        review.get()
                );

                request.getRequestDispatcher(
                        "/assistant/appointment-review.jsp"
                ).forward(
                        request,
                        response
                );

                return;
            }

            /*
             * Unknown action.
             */
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid appointment action."
            );

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid appointment ID."
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to process appointment request.",
                    e
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action =
                request.getParameter("action");

        String idParameter =
                request.getParameter("id");

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

        int assistantUserId =
                (Integer) userIdObject;

        try {

            int appointmentId =
                    parseId(idParameter);

            /*
             * Assistant starts reviewing request.
             */
            if ("startReview".equalsIgnoreCase(action)) {

                appointmentReviewService.startReview(
                        appointmentId,
                        assistantUserId
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/assistant/appointments"
                        + "?action=review&id="
                        + appointmentId
                );

                return;
            }

            /*
             * Assistant sends reviewed request
             * to doctor for approval.
             */
            if ("sendToDoctor".equalsIgnoreCase(action)) {

                appointmentReviewService.sendToDoctor(
                        appointmentId,
                        assistantUserId
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/assistant/appointments"
                );

                return;
            }

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid appointment action."
            );

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid appointment ID."
            );

        } catch (ValidationException e) {

        request.setAttribute(
                "error",
                e.getMessage()
        );

        try {
            loadQueue(request, response);
        } catch (SQLException sqlException) {

            throw new ServletException(
                    "Unable to reload appointment queue.",
                    sqlException
            );
        }

        } catch (SQLException e) {

                    throw new ServletException(
                            "Unable to update appointment.",
                            e
                    );
                }
            }

    private void loadQueue(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        List<AppointmentReviewDTO> reviews =
                appointmentReviewService
                        .getPendingReviews();

        request.setAttribute(
                "appointmentReviews",
                reviews
        );

        request.getRequestDispatcher(
                "/assistant/appointments.jsp"
        ).forward(
                request,
                response
        );
    }

    private int parseId(String value)
            throws NumberFormatException {

        if (value == null || value.isBlank()) {
            throw new NumberFormatException(
                    "Appointment ID is missing."
            );
        }

        return Integer.parseInt(value);
    }
}