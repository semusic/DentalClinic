<%@ page contentType="text/html;charset=UTF-8" %>
<%
    request.setAttribute("activeNav", "book");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Request Submitted</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
</head>
<body>

    <jsp:include page="/WEB-INF/includes/patient-header.jsp" />

    <main class="main-container" style="display: flex; align-items: center; justify-content: center;">
        <div class="card" style="max-width: 540px; text-align: center; padding: 44px 32px;">
            <div style="width: 72px; height: 72px; background: #ecfdf5; color: #10b981; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 36px; margin: 0 auto 20px; font-weight: 800;">
                ✓
            </div>

            <h1 style="font-size: 26px; font-weight: 800; color: var(--text-heading); margin-bottom: 12px;">Appointment Request Submitted!</h1>
            <p style="color: var(--text-muted); font-size: 15px; line-height: 1.6;">
                Your appointment request has been recorded. Our clinic team and assigned doctor will review the details.
            </p>

            <div style="margin: 20px 0;">
                <span class="badge badge-warning" style="font-size: 13px; padding: 6px 16px;">
                    STATUS: PENDING DOCTOR APPROVAL
                </span>
            </div>

            <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 28px;">
                You will receive a notification in your portal inbox as soon as the appointment is confirmed or updated.
            </p>

            <a href="${pageContext.request.contextPath}/patient/dashboard" class="btn btn-primary" style="width: 100%; justify-content: center; padding: 12px;">
                Return to Patient Dashboard
            </a>
        </div>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>