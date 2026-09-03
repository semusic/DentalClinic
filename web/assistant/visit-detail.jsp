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

<%
    request.setAttribute("activeNav", "visits");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Patient Visit Detail</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
    <style>
        .visit-detail-layout {
            max-width: 960px;
            margin: 0 auto;
        }
        .patient-hero-card {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            border-radius: var(--radius-lg);
            padding: 28px 32px;
            color: #ffffff;
            margin-bottom: 24px;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 20px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.2);
        }
        .patient-hero-name {
            font-size: 26px;
            font-weight: 800;
            letter-spacing: -0.5px;
            margin-bottom: 4px;
        }
        .patient-hero-meta {
            font-size: 13px;
            opacity: 0.6;
        }
        .hero-info-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-top: 20px;
            background: rgba(255,255,255,0.06);
            padding: 16px;
            border-radius: var(--radius-md);
        }
        .hero-info-item span {
            font-size: 10px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            opacity: 0.55;
            display: block;
            margin-bottom: 3px;
        }
        .hero-info-item strong {
            font-size: 13px;
            font-weight: 700;
        }
        .section-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--border-color);
            padding: 24px;
            box-shadow: var(--shadow-md);
            margin-bottom: 20px;
        }
        .section-title {
            font-size: 15px;
            font-weight: 700;
            color: var(--text-heading);
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .section-title span {
            font-size: 13px;
            font-weight: 500;
            color: var(--text-muted);
        }

        /* Progress Timeline */
        .progress-timeline {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 8px;
            margin-bottom: 20px;
        }
        .progress-step {
            padding: 14px 12px;
            border-radius: var(--radius-md);
            text-align: center;
            font-size: 12px;
            font-weight: 700;
            border: 1.5px solid;
            transition: var(--transition);
        }
        .progress-step.done {
            background: #dcfce7;
            color: #15803d;
            border-color: #86efac;
        }
        .progress-step.pending {
            background: #f8fafc;
            color: #94a3b8;
            border-color: #e2e8f0;
        }
        .progress-step-num {
            font-size: 18px;
            margin-bottom: 4px;
        }

        /* Services Table */
        .services-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }
        .services-table th {
            background: #f8fafc;
            padding: 12px 16px;
            font-weight: 700;
            color: var(--text-muted);
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 1px solid var(--border-color);
            text-align: left;
        }
        .services-table td {
            padding: 14px 16px;
            border-bottom: 1px solid var(--border-color);
            color: var(--text-body);
        }
        .services-table tr:last-child td {
            border-bottom: none;
        }
        .services-table-wrap {
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            overflow: hidden;
        }

        /* Add Service Form */
        .add-service-form {
            background: var(--bg-body);
            border-radius: var(--radius-md);
            padding: 20px;
            margin-bottom: 20px;
            border: 1px dashed var(--border-color);
        }
        .add-service-grid {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr;
            gap: 12px;
            margin-bottom: 12px;
        }

        /* Medicine Toggle */
        .medicine-toggle-row {
            display: flex;
            gap: 16px;
            align-items: center;
            flex-wrap: wrap;
        }
        .medicine-radio-label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            padding: 10px 16px;
            border-radius: var(--radius-md);
            border: 1.5px solid var(--border-color);
            transition: var(--transition);
        }
        .medicine-radio-label:has(input:checked) {
            background: var(--primary-light);
            border-color: var(--primary);
            color: var(--primary);
        }
        .medicine-radio-label input {
            accent-color: var(--primary);
        }

        /* No Visit State */
        .no-visit-card {
            background: #fff7ed;
            border: 1px solid #fed7aa;
            border-radius: var(--radius-lg);
            padding: 40px;
            text-align: center;
        }
        .no-visit-icon {
            font-size: 40px;
            margin-bottom: 12px;
        }

        /* Back Link */
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: var(--primary);
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 20px;
            transition: gap 0.2s;
        }
        .back-link:hover { gap: 10px; }

        @media (max-width: 768px) {
            .hero-info-grid { grid-template-columns: repeat(2, 1fr); }
            .progress-timeline { grid-template-columns: repeat(2, 1fr); }
            .add-service-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/includes/assistant-header.jsp" />

    <main class="main-container">
        <div class="visit-detail-layout">

            <a href="${pageContext.request.contextPath}/assistant/visits" class="back-link">
                ← Back to Visits
            </a>

            <% if (error != null && !error.isBlank()) { %>
                <div class="alert alert-error" style="margin-bottom: 16px;"><%= error %></div>
            <% } %>

            <% if (success != null && !success.isBlank()) { %>
                <div class="alert alert-success" style="margin-bottom: 16px;"><%= success %></div>
            <% } %>

            <!-- Patient Hero Card -->
            <div class="patient-hero-card">
                <div style="flex: 1; min-width: 200px;">
                    <div class="patient-hero-name"><%= appointment.getPatientName() %></div>
                    <div class="patient-hero-meta">
                        Appointment #<%= appointment.getAppointmentId() %>
                        <% if (hasVisit) { %> &nbsp;•&nbsp; Visit #<%= visit.getVisitId() %><% } %>
                    </div>
                    <div class="hero-info-grid">
                        <div class="hero-info-item">
                            <span>Service</span>
                            <strong><%= appointment.getServiceName() %></strong>
                        </div>
                        <div class="hero-info-item">
                            <span>Doctor</span>
                            <strong><%= appointment.getDoctorName() != null ? appointment.getDoctorName() : "Unassigned" %></strong>
                        </div>
                        <div class="hero-info-item">
                            <span>Date</span>
                            <strong><%= appointment.getAppointmentDate() %></strong>
                        </div>
                        <div class="hero-info-item">
                            <span>Time</span>
                            <strong><%= appointment.getAppointmentTime() != null ? appointment.getAppointmentTime() : "—" %></strong>
                        </div>
                    </div>
                </div>
                <span class="badge badge-info" style="font-size: 13px; padding: 7px 14px; background: rgba(255,255,255,0.15); color: #ffffff; border: 1px solid rgba(255,255,255,0.25);">
                    <%= appointment.getAppointmentStatus() %>
                </span>
            </div>

            <% if (!hasVisit) { %>
                <!-- No Visit State -->
                <div class="no-visit-card">
                    <div class="no-visit-icon">📋</div>
                    <h3 style="font-size: 18px; font-weight: 700; color: #92400e; margin-bottom: 8px;">No Visit Record Yet</h3>
                    <p style="color: #b45309; font-size: 14px; margin-bottom: 20px;">This confirmed appointment does not have an active visit record created yet. Create one to begin the check-in process.</p>
                    <form method="post" action="${pageContext.request.contextPath}/assistant/visits">
                        <input type="hidden" name="action" value="createVisit">
                        <input type="hidden" name="appointmentId" value="<%= appointment.getAppointmentId() %>">
                        <button type="submit" class="btn btn-primary">Create Visit Record</button>
                    </form>
                </div>

            <% } else { %>

                <!-- Progress Timeline -->
                <div class="section-card">
                    <div class="section-title">Visit Progress & Check-in</div>
                    <div class="progress-timeline">
                        <div class="progress-step done">
                            <div class="progress-step-num">✓</div>
                            Visit Created
                        </div>
                        <div class="progress-step <%= checkedIn ? "done" : "pending" %>">
                            <div class="progress-step-num"><%= checkedIn ? "✓" : "2" %></div>
                            Patient Checked In
                        </div>
                        <div class="progress-step <%= consultationStarted ? "done" : "pending" %>">
                            <div class="progress-step-num"><%= consultationStarted ? "✓" : "3" %></div>
                            Consultation Started
                        </div>
                        <div class="progress-step <%= consultationCompleted ? "done" : "pending" %>">
                            <div class="progress-step-num"><%= consultationCompleted ? "✓" : "4" %></div>
                            Completed
                        </div>
                    </div>

                    <div style="display: flex; gap: 12px; flex-wrap: wrap;">
                        <% if (!checkedIn && !consultationCompleted) { %>
                            <form method="post" action="${pageContext.request.contextPath}/assistant/visits">
                                <input type="hidden" name="action" value="checkIn">
                                <input type="hidden" name="visitId" value="<%= visit.getVisitId() %>">
                                <button type="submit" class="btn btn-primary">✓ Check In Patient</button>
                            </form>
                        <% } %>

                        <% if (checkedIn && !consultationStarted && !consultationCompleted) { %>
                            <form method="post" action="${pageContext.request.contextPath}/assistant/visits">
                                <input type="hidden" name="action" value="startConsultation">
                                <input type="hidden" name="visitId" value="<%= visit.getVisitId() %>">
                                <button type="submit" class="btn btn-primary">🩺 Start Consultation</button>
                            </form>
                        <% } %>

                        <% if (consultationCompleted) { %>
                            <div style="display:flex; align-items:center; gap:8px; background:#dcfce7; color:#15803d; font-weight:700; padding:10px 20px; border-radius:var(--radius-md); font-size:14px;">
                                ✅ Consultation Completed
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- Services Performed -->
                <div class="section-card">
                    <div class="section-title">
                        Services Performed
                        <span>Record additional procedures conducted during consultation</span>
                    </div>

                    <% if (!consultationCompleted) { %>
                        <div class="add-service-form">
                            <form method="post" action="${pageContext.request.contextPath}/assistant/visits">
                                <input type="hidden" name="action" value="addService">
                                <input type="hidden" name="visitId" value="<%= visit.getVisitId() %>">
                                <div class="add-service-grid">
                                    <div>
                                        <label class="form-label">Select Service</label>
                                        <select class="form-control" name="serviceId" required>
                                            <option value="">— Choose Service —</option>
                                            <% if (availableServices != null) {
                                                for (Service s : availableServices) { %>
                                                <option value="<%= s.getServiceId() %>">
                                                    <%= s.getServiceName() %> — LKR <%= s.getStandardPrice() %>
                                                </option>
                                            <% } } %>
                                        </select>
                                    </div>
                                    <div>
                                        <label class="form-label">Quantity</label>
                                        <input class="form-control" type="number" name="quantity" value="1" min="1" required>
                                    </div>
                                    <div>
                                        <label class="form-label">Notes (Optional)</label>
                                        <input class="form-control" type="text" name="notes" placeholder="Treatment notes...">
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary btn-sm">+ Add Service to Visit</button>
                            </form>
                        </div>
                    <% } %>

                    <div class="services-table-wrap">
                        <table class="services-table">
                            <thead>
                                <tr>
                                    <th>Service</th>
                                    <th>Qty</th>
                                    <th>Unit Price</th>
                                    <th>Notes</th>
                                    <th style="text-align:right;">Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (visitServices == null || visitServices.isEmpty()) { %>
                                    <tr>
                                        <td colspan="5" style="text-align:center; color:var(--text-muted); padding:24px;">
                                            No services added yet
                                        </td>
                                    </tr>
                                <% } else {
                                    for (VisitService vs : visitServices) { %>
                                    <tr>
                                        <td><strong>Service #<%= vs.getServiceId() %></strong></td>
                                        <td><%= vs.getQuantity() %></td>
                                        <td>LKR <%= vs.getUnitPrice() %></td>
                                        <td style="color:var(--text-muted)"><%= vs.getTreatmentNotes() != null ? vs.getTreatmentNotes() : "—" %></td>
                                        <td style="text-align:right;"><strong>LKR <%= vs.getLineTotal() %></strong></td>
                                    </tr>
                                <% } } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Prescription & Medication -->
                <div class="section-card">
                    <div class="section-title">Prescription & Medication Status</div>

                    <div style="background: var(--bg-body); padding: 16px; border-radius: var(--radius-md); margin-bottom: 16px; display: flex; align-items: center; gap: 12px;">
                        <div style="font-size: 24px;"><%= medicinePrescribed ? "💊" : "🚫" %></div>
                        <div>
                            <div style="font-size: 13px; font-weight: 700; color: var(--text-heading);">
                                Medication Prescribed: <span style="color: <%= medicinePrescribed ? "#15803d" : "#b45309" %>"><%= medicinePrescribed ? "YES" : "NO" %></span>
                            </div>
                            <div style="font-size: 12px; color: var(--text-muted);">
                                <%= medicinePrescribed ? "Prescription issued during this visit." : "No medication has been prescribed for this visit." %>
                            </div>
                        </div>
                    </div>

                    <% if (!consultationCompleted) { %>
                        <form method="post" action="${pageContext.request.contextPath}/assistant/visits">
                            <input type="hidden" name="action" value="medicine">
                            <input type="hidden" name="visitId" value="<%= visit.getVisitId() %>">
                            <div class="medicine-toggle-row" style="margin-bottom: 16px;">
                                <label class="medicine-radio-label">
                                    <input type="radio" name="prescribed" value="true" <%= medicinePrescribed ? "checked" : "" %>>
                                    💊 Yes, Medication Prescribed
                                </label>
                                <label class="medicine-radio-label">
                                    <input type="radio" name="prescribed" value="false" <%= !medicinePrescribed ? "checked" : "" %>>
                                    🚫 No Medication
                                </label>
                            </div>
                            <button type="submit" class="btn btn-secondary btn-sm">Update Medication Status</button>
                        </form>
                    <% } %>
                </div>

                <!-- Complete Consultation -->
                <div class="section-card">
                    <div class="section-title">Complete Consultation</div>
                    <% if (consultationCompleted) { %>
                        <div class="alert alert-success" style="margin: 0;">
                            ✅ Consultation completed and notes recorded.
                        </div>
                    <% } else { %>
                        <form method="post" action="${pageContext.request.contextPath}/assistant/visits">
                            <input type="hidden" name="action" value="complete">
                            <input type="hidden" name="visitId" value="<%= visit.getVisitId() %>">
                            <div class="form-group">
                                <label class="form-label">Doctor's Consultation Notes</label>
                                <textarea class="form-control" name="visitNotes" rows="4" required
                                          placeholder="Enter clinical notes, diagnosis, treatment performed, or follow-up recommendations..."></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary" style="background: #10b981; border-color: #10b981; box-shadow: 0 4px 12px rgba(16,185,129,0.25);">
                                ✅ Complete Consultation
                            </button>
                        </form>
                    <% } %>
                </div>

            <% } %>
        </div>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>