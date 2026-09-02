<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="com.dentalclinic.dto.CashierVisitDTO" %>

<%
    CashierVisitDTO visit =
            (CashierVisitDTO)
                    request.getAttribute("visit");

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
        DentalCare | Generate Invoice
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

        .container {
            max-width: 850px;
            margin: 45px auto;
            padding: 20px;
        }

        .card {
            background: white;
            padding: 30px;
            border-radius: 16px;

            box-shadow:
                0 8px 28px
                rgba(0, 0, 0, 0.05);
        }

        h1 {
            margin-top: 0;
            color: #183b56;
        }

        .subtitle {
            color: #718096;
            margin-bottom: 25px;
        }

        .details {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }

        .detail {
            padding: 16px;
            border-radius: 10px;
            background: #f8fafc;
        }

        .label {
            font-size: 12px;
            color: #718096;
            margin-bottom: 5px;
        }

        .value {
            font-weight: 700;
            color: #263238;
        }

        .notice {
            margin-top: 25px;
            padding: 16px;
            border-radius: 10px;
            background: #eaf4fb;
            color: #1677a5;
        }

        .button {
            border: none;

            margin-top: 25px;

            padding:
                12px 20px;

            border-radius:
                9px;

            background:
                #1677a5;

            color:
                white;

            font-weight:
                700;

            cursor:
                pointer;

            font-size:
                14px;
        }

        .back {
            display: inline-block;

            margin-top: 15px;

            color:
                #1677a5;

            text-decoration:
                none;
        }

        .error {
            margin-bottom: 20px;

            padding: 14px;

            background: #fff0f0;

            color: #b42318;

            border-radius: 10px;
        }

        @media (max-width: 600px) {

            .details {
                grid-template-columns: 1fr;
            }

        }

    </style>

</head>

<body>

<main class="container">

    <div class="card">

        <h1>
            Review & Generate Invoice
        </h1>

        <div class="subtitle">

            The consultation has been completed.
            The invoice will be generated from the
            services actually recorded during the visit.

        </div>


        <%
            if (error != null
                    && !error.isBlank()) {
        %>

            <div class="error">
                <%= error %>
            </div>

        <%
            }
        %>


        <div class="details">

            <div class="detail">

                <div class="label">
                    Patient
                </div>

                <div class="value">

                    <%= visit.getPatientName() %>

                </div>

            </div>


            <div class="detail">

                <div class="label">
                    Doctor
                </div>

                <div class="value">

                    <%= visit.getDoctorName() %>

                </div>

            </div>


            <div class="detail">

                <div class="label">
                    Visit ID
                </div>

                <div class="value">

                    <%= visit.getVisitId() %>

                </div>

            </div>


            <div class="detail">

                <div class="label">
                    Completed
                </div>

                <div class="value">

                    <%= visit.getConsultationCompletedAt() %>

                </div>

            </div>

        </div>


        <div class="notice">

            The system will automatically calculate the
            invoice from all services recorded for this
            visit.

        </div>


        <form
            method="post"
            action="${pageContext.request.contextPath}/cashier/invoices">

            <input
                type="hidden"
                name="action"
                value="generateInvoice">

            <input
                type="hidden"
                name="visitId"
                value="<%= visit.getVisitId() %>">

            <button
                type="submit"
                class="button">

                Generate Invoice

            </button>

        </form>


        <br>

        <a
            class="back"
            href="${pageContext.request.contextPath}/cashier/invoices">

            ← Back to billing queue

        </a>

    </div>

</main>

</body>

</html>