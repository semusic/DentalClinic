<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="com.dentalclinic.dto.AssistantVisitDTO" %>
<%@ page import="com.dentalclinic.model.PatientVisit" %>

<%
    List<AssistantVisitDTO> appointments = (List<AssistantVisitDTO>) request.getAttribute("appointments");
    LocalDate selectedDate = (LocalDate) request.getAttribute("selectedDate");
    Boolean showAllObj = (Boolean) request.getAttribute("showAll");
    boolean showAll = showAllObj != null && showAllObj;
    String error = (String) request.getAttribute("error");
%>

<%
    request.setAttribute("activeNav", "visits");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Patient Visits</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
    <style>
        .visit-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--border-color);
            padding: 24px;
            box-shadow: var(--shadow-md);
            transition: var(--transition);
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        .visit-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary-border);
        }
        .visit-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 12px;
        }
        .visit-patient-name {
            font-size: 20px;
            font-weight: 800;
            color: var(--text-heading);
            letter-spacing: -0.3px;
        }
        .visit-appt-id {
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 2px;
        }
        .visit-info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            background: var(--bg-body);
            padding: 14px;
            border-radius: var(--radius-md);
        }
        .visit-info-item span {
            font-size: 11px;
            color: var(--text-muted);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            display: block;
        }
        .visit-info-item strong {
            font-size: 13px;
            color: var(--text-heading);
        }
        .visit-status-box {
            background: #f8fafc;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-sm);
            padding: 12px 14px;
        }
        .visit-status-label {
            font-size: 10px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: block;
            margin-bottom: 4px;
        }
        .visit-status-value {
            font-size: 14px;
            font-weight: 700;
            color: var(--text-heading);
        }
        .visit-footer {
            display: flex;
            justify-content: flex-end;
            padding-top: 14px;
            border-top: 1px solid var(--border-color);
        }
        .date-filter-bar {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }
        .date-results-bar {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 24px;
            flex-wrap: wrap;
        }
        .date-pill {
            background: var(--primary-light);
            color: var(--primary);
            font-size: 12px;
            font-weight: 700;
            padding: 4px 12px;
            border-radius: 20px;
            border: 1px solid var(--primary-border);
        }
        .count-pill {
            background: #f1f5f9;
            color: var(--text-muted);
            font-size: 12px;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 20px;
        }
        .empty-visits {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 80px 40px;
            text-align: center;
            box-shadow: var(--shadow-sm);
        }
        .empty-visits-icon {
            width: 64px;
            height: 64px;
            background: #f0fdf4;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            margin: 0 auto 16px;
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/includes/assistant-header.jsp" />

    <main class="main-container">
        <div class="page-header">
            <div class="page-title-group">
                <h1>Patient Clinic Visits</h1>
                <p>Track scheduled appointments, check in patients, and manage consultation records.</p>
            </div>

            <div class="date-filter-bar">
                <form method="get" action="${pageContext.request.contextPath}/assistant/visits"
                      style="display: flex; gap: 8px; align-items: center;">
                    <input class="form-control" type="date" name="date" value="<%= selectedDate != null ? selectedDate : "" %>" style="width: auto;">
                    <button class="btn btn-primary btn-sm" type="submit">Filter Date</button>
                    <a href="${pageContext.request.contextPath}/assistant/visits?date=all" class="btn btn-secondary btn-sm" style="white-space: nowrap;">
                        📋 Show All Dates
                    </a>
                </form>
            </div>
        </div>

        <% if (error != null && !error.isBlank()) { %>
            <div class="alert alert-error">
                <%= error %>
            </div>
        <% } %>

        <div class="date-results-bar">
            <span class="date-pill">
                📅 <%= showAll ? "All Dates" : (selectedDate != null ? selectedDate.toString() : "All Confirmed") %>
            </span>
            <span class="count-pill">
                <%= appointments == null ? 0 : appointments.size() %> appointment<%= appointments == null || appointments.size() == 1 ? "" : "s" %>
            </span>
        </div>

        <% if (appointments == null || appointments.isEmpty()) { %>
            <div class="empty-visits">
                <div class="empty-visits-icon">🏥</div>
                <h3 style="font-size: 20px; font-weight: 700; color: var(--text-heading); margin-bottom: 8px;">No Appointments Scheduled</h3>
                <p style="color: var(--text-muted); font-size: 14px;">There are no confirmed appointments on this date. Click <strong>Show All Dates</strong> above to view all confirmed appointments.</p>
            </div>
        <% } else { %>
            <div class="grid-2">
                <% for (AssistantVisitDTO appointment : appointments) {
                    PatientVisit visit = appointment.getPatientVisit();
                    boolean hasVisit = visit != null;
                    boolean completed = hasVisit && visit.getConsultationCompletedAt() != null;
                    boolean checkedIn = hasVisit && visit.getCheckedInAt() != null;
                    boolean started = hasVisit && visit.getConsultationStartedAt() != null;

                    String visitStatusText;
                    String visitStatusIcon;
                    if (!hasVisit) {
                        visitStatusText = "Visit Record Not Created";
                        visitStatusIcon = "⚪";
                    } else if (completed) {
                        visitStatusText = "Consultation Completed";
                        visitStatusIcon = "✅";
                    } else if (started) {
                        visitStatusText = "Consultation in Progress";
                        visitStatusIcon = "🩺";
                    } else if (checkedIn) {
                        visitStatusText = "Patient Checked In — Waiting";
                        visitStatusIcon = "⌛";
                    } else {
                        visitStatusText = "Visit Created — Awaiting Arrival";
                        visitStatusIcon = "🕐";
                    }
                %>
                    <div class="visit-card">
                        <div class="visit-header">
                            <div>
                                <div class="visit-patient-name"><%= appointment.getPatientName() %></div>
                                <div class="visit-appt-id">Appointment #<%= appointment.getAppointmentId() %></div>
                            </div>
                            <span class="badge badge-info"><%= appointment.getAppointmentStatus() %></span>
                        </div>

                        <div class="visit-info-grid">
                            <div class="visit-info-item">
                                <span>Service</span>
                                <strong><%= appointment.getServiceName() %></strong>
                            </div>
                            <div class="visit-info-item">
                                <span>Doctor</span>
                                <strong><%= appointment.getDoctorName() != null ? appointment.getDoctorName() : "Unassigned" %></strong>
                            </div>
                            <div class="visit-info-item">
                                <span>Date</span>
                                <strong><%= appointment.getAppointmentDate() %></strong>
                            </div>
                            <div class="visit-info-item">
                                <span>Time</span>
                                <strong><%= appointment.getAppointmentTime() != null ? appointment.getAppointmentTime() : "Not set" %></strong>
                            </div>
                        </div>

                        <div class="visit-status-box">
                            <span class="visit-status-label">Visit Status</span>
                            <span class="visit-status-value"><%= visitStatusIcon %> <%= visitStatusText %></span>
                        </div>

                        <div class="visit-footer">
                            <% if (!hasVisit) { %>
                                <form method="post" action="${pageContext.request.contextPath}/assistant/visits">
                                    <input type="hidden" name="action" value="createVisit">
                                    <input type="hidden" name="appointmentId" value="<%= appointment.getAppointmentId() %>">
                                    <button type="submit" class="btn btn-primary btn-sm">Create Visit Record</button>
                                </form>
                            <% } else { %>
                                <a href="${pageContext.request.contextPath}/assistant/visits?visitId=<%= visit.getVisitId() %>"
                                   class="btn btn-secondary btn-sm">
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