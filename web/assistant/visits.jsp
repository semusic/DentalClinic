<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="com.dentalclinic.dto.AssistantVisitDTO" %>
<%@ page import="com.dentalclinic.model.PatientVisit" %>

<%
    List<AssistantVisitDTO> appointments = (List<AssistantVisitDTO>) request.getAttribute("appointments");
    LocalDate selectedDate = (LocalDate) request.getAttribute("selectedDate");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Patient Visits</title>
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
                <a href="${pageContext.request.contextPath}/assistant/appointments" class="nav-link">Appointment Requests</a>
                <a href="${pageContext.request.contextPath}/assistant/visits" class="nav-link active">Visits & Check-in</a>
                <a href="${pageContext.request.contextPath}/services" class="nav-link">Services</a>
            </div>

            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/assistant/dashboard" class="btn btn-secondary btn-sm">← Back to Dashboard</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout btn-sm">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-container">
        <div class="page-header">
            <div class="page-title-group">
                <h1>Patient Clinic Visits</h1>
                <p>Track scheduled appointments, check in patients, and manage consultation records.</p>
            </div>

            <form method="get" action="${pageContext.request.contextPath}/assistant/visits" style="display: flex; gap: 8px; align-items: center;">
                <input class="form-control" type="date" name="date" value="<%= selectedDate %>" style="width: auto;">
                <button class="btn btn-primary" type="submit">Filter Date</button>
            </form>
        </div>

        <% if (error != null && !error.isBlank()) { %>
            <div class="alert alert-error">
                <%= error %>
            </div>
        <% } %>

        <div style="margin-bottom: 20px; color: var(--text-muted); font-size: 14px;">
            Showing appointments for <strong><%= selectedDate %></strong> — <%= appointments == null ? 0 : appointments.size() %> total records
        </div>

        <% if (appointments == null || appointments.isEmpty()) { %>
            <div class="card" style="text-align: center; padding: 60px; color: var(--text-muted);">
                <h3>No Appointments Scheduled</h3>
                <p style="margin-top: 8px;">There are no confirmed appointments on this date.</p>
            </div>
        <% } else { %>
            <div class="grid-2">
                <% for (AssistantVisitDTO appointment : appointments) {
                    PatientVisit visit = appointment.getPatientVisit();
                    boolean hasVisit = visit != null;
                    boolean completed = hasVisit && visit.getConsultationCompletedAt() != null;
                    boolean checkedIn = hasVisit && visit.getCheckedInAt() != null;
                    boolean started = hasVisit && visit.getConsultationStartedAt() != null;
                %>
                    <div class="card card-hover" style="display: flex; flex-direction: column; justify-content: space-between;">
                        <div>
                            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 16px;">
                                <div>
                                    <h3 style="font-size: 20px; font-weight: 800; color: var(--text-heading);"><%= appointment.getPatientName() %></h3>
                                    <span style="font-size: 12px; color: var(--text-muted);">Appointment #<%= appointment.getAppointmentId() %></span>
                                </div>
                                <span class="badge badge-info"><%= appointment.getAppointmentStatus() %></span>
                            </div>

                            <div class="grid-2" style="gap: 12px; margin-bottom: 16px; background: var(--bg-body); padding: 14px; border-radius: var(--radius-md);">
                                <div>
                                    <span style="font-size: 11px; color: var(--text-muted); display: block;">Service</span>
                                    <strong style="font-size: 13px;"><%= appointment.getServiceName() %></strong>
                                </div>
                                <div>
                                    <span style="font-size: 11px; color: var(--text-muted); display: block;">Doctor</span>
                                    <strong style="font-size: 13px;"><%= appointment.getDoctorName() != null ? appointment.getDoctorName() : "Unassigned" %></strong>
                                </div>
                                <div>
                                    <span style="font-size: 11px; color: var(--text-muted); display: block;">Date</span>
                                    <strong style="font-size: 13px;"><%= appointment.getAppointmentDate() %></strong>
                                </div>
                                <div>
                                    <span style="font-size: 11px; color: var(--text-muted); display: block;">Time</span>
                                    <strong style="font-size: 13px;"><%= appointment.getAppointmentTime() != null ? appointment.getAppointmentTime() : "Not set" %></strong>
                                </div>
                            </div>

                            <div style="padding: 12px; border-radius: var(--radius-md); background: #ffffff; border: 1px solid var(--border-color); font-size: 13px; margin-bottom: 16px;">
                                <span style="font-size: 11px; color: var(--text-muted); display: block;">VISIT STATUS</span>
                                <strong style="color: var(--text-heading);">
                                    <% if (!hasVisit) { %>
                                        Visit record not created yet
                                    <% } else if (completed) { %>
                                        ✅ Consultation Completed
                                    <% } else if (started) { %>
                                        🩺 Consultation in Progress
                                    <% } else if (checkedIn) { %>
                                        ⌛ Patient Checked In (Waiting)
                                    <% } else { %>
                                        Visit Created — Awaiting Patient Arrival
                                    <% } %>
                                </strong>
                            </div>
                        </div>

                        <div style="display: flex; justify-content: flex-end; border-top: 1px solid var(--border-color); padding-top: 14px;">
                            <% if (!hasVisit) { %>
                                <form method="post" action="${pageContext.request.contextPath}/assistant/visits">
                                    <input type="hidden" name="action" value="createVisit">
                                    <input type="hidden" name="appointmentId" value="<%= appointment.getAppointmentId() %>">
                                    <button type="submit" class="btn btn-primary btn-sm">Create Visit Record</button>
                                </form>
                            <% } else { %>
                                <a href="${pageContext.request.contextPath}/assistant/visits?visitId=<%= visit.getVisitId() %>" class="btn btn-secondary btn-sm">
                                    Open Visit Record →
                                </a>
                            <% } %>
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