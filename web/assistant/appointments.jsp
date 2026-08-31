<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.dto.AppointmentReviewDTO" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        DentalCare | Appointment Requests
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
            font-size: 25px;
            font-weight: 700;
            color: #1677a5;
        }

        .back-link {
            text-decoration: none;
            color: #1677a5;
            font-weight: 600;
        }

        .container {
            max-width: 1200px;
            margin: 35px auto;
            padding: 0 20px;
        }

        .page-header {
            margin-bottom: 30px;
        }

        .page-header h1 {
            margin-bottom: 8px;
            color: #183b56;
        }

        .page-header p {
            color: #718096;
        }

        .queue {
            display: grid;
            gap: 20px;
        }

        .appointment-card {
            background: white;
            border-radius: 16px;
            padding: 25px;

            box-shadow:
                0 8px 28px rgba(0, 0, 0, 0.06);

            border: 1px solid #edf2f7;
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
            margin-bottom: 20px;
        }

        .appointment-number {
            font-size: 14px;
            color: #718096;
        }

        .patient-name {
            font-size: 22px;
            font-weight: 700;
            color: #183b56;
            margin-top: 5px;
        }

        .status {
            padding: 7px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
            background: #fff6df;
            color: #946200;
        }

        .details {
            display: grid;
            grid-template-columns:
                repeat(3, 1fr);
            gap: 18px;
        }

        .detail {
            padding: 15px;
            background: #f8fafc;
            border-radius: 10px;
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
            margin-top: 18px;
            padding: 17px;
            background: #f8fafc;
            border-radius: 10px;
        }

        .reason-text {
            margin-top: 7px;
            line-height: 1.6;
            color: #4a5568;
        }

        .footer {
            margin-top: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .created {
            font-size: 13px;
            color: #718096;
        }

        .review-button {
            display: inline-block;
            padding: 11px 18px;
            border-radius: 9px;
            background: #1677a5;
            color: white;
            text-decoration: none;
            font-weight: 600;
        }

        .empty {
            background: white;
            padding: 60px 30px;
            border-radius: 16px;
            text-align: center;
            color: #718096;
        }

        @media (max-width: 800px) {

            .details {
                grid-template-columns: 1fr;
            }

            .header {
                padding: 18px 20px;
            }

            .card-header {
                flex-direction: column;
            }

            .footer {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
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
        class="back-link"
        href="${pageContext.request.contextPath}/assistant/dashboard">

        Dashboard

    </a>

</header>


<main class="container">

    <div class="page-header">

        <h1>
            Appointment Requests
        </h1>

        <p>
            Review patient appointment requests and
            prepare them for doctor approval.
        </p>

    </div>


    <%
        List<AppointmentReviewDTO> reviews =
                (List<AppointmentReviewDTO>)
                        request.getAttribute(
                                "appointmentReviews"
                        );

        if (reviews == null
                || reviews.isEmpty()) {
    %>

        <div class="empty">

            <h2>
                No appointment requests
            </h2>

            <p>
                There are currently no active appointment
                requests requiring review.
            </p>

        </div>

    <%
        } else {
    %>

        <div class="queue">

    <%
            for (AppointmentReviewDTO review :
                    reviews) {
    %>

            <article class="appointment-card">

                <div class="card-header">

                    <div>

                        <div class="appointment-number">
                            Appointment #
                            <%= review.getAppointmentId() %>
                        </div>

                        <div class="patient-name">
                            <%= review.getPatientName() %>
                        </div>

                    </div>

                    <div class="status">
                        <%= review.getStatusCode() %>
                    </div>

                </div>


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

                            <%
                                if (review.getDoctorName()
                                        != null) {
                            %>

                                <%= review.getDoctorName() %>

                            <%
                                } else {
                            %>

                                Not assigned

                            <%
                                }
                            %>

                        </div>

                    </div>


                    <div class="detail">

                        <div class="label">
                            Specialization
                        </div>

                        <div class="value">

                            <%
                                if (review.getDoctorSpecialization()
                                        != null) {
                            %>

                                <%= review.getDoctorSpecialization() %>

                            <%
                                } else {
                            %>

                                —

                            <%
                                }
                            %>

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

                            <%
                                if (review.getRequestedTime()
                                        != null) {
                            %>

                                <%= review.getRequestedTime() %>

                            <%
                                } else {
                            %>

                                Not specified

                            <%
                                }
                            %>

                        </div>

                    </div>


                    <div class="detail">

                        <div class="label">
                            Patient Contact
                        </div>

                        <div class="value">

                            <%
                                String phone =
                                        review.getPatientPhone();

                                String email =
                                        review.getPatientEmail();

                                if (phone != null
                                        && !phone.isBlank()) {
                            %>

                                <%= phone %>

                            <%
                                } else {
                            %>

                                <%= email %>

                            <%
                                }
                            %>

                        </div>

                    </div>

                </div>


                <div class="reason">

                    <div class="label">
                        Reason for Visit
                    </div>

                    <div class="reason-text">

                        <%
                            String reason =
                                    review.getPatientReason();

                            if (reason != null
                                    && !reason.isBlank()) {
                        %>

                            <%= reason %>

                        <%
                            } else {
                        %>

                            No reason provided.

                        <%
                            }
                        %>

                    </div>

                </div>


                <div class="footer">

                    <div class="created">

                        Submitted:
                        <%= review.getCreatedAt() %>

                    </div>

                    <a
                        class="review-button"
                        href="${pageContext.request.contextPath}/assistant/appointments?action=review&id=<%= review.getAppointmentId() %>">

                        Review Request

                    </a>
                </div>

            </article>

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