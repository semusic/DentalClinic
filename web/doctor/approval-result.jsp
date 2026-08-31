<%@ page contentType="text/html;charset=UTF-8" %>

<%
    String decision =
            (String) request.getAttribute("decision");

    String title = "Decision Recorded";
    String message =
            "The appointment decision has been recorded.";

    if ("APPROVED".equals(decision)) {

        title = "Appointment Approved";

        message =
                "The appointment has been approved successfully. "
                + "The clinic will continue the confirmation "
                + "and patient notification process.";

    } else if ("REJECTED".equals(decision)) {

        title = "Appointment Rejected";

        message =
                "The appointment has been rejected and "
                + "the decision has been recorded.";

    } else if ("RESCHEDULE_REQUIRED".equals(decision)) {

        title = "Reschedule Requested";

        message =
                "A request has been made to arrange a "
                + "different appointment time.";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        DentalCare | <%= title %>
    </title>

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

            background: #f5f9fc;
        }

        .card {
            width: 520px;
            max-width: 90%;

            background: white;

            padding: 45px;

            border-radius: 20px;

            text-align: center;

            box-shadow:
                0 15px 45px rgba(0, 0, 0, 0.08);
        }

        .brand {
            color: #1677a5;
            font-size: 25px;
            font-weight: 700;

            margin-bottom: 25px;
        }

        .icon {
            width: 70px;
            height: 70px;

            margin: 0 auto 20px;

            display: flex;
            align-items: center;
            justify-content: center;

            border-radius: 50%;

            background: #e7f7ef;
            color: #16834b;

            font-size: 36px;
            font-weight: bold;
        }

        h1 {
            color: #183b56;
            margin-bottom: 15px;
        }

        p {
            color: #718096;
            line-height: 1.7;
        }

        .decision {
            margin-top: 20px;

            display: inline-block;

            padding: 9px 17px;

            border-radius: 20px;

            background: #eaf4fb;

            color: #1677a5;

            font-weight: 700;
            font-size: 13px;
        }

    </style>

</head>

<body>

<div class="card">

    <div class="brand">
        DentalCare
    </div>

    <div class="icon">
        ✓
    </div>

    <h1>
        <%= title %>
    </h1>

    <p>
        <%= message %>
    </p>

    <div class="decision">
        Decision: <%= decision %>
    </div>

</div>

</body>

</html>