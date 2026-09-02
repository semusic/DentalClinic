<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dentalclinic.dto.CashierVisitDTO" %>

<%
    CashierVisitDTO visit = (CashierVisitDTO) request.getAttribute("visit");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Generate Invoice</title>
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
                <a href="${pageContext.request.contextPath}/cashier/invoices" class="btn btn-secondary btn-sm">← Back to Invoices</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout btn-sm">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-container">
        <div class="card" style="max-width: 800px; margin: 0 auto;">
            <div class="page-header" style="margin-bottom: 24px;">
                <div class="page-title-group">
                    <h1>Generate Patient Invoice</h1>
                    <p>Review visit details and calculate itemized total for billing.</p>
                </div>
            </div>

            <% if (error != null && !error.isBlank()) { %>
                <div class="alert alert-error"><%= error %></div>
            <% } %>

            <% if (visit != null) { %>
                <div class="grid-2" style="background: var(--bg-body); padding: 18px; border-radius: var(--radius-md); margin-bottom: 24px;">
                    <div>
                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Patient Name</span>
                        <strong style="font-size: 16px;"><%= visit.getPatientName() %></strong>
                    </div>
                    <div>
                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Doctor</span>
                        <strong style="font-size: 16px;"><%= visit.getDoctorName() %></strong>
                    </div>
                    <div style="margin-top: 10px;">
                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Visit ID</span>
                        <strong>#<%= visit.getVisitId() %></strong>
                    </div>
                    <div style="margin-top: 10px;">
                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Consultation Completed</span>
                        <strong><%= visit.getConsultationCompletedAt() %></strong>
                    </div>
                </div>

                <div class="alert alert-success" style="margin-bottom: 24px; background: #e0f2fe; color: #0369a1; border-color: #bae6fd;">
                    ℹ️ The system will aggregate all recorded services and prices for this visit to compute the total invoice amount automatically.
                </div>

                <form method="post" action="${pageContext.request.contextPath}/cashier/invoices">
                    <input type="hidden" name="action" value="generateInvoice">
                    <input type="hidden" name="visitId" value="<%= visit.getVisitId() %>">

                    <div style="display: flex; gap: 12px; margin-top: 24px;">
                        <a href="${pageContext.request.contextPath}/cashier/invoices" class="btn btn-secondary" style="flex: 1;">Cancel</a>
                        <button type="submit" class="btn btn-primary" style="flex: 2;">Confirm & Generate Invoice</button>
                    </div>
                </form>
            <% } %>
        </div>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>