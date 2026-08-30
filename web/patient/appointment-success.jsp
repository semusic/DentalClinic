<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        DentalCare | Request Submitted
    </title>

    <style>

        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: Arial, sans-serif;
            background: #f5f9fc;
        }

        .card {
            width: 500px;
            max-width: 90%;
            background: white;
            padding: 45px;
            text-align: center;
            border-radius: 18px;
            box-shadow:
                0 15px 40px rgba(0, 0, 0, 0.08);
        }

        .icon {
            font-size: 60px;
            margin-bottom: 20px;
        }

        h1 {
            color: #1677a5;
        }

        p {
            color: #718096;
            line-height: 1.7;
        }

        .status {
            display: inline-block;
            padding: 9px 18px;
            border-radius: 20px;
            background: #fff7e6;
            color: #9a6700;
            font-weight: 700;
            margin: 15px 0;
        }

        a {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 20px;
            background: #1677a5;
            color: white;
            border-radius: 9px;
            text-decoration: none;
            font-weight: 600;
        }

    </style>

</head>

<body>

<div class="card">

    <div class="icon">
        ✓
    </div>

    <h1>
        Appointment Request Submitted
    </h1>

    <p>
        Your appointment request has been
        successfully submitted to DentalCare.
    </p>

    <div class="status">
        PENDING DOCTOR REVIEW
    </div>

    <p>
        The clinic assistant will review your
        request before it is sent for doctor approval.
        You will be notified once a decision is made.
    </p>

    <a href="${pageContext.request.contextPath}/patient/dashboard">
        Back to Dashboard
    </a>

</div>

</body>

</html>