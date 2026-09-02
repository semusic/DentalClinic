<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="com.dentalclinic.dto.AssistantVisitDTO" %>
<%@ page import="com.dentalclinic.model.PatientVisit" %>

<%
    List<AssistantVisitDTO> appointments =
            (List<AssistantVisitDTO>)
                    request.getAttribute("appointments");

    LocalDate selectedDate =
            (LocalDate)
                    request.getAttribute("selectedDate");

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
        DentalCare | Today's Visits
    </title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;

            font-family:
                Arial,
                sans-serif;

            background: #f5f9fc;

            color: #263238;
        }

        .header {

            background: white;

            padding:
                20px 40px;

            border-bottom:
                1px solid #e5e7eb;

            display: flex;

            align-items: center;

            justify-content: space-between;
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

            max-width: 1150px;

            margin:
                35px auto;

            padding:
                0 20px;
        }

        .page-header {

            display: flex;

            justify-content:
                space-between;

            align-items:
                flex-end;

            gap: 20px;

            margin-bottom:
                25px;
        }

        .page-header h1 {

            margin:
                0 0 8px;

            color: #183b56;
        }

        .page-header p {

            margin: 0;

            color: #718096;
        }

        .date-form {

            display: flex;

            gap: 8px;

            align-items:
                center;
        }

        .date-input {

            padding:
                10px 12px;

            border:
                1px solid #dbe4ec;

            border-radius:
                8px;

            font-size:
                14px;
        }

        .date-button {

            border: none;

            padding:
                10px 15px;

            border-radius:
                8px;

            background:
                #1677a5;

            color: white;

            font-weight: 700;

            cursor: pointer;
        }

        .error {

            background:
                #fff0f0;

            color:
                #b42318;

            padding:
                14px 18px;

            border-radius:
                10px;

            margin-bottom:
                20px;
        }

        .summary {

            margin-bottom:
                20px;

            color:
                #718096;

            font-size:
                14px;
        }

        .queue {

            display:
                grid;

            gap:
                18px;
        }

        .visit-card {

            background:
                white;

            border:
                1px solid #edf2f7;

            border-radius:
                16px;

            padding:
                24px;

            box-shadow:
                0 8px 28px
                rgba(0, 0, 0, 0.05);
        }

        .card-top {

            display:
                flex;

            justify-content:
                space-between;

            align-items:
                flex-start;

            gap:
                20px;

            margin-bottom:
                20px;
        }

        .patient-name {

            font-size:
                21px;

            font-weight:
                700;

            color:
                #183b56;
        }

        .appointment-number {

            margin-top:
                5px;

            color:
                #718096;

            font-size:
                13px;
        }

        .status {

            padding:
                7px 13px;

            border-radius:
                20px;

            background:
                #eaf4fb;

            color:
                #1677a5;

            font-size:
                12px;

            font-weight:
                700;

            white-space:
                nowrap;
        }

        .details {

            display:
                grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap:
                14px;
        }

        .detail {

            background:
                #f8fafc;

            padding:
                14px;

            border-radius:
                10px;
        }

        .label {

            font-size:
                12px;

            color:
                #718096;

            margin-bottom:
                5px;
        }

        .value {

            color:
                #263238;

            font-weight:
                600;
        }

        .visit-status {

            margin-top:
                18px;

            padding:
                14px;

            background:
                #f8fafc;

            border-radius:
                10px;
        }

        .visit-state {

            font-weight:
                700;

            color:
                #183b56;
        }

        .action-area {

            margin-top:
                20px;

            display:
                flex;

            justify-content:
                flex-end;
        }

        .button {

            border:
                none;

            padding:
                11px 17px;

            border-radius:
                9px;

            text-decoration:
                none;

            font-weight:
                700;

            cursor:
                pointer;

            font-size:
                14px;
        }

        .primary {

            background:
                #1677a5;

            color:
                white;
        }

        .secondary {

            background:
                white;

            color:
                #1677a5;

            border:
                1px solid #cbd8e3;
        }

        .empty {

            background:
                white;

            padding:
                60px 30px;

            border-radius:
                16px;

            text-align:
                center;

            color:
                #718096;
        }

        @media (max-width: 900px) {

            .details {

                grid-template-columns:
                    repeat(2, 1fr);
            }
        }

        @media (max-width: 600px) {

            .page-header {

                flex-direction:
                    column;

                align-items:
                    stretch;
            }

            .date-form {

                width:
                    100%;
            }

            .date-input {

                flex:
                    1;
            }

            .details {

                grid-template-columns:
                    1fr;
            }

            .card-top {

                flex-direction:
                    column;
            }

            .header {

                padding:
                    18px 20px;
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
        href="${pageContext.request.contextPath}/assistant/dashboard">

        Dashboard

    </a>

</header>


<main class="container">

    <div class="page-header">

        <div>

            <h1>
                Patient Visits
            </h1>

            <p>
                Manage confirmed appointments and
                today's clinic visits.
            </p>

        </div>


        <form
            class="date-form"
            method="get"
            action="${pageContext.request.contextPath}/assistant/visits">

            <input
                class="date-input"
                type="date"
                name="date"
                value="<%= selectedDate %>">

            <button
                class="date-button"
                type="submit">

                View

            </button>

        </form>

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


    <div class="summary">

        Appointments for:

        <strong>
            <%= selectedDate %>
        </strong>

        &nbsp; • &nbsp;

        <%= appointments == null
                ? 0
                : appointments.size() %>

        appointment(s)

    </div>


    <%
        if (appointments == null
                || appointments.isEmpty()) {
    %>

        <div class="empty">

            <h2>
                No confirmed appointments
            </h2>

            <p>
                There are no confirmed appointments
                scheduled for this date.
            </p>

        </div>

    <%
        } else {
    %>

        <div class="queue">

    <%
            for (AssistantVisitDTO appointment :
                    appointments) {

                PatientVisit visit =
                        appointment.getPatientVisit();

                boolean hasVisit =
                        visit != null;

                boolean completed =
                        hasVisit
                        && visit.getConsultationCompletedAt()
                                != null;

                boolean checkedIn =
                        hasVisit
                        && visit.getCheckedInAt()
                                != null;

                boolean started =
                        hasVisit
                        && visit.getConsultationStartedAt()
                                != null;
    %>

            <article class="visit-card">

                <div class="card-top">

                    <div>

                        <div class="patient-name">
                            <%= appointment.getPatientName() %>
                        </div>

                        <div class="appointment-number">

                            Appointment #
                            <%= appointment.getAppointmentId() %>

                        </div>

                    </div>

                    <div class="status">

                        <%= appointment.getAppointmentStatus() %>

                    </div>

                </div>


                <div class="details">

                    <div class="detail">

                        <div class="label">
                            Service
                        </div>

                        <div class="value">
                            <%= appointment.getServiceName() %>
                        </div>

                    </div>


                    <div class="detail">

                        <div class="label">
                            Doctor
                        </div>

                        <div class="value">

                            <%= appointment.getDoctorName()
                                    == null
                                    ? "Not assigned"
                                    : appointment.getDoctorName() %>

                        </div>

                    </div>


                    <div class="detail">

                        <div class="label">
                            Date
                        </div>

                        <div class="value">
                            <%= appointment.getAppointmentDate() %>
                        </div>

                    </div>


                    <div class="detail">

                        <div class="label">
                            Time
                        </div>

                        <div class="value">

                            <%= appointment.getAppointmentTime()
                                    == null
                                    ? "Not specified"
                                    : appointment.getAppointmentTime() %>

                        </div>

                    </div>

                </div>


                <div class="visit-status">

                    <div class="label">
                        Visit Status
                    </div>


                    <div class="visit-state">

                    <%
                        if (!hasVisit) {
                    %>

                        Visit not created yet.

                    <%
                        } else if (completed) {
                    %>

                        Consultation completed.

                    <%
                        } else if (started) {
                    %>

                        Consultation in progress.

                    <%
                        } else if (checkedIn) {
                    %>

                        Patient checked in.

                    <%
                        } else {
                    %>

                        Visit created — waiting for check-in.

                    <%
                        }
                    %>

                    </div>

                </div>


                <div class="action-area">

                <%
                    if (!hasVisit) {
                %>

                    <form
                        method="post"
                        action="${pageContext.request.contextPath}/assistant/visits">

                        <input
                            type="hidden"
                            name="action"
                            value="createVisit">

                        <input
                            type="hidden"
                            name="appointmentId"
                            value="<%= appointment.getAppointmentId() %>">

                        <button
                            type="submit"
                            class="button primary">

                            Create Visit

                        </button>

                    </form>

                <%
                    } else {
                %>

                    <a
                        class="button secondary"
                        href="${pageContext.request.contextPath}/assistant/visits?visitId=<%= visit.getVisitId() %>">

                        Open Visit

                    </a>

                <%
                    }
                %>

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