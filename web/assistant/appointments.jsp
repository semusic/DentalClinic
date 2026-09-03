<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.dto.AppointmentReviewDTO" %>

<%
    String doctorToken = request.getParameter("doctorToken");
%>

<%
    request.setAttribute("activeNav", "appointments");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Appointment Requests</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
    <style>
        .request-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--border-color);
            padding: 24px;
            box-shadow: var(--shadow-md);
            transition: var(--transition);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            gap: 16px;
        }
        .request-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary-border);
        }
        .request-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 12px;
        }
        .request-id {
            font-size: 11px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .request-name {
            font-size: 20px;
            font-weight: 800;
            color: var(--text-heading);
            margin-top: 2px;
            letter-spacing: -0.3px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            background: var(--bg-body);
            padding: 14px;
            border-radius: var(--radius-md);
        }
        .info-item span {
            font-size: 11px;
            color: var(--text-muted);
            display: block;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
        .info-item strong {
            font-size: 13px;
            color: var(--text-heading);
        }
        .reason-box {
            background: #f8fafc;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-sm);
            padding: 12px 14px;
            font-size: 13px;
            color: var(--text-body);
            line-height: 1.5;
        }
        .reason-label {
            font-size: 10px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: block;
            margin-bottom: 4px;
        }
        .request-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-top: 14px;
            border-top: 1px solid var(--border-color);
        }
        .submitted-at {
            font-size: 12px;
            color: var(--text-muted);
        }
        .empty-queue {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 80px 40px;
            text-align: center;
            box-shadow: var(--shadow-sm);
        }
        .empty-queue-icon {
            width: 64px;
            height: 64px;
            background: var(--primary-light);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            margin: 0 auto 16px;
        }
        .empty-queue h3 {
            font-size: 20px;
            font-weight: 700;
            color: var(--text-heading);
            margin-bottom: 8px;
        }
        .empty-queue p {
            color: var(--text-muted);
            font-size: 14px;
        }
        .success-banner {
            background: linear-gradient(135deg, #ecfdf5, #d1fae5);
            border: 1px solid #6ee7b7;
            border-left: 4px solid #10b981;
            border-radius: var(--radius-md);
            padding: 20px 24px;
            margin-bottom: 24px;
        }
        .success-banner h3 {
            font-size: 15px;
            font-weight: 700;
            color: #065f46;
            margin-bottom: 6px;
        }
        .success-banner p {
            font-size: 13px;
            color: #047857;
            margin-bottom: 12px;
        }
        .token-input-row {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .token-input-row .form-control {
            font-family: monospace;
            font-size: 13px;
            font-weight: 600;
            background: #ffffff;
            flex: 1;
        }
        .queue-count-bar {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 24px;
        }
        .queue-count-pill {
            background: var(--primary);
            color: #fff;
            font-size: 12px;
            font-weight: 700;
            padding: 4px 12px;
            border-radius: 20px;
        }
        .queue-count-text {
            font-size: 14px;
            color: var(--text-muted);
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/includes/assistant-header.jsp" />

    <main class="main-container">

        <% if (doctorToken != null && !doctorToken.isBlank()) { %>
            <div class="success-banner">
                <h3>✓ Appointment Sent to Doctor for Approval</h3>
                <p>A secure one-time approval link has been generated. Copy or open it below:</p>
                <div class="token-input-row">
                    <input class="form-control" type="text" id="doctorTokenInput" readonly
                           value="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/doctor/approval?token=<%= doctorToken %>"
                           onclick="this.select()">
                    <button type="button" class="btn btn-secondary btn-sm"
                            onclick="navigator.clipboard.writeText(document.getElementById('doctorTokenInput').value).then(()=>alert('Link copied!'))">
                        📋 Copy
                    </button>
                </div>
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
            <div class="empty-queue">
                <div class="empty-queue-icon">📋</div>
                <h3>No Pending Requests</h3>
                <p>There are currently no appointment requests in the review queue. New patient requests will appear here.</p>
            </div>
        <%
            } else {
        %>
            <div class="queue-count-bar">
                <span class="queue-count-pill"><%= reviews.size() %></span>
                <span class="queue-count-text">pending request<%= reviews.size() == 1 ? "" : "s" %> in queue</span>
            </div>

            <div class="grid-2">
                <% for (AppointmentReviewDTO review : reviews) {
                    String status = review.getStatusCode();
                    String badgeClass = "badge-warning";
                    String statusText = status;
                    if ("RESCHEDULE_REQUIRED".equals(status)) {
                        badgeClass = "badge-warning";
                        statusText = "NEW TIME — NEEDS REVIEW";
                    } else if ("AWAITING_DOCTOR_APPROVAL".equals(status)) {
                        badgeClass = "badge-info";
                        statusText = "AWAITING DOCTOR";
                    } else if ("CONFIRMED".equals(status) || "DOCTOR_APPROVED".equals(status)) {
                        badgeClass = "badge-success";
                        statusText = "APPROVED";
                    } else if ("PENDING".equals(status)) {
                        badgeClass = "badge-warning";
                        statusText = "PENDING REVIEW";
                    }
                    String actionLabel = "Review Request →";
                    if ("RESCHEDULE_REQUIRED".equals(status)) {
                        actionLabel = "Start Doctor Review →";
                    } else if ("AWAITING_DOCTOR_APPROVAL".equals(status)) {
                        actionLabel = "View / Regenerate Link →";
                    }
                %>
                    <div class="request-card">
                        <div>
                            <div class="request-header">
                                <div>
                                    <div class="request-id">Appointment #<%= review.getAppointmentId() %></div>
                                    <div class="request-name"><%= review.getPatientName() %></div>
                                </div>
                                <span class="badge <%= badgeClass %>"><%= statusText %></span>
                            </div>

                            <div class="info-grid" style="margin: 16px 0;">
                                <div class="info-item">
                                    <span>Service</span>
                                    <strong><%= review.getServiceName() %></strong>
                                </div>
                                <div class="info-item">
                                    <span>Doctor</span>
                                    <strong><%= review.getDoctorName() != null ? review.getDoctorName() : "Unassigned" %></strong>
                                </div>
                                <div class="info-item">
                                    <span>Date</span>
                                    <strong><%= review.getRequestedDate() %></strong>
                                </div>
                                <div class="info-item">
                                    <span>Time</span>
                                    <strong><%= review.getRequestedTime() != null ? review.getRequestedTime() : "Flexible" %></strong>
                                </div>
                            </div>

                            <div class="reason-box">
                                <span class="reason-label">Patient Reason</span>
                                <%= review.getPatientReason() != null && !review.getPatientReason().isBlank() ? review.getPatientReason() : "No specific reason provided." %>
                            </div>
                        </div>

                        <div class="request-footer">
                            <span class="submitted-at">Submitted: <%= review.getCreatedAt() %></span>
                            <a href="${pageContext.request.contextPath}/assistant/appointments?action=review&id=<%= review.getAppointmentId() %>"
                               class="btn btn-primary btn-sm">
                                <%= actionLabel %>
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