<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dentalclinic.model.User" %>
<%
    User user = (User) session.getAttribute("authenticatedUser");
    String userName = (user != null && user.getUsername() != null) ? user.getUsername() : "Patient";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Patient Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
</head>
<body>

    <header class="app-navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/patient/dashboard" class="nav-brand">
                <div class="brand-icon">🦷</div>
                <div class="brand-title">Dental<span>Care</span></div>
                <span class="role-badge patient">Patient</span>
            </a>

            <div class="nav-menu">
                <a href="${pageContext.request.contextPath}/patient/dashboard" class="nav-link active">Dashboard</a>
                <a href="${pageContext.request.contextPath}/patient/appointments/request" class="nav-link">Book Appointment</a>
                <a href="${pageContext.request.contextPath}/patient/notifications" class="nav-link">Notifications</a>
                <a href="${pageContext.request.contextPath}/services" class="nav-link">Services</a>
            </div>

            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout btn-sm">
                    <span>Logout</span>
                </a>
            </div>
        </div>
    </header>

    <main class="main-container">
        <div class="page-header">
            <div class="page-title-group">
                <h1>Welcome, <%= userName %>!</h1>
                <p>Manage your appointments, health notifications, and dental care services.</p>
            </div>
            <a href="${pageContext.request.contextPath}/patient/appointments/request" class="btn btn-primary">
                + New Appointment Request
            </a>
        </div>

        <div class="grid-3" style="margin-bottom: 32px;">
            <a href="${pageContext.request.contextPath}/patient/appointments/request" class="action-card">
                <div>
                    <div class="action-icon">📅</div>
                    <div class="action-title">Request Appointment</div>
                    <div class="action-desc">Select your preferred dental service, specialist doctor, date, and preferred time slot.</div>
                </div>
                <div class="action-footer">
                    <span>Book Now</span> →
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/patient/notifications" class="action-card">
                <div>
                    <div class="action-icon" style="background: #fef3c7; color: #b45309;">🔔</div>
                    <div class="action-title">View Notifications</div>
                    <div class="action-desc">Check updates on your submitted appointment requests, doctor approvals, and visit details.</div>
                </div>
                <div class="action-footer" style="color: #b45309;">
                    <span>Check Alerts</span> →
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/services" class="action-card">
                <div>
                    <div class="action-icon" style="background: #f0fdf4; color: #16a34a;">🩺</div>
                    <div class="action-title">Dental Services</div>
                    <div class="action-desc">Explore our full catalog of dental procedures, preventative care, and transparent pricing.</div>
                </div>
                <div class="action-footer" style="color: #16a34a;">
                    <span>View Catalog</span> →
                </div>
            </a>
        </div>

        <div class="card">
            <div class="card-title">Patient Portal Quick Guide</div>
            <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 16px;">
                Appointments requested through this portal are reviewed by clinic staff and submitted to attending doctors for approval. You will receive notifications on your dashboard when status updates occur.
            </p>
            <div style="display: flex; gap: 12px; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/patient/appointments/request" class="btn btn-secondary btn-sm">Submit New Request</a>
                <a href="${pageContext.request.contextPath}/patient/notifications" class="btn btn-outline btn-sm">Notification Inbox</a>
            </div>
        </div>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>