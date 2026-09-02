<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Sign In</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
</head>
<body style="align-items: center; justify-content: center; background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%); min-height: 100vh;">

    <div class="card" style="width: 100%; max-width: 440px; padding: 40px; box-shadow: var(--shadow-lg);">
        <div style="text-align: center; margin-bottom: 32px;">
            <div class="brand-icon" style="margin: 0 auto 16px; width: 52px; height: 52px; font-size: 26px;">
                🦷
            </div>
            <h1 style="font-size: 26px; font-weight: 800; color: var(--text-heading);">DentalCare</h1>
            <p style="color: var(--text-muted); font-size: 14px; margin-top: 4px;">Clinic Management & Patient Portal</p>
        </div>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="alert alert-error">
                <%= error %>
            </div>
        <%
            }

            String registered = request.getParameter("registered");
            if ("true".equals(registered)) {
        %>
            <div class="alert alert-success">
                Account created successfully! Please sign in with your username and password.
            </div>
        <%
            }
        %>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label class="form-label" for="username">Username</label>
                <input class="form-control" type="text" id="username" name="username" maxlength="50" required autocomplete="username" placeholder="Enter your username">
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Password</label>
                <input class="form-control" type="password" id="password" name="password" required autocomplete="current-password" placeholder="Enter your password">
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; padding: 13px; font-size: 15px; margin-top: 8px;">
                Sign In to Portal
            </button>
        </form>

        <div style="text-align: center; margin-top: 24px; padding-top: 20px; border-top: 1px solid var(--border-color); font-size: 14px;">
            <p style="color: var(--text-muted);">
                Don't have a patient account?
                <a href="${pageContext.request.contextPath}/register" style="color: var(--primary); font-weight: 700; text-decoration: none;">Create one here</a>
            </p>
            <p style="margin-top: 12px;">
                <a href="${pageContext.request.contextPath}/services" style="color: var(--text-muted); font-size: 13px; text-decoration: none;">
                    Explore Services & Pricing →
                </a>
            </p>
        </div>
    </div>

</body>
</html>