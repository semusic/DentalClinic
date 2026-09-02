<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dentalclinic.dto.PatientRecordDTO" %>
<%@ page import="java.util.List" %>

<%
    PatientRecordDTO record = (PatientRecordDTO) request.getAttribute("record");
    List<PatientRecordDTO.ServiceRecord> services = record != null ? record.getServices() : null;
    List<PatientRecordDTO.PaymentRecord> payments = record != null ? record.getPayments() : null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Patient Visit Record</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
</head>
<body>

    <header class="app-navbar">
        <div class="nav-container">
            <a href="#" class="nav-brand">
                <div class="brand-icon">🦷</div>
                <div class="brand-title">Dental<span>Care</span></div>
                <span class="role-badge patient">Medical Record</span>
            </a>
            <div class="nav-actions">
                <button onclick="window.print()" class="btn btn-secondary btn-sm">🖨️ Print Record</button>
            </div>
        </div>
    </header>

    <main class="main-container">
        <% if (record == null) { %>
            <div class="card" style="text-align: center; padding: 60px; color: var(--text-muted);">
                <h2>Record Not Found</h2>
                <p>The patient visit record could not be loaded or token is invalid.</p>
            </div>
        <% } else { %>

            <div class="page-header" style="margin-bottom: 24px;">
                <div class="page-title-group">
                    <h1>Patient Visit Record</h1>
                    <p>Verified digital clinic record accessed via patient QR code</p>
                </div>
            </div>

            <!-- Patient Details -->
            <div class="card" style="margin-bottom: 24px;">
                <h2 style="font-size: 18px; font-weight: 700; color: var(--primary); margin-bottom: 16px; border-bottom: 2px solid var(--primary-light); padding-bottom: 8px;">
                    👤 Patient Information
                </h2>
                <div class="grid-3">
                    <div>
                        <span style="font-size: 12px; color: var(--text-muted); display: block;">Full Name</span>
                        <strong style="font-size: 16px; color: var(--text-heading);"><%= record.getPatientName() %></strong>
                    </div>
                    <div>
                        <span style="font-size: 12px; color: var(--text-muted); display: block;">Phone</span>
                        <strong style="font-size: 16px; color: var(--text-heading);"><%= record.getPatientPhone() %></strong>
                    </div>
                    <div>
                        <span style="font-size: 12px; color: var(--text-muted); display: block;">Email</span>
                        <strong style="font-size: 16px; color: var(--text-heading);"><%= record.getPatientEmail() %></strong>
                    </div>
                </div>
            </div>

            <!-- Visit Details -->
            <div class="card" style="margin-bottom: 24px;">
                <h2 style="font-size: 18px; font-weight: 700; color: var(--primary); margin-bottom: 16px; border-bottom: 2px solid var(--primary-light); padding-bottom: 8px;">
                    🩺 Visit Information
                </h2>
                <div class="grid-3">
                    <div style="margin-bottom: 12px;">
                        <span style="font-size: 12px; color: var(--text-muted); display: block;">Visit ID</span>
                        <strong>#<%= record.getVisitId() %></strong>
                    </div>
                    <div style="margin-bottom: 12px;">
                        <span style="font-size: 12px; color: var(--text-muted); display: block;">Appointment Date</span>
                        <strong><%= record.getAppointmentDateTime() == null ? "N/A" : record.getAppointmentDateTime() %></strong>
                    </div>
                    <div style="margin-bottom: 12px;">
                        <span style="font-size: 12px; color: var(--text-muted); display: block;">Attending Doctor</span>
                        <strong><%= record.getDoctorName() %></strong>
                    </div>
                    <div>
                        <span style="font-size: 12px; color: var(--text-muted); display: block;">Checked In</span>
                        <strong><%= record.getCheckedInAt() == null ? "N/A" : record.getCheckedInAt() %></strong>
                    </div>
                    <div>
                        <span style="font-size: 12px; color: var(--text-muted); display: block;">Consultation Started</span>
                        <strong><%= record.getConsultationStartedAt() == null ? "N/A" : record.getConsultationStartedAt() %></strong>
                    </div>
                    <div>
                        <span style="font-size: 12px; color: var(--text-muted); display: block;">Completed</span>
                        <strong><%= record.getConsultationCompletedAt() == null ? "N/A" : record.getConsultationCompletedAt() %></strong>
                    </div>
                </div>
            </div>

            <!-- Services Performed -->
            <div class="card" style="margin-bottom: 24px;">
                <h2 style="font-size: 18px; font-weight: 700; color: var(--primary); margin-bottom: 16px; border-bottom: 2px solid var(--primary-light); padding-bottom: 8px;">
                    🦷 Services Performed
                </h2>
                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Service</th>
                                <th>Quantity</th>
                                <th style="text-align: right;">Unit Price</th>
                                <th style="text-align: right;">Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (services == null || services.isEmpty()) { %>
                                <tr><td colspan="4" style="text-align: center; color: var(--text-muted);">No services recorded for this visit.</td></tr>
                            <% } else {
                                for (PatientRecordDTO.ServiceRecord service : services) {
                            %>
                                <tr>
                                    <td><strong><%= service.getServiceName() %></strong></td>
                                    <td><%= service.getQuantity() %></td>
                                    <td style="text-align: right;">LKR <%= service.getUnitPrice() %></td>
                                    <td style="text-align: right;"><strong>LKR <%= service.getLineTotal() %></strong></td>
                                </tr>
                            <%  }
                               }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Payment & Transactions -->
            <div class="card" style="margin-bottom: 24px;">
                <h2 style="font-size: 18px; font-weight: 700; color: var(--primary); margin-bottom: 16px; border-bottom: 2px solid var(--primary-light); padding-bottom: 8px;">
                    💳 Billing & Payment Summary
                </h2>
                <div class="grid-3" style="margin-bottom: 20px;">
                    <div>
                        <span style="font-size: 12px; color: var(--text-muted); display: block;">Invoice Number</span>
                        <strong><%= record.getInvoiceNumber() == null ? "N/A" : record.getInvoiceNumber() %></strong>
                    </div>
                    <div>
                        <span style="font-size: 12px; color: var(--text-muted); display: block;">Invoice Total</span>
                        <strong>LKR <%= record.getInvoiceTotal() %></strong>
                    </div>
                    <div>
                        <span style="font-size: 12px; color: var(--text-muted); display: block;">Total Paid</span>
                        <strong style="color: #10b981; font-size: 18px;">LKR <%= record.getTotalPaid() %></strong>
                    </div>
                </div>

                <h3 style="font-size: 14px; font-weight: 700; margin-bottom: 12px; color: var(--text-muted);">Payment History</h3>
                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Reference</th>
                                <th>Method</th>
                                <th>Amount</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (payments == null || payments.isEmpty()) { %>
                                <tr><td colspan="4" style="text-align: center; color: var(--text-muted);">No payment records found.</td></tr>
                            <% } else {
                                for (PatientRecordDTO.PaymentRecord payment : payments) {
                            %>
                                <tr>
                                    <td><%= payment.getPaymentReference() %></td>
                                    <td><span class="badge badge-info"><%= payment.getPaymentMethod() %></span></td>
                                    <td>LKR <%= payment.getAmount() %></td>
                                    <td><%= payment.getTransactionDate() %></td>
                                </tr>
                            <%  }
                               }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Notes -->
            <div class="card">
                <h2 style="font-size: 18px; font-weight: 700; color: var(--primary); margin-bottom: 16px; border-bottom: 2px solid var(--primary-light); padding-bottom: 8px;">
                    📝 Clinical Notes
                </h2>
                <div style="background: var(--bg-body); padding: 16px; border-radius: var(--radius-md); font-size: 14px; line-height: 1.6;">
                    <%= record.getVisitNotes() == null || record.getVisitNotes().isBlank() ? "No additional clinical notes recorded." : record.getVisitNotes() %>
                </div>
            </div>
        <% } %>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System • Official Record
    </footer>

</body>
</html>