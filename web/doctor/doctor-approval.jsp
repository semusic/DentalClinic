<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dentalclinic.dto.DoctorApprovalReviewDTO" %>

<%
    DoctorApprovalReviewDTO approval =
            (DoctorApprovalReviewDTO)
                    request.getAttribute(
                            "approval"
                    );

    String token =
            (String) request.getAttribute("token");

    String error =
            (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        DentalCare | Doctor Approval
    </title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;

            font-family: Arial, sans-serif;

            background: #f5f9fc;
            color: #263238;

            padding: 40px 20px;
        }

        .container {
            max-width: 850px;
            margin: 0 auto;
        }

        .brand {
            text-align: center;
            color: #1677a5;
            font-size: 27px;
            font-weight: 700;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            padding: 35px;
            border-radius: 18px;

            box-shadow:
                0 14px 40px rgba(0, 0, 0, 0.08);
        }

        h1 {
            margin-top: 0;
            color: #183b56;
        }

        .intro {
            color: #718096;
            line-height: 1.7;
            margin-bottom: 28px;
        }

        .section {
            margin-top: 28px;
        }

        .section h2 {
            font-size: 18px;
            color: #1677a5;

            border-bottom: 1px solid #e5e7eb;

            padding-bottom: 9px;
        }

        .details {
            display: grid;
            grid-template-columns:
                repeat(2, 1fr);

            gap: 15px;
        }

        .detail {
            background: #f8fafc;
            border-radius: 10px;
            padding: 15px;
        }

        .label {
            color: #718096;
            font-size: 12px;
            margin-bottom: 5px;
        }

        .value {
            font-weight: 600;
            line-height: 1.5;
        }

        .reason {
            background: #f8fafc;
            padding: 17px;
            border-radius: 10px;
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

        .decision-note {
            width: 100%;
            min-height: 110px;
            resize: vertical;

            padding: 13px;

            border: 1px solid #dbe4ec;
            border-radius: 9px;

            font-family: inherit;
            font-size: 14px;
        }

        .decision-note:focus {
            outline: none;
            border-color: #1677a5;
        }

        .actions {
            margin-top: 30px;

            display: grid;
            grid-template-columns:
                repeat(3, 1fr);

            gap: 12px;
        }

        .action-button {
            border: none;
            padding: 14px 10px;

            border-radius: 9px;

            color: white;

            font-weight: 700;
            cursor: pointer;
            font-size: 14px;
        }

        .approve {
            background: #16834b;
        }

        .reject {
            background: #c93b3b;
        }

        .reschedule {
            background: #b7791f;
        }

        .security {
            margin-top: 25px;
            padding: 14px;

            background: #f8fafc;

            border-radius: 9px;

            color: #718096;
            font-size: 13px;
            line-height: 1.6;
        }

        @media (max-width: 700px) {

            .details {
                grid-template-columns: 1fr;
            }

            .actions {
                grid-template-columns: 1fr;
            }
        }

    </style>

</head>

<body>

<div class="container">

    <div class="brand">
        DentalCare
    </div>


    <div class="card">

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
            if (approval != null) {
        %>

        <h1>
            Doctor Approval Request
        </h1>

        <p class="intro">
            Please review the appointment information
            below and select the appropriate decision.
            No clinic account login is required.
        </p>


        <div class="section">

            <h2>
                Doctor
            </h2>

            <div class="details">

                <div class="detail">

                    <div class="label">
                        Doctor
                    </div>

                    <div class="value">
                        <%= approval.getDoctorName() %>
                    </div>

                </div>

                <div class="detail">

                    <div class="label">
                        Specialization
                    </div>

                    <div class="value">
                        <%= approval.getDoctorSpecialization() %>
                    </div>

                </div>

            </div>

        </div>


        <div class="section">

            <h2>
                Patient
            </h2>

            <div class="details">

                <div class="detail">

                    <div class="label">
                        Patient
                    </div>

                    <div class="value">
                        <%= approval.getPatientName() %>
                    </div>

                </div>

                <div class="detail">

                    <div class="label">
                        Contact
                    </div>

                    <div class="value">
                        <%= approval.getPatientPhone() %>
                    </div>

                </div>

                <div class="detail">

                    <div class="label">
                        Email
                    </div>

                    <div class="value">
                        <%= approval.getPatientEmail() %>
                    </div>

                </div>

            </div>

        </div>


        <div class="section">

            <h2>
                Appointment
            </h2>

            <div class="details">

                <div class="detail">

                    <div class="label">
                        Service
                    </div>

                    <div class="value">
                        <%= approval.getServiceName() %>
                    </div>

                </div>

                <div class="detail">

                    <div class="label">
                        Appointment Date
                    </div>

                    <div class="value">
                        <%= approval.getRequestedDate() %>
                    </div>

                </div>

                <div class="detail">

                    <div class="label">
                        Requested Time
                    </div>

                    <div class="value">
                        <%= approval.getRequestedTime() %>
                    </div>

                </div>

                <div class="detail">

                    <div class="label">
                        Current Status
                    </div>

                    <div class="value">
                        <%= approval.getCurrentStatus() %>
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
                    if (approval.getPatientReason() != null
                            && !approval.getPatientReason()
                                    .isBlank()) {
                %>

                    <%= approval.getPatientReason() %>

                <%
                    } else {
                %>

                    No reason was provided.

                <%
                    }
                %>

            </div>

        </div>


        <div class="section">

            <h2>
                Doctor's Decision Note
            </h2>

            <form
                method="post"
                action="${pageContext.request.contextPath}/doctor/approval">

                <input
                    type="hidden"
                    name="token"
                    value="<%= token %>">

                <textarea
                    class="decision-note"
                    name="decisionNote"
                    maxlength="1000"
                    placeholder="Optional note regarding your decision."></textarea>


                <div class="actions">

                    <button
                        class="action-button approve"
                        type="submit"
                        name="decision"
                        value="APPROVED">

                        Approve Appointment

                    </button>


                    <button
                        class="action-button reject"
                        type="submit"
                        name="decision"
                        value="REJECTED">

                        Reject Appointment

                    </button>


                    <button
                        class="action-button reschedule"
                        type="submit"
                        name="decision"
                        value="RESCHEDULE_REQUIRED">

                        Request Reschedule

                    </button>

                </div>

            </form>

        </div>


        <div class="security">

            This secure approval link is temporary and
            can only be used once. Do not share the link
            with anyone else.

        </div>


        <%
            }
        %>

    </div>

</div>

</body>

</html>