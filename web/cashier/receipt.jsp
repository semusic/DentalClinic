<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.model.Invoice" %>
<%@ page import="com.dentalclinic.model.InvoiceItem" %>
<%@ page import="com.dentalclinic.model.Payment" %>
<%@ page import="com.dentalclinic.model.Receipt" %>

<%
    Invoice invoice =
            (Invoice)
                    request.getAttribute(
                            "invoice"
                    );

    Payment payment =
            (Payment)
                    request.getAttribute(
                            "payment"
                    );

    Receipt receipt =
            (Receipt)
                    request.getAttribute(
                            "receipt"
                    );

    List<InvoiceItem> items =
            (List<InvoiceItem>)
                    request.getAttribute(
                            "invoiceItems"
                    );

    /*
     * The QR is available when a secure QR token
     * has been generated for this paid invoice.
     */
    boolean qrAvailable =
            invoice.getQrToken() != null
            && !invoice.getQrToken().isBlank();

    String encodedQrToken = "";

    if (qrAvailable) {

        encodedQrToken =
                java.net.URLEncoder.encode(
                        invoice.getQrToken(),
                        java.nio.charset.StandardCharsets.UTF_8
                );
    }
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        DentalCare | Receipt
    </title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;

            font-family:
                Arial,
                sans-serif;

            background:
                #f5f9fc;

            color:
                #263238;
        }

        .container {
            max-width:
                850px;

            margin:
                40px auto;

            padding:
                20px;
        }

        .receipt {
            background:
                white;

            padding:
                35px;

            border-radius:
                16px;

            box-shadow:
                0 8px 28px
                rgba(0,0,0,0.06);
        }

        .top {
            display:
                flex;

            justify-content:
                space-between;

            gap:
                20px;

            border-bottom:
                1px solid #edf2f7;

            padding-bottom:
                25px;
        }

        .brand {
            font-size:
                26px;

            font-weight:
                700;

            color:
                #1677a5;
        }

        h1 {
            margin:
                5px 0;

            color:
                #183b56;
        }

        .muted {
            color:
                #718096;
        }

        .receipt-number {
            text-align:
                right;

            font-weight:
                700;

            color:
                #183b56;
        }

        .details {
            display:
                grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap:
                14px;

            margin-top:
                25px;
        }

        .detail {
            background:
                #f8fafc;

            padding:
                15px;

            border-radius:
                10px;
        }

        .label {
            font-size:
                12px;

            color:
                #718096;

            margin-bottom:
                5px;
        }

        .value {
            font-weight:
                700;

            word-break:
                break-word;
        }

        table {
            width:
                100%;

            border-collapse:
                collapse;

            margin-top:
                30px;
        }

        th,
        td {
            padding:
                13px 8px;

            border-bottom:
                1px solid #edf2f7;

            text-align:
                left;
        }

        th {
            font-size:
                12px;

            color:
                #718096;
        }

        .right {
            text-align:
                right;
        }

        .paid {
            margin-top:
                25px;

            padding:
                20px;

            border-radius:
                12px;

            background:
                #edf9f2;

            color:
                #18794e;
        }

        .paid-amount {
            margin-top:
                6px;

            font-size:
                25px;

            font-weight:
                700;
        }

        /*
         * QR SECTION
         */
        .qr-section {
            margin-top:
                30px;

            padding:
                25px;

            text-align:
                center;

            border:
                1px solid #e5e7eb;

            border-radius:
                12px;

            background:
                #fafcfd;

            page-break-inside:
                avoid;
        }

        .qr-section h2 {
            margin:
                0 0 8px;

            color:
                #183b56;

            font-size:
                20px;
        }

        .qr-section p {
            margin:
                6px 0;

            color:
                #718096;

            font-size:
                13px;

            line-height:
                1.5;
        }

        .qr-image {
            display:
                block;

            width:
                280px;

            height:
                280px;

            margin:
                20px auto;

            image-rendering:
                pixelated;
        }

        .qr-note {
            margin-bottom:
                0;

            font-size:
                12px !important;

            color:
                #718096;
        }

        .qr-unavailable {
            margin-top:
                30px;

            padding:
                18px;

            border-radius:
                10px;

            background:
                #fffaf0;

            color:
                #946200;

            text-align:
                center;
        }

        /*
         * ACTIONS
         */
        .actions {
            margin-top:
                25px;

            display:
                flex;

            gap:
                10px;

            flex-wrap:
                wrap;
        }

        .button {
            padding:
                11px 18px;

            border:
                none;

            border-radius:
                9px;

            background:
                #1677a5;

            color:
                white;

            text-decoration:
                none;

            font-weight:
                700;

            cursor:
                pointer;

            font-size:
                14px;

            display:
                inline-block;
        }

        .secondary {
            background:
                #eef2f5;

            color:
                #374151;
        }

        /*
         * PRINT
         */
        @media print {

            body {
                background:
                    white;
            }

            .no-print {
                display:
                    none !important;
            }

            .container {
                margin:
                    0 !important;

                max-width:
                    none !important;

                padding:
                    0 !important;
            }

            .receipt {
                box-shadow:
                    none !important;

                border:
                    none !important;

                border-radius:
                    0 !important;

                padding:
                    15px !important;
            }

            .qr-section {
                page-break-inside:
                    avoid;
            }

            .qr-image {
                width:
                    250px;

                height:
                    250px;
            }
        }

        /*
         * MOBILE
         */
        @media (max-width: 650px) {

            .container {
                margin:
                    15px auto;

                padding:
                    10px;
            }

            .receipt {
                padding:
                    22px;
            }

            .top {
                flex-direction:
                    column;
            }

            .receipt-number {
                text-align:
                    left;
            }

            .details {
                grid-template-columns:
                    1fr;
            }

            .qr-image {
                width:
                    240px;

                height:
                    240px;
            }

            .actions {
                flex-direction:
                    column;
            }

            .button {
                text-align:
                    center;

                width:
                    100%;
            }
        }

    </style>

</head>

<body>

<main class="container">

    <div class="receipt">

        <!-- HEADER -->

        <div class="top">

            <div>

                <div class="brand">
                    DentalCare
                </div>

                <h1>
                    Payment Receipt
                </h1>

                <div class="muted">
                    Thank you for your payment.
                </div>

            </div>


            <div class="receipt-number">

                RECEIPT

                <br>

                <%= receipt.getReceiptNumber() %>

            </div>

        </div>


        <!-- RECEIPT DETAILS -->

        <div class="details">

            <div class="detail">

                <div class="label">
                    Receipt Number
                </div>

                <div class="value">

                    <%= receipt.getReceiptNumber() %>

                </div>

            </div>


            <div class="detail">

                <div class="label">
                    Invoice Number
                </div>

                <div class="value">

                    <%= invoice.getInvoiceNumber() %>

                </div>

            </div>


            <div class="detail">

                <div class="label">
                    Patient ID
                </div>

                <div class="value">

                    <%= invoice.getPatientId() %>

                </div>

            </div>


            <div class="detail">

                <div class="label">
                    Payment Reference
                </div>

                <div class="value">

                    <%= payment.getPaymentReference() %>

                </div>

            </div>


            <div class="detail">

                <div class="label">
                    Payment Method
                </div>

                <div class="value">

                    <%= payment.getPaymentMethod() %>

                </div>

            </div>


            <div class="detail">

                <div class="label">
                    Payment Date
                </div>

                <div class="value">

                    <%= payment.getTransactionDate() %>

                </div>

            </div>

        </div>


        <!-- SERVICES -->

        <table>

            <thead>

                <tr>

                    <th>
                        Service
                    </th>

                    <th>
                        Qty
                    </th>

                    <th class="right">
                        Total
                    </th>

                </tr>

            </thead>

            <tbody>

            <%
                if (items != null
                        && !items.isEmpty()) {

                    for (InvoiceItem item :
                            items) {
            %>

                <tr>

                    <td>

                        <%= item.getItemDescription() %>

                    </td>

                    <td>

                        <%= item.getQuantity() %>

                    </td>

                    <td class="right">

                        LKR
                        <%= item.getLineTotal() %>

                    </td>

                </tr>

            <%
                    }

                } else {
            %>

                <tr>

                    <td colspan="3">

                        No invoice items found.

                    </td>

                </tr>

            <%
                }
            %>

            </tbody>

        </table>


        <!-- PAYMENT -->

        <div class="paid">

            <div>
                AMOUNT PAID
            </div>

            <div class="paid-amount">

                LKR
                <%= payment.getAmount() %>

            </div>

            <div style="margin-top:6px;">

                Payment Status:

                <strong>
                    <%= payment.getPaymentStatus() %>
                </strong>

            </div>

        </div>


        <!-- QR CODE -->

        <% if (qrAvailable) { %>

        <div class="qr-section">

            <h2>
                Patient Visit QR
            </h2>

            <p>

                Scan this QR code with a phone to
                view the patient's visit record.

            </p>


            <img
                class="qr-image"
                src="${pageContext.request.contextPath}/qr?t=<%= encodedQrToken %>"
                alt="Secure patient visit QR code">


            <p class="qr-note">

                Keep this receipt for future reference.

            </p>

        </div>

        <% } else { %>

        <div class="qr-unavailable">

            <strong>
                Patient Visit QR is not available
            </strong>

            <br><br>

            This receipt does not yet have a QR token.

        </div>

        <% } %>


        <!-- NAVIGATION ACTIONS -->

        <div class="actions no-print">

            <a
                class="button secondary"
                href="${pageContext.request.contextPath}/cashier/invoice-history?invoiceId=<%= invoice.getInvoiceId() %>">

                View Invoice

            </a>


            <a
                class="button"
                href="${pageContext.request.contextPath}/cashier/payments?invoiceId=<%= invoice.getInvoiceId() %>">

                Payment History

            </a>

        </div>


        <!-- PRINT / SAVE -->

        <div class="actions no-print">

            <button
                type="button"
                class="button"
                onclick="window.print()">

                🖨 Print Receipt

            </button>


            <button
                type="button"
                class="button"
                onclick="window.print()">

                ↓ Save PDF

            </button>


            <a
                class="button secondary"
                href="${pageContext.request.contextPath}/cashier/invoice-history">

                Invoice History

            </a>

        </div>

    </div>

</main>

</body>

</html>