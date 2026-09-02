<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.dentalclinic.model.Doctor" %>
<%@ page import="com.dentalclinic.model.DoctorSchedule" %>

<%
    List<DoctorSchedule> schedules = (List<DoctorSchedule>) request.getAttribute("schedules");
    List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
    Map<Integer, Doctor> doctorMap = (Map<Integer, Doctor>) request.getAttribute("doctorMap");

    String[] days = {"", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};

    String flashMessage = (String) session.getAttribute("flashMessage");
    String flashError = (String) session.getAttribute("flashError");
    if (flashMessage != null) session.removeAttribute("flashMessage");
    if (flashError != null) session.removeAttribute("flashError");
%>

<%
    request.setAttribute("activeNav", "doctor-schedules");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Doctor Schedules</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
</head>
<body>

    <jsp:include page="/admin/includes/admin-header.jsp" />

    <main class="main-container">
        <div class="page-header">
            <div class="page-title-group">
                <h1>Doctor Working Schedules & Roster</h1>
                <p>Configure weekly attending hours, shift start/end times, and appointment capacity per doctor.</p>
            </div>
        </div>

        <% if (flashMessage != null) { %>
            <div class="alert alert-success" style="margin-bottom: 20px;">
                ✓ <%= flashMessage %>
            </div>
        <% } %>
        <% if (flashError != null) { %>
            <div class="alert alert-error" style="margin-bottom: 20px;">
                ✕ <%= flashError %>
            </div>
        <% } %>

        <div class="grid-3" style="grid-template-columns: 1fr 2fr; gap: 28px;">
            <!-- ADD SCHEDULE FORM CARD -->
            <div class="card" style="height: fit-content;">
                <h3 class="card-title" style="color: var(--primary); border-bottom: 1px solid var(--border-color); padding-bottom: 12px; margin-bottom: 20px;">
                    📅 Add Working Shift Slot
                </h3>

                <form method="post" action="${pageContext.request.contextPath}/admin/doctor-schedules">
                    <input type="hidden" name="action" value="add">

                    <div class="form-group" style="margin-bottom: 16px;">
                        <label class="form-label">Attending Doctor *</label>
                        <select name="doctorId" class="form-control" required>
                            <option value="">-- Select Doctor --</option>
                            <% if (doctors != null) { for (Doctor d : doctors) { %>
                                <option value="<%= d.getDoctorId() %>">Dr. <%= d.getFirstName() %> <%= d.getLastName() %> (<%= d.getSpecialization() %>)</option>
                            <% } } %>
                        </select>
                    </div>

                    <div class="form-group" style="margin-bottom: 16px;">
                        <label class="form-label">Day of Week *</label>
                        <select name="dayOfWeek" class="form-control" required>
                            <option value="1">Monday</option>
                            <option value="2">Tuesday</option>
                            <option value="3">Wednesday</option>
                            <option value="4">Thursday</option>
                            <option value="5">Friday</option>
                            <option value="6">Saturday</option>
                            <option value="7">Sunday</option>
                        </select>
                    </div>

                    <div class="grid-2" style="margin-bottom: 16px;">
                        <div class="form-group">
                            <label class="form-label">Shift Start Time *</label>
                            <input type="time" name="startTime" class="form-control" value="09:00" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Shift End Time *</label>
                            <input type="time" name="endTime" class="form-control" value="17:00" required>
                        </div>
                    </div>

                    <div class="form-group" style="margin-bottom: 24px;">
                        <label class="form-label">Max Appointments Capacity *</label>
                        <input type="number" name="maxAppointments" class="form-control" value="10" min="1" max="50" required>
                    </div>

                    <button type="submit" class="btn btn-primary" style="width: 100%;">
                        Save Working Schedule
                    </button>
                </form>
            </div>

            <!-- SCHEDULE ROSTER TABLE -->
            <div class="table-container">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Attending Doctor</th>
                            <th>Day of Week</th>
                            <th>Working Hours</th>
                            <th>Max Slots</th>
                            <th>Status</th>
                            <th style="text-align: right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (schedules == null || schedules.isEmpty()) { %>
                            <tr>
                                <td colspan="6" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                    No working schedules configured. Add a shift slot using the form on the left.
                                </td>
                            </tr>
                        <% } else { for (DoctorSchedule s : schedules) {
                            Doctor d = doctorMap != null ? doctorMap.get(s.getDoctorId()) : null;
                            String dayName = (s.getDayOfWeek() >= 1 && s.getDayOfWeek() <= 7) ? days[s.getDayOfWeek()] : "Day " + s.getDayOfWeek();
                        %>
                            <tr>
                                <td>
                                    <strong><%= d != null ? "Dr. " + d.getFirstName() + " " + d.getLastName() : "Doctor #" + s.getDoctorId() %></strong>
                                    <div style="font-size: 12px; color: var(--text-muted);"><%= d != null ? d.getSpecialization() : "" %></div>
                                </td>
                                <td><span class="badge badge-info"><%= dayName %></span></td>
                                <td><code><%= s.getStartTime() %> - <%= s.getEndTime() %></code></td>
                                <td><strong><%= s.getMaxAppointments() %> appts</strong></td>
                                <td>
                                    <% if (s.isActive()) { %>
                                        <span class="badge badge-success">ACTIVE</span>
                                    <% } else { %>
                                        <span class="badge badge-danger">INACTIVE</span>
                                    <% } %>
                                </td>
                                <td style="text-align: right;">
                                    <div style="display: flex; gap: 6px; justify-content: flex-end;">
                                        <form method="post" action="${pageContext.request.contextPath}/admin/doctor-schedules" style="display: inline;">
                                            <input type="hidden" name="action" value="toggleStatus">
                                            <input type="hidden" name="scheduleId" value="<%= s.getScheduleId() %>">
                                            <input type="hidden" name="active" value="<%= s.isActive() %>">
                                            <button type="submit" class="btn btn-secondary btn-sm">
                                                <%= s.isActive() ? "Disable" : "Enable" %>
                                            </button>
                                        </form>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/doctor-schedules" style="display: inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="scheduleId" value="<%= s.getScheduleId() %>">
                                            <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Delete this schedule slot?');">Delete</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>
