<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.dto.AssistantVisitDTO" %>
<%@ page import="com.dentalclinic.model.PatientVisit" %>
<%@ page import="com.dentalclinic.model.Service" %>
<%@ page import="com.dentalclinic.model.VisitService" %>

<%
    AssistantVisitDTO appointment = (AssistantVisitDTO) request.getAttribute("appointment");
    PatientVisit visit = (PatientVisit) request.getAttribute("visit");
    List<Service> availableServices = (List<Service>) request.getAttribute("availableServices");
    List<VisitService> visitServices = (List<VisitService>) request.getAttribute("visitServices");
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");

    boolean hasVisit = visit != null;
    boolean checkedIn = hasVisit && visit.getCheckedInAt() != null;
    boolean consultationStarted = hasVisit && visit.getConsultationStartedAt() != null;
    boolean consultationCompleted = hasVisit && visit.getConsultationCompletedAt() != null;
    boolean medicinePrescribed = hasVisit && visit.isMedicinePrescribed();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Patient Visit Detail</title>
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
                <a href="${pageContext.request.contextPath}/assistant/visits" class="btn btn-secondary btn-sm">← Back to Visits</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout btn-sm">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-container">
        <div class="page-header" style="margin-bottom: 24px;">
            <div class="page-title-group">
                <h1>Clinical Visit Detail</h1>
                <p>Manage patient check-in, performed services, prescriptions, and consultation notes.</p>
            </div>
        </div>

        <% if (error != null && !error.isBlank()) { %>
            <div class="alert alert-error"><%= error %></div>
        <% } %>

        <% if (success != null && !success.isBlank()) { %>
            <div class="alert alert-success"><%= success %></div>
        <% } %>

        <!-- Patient Header Card -->
        <div class="card" style="margin-bottom: 24px;">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; gap: 20px; flex-wrap: wrap; margin-bottom: 20px;">
                <div>
                    <h2 style="font-size: 24px; font-weight: 800; color: var(--text-heading);"><%= appointment.getPatientName() %></h2>
                    <span style="font-size: 13px; color: var(--text-muted);">
                        Appointment #<%= appointment.getAppointmentId() %> <% if (hasVisit) { %> • Visit #<%= visit.getVisitId() %> <% } %>
                    </span>
                </div>
                <span class="badge badge-info" style="font-size: 13px; padding: 6px 14px;"><%= appointment.getAppointmentStatus() %></span>
            </div>

            <div class="grid-4" style="background: var(--bg-body); padding: 16px; border-radius: var(--radius-md);">
                <div>
                    <span style="font-size: 11px; color: var(--text-muted); display: block;">Booked Service</span>
                    <strong><%= appointment.getServiceName() %></strong>
                </div>
                <div>
                    <span style="font-size: 11px; color: var(--text-muted); display: block;">Attending Doctor</span>
                    <strong><%= appointment.getDoctorName() != null ? appointment.getDoctorName() : "Unassigned" %></strong>
                </div>
                <div>
                    <span style="font-size: 11px; color: var(--text-muted); display: block;">Date</span>
                    <strong><%= appointment.getAppointmentDate() %></strong>
                </div>
                <div>
                    <span style="font-size: 11px; color: var(--text-muted); display: block;">Time</span>
                    <strong><%= appointment.getAppointmentTime() != null ? appointment.getAppointmentTime() : "Not set" %></strong>
                </div>
            </div>
        </div>

        <% if (!hasVisit) { %>
            <div class="card">
                <h3 class="card-title">Create Visit Record</h3>
                <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 20px;">This confirmed appointment does not have an active visit record created yet.</p>
                <form method="post" action="${pageContext.request.contextPath}/assistant/visits">
                    <input type="hidden" name="action" value="createVisit">
                    <input type="hidden" name="appointmentId" value="<%= appointment.getAppointmentId() %>">
                    <button type="submit" class="btn btn-primary">Create Visit Record Now</button>
                </form>
            </div>
        <% } else { %>

            <!-- Visit Progress Timeline -->
            <div class="card" style="margin-bottom: 24px;">
                <h3 class="card-title" style="margin-bottom: 16px;">Visit Progress & Check-in</h3>
                <div class="grid-4" style="gap: 12px; margin-bottom: 20px;">
                    <div style="padding: 14px; border-radius: var(--radius-md); text-align: center; font-weight: 700; font-size: 13px; background: #dcfce7; color: #15803d;">
                        1. Visit Created ✓
                    </div>
                    <div style="padding: 14px; border-radius: var(--radius-md); text-align: center; font-weight: 700; font-size: 13px; background: <%= checkedIn ? "#dcfce7" : "#f1f5f9" %>; color: <%= checkedIn ? "#15803d" : "#64748b" %>;">
                        2. Patient Checked In <%= checkedIn ? "✓" : "" %>
                    </div>
                    <div style="padding: 14px; border-radius: var(--radius-md); text-align: center; font-weight: 700; font-size: 13px; background: <%= consultationStarted ? "#dcfce7" : "#f1f5f9" %>; color: <%= consultationStarted ? "#15803d" : "#64748b" %>;">
                        3. Consultation Started <%= consultationStarted ? "✓" : "" %>
                    </div>
                    <div style="padding: 14px; border-radius: var(--radius-md); text-align: center; font-weight: 700; font-size: 13px; background: <%= consultationCompleted ? "#dcfce7" : "#f1f5f9" %>; color: <%= consultationCompleted ? "#15803d" : "#64748b" %>;">
                        4. Completed <%= consultationCompleted ? "✓" : "" %>
                    </div>
                </div>

                <div style="display: flex; gap: 12px; flex-wrap: wrap;">
                    <% if (!checkedIn && !consultationCompleted) { %>
                        <form method="post" action="${pageContext.request.contextPath}/assistant/visits">
                            <input type="hidden" name="action" value="checkIn">
                            <input type="hidden" name="visitId" value="<%= visit.getVisitId() %>">
                            <button type="submit" class="btn btn-primary">Check In Patient</button>
                        </form>
                    <% } %>

                    <% if (checkedIn && !consultationStarted && !consultationCompleted) { %>
                        <form method="post" action="${pageContext.request.contextPath}/assistant/visits">
                            <input type="hidden" name="action" value="startConsultation">
                            <input type="hidden" name="visitId" value="<%= visit.getVisitId() %>">
                            <button type="submit" class="btn btn-primary">Start Consultation</button>
                        </form>
                    <% } %>
                </div>
            </div>

            <!-- Performed Services -->
            <div class="card" style="margin-bottom: 24px;">
                <h3 class="card-title">Services Performed</h3>
                <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 20px;">Record additional procedures or services conducted during the consultation.</p>

                <% if (!consultationCompleted) { %>
                    <form method="post" action="${pageContext.request.contextPath}/assistant/visits" style="margin-bottom: 24px; background: var(--bg-body); padding: 18px; border-radius: var(--radius-md);">
                        <input type="hidden" name="action" value="addService">
                        <input type="hidden" name="visitId" value="<%= visit.getVisitId() %>">

                        <div class="grid-3" style="gap: 12px; margin-bottom: 12px;">
                            <div>
                                <label class="form-label">Select Service</label>
                                <select class="form-control" name="serviceId" required>
                                    <option value="">-- Choose Service --</option>
                                    <% if (availableServices != null) {
                                        for (Service s : availableServices) {
                                    %>
                                        <option value="<%= s.getServiceId() %>"><%= s.getServiceName() %> — LKR <%= s.getStandardPrice() %></option>
                                    <% } } %>
                                </select>
                            </div>
                            <div>
                                <label class="form-label">Quantity</label>
                                <input class="form-control" type="number" name="quantity" value="1" min="1" required>
                            </div>
                            <div>
                                <label class="form-label">Treatment Notes</label>
                                <input class="form-control" type="text" name="notes" placeholder="Optional notes">
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary btn-sm">+ Add Service to Visit</button>
                    </form>
                <% } %>

                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Service ID</th>
                                <th>Quantity</th>
                                <th>Unit Price</th>
                                <th>Notes</th>
                                <th style="text-align: right;">Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (visitServices == null || visitServices.isEmpty()) { %>
                                <tr><td colspan="5" style="text-align: center; color: var(--text-muted);">No services added yet.</td></tr>
                            <% } else {
                                for (VisitService vs : visitServices) {
                            %>
                                <tr>
                                    <td>Service #<%= vs.getServiceId() %></td>
                                    <td><%= vs.getQuantity() %></td>
                                    <td>LKR <%= vs.getUnitPrice() %></td>
                                    <td><%= vs.getTreatmentNotes() != null ? vs.getTreatmentNotes() : "—" %></td>
                                    <td style="text-align: right;"><strong>LKR <%= vs.getLineTotal() %></strong></td>
                                </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Medicine Status -->
            <div class="card" style="margin-bottom: 24px;">
                <h3 class="card-title">Prescription & Medication Status</h3>
                <div style="background: var(--bg-body); padding: 18px; border-radius: var(--radius-md); margin-bottom: 16px;">
                    <span style="font-size: 14px; font-weight: 700; color: var(--text-heading);">
                        Prescription Prescribed: <%= medicinePrescribed ? "YES" : "NO" %>
                    </span>
                </div>

                <% if (!consultationCompleted) { %>
                    <form method="post" action="${pageContext.request.contextPath}/assistant/visits">
                        <input type="hidden" name="action" value="medicine">
                        <input type="hidden" name="visitId" value="<%= visit.getVisitId() %>">
                        <div style="display: flex; gap: 20px; align-items: center; margin-bottom: 16px;">
                            <label style="display: flex; align-items: center; gap: 8px; font-weight: 600; cursor: pointer;">
                                <input type="radio" name="prescribed" value="true" <%= medicinePrescribed ? "checked" : "" %>> Yes, Medication Prescribed
                            </label>
                            <label style="display: flex; align-items: center; gap: 8px; font-weight: 600; cursor: pointer;">
                                <input type="radio" name="prescribed" value="false" <%= !medicinePrescribed ? "checked" : "" %>> No Medication
                            </label>
                        </div>
                        <button type="submit" class="btn btn-secondary btn-sm">Update Medication Status</button>
                    </form>
                <% } %>
            </div>

            <!-- Complete Consultation -->
            <div class="card">
                <h3 class="card-title">Complete Consultation</h3>
                <% if (consultationCompleted) { %>
                    <div class="alert alert-success" style="margin: 0;">
                        ✓ Consultation completed. Notes recorded.
                    </div>
                <% } else { %>
                    <form method="post" action="${pageContext.request.contextPath}/assistant/visits">
                        <input type="hidden" name="action" value="complete">
                        <input type="hidden" name="visitId" value="<%= visit.getVisitId() %>">
                        <div class="form-group">
                            <label class="form-label">Doctor's Consultation Notes</label>
                            <textarea class="form-control" name="visitNotes" rows="3" required placeholder="Enter clinical notes, diagnosis, or recommendations..."></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary" style="background: #10b981; border-color: #10b981;">Complete Consultation</button>
                    </form>
                <% } %>
            </div>

        <% } %>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>