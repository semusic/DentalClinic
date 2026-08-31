package com.dentalclinic.controller;

import com.dentalclinic.dto.DoctorApprovalReviewDTO;
import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.service.DoctorApprovalService;
import com.dentalclinic.service.impl.DoctorApprovalServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

@WebServlet("/doctor/approval")
public class DoctorApprovalServlet extends HttpServlet {

    private DoctorApprovalService doctorApprovalService;

    @Override
    public void init() {

        doctorApprovalService =
                new DoctorApprovalServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String token =
                request.getParameter("token");

        try {

            if (token == null || token.isBlank()) {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Approval token is required."
                );

                return;
            }

            Optional<DoctorApprovalReviewDTO> approval =
                    doctorApprovalService
                            .getApprovalByToken(token);

            if (approval.isEmpty()) {

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Approval request could not be found."
                );

                return;
            }

            request.setAttribute(
                    "approval",
                    approval.get()
            );

            request.setAttribute(
                    "token",
                    token
            );

            request.getRequestDispatcher(
                    "/doctor/doctor-approval.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (ValidationException e) {

            request.setAttribute(
                    "error",
                    e.getMessage()
            );

            request.getRequestDispatcher(
                    "/doctor/doctor-approval.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to load doctor approval request.",
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

            String token =
                    request.getParameter("token");

            String decision =
                    request.getParameter("decision");

            String decisionNote =
                    request.getParameter("decisionNote");

            try {

            if (token == null || token.isBlank()) {

                throw new ValidationException(
                        "Approval token is required."
                );
            }

            if (decision == null
                    || decision.isBlank()) {

                throw new ValidationException(
                        "A decision is required."
                );
            }

            switch (decision) {

                case "APPROVED" ->

                        doctorApprovalService.approve(
                                token,
                                decisionNote
                        );

                case "REJECTED" ->

                        doctorApprovalService.reject(
                                token,
                                decisionNote
                        );

                case "RESCHEDULE_REQUIRED" ->

                        doctorApprovalService
                                .requestReschedule(
                                        token,
                                        decisionNote
                                );

                default ->

                        throw new ValidationException(
                                "Invalid doctor decision."
                        );
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/doctor/approval/result?decision="
                    + java.net.URLEncoder.encode(
                            decision,
                            java.nio.charset.StandardCharsets.UTF_8
                    )
            );

        } catch (ValidationException e) {

    request.setAttribute(
            "error",
            e.getMessage()
    );

        try {

         Optional<DoctorApprovalReviewDTO> approval =
                 doctorApprovalService
                         .getApprovalByToken(token);

         if (approval.isPresent()) {

             request.setAttribute(
                     "approval",
                     approval.get()
             );
         }

     } catch (SQLException sqlException) {

         throw new ServletException(
                 "Unable to reload approval request.",
                 sqlException
         );

     } catch (ValidationException validationException) {

    
    }

    request.setAttribute(
            "token",
            token
    );

    request.getRequestDispatcher(
            "/doctor/doctor-approval.jsp"
    ).forward(
            request,
            response
    );


        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to process doctor decision.",
                    e
            );
        }
    }
}