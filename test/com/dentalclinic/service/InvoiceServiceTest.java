package com.dentalclinic.service;

import com.dentalclinic.exception.ValidationException;
import com.dentalclinic.service.impl.InvoiceServiceImpl;
import org.junit.Test;

public class InvoiceServiceTest {

    private final InvoiceService service =
            new InvoiceServiceImpl();

    @Test(expected = ValidationException.class)
    public void shouldRejectInvalidVisitId()
            throws Exception {

        service.generateInvoice(
                0,
                1
        );
    }

    @Test(expected = ValidationException.class)
    public void shouldRejectInvalidCashierUserId()
            throws Exception {

        service.generateInvoice(
                1,
                0
        );
    }

    @Test(expected = ValidationException.class)
    public void shouldRejectInvalidInvoiceId()
            throws Exception {

        service.getInvoice(0);
    }

    @Test(expected = ValidationException.class)
    public void shouldRejectInvalidInvoiceIdForQr()
            throws Exception {

        service.generateQrToken(0);
    }

    @Test(expected = ValidationException.class)
    public void shouldRejectInvalidInvoiceIdForVoiding()
            throws Exception {

        service.voidInvoice(
                0,
                1,
                "Test reason"
        );
    }

    @Test(expected = ValidationException.class)
    public void shouldRejectInvalidCashierUserIdForVoiding()
            throws Exception {

        service.voidInvoice(
                1,
                0,
                "Test reason"
        );
    }

    @Test(expected = ValidationException.class)
    public void shouldRequireVoidReason()
            throws Exception {

        service.voidInvoice(
                1,
                1,
                "   "
        );
    }

    @Test(expected = ValidationException.class)
    public void shouldRejectNullVoidReason()
            throws Exception {

        service.voidInvoice(
                1,
                1,
                null
        );
    }
}