<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dentalclinic.dto.AppointmentReviewDTO" %>

<%
    AppointmentReviewDTO review =
            (AppointmentReviewDTO)
                    request.getAttribute(
                            "appointmentReview"
                    );

    String error =
            (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>DentalCare | Review Appointment</title>

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

        .container {
            max-width: 900px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .card {
            background: white;
            border-radius: 18px;
            padding: 35px;
            box-shadow:
                0 12px 35px rgba(0, 0, 0, 0.07);
        }

        .title {
            margin-top: 0;
            color: #183b56;
        }

        .status {
            display: inline-block;
            margin: 10px 0 25px;
            padding: 8px 15px;
            border-radius: 20px;
            background: #fff6df;
            color: #946200;
            font-weight: 700;
            font-size: 13px;
        }

        .section {
            margin-top: 28px;
        }

        .section h2 {
            font-size: 18px;
            color: #1677a5;
            border-bottom: 1px solid #e5e7eb;
            padding-bottom: 8px;
        }

        .details {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }

        .detail {
            background: #f8fafc;
            border-radius: 10px;
            padding: 15px;
        }

        .label {
            font-size: 12px;
            color: #718096;
            margin-bottom: 5px;
        }

        .value {
            font-weight: 600;
            color: #263238;
        }

        .reason {
            background: #f8fafc;
            border-radius: 10px;
            padding: 18px;
            line-height: 1.7;
            color: #4a5568;
        }

        .error {
            background: #fff0f0;
            color: #b42318;
            padding: 13px;
            border-radius: 9px;
            margin-bottom: 20px;
        }

        .actions {
            display: flex;
            gap: 12px;
            margin-top: 30px;
        }

        .button {
            border: none;
            padding: 13px 20px;
            border-radius: 9px;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
            text-align: center;
        }

        .primary {
            background: #1677a5;
            color: white;
        }

        .secondary {
            background: white;
            color: #374151;
            border: 1px solid #dbe4ec;
        }

        @media (max-width: 650px) {

            .details {
                grid-template-columns: 1fr;
            }

            .actions {
                flex-direction: column;
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
        class="button secondary"
        href="${pageContext.request.contextPath}/assistant/appointments">

        Back to Queue

    </a>

</header>


<div class="container">

    <div class="card">

        <h1 class="title">
            Appointment Review
        </h1>

        <%
            if (error != null) {
        %>

        <div class="error">
            <%= error %>
        </div>

        <%
            }
        %>


        <%
            if (review != null) {
        %>

        <div class="status">
            <%= review.getStatusCode() %>
        </div>


        <div class="section">

            <h2>
                Patient Information
            </h2>

            <div class="details">

                <div class="detail">

                    <div class="label">
                        Patient
                    </div>

                    <div class="value">
                        <%= review.getPatientName() %>
                    </div>

                </div>

                <div class="detail">

                    <div class="label">
                        Phone
                    </div>

                    <div class="value">
                        <%= review.getPatientPhone() %>
                    </div>

                </div>

                <div class="detail">

                    <div class="label">
                        Email
                    </div>

                    <div class="value">
                        <%= review.getPatientEmail() %>
                    </div>

                </div>

            </div>

        </div>


        <div class="section">

            <h2>
                Appointment Information
            </h2>

            <div class="details">

                <div class="detail">

                    <div class="label">
                        Service
                    </div>

                    <div class="value">
                        <%= review.getServiceName() %>
                    </div>

                </div>

                <div class="detail">

                    <div class="label">
                        Doctor
                    </div>

                    <div class="value">
                        <%= review.getDoctorName() == null
                                ? "Not assigned"
                                : review.getDoctorName() %>
                    </div>

                </div>

                <div class="detail">

                    <div class="label">
                        Specialization
                    </div>

                    <div class="value">
                        <%= review.getDoctorSpecialization() == null
                                ? "—"
                                : review.getDoctorSpecialization() %>
                    </div>

                </div>

                <div class="detail">

                    <div class="label">
                        Requested Date
                    </div>

                    <div class="value">
                        <%= review.getRequestedDate() %>
                    </div>

                </div>

                <div class="detail">

                    <div class="label">
                        Requested Time
                    </div>

                    <div class="value">
                        <%= review.getRequestedTime() == null
                                ? "Not specified"
                                : review.getRequestedTime() %>
                    </div>

                </div>

                <div class="detail">

                    <div class="label">
                        Appointment ID
                    </div>

                    <div class="value">
                        #<%= review.getAppointmentId() %>
                    </div>

                </div>

            </div>

        </div>


        <div class="section">

            <h2>
                Reason for Visit
            </h2>

            <div class="reason">

                <%
                    if (review.getPatientReason() != null
                            && !review.getPatientReason()
                                    .isBlank()) {
                %>

                    <%= review.getPatientReason() %>

                <%
                    } else {
                %>

                    No reason provided.

                <%
                    }
                %>

            </div>

        </div>


        <div class="actions">

            <%
                if ("PENDING".equals(
                        review.getStatusCode())) {
            %>

                <form
                    method="post"
                    action="${pageContext.request.contextPath}/assistant/appointments">

                    <input
                        type="hidden"
                        name="action"
                        value="startReview">

                    <input
                        type="hidden"
                        name="id"
                        value="<%= review.getAppointmentId() %>">

                    <button
                        type="submit"
                        class="button primary">

                        Start Review

                    </button>

                </form>

            <%
                }

                if ("UNDER_REVIEW".equals(
                        review.getStatusCode())) {
            %>

                <form
                    method="post"
                    action="${pageContext.request.contextPath}/assistant/appointments">

                    <input
                        type="hidden"
                        name="action"
                        value="sendToDoctor">

                    <input
                        type="hidden"
                        name="id"
                        value="<%= review.getAppointmentId() %>">

                    <button
                        type="submit"
                        class="button primary">

                        Send to Doctor for Approval

                    </button>

                </form>

            <%
                }
            %>

        </div>

        <%
            }
        %>

    </div>

</div>

</body>

</html>