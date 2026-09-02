<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.model.Notification" %>

<%
    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Notifications</title>
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
                <a href="${pageContext.request.contextPath}/patient/dashboard" class="nav-link">Dashboard</a>
                <a href="${pageContext.request.contextPath}/patient/appointments/request" class="nav-link">Book Appointment</a>
                <a href="${pageContext.request.contextPath}/patient/notifications" class="nav-link active">Notifications</a>
                <a href="${pageContext.request.contextPath}/services" class="nav-link">Services</a>
            </div>

            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/patient/dashboard" class="btn btn-secondary btn-sm">← Back to Dashboard</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout btn-sm">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-container">
        <div class="page-header">
            <div class="page-title-group">
                <h1>Notification Inbox</h1>
                <p>Track updates regarding your appointment requests and clinic notifications.</p>
            </div>
        </div>

        <%
            if (notifications == null || notifications.isEmpty()) {
        %>
            <div class="card" style="text-align: center; padding: 60px; color: var(--text-muted);">
                <div style="font-size: 40px; margin-bottom: 12px;">🔔</div>
                <h3>No Notifications Available</h3>
                <p style="margin-top: 8px;">You currently have no new notifications or appointment alerts.</p>
            </div>
        <%
            } else {
                for (Notification notification : notifications) {
                    boolean unread = notification.getReadAt() == null;
        %>
            <div class="card" style="margin-bottom: 16px; border-left: 4px solid <%= unread ? "var(--primary)" : "var(--border-color)" %>;">
                <div style="display: flex; align-items: flex-start; justify-content: space-between; gap: 16px; margin-bottom: 12px;">
                    <div>
                        <h3 style="font-size: 17px; font-weight: 700; color: var(--text-heading);">
                            <%= notification.getSubject() == null ? "DentalCare Notification" : notification.getSubject() %>
                        </h3>
                    </div>
                    <span class="badge badge-info">
                        <%= notification.getNotificationType() %>
                    </span>
                </div>

                <div style="color: var(--text-body); font-size: 14px; line-height: 1.6; margin-bottom: 12px;">
                    <%= notification.getMessage() %>
                </div>

                <div style="display: flex; gap: 16px; font-size: 12px; color: var(--text-muted); border-top: 1px solid var(--border-color); padding-top: 10px;">
                    <% if (notification.getAppointmentId() != null) { %>
                        <span><strong>Appointment ID:</strong> #<%= notification.getAppointmentId() %></span>
                    <% } %>
                    <span><strong>Date:</strong> <%= notification.getCreatedAt() %></span>
                    <span><strong>Status:</strong> <%= notification.getNotificationStatus() %></span>
                </div>
            </div>
        <%
                }
            }
        %>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>