<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.model.Service" %>
<%@ page import="com.dentalclinic.model.Doctor" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Request Appointment</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
</head>
<body>

    <header class="app-navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/patient/dashboard" class="nav-brand">
                <div class="brand-icon">🦷</div>
                <div class="brand-title">Dental<span>Care</span></div>
                <span class="role-badge patient">Patient</span>
            </a>

            <div class="nav-menu">
                <a href="${pageContext.request.contextPath}/patient/dashboard" class="nav-link">Dashboard</a>
                <a href="${pageContext.request.contextPath}/patient/appointments/request" class="nav-link active">Book Appointment</a>
                <a href="${pageContext.request.contextPath}/patient/notifications" class="nav-link">Notifications</a>
                <a href="${pageContext.request.contextPath}/services" class="nav-link">Services</a>
            </div>

            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/patient/dashboard" class="btn btn-secondary btn-sm">← Back to Dashboard</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout btn-sm">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-container">
        <div class="card" style="max-width: 800px; margin: 0 auto;">
            <div class="page-header" style="margin-bottom: 24px;">
                <div class="page-title-group">
                    <h1>Request an Appointment</h1>
                    <p>Select your service, doctor, and preferred time slot. Requests are subject to doctor approval.</p>
                </div>
            </div>

            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="alert alert-error">
                    <%= error %>
                </div>
            <%
                }

                List<Service> services = (List<Service>) request.getAttribute("services");
                List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
                Integer selectedServiceId = (Integer) request.getAttribute("selectedServiceId");
            %>

            <form action="${pageContext.request.contextPath}/patient/appointments/request" method="post">
                <div class="form-group">
                    <label class="form-label" for="serviceId">Dental Service</label>
                    <select class="form-control" id="serviceId" name="serviceId" required onchange="loadDoctors(this.value)">
                        <option value="">-- Select a Service --</option>
                        <%
                            if (services != null) {
                                for (Service service : services) {
                                    boolean selected = selectedServiceId != null && selectedServiceId.equals(service.getServiceId());
                        %>
                            <option value="<%= service.getServiceId() %>" <%= selected ? "selected" : "" %>>
                                <%= service.getServiceName() %> — LKR <%= service.getStandardPrice() %>
                            </option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="doctorId">Preferred Doctor</label>
                    <select class="form-control" id="doctorId" name="doctorId" required>
                        <option value="">-- Select a Service First --</option>
                        <%
                            if (doctors != null && !doctors.isEmpty()) {
                                for (Doctor doctor : doctors) {
                        %>
                            <option value="<%= doctor.getDoctorId() %>">
                                Dr. <%= doctor.getFullName() %> (<%= doctor.getSpecialization() %>)
                            </option>
                        <%
                                }
                            }
                        %>
                    </select>
                    <div class="form-hint">Only doctors qualified for the selected service are displayed.</div>
                </div>

                <div class="grid-2">
                    <div class="form-group">
                        <label class="form-label" for="requestedDate">Preferred Date</label>
                        <input class="form-control" type="date" id="requestedDate" name="requestedDate" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="requestedTime">Preferred Time</label>
                        <input class="form-control" type="time" id="requestedTime" name="requestedTime" required>
                        <div class="form-hint">The doctor's schedule and availability will be checked.</div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="patientReason">Reason for Visit</label>
                    <textarea class="form-control" id="patientReason" name="patientReason" maxlength="2000" rows="3" placeholder="Briefly describe your symptoms or reason for appointment..."></textarea>
                </div>

                <div style="display: flex; gap: 12px; margin-top: 28px;">
                    <a href="${pageContext.request.contextPath}/patient/dashboard" class="btn btn-secondary" style="flex: 1;">Cancel</a>
                    <button type="submit" class="btn btn-primary" style="flex: 2;">Submit Request</button>
                </div>
            </form>
        </div>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

    <script>
        function loadDoctors(serviceId) {
            if (!serviceId) {
                window.location = '${pageContext.request.contextPath}/patient/appointments/request';
                return;
            }
            window.location = '${pageContext.request.contextPath}/patient/appointments/request?serviceId=' + encodeURIComponent(serviceId);
        }
    </script>

</body>
</html>