package com.dentalclinic.controller;

import com.dentalclinic.dao.ServiceDAO;
import com.dentalclinic.dao.impl.ServiceDAOImpl;
import com.dentalclinic.dto.AssistantVisitDTO;
import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.model.PatientVisit;
import com.dentalclinic.model.Service;
import com.dentalclinic.model.VisitService;
import com.dentalclinic.service.AssistantVisitService;
import com.dentalclinic.service.impl.AssistantVisitServiceImpl;
import com.dentalclinic.service.impl.VisitServiceServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

@WebServlet("/assistant/visits")
public class AssistantVisitServlet
        extends HttpServlet {

    private AssistantVisitService assistantVisitService;
    private ServiceDAO serviceDAO;
    private VisitServiceServiceImpl visitServiceService;

    @Override
    public void init() {

        assistantVisitService =
                new AssistantVisitServiceImpl();

        serviceDAO =
                new ServiceDAOImpl();

        visitServiceService =
                new VisitServiceServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String appointmentIdParameter =
                request.getParameter("appointmentId");

        String visitIdParameter =
                request.getParameter("visitId");

        String dateParameter =
                request.getParameter("date");

        try {

            /*
             * --------------------------------------------------
             * 1. Open an existing patient visit
             * --------------------------------------------------
             */
            if (visitIdParameter != null
                    && !visitIdParameter.isBlank()) {

                int visitId =
                        parsePositiveInt(
                                visitIdParameter,
                                "Invalid visit ID."
                        );

                loadVisitDetail(
                        request,
                        response,
                        visitId
                );

                return;
            }

            /*
             * --------------------------------------------------
             * 2. Open an appointment before a visit exists
             * --------------------------------------------------
             */
            if (appointmentIdParameter != null
                    && !appointmentIdParameter.isBlank()) {

                int appointmentId =
                        parsePositiveInt(
                                appointmentIdParameter,
                                "Invalid appointment ID."
                        );

                Optional<AssistantVisitDTO> appointment =
                        assistantVisitService
                                .getAppointment(
                                        appointmentId
                                );

                if (appointment.isEmpty()) {

                    response.sendError(
                            HttpServletResponse.SC_NOT_FOUND,
                            "Appointment could not be found."
                    );

                    return;
                }

                List<Service> availableServices =
                        serviceDAO.findAllActive();

                request.setAttribute(
                        "appointment",
                        appointment.get()
                );

                request.setAttribute(
                        "availableServices",
                        availableServices
                );

                request.setAttribute(
                        "visitServices",
                        Collections.emptyList()
                );

                request.getRequestDispatcher(
                        "/assistant/visit-detail.jsp"
                ).forward(
                        request,
                        response
                );

                return;
            }

            /*
             * --------------------------------------------------
             * 3. Display confirmed appointments
             * --------------------------------------------------
             */
            LocalDate date = null;
            boolean showAll = "all".equalsIgnoreCase(dateParameter);

            if (!showAll) {
                if (dateParameter == null || dateParameter.isBlank()) {
                    date = LocalDate.now();
                } else {
                    date = LocalDate.parse(dateParameter);
                }
            }

            List<AssistantVisitDTO> appointments =
                    assistantVisitService.getConfirmedAppointments(date);

            if (dateParameter == null && appointments.isEmpty()) {
                List<AssistantVisitDTO> allAppointments =
                        assistantVisitService.getConfirmedAppointments(null);
                if (!allAppointments.isEmpty()) {
                    appointments = allAppointments;
                    showAll = true;
                }
            }

            request.setAttribute(
                    "appointments",
                    appointments
            );

            request.setAttribute(
                    "selectedDate",
                    date
            );

            request.setAttribute(
                    "showAll",
                    showAll
            );

            request.getRequestDispatcher(
                    "/assistant/visits.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (ValidationException e) {

            request.setAttribute(
                    "error",
                    e.getMessage()
            );


            if (visitIdParameter != null
                    && !visitIdParameter.isBlank()) {

                try {

                    int visitId =
                            Integer.parseInt(
                                    visitIdParameter
                            );

                    loadVisitDetail(
                            request,
                            response,
                            visitId
                    );

                    return;

                } catch (NumberFormatException ignored) {

                    // Continue to normal error handling.
                }
            }

            try {

                LocalDate date;

                if (dateParameter == null
                        || dateParameter.isBlank()) {

                    date = LocalDate.now();

                } else {

                    date =
                            LocalDate.parse(
                                    dateParameter
                            );
                }

                request.setAttribute(
                        "appointments",
                        assistantVisitService
                                .getConfirmedAppointments(
                                        date
                                )
                );

                request.setAttribute(
                        "selectedDate",
                        date
                );

                request.getRequestDispatcher(
                        "/assistant/visits.jsp"
                ).forward(
                        request,
                        response
                );

            } catch (SQLException sqlException) {

                throw new ServletException(
                        "Unable to reload assistant visits.",
                        sqlException
                );
            }

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid ID."
            );

        } catch (java.time.format.DateTimeParseException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid date."
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to load assistant visit information.",
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

        HttpSession session =
                request.getSession(false);

        /*
         * ------------------------------------------------------
         * Authentication check
         * ------------------------------------------------------
         */
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

            if (action == null
                    || action.isBlank()) {

                throw new ValidationException(
                        "Visit action is required."
                );
            }

            /*
             * --------------------------------------------------
             * CREATE VISIT
             * --------------------------------------------------
             */
            if ("createVisit".equalsIgnoreCase(action)) {

                int appointmentId =
                        parsePositiveInt(
                                request.getParameter(
                                        "appointmentId"
                                ),
                                "Invalid appointment ID."
                        );

                int visitId =
                        assistantVisitService.createVisit(
                                appointmentId,
                                assistantUserId
                        );

                /*
                 * Important:
                 * This is a visitId, so use ?visitId=
                 */
                response.sendRedirect(
                        request.getContextPath()
                        + "/assistant/visits"
                        + "?visitId="
                        + visitId
                );

                return;
            }

            /*
             * --------------------------------------------------
             * CHECK IN
             * --------------------------------------------------
             */
            if ("checkIn".equalsIgnoreCase(action)) {

                int visitId =
                        parsePositiveInt(
                                request.getParameter(
                                        "visitId"
                                ),
                                "Invalid visit ID."
                        );

                assistantVisitService.checkIn(
                        visitId
                );

                redirectToVisit(
                        request,
                        response,
                        visitId
                );

                return;
            }

            /*
             * --------------------------------------------------
             * START CONSULTATION
             * --------------------------------------------------
             */
            if ("startConsultation".equalsIgnoreCase(
                    action)) {

                int visitId =
                        parsePositiveInt(
                                request.getParameter(
                                        "visitId"
                                ),
                                "Invalid visit ID."
                        );

                assistantVisitService
                        .startConsultation(
                                visitId
                        );

                redirectToVisit(
                        request,
                        response,
                        visitId
                );

                return;
            }

            /*
             * --------------------------------------------------
             * ADD SERVICE
             * --------------------------------------------------
             */
            if ("addService".equalsIgnoreCase(action)) {

                int visitId =
                        parsePositiveInt(
                                request.getParameter(
                                        "visitId"
                                ),
                                "Invalid visit ID."
                        );

                int serviceId =
                        parsePositiveInt(
                                request.getParameter(
                                        "serviceId"
                                ),
                                "Please select a service."
                        );

                int quantity =
                        parsePositiveInt(
                                request.getParameter(
                                        "quantity"
                                ),
                                "Invalid quantity."
                        );

                String notes =
                        request.getParameter("notes");

                assistantVisitService
                        .addAdditionalService(
                                visitId,
                                serviceId,
                                assistantUserId,
                                quantity,
                                notes
                        );

                redirectToVisit(
                        request,
                        response,
                        visitId
                );

                return;
            }

            /*
             * --------------------------------------------------
             * MEDICINE PRESCRIBED
             * --------------------------------------------------
             */
            if ("medicine".equalsIgnoreCase(action)) {

                int visitId =
                        parsePositiveInt(
                                request.getParameter(
                                        "visitId"
                                ),
                                "Invalid visit ID."
                        );

                boolean prescribed =
                        "true".equalsIgnoreCase(
                                request.getParameter(
                                        "prescribed"
                                )
                        );

                assistantVisitService
                        .recordMedicinePrescribed(
                                visitId,
                                prescribed
                        );

                redirectToVisit(
                        request,
                        response,
                        visitId
                );

                return;
            }

            /*
             * --------------------------------------------------
             * COMPLETE CONSULTATION
             * --------------------------------------------------
             */
            if ("complete".equalsIgnoreCase(action)) {

                int visitId =
                        parsePositiveInt(
                                request.getParameter(
                                        "visitId"
                                ),
                                "Invalid visit ID."
                        );

                String visitNotes =
                        request.getParameter(
                                "visitNotes"
                        );

                assistantVisitService
                        .completeConsultation(
                                visitId,
                                visitNotes
                        );

                redirectToVisit(
                        request,
                        response,
                        visitId
                );

                return;
            }

            throw new ValidationException(
                    "Invalid visit action."
            );

        } catch (ValidationException e) {

            /*
             * Preserve the error message.
             */
            request.setAttribute(
                    "error",
                    e.getMessage()
            );

            /*
             * If the operation belongs to an existing visit,
             * reload the complete visit detail page so all
             * required JSP attributes are available.
             */
            String visitIdParameter =
                    request.getParameter("visitId");

            if (visitIdParameter != null
                    && !visitIdParameter.isBlank()) {

                try {

                    int visitId =
                            Integer.parseInt(
                                    visitIdParameter
                            );

                    loadVisitDetail(
                            request,
                            response,
                            visitId
                    );

                    return;

                } catch (NumberFormatException ignored) {

                    // Continue below.
                }
            }

            /*
             * If there is no visit ID, go back to the
             * assistant visit list.
             */
            try {

                LocalDate date =
                        LocalDate.now();

                request.setAttribute(
                        "appointments",
                        assistantVisitService
                                .getConfirmedAppointments(
                                        date
                                )
                );

                request.setAttribute(
                        "selectedDate",
                        date
                );

                request.getRequestDispatcher(
                        "/assistant/visits.jsp"
                ).forward(
                        request,
                        response
                );

            } catch (SQLException sqlException) {

                throw new ServletException(
                        "Unable to reload assistant visits.",
                        sqlException
                );
            }

        } catch (NumberFormatException e) {

            throw new ServletException(
                    "Invalid numeric value.",
                    e
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to process visit operation.",
                    e
            );
        }
    }

   
        private void loadVisitDetail(
                HttpServletRequest request,
                HttpServletResponse response,
                int visitId
        ) throws ServletException, IOException {

            try {

                Optional<PatientVisit> visit =
                        assistantVisitService.getVisit(
                                visitId
                        );

                if (visit.isEmpty()) {

                    response.sendError(
                            HttpServletResponse.SC_NOT_FOUND,
                            "Patient visit could not be found."
                    );

                    return;
                }

                Optional<AssistantVisitDTO> appointment =
                        assistantVisitService.getAppointment(
                                visit.get().getAppointmentId()
                        );

                if (appointment.isEmpty()) {

                    response.sendError(
                            HttpServletResponse.SC_NOT_FOUND,
                            "Appointment could not be found."
                    );

                    return;
                }

                /*
                 * Load all active clinic services for the
                 * additional-service dropdown.
                 */
                List<Service> availableServices =
                        serviceDAO.findAllActive();

                /*
                 * Load services already recorded for this visit.
                 */
                List<VisitService> visitServices =
                        visitServiceService.getVisitServices(
                                visitId
                        );

                request.setAttribute(
                        "appointment",
                        appointment.get()
                );

                request.setAttribute(
                        "visit",
                        visit.get()
                );

                request.setAttribute(
                        "availableServices",
                        availableServices
                );

                request.setAttribute(
                        "visitServices",
                        visitServices
                );

                request.getRequestDispatcher(
                        "/assistant/visit-detail.jsp"
                ).forward(
                        request,
                        response
                );

            } catch (SQLException e) {

                throw new ServletException(
                        "Unable to load visit information.",
                        e
                );
            }
        }
        
        
    private void redirectToVisit(
            HttpServletRequest request,
            HttpServletResponse response,
            int visitId
    ) throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/assistant/visits"
                + "?visitId="
                + visitId
        );
    }

    /*
     * ----------------------------------------------------------
     * Parse and validate positive integer
     * ----------------------------------------------------------
     */
    private int parsePositiveInt(
            String value,
            String errorMessage
    ) throws ValidationException {

        if (value == null
                || value.isBlank()) {

            throw new ValidationException(
                    errorMessage
            );
        }

        try {

            int number =
                    Integer.parseInt(value);

            if (number <= 0) {

                throw new ValidationException(
                        errorMessage
                );
            }

            return number;

        } catch (NumberFormatException e) {

            throw new ValidationException(
                    errorMessage
            );
        }
    }
}