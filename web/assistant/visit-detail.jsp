<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.dto.AssistantVisitDTO" %>
<%@ page import="com.dentalclinic.model.PatientVisit" %>
<%@ page import="com.dentalclinic.model.Service" %>
<%@ page import="com.dentalclinic.model.VisitService" %>

<%
    AssistantVisitDTO appointment =
            (AssistantVisitDTO)
                    request.getAttribute("appointment");

    PatientVisit visit =
            (PatientVisit)
                    request.getAttribute("visit");

    List<Service> availableServices =
            (List<Service>)
                    request.getAttribute(
                            "availableServices"
                    );

    List<VisitService> visitServices =
            (List<VisitService>)
                    request.getAttribute(
                            "visitServices"
                    );

    String error =
            (String)
                    request.getAttribute("error");

    String success =
            (String)
                    request.getAttribute("success");

    boolean hasVisit =
            visit != null;

    boolean checkedIn =
            hasVisit
            && visit.getCheckedInAt() != null;

    boolean consultationStarted =
            hasVisit
            && visit.getConsultationStartedAt() != null;

    boolean consultationCompleted =
            hasVisit
            && visit.getConsultationCompletedAt() != null;

    boolean medicinePrescribed =
            hasVisit
            && visit.isMedicinePrescribed();
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>DentalCare | Patient Visit</title>

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

        .back-link {
            text-decoration: none;
            color: #1677a5;
            font-weight: 600;
        }

        .container {
            max-width: 1100px;
            margin: 35px auto;
            padding: 0 20px;
        }

        .page-title {
            margin-bottom: 25px;
        }

        .page-title h1 {
            margin: 0 0 8px;
            color: #183b56;
        }

        .page-title p {
            margin: 0;
            color: #718096;
        }

        .alert {
            padding: 14px 18px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .alert-error {
            background: #fff0f0;
            color: #b42318;
        }

        .alert-success {
            background: #edf9f2;
            color: #18794e;
        }

        .card {
            background: white;
            border: 1px solid #edf2f7;
            border-radius: 16px;
            padding: 25px;
            margin-bottom: 20px;

            box-shadow:
                0 8px 28px rgba(0, 0, 0, 0.05);
        }

        .card h2 {
            margin: 0 0 20px;
            color: #183b56;
            font-size: 20px;
        }

        .patient-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
        }

        .patient-name {
            font-size: 25px;
            font-weight: 700;
            color: #183b56;
        }

        .appointment-number {
            margin-top: 6px;
            color: #718096;
            font-size: 13px;
        }

        .status {
            padding: 8px 14px;
            border-radius: 20px;
            background: #eaf4fb;
            color: #1677a5;
            font-size: 12px;
            font-weight: 700;
        }

        .details {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 14px;
            margin-top: 22px;
        }

        .detail {
            padding: 15px;
            background: #f8fafc;
            border-radius: 10px;
        }

        .label {
            color: #718096;
            font-size: 12px;
            margin-bottom: 6px;
        }

        .value {
            color: #263238;
            font-weight: 600;
        }

        .timeline {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 10px;
        }

        .stage {
            padding: 15px;
            border-radius: 10px;
            background: #f3f4f6;
            color: #718096;
            text-align: center;
            font-size: 13px;
            font-weight: 600;
        }

        .stage.complete {
            background: #edf9f2;
            color: #18794e;
        }

        .button-row {
            margin-top: 20px;

            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .button {
            border: none;
            border-radius: 9px;
            padding: 11px 17px;
            font-weight: 700;
            cursor: pointer;
            font-size: 14px;
        }

        .primary {
            background: #1677a5;
            color: white;
        }

        .success-button {
            background: #18794e;
            color: white;
        }

        .secondary {
            background: #eef2f5;
            color: #374151;
        }

        .danger {
            background: #fff0f0;
            color: #b42318;
        }

        .service-description {
            margin-top: -10px;
            margin-bottom: 20px;
            color: #718096;
        }

        .service-form {
            display: grid;
            grid-template-columns: 2fr 100px 2fr auto;
            gap: 10px;
            align-items: end;
        }

        select,
        input,
        textarea {
            width: 100%;
            padding: 11px 12px;
            border: 1px solid #d7e0e7;
            border-radius: 8px;
            font-family: inherit;
            background: white;
        }

        textarea {
            min-height: 120px;
            resize: vertical;
        }

        .service-list {
            margin-top: 22px;
        }

        .service-item {
            padding: 16px 0;
            border-bottom: 1px solid #edf2f7;

            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
        }

        .service-item:last-child {
            border-bottom: none;
        }

        .service-name {
            font-weight: 700;
            color: #183b56;
        }

        .service-meta {
            margin-top: 5px;
            color: #718096;
            font-size: 12px;
        }

        .service-total {
            white-space: nowrap;
            font-weight: 700;
        }

        .empty {
            padding: 20px;
            background: #f8fafc;
            border-radius: 10px;
            color: #718096;
            text-align: center;
        }

        .medicine-box {
            padding: 18px;
            background: #f8fafc;
            border-radius: 12px;
        }

        .medicine-status {
            margin-bottom: 15px;
            font-weight: 700;
            color: #183b56;
        }

        .radio-row {
            display: flex;
            gap: 18px;
        }

        .radio-option {
            display: flex;
            align-items: center;
            gap: 7px;
            cursor: pointer;
        }

        .radio-option input {
            width: auto;
        }

        .complete-note {
            margin-top: 18px;
        }

        .finished-message {
            padding: 18px;
            background: #edf9f2;
            color: #18794e;
            border-radius: 10px;
            font-weight: 600;
        }

        @media (max-width: 900px) {

            .details {
                grid-template-columns: repeat(2, 1fr);
            }

            .timeline {
                grid-template-columns: repeat(2, 1fr);
            }

            .service-form {
                grid-template-columns: 1fr 100px;
            }
        }

        @media (max-width: 600px) {

            .header {
                padding: 18px 20px;
            }

            .patient-header {
                flex-direction: column;
            }

            .details,
            .timeline,
            .service-form {
                grid-template-columns: 1fr;
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
        href="${pageContext.request.contextPath}/assistant/visits">

        ← Back to Visits

    </a>

</header>


<main class="container">

    <div class="page-title">

        <h1>
            Patient Visit
        </h1>

        <p>
            Manage today's patient visit and
            record services performed.
        </p>

    </div>


    <%
        if (error != null && !error.isBlank()) {
    %>

        <div class="alert alert-error">
            <%= error %>
        </div>

    <%
        }
    %>


    <%
        if (success != null && !success.isBlank()) {
    %>

        <div class="alert alert-success">
            <%= success %>
        </div>

    <%
        }
    %>


    <!-- PATIENT INFORMATION -->

    <section class="card">

        <div class="patient-header">

            <div>

                <div class="patient-name">
                    <%= appointment.getPatientName() %>
                </div>

                <div class="appointment-number">

                    Appointment #
                    <%= appointment.getAppointmentId() %>

                    <% if (hasVisit) { %>

                        &nbsp; • &nbsp;

                        Visit #
                        <%= visit.getVisitId() %>

                    <% } %>

                </div>

            </div>


            <div class="status">

                <%= appointment.getAppointmentStatus() %>

            </div>

        </div>


        <div class="details">

            <div class="detail">

                <div class="label">
                    Booked Service
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

    </section>


    <% if (!hasVisit) { %>

        <!-- CREATE VISIT -->

        <section class="card">

            <h2>
                Create Patient Visit
            </h2>

            <p>
                This confirmed appointment does not yet
                have a patient visit record.
            </p>

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

        </section>

    <% } else { %>


    <!-- VISIT PROGRESS -->

    <section class="card">

        <h2>
            Visit Progress
        </h2>

        <div class="timeline">

            <div class="stage complete">
                Visit Created
            </div>


            <div class="stage <%= checkedIn
                    ? "complete"
                    : "" %>">

                Checked In

            </div>


            <div class="stage <%= consultationStarted
                    ? "complete"
                    : "" %>">

                Consultation

            </div>


            <div class="stage <%= consultationCompleted
                    ? "complete"
                    : "" %>">

                Completed

            </div>

        </div>


        <div class="button-row">


            <% if (!checkedIn && !consultationCompleted) { %>

                <form
                    method="post"
                    action="${pageContext.request.contextPath}/assistant/visits">

                    <input
                        type="hidden"
                        name="action"
                        value="checkIn">

                    <input
                        type="hidden"
                        name="visitId"
                        value="<%= visit.getVisitId() %>">

                    <button
                        type="submit"
                        class="button primary">

                        Check In Patient

                    </button>

                </form>

            <% } %>


            <% if (checkedIn
                    && !consultationStarted
                    && !consultationCompleted) { %>

                <form
                    method="post"
                    action="${pageContext.request.contextPath}/assistant/visits">

                    <input
                        type="hidden"
                        name="action"
                        value="startConsultation">

                    <input
                        type="hidden"
                        name="visitId"
                        value="<%= visit.getVisitId() %>">

                    <button
                        type="submit"
                        class="button primary">

                        Start Consultation

                    </button>

                </form>

            <% } %>


        </div>

    </section>


    <!-- SERVICES -->

    <section class="card">

        <h2>
            Services Performed
        </h2>

        <p class="service-description">

            The assistant records additional services
            that were authorized and actually performed
            during the visit.

        </p>


        <% if (!consultationCompleted) { %>

        <form
            class="service-form"
            method="post"
            action="${pageContext.request.contextPath}/assistant/visits">

            <input
                type="hidden"
                name="action"
                value="addService">

            <input
                type="hidden"
                name="visitId"
                value="<%= visit.getVisitId() %>">


            <div>

                <label>
                    Service
                </label>

                <select
                    name="serviceId"
                    required>

                    <option value="">
                        Select service
                    </option>

                    <%
                        if (availableServices != null) {

                            for (Service service :
                                    availableServices) {
                    %>

                        <option
                            value="<%= service.getServiceId() %>">

                            <%= service.getServiceName() %>
                            —
                            LKR
                            <%= service.getStandardPrice() %>

                        </option>

                    <%
                            }
                        }
                    %>

                </select>

            </div>


            <div>

                <label>
                    Qty
                </label>

                <input
                    type="number"
                    name="quantity"
                    value="1"
                    min="1"
                    required>

            </div>


            <div>

                <label>
                    Note
                </label>

                <input
                    type="text"
                    name="notes"
                    maxlength="1000"
                    placeholder="Optional">

            </div>


            <button
                type="submit"
                class="button primary">

                Add Service

            </button>

        </form>

        <% } %>


        <div class="service-list">

        <%
            if (visitServices == null
                    || visitServices.isEmpty()) {
        %>

            <div class="empty">

                No services have been recorded yet.

            </div>

        <%
            } else {

                for (VisitService service :
                        visitServices) {
        %>

            <div class="service-item">

                <div>

                    <div class="service-name">

                        Service #<%= service.getServiceId() %>

                    </div>

                    <div class="service-meta">

                        Quantity:
                        <%= service.getQuantity() %>

                        &nbsp; • &nbsp;

                        Unit Price:
                        LKR <%= service.getUnitPrice() %>

                        <% if (service.getTreatmentNotes()
                                != null
                                && !service.getTreatmentNotes()
                                .isBlank()) { %>

                            &nbsp; • &nbsp;

                            <%= service.getTreatmentNotes() %>

                        <% } %>

                    </div>

                </div>


                <div class="service-total">

                    LKR
                    <%= service.getLineTotal() %>

                </div>

            </div>

        <%
                }
            }
        %>

        </div>

    </section>


    <!-- MEDICINE -->

    <section class="card">

        <h2>
            Medicine
        </h2>

        <div class="medicine-box">

            <div class="medicine-status">

                Medicine prescribed:

                <%= medicinePrescribed
                        ? "Yes"
                        : "No" %>

            </div>


            <% if (!consultationCompleted) { %>

                <form
                    method="post"
                    action="${pageContext.request.contextPath}/assistant/visits">

                    <input
                        type="hidden"
                        name="action"
                        value="medicine">

                    <input
                        type="hidden"
                        name="visitId"
                        value="<%= visit.getVisitId() %>">


                    <div class="radio-row">

                        <label class="radio-option">

                            <input
                                type="radio"
                                name="prescribed"
                                value="true"
                                <%= medicinePrescribed
                                        ? "checked"
                                        : "" %>>

                            Yes

                        </label>


                        <label class="radio-option">

                            <input
                                type="radio"
                                name="prescribed"
                                value="false"
                                <%= !medicinePrescribed
                                        ? "checked"
                                        : "" %>>

                            No

                        </label>

                    </div>


                    <div
                        style="
                            margin-top:15px;">

                        <button
                            type="submit"
                            class="button secondary">

                            Save Medicine Status

                        </button>

                    </div>

                </form>

            <% } %>

        </div>

    </section>


    <!-- COMPLETE VISIT -->

    <section class="card">

        <h2>
            Complete Consultation
        </h2>


        <% if (consultationCompleted) { %>

            <div class="finished-message">

                This consultation has been completed.

            </div>

        <% } else { %>

            <form
                method="post"
                action="${pageContext.request.contextPath}/assistant/visits">

                <input
                    type="hidden"
                    name="action"
                    value="complete">

                <input
                    type="hidden"
                    name="visitId"
                    value="<%= visit.getVisitId() %>">


                <label>
                    Visit Notes
                </label>

                <textarea
                    name="visitNotes"
                    maxlength="5000"
                    required
                    placeholder="Record the consultation notes provided by the doctor..."></textarea>


                <div
                    class="complete-note">

                    <button
                        type="submit"
                        class="button success-button">

                        Complete Consultation

                    </button>

                </div>

            </form>

        <% } %>

    </section>


    <% } %>

</main>

</body>

</html>