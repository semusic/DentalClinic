<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.dentalclinic.model.Doctor" %>
<%@ page import="com.dentalclinic.model.Service" %>

<%
    List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
    List<Service> allServices = (List<Service>) request.getAttribute("allServices");
    Map<Integer, List<Integer>> doctorServicesMap = (Map<Integer, List<Integer>>) request.getAttribute("doctorServicesMap");
    Doctor editDoctor = (Doctor) request.getAttribute("editDoctor");
    List<Integer> editAssignedServices = (List<Integer>) request.getAttribute("editAssignedServices");

    String flashMessage = (String) session.getAttribute("flashMessage");
    String flashError = (String) session.getAttribute("flashError");
    if (flashMessage != null) session.removeAttribute("flashMessage");
    if (flashError != null) session.removeAttribute("flashError");
%>

<%
    request.setAttribute("activeNav", "doctors");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Doctor Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
</head>
<body>

    <jsp:include page="/admin/includes/admin-header.jsp" />

    <main class="main-container">
        <div class="page-header">
            <div class="page-title-group">
                <h1>Doctor Management & Directory</h1>
                <p>Register attending dental practitioners, update specialization profiles, and assign procedure competencies.</p>
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
            <!-- FORM CARD -->
            <div class="card" style="height: fit-content;">
                <h3 class="card-title" style="color: var(--primary); border-bottom: 1px solid var(--border-color); padding-bottom: 12px; margin-bottom: 20px;">
                    <%= editDoctor != null ? "✏️ Edit Doctor Profile" : "➕ Register New Doctor" %>
                </h3>

                <form method="post" action="${pageContext.request.contextPath}/admin/doctors">
                    <input type="hidden" name="action" value="<%= editDoctor != null ? "edit" : "add" %>">
                    <% if (editDoctor != null) { %>
                        <input type="hidden" name="doctorId" value="<%= editDoctor.getDoctorId() %>">
                    <% } %>

                    <div class="form-group" style="margin-bottom: 16px;">
                        <label class="form-label">First Name *</label>
                        <input type="text" name="firstName" class="form-control" value="<%= editDoctor != null ? editDoctor.getFirstName() : "" %>" required>
                    </div>

                    <div class="form-group" style="margin-bottom: 16px;">
                        <label class="form-label">Last Name *</label>
                        <input type="text" name="lastName" class="form-control" value="<%= editDoctor != null ? editDoctor.getLastName() : "" %>" required>
                    </div>

                    <div class="form-group" style="margin-bottom: 16px;">
                        <label class="form-label">Specialization / Clinical Focus *</label>
                        <input type="text" name="specialization" class="form-control" value="<%= editDoctor != null ? editDoctor.getSpecialization() : "" %>" placeholder="e.g. Orthodontist, Periodontist, General Dentistry" required>
                    </div>

                    <div class="form-group" style="margin-bottom: 16px;">
                        <label class="form-label">SLMC Registration / License No. *</label>
                        <input type="text" name="registrationNo" class="form-control" value="<%= editDoctor != null ? editDoctor.getRegistrationNo() : "" %>" placeholder="e.g. SLMC-8921" required>
                    </div>

                    <div class="form-group" style="margin-bottom: 16px;">
                        <label class="form-label">Contact Phone Number</label>
                        <input type="text" name="phone" class="form-control" value="<%= editDoctor != null && editDoctor.getPhone() != null ? editDoctor.getPhone() : "" %>">
                    </div>

                    <div class="form-group" style="margin-bottom: 16px;">
                        <label class="form-label">Official Email Address * (For Approval Notices)</label>
                        <input type="email" name="email" class="form-control" value="<%= editDoctor != null && editDoctor.getEmail() != null ? editDoctor.getEmail() : "" %>" required>
                    </div>

                    <div class="form-group" style="margin-bottom: 20px;">
                        <label class="form-label" style="margin-bottom: 8px; display: block;">Authorized Services & Procedures:</label>
                        <div style="max-height: 180px; overflow-y: auto; background: var(--bg-body); padding: 12px; border-radius: var(--radius-md); border: 1px solid var(--border-color);">
                            <% if (allServices != null) { for (Service s : allServices) {
                                boolean isAssigned = editAssignedServices != null && editAssignedServices.contains(s.getServiceId());
                            %>
                                <label style="display: flex; align-items: center; gap: 8px; font-size: 13px; margin-bottom: 6px; cursor: pointer;">
                                    <input type="checkbox" name="services" value="<%= s.getServiceId() %>" <%= isAssigned ? "checked" : "" %>>
                                    <span><strong><%= s.getServiceName() %></strong> (<%= s.getCategoryName() %>)</span>
                                </label>
                            <% } } %>
                        </div>
                    </div>

                    <div style="display: flex; gap: 10px;">
                        <button type="submit" class="btn btn-primary" style="flex: 1;">
                            <%= editDoctor != null ? "Save Doctor Changes" : "Register Doctor" %>
                        </button>
                        <% if (editDoctor != null) { %>
                            <a href="${pageContext.request.contextPath}/admin/doctors" class="btn btn-secondary">Cancel</a>
                        <% } %>
                    </div>
                </form>
            </div>

            <!-- DIRECTORY TABLE -->
            <div class="table-container">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Doctor Name</th>
                            <th>Specialization</th>
                            <th>License No.</th>
                            <th>Contact / Email</th>
                            <th>Status</th>
                            <th style="text-align: right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (doctors != null) { for (Doctor d : doctors) {
                            List<Integer> assigned = doctorServicesMap != null ? doctorServicesMap.get(d.getDoctorId()) : null;
                            int serviceCount = assigned != null ? assigned.size() : 0;
                        %>
                            <tr>
                                <td>
                                    <strong>Dr. <%= d.getFirstName() %> <%= d.getLastName() %></strong>
                                    <div style="font-size: 12px; color: var(--text-muted); margin-top: 2px;">
                                        Offers <%= serviceCount %> dental procedure(s)
                                    </div>
                                </td>
                                <td><span class="badge badge-info"><%= d.getSpecialization() %></span></td>
                                <td><code><%= d.getRegistrationNo() %></code></td>
                                <td>
                                    <div style="font-size: 13px;">📞 <%= d.getPhone() != null ? d.getPhone() : "N/A" %></div>
                                    <div style="font-size: 12px; color: var(--text-muted);">✉️ <%= d.getEmail() != null ? d.getEmail() : "N/A" %></div>
                                </td>
                                <td>
                                    <% if (d.isActive()) { %>
                                        <span class="badge badge-success">ACTIVE</span>
                                    <% } else { %>
                                        <span class="badge badge-danger">INACTIVE</span>
                                    <% } %>
                                </td>
                                <td style="text-align: right;">
                                    <div style="display: flex; gap: 6px; justify-content: flex-end;">
                                        <a href="${pageContext.request.contextPath}/admin/doctors?editId=<%= d.getDoctorId() %>" class="btn btn-secondary btn-sm">Edit</a>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/doctors" style="display: inline;">
                                            <input type="hidden" name="action" value="toggleStatus">
                                            <input type="hidden" name="doctorId" value="<%= d.getDoctorId() %>">
                                            <input type="hidden" name="active" value="<%= d.isActive() %>">
                                            <% if (d.isActive()) { %>
                                                <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Deactivate Dr. <%= d.getFirstName() %> <%= d.getLastName() %>?');">Deactivate</button>
                                            <% } else { %>
                                                <button type="submit" class="btn btn-success btn-sm">Activate</button>
                                            <% } %>
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
