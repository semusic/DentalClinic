<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.model.Invoice" %>

<%
    List<Invoice> invoices = (List<Invoice>) request.getAttribute("invoices");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Invoice History</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
</head>
<body>

    <header class="app-navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/cashier/dashboard" class="nav-brand">
                <div class="brand-icon">🦷</div>
                <div class="brand-title">Dental<span>Care</span></div>
                <span class="role-badge cashier">Cashier</span>
            </a>

            <div class="nav-menu">
                <a href="${pageContext.request.contextPath}/cashier/dashboard" class="nav-link">Dashboard</a>
                <a href="${pageContext.request.contextPath}/cashier/invoices" class="nav-link">Invoices</a>
                <a href="${pageContext.request.contextPath}/cashier/invoice-history" class="nav-link active">Invoice History</a>
            </div>

            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/cashier/dashboard" class="btn btn-secondary btn-sm">← Back to Dashboard</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout btn-sm">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-container">
        <div class="page-header">
            <div class="page-title-group">
                <h1>Invoice & Payment History</h1>
                <p>Audit historical patient invoices, settled balances, and payment records.</p>
            </div>
        </div>

        <% if (error != null && !error.isBlank()) { %>
            <div class="alert alert-error"><%= error %></div>
        <% } %>

        <div class="card" style="margin-bottom: 20px; padding: 16px;">
            <input id="invoiceSearch" class="form-control" type="text" placeholder="🔍 Search by invoice number, patient ID, or visit ID...">
        </div>

        <div class="table-container">
            <% if (invoices == null || invoices.isEmpty()) { %>
                <div style="text-align: center; padding: 60px; color: var(--text-muted);">
                    <h3>No Historical Invoices Found</h3>
                    <p style="margin-top: 8px;">Generated billing invoices will appear here.</p>
                </div>
            <% } else { %>
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Invoice Number</th>
                            <th>Visit ID</th>
                            <th>Patient ID</th>
                            <th>Total Amount</th>
                            <th>Status</th>
                            <th>Issued Date</th>
                            <th style="text-align: right;">Action</th>
                        </tr>
                    </thead>
                    <tbody id="invoiceTable">
                        <% for (Invoice invoice : invoices) {
                            String status = invoice.getInvoiceStatus();
                            String badgeClass = "PAID".equalsIgnoreCase(status) ? "badge-success" :
                                                "PARTIALLY_PAID".equalsIgnoreCase(status) ? "badge-info" : "badge-warning";
                        %>
                            <tr>
                                <td>
                                    <strong><%= invoice.getInvoiceNumber() %></strong>
                                    <span style="font-size: 11px; color: var(--text-muted); display: block;">ID: #<%= invoice.getInvoiceId() %></span>
                                </td>
                                <td>#<%= invoice.getVisitId() %></td>
                                <td>#<%= invoice.getPatientId() %></td>
                                <td><strong>LKR <%= invoice.getTotalAmount() %></strong></td>
                                <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                <td><%= invoice.getIssuedAt() %></td>
                                <td style="text-align: right;">
                                    <a href="${pageContext.request.contextPath}/cashier/invoice-history?invoiceId=<%= invoice.getInvoiceId() %>" class="btn btn-secondary btn-sm">
                                        View Detail →
                                    </a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

    <script>
        const searchBox = document.getElementById("invoiceSearch");
        const table = document.getElementById("invoiceTable");
        if (searchBox && table) {
            searchBox.addEventListener("input", function () {
                const search = this.value.toLowerCase().trim();
                const rows = table.querySelectorAll("tr");
                rows.forEach(function (row) {
                    const text = row.innerText.toLowerCase();
                    row.style.display = text.includes(search) ? "" : "none";
                });
            });
        }
    </script>

</body>
</html>