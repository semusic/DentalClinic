<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">

    <title>
        DentalCare | Patient Registration
    </title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: Arial, sans-serif;
            background:
                linear-gradient(
                    135deg,
                    #e8f8ff,
                    #f7fbff
                );
            padding: 40px 20px;
        }

        .container {
            max-width: 850px;
            margin: auto;
            background: white;
            padding: 40px;
            border-radius: 18px;
            box-shadow:
                0 20px 60px rgba(0, 0, 0, 0.10);
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

        .header h1 {
            margin: 0;
            color: #1677a5;
        }

        .header p {
            color: #718096;
        }

        .section-title {
            margin-top: 30px;
            margin-bottom: 18px;
            color: #2d3748;
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 8px;
        }

        .grid {
            display: grid;
            grid-template-columns:
                repeat(2, 1fr);
            gap: 18px;
        }

        .field {
            display: flex;
            flex-direction: column;
        }

        .full {
            grid-column: 1 / -1;
        }

        label {
            font-weight: 600;
            margin-bottom: 7px;
            color: #2d3748;
        }

        input,
        select,
        textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #dbe4ec;
            border-radius: 9px;
            font-size: 14px;
            font-family: inherit;
        }

        textarea {
            min-height: 90px;
            resize: vertical;
        }

        input:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: #1677a5;
        }

        .error {
            background: #fff1f1;
            color: #b42318;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .actions {
            margin-top: 30px;
            display: flex;
            gap: 12px;
        }

        button,
        .back-link {
            flex: 1;
            padding: 14px;
            border-radius: 9px;
            text-align: center;
            text-decoration: none;
            font-weight: 600;
        }

        button {
            border: none;
            background: #1677a5;
            color: white;
            cursor: pointer;
        }

        .back-link {
            border: 1px solid #dbe4ec;
            color: #2d3748;
            background: white;
        }

        @media (max-width: 650px) {
            .grid {
                grid-template-columns: 1fr;
            }

            .full {
                grid-column: auto;
            }
        }
    </style>
</head>

<body>

<div class="container">

    <div class="header">
        <h1>DentalCare</h1>
        <p>Create your patient account</p>
    </div>

    <%
        String error =
                (String) request.getAttribute("error");

        if (error != null) {
    %>

    <div class="error">
        <%= error %>
    </div>

    <%
        }
    %>

    <form
        action="${pageContext.request.contextPath}/register"
        method="post">

        <h3 class="section-title">
            Account Information
        </h3>

        <div class="grid">

            <div class="field">
                <label>Username</label>
                <input
                    type="text"
                    name="username"
                    maxlength="50"
                    required>
            </div>

            <div class="field">
                <label>Email</label>
                <input
                    type="email"
                    name="email"
                    maxlength="150"
                    required>
            </div>

            <div class="field">
                <label>Password</label>
                <input
                    type="password"
                    name="password"
                    minlength="8"
                    required>
            </div>

            <div class="field">
                <label>Confirm Password</label>
                <input
                    type="password"
                    name="confirmPassword"
                    minlength="8"
                    required>
            </div>

        </div>


        <h3 class="section-title">
            Personal Information
        </h3>

        <div class="grid">

            <div class="field">
                <label>First Name</label>
                <input
                    type="text"
                    name="firstName"
                    maxlength="100"
                    required>
            </div>

            <div class="field">
                <label>Last Name</label>
                <input
                    type="text"
                    name="lastName"
                    maxlength="100"
                    required>
            </div>

            <div class="field">
                <label>Phone</label>
                <input
                    type="tel"
                    name="phone"
                    maxlength="20">
            </div>

            <div class="field">
                <label>Date of Birth</label>
                <input
                    type="date"
                    name="dateOfBirth">
            </div>

            <div class="field">
                <label>Gender</label>
                <select name="gender">
                    <option value="">Select</option>
                    <option value="Female">Female</option>
                    <option value="Male">Male</option>
                    <option value="Other">Other</option>
                    <option value="Prefer not to say">
                        Prefer not to say
                    </option>
                </select>
            </div>

            <div class="field full">
                <label>Address</label>
                <input
                    type="text"
                    name="address"
                    maxlength="255">
            </div>

        </div>


        <h3 class="section-title">
            Emergency Contact
        </h3>

        <div class="grid">

            <div class="field">
                <label>Contact Name</label>
                <input
                    type="text"
                    name="emergencyContactName"
                    maxlength="150">
            </div>

            <div class="field">
                <label>Contact Phone</label>
                <input
                    type="tel"
                    name="emergencyContactPhone"
                    maxlength="20">
            </div>

        </div>


        <h3 class="section-title">
            Additional Information
        </h3>

        <div class="field">
            <label>Medical Notes</label>

            <textarea
                name="medicalNotes"
                maxlength="2000"
                placeholder="Optional information to help the clinic prepare for your visit.">
            </textarea>
        </div>


        <div class="actions">

            <a
                class="back-link"
                href="${pageContext.request.contextPath}/login">
                Back to Login
            </a>

            <button type="submit">
                Create Patient Account
            </button>

        </div>

    </form>

</div>

</body>
</html>