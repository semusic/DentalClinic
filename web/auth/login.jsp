<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>DentalCare | Login</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: Arial, sans-serif;
            background: linear-gradient(
                135deg,
                #e8f8ff,
                #f7fbff
            );
        }

        .login-container {
            width: 420px;
            background: white;
            padding: 42px;
            border-radius: 18px;
            box-shadow:
                0 20px 60px rgba(0, 0, 0, 0.12);
        }

        .brand {
            text-align: center;
            margin-bottom: 30px;
        }

        .brand h1 {
            margin: 0;
            font-size: 30px;
            color: #1677a5;
        }

        .brand p {
            margin-top: 8px;
            color: #718096;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #2d3748;
        }

        input {
            width: 100%;
            padding: 13px 14px;
            border: 1px solid #dbe4ec;
            border-radius: 10px;
            font-size: 15px;
            outline: none;
        }

        input:focus {
            border-color: #1677a5;
        }

        button {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 10px;
            background: #1677a5;
            color: white;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }

        button:hover {
            opacity: 0.92;
        }

        .error {
            margin-bottom: 18px;
            padding: 12px;
            border-radius: 8px;
            background: #fff0f0;
            color: #b42318;
        }
    </style>
</head>

<body>

<div class="login-container">

    <div class="brand">
        <h1>DentalCare</h1>
        <p>Clinic Management Portal</p>
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

    <form action="${pageContext.request.contextPath}/login"
          method="post">

        <div class="form-group">
            <label for="username">
                Username
            </label>

            <input
                    type="text"
                    id="username"
                    name="username"
                    maxlength="50"
                    required
                    autocomplete="username">
        </div>

        <div class="form-group">
            <label for="password">
                Password
            </label>

            <input
                    type="password"
                    id="password"
                    name="password"
                    required
                    autocomplete="current-password">
        </div>

        <button type="submit">
            Sign In
        </button>

    </form>

</div>

</body>
</html>