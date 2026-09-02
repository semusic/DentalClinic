<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.dentalclinic.model.Invoice" %>
<%@ page import="com.dentalclinic.model.InvoiceItem" %>
<%@ page import="com.dentalclinic.model.Payment" %>

<%
    Invoice invoice =
            (Invoice)
                    request.getAttribute("invoice");

    List<InvoiceItem> items =
            (List<InvoiceItem>)
                    request.getAttribute(
                            "invoiceItems"
                    );

    List<Payment> payments =
            (List<Payment>)
                    request.getAttribute(
                            "payments"
                    );

    BigDecimal alreadyPaid =
            (BigDecimal)
                    request.getAttribute(
                            "alreadyPaid"
                    );

    BigDecimal outstanding =
            (BigDecimal)
                    request.getAttribute(
                            "outstanding"
                    );

    String error =
            (String)
                    request.getAttribute(
                            "error"
                    );
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        DentalCare | Payment
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

        .card {
            background: white;
            border-radius: 16px;
            padding: 28px;
            margin-bottom: 20px;

            box-shadow:
                0 8px 28px
                rgba(0,0,0,0.05);
        }

        .header {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            align-items: flex-start;
        }

        h1 {
            margin: 0 0 8px;
            color: #183b56;
        }

        h2 {
            color: #183b56;
            margin-top: 0;
        }

        .subtitle,
        .muted {
            color: #718096;
        }

        .details {
            display: grid;
            grid-template-columns:
                repeat(3, 1fr);
            gap: 14px;
            margin-top: 22px;
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
            margin-top: 15px;
        }

        th,
        td {
            padding: 13px 8px;
            border-bottom:
                1px solid #edf2f7;
            text-align: left;
        }

        th {
            color: #718096;
            font-size: 12px;
        }

        .right {
            text-align: right;
        }

        .summary {
            max-width: 350px;
            margin-left: auto;
            margin-top: 20px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
        }

        .outstanding {
            border-top:
                2px solid #183b56;
            padding-top: 12px;
            margin-top: 8px;
            font-size: 20px;
            font-weight: 700;
            color: #183b56;
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-size: 13px;
            font-weight: 600;
        }

        input,
        select,
        textarea {
            width: 100%;
            padding: 12px;
            border:
                1px solid #d7e0e7;
            border-radius: 8px;
            font-family: inherit;
        }

        textarea {
            min-height: 90px;
            resize: vertical;
        }

        .form-grid {
            display: grid;
            grid-template-columns:
                1fr 1fr;
            gap: 18px;
        }

        .full {
            grid-column: 1 / -1;
        }

        .button {
            border: none;
            padding: 12px 20px;
            border-radius: 9px;
            background: #1677a5;
            color: white;
            font-weight: 700;
            cursor: pointer;
        }

        .error {
            background: #fff0f0;
            color: #b42318;
            padding: 14px 18px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .payment-history {
            margin-top: 15px;
        }

        .empty {
            padding: 18px;
            text-align: center;
            background: #f8fafc;
            border-radius: 10px;
            color: #718096;
        }

        @media (max-width: 700px) {

            .details,
            .form-grid {
                grid-template-columns:
                    1fr;
            }

            .full {
                grid-column: auto;
            }

        }

    </style>

</head>

<body>

<main class="container">

    <div class="card">

        <div class="header">

            <div>

                <h1>
                    Payment
                </h1>

                <div class="subtitle">

                    Invoice:
                    <strong>
                        <%= invoice.getInvoiceNumber() %>
                    </strong>

                </div>

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
                    Patient ID
                </div>

                <div class="value">
                    <%= invoice.getPatientId() %>
                </div>

            </div>


            <div class="detail">

                <div class="label">
                    Invoice Status
                </div>

                <div class="value">
                    <%= invoice.getInvoiceStatus() %>
                </div>

            </div>

        </div>

    </div>


    <div class="card">

        <h2>
            Invoice Items
        </h2>

        <table>

            <thead>

                <tr>

                    <th>
                        Description
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


        <div class="summary">

            <div class="summary-row">

                <span>
                    Invoice Total
                </span>

                <strong>
                    LKR
                    <%= invoice.getTotalAmount() %>
                </strong>

            </div>


            <div class="summary-row">

                <span>
                    Already Paid
                </span>

                <strong>
                    LKR
                    <%= alreadyPaid %>
                </strong>

            </div>


            <div class="summary-row outstanding">

                <span>
                    Outstanding
                </span>

                <strong>
                    LKR
                    <%= outstanding %>
                </strong>

            </div>

        </div>

    </div>


    <div class="card">

        <h2>
            Make Payment
        </h2>

        <form
            method="post"
            action="${pageContext.request.contextPath}/cashier/payments">

            <input
                type="hidden"
                name="action"
                value="makePayment">

            <input
                type="hidden"
                name="invoiceId"
                value="<%= invoice.getInvoiceId() %>">


            <div class="form-grid">

                <div>

                    <label>
                        Payment Amount (LKR)
                    </label>

                    <input
                        type="number"
                        name="amount"
                        min="0.01"
                        step="0.01"
                        max="<%= outstanding %>"
                        value="<%= outstanding %>"
                        required>

                </div>


                <div>

                    <label>
                        Payment Method
                    </label>

                    <select
                        name="paymentMethod"
                        required>

                        <option value="">
                            Select method
                        </option>

                        <option value="CASH">
                            Cash
                        </option>

                        <option value="CARD">
                            Card
                        </option>

                        <option value="BANK_TRANSFER">
                            Bank Transfer
                        </option>

                    </select>

                </div>


                <div class="full">

                    <label>
                        Notes
                    </label>

                    <textarea
                        name="notes"
                        maxlength="500"
                        placeholder="Optional payment note"></textarea>

                </div>

            </div>


            <br>

            <button
                type="submit"
                class="button">

                Process Payment

            </button>

        </form>

    </div>


    <div class="card payment-history">

        <h2>
            Payment History
        </h2>

        <%
            if (payments == null
                    || payments.isEmpty()) {
        %>

            <div class="empty">

                No payments have been recorded
                for this invoice.

            </div>

        <%
            } else {
        %>

            <table>

                <thead>

                    <tr>

                        <th>
                            Reference
                        </th>

                        <th>
                            Method
                        </th>

                        <th>
                            Amount
                        </th>

                        <th>
                            Status
                        </th>

                        <th>
                            Date
                        </th>

                    </tr>

                </thead>

                <tbody>

                <%
                    for (Payment payment :
                            payments) {
                %>

                    <tr>

                        <td>
                            <%= payment.getPaymentReference() %>
                        </td>

                        <td>
                            <%= payment.getPaymentMethod() %>
                        </td>

                        <td>
                            LKR
                            <%= payment.getAmount() %>
                        </td>

                        <td>
                            <%= payment.getPaymentStatus() %>
                        </td>

                        <td>
                            <%= payment.getTransactionDate() %>
                        </td>

                    </tr>

                <%
                    }
                %>

                </tbody>

            </table>

        <%
            }
        %>

    </div>

</main>

</body>

</html>