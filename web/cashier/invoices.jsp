<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.dto.CashierVisitDTO" %>

<%
    List<CashierVisitDTO> visits = (List<CashierVisitDTO>) request.getAttribute("visits");
    if (visits == null) {
        visits = (List<CashierVisitDTO>) request.getAttribute("completedVisits");
    }
    String error = (String) request.getAttribute("error");
%>

<%
    request.setAttribute("activeNav", "invoices");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Ready Invoices</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
    <style>
        .cashier-layout {
            max-width: 1040px;
            margin: 0 auto;
        }
        .visit-billing-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--border-color);
            padding: 24px;
            box-shadow: var(--shadow-md);
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 16px;
            flex-wrap: wrap;
        }
        .visit-billing-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary-border);
        }
        .patient-title-name {
            font-size: 20px;
            font-weight: 800;
            color: var(--text-heading);
            letter-spacing: -0.3px;
            margin-bottom: 2px;
        }
        .meta-line {
            font-size: 13px;
            color: var(--text-muted);
            display: flex;
            gap: 12px;
            align-items: center;
            flex-wrap: wrap;
        }
        .empty-billing-state {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 80px 40px;
            text-align: center;
            box-shadow: var(--shadow-sm);
        }
        .empty-billing-icon {
            width: 64px;
            height: 64px;
            background: #fefce8;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            margin: 0 auto 16px;
            color: #ca8a04;
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/includes/cashier-header.jsp" />

    <main class="main-container">
        <div class="cashier-layout">

            <div class="page-header">
                <div class="page-title-group">
                    <h1>Ready for Billing & Invoicing</h1>
                    <p>Select completed consultations below to generate official clinic billing invoices.</p>
                </div>
            </div>

            <% if (error != null && !error.isBlank()) { %>
                <div class="alert alert-error" style="margin-bottom: 20px;"><%= error %></div>
            <% } %>

            <% if (visits == null || visits.isEmpty()) { %>
                <div class="empty-billing-state">
                    <div class="empty-billing-icon">🧾</div>
                    <h3 style="font-size: 20px; font-weight: 700; color: var(--text-heading); margin-bottom: 8px;">No Pending Billing Visits</h3>
                    <p style="color: var(--text-muted); font-size: 14px;">All completed consultations have been invoiced, or no visits are currently awaiting billing.</p>
                </div>
            <% } else { %>
                <div style="margin-bottom: 16px; font-size: 13px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px;">
                    Visits Awaiting Invoicing (<%= visits.size() %>)
                </div>

                <% for (CashierVisitDTO visit : visits) { %>
                    <div class="visit-billing-card">
                        <div>
                            <div class="patient-title-name"><%= visit.getPatientName() %></div>
                            <div class="meta-line">
                                <span>Visit #<%= visit.getVisitId() %></span> &nbsp;•&nbsp;
                                <span>Appointment #<%= visit.getAppointmentId() %></span> &nbsp;•&nbsp;
                                <span>Doctor: <strong><%= visit.getDoctorName() %></strong></span>
                            </div>
                            <div style="font-size: 12px; color: #16a34a; font-weight: 600; margin-top: 6px;">
                                ✅ Consultation Completed: <%= visit.getConsultationCompletedAt() != null ? visit.getConsultationCompletedAt().toString() : "Recent" %>
                            </div>
                        </div>

                        <a href="${pageContext.request.contextPath}/cashier/invoices?visitId=<%= visit.getVisitId() %>"
                           class="btn btn-primary" style="background: #16a34a; border-color: #16a34a;">
                            Generate Invoice →
                        </a>
                    </div>
                <% } %>
            <% } %>

        </div>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>