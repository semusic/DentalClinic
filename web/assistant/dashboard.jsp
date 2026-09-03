<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.model.User" %>
<%@ page import="com.dentalclinic.model.Notification" %>
<%
    request.setAttribute("activeNav", "dashboard");
    User user = (User) session.getAttribute("authenticatedUser");
    String userName = (user != null && user.getUsername() != null) ? user.getUsername() : "Assistant";
    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
    Integer pendingCount = (Integer) request.getAttribute("pendingCount");
    Integer confirmedCount = (Integer) request.getAttribute("confirmedCount");
    if (pendingCount == null) pendingCount = 0;
    if (confirmedCount == null) confirmedCount = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Assistant Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
    <style>
        .welcome-banner {
            background: linear-gradient(135deg, #0284c7 0%, #0369a1 60%, #075985 100%);
            border-radius: var(--radius-lg);
            padding: 36px 40px;
            color: #ffffff;
            margin-bottom: 24px;
            position: relative;
            overflow: hidden;
            box-shadow: 0 8px 32px rgba(2, 132, 199, 0.3);
        }
        .welcome-banner::before {
            content: '';
            position: absolute;
            top: -40px; right: -40px;
            width: 200px; height: 200px;
            background: rgba(255,255,255,0.06);
            border-radius: 50%;
        }
        .welcome-banner::after {
            content: '';
            position: absolute;
            bottom: -60px; right: 80px;
            width: 140px; height: 140px;
            background: rgba(255,255,255,0.04);
            border-radius: 50%;
        }
        .welcome-label {
            font-size: 13px;
            font-weight: 600;
            opacity: 0.8;
            margin-bottom: 4px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .welcome-name {
            font-size: 30px;
            font-weight: 800;
            letter-spacing: -0.5px;
            margin-bottom: 8px;
        }
        .welcome-sub {
            font-size: 14px;
            opacity: 0.75;
        }
        .notif-alert-box {
            background: linear-gradient(135deg, #ecfdf5, #d1fae5);
            border: 1px solid #6ee7b7;
            border-left: 5px solid #10b981;
            border-radius: var(--radius-lg);
            padding: 20px 24px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
        }
        .quick-action-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--border-color);
            padding: 28px;
            text-decoration: none;
            color: inherit;
            transition: var(--transition);
            box-shadow: var(--shadow-md);
            display: flex;
            flex-direction: column;
            gap: 14px;
            position: relative;
        }
        .quick-action-card:hover {
            border-color: var(--primary-border);
            box-shadow: var(--shadow-lg);
            transform: translateY(-3px);
        }
        .qa-icon {
            width: 52px;
            height: 52px;
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
        }
        .qa-title {
            font-size: 18px;
            font-weight: 800;
            color: var(--text-heading);
            letter-spacing: -0.3px;
        }
        .qa-desc {
            font-size: 14px;
            color: var(--text-muted);
            line-height: 1.55;
        }
        .qa-footer {
            margin-top: auto;
            font-size: 13px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: gap 0.2s;
        }
        .quick-action-card:hover .qa-footer {
            gap: 10px;
        }
        .stat-badge {
            position: absolute;
            top: 24px;
            right: 24px;
            font-size: 13px;
            font-weight: 800;
            padding: 4px 12px;
            border-radius: 20px;
        }
        .workflow-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--border-color);
            padding: 28px;
            box-shadow: var(--shadow-md);
        }
        .workflow-step {
            display: flex;
            gap: 16px;
            padding: 16px 0;
            border-bottom: 1px solid var(--border-color);
        }
        .workflow-step:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }
        .workflow-step:first-child {
            padding-top: 0;
        }
        .step-number {
            width: 32px;
            height: 32px;
            background: var(--primary-light);
            color: var(--primary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 14px;
            flex-shrink: 0;
        }
        .step-content strong {
            display: block;
            font-size: 14px;
            font-weight: 700;
            color: var(--text-heading);
            margin-bottom: 3px;
        }
        .step-content p {
            font-size: 13px;
            color: var(--text-muted);
            line-height: 1.5;
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/includes/assistant-header.jsp" />

    <main class="main-container">

        <div class="welcome-banner">
            <div class="welcome-label">Assistant Portal</div>
            <div class="welcome-name">Welcome, <%= userName %> 👋</div>
            <div class="welcome-sub">Manage patient check-ins, appointment reviews, and visit workflows.</div>
        </div>

        <% if (notifications != null && !notifications.isEmpty()) {
            Notification latest = notifications.get(0);
        %>
            <div class="notif-alert-box">
                <div>
                    <div style="font-size: 14px; font-weight: 800; color: #065f46; margin-bottom: 2px;">
                        🔔 Latest Notification: <%= latest.getSubject() != null ? latest.getSubject() : "Appointment Alert" %>
                    </div>
                    <div style="font-size: 13px; color: #047857;">
                        <%= latest.getMessage() %>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/assistant/notifications" class="btn btn-primary btn-sm" style="white-space: nowrap;">
                    View All Notifications (<%= notifications.size() %>) →
                </a>
            </div>
        <% } %>

        <div class="grid-2" style="margin-bottom: 32px;">
            <a href="${pageContext.request.contextPath}/assistant/appointments" class="quick-action-card">
                <span class="stat-badge" style="background: #e0f2fe; color: #0284c7;"><%= pendingCount %> pending</span>
                <div class="qa-icon" style="background: #e0f2fe; color: #0284c7;">📋</div>
                <div>
                    <div class="qa-title">Appointment Request Queue</div>
                    <div class="qa-desc" style="margin-top: 6px;">Review submitted patient requests, select qualified doctors, assign time slots, and generate secure approval links.</div>
                </div>
                <div class="qa-footer" style="color: #0284c7;">
                    <span>Manage Requests</span> <span>→</span>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/assistant/visits" class="quick-action-card">
                <span class="stat-badge" style="background: #f0fdf4; color: #16a34a;"><%= confirmedCount %> confirmed</span>
                <div class="qa-icon" style="background: #f0fdf4; color: #16a34a;">🏥</div>
                <div>
                    <div class="qa-title">Patient Visits & Check-in</div>
                    <div class="qa-desc" style="margin-top: 6px;">Check in arriving patients, manage active consultations, record performed services, and track visit status.</div>
                </div>
                <div class="qa-footer" style="color: #16a34a;">
                    <span>Manage Visits</span> <span>→</span>
                </div>
            </a>
        </div>

        <div class="workflow-card">
            <div class="card-title" style="margin-bottom: 4px;">Assistant Workflow Guide</div>
            <p style="color: var(--text-muted); font-size: 13px; margin-bottom: 20px;">Follow these steps to process patient appointments efficiently.</p>

            <div class="workflow-step">
                <div class="step-number">1</div>
                <div class="step-content">
                    <strong>Request Review</strong>
                    <p>Validate patient request details, assign a qualified doctor, and send a one-time approval link to the doctor.</p>
                </div>
            </div>

            <div class="workflow-step">
                <div class="step-number">2</div>
                <div class="step-content">
                    <strong>Patient Check-in</strong>
                    <p>When patients arrive at reception, open their visit under <strong>Visits & Check-in</strong> and register their arrival.</p>
                </div>
            </div>

            <div class="workflow-step">
                <div class="step-number">3</div>
                <div class="step-content">
                    <strong>Clinical Documentation</strong>
                    <p>Record performed dental services, medications prescribed, and clinical notes before finalizing and closing the visit.</p>
                </div>
            </div>

            <div style="margin-top: 24px; display: flex; gap: 12px; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/assistant/appointments" class="btn btn-primary btn-sm">Review Appointment Queue</a>
                <a href="${pageContext.request.contextPath}/assistant/visits" class="btn btn-secondary btn-sm">View Active Visits</a>
                <a href="${pageContext.request.contextPath}/assistant/notifications" class="btn btn-secondary btn-sm">View Notifications 🔔</a>
            </div>
        </div>

    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>