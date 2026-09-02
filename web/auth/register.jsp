<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Patient Registration</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
</head>
<body>

    <header class="app-navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/login" class="nav-brand">
                <div class="brand-icon">🦷</div>
                <div class="brand-title">Dental<span>Care</span></div>
            </a>
            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary btn-sm">Back to Sign In</a>
            </div>
        </div>
    </header>

    <main class="main-container">
        <div class="card" style="max-width: 800px; margin: 0 auto;">
            <div style="margin-bottom: 24px; text-align: center;">
                <h1 style="font-size: 26px; font-weight: 800; color: var(--text-heading);">Patient Account Registration</h1>
                <p style="color: var(--text-muted);">Create your account to request appointments and access medical records</p>
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
            %>

            <form action="${pageContext.request.contextPath}/register" method="post">
                <h3 style="font-size: 16px; font-weight: 700; color: var(--primary); margin-bottom: 16px; border-bottom: 2px solid var(--primary-light); padding-bottom: 8px;">
                    Account Credentials
                </h3>
                <div class="grid-2">
                    <div class="form-group">
                        <label class="form-label">Username</label>
                        <input class="form-control" type="text" name="username" maxlength="50" required placeholder="Choose a username">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Email Address</label>
                        <input class="form-control" type="email" name="email" maxlength="150" required placeholder="name@example.com">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Password</label>
                        <input class="form-control" type="password" name="password" minlength="8" required placeholder="At least 8 characters">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Confirm Password</label>
                        <input class="form-control" type="password" name="confirmPassword" minlength="8" required placeholder="Re-enter password">
                    </div>
                </div>

                <h3 style="font-size: 16px; font-weight: 700; color: var(--primary); margin-top: 16px; margin-bottom: 16px; border-bottom: 2px solid var(--primary-light); padding-bottom: 8px;">
                    Personal Information
                </h3>
                <div class="grid-2">
                    <div class="form-group">
                        <label class="form-label">First Name</label>
                        <input class="form-control" type="text" name="firstName" maxlength="100" required placeholder="First name">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Last Name</label>
                        <input class="form-control" type="text" name="lastName" maxlength="100" required placeholder="Last name">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Phone Number</label>
                        <input class="form-control" type="tel" name="phone" maxlength="20" placeholder="+94 77 123 4567">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Date of Birth</label>
                        <input class="form-control" type="date" name="dateOfBirth">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Gender</label>
                        <select class="form-control" name="gender">
                            <option value="">Select Gender</option>
                            <option value="Female">Female</option>
                            <option value="Male">Male</option>
                            <option value="Other">Other</option>
                            <option value="Prefer not to say">Prefer not to say</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Address</label>
                        <input class="form-control" type="text" name="address" maxlength="255" placeholder="Residential address">
                    </div>
                </div>

                <h3 style="font-size: 16px; font-weight: 700; color: var(--primary); margin-top: 16px; margin-bottom: 16px; border-bottom: 2px solid var(--primary-light); padding-bottom: 8px;">
                    Emergency Contact
                </h3>
                <div class="grid-2">
                    <div class="form-group">
                        <label class="form-label">Contact Person Name</label>
                        <input class="form-control" type="text" name="emergencyContactName" maxlength="150" placeholder="Relative or guardian">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Contact Phone</label>
                        <input class="form-control" type="tel" name="emergencyContactPhone" maxlength="20" placeholder="Emergency contact number">
                    </div>
                </div>

                <h3 style="font-size: 16px; font-weight: 700; color: var(--primary); margin-top: 16px; margin-bottom: 16px; border-bottom: 2px solid var(--primary-light); padding-bottom: 8px;">
                    Medical History Notes
                </h3>
                <div class="form-group">
                    <label class="form-label">Medical & Health Notes (Optional)</label>
                    <textarea class="form-control" name="medicalNotes" maxlength="2000" rows="3" placeholder="Disclose allergies, medical conditions, or special requirements..."></textarea>
                </div>

                <div style="display: flex; gap: 12px; margin-top: 28px;">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary" style="flex: 1;">Cancel</a>
                    <button type="submit" class="btn btn-primary" style="flex: 2;">Complete Registration</button>
                </div>
            </form>
        </div>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>