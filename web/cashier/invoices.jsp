<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.model.PatientVisit" %>

<%
    List<PatientVisit> completedVisits = (List<PatientVisit>) request.getAttribute("completedVisits");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Active Invoices</title>
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
                <a href="${pageContext.request.contextPath}/cashier/invoices" class="nav-link active">Invoices</a>
                <a href="${pageContext.request.contextPath}/cashier/invoice-history" class="nav-link">Invoice History</a>
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
                <h1>Pending Billing Visits</h1>
                <p>Select completed consultations to generate official patient invoices.</p>
            </div>
        </div>

        <% if (error != null && !error.isBlank()) { %>
            <div class="alert alert-error"><%= error %></div>
        <% } %>

        <% if (completedVisits == null || completedVisits.isEmpty()) { %>
            <div class="card" style="text-align: center; padding: 60px; color: var(--text-muted);">
                <h3>No Completed Visits Pending Invoicing</h3>
                <p style="margin-top: 8px;">All recent patient consultations have been invoiced or none are ready for billing.</p>
            </div>
        <% } else { %>
            <div class="table-container">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Visit ID</th>
                            <th>Appointment ID</th>
                            <th>Consultation Completed</th>
                            <th>Medicine Prescribed</th>
                            <th style="text-align: right;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (PatientVisit visit : completedVisits) { %>
                            <tr>
                                <td><strong>Visit #<%= visit.getVisitId() %></strong></td>
                                <td>Appointment #<%= visit.getAppointmentId() %></td>
                                <td><%= visit.getConsultationCompletedAt() %></td>
                                <td>
                                    <span class="badge <%= visit.isMedicinePrescribed() ? "badge-info" : "badge-success" %>">
                                        <%= visit.isMedicinePrescribed() ? "Yes" : "No" %>
                                    </span>
                                </td>
                                <td style="text-align: right;">
                                    <a href="${pageContext.request.contextPath}/cashier/invoices?visitId=<%= visit.getVisitId() %>" class="btn btn-primary btn-sm">
                                        Generate Invoice →
                                    </a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>