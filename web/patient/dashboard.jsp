<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.model.User" %>
<%@ page import="com.dentalclinic.model.Appointment" %>

<%
    request.setAttribute("activeNav", "dashboard");
    User user = (User) session.getAttribute("authenticatedUser");
    String userName = (user != null && user.getUsername() != null) ? user.getUsername() : "Patient";
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
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

    <jsp:include page="/WEB-INF/includes/patient-header.jsp" />

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
                    <div class="action-desc">Select your preferred dental service, specialist doctor, date, and available time slot.</div>
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

        <!-- MY APPOINTMENTS SECTION -->
        <div class="card" style="margin-bottom: 32px;">
            <div class="card-title" style="display: flex; justify-content: space-between; align-items: center;">
                <span>My Appointments & Requests</span>
                <a href="${pageContext.request.contextPath}/patient/appointments/request" class="btn btn-secondary btn-sm">+ Book New</a>
            </div>

            <% if (appointments == null || appointments.isEmpty()) { %>
                <div style="text-align: center; padding: 36px; color: var(--text-muted);">
                    <div style="font-size: 32px; margin-bottom: 8px;">📅</div>
                    <p>You have no appointment requests or past visits.</p>
                    <a href="${pageContext.request.contextPath}/patient/appointments/request" class="btn btn-primary btn-sm" style="margin-top: 12px;">Request Your First Appointment</a>
                </div>
            <% } else { %>
                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Ref No.</th>
                                <th>Requested Date</th>
                                <th>Requested Time</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (Appointment app : appointments) {
                                    boolean isReschedule = "RESCHEDULE_REQUIRED".equalsIgnoreCase(app.getStatusCode());
                                    boolean isConfirmed = "CONFIRMED".equalsIgnoreCase(app.getStatusCode()) || "DOCTOR_APPROVED".equalsIgnoreCase(app.getStatusCode());
                                    boolean isRejected = "REJECTED".equalsIgnoreCase(app.getStatusCode());
                            %>
                                <tr style="<%= isReschedule ? "background: #fffbeb;" : "" %>">
                                    <td><strong><%= app.getAppointmentNumber() != null ? app.getAppointmentNumber() : "#" + app.getAppointmentId() %></strong></td>
                                    <td><%= app.getRequestedDate() %></td>
                                    <td><%= app.getRequestedTime() != null ? app.getRequestedTime() : "TBD" %></td>
                                    <td>
                                        <span class="badge <%= isConfirmed ? "badge-success" : isReschedule ? "badge-warning" : isRejected ? "badge-danger" : "badge-info" %>">
                                            <%= app.getStatusCode() %>
                                        </span>
                                    </td>
                                    <td>
                                        <% if (isReschedule) { %>
                                            <a href="${pageContext.request.contextPath}/patient/appointments/request?rescheduleId=<%= app.getAppointmentId() %>" class="btn btn-primary btn-sm">
                                                Choose New Time →
                                            </a>
                                        <% } else { %>
                                            <span style="font-size: 12px; color: var(--text-muted);">No action required</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>

        <div class="card">
            <div class="card-title">Patient Portal Quick Guide</div>
            <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 16px;">
                Appointments requested through this portal are reviewed by clinic staff and submitted to attending doctors for approval. If a doctor requests a different appointment time, click <strong>Choose New Time</strong> to pick another available slot.
            </p>
        </div>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>