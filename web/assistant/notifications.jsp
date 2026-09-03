<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.model.Notification" %>

<%
    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
    String filter = request.getParameter("filter");
    boolean showAll = "all".equalsIgnoreCase(filter);
%>

<%
    request.setAttribute("activeNav", "notifications");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Assistant Notifications</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
    <style>
        .notifications-layout {
            max-width: 860px;
            margin: 0 auto;
        }
        .filter-tabs-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
            flex-wrap: wrap;
            gap: 12px;
        }
        .tab-btn-group {
            display: flex;
            gap: 8px;
            background: #f1f5f9;
            padding: 4px;
            border-radius: var(--radius-md);
        }
        .tab-btn {
            padding: 6px 16px;
            font-size: 13px;
            font-weight: 700;
            border-radius: var(--radius-sm);
            text-decoration: none;
            color: var(--text-muted);
            transition: var(--transition);
        }
        .tab-btn.active {
            background: #ffffff;
            color: var(--primary);
            box-shadow: var(--shadow-sm);
        }
        .notif-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--border-color);
            padding: 24px;
            box-shadow: var(--shadow-md);
            margin-bottom: 16px;
            transition: var(--transition);
        }
        .notif-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }
        .notif-card.unread {
            border-left: 5px solid var(--primary);
            background: #faf5ff;
        }
        .notif-card.read {
            border-left: 5px solid #cbd5e1;
            opacity: 0.85;
        }
        .notif-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 12px;
        }
        .notif-title {
            font-size: 17px;
            font-weight: 800;
            color: var(--text-heading);
            letter-spacing: -0.3px;
        }
        .notif-body {
            color: var(--text-body);
            font-size: 14px;
            line-height: 1.6;
            background: #ffffff;
            padding: 14px 16px;
            border-radius: var(--radius-md);
            border: 1px solid var(--border-color);
            margin-bottom: 14px;
        }
        .notif-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 12px;
            color: var(--text-muted);
            padding-top: 10px;
            border-top: 1px solid var(--border-color);
            flex-wrap: wrap;
            gap: 10px;
        }
        .empty-state {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 70px 40px;
            text-align: center;
            box-shadow: var(--shadow-sm);
        }
        .unread-badge-pill {
            background: var(--primary);
            color: #ffffff;
            font-size: 11px;
            font-weight: 700;
            padding: 2px 8px;
            border-radius: 12px;
            margin-left: 4px;
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/includes/assistant-header.jsp" />

    <main class="main-container">
        <div class="notifications-layout">
            <div class="page-header">
                <div class="page-title-group">
                    <h1>Assistant Notifications</h1>
                    <p>Live alerts regarding doctor approvals, appointment reschedules, and clinic updates.</p>
                </div>
            </div>

            <%
                int unreadCount = 0;
                if (notifications != null) {
                    for (Notification n : notifications) {
                        if (n.getReadAt() == null) unreadCount++;
                    }
                }
            %>

            <div class="filter-tabs-bar">
                <div class="tab-btn-group">
                    <a href="${pageContext.request.contextPath}/assistant/notifications"
                       class="tab-btn <%= !showAll ? "active" : "" %>">
                       Unread Inbox <% if (unreadCount > 0) { %><span class="unread-badge-pill"><%= unreadCount %></span><% } %>
                    </a>
                    <a href="${pageContext.request.contextPath}/assistant/notifications?filter=all"
                       class="tab-btn <%= showAll ? "active" : "" %>">
                       All History
                    </a>
                </div>

                <% if (unreadCount > 0) { %>
                    <a href="${pageContext.request.contextPath}/assistant/notifications?markAllRead=true"
                       class="btn btn-secondary btn-sm">
                       ✓ Mark All as Read
                    </a>
                <% } %>
            </div>

            <%
                boolean hasDisplayedItems = false;
                if (notifications != null && !notifications.isEmpty()) {
                    for (Notification n : notifications) {
                        boolean isUnread = n.getReadAt() == null;
                        if (!showAll && !isUnread) continue; // Skip read items in unread tab
                        hasDisplayedItems = true;

                        String badgeClass = "badge-info";
                        if ("DOCTOR_APPROVED".equalsIgnoreCase(n.getNotificationType()) || "APPOINTMENT_CONFIRMED".equalsIgnoreCase(n.getNotificationType())) {
                            badgeClass = "badge-success";
                        } else if ("RESCHEDULE_REQUIRED".equalsIgnoreCase(n.getNotificationType()) || "APPOINTMENT_REJECTED".equalsIgnoreCase(n.getNotificationType())) {
                            badgeClass = "badge-warning";
                        }
            %>
                <div class="notif-card <%= isUnread ? "unread" : "read" %>">
                    <div class="notif-header">
                        <div>
                            <div class="notif-title">
                                <%= isUnread ? "🔴 " : "" %><%= n.getSubject() != null ? n.getSubject() : "Clinic Notification" %>
                            </div>
                        </div>
                        <span class="badge <%= badgeClass %>"><%= n.getNotificationType() %></span>
                    </div>

                    <div class="notif-body">
                        <%= n.getMessage() %>
                    </div>

                    <div class="notif-footer">
                        <div>
                            <% if (n.getAppointmentId() != null) { %>
                                <strong>Appointment #<%= n.getAppointmentId() %></strong> &nbsp;•&nbsp;
                            <% } %>
                            <span><%= n.getCreatedAt() %></span>
                        </div>
                        <% if (n.getAppointmentId() != null) { %>
                            <a href="${pageContext.request.contextPath}/assistant/notifications?readId=<%= n.getNotificationId() %>&appointmentId=<%= n.getAppointmentId() %>"
                               class="btn btn-primary btn-sm">
                                Open Visit / Detail →
                            </a>
                        <% } %>
                    </div>
                </div>
            <%
                    }
                }
                if (!hasDisplayedItems) {
            %>
                <div class="empty-state">
                    <div style="font-size: 44px; margin-bottom: 12px;">✅</div>
                    <h3 style="font-size: 20px; font-weight: 700; color: var(--text-heading); margin-bottom: 8px;">
                        <%= showAll ? "No Notification History" : "Inbox Zero! No Unread Alerts" %>
                    </h3>
                    <p style="color: var(--text-muted); font-size: 14px;">
                        <%= showAll ? "You have no notification records." : "All doctor approval and clinic notifications have been reviewed." %>
                    </p>
                </div>
            <% } %>
        </div>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>
