package com.dentalclinic.controller;

import com.dentalclinic.dto.CashierVisitDTO;
import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.model.Invoice;
import com.dentalclinic.model.InvoiceItem;
import com.dentalclinic.service.CashierVisitService;
import com.dentalclinic.service.InvoiceService;
import com.dentalclinic.service.impl.CashierVisitServiceImpl;
import com.dentalclinic.service.impl.InvoiceServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/cashier/invoices")
public class CashierInvoiceServlet
        extends HttpServlet {

    private CashierVisitService cashierVisitService;
    private InvoiceService invoiceService;

    @Override
    public void init() {

        cashierVisitService =
                new CashierVisitServiceImpl();

        invoiceService =
                new InvoiceServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String visitIdParameter =
                request.getParameter("visitId");

        String invoiceIdParameter =
                request.getParameter("invoiceId");

        try {

            /*
             * --------------------------------------------------
             * Open an existing invoice.
             * --------------------------------------------------
             */
            if (invoiceIdParameter != null
                    && !invoiceIdParameter.isBlank()) {

                int invoiceId =
                        parsePositiveInt(
                                invoiceIdParameter
                        );

                Invoice invoice =
                        invoiceService.getInvoice(
                                invoiceId
                        );

                List<InvoiceItem> items =
                        invoiceService.getInvoiceItems(
                                invoiceId
                        );

                request.setAttribute(
                        "invoice",
                        invoice
                );

                request.setAttribute(
                        "invoiceItems",
                        items
                );

                request.getRequestDispatcher(
                        "/cashier/invoice-detail.jsp"
                ).forward(
                        request,
                        response
                );

                return;
            }

            /*
             * --------------------------------------------------
             * Open a completed visit for billing review.
             * --------------------------------------------------
             */
            if (visitIdParameter != null
                    && !visitIdParameter.isBlank()) {

                int visitId =
                        parsePositiveInt(
                                visitIdParameter
                        );

                CashierVisitDTO visit =
                        cashierVisitService
                                .getVisitForBilling(
                                        visitId
                                );

                request.setAttribute(
                        "visit",
                        visit
                );

                request.getRequestDispatcher(
                        "/cashier/invoice-create.jsp"
                ).forward(
                        request,
                        response
                );

                return;
            }

            /*
             * --------------------------------------------------
             * Default:
             * Show visits waiting for billing.
             * --------------------------------------------------
             */
            List<CashierVisitDTO> visits =
                    cashierVisitService
                            .getVisitsReadyForBilling();

            request.setAttribute(
                    "visits",
                    visits
            );

            request.setAttribute(
                    "completedVisits",
                    visits
            );

            request.getRequestDispatcher(
                    "/cashier/invoices.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (ValidationException e) {

            request.setAttribute(
                    "error",
                    e.getMessage()
            );

            try {

                request.setAttribute(
                        "visits",
                        cashierVisitService
                                .getVisitsReadyForBilling()
                );

            } catch (SQLException sqlException) {

                throw new ServletException(
                        "Unable to reload cashier invoices.",
                        sqlException
                );
            }

            request.getRequestDispatcher(
                    "/cashier/invoices.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to load cashier invoice information.",
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

        int cashierUserId =
                (Integer) userIdObject;

        try {

            if ("generateInvoice"
                    .equalsIgnoreCase(action)) {

                int visitId =
                        parsePositiveInt(
                                request.getParameter(
                                        "visitId"
                                )
                        );

                int invoiceId =
                        invoiceService.generateInvoice(
                                visitId,
                                cashierUserId
                        );

                response.sendRedirect(
                        request.getContextPath()
                        + "/cashier/invoices"
                        + "?invoiceId="
                        + invoiceId
                );

                return;
            }

            throw new ValidationException(
                    "Invalid cashier action."
            );

        } catch (ValidationException e) {

            request.setAttribute(
                    "error",
                    e.getMessage()
            );

            try {

                request.setAttribute(
                        "visits",
                        cashierVisitService
                                .getVisitsReadyForBilling()
                );

            } catch (SQLException sqlException) {

                throw new ServletException(
                        "Unable to reload cashier queue.",
                        sqlException
                );
            }

            request.getRequestDispatcher(
                    "/cashier/invoices.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to generate invoice.",
                    e
            );
        }
    }

    private int parsePositiveInt(
            String value
    ) throws ValidationException {

        if (value == null
                || value.isBlank()) {

            throw new ValidationException(
                    "Invalid ID."
            );
        }

        try {

            int number =
                    Integer.parseInt(value);

            if (number <= 0) {

                throw new ValidationException(
                        "Invalid ID."
                );
            }

            return number;

        } catch (NumberFormatException e) {

            throw new ValidationException(
                    "Invalid ID."
            );
        }
    }
}