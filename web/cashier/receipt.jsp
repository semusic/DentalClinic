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
            font-family: Arial, sans-serif;
            background: #f5f9fc;
            color: #263238;
        }

        .container {
            max-width: 850px;
            margin: 40px auto;
            padding: 20px;
        }

        .receipt {
            background: white;
            padding: 35px;
            border-radius: 16px;

            box-shadow:
                0 8px 28px
                rgba(0,0,0,0.06);
        }

        .top {
            display: flex;
            justify-content: space-between;
            gap: 20px;

            border-bottom:
                1px solid #edf2f7;

            padding-bottom:
                25px;
        }

        .brand {
            font-size: 26px;
            font-weight: 700;
            color: #1677a5;
        }

        h1 {
            margin: 5px 0;
            color: #183b56;
        }

        .muted {
            color: #718096;
        }

        .receipt-number {
            text-align: right;
            font-weight: 700;
            color: #183b56;
        }

        .details {
            display: grid;
            grid-template-columns:
                repeat(3, 1fr);
            gap: 14px;
            margin-top: 25px;
        }

        .detail {
            background: #f8fafc;
            padding: 15px;
            border-radius: 10px;
        }

        .label {
            font-size: 12px;
            color: #718096;
            margin-bottom: 5px;
        }

        .value {
            font-weight: 700;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 30px;
        }

        th,
        td {
            padding: 13px 8px;
            border-bottom:
                1px solid #edf2f7;
            text-align: left;
        }

        th {
            font-size: 12px;
            color: #718096;
        }

        .right {
            text-align: right;
        }

        .paid {
            margin-top: 25px;
            padding: 20px;
            border-radius: 12px;
            background: #edf9f2;
            color: #18794e;
        }

        .paid-amount {
            margin-top: 6px;
            font-size: 25px;
            font-weight: 700;
        }

        .actions {
            margin-top: 25px;

            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .button {
            padding: 11px 18px;
            border-radius: 9px;
            background: #1677a5;
            color: white;
            text-decoration: none;
            font-weight: 700;
        }

        .secondary {
            background: #eef2f5;
            color: #374151;
        }

        @media (max-width: 650px) {

            .top {
                flex-direction: column;
            }

            .receipt-number {
                text-align: left;
            }

            .details {
                grid-template-columns: 1fr;
            }

            .receipt {
                padding: 22px;
            }
        }

    </style>

</head>

<body>

<main class="container">

    <div class="receipt">

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
                        <%= item.getLineTotal() %>

                    </td>

                </tr>

            <%
                    }
                }
            %>

            </tbody>

        </table>


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


        <div class="actions">

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

    </div>

</main>

</body>

</html>