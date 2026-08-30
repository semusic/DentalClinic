<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.model.Service" %>
<%@ page import="com.dentalclinic.model.Doctor" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        DentalCare | Request Appointment
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
            padding: 22px 45px;
            border-bottom: 1px solid #e5e7eb;
        }

        .brand {
            color: #1677a5;
            font-size: 26px;
            font-weight: 700;
        }

        .container {
            max-width: 850px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .card {
            background: white;
            padding: 35px;
            border-radius: 18px;
            box-shadow:
                0 12px 35px rgba(0,0,0,0.07);
        }

        h1 {
            margin-top: 0;
            color: #183b56;
        }

        .subtitle {
            color: #718096;
            margin-bottom: 30px;
        }

        .field {
            margin-bottom: 22px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
        }

        select,
        input,
        textarea {
            width: 100%;
            padding: 13px;
            border: 1px solid #dbe4ec;
            border-radius: 9px;
            font: inherit;
        }

        select:focus,
        input:focus,
        textarea:focus {
            outline: none;
            border-color: #1677a5;
        }

        textarea {
            min-height: 120px;
            resize: vertical;
        }

        .error {
            background: #fff0f0;
            color: #b42318;
            padding: 13px;
            border-radius: 9px;
            margin-bottom: 20px;
        }

        .hint {
            margin-top: 7px;
            font-size: 13px;
            color: #718096;
        }

        .actions {
            display: flex;
            gap: 12px;
            margin-top: 30px;
        }

        button,
        .back {
            flex: 1;
            padding: 14px;
            border-radius: 9px;
            font-weight: 700;
            text-align: center;
            text-decoration: none;
        }

        button {
            border: none;
            background: #1677a5;
            color: white;
            cursor: pointer;
        }

        .back {
            border: 1px solid #dbe4ec;
            color: #374151;
            background: white;
        }

    </style>

</head>

<body>

<header class="header">

    <div class="brand">
        DentalCare
    </div>

</header>


<div class="container">

    <div class="card">

        <h1>
            Request an Appointment
        </h1>

        <p class="subtitle">
            Choose your preferred service, doctor,
            date and time. Your request must be
            reviewed before the appointment is confirmed.
        </p>

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

            List<Service> services =
                    (List<Service>)
                            request.getAttribute(
                                    "services"
                            );

            List<Doctor> doctors =
                    (List<Doctor>)
                            request.getAttribute(
                                    "doctors"
                            );

            Integer selectedServiceId =
                    (Integer)
                            request.getAttribute(
                                    "selectedServiceId"
                            );
        %>


        <form
            action="${pageContext.request.contextPath}/patient/appointments/request"
            method="post">

            <div class="field">

                <label for="serviceId">
                    Dental Service
                </label>

                <select
                    id="serviceId"
                    name="serviceId"
                    required
                    onchange="loadDoctors(this.value)">

                    <option value="">
                        Select a service
                    </option>

                    <%
                        if (services != null) {

                            for (Service service :
                                    services) {

                                boolean selected =
                                        selectedServiceId != null
                                        && selectedServiceId
                                            .equals(
                                                service.getServiceId()
                                            );
                    %>

                    <option
                        value="<%= service.getServiceId() %>"
                        <%= selected
                                ? "selected"
                                : "" %>>

                        <%= service.getServiceName() %>
                        -
                        LKR <%= service.getStandardPrice() %>

                    </option>

                    <%
                            }
                        }
                    %>

                </select>

            </div>


            <div class="field">

                <label for="doctorId">
                    Preferred Doctor
                </label>

                <select
                    id="doctorId"
                    name="doctorId"
                    required>

                    <option value="">
                        Select a service first
                    </option>

                    <%
                        if (doctors != null
                                && !doctors.isEmpty()) {

                            for (Doctor doctor :
                                    doctors) {
                    %>

                    <option
                        value="<%= doctor.getDoctorId() %>">

                        Dr. <%= doctor.getFullName() %>
                        -
                        <%= doctor.getSpecialization() %>

                    </option>

                    <%
                            }
                        }
                    %>

                </select>

                <div class="hint">
                    Only doctors assigned to the selected
                    service are displayed.
                </div>

            </div>


            <div class="field">

                <label for="requestedDate">
                    Preferred Date
                </label>

                <input
                    type="date"
                    id="requestedDate"
                    name="requestedDate"
                    required>

            </div>


            <div class="field">

                <label for="requestedTime">
                    Preferred Time
                </label>

                <input
                    type="time"
                    id="requestedTime"
                    name="requestedTime"
                    required>

                <div class="hint">
                    The system will verify the doctor's
                    working schedule and appointment conflicts.
                </div>

            </div>


            <div class="field">

                <label for="patientReason">
                    Reason for Visit
                </label>

                <textarea
                    id="patientReason"
                    name="patientReason"
                    maxlength="2000"
                    placeholder="Briefly describe why you would like an appointment."></textarea>

            </div>


            <div class="actions">

                <a
                    class="back"
                    href="${pageContext.request.contextPath}/patient/dashboard">

                    Cancel

                </a>

                <button type="submit">
                    Submit Appointment Request
                </button>

            </div>

        </form>

    </div>

</div>


<script>

    function loadDoctors(serviceId) {

        if (!serviceId) {

            window.location =
                '${pageContext.request.contextPath}'
                + '/patient/appointments/request';

            return;
        }

        window.location =
            '${pageContext.request.contextPath}'
            + '/patient/appointments/request?serviceId='
            + encodeURIComponent(serviceId);
    }

</script>

</body>

</html>