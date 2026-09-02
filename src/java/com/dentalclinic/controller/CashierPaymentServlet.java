package com.dentalclinic.controller;

import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.model.Invoice;
import com.dentalclinic.model.InvoiceItem;
import com.dentalclinic.model.Payment;
import com.dentalclinic.model.Receipt;
import com.dentalclinic.service.InvoiceService;
import com.dentalclinic.service.PaymentService;
import com.dentalclinic.service.impl.InvoiceServiceImpl;
import com.dentalclinic.service.impl.PaymentServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/cashier/payments")
public class CashierPaymentServlet
        extends HttpServlet {

    private InvoiceService invoiceService;
    private PaymentService paymentService;

    @Override
    public void init() {

        invoiceService =
                new InvoiceServiceImpl();

        paymentService =
                new PaymentServiceImpl();
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

        String paymentIdParameter =
                request.getParameter("paymentId");

        try {

            /*
             * Open receipt/payment details.
             */
            if (paymentIdParameter != null
                    && !paymentIdParameter.isBlank()) {

                int paymentId =
                        parsePositiveInt(
                                paymentIdParameter
                        );

                Payment payment =
                        paymentService.getPayment(
                                paymentId
                        );

                Receipt receipt =
                        paymentService
                                .getReceiptByPaymentId(
                                        paymentId
                                );

                Invoice invoice =
                        invoiceService.getInvoice(
                                payment.getInvoiceId()
                        );

                List<InvoiceItem> invoiceItems =
                        invoiceService
                                .getInvoiceItems(
                                        invoice.getInvoiceId()
                                );

                request.setAttribute(
                        "payment",
                        payment
                );

                request.setAttribute(
                        "receipt",
                        receipt
                );

                request.setAttribute(
                        "invoice",
                        invoice
                );

                request.setAttribute(
                        "invoiceItems",
                        invoiceItems
                );

                request.getRequestDispatcher(
                        "/cashier/receipt.jsp"
                ).forward(
                        request,
                        response
                );

                return;
            }

            /*
             * Open an invoice for payment.
             */
            if (invoiceIdParameter == null
                    || invoiceIdParameter.isBlank()) {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invoice ID is required."
                );

                return;
            }

            int invoiceId =
                    parsePositiveInt(
                            invoiceIdParameter
                    );

            Invoice invoice =
                    invoiceService.getInvoice(
                            invoiceId
                    );

            if ("VOID".equalsIgnoreCase(
                    invoice.getInvoiceStatus())) {

                throw new ValidationException(
                        "A voided invoice cannot receive payment."
                );
            }

            List<InvoiceItem> invoiceItems =
                    invoiceService.getInvoiceItems(
                            invoiceId
                    );

            List<Payment> payments =
                    paymentService.getPayments(
                            invoiceId
                    );

            BigDecimal alreadyPaid =
                    calculatePaidAmount(
                            payments
                    );

            BigDecimal outstanding =
                    invoice.getTotalAmount()
                            .subtract(
                                    alreadyPaid
                            );

            request.setAttribute(
                    "invoice",
                    invoice
            );

            request.setAttribute(
                    "invoiceItems",
                    invoiceItems
            );

            request.setAttribute(
                    "payments",
                    payments
            );

            request.setAttribute(
                    "alreadyPaid",
                    alreadyPaid
            );

            request.setAttribute(
                    "outstanding",
                    outstanding
            );

            request.getRequestDispatcher(
                    "/cashier/payment.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (ValidationException e) {

            request.setAttribute(
                    "error",
                    e.getMessage()
            );

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage()
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to load payment information.",
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
                        session.getAttribute(
                                "userId"
                        );

        String action =
                request.getParameter(
                        "action"
                );

        try {

            if (!"makePayment".equalsIgnoreCase(
                    action)) {

                throw new ValidationException(
                        "Invalid payment action."
                );
            }

            int invoiceId =
                    parsePositiveInt(
                            request.getParameter(
                                    "invoiceId"
                            )
                    );

            String amountText =
                    request.getParameter(
                            "amount"
                    );

            if (amountText == null
                    || amountText.isBlank()) {

                throw new ValidationException(
                        "Payment amount is required."
                );
            }

            BigDecimal amount;

            try {

                amount =
                        new BigDecimal(
                                amountText.trim()
                        );

            } catch (NumberFormatException e) {

                throw new ValidationException(
                        "Invalid payment amount."
                );
            }

            String paymentMethod =
                    request.getParameter(
                            "paymentMethod"
                    );

            String notes =
                    request.getParameter(
                            "notes"
                    );

            Receipt receipt =
                    paymentService.makePayment(
                            invoiceId,
                            amount,
                            paymentMethod,
                            notes,
                            cashierUserId
                    );

            Invoice updatedInvoice =
                    invoiceService.getInvoice(
                            invoiceId
                    );

            if ("PAID".equalsIgnoreCase(
                    updatedInvoice.getInvoiceStatus())) {

                invoiceService.generateQrToken(
                        invoiceId
                );
            }
            
            response.sendRedirect(
                    request.getContextPath()
                    + "/cashier/payments"
                    + "?paymentId="
                    + receipt.getPaymentId()
            );

        } catch (ValidationException e) {

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

                    Invoice invoice =
                            invoiceService.getInvoice(
                                    invoiceId
                            );

                    List<InvoiceItem> items =
                            invoiceService
                                    .getInvoiceItems(
                                            invoiceId
                                    );

                    List<Payment> payments =
                            paymentService
                                    .getPayments(
                                            invoiceId
                                    );

                    BigDecimal paid =
                            calculatePaidAmount(
                                    payments
                            );

                    BigDecimal outstanding =
                            invoice.getTotalAmount()
                                    .subtract(
                                            paid
                                    );

                    request.setAttribute(
                            "invoice",
                            invoice
                    );

                    request.setAttribute(
                            "invoiceItems",
                            items
                    );

                    request.setAttribute(
                            "payments",
                            payments
                    );

                    request.setAttribute(
                            "alreadyPaid",
                            paid
                    );

                    request.setAttribute(
                            "outstanding",
                            outstanding
                    );

                    request.setAttribute(
                            "error",
                            e.getMessage()
                    );

                    request.getRequestDispatcher(
                            "/cashier/payment.jsp"
                    ).forward(
                            request,
                            response
                    );

                    return;

                } catch (
                        NumberFormatException ignored) {
                } catch (
                        SQLException
                        | ValidationException exception) {

                    throw new ServletException(
                            "Unable to reload payment page.",
                            exception
                    );
                }
            }

            throw new ServletException(
                    e.getMessage(),
                    e
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to process payment.",
                    e
            );
        }
    }

    private BigDecimal calculatePaidAmount(
            List<Payment> payments) {

        BigDecimal total =
                BigDecimal.ZERO;

        if (payments == null) {
            return total;
        }

        for (Payment payment :
                payments) {

            if ("COMPLETED".equalsIgnoreCase(
                    payment.getPaymentStatus())) {

                total =
                        total.add(
                                payment.getAmount()
                        );
            }
        }

        return total;
    }

    private int parsePositiveInt(
            String value)
            throws ValidationException {

        if (value == null
                || value.isBlank()) {

            throw new ValidationException(
                    "Invalid ID."
            );
        }

        try {

            int number =
                    Integer.parseInt(
                            value
                    );

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