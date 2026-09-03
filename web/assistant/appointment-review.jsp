<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dentalclinic.dto.AppointmentReviewDTO" %>

<%
    AppointmentReviewDTO review = (AppointmentReviewDTO) request.getAttribute("appointmentReview");
    String error = (String) request.getAttribute("error");
%>

<%
    request.setAttribute("activeNav", "appointments");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Review Appointment</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
    <style>
        .review-layout {
            max-width: 880px;
            margin: 0 auto;
        }
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: var(--primary);
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 24px;
            transition: var(--transition);
        }
        .back-link:hover {
            gap: 10px;
        }
        .section-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--border-color);
            padding: 24px;
            box-shadow: var(--shadow-md);
            margin-bottom: 20px;
        }
        .section-card-title {
            font-size: 14px;
            font-weight: 700;
            color: var(--primary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 16px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .detail-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
        }
        .detail-item span {
            font-size: 11px;
            color: var(--text-muted);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            display: block;
            margin-bottom: 3px;
        }
        .detail-item strong {
            font-size: 14px;
            color: var(--text-heading);
            font-weight: 700;
        }
        .reason-block {
            background: var(--bg-body);
            border-radius: var(--radius-md);
            padding: 16px;
            font-size: 14px;
            color: var(--text-body);
            line-height: 1.6;
        }
        .action-bar {
            display: flex;
            gap: 12px;
            padding-top: 24px;
            border-top: 1px solid var(--border-color);
            margin-top: 4px;
        }
        .status-sent-box {
            flex: 2;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            background: #e0f2fe;
            color: #0284c7;
            font-weight: 700;
            border-radius: var(--radius-md);
            padding: 12px;
            font-size: 14px;
        }
        .approval-banner {
            background: linear-gradient(135deg, #ecfdf5, #d1fae5);
            border: 1px solid #6ee7b7;
            border-left: 5px solid #10b981;
            border-radius: var(--radius-md);
            padding: 20px 24px;
            margin-bottom: 24px;
        }
        .approval-banner h3 {
            font-size: 15px;
            font-weight: 700;
            color: #065f46;
            margin-bottom: 6px;
        }
        .approval-banner p {
            font-size: 13px;
            color: #047857;
            margin-bottom: 12px;
        }
        .approval-actions {
            display: flex;
            gap: 10px;
            margin-top: 12px;
            flex-wrap: wrap;
        }
        .token-row {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .token-row .form-control {
            font-family: monospace;
            font-size: 13px;
            font-weight: 600;
            background: #ffffff;
            flex: 1;
        }
        .patient-name-hero {
            font-size: 26px;
            font-weight: 800;
            color: var(--text-heading);
            letter-spacing: -0.5px;
            margin-bottom: 4px;
        }
        .page-intro {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 24px;
            flex-wrap: wrap;
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/includes/assistant-header.jsp" />

    <main class="main-container">
        <div class="review-layout">

            <a href="${pageContext.request.contextPath}/assistant/appointments" class="back-link">
                ← Back to Appointment Queue
            </a>

            <%
                String doctorToken = request.getParameter("doctorToken");
                if (doctorToken != null && !doctorToken.isBlank()) {
                    String publicBaseUrl = com.dentalclinic.pattern.bridge.EmailNotificationDelivery.getPublicBaseUrl();
                    String approvalUrl = publicBaseUrl + "/doctor/approval?token=" + java.net.URLEncoder.encode(doctorToken, java.nio.charset.StandardCharsets.UTF_8);
            %>
                <div class="approval-banner">
                    <h3>✓ Doctor Approval Link Generated</h3>
                    <p>A secure one-time token has been created. Share the link below with the attending doctor:</p>
                    <div class="token-row">
                        <input class="form-control" type="text" id="doctorTokenInput" readonly
                               value="<%= approvalUrl %>"
                               onclick="this.select()">
                    </div>
                    <div class="approval-actions">
                        <button type="button" class="btn btn-secondary btn-sm"
                                onclick="navigator.clipboard.writeText(document.getElementById('doctorTokenInput').value).then(()=>alert('Approval link copied!'))">
                            📋 Copy Link
                        </button>
                        <a href="<%= approvalUrl %>" target="_blank" class="btn btn-primary btn-sm">
                            👁️ Open Link ↗
                        </a>
                    </div>
                </div>
            <% } %>

            <% if (error != null) { %>
                <div class="alert alert-error" style="margin-bottom: 20px;">
                    <%= error %>
                </div>
            <% } %>

            <% if (review != null) {
                String revStatus = review.getStatusCode();
                String revBadgeClass = "badge-warning";
                String revBadgeText = revStatus;
                if ("RESCHEDULE_REQUIRED".equals(revStatus)) {
                    revBadgeClass = "badge-warning";
                    revBadgeText = "NEW TIME SELECTED — DOCTOR APPROVAL REQUIRED";
                } else if ("PENDING".equals(revStatus)) {
                    revBadgeClass = "badge-warning";
                    revBadgeText = "PENDING REVIEW";
                } else if ("AWAITING_DOCTOR_APPROVAL".equals(revStatus)) {
                    revBadgeClass = "badge-info";
                    revBadgeText = "AWAITING DOCTOR APPROVAL";
                } else if ("CONFIRMED".equals(revStatus) || "DOCTOR_APPROVED".equals(revStatus)) {
                    revBadgeClass = "badge-success";
                    revBadgeText = "DOCTOR APPROVED / CONFIRMED";
                }
            %>
                <div class="page-intro">
                    <div>
                        <div class="patient-name-hero"><%= review.getPatientName() %></div>
                        <div style="font-size: 13px; color: var(--text-muted);">Appointment #<%= review.getAppointmentId() %></div>
                    </div>
                    <span class="badge <%= revBadgeClass %>" style="font-size: 13px; padding: 7px 18px; white-space: nowrap;">
                        <%= revBadgeText %>
                    </span>
                </div>

                <!-- Patient Information -->
                <div class="section-card">
                    <div class="section-card-title">👤 Patient Information</div>
                    <div class="detail-grid">
                        <div class="detail-item">
                            <span>Full Name</span>
                            <strong><%= review.getPatientName() %></strong>
                        </div>
                        <div class="detail-item">
                            <span>Phone</span>
                            <strong><%= review.getPatientPhone() %></strong>
                        </div>
                        <div class="detail-item">
                            <span>Email</span>
                            <strong><%= review.getPatientEmail() %></strong>
                        </div>
                    </div>
                </div>

                <!-- Appointment Details -->
                <div class="section-card">
                    <div class="section-card-title">🦷 Appointment Specifications</div>
                    <div class="detail-grid">
                        <div class="detail-item">
                            <span>Service</span>
                            <strong><%= review.getServiceName() %></strong>
                        </div>
                        <div class="detail-item">
                            <span>Assigned Doctor</span>
                            <strong><%= review.getDoctorName() == null ? "Not assigned" : review.getDoctorName() %></strong>
                        </div>
                        <div class="detail-item">
                            <span>Specialization</span>
                            <strong><%= review.getDoctorSpecialization() == null ? "—" : review.getDoctorSpecialization() %></strong>
                        </div>
                        <div class="detail-item">
                            <span>Requested Date</span>
                            <strong><%= review.getRequestedDate() %></strong>
                        </div>
                        <div class="detail-item">
                            <span>Requested Time</span>
                            <strong><%= review.getRequestedTime() == null ? "Not specified" : review.getRequestedTime() %></strong>
                        </div>
                        <div class="detail-item">
                            <span>Appointment ID</span>
                            <strong>#<%= review.getAppointmentId() %></strong>
                        </div>
                    </div>
                </div>

                <!-- Reason -->
                <div class="section-card">
                    <div class="section-card-title">📝 Reason for Visit</div>
                    <div class="reason-block">
                        <%= review.getPatientReason() != null && !review.getPatientReason().isBlank() ? review.getPatientReason() : "No reason provided." %>
                    </div>
                </div>

                <!-- Action Bar -->
                <div class="action-bar">
                    <a href="${pageContext.request.contextPath}/assistant/appointments"
                       class="btn btn-secondary" style="flex: 1;">Cancel</a>

                    <% if ("PENDING".equals(review.getStatusCode()) || "RESCHEDULE_REQUIRED".equals(review.getStatusCode())) { %>
                        <form method="post" action="${pageContext.request.contextPath}/assistant/appointments"
                              style="flex: 2;">
                            <input type="hidden" name="action" value="sendToDoctor">
                            <input type="hidden" name="id" value="<%= review.getAppointmentId() %>">
                            <button type="submit" class="btn btn-primary" style="width: 100%;">
                                🚀 Send for Doctor Approval →
                            </button>
                        </form>
                    <% } else if ("UNDER_REVIEW".equals(review.getStatusCode())) { %>
                        <form method="post" action="${pageContext.request.contextPath}/assistant/appointments"
                              style="flex: 2;">
                            <input type="hidden" name="action" value="sendToDoctor">
                            <input type="hidden" name="id" value="<%= review.getAppointmentId() %>">
                            <button type="submit" class="btn btn-primary" style="width: 100%;">
                                🚀 Send to Doctor for Approval →
                            </button>
                        </form>
                    <% } else if ("AWAITING_DOCTOR_APPROVAL".equals(review.getStatusCode())) { %>
                        <div style="flex: 2; display: flex; gap: 10px;">
                            <div style="flex: 1; display: flex; align-items: center; gap: 8px; background: #e0f2fe; color: #0284c7; font-weight: 700; border-radius: var(--radius-md); padding: 10px 14px; font-size: 13px;">
                                ✓ Approval Sent to Doctor
                            </div>
                            <form method="post" action="${pageContext.request.contextPath}/assistant/appointments">
                                <input type="hidden" name="action" value="resendToDoctor">
                                <input type="hidden" name="id" value="<%= review.getAppointmentId() %>">
                                <button type="submit" class="btn btn-secondary btn-sm" style="height: 100%; white-space: nowrap;">
                                    🔁 Regenerate Link
                                </button>
                            </form>
                        </div>
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