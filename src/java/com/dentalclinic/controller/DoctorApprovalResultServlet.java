package com.dentalclinic.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/doctor/approval/result")
public class DoctorApprovalResultServlet
        extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String decision =
                request.getParameter("decision");

        request.setAttribute(
                "decision",
                decision
        );

        request.getRequestDispatcher(
                "/doctor/approval-result.jsp"
        ).forward(
                request,
                response
        );
    }
}