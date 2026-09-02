<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.model.Invoice" %>

<%
    List<Invoice> invoices =
            (List<Invoice>)
                    request.getAttribute(
                            "invoices"
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
        DentalCare | Invoice History
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

        .header {
            background: white;
            padding: 20px 40px;
            border-bottom: 1px solid #e5e7eb;

            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .brand {
            color: #1677a5;
            font-size: 25px;
            font-weight: 700;
        }

        .back {
            color: #1677a5;
            text-decoration: none;
            font-weight: 600;
        }

        .container {
            max-width: 1150px;
            margin: 35px auto;
            padding: 0 20px;
        }

        h1 {
            margin: 0 0 8px;
            color: #183b56;
        }

        .subtitle {
            color: #718096;
            margin-bottom: 25px;
        }

        .error {
            background: #fff0f0;
            color: #b42318;
            padding: 14px 18px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .toolbar {
            background: white;
            padding: 18px;
            border-radius: 12px;
            margin-bottom: 18px;
            box-shadow:
                0 6px 20px rgba(0,0,0,0.04);
        }

        .search {
            width: 100%;
            padding: 12px;
            border: 1px solid #d7e0e7;
            border-radius: 8px;
            font-size: 14px;
        }

        .table-card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow:
                0 8px 28px rgba(0,0,0,0.05);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th,
        td {
            padding: 15px 14px;
            border-bottom: 1px solid #edf2f7;
            text-align: left;
        }

        th {
            background: #f8fafc;
            color: #718096;
            font-size: 12px;
            text-transform: uppercase;
        }

        td {
            font-size: 14px;
        }

        .invoice-number {
            font-weight: 700;
            color: #183b56;
        }

        .status {
            display: inline-block;
            padding: 6px 11px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
        }

        .unpaid {
            background: #fff4dc;
            color: #946200;
        }

        .partial {
            background: #eaf4fb;
            color: #1677a5;
        }

        .paid {
            background: #edf9f2;
            color: #18794e;
        }

        .void {
            background: #fff0f0;
            color: #b42318;
        }

        .view {
            color: #1677a5;
            text-decoration: none;
            font-weight: 700;
        }

        .empty {
            padding: 60px 20px;
            text-align: center;
            color: #718096;
        }

        @media (max-width: 800px) {

            .table-card {
                overflow-x: auto;
            }

            table {
                min-width: 800px;
            }

            .header {
                padding: 18px 20px;
            }
        }

    </style>

</head>

<body>

<header class="header">

    <div class="brand">
        DentalCare
    </div>

    <a
        class="back"
        href="${pageContext.request.contextPath}/cashier/invoices">

        ← Ready for Billing

    </a>

</header>


<main class="container">

    <h1>
        Invoice History
    </h1>

    <div class="subtitle">

        View all generated invoices and their
        current financial status.

    </div>


    <%
        if (error != null
                && !error.isBlank()) {
    %>

        <div class="error">
            <%= error %>
        </div>

    <%
        }
    %>


    <div class="toolbar">

        <input
            id="invoiceSearch"
            class="search"
            type="text"
            placeholder="Search invoice number, invoice ID, visit ID or patient ID...">

    </div>


    <div class="table-card">

    <%
        if (invoices == null
                || invoices.isEmpty()) {
    %>

        <div class="empty">

            <h2>
                No invoices found
            </h2>

            <p>
                Generated invoices will appear here.
            </p>

        </div>

    <%
        } else {
    %>

        <table>

            <thead>

                <tr>

                    <th>
                        Invoice
                    </th>

                    <th>
                        Visit
                    </th>

                    <th>
                        Patient
                    </th>

                    <th>
                        Total
                    </th>

                    <th>
                        Status
                    </th>

                    <th>
                        Issued
                    </th>

                    <th>
                        Action
                    </th>

                </tr>

            </thead>

            <tbody id="invoiceTable">

            <%
                for (Invoice invoice :
                        invoices) {

                    String status =
                            invoice.getInvoiceStatus();

                    String statusClass =
                            "PAID".equalsIgnoreCase(
                                    status)
                                    ? "paid"
                                    : "VOID".equalsIgnoreCase(
                                            status)
                                        ? "void"
                                        : "PARTIALLY_PAID"
                                                .equalsIgnoreCase(
                                                        status)
                                            ? "partial"
                                            : "unpaid";
            %>

                <tr>

                    <td>

                        <div class="invoice-number">

                            <%= invoice.getInvoiceNumber() %>

                        </div>

                        ID:
                        <%= invoice.getInvoiceId() %>

                    </td>


                    <td>

                        #
                        <%= invoice.getVisitId() %>

                    </td>


                    <td>

                        #<%= invoice.getPatientId() %>

                    </td>


                    <td>

                        LKR
                        <%= invoice.getTotalAmount() %>

                    </td>


                    <td>

                        <span
                            class="status <%= statusClass %>">

                            <%= status %>

                        </span>

                    </td>


                    <td>

                        <%= invoice.getIssuedAt() %>

                    </td>


                    <td>

                        <a
                            class="view"
                            href="${pageContext.request.contextPath}/cashier/invoice-history?invoiceId=<%= invoice.getInvoiceId() %>">

                            View

                        </a>

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


<script>

    const searchBox =
        document.getElementById(
            "invoiceSearch"
        );

    const table =
        document.getElementById(
            "invoiceTable"
        );

    if (searchBox && table) {

        searchBox.addEventListener(
            "input",
            function () {

                const search =
                    this.value
                        .toLowerCase()
                        .trim();

                const rows =
                    table.querySelectorAll(
                        "tr"
                    );

                rows.forEach(
                    function (row) {

                        const text =
                            row.innerText
                                .toLowerCase();

                        row.style.display =
                            text.includes(search)
                                ? ""
                                : "none";
                    }
                );
            }
        );
    }

</script>

</body>

</html>