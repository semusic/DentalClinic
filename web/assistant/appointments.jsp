<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.dto.AppointmentReviewDTO" %>

<%
    String doctorToken = request.getParameter("doctorToken");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Appointment Requests</title>
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
                <a href="${pageContext.request.contextPath}/assistant/dashboard" class="btn btn-secondary btn-sm">← Back to Dashboard</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout btn-sm">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-container">
        <% if (doctorToken != null && !doctorToken.isBlank()) { %>
            <div class="alert alert-success" style="margin-bottom: 24px; padding: 20px;">
                <h3 style="font-size: 16px; font-weight: 700; margin-bottom: 8px;">✓ Appointment Sent to Doctor for Approval</h3>
                <p style="margin-bottom: 12px; font-size: 14px;">The generated secure doctor approval link is:</p>
                <input class="form-control" type="text" readonly
                       value="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/doctor/approval?token=<%= doctorToken %>"
                       onclick="this.select()" style="font-family: monospace; font-weight: 600;">
                <p style="font-size: 12px; color: var(--text-muted); margin-top: 8px;">
                    This link can be clicked directly to open the Doctor Approval page.
                </p>
            </div>
        <% } %>

        <div class="page-header">
            <div class="page-title-group">
                <h1>Appointment Requests</h1>
                <p>Review patient appointment requests and assign them to doctors for approval.</p>
            </div>
        </div>

        <%
            List<AppointmentReviewDTO> reviews = (List<AppointmentReviewDTO>) request.getAttribute("appointmentReviews");
            if (reviews == null || reviews.isEmpty()) {
        %>
            <div class="card" style="text-align: center; padding: 60px; color: var(--text-muted);">
                <h3>No Appointment Requests Requiring Review</h3>
                <p style="margin-top: 8px;">There are currently no active appointment requests in the review queue.</p>
            </div>
        <%
            } else {
        %>
            <div class="grid-2">
                <% for (AppointmentReviewDTO review : reviews) { %>
                    <div class="card card-hover" style="display: flex; flex-direction: column; justify-content: space-between;">
                        <div>
                            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 16px;">
                                <div>
                                    <span style="font-size: 12px; color: var(--text-muted); font-weight: 700;">APPOINTMENT #<%= review.getAppointmentId() %></span>
                                    <h3 style="font-size: 20px; font-weight: 800; color: var(--text-heading); margin-top: 2px;"><%= review.getPatientName() %></h3>
                                </div>
                                <span class="badge badge-warning"><%= review.getStatusCode() %></span>
                            </div>

                            <div class="grid-2" style="gap: 12px; margin-bottom: 16px; background: var(--bg-body); padding: 14px; border-radius: var(--radius-md);">
                                <div>
                                    <span style="font-size: 11px; color: var(--text-muted); display: block;">Requested Service</span>
                                    <strong style="font-size: 13px;"><%= review.getServiceName() %></strong>
                                </div>
                                <div>
                                    <span style="font-size: 11px; color: var(--text-muted); display: block;">Doctor</span>
                                    <strong style="font-size: 13px;"><%= review.getDoctorName() != null ? review.getDoctorName() : "Unassigned" %></strong>
                                </div>
                                <div>
                                    <span style="font-size: 11px; color: var(--text-muted); display: block;">Date</span>
                                    <strong style="font-size: 13px;"><%= review.getRequestedDate() %></strong>
                                </div>
                                <div>
                                    <span style="font-size: 11px; color: var(--text-muted); display: block;">Time</span>
                                    <strong style="font-size: 13px;"><%= review.getRequestedTime() != null ? review.getRequestedTime() : "Flexible" %></strong>
                                </div>
                            </div>

                            <div style="font-size: 13px; color: var(--text-body); margin-bottom: 16px; background: #ffffff; border: 1px solid var(--border-color); padding: 12px; border-radius: var(--radius-sm);">
                                <strong style="color: var(--text-muted); font-size: 11px; display: block; margin-bottom: 4px;">PATIENT REASON</strong>
                                <%= review.getPatientReason() != null && !review.getPatientReason().isBlank() ? review.getPatientReason() : "No specific reason provided." %>
                            </div>
                        </div>

                        <div style="display: flex; align-items: center; justify-content: space-between; border-top: 1px solid var(--border-color); padding-top: 14px; margin-top: 12px;">
                            <span style="font-size: 12px; color: var(--text-muted);">Submitted: <%= review.getCreatedAt() %></span>
                            <a href="${pageContext.request.contextPath}/assistant/appointments?action=review&id=<%= review.getAppointmentId() %>" class="btn btn-primary btn-sm">
                                Review Request →
                            </a>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>