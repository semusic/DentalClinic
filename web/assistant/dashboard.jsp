<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dentalclinic.model.User" %>
<%
    User user = (User) session.getAttribute("authenticatedUser");
    String userName = (user != null && user.getUsername() != null) ? user.getUsername() : "Assistant";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Assistant Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
</head>
<body>

    <header class="app-navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/assistant/dashboard" class="nav-brand">
                <div class="brand-icon">🦷</div>
                <div class="brand-title">Dental<span>Care</span></div>
                <span class="role-badge assistant">Assistant</span>
            </a>

            <div class="nav-menu">
                <a href="${pageContext.request.contextPath}/assistant/dashboard" class="nav-link active">Dashboard</a>
                <a href="${pageContext.request.contextPath}/assistant/appointments" class="nav-link">Appointment Requests</a>
                <a href="${pageContext.request.contextPath}/assistant/visits" class="nav-link">Visits & Check-in</a>
                <a href="${pageContext.request.contextPath}/services" class="nav-link">Services</a>
            </div>

            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout btn-sm">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-container">
        <div class="page-header">
            <div class="page-title-group">
                <h1>Assistant Operations Desk</h1>
                <p>Manage patient check-ins, appointment reviews, doctor approvals, and visit workflows.</p>
            </div>
        </div>

        <div class="grid-2" style="margin-bottom: 32px;">
            <a href="${pageContext.request.contextPath}/assistant/appointments" class="action-card">
                <div>
                    <div class="action-icon" style="background: #e0f2fe; color: #0284c7;">📋</div>
                    <div class="action-title">Appointment Request Queue</div>
                    <div class="action-desc">Review submitted patient requests, select qualified doctors, assign time slots, and generate secure approval links for doctors.</div>
                </div>
                <div class="action-footer" style="color: #0284c7;">
                    <span>Manage Requests</span> →
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/assistant/visits" class="action-card">
                <div>
                    <div class="action-icon" style="background: #f0fdf4; color: #16a34a;">🏥</div>
                    <div class="action-title">Patient Visits & Check-in</div>
                    <div class="action-desc">Check in arriving patients, manage active consultations, record performed services, add prescribed medicine, and track visit status.</div>
                </div>
                <div class="action-footer" style="color: #16a34a;">
                    <span>Manage Visits</span> →
                </div>
            </a>
        </div>

        <div class="card">
            <div class="card-title">Assistant Workflow Overview</div>
            <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 16px;">
                1. <strong>Request Review:</strong> Validate patient request details and send approval requests to attending doctors.<br>
                2. <strong>Patient Check-in:</strong> When patients arrive at the reception desk, register check-in under Visits.<br>
                3. <strong>Clinical Documentation:</strong> Record performed dental services, medications, and clinical notes before finalizing visits.
            </p>
            <div style="display: flex; gap: 12px; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/assistant/appointments" class="btn btn-primary btn-sm">Review Appointment Queue</a>
                <a href="${pageContext.request.contextPath}/assistant/visits" class="btn btn-secondary btn-sm">View Active Visits</a>
            </div>
        </div>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>