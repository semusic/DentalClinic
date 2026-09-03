<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dentalclinic.model.User" %>

<%
    User user = (User) session.getAttribute("authenticatedUser");
    String role = (user != null && user.getRoleName() != null) ? user.getRoleName() : "GUEST";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Help & User Guide</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
    <style>
        .help-step {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: var(--shadow-sm);
        }
        .help-step-number {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: var(--primary-light);
            color: var(--primary);
            font-weight: 800;
            font-size: 14px;
            margin-right: 12px;
        }
        .help-step-title {
            font-size: 18px;
            font-weight: 700;
            color: var(--text-heading);
            display: inline-flex;
            align-items: center;
        }
        .help-list {
            margin-top: 12px;
            padding-left: 24px;
            color: var(--text-body);
            font-size: 14px;
            line-height: 1.8;
        }
    </style>
</head>
<body>

<%
    if ("ADMIN".equalsIgnoreCase(role)) {
        request.setAttribute("activeNav", "help");
%>
        <jsp:include page="/WEB-INF/includes/admin-header.jsp" />
<%
    } else if ("ASSISTANT".equalsIgnoreCase(role)) {
        request.setAttribute("activeNav", "help");
%>
        <jsp:include page="/WEB-INF/includes/assistant-header.jsp" />
<%
    } else if ("PATIENT".equalsIgnoreCase(role)) {
        request.setAttribute("activeNav", "help");
%>
        <jsp:include page="/WEB-INF/includes/patient-header.jsp" />
<%
    } else if ("CASHIER".equalsIgnoreCase(role)) {
        request.setAttribute("activeNav", "help");
%>
        <jsp:include page="/WEB-INF/includes/cashier-header.jsp" />
<%
    } else {
%>
        <header class="app-navbar">
            <div class="nav-container">
                <a href="${pageContext.request.contextPath}/login" class="nav-brand">
                    <div class="brand-icon">🦷</div>
                    <div class="brand-title">Dental<span>Care</span></div>
                    <span class="role-badge">Guest Guide</span>
                </a>

                <div class="nav-actions">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm">Sign In</a>
                </div>
            </div>
        </header>
<%
    }
%>

    <main class="main-container">
        <div class="page-header" style="margin-bottom: 32px;">
            <div class="page-title-group">
                <h1>Clinic Staff & Patient Operational Guide</h1>
                <p>Step-by-step instructions for managing patient appointments, clinical visits, billing, and system workflows.</p>
            </div>
        </div>

        <!-- 1. LOGIN -->
        <div class="help-step">
            <div class="help-step-title">
                <span class="help-step-number">1</span> System Authentication & Login
            </div>
            <ul class="help-list">
                <li>Navigate to <code>/login</code> on the clinic portal.</li>
                <li>Enter your registered username and password credentials.</li>
                <li>Click <strong>Sign In to Portal</strong>. The system automatically routes you to your authorized role dashboard (Patient, Assistant, Cashier, or Admin).</li>
            </ul>
        </div>

        <!-- 2. APPOINTMENT REGISTRATION -->
        <div class="help-step">
            <div class="help-step-title">
                <span class="help-step-number">2</span> Registering an Appointment
            </div>
            <ul class="help-list">
                <li>Log in to the Patient Portal and click <strong>Book Appointment</strong>.</li>
                <li>Select the desired dental procedure/service from the catalog dropdown.</li>
                <li>Select an available attending doctor and choose your requested visit date and time slot.</li>
                <li>Enter a brief description of symptoms or reason for visit, then click <strong>Submit Appointment Request</strong>.</li>
                <li>The system generates a unique Appointment Number (e.g. <code>APT-2026-000001</code>).</li>
            </ul>
        </div>

        <!-- 3. SEARCHING APPOINTMENTS -->
        <div class="help-step">
            <div class="help-step-title">
                <span class="help-step-number">3</span> Finding & Searching Appointments
            </div>
            <ul class="help-list">
                <li>Staff members click <strong>Search</strong> on the navigation menu or visit <code>/assistant/appointments/search</code>.</li>
                <li>Enter the unique Appointment Number (e.g. <code>APT-2026-000001</code>) or numeric ID.</li>
                <li>Click <strong>Search</strong> to display complete patient info, contact, treatment details, and status history.</li>
            </ul>
        </div>

        <!-- 4. DOCTOR APPROVAL PROCESS -->
        <div class="help-step">
            <div class="help-step-title">
                <span class="help-step-number">4</span> Doctor Approval Workflow
            </div>
            <ul class="help-list">
                <li>Clinic Assistants review pending requests in the <strong>Assistant Desk</strong> (<code>/assistant/appointments</code>).</li>
                <li>Click <strong>Send to Doctor for Approval</strong>. The system generates a single-use token link and sends an automated notification to the assigned doctor.</li>
                <li>The doctor opens the secure link (no sign-in required) to inspect visit details and selects <strong>Approve</strong>, <strong>Reject</strong>, or <strong>Request Reschedule</strong>.</li>
            </ul>
        </div>

        <!-- 5. PATIENT CHECK-IN & VISIT WORKFLOW -->
        <div class="help-step">
            <div class="help-step-title">
                <span class="help-step-number">5</span> Patient Arrival & Check-In Workflow
            </div>
            <ul class="help-list">
                <li>When the patient arrives at the clinic, the Assistant opens <strong>Visits & Check-in</strong> (<code>/assistant/visits</code>).</li>
                <li>Click <strong>Check In Patient</strong>. The visit stage advances to <code>CHECKED_IN</code>.</li>
                <li>Click <strong>Start Consultation</strong> when the patient enters the consultation room to begin treatment recording.</li>
            </ul>
        </div>

        <!-- 6. ADDING ADDITIONAL SERVICES & PRESCRIBED MEDICINES -->
        <div class="help-step">
            <div class="help-step-title">
                <span class="help-step-number">6</span> Recording Performed Services & Prescribed Medicines
            </div>
            <ul class="help-list">
                <li>In the active visit detail view (<code>/assistant/visits?action=detail&id=...</code>), record additional procedures performed during treatment.</li>
                <li>Select performed service items and quantity to calculate treatment fees.</li>
                <li>Record prescribed medications, dosage, quantity, and administration instructions. Toggle <strong>Dispensed / Provided</strong> status when medicines are handed to patient.</li>
            </ul>
        </div>

        <!-- 7. COMPLETING CONSULTATION -->
        <div class="help-step">
            <div class="help-step-title">
                <span class="help-step-number">7</span> Completing Consultation
            </div>
            <ul class="help-list">
                <li>Enter final clinical summary notes in the consultation notes section.</li>
                <li>Click <strong>Complete Consultation & Send to Cashier</strong>.</li>
                <li>The visit status updates to <code>COMPLETED</code> and queues the visit for Cashier billing.</li>
            </ul>
        </div>

        <!-- 8. BILLING, PAYMENT & RECEIPTS -->
        <div class="help-step">
            <div class="help-step-title">
                <span class="help-step-number">8</span> Billing, Payment & Printing Receipts
            </div>
            <ul class="help-list">
                <li>The Cashier selects completed visits under <strong>Ready for Billing</strong> (<code>/cashier/invoices</code>).</li>
                <li>Click <strong>Generate Invoice</strong> to create the official itemized bill with price snapshots.</li>
                <li>Select payment method (Cash, Card, Bank Transfer) and process full or partial payments under <strong>Process Payment</strong>.</li>
                <li>Upon payment completion, click <strong>Print Official Receipt</strong> or click <strong>Save PDF</strong> (uses browser print dialog target destination to save as PDF).</li>
                <li>Receipt includes a verified Patient Visit Record QR code for mobile verification.</li>
            </ul>
        </div>

        <!-- 9. LOGOUT -->
        <div class="help-step">
            <div class="help-step-title">
                <span class="help-step-number">9</span> System Logout
            </div>
            <ul class="help-list">
                <li>Click <strong>Logout</strong> on any page header. The system invalidates your HTTP session to prevent unauthorized access.</li>
            </ul>
        </div>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>
