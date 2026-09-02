<%@ page contentType="text/html;charset=UTF-8" %>

<%
    String decision = (String) request.getAttribute("decision");
    String title = "Decision Recorded";
    String message = "The appointment decision has been recorded.";

    if ("APPROVED".equals(decision)) {
        title = "Appointment Approved";
        message = "The appointment request has been approved successfully. The clinic staff will process confirmation and patient notifications.";
    } else if ("REJECTED".equals(decision)) {
        title = "Appointment Rejected";
        message = "The appointment request has been rejected. The patient will be notified accordingly.";
    } else if ("RESCHEDULE_REQUIRED".equals(decision)) {
        title = "Reschedule Requested";
        message = "A request for a different appointment slot has been submitted to the clinic assistant.";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | <%= title %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
</head>
<body style="align-items: center; justify-content: center; background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%); min-height: 100vh;">

    <div class="card" style="max-width: 520px; text-align: center; padding: 44px 32px; box-shadow: var(--shadow-lg);">
        <div class="brand-icon" style="margin: 0 auto 16px; width: 52px; height: 52px; font-size: 26px;">
            🦷
        </div>

        <div style="width: 64px; height: 64px; background: #ecfdf5; color: #10b981; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 32px; margin: 0 auto 20px; font-weight: 800;">
            ✓
        </div>

        <h1 style="font-size: 24px; font-weight: 800; color: var(--text-heading); margin-bottom: 12px;"><%= title %></h1>
        <p style="color: var(--text-muted); font-size: 15px; line-height: 1.6; margin-bottom: 24px;">
            <%= message %>
        </p>

        <div style="display: inline-block; padding: 8px 20px; border-radius: 20px; background: var(--primary-light); color: var(--primary); font-weight: 700; font-size: 13px;">
            DECISION RECORDED: <%= decision %>
        </div>
    </div>

</body>
</html>