<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.dto.CashierVisitDTO" %>

<%
    List<CashierVisitDTO> visits =
            (List<CashierVisitDTO>)
                    request.getAttribute("visits");

    String error =
            (String)
                    request.getAttribute("error");
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        DentalCare | Cashier
    </title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f5f9fc;
            color: #263238;
        }

        .header {
            background: white;
            padding: 20px 40px;
            border-bottom: 1px solid #e5e7eb;

            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .brand {
            color: #1677a5;
            font-size: 25px;
            font-weight: 700;
        }

        .dashboard {
            color: #1677a5;
            text-decoration: none;
            font-weight: 600;
        }

        .container {
            max-width: 1100px;
            margin: 35px auto;
            padding: 0 20px;
        }

        h1 {
            margin: 0 0 8px;
            color: #183b56;
        }

        .subtitle {
            color: #718096;
            margin-bottom: 25px;
        }

        .alert {
            padding: 14px 18px;
            border-radius: 10px;
            margin-bottom: 20px;

            background: #fff0f0;
            color: #b42318;
        }

        .queue {
            display: grid;
            gap: 18px;
        }

        .card {
            background: white;
            border-radius: 16px;
            padding: 24px;

            border: 1px solid #edf2f7;

            box-shadow:
                0 8px 28px
                rgba(0, 0, 0, 0.05);

            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 25px;
        }

        .patient {
            font-size: 21px;
            font-weight: 700;
            color: #183b56;
        }

        .meta {
            margin-top: 8px;
            color: #718096;
            font-size: 13px;
            line-height: 1.7;
        }

        .status {
            display: inline-block;
            margin-top: 10px;

            padding: 7px 12px;

            border-radius: 20px;

            background: #edf9f2;
            color: #18794e;

            font-size: 12px;
            font-weight: 700;
        }

        .button {
            display: inline-block;

            padding: 11px 18px;

            background: #1677a5;
            color: white;

            text-decoration: none;

            border-radius: 9px;

            font-weight: 700;

            white-space: nowrap;
        }

        .empty {
            background: white;
            padding: 60px 30px;

            border-radius: 16px;

            text-align: center;

            color: #718096;

            box-shadow:
                0 8px 28px
                rgba(0, 0, 0, 0.05);
        }

        @media (max-width: 700px) {

            .card {
                flex-direction: column;
                align-items: flex-start;
            }

            .header {
                padding: 18px 20px;
            }
        }

    </style>

</head>

<body>

<header class="header">

    <div class="brand">
        DentalCare
    </div>

    <a
        class="dashboard"
        href="${pageContext.request.contextPath}/cashier/dashboard">

        Dashboard

    </a>

</header>


<main class="container">

    <h1>
        Ready for Billing
    </h1>

    <div class="subtitle">

        Completed patient visits waiting for
        invoice generation.

    </div>


    <%
        if (error != null
                && !error.isBlank()) {
    %>

        <div class="alert">
            <%= error %>
        </div>

    <%
        }
    %>


    <%
        if (visits == null
                || visits.isEmpty()) {
    %>

        <div class="empty">

            <h2>
                No visits waiting for billing
            </h2>

            <p>
                Completed visits will appear here
                when they are ready for invoicing.
            </p>

        </div>

    <%
        } else {
    %>

        <div class="queue">

        <%
            for (CashierVisitDTO visit :
                    visits) {
        %>

            <div class="card">

                <div>

                    <div class="patient">

                        <%= visit.getPatientName() %>

                    </div>


                    <div class="meta">

                        Visit #
                        <%= visit.getVisitId() %>

                        <br>

                        Appointment #
                        <%= visit.getAppointmentId() %>

                        <br>

                        Doctor:
                        <%= visit.getDoctorName() %>

                        <br>

                        Completed:
                        <%= visit.getConsultationCompletedAt() %>

                    </div>


                    <div class="status">

                        READY FOR BILLING

                    </div>

                </div>


                <a
                    class="button"
                    href="${pageContext.request.contextPath}/cashier/invoices?visitId=<%= visit.getVisitId() %>">

                    Review Bill

                </a>

            </div>

        <%
            }
        %>

        </div>

    <%
        }
    %>

</main>

</body>

</html>