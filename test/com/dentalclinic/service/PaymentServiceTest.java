package com.dentalclinic.service;

import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.service.impl.PaymentServiceImpl;
import org.junit.Test;

import java.math.BigDecimal;

public class PaymentServiceTest {

    private final PaymentService service =
            new PaymentServiceImpl();

    @Test(expected = ValidationException.class)
    public void shouldRejectInvalidInvoiceId()
            throws Exception {

        service.makePayment(
                0,
                BigDecimal.valueOf(1000),
                "CASH",
                "Test payment",
                1
        );
    }

    @Test(expected = ValidationException.class)
    public void shouldRejectInvalidCashierUserId()
            throws Exception {

        service.makePayment(
                1,
                BigDecimal.valueOf(1000),
                "CASH",
                "Test payment",
                0
        );
    }

    @Test(expected = ValidationException.class)
    public void shouldRejectNullPaymentAmount()
            throws Exception {

        service.makePayment(
                1,
                null,
                "CASH",
                "Test payment",
                1
        );
    }

    @Test(expected = ValidationException.class)
    public void shouldRejectZeroPaymentAmount()
            throws Exception {

        service.makePayment(
                1,
                BigDecimal.ZERO,
                "CASH",
                "Test payment",
                1
        );
    }

    @Test(expected = ValidationException.class)
    public void shouldRejectNegativePaymentAmount()
            throws Exception {

        service.makePayment(
                1,
                BigDecimal.valueOf(-100),
                "CASH",
                "Test payment",
                1
        );
    }

    @Test(expected = ValidationException.class)
    public void shouldRequirePaymentMethod()
            throws Exception {

        service.makePayment(
                1,
                BigDecimal.valueOf(1000),
                "   ",
                "Test payment",
                1
        );
    }

    @Test(expected = ValidationException.class)
    public void shouldRejectInvalidPaymentId()
            throws Exception {

        service.getPayment(0);
    }

    @Test(expected = ValidationException.class)
    public void shouldRejectInvalidInvoiceIdForPaymentHistory()
            throws Exception {

        service.getPayments(0);
    }

    @Test(expected = ValidationException.class)
    public void shouldRejectInvalidPaymentIdForReceipt()
            throws Exception {

        service.getReceiptByPaymentId(0);
    }
}