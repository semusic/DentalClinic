<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.model.Invoice" %>
<%@ page import="com.dentalclinic.model.InvoiceItem" %>

<%
    Invoice invoice =
            (Invoice)
                    request.getAttribute("invoice");

    List<InvoiceItem> items =
            (List<InvoiceItem>)
                    request.getAttribute("invoiceItems");
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        DentalCare | Invoice
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
            max-width: 850px;

            margin:
                40px auto;

            padding:
                20px;
        }

        .invoice {
            background:
                white;

            padding:
                35px;

            border-radius:
                16px;

            box-shadow:
                0 8px 28px
                rgba(0, 0, 0, 0.06);
        }

        .header {
            display:
                flex;

            justify-content:
                space-between;

            align-items:
                flex-start;

            gap:
                20px;

            border-bottom:
                1px solid #edf2f7;

            padding-bottom:
                25px;
        }

        .clinic {
            font-size:
                26px;

            font-weight:
                700;

            color:
                #1677a5;
        }

        .invoice-title {
            color:
                #183b56;

            font-size:
                14px;

            font-weight:
                700;

            text-align:
                right;
        }

        .invoice-number {
            margin-top:
                5px;

            color:
                #718096;
        }

        .patient-box {
            margin-top:
                25px;

            display:
                grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap:
                15px;
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

        .amount {
            text-align:
                right;
        }

        .totals {
            margin-top:
                20px;

            margin-left:
                auto;

            max-width:
                320px;
        }

        .total-row {
            display:
                flex;

            justify-content:
                space-between;

            padding:
                8px 0;
        }

        .grand-total {
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

            color:
                #183b56;
        }

        .status {
            display:
                inline-block;

            margin-top:
                25px;

            padding:
                8px 14px;

            border-radius:
                20px;

            background:
                #fff4dc;

            color:
                #946200;

            font-weight:
                700;

            font-size:
                12px;
        }

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
        }

        .secondary {
            background:
                #eef2f5;

            color:
                #374151;
        }

        @media (max-width: 650px) {

            .header {
                flex-direction:
                    column;
            }

            .invoice-title {
                text-align:
                    left;
            }

            .patient-box {
                grid-template-columns:
                    1fr;
            }

            .invoice {
                padding:
                    22px;
            }

        }

    </style>

</head>

<body>

<main class="container">

    <div class="invoice">

        <div class="header">

            <div>

                <div class="clinic">
                    DentalCare
                </div>

                <div style="
                    margin-top:5px;
                    color:#718096;">

                    Dental Clinic Management System

                </div>

            </div>


            <div class="invoice-title">

                INVOICE

                <div class="invoice-number">

                    <%= invoice.getInvoiceNumber() %>

                </div>

            </div>

        </div>


        <div class="patient-box">

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
                    Patient ID
                </div>

                <div class="value">

                    <%= invoice.getPatientId() %>

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

        </div>


        <table>

            <thead>

                <tr>

                    <th>
                        Description
                    </th>

                    <th>
                        Quantity
                    </th>

                    <th class="amount">
                        Unit Price
                    </th>

                    <th class="amount">
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

                    <td class="amount">

                        LKR
                        <%= item.getUnitPrice() %>

                    </td>

                    <td class="amount">

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


            <div class="total-row grand-total">

                <span>
                    TOTAL
                </span>

                <strong>

                    LKR
                    <%= invoice.getTotalAmount() %>

                </strong>

            </div>

        </div>


        <div class="status">

            <%= invoice.getInvoiceStatus() %>

        </div>


        <div class="actions">

            <a
                class="button"
                href="${pageContext.request.contextPath}/cashier/payments?invoiceId=<%= invoice.getInvoiceId() %>">

                Proceed to Payment

            </a>


            <a
                class="button secondary"
                href="${pageContext.request.contextPath}/cashier/invoices">

                Back to Billing

            </a>

        </div>

    </div>

</main>

</body>

</html>