<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    String reportType = (String) request.getAttribute("reportType");
    List<Map<String, Object>> rows = (List<Map<String, Object>>) request.getAttribute("reportData");
%>

<%
    request.setAttribute("activeNav", "reports");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Executive Clinic Reports</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
    <style>
        .report-nav {
            display: flex;
            gap: 8px;
            margin-bottom: 24px;
            flex-wrap: wrap;
        }
        .report-tab {
            padding: 10px 18px;
            border-radius: var(--radius-md);
            background: #ffffff;
            border: 1px solid var(--border-color);
            color: var(--text-body);
            text-decoration: none;
            font-weight: 600;
            font-size: 13px;
        }
        .report-tab.active {
            background: var(--primary);
            color: #ffffff;
            border-color: var(--primary);
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/includes/admin-header.jsp" />

    <main class="main-container">
        <div class="page-header">
            <div class="page-title-group">
                <h1>Executive Management Reports</h1>
                <p>Data-driven operational intelligence, financial audits, and procedure utilization metrics.</p>
            </div>
            <div class="no-print" style="display: flex; gap: 10px;">
                <button type="button" onclick="window.print()" class="btn btn-secondary btn-sm">🖨 Print Report</button>
                <a href="${pageContext.request.contextPath}/admin/reports?type=<%= reportType %>&export=csv" class="btn btn-primary btn-sm">📥 Export CSV</a>
            </div>
        </div>

        <div class="report-nav no-print">
            <a href="${pageContext.request.contextPath}/admin/reports?type=daily_appointments" class="report-tab <%= "daily_appointments".equals(reportType) ? "active" : "" %>">📅 Daily Appointments</a>
            <a href="${pageContext.request.contextPath}/admin/reports?type=completed_treatments" class="report-tab <%= "completed_treatments".equals(reportType) ? "active" : "" %>">🩺 Completed Treatments</a>
            <a href="${pageContext.request.contextPath}/admin/reports?type=revenue_payments" class="report-tab <%= "revenue_payments".equals(reportType) ? "active" : "" %>">💰 Revenue & Payments</a>
            <a href="${pageContext.request.contextPath}/admin/reports?type=outstanding_invoices" class="report-tab <%= "outstanding_invoices".equals(reportType) ? "active" : "" %>">⚠️ Outstanding Invoices</a>
            <a href="${pageContext.request.contextPath}/admin/reports?type=popular_services" class="report-tab <%= "popular_services".equals(reportType) ? "active" : "" %>">⭐ Service Utilization</a>
        </div>

        <div class="table-container">
            <% if (rows == null || rows.isEmpty()) { %>
                <div style="text-align: center; padding: 60px; color: var(--text-muted);">
                    <h3>No report data available for this criteria</h3>
                </div>
            <% } else { %>
                <table class="table table-hover">
                    <% if ("daily_appointments".equals(reportType)) { %>
                        <thead>
                            <tr>
                                <th>Appointment Number</th>
                                <th>Requested Date</th>
                                <th>Patient Name</th>
                                <th>Service Offered</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, Object> r : rows) { %>
                                <tr>
                                    <td><strong><%= r.get("appointmentNumber") != null ? r.get("appointmentNumber") : "APT-ID-" + r.get("appointmentId") %></strong></td>
                                    <td><%= r.get("requestedDate") %></td>
                                    <td><%= r.get("patientName") %></td>
                                    <td><%= r.get("serviceName") %></td>
                                    <td><span class="badge badge-info"><%= r.get("statusCode") %></span></td>
                                </tr>
                            <% } %>
                        </tbody>
                    <% } else if ("completed_treatments".equals(reportType)) { %>
                        <thead>
                            <tr>
                                <th>Visit Record ID</th>
                                <th>Service Performed</th>
                                <th>Attending Doctor</th>
                                <th>Qty</th>
                                <th>Unit Price</th>
                                <th>Total Revenue</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, Object> r : rows) { %>
                                <tr>
                                    <td>#<%= r.get("id") %></td>
                                    <td><strong><%= r.get("serviceName") %></strong></td>
                                    <td><%= r.get("doctorName") %></td>
                                    <td><%= r.get("quantity") %></td>
                                    <td>LKR <%= r.get("unitPrice") %></td>
                                    <td><strong>LKR <%= r.get("lineTotal") %></strong></td>
                                </tr>
                            <% } %>
                        </tbody>
                    <% } else if ("revenue_payments".equals(reportType)) { %>
                        <thead>
                            <tr>
                                <th>Payment Reference</th>
                                <th>Invoice Number</th>
                                <th>Payment Method</th>
                                <th>Amount Paid</th>
                                <th>Status</th>
                                <th>Transaction Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, Object> r : rows) { %>
                                <tr>
                                    <td><code><%= r.get("reference") %></code></td>
                                    <td><%= r.get("invoiceNumber") %></td>
                                    <td><span class="badge badge-info"><%= r.get("method") %></span></td>
                                    <td><strong>LKR <%= r.get("amount") %></strong></td>
                                    <td><span class="badge badge-success"><%= r.get("status") %></span></td>
                                    <td><%= r.get("date") %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    <% } else if ("outstanding_invoices".equals(reportType)) { %>
                        <thead>
                            <tr>
                                <th>Invoice Number</th>
                                <th>Patient Name</th>
                                <th>Total Bill</th>
                                <th>Status</th>
                                <th>Issued Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, Object> r : rows) { %>
                                <tr>
                                    <td><strong><%= r.get("invoiceNumber") %></strong></td>
                                    <td><%= r.get("patientName") %></td>
                                    <td><strong>LKR <%= r.get("totalAmount") %></strong></td>
                                    <td><span class="badge badge-danger"><%= r.get("status") %></span></td>
                                    <td><%= r.get("issuedAt") %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    <% } else if ("popular_services".equals(reportType)) { %>
                        <thead>
                            <tr>
                                <th>Service Name</th>
                                <th>Category</th>
                                <th>Total Patient Bookings</th>
                                <th>Standard Price</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, Object> r : rows) { %>
                                <tr>
                                    <td><strong><%= r.get("serviceName") %></strong></td>
                                    <td><span class="badge badge-info"><%= r.get("categoryName") %></span></td>
                                    <td><strong><%= r.get("totalBookings") %> bookings</strong></td>
                                    <td>LKR <%= String.format("%,.2f", r.get("standardPrice")) %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    <% } %>
                </table>
            <% } %>
        </div>
    </main>

    <footer class="app-footer no-print">
        DentalCare Clinic Management System
    </footer>

</body>
</html>
