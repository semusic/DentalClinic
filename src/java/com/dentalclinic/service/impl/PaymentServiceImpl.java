package com.dentalclinic.service.impl;

import com.dentalclinic.dao.InvoiceDAO;
import com.dentalclinic.dao.PaymentDAO;
import com.dentalclinic.dao.ReceiptDAO;

import com.dentalclinic.dao.impl.InvoiceDAOImpl;
import com.dentalclinic.dao.impl.PaymentDAOImpl;
import com.dentalclinic.dao.impl.ReceiptDAOImpl;

import com.dentalclinic.exception.ValidationException;

import com.dentalclinic.model.Invoice;
import com.dentalclinic.model.Payment;
import com.dentalclinic.model.Receipt;

import com.dentalclinic.service.PaymentService;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public class PaymentServiceImpl
        implements PaymentService {

    private final InvoiceDAO invoiceDAO;
    private final PaymentDAO paymentDAO;
    private final ReceiptDAO receiptDAO;

    public PaymentServiceImpl() {

        this.invoiceDAO =
                new InvoiceDAOImpl();

        this.paymentDAO =
                new PaymentDAOImpl();

        this.receiptDAO =
                new ReceiptDAOImpl();
    }

    @Override
    public Receipt makePayment(
            int invoiceId,
            BigDecimal amount,
            String paymentMethod,
            String notes,
            int cashierUserId
    ) throws SQLException, ValidationException {

        if (invoiceId <= 0) {

            throw new ValidationException(
                    "Invalid invoice."
            );
        }

        if (cashierUserId <= 0) {

            throw new ValidationException(
                    "Invalid cashier user."
            );
        }

        if (amount == null
                || amount.compareTo(
                        BigDecimal.ZERO
                ) <= 0) {

            throw new ValidationException(
                    "Payment amount must be greater than zero."
            );
        }

        String method =
                paymentMethod == null
                        ? ""
                        : paymentMethod.trim();

        if (method.isBlank()) {

            throw new ValidationException(
                    "Payment method is required."
            );
        }

        Invoice invoice =
                invoiceDAO.findById(
                        invoiceId
                ).orElseThrow(() ->
                        new ValidationException(
                                "Invoice could not be found."
                        )
                );

        if ("PAID".equalsIgnoreCase(
                invoice.getInvoiceStatus())) {

            throw new ValidationException(
                    "This invoice has already been fully paid."
            );
        }

        List<Payment> existingPayments =
                paymentDAO.findByInvoiceId(
                        invoiceId
                );

        BigDecimal alreadyPaid =
                BigDecimal.ZERO;

        for (Payment payment :
                existingPayments) {

            if ("COMPLETED".equalsIgnoreCase(
                    payment.getPaymentStatus())) {

                alreadyPaid =
                        alreadyPaid.add(
                                payment.getAmount()
                        );
            }
        }

        BigDecimal outstanding =
                invoice.getTotalAmount()
                        .subtract(alreadyPaid);

        if (outstanding.compareTo(
                BigDecimal.ZERO
        ) <= 0) {

            throw new ValidationException(
                    "There is no outstanding balance."
            );
        }

        if (amount.compareTo(
                outstanding
        ) > 0) {

            throw new ValidationException(
                    "Payment cannot exceed the outstanding balance of LKR "
                    + outstanding
            );
        }

        String paymentReference =
                generatePaymentReference();

        Payment payment =
                new Payment();

        payment.setInvoiceId(
                invoiceId
        );

        payment.setPaymentReference(
                paymentReference
        );

        payment.setAmount(
                amount
        );

        payment.setPaymentMethod(
                method
        );

        payment.setPaymentStatus(
                "COMPLETED"
        );

        payment.setTransactionDate(
                LocalDateTime.now()
        );

        payment.setProcessedByUserId(
                cashierUserId
        );

        payment.setNotes(
                notes == null
                        ? null
                        : notes.trim()
        );

        int paymentId =
                paymentDAO.create(
                        payment
                );

        Receipt receipt =
                new Receipt();

        receipt.setPaymentId(
                paymentId
        );

        receipt.setReceiptNumber(
                generateReceiptNumber()
        );

        receipt.setIssuedAt(
                LocalDateTime.now()
        );

        receipt.setIssuedByUserId(
                cashierUserId
        );

        int receiptId =
                receiptDAO.create(
                        receipt
                );

        return receiptDAO.findById(
                receiptId
        ).orElseThrow(() ->
                new SQLException(
                        "Payment was created but receipt could not be retrieved."
                )
        );
    }

    @Override
    public List<Payment> getPayments(
            int invoiceId
    ) throws SQLException, ValidationException {

        if (invoiceId <= 0) {

            throw new ValidationException(
                    "Invalid invoice."
            );
        }

        return paymentDAO.findByInvoiceId(
                invoiceId
        );
    }

    @Override
    public Receipt getReceiptByPaymentId(
            int paymentId
    ) throws SQLException, ValidationException {

        if (paymentId <= 0) {

            throw new ValidationException(
                    "Invalid payment."
            );
        }

        return receiptDAO.findByPaymentId(
                paymentId
        ).orElseThrow(() ->
                new ValidationException(
                        "Receipt could not be found."
                )
        );
    }

    private String generatePaymentReference() {

        String timestamp =
                LocalDateTime.now()
                        .format(
                                DateTimeFormatter.ofPattern(
                                        "yyyyMMddHHmmss"
                                )
                        );

        String suffix =
                UUID.randomUUID()
                        .toString()
                        .replace(
                                "-",
                                ""
                        )
                        .substring(
                                0,
                                6
                        )
                        .toUpperCase();

        return "PAY-"
                + timestamp
                + "-"
                + suffix;
    }

    private String generateReceiptNumber() {

        String timestamp =
                LocalDateTime.now()
                        .format(
                                DateTimeFormatter.ofPattern(
                                        "yyyyMMddHHmmss"
                                )
                        );

        String suffix =
                UUID.randomUUID()
                        .toString()
                        .replace(
                                "-",
                                ""
                        )
                        .substring(
                                0,
                                6
                        )
                        .toUpperCase();

        return "REC-"
                + timestamp
                + "-"
                + suffix;
    }
    
    
        @Override
    public Payment getPayment(
            int paymentId
    ) throws SQLException, ValidationException {

        if (paymentId <= 0) {

            throw new ValidationException(
                    "Invalid payment."
            );
        }

        return paymentDAO.findById(
                paymentId
        ).orElseThrow(() ->
                new ValidationException(
                        "Payment could not be found."
                )
        );
    }
}