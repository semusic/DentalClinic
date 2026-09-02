<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dentalclinic.dto.DoctorApprovalReviewDTO" %>

<%
    DoctorApprovalReviewDTO approval = (DoctorApprovalReviewDTO) request.getAttribute("approval");
    String token = (String) request.getAttribute("token");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Doctor Approval</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
</head>
<body style="background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%); min-height: 100vh;">

    <header class="app-navbar" style="background: #ffffff; border-bottom: 1px solid var(--border-color);">
        <div class="nav-container" style="justify-content: center;">
            <div class="nav-brand">
                <div class="brand-icon">🦷</div>
                <div class="brand-title">Dental<span>Care</span></div>
                <span class="role-badge" style="background: #fef3c7; color: #b45309; border-color: #fde68a;">Secure Doctor Approval</span>
            </div>
        </div>
    </header>

    <main class="main-container">
        <div class="card" style="max-width: 800px; margin: 0 auto; padding: 36px; box-shadow: var(--shadow-lg);">
            <% if (error != null) { %>
                <div class="alert alert-error"><%= error %></div>
            <% } %>

            <% if (approval != null) { %>
                <div style="margin-bottom: 24px; text-align: center;">
                    <h1 style="font-size: 26px; font-weight: 800; color: var(--text-heading);">Appointment Approval Request</h1>
                    <p style="color: var(--text-muted); font-size: 14px; margin-top: 4px;">
                        Please review the patient appointment request details below and record your decision.
                    </p>
                </div>

                <div class="card" style="margin-bottom: 20px; background: var(--bg-body); border: none;">
                    <h3 style="font-size: 15px; font-weight: 700; color: var(--primary); margin-bottom: 10px;">🩺 Attending Doctor Details</h3>
                    <div class="grid-2">
                        <div>
                            <span style="font-size: 11px; color: var(--text-muted); display: block;">Doctor Name</span>
                            <strong><%= approval.getDoctorName() %></strong>
                        </div>
                        <div>
                            <span style="font-size: 11px; color: var(--text-muted); display: block;">Specialization</span>
                            <strong><%= approval.getDoctorSpecialization() %></strong>
                        </div>
                    </div>
                </div>

                <div class="card" style="margin-bottom: 20px; background: var(--bg-body); border: none;">
                    <h3 style="font-size: 15px; font-weight: 700; color: var(--primary); margin-bottom: 10px;">👤 Patient Information</h3>
                    <div class="grid-3">
                        <div>
                            <span style="font-size: 11px; color: var(--text-muted); display: block;">Patient Name</span>
                            <strong><%= approval.getPatientName() %></strong>
                        </div>
                        <div>
                            <span style="font-size: 11px; color: var(--text-muted); display: block;">Phone</span>
                            <strong><%= approval.getPatientPhone() %></strong>
                        </div>
                        <div>
                            <span style="font-size: 11px; color: var(--text-muted); display: block;">Email</span>
                            <strong><%= approval.getPatientEmail() %></strong>
                        </div>
                    </div>
                </div>

                <div class="card" style="margin-bottom: 20px; background: var(--bg-body); border: none;">
                    <h3 style="font-size: 15px; font-weight: 700; color: var(--primary); margin-bottom: 10px;">📅 Appointment Request Details</h3>
                    <div class="grid-4">
                        <div>
                            <span style="font-size: 11px; color: var(--text-muted); display: block;">Service</span>
                            <strong><%= approval.getServiceName() %></strong>
                        </div>
                        <div>
                            <span style="font-size: 11px; color: var(--text-muted); display: block;">Requested Date</span>
                            <strong><%= approval.getRequestedDate() %></strong>
                        </div>
                        <div>
                            <span style="font-size: 11px; color: var(--text-muted); display: block;">Requested Time</span>
                            <strong><%= approval.getRequestedTime() %></strong>
                        </div>
                        <div>
                            <span style="font-size: 11px; color: var(--text-muted); display: block;">Current Status</span>
                            <span class="badge badge-warning"><%= approval.getCurrentStatus() %></span>
                        </div>
                    </div>
                </div>

                <div style="margin-bottom: 24px;">
                    <h3 style="font-size: 15px; font-weight: 700; color: var(--text-heading); margin-bottom: 8px;">Reason for Visit</h3>
                    <div style="background: var(--bg-body); padding: 14px; border-radius: var(--radius-md); font-size: 14px;">
                        <%= approval.getPatientReason() != null && !approval.getPatientReason().isBlank() ? approval.getPatientReason() : "No reason provided." %>
                    </div>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/doctor/approval">
                    <input type="hidden" name="token" value="<%= token %>">
                    <div class="form-group">
                        <label class="form-label">Doctor's Decision Note (Optional)</label>
                        <textarea class="form-control" name="decisionNote" maxlength="1000" rows="3" placeholder="Add optional instructions or reschedule recommendations..."></textarea>
                    </div>

                    <div class="grid-3" style="gap: 12px; margin-top: 24px;">
                        <button type="submit" name="decision" value="APPROVED" class="btn btn-primary" style="background: #10b981; border-color: #10b981; padding: 14px;">
                            ✓ Approve
                        </button>
                        <button type="submit" name="decision" value="REJECTED" class="btn btn-danger" style="padding: 14px;">
                            ✕ Reject
                        </button>
                        <button type="submit" name="decision" value="RESCHEDULE_REQUIRED" class="btn btn-secondary" style="background: #f59e0b; color: white; border-color: #f59e0b; padding: 14px;">
                            📅 Reschedule
                        </button>
                    </div>
                </form>

                <div style="margin-top: 24px; padding: 12px; background: var(--bg-body); border-radius: var(--radius-sm); text-align: center; font-size: 12px; color: var(--text-muted);">
                    🔒 This secure link is single-use and token-protected. No account sign-in required.
                </div>
            <% } %>
        </div>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>