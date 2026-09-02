<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dentalclinic.dto.AppointmentReviewDTO" %>

<%
    AppointmentReviewDTO review = (AppointmentReviewDTO) request.getAttribute("appointmentReview");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Review Appointment</title>
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
                <a href="${pageContext.request.contextPath}/assistant/dashboard" class="nav-link">Dashboard</a>
                <a href="${pageContext.request.contextPath}/assistant/appointments" class="nav-link active">Appointment Requests</a>
                <a href="${pageContext.request.contextPath}/assistant/visits" class="nav-link">Visits & Check-in</a>
                <a href="${pageContext.request.contextPath}/services" class="nav-link">Services</a>
            </div>

            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/assistant/appointments" class="btn btn-secondary btn-sm">← Back to Requests</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout btn-sm">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-container">
        <div class="card" style="max-width: 850px; margin: 0 auto;">
            <div class="page-header" style="margin-bottom: 20px;">
                <div class="page-title-group">
                    <h1>Review Appointment Request</h1>
                    <p>Review details before assigning and dispatching for doctor approval.</p>
                </div>
            </div>

            <% if (error != null) { %>
                <div class="alert alert-error">
                    <%= error %>
                </div>
            <% } %>

            <% if (review != null) { %>
                <div style="margin-bottom: 24px;">
                    <span class="badge badge-warning" style="font-size: 13px; padding: 6px 16px;">
                        STATUS: <%= review.getStatusCode() %>
                    </span>
                </div>

                <div class="card" style="margin-bottom: 24px; background: var(--bg-body); border: none;">
                    <h3 style="font-size: 16px; font-weight: 700; color: var(--primary); margin-bottom: 12px;">Patient Information</h3>
                    <div class="grid-3">
                        <div>
                            <span style="font-size: 12px; color: var(--text-muted); display: block;">Patient Name</span>
                            <strong><%= review.getPatientName() %></strong>
                        </div>
                        <div>
                            <span style="font-size: 12px; color: var(--text-muted); display: block;">Phone</span>
                            <strong><%= review.getPatientPhone() %></strong>
                        </div>
                        <div>
                            <span style="font-size: 12px; color: var(--text-muted); display: block;">Email</span>
                            <strong><%= review.getPatientEmail() %></strong>
                        </div>
                    </div>
                </div>

                <div class="card" style="margin-bottom: 24px; background: var(--bg-body); border: none;">
                    <h3 style="font-size: 16px; font-weight: 700; color: var(--primary); margin-bottom: 12px;">Appointment Specifications</h3>
                    <div class="grid-3">
                        <div style="margin-bottom: 12px;">
                            <span style="font-size: 12px; color: var(--text-muted); display: block;">Service</span>
                            <strong><%= review.getServiceName() %></strong>
                        </div>
                        <div style="margin-bottom: 12px;">
                            <span style="font-size: 12px; color: var(--text-muted); display: block;">Assigned Doctor</span>
                            <strong><%= review.getDoctorName() == null ? "Not assigned" : review.getDoctorName() %></strong>
                        </div>
                        <div style="margin-bottom: 12px;">
                            <span style="font-size: 12px; color: var(--text-muted); display: block;">Specialization</span>
                            <strong><%= review.getDoctorSpecialization() == null ? "—" : review.getDoctorSpecialization() %></strong>
                        </div>
                        <div>
                            <span style="font-size: 12px; color: var(--text-muted); display: block;">Requested Date</span>
                            <strong><%= review.getRequestedDate() %></strong>
                        </div>
                        <div>
                            <span style="font-size: 12px; color: var(--text-muted); display: block;">Requested Time</span>
                            <strong><%= review.getRequestedTime() == null ? "Not specified" : review.getRequestedTime() %></strong>
                        </div>
                        <div>
                            <span style="font-size: 12px; color: var(--text-muted); display: block;">Appointment ID</span>
                            <strong>#<%= review.getAppointmentId() %></strong>
                        </div>
                    </div>
                </div>

                <div style="margin-bottom: 28px;">
                    <h3 style="font-size: 16px; font-weight: 700; color: var(--text-heading); margin-bottom: 8px;">Reason for Visit</h3>
                    <div style="background: var(--bg-body); padding: 16px; border-radius: var(--radius-md); font-size: 14px;">
                        <%= review.getPatientReason() != null && !review.getPatientReason().isBlank() ? review.getPatientReason() : "No reason provided." %>
                    </div>
                </div>

                <div style="display: flex; gap: 12px; border-top: 1px solid var(--border-color); padding-top: 24px;">
                    <a href="${pageContext.request.contextPath}/assistant/appointments" class="btn btn-secondary" style="flex: 1;">Cancel</a>

                    <% if ("PENDING".equals(review.getStatusCode())) { %>
                        <form method="post" action="${pageContext.request.contextPath}/assistant/appointments" style="flex: 2;">
                            <input type="hidden" name="action" value="startReview">
                            <input type="hidden" name="id" value="<%= review.getAppointmentId() %>">
                            <button type="submit" class="btn btn-primary" style="width: 100%;">Start Review</button>
                        </form>
                    <% } %>

                    <% if ("UNDER_REVIEW".equals(review.getStatusCode())) { %>
                        <form method="post" action="${pageContext.request.contextPath}/assistant/appointments" style="flex: 2;">
                            <input type="hidden" name="action" value="sendToDoctor">
                            <input type="hidden" name="id" value="<%= review.getAppointmentId() %>">
                            <button type="submit" class="btn btn-primary" style="width: 100%;">Send to Doctor for Approval</button>
                        </form>
                    <% } %>
                </div>
            <% } %>
        </div>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>