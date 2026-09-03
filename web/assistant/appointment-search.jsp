<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dentalclinic.model.Appointment" %>
<%@ page import="com.dentalclinic.model.Patient" %>
<%@ page import="com.dentalclinic.model.Service" %>
<%@ page import="com.dentalclinic.model.Doctor" %>

<%
    Appointment app = (Appointment) request.getAttribute("appointment");
    Patient patient = (Patient) request.getAttribute("patient");
    Service service = (Service) request.getAttribute("service");
    Doctor doctor = (Doctor) request.getAttribute("doctor");
    Boolean notFound = (Boolean) request.getAttribute("notFound");
    String query = request.getParameter("query");
%>

<%
    request.setAttribute("activeNav", "search");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Search Appointment</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
    <style>
        .search-layout {
            max-width: 900px;
            margin: 0 auto;
        }
        .search-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--border-color);
            padding: 28px;
            box-shadow: var(--shadow-md);
            margin-bottom: 24px;
        }
        .search-input-row {
            display: flex;
            gap: 12px;
            align-items: center;
        }
        .search-input-row .form-control {
            flex: 1;
            font-size: 15px;
            padding: 14px 18px;
            border-radius: var(--radius-md);
        }
        .search-label {
            font-size: 14px;
            font-weight: 700;
            color: var(--text-heading);
            margin-bottom: 10px;
        }
        .search-hint {
            font-size: 13px;
            color: var(--text-muted);
            margin-top: 8px;
        }
        .result-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--border-color);
            padding: 32px;
            box-shadow: var(--shadow-md);
        }
        .result-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--border-color);
            margin-bottom: 24px;
            flex-wrap: wrap;
            gap: 12px;
        }
        .appt-number-label {
            font-size: 11px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: block;
            margin-bottom: 4px;
        }
        .appt-number-value {
            font-size: 26px;
            font-weight: 800;
            color: var(--primary);
            letter-spacing: -0.5px;
        }
        .result-section {
            background: var(--bg-body);
            border-radius: var(--radius-md);
            padding: 20px;
        }
        .result-section-title {
            font-size: 13px;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 14px;
            display: flex;
            align-items: center;
            gap: 6px;
            padding-bottom: 8px;
            border-bottom: 1px solid var(--border-color);
        }
        .result-field {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            padding: 8px 0;
            border-bottom: 1px solid var(--border-color);
            font-size: 14px;
        }
        .result-field:last-child {
            border-bottom: none;
        }
        .result-field-label {
            color: var(--text-muted);
            font-weight: 600;
            font-size: 13px;
        }
        .result-field-value {
            color: var(--text-heading);
            font-weight: 700;
            text-align: right;
        }
        .reason-section {
            background: var(--bg-body);
            border-radius: var(--radius-md);
            padding: 16px;
            margin: 20px 0;
        }
        .reason-title {
            font-size: 12px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }
        .result-actions {
            display: flex;
            justify-content: flex-end;
            padding-top: 20px;
            border-top: 1px solid var(--border-color);
        }
        .not-found-card {
            background: #fff1f2;
            border: 1px solid #fecdd3;
            border-radius: var(--radius-lg);
            padding: 40px;
            text-align: center;
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/includes/assistant-header.jsp" />

    <main class="main-container">
        <div class="search-layout">

            <div class="page-header">
                <div class="page-title-group">
                    <h1>Appointment Search</h1>
                    <p>Look up patient appointments by appointment number or ID.</p>
                </div>
            </div>

            <!-- Search Box -->
            <div class="search-card">
                <div class="search-label">Search by Appointment Number</div>
                <form method="get" action="${pageContext.request.contextPath}/assistant/appointments/search">
                    <div class="search-input-row">
                        <input class="form-control" type="text" name="query"
                               value="<%= query != null ? query : "" %>"
                               placeholder="e.g. APT-2026-000001"
                               required>
                        <button type="submit" class="btn btn-primary">🔍 Search</button>
                    </div>
                    <div class="search-hint">Enter the unique appointment number (e.g. <code>APT-2026-000001</code>) or numeric ID.</div>
                </form>
            </div>

            <!-- Not Found -->
            <% if (notFound != null && notFound) { %>
                <div class="not-found-card">
                    <div style="font-size: 36px; margin-bottom: 12px;">🔍</div>
                    <h3 style="font-size: 18px; font-weight: 700; color: #be123c; margin-bottom: 8px;">No Appointment Found</h3>
                    <p style="color: #e11d48; font-size: 14px;">
                        No appointment matched <strong>"<%= query %>"</strong>. Please verify the appointment number and try again.
                    </p>
                </div>
            <% } %>

            <!-- Search Result -->
            <% if (app != null) { %>
                <div class="result-card">
                    <div class="result-header">
                        <div>
                            <span class="appt-number-label">Appointment Number</span>
                            <div class="appt-number-value">
                                <%= app.getAppointmentNumber() != null ? app.getAppointmentNumber() : "APT-ID-" + app.getAppointmentId() %>
                            </div>
                        </div>
                        <span class="badge badge-info" style="font-size: 13px; padding: 7px 16px;">
                            <%= app.getStatusCode() %>
                        </span>
                    </div>

                    <div class="grid-2" style="gap: 20px; margin-bottom: 20px;">
                        <!-- Patient Info -->
                        <div class="result-section">
                            <div class="result-section-title">👤 Patient Information</div>
                            <div class="result-field">
                                <span class="result-field-label">Patient ID</span>
                                <span class="result-field-value">#<%= app.getPatientId() %></span>
                            </div>
                            <div class="result-field">
                                <span class="result-field-label">Full Name</span>
                                <span class="result-field-value">
                                    <%= patient != null && patient.getEmergencyContactName() != null ? patient.getEmergencyContactName() : "Registered Patient" %>
                                </span>
                            </div>
                            <div class="result-field">
                                <span class="result-field-label">Address</span>
                                <span class="result-field-value">
                                    <%= patient != null && patient.getAddress() != null ? patient.getAddress() : "N/A" %>
                                </span>
                            </div>
                            <div class="result-field">
                                <span class="result-field-label">Contact Phone</span>
                                <span class="result-field-value">
                                    <%= patient != null && patient.getEmergencyContactPhone() != null ? patient.getEmergencyContactPhone() : "N/A" %>
                                </span>
                            </div>
                        </div>

                        <!-- Treatment Info -->
                        <div class="result-section">
                            <div class="result-section-title">🦷 Treatment & Dentist</div>
                            <div class="result-field">
                                <span class="result-field-label">Treatment / Service</span>
                                <span class="result-field-value">
                                    <%= service != null ? service.getServiceName() : "Service #" + app.getServiceId() %>
                                </span>
                            </div>
                            <div class="result-field">
                                <span class="result-field-label">Standard Price</span>
                                <span class="result-field-value">
                                    LKR <%= service != null ? String.format("%,.2f", service.getStandardPrice()) : "N/A" %>
                                </span>
                            </div>
                            <div class="result-field">
                                <span class="result-field-label">Assigned Dentist</span>
                                <span class="result-field-value">
                                    <%= doctor != null ? "Dr. " + doctor.getFirstName() + " " + doctor.getLastName() : "Not Assigned" %>
                                </span>
                            </div>
                            <div class="result-field">
                                <span class="result-field-label">Requested Date & Time</span>
                                <span class="result-field-value">
                                    <%= app.getRequestedDate() %> at <%= app.getRequestedTime() != null ? app.getRequestedTime() : "Unspecified" %>
                                </span>
                            </div>
                        </div>
                    </div>

                    <% if (app.getPatientReason() != null && !app.getPatientReason().isBlank()) { %>
                        <div class="reason-section">
                            <div class="reason-title">📝 Reason for Visit / Symptoms</div>
                            <p style="font-size: 14px; color: var(--text-body); line-height: 1.6;"><%= app.getPatientReason() %></p>
                        </div>
                    <% } %>

                    <div class="result-actions">
                        <a href="${pageContext.request.contextPath}/assistant/appointments?action=review&id=<%= app.getAppointmentId() %>"
                           class="btn btn-primary">
                            Review / Action Appointment →
                        </a>
                    </div>
                </div>
            <% } %>

        </div>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>
