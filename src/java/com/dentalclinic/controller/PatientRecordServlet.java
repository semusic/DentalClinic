package com.dentalclinic.controller;

import com.dentalclinic.dto.PatientRecordDTO;
import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.service.PatientRecordService;
import com.dentalclinic.service.impl.PatientRecordServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/patient-record")
public class PatientRecordServlet
        extends HttpServlet {

    private PatientRecordService
            patientRecordService;

    @Override
    public void init() {

        patientRecordService =
                new PatientRecordServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String token =
                request.getParameter("t");

        try {

            PatientRecordDTO record =
                    patientRecordService
                            .getByQrToken(
                                    token
                            );

            response.setHeader(
                    "Cache-Control",
                    "no-store, no-cache, must-revalidate"
            );

            response.setHeader(
                    "Pragma",
                    "no-cache"
            );

            request.setAttribute(
                    "record",
                    record
            );

            request.getRequestDispatcher(
                    "/patient-record.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (ValidationException e) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    e.getMessage()
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to load patient record.",
                    e
            );
        }
    }
}