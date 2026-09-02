<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.model.Invoice" %>
<%@ page import="com.dentalclinic.model.InvoiceItem" %>

<%
    Invoice invoice =
            (Invoice)
                    request.getAttribute(
                            "invoice"
                    );

    List<InvoiceItem> items =
            (List<InvoiceItem>)
                    request.getAttribute(
                            "invoiceItems"
                    );

    String error =
            (String)
                    request.getAttribute(
                            "error"
                    );

    boolean isUnpaid =
            "UNPAID".equalsIgnoreCase(
                    invoice.getInvoiceStatus()
            );

    boolean isVoid =
            "VOID".equalsIgnoreCase(
                    invoice.getInvoiceStatus()
            );

    boolean isPaid =
            "PAID".equalsIgnoreCase(
                    invoice.getInvoiceStatus()
            );
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        DentalCare | Invoice Details
    </title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f5f9fc;
            color: #263238;
        }

        .container {
            max-width: 900px;
            margin: 35px auto;
            padding: 20px;
        }

        .invoice {
            background: white;
            border-radius: 16px;
            padding: 32px;

            box-shadow:
                0 8px 28px rgba(0,0,0,0.05);
        }

        .top {
            display: flex;
            justify-content: space-between;
            gap: 20px;

            border-bottom:
                1px solid #edf2f7;

            padding-bottom:
                22px;
        }

        .brand {
            color: #1677a5;
            font-size: 25px;
            font-weight: 700;
        }

        h1 {
            margin:
                6px 0 0;

            color:
                #183b56;
        }

        .invoice-number {
            color:
                #718096;

            margin-top:
                5px;
        }

        .status {
            align-self:
                flex-start;

            padding:
                8px 14px;

            border-radius:
                20px;

            font-size:
                12px;

            font-weight:
                700;
        }

        .status-unpaid {
            background:
                #fff4dc;
            color:
                #946200;
        }

        .status-paid {
            background:
                #edf9f2;
            color:
                #18794e;
        }

        .status-void {
            background:
                #fff0f0;
            color:
                #b42318;
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
            color:
                #718096;

            font-size:
                12px;

            margin-bottom:
                5px;
        }

        .value {
            font-weight:
                700;
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
            color:
                #718096;

            font-size:
                12px;
        }

        .right {
            text-align:
                right;
        }

        .totals {
            max-width:
                350px;

            margin:
                20px 0 0 auto;
        }

        .total-row {
            display:
                flex;

            justify-content:
                space-between;

            padding:
                8px 0;
        }

        .grand {
            border-top:
                2px solid #183b56;

            margin-top:
                8px;

            padding-top:
                12px;

            font-size:
                20px;

            font-weight:
                700;
        }

        .void-box {
            margin-top:
                25px;

            padding:
                18px;

            background:
                #fff0f0;

            border-radius:
                10px;

            color:
                #7f1d1d;
        }

        .void-box strong {
            color:
                #b42318;
        }

        .error {
            margin-bottom:
                20px;

            padding:
                14px 18px;

            border-radius:
                10px;

            background:
                #fff0f0;

            color:
                #b42318;
        }

        .actions {
            margin-top:
                28px;

            display:
                flex;

            gap:
                10px;

            flex-wrap:
                wrap;
        }

        .button {
            border:
                none;

            padding:
                11px 18px;

            border-radius:
                9px;

            font-weight:
                700;

            cursor:
                pointer;

            text-decoration:
                none;

            background:
                #1677a5;

            color:
                white;
        }

        .secondary {
            background:
                #eef2f5;

            color:
                #374151;
        }

        .danger {
            background:
                #b42318;

            color:
                white;
        }

        .void-form {
            margin-top:
                15px;
        }

        .void-form textarea {
            width:
                100%;

            min-height:
                100px;

            padding:
                12px;

            border:
                1px solid #d7e0e7;

            border-radius:
                8px;

            resize:
                vertical;

            font-family:
                inherit;
        }

        @media (max-width: 650px) {

            .details {
                grid-template-columns:
                    1fr;
            }

            .top {
                flex-direction:
                    column;
            }

            .invoice {
                padding:
                    22px;
            }

            table {
                font-size:
                    13px;
            }

        }
        
        @media print {

            body {
                background: white;
            }

            .no-print {
                display: none !important;
            }

            .invoice {
                box-shadow: none !important;
                border: none !important;
                margin: 0 !important;
                width: 100% !important;
            }

            .container {
                margin: 0 !important;
                max-width: none !important;
                padding: 0 !important;
            }

        }

    </style>

</head>

<body>

<main class="container">

    <div class="invoice">

        <div class="top">

            <div>

                <div class="brand">
                    DentalCare
                </div>

                <h1>
                    Invoice Details
                </h1>

                <div class="invoice-number">

                    <%= invoice.getInvoiceNumber() %>

                </div>

            </div>


            <%
                String statusClass =
                        isPaid
                                ? "status-paid"
                                : isVoid
                                    ? "status-void"
                                    : "status-unpaid";
            %>

            <div class="status <%= statusClass %>">

                <%= invoice.getInvoiceStatus() %>

            </div>

        </div>


        <%
            if (error != null
                    && !error.isBlank()) {
        %>

            <div
                class="error"
                style="margin-top:20px;">

                <%= error %>

            </div>

        <%
            }
        %>


        <div class="details">

            <div class="detail">

                <div class="label">
                    Invoice ID
                </div>

                <div class="value">

                    <%= invoice.getInvoiceId() %>

                </div>

            </div>


            <div class="detail">

                <div class="label">
                    Visit ID
                </div>

                <div class="value">

                    <%= invoice.getVisitId() %>

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
                    Issued
                </div>

                <div class="value">

                    <%= invoice.getIssuedAt() %>

                </div>

            </div>


            <div class="detail">

                <div class="label">
                    Due Date
                </div>

                <div class="value">

                    <%= invoice.getDueDate() %>

                </div>

            </div>


            <div class="detail">

                <div class="label">
                    Created By
                </div>

                <div class="value">

                    User #
                    <%= invoice.getCreatedByUserId() %>

                </div>

            </div>

        </div>


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
                        Unit Price
                    </th>

                    <th class="right">
                        Total
                    </th>

                </tr>

            </thead>

            <tbody>

            <%
                if (items != null) {

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
                        <%= item.getUnitPrice() %>

                    </td>

                    <td class="right">

                        LKR
                        <%= item.getLineTotal() %>

                    </td>

                </tr>

            <%
                    }
                }
            %>

            </tbody>

        </table>


        <div class="totals">

            <div class="total-row">

                <span>
                    Subtotal
                </span>

                <strong>
                    LKR
                    <%= invoice.getSubtotal() %>
                </strong>

            </div>


            <div class="total-row">

                <span>
                    Discount
                </span>

                <strong>
                    LKR
                    <%= invoice.getDiscountAmount() %>
                </strong>

            </div>


            <div class="total-row">

                <span>
                    Tax
                </span>

                <strong>
                    LKR
                    <%= invoice.getTaxAmount() %>
                </strong>

            </div>


            <div class="total-row grand">

                <span>
                    TOTAL
                </span>

                <strong>
                    LKR
                    <%= invoice.getTotalAmount() %>
                </strong>

            </div>

        </div>


        <% if (isVoid) { %>

        <div class="void-box">

            <strong>
                VOIDED INVOICE
            </strong>

            <br><br>

            <strong>
                Reason:
            </strong>

            <%= invoice.getVoidReason() %>

            <br><br>

            <strong>
                Voided At:
            </strong>

            <%= invoice.getVoidedAt() %>

            <br>

            <strong>
                Voided By User:
            </strong>

            <%= invoice.getVoidedByUserId() %>

        </div>

        <% } %>


        <% if (isUnpaid) { %>

        <div
            class="void-box"
            style="
                background:#fffaf0;
                color:#6b4f00;">

            This invoice has not been paid and can
            be voided if a billing mistake is found.

            <form
                class="void-form"
                method="post"
                action="${pageContext.request.contextPath}/cashier/invoice-history"
                onsubmit="return confirm(
                    'Are you sure you want to void this invoice?'
                );">

                <input
                    type="hidden"
                    name="action"
                    value="voidInvoice">

                <input
                    type="hidden"
                    name="invoiceId"
                    value="<%= invoice.getInvoiceId() %>">

                <textarea
                    name="reason"
                    maxlength="500"
                    required
                    placeholder="Enter the reason for voiding this invoice..."></textarea>

                <br><br>

                <button
                    type="submit"
                    class="button danger">

                    Void Invoice

                </button>

            </form>

        </div>

        <% } %>


        <% if (isPaid) { %>

        <div
            class="void-box"
            style="
                background:#edf9f2;
                color:#18794e;">

            This invoice has been fully paid.

            It is preserved as a financial record and
            cannot be voided through the cashier
            interface.

        </div>

        <% } %>


        <div class="actions">

            <a
                class="button secondary"
                href="${pageContext.request.contextPath}/cashier/invoice-history">

                ← Invoice History

            </a>


            <%
                if ("UNPAID".equalsIgnoreCase(
                        invoice.getInvoiceStatus())) {
            %>

            <a
                class="button"
                href="${pageContext.request.contextPath}/cashier/payments?invoiceId=<%= invoice.getInvoiceId() %>">

                Proceed to Payment

            </a>

            <%
                }
            %>

        </div>

            <div class="actions no-print">

                <button
                    type="button"
                    class="button"
                    onclick="window.print()">

                    🖨 Print

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

                    ← Invoice History

                </a>

            </div>
            
            
    </div>

</main>

</body>

</html>