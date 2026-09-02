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

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Search Appointment</title>
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
                <a href="${pageContext.request.contextPath}/assistant/appointments" class="nav-link">Requests</a>
                <a href="${pageContext.request.contextPath}/assistant/visits" class="nav-link">Visits</a>
                <a href="${pageContext.request.contextPath}/assistant/appointments/search" class="nav-link active">Search</a>
                <a href="${pageContext.request.contextPath}/help" class="nav-link">Help Guide</a>
            </div>

            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/assistant/dashboard" class="btn btn-secondary btn-sm">← Back</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout btn-sm">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-container">
        <div class="page-header">
            <div class="page-title-group">
                <h1>Appointment Search</h1>
                <p>Lookup appointments using unique appointment numbers (e.g. <code>APT-2026-000001</code>) or numeric ID.</p>
            </div>
        </div>

        <div class="card" style="margin-bottom: 28px; max-width: 650px;">
            <form method="get" action="${pageContext.request.contextPath}/assistant/appointments/search" style="display: flex; gap: 12px;">
                <input class="form-control" type="text" name="query" value="<%= query != null ? query : "" %>" placeholder="Enter Appointment Number (APT-2026-000001)..." required style="flex: 1;">
                <button type="submit" class="btn btn-primary">🔍 Search</button>
            </form>
        </div>

        <% if (notFound != null && notFound) { %>
            <div class="alert alert-error">
                ✕ No appointment found matching "<strong><%= query %></strong>". Please verify the appointment number and try again.
            </div>
        <% } %>

        <% if (app != null) { %>
            <div class="card" style="max-width: 850px; padding: 32px;">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 2px solid var(--border-color); padding-bottom: 16px; margin-bottom: 20px;">
                    <div>
                        <span style="font-size: 12px; color: var(--text-muted); display: block;">UNIQUE APPOINTMENT NUMBER</span>
                        <h2 style="font-size: 24px; font-weight: 800; color: var(--primary);"><%= app.getAppointmentNumber() != null ? app.getAppointmentNumber() : "APT-ID-" + app.getAppointmentId() %></h2>
                    </div>
                    <div>
                        <span class="badge badge-info" style="font-size: 13px;"><%= app.getStatusCode() %></span>
                    </div>
                </div>

                <div class="grid-2" style="margin-bottom: 24px;">
                    <!-- PATIENT DETAILS -->
                    <div class="card" style="background: var(--bg-body); border: none;">
                        <h3 class="card-title" style="color: var(--primary); font-size: 15px;">👤 Patient Information</h3>
                        <div style="font-size: 14px; line-height: 1.8;">
                            <div><strong>Patient ID:</strong> #<%= app.getPatientId() %></div>
                            <div><strong>Full Name:</strong> <%= patient != null ? patient.getEmergencyContactName() : "Registered Patient" %></div>
                            <div><strong>Address:</strong> <%= patient != null && patient.getAddress() != null ? patient.getAddress() : "N/A" %></div>
                            <div><strong>Contact Phone:</strong> <%= patient != null && patient.getEmergencyContactPhone() != null ? patient.getEmergencyContactPhone() : "N/A" %></div>
                        </div>
                    </div>

                    <!-- APPOINTMENT & DENTIST DETAILS -->
                    <div class="card" style="background: var(--bg-body); border: none;">
                        <h3 class="card-title" style="color: var(--primary); font-size: 15px;">🦷 Treatment & Dentist Details</h3>
                        <div style="font-size: 14px; line-height: 1.8;">
                            <div><strong>Treatment / Service:</strong> <%= service != null ? service.getServiceName() : "Service #" + app.getServiceId() %></div>
                            <div><strong>Standard Price:</strong> LKR <%= service != null ? String.format("%,.2f", service.getStandardPrice()) : "N/A" %></div>
                            <div><strong>Assigned Dentist:</strong> <%= doctor != null ? "Dr. " + doctor.getFirstName() + " " + doctor.getLastName() + " (" + doctor.getSpecialization() + ")" : "Not Assigned" %></div>
                            <div><strong>Requested Date & Time:</strong> <%= app.getRequestedDate() %> at <%= app.getRequestedTime() != null ? app.getRequestedTime() : "Unspecified" %></div>
                        </div>
                    </div>
                </div>

                <% if (app.getPatientReason() != null && !app.getPatientReason().isBlank()) { %>
                    <div style="background: var(--bg-body); padding: 16px; border-radius: var(--radius-md); margin-bottom: 24px;">
                        <strong style="font-size: 13px; color: var(--text-muted); display: block; margin-bottom: 4px;">REASON FOR VISIT / SYMPTOMS:</strong>
                        <p style="font-size: 14px; color: var(--text-heading);"><%= app.getPatientReason() %></p>
                    </div>
                <% } %>

                <div style="display: flex; gap: 12px; justify-content: flex-end; border-top: 1px solid var(--border-color); padding-top: 20px;">
                    <a href="${pageContext.request.contextPath}/assistant/appointments?action=review&id=<%= app.getAppointmentId() %>" class="btn btn-primary">
                        Review / Action Appointment →
                    </a>
                </div>
            </div>
        <% } %>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>
