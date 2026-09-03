<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dentalclinic.model.User" %>
<%
    request.setAttribute("activeNav", "dashboard");
    User user = (User) session.getAttribute("authenticatedUser");
    String userName = (user != null && user.getFirstName() != null) ? user.getFirstName() + " " + user.getLastName() : "Administrator";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
</head>
<body>

    <jsp:include page="/WEB-INF/includes/admin-header.jsp" />

    <main class="main-container">
        <div class="page-header">
            <div class="page-title-group">
                <h1>Administrator Dashboard</h1>
                <p>Welcome back, <strong><%= userName %></strong>. Operational clinic administration portal.</p>
            </div>
        </div>

        <div class="grid-2" style="margin-bottom: 32px; gap: 24px;">
            <a href="${pageContext.request.contextPath}/admin/doctors" class="action-card">
                <div>
                    <div class="action-icon" style="background: #eff6ff; color: #2563eb;">👨‍⚕️</div>
                    <div class="action-title">Doctor Management & Directory</div>
                    <div class="action-desc">Register new attending doctors, edit specialization details, assign procedure competencies, and toggle active status.</div>
                </div>
                <div class="action-footer" style="color: #2563eb;">
                    <span>Manage Doctors</span> →
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/admin/doctor-schedules" class="action-card">
                <div>
                    <div class="action-icon" style="background: #fff7ed; color: #ea580c;">📅</div>
                    <div class="action-title">Doctor Working Schedules</div>
                    <div class="action-desc">Configure weekly attending shift hours, day of week availability, shift start/end times, and appointment capacities.</div>
                </div>
                <div class="action-footer" style="color: #ea580c;">
                    <span>Manage Schedules</span> →
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/admin/services" class="action-card">
                <div>
                    <div class="action-icon" style="background: #faf5ff; color: #9333ea;">🛠️</div>
                    <div class="action-title">Service Catalog & Pricing</div>
                    <div class="action-desc">Add new dental services, adjust standard procedure prices, modify procedure durations, and toggle active availability.</div>
                </div>
                <div class="action-footer" style="color: #9333ea;">
                    <span>Manage Service Catalog</span> →
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/admin/reports" class="action-card">
                <div>
                    <div class="action-icon" style="background: #f0fdf4; color: #16a34a;">📊</div>
                    <div class="action-title">Executive Management Reports</div>
                    <div class="action-desc">Generate daily appointment summaries, completed treatment audits, financial revenue statistics, and service demand metrics.</div>
                </div>
                <div class="action-footer" style="color: #16a34a;">
                    <span>View Management Reports</span> →
                </div>
            </a>
        </div>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>