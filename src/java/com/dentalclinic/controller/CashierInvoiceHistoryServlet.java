package com.dentalclinic.controller;

import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.model.Invoice;
import com.dentalclinic.service.InvoiceService;
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

@WebServlet("/cashier/invoice-history")
public class CashierInvoiceHistoryServlet
        extends HttpServlet {

    private InvoiceService invoiceService;

    @Override
    public void init() {

        invoiceService =
                new InvoiceServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null
                || !(session.getAttribute("userId")
                instanceof Integer)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login"
            );

            return;
        }

        String invoiceIdParameter =
                request.getParameter("invoiceId");

        try {

            /*
             * Open a specific invoice from history.
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

                request.setAttribute(
                        "invoice",
                        invoice
                );

                request.setAttribute(
                        "invoiceItems",
                        invoiceService.getInvoiceItems(
                                invoiceId
                        )
                );

                request.getRequestDispatcher(
                        "/cashier/invoice-history-detail.jsp"
                ).forward(
                        request,
                        response
                );

                return;
            }

            /*
             * Show complete invoice history.
             */
            List<Invoice> invoices =
                    invoiceService
                            .getInvoiceHistory();

            request.setAttribute(
                    "invoices",
                    invoices
            );

            request.getRequestDispatcher(
                    "/cashier/invoice-history.jsp"
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
                        "invoices",
                        invoiceService
                                .getInvoiceHistory()
                );

            } catch (SQLException sqlException) {

                throw new ServletException(
                        "Unable to reload invoice history.",
                        sqlException
                );
            }

            request.getRequestDispatcher(
                    "/cashier/invoice-history.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to load invoice history.",
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

        HttpSession session =
                request.getSession(false);

        if (session == null
                || !(session.getAttribute("userId")
                instanceof Integer)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login"
            );

            return;
        }

        int cashierUserId =
                (Integer)
                        session.getAttribute("userId");

        String action =
                request.getParameter("action");

        try {

            if ("voidInvoice".equalsIgnoreCase(
                    action)) {

                int invoiceId =
                        parsePositiveInt(
                                request.getParameter(
                                        "invoiceId"
                                )
                        );

                String reason =
                        request.getParameter(
                                "reason"
                        );

                invoiceService.voidInvoice(
                        invoiceId,
                        cashierUserId,
                        reason
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/cashier/invoice-history"
                        + "?invoiceId="
                        + invoiceId
                );

                return;
            }

            throw new ValidationException(
                    "Invalid invoice history action."
            );

        } catch (ValidationException e) {

            request.setAttribute(
                    "error",
                    e.getMessage()
            );

            String invoiceIdParameter =
                    request.getParameter(
                            "invoiceId"
                    );

            if (invoiceIdParameter != null
                    && !invoiceIdParameter.isBlank()) {

                try {

                    int invoiceId =
                            parsePositiveInt(
                                    invoiceIdParameter
                            );

                    request.setAttribute(
                            "invoice",
                            invoiceService.getInvoice(
                                    invoiceId
                            )
                    );

                    request.setAttribute(
                            "invoiceItems",
                            invoiceService
                                    .getInvoiceItems(
                                            invoiceId
                                    )
                    );

                    request.getRequestDispatcher(
                            "/cashier/invoice-history-detail.jsp"
                    ).forward(
                            request,
                            response
                    );

                    return;

                } catch (
                        NumberFormatException ignored) {
                } catch (ValidationException
                         | SQLException exception) {

                    throw new ServletException(
                            "Unable to reload invoice.",
                            exception
                    );
                }
            }

            doGet(
                    request,
                    response
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to process invoice history operation.",
                    e
            );
        }
    }

    private int parsePositiveInt(
            String value)
            throws ValidationException {

        if (value == null
                || value.isBlank()) {

            throw new ValidationException(
                    "Invalid invoice ID."
            );
        }

        try {

            int number =
                    Integer.parseInt(value);

            if (number <= 0) {

                throw new ValidationException(
                        "Invalid invoice ID."
                );
            }

            return number;

        } catch (NumberFormatException e) {

            throw new ValidationException(
                    "Invalid invoice ID."
            );
        }
    }
}