<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.model.Service" %>
<%@ page import="com.dentalclinic.model.ServiceCategory" %>

<%
    List<Service> services = (List<Service>) request.getAttribute("services");
    List<ServiceCategory> categories = (List<ServiceCategory>) request.getAttribute("categories");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<%
    request.setAttribute("activeNav", "services");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Service Catalog & Pricing</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
    <style>
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            z-index: 2000;
            align-items: center;
            justify-content: center;
        }
        .modal-overlay.active {
            display: flex;
        }
        .modal-box {
            background: #ffffff;
            border-radius: var(--radius-lg);
            width: 100%;
            max-width: 540px;
            padding: 32px;
            box-shadow: var(--shadow-lg);
            border: 1px solid var(--border-color);
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/includes/admin-header.jsp" />

    <main class="main-container">
        <div class="page-header">
            <div class="page-title-group">
                <h1>Service Catalog & Pricing</h1>
                <p>Manage procedure definitions, duration, catalog categorization, and standard pricing.</p>
            </div>
            <div>
                <button type="button" class="btn btn-primary" onclick="openAddModal()">
                    + Add Service
                </button>
            </div>
        </div>

        <% if ("created".equals(success)) { %>
            <div class="alert alert-success">✓ New dental service added to catalog successfully.</div>
        <% } else if ("updated".equals(success)) { %>
            <div class="alert alert-success">✓ Dental service details and price updated successfully.</div>
        <% } else if ("status_toggled".equals(success)) { %>
            <div class="alert alert-success">✓ Service active status toggled successfully.</div>
        <% } else if (error != null) { %>
            <div class="alert alert-error">✕ Error processing request. Please verify inputs and try again.</div>
        <% } %>

        <div class="card" style="margin-bottom: 20px; padding: 16px;">
            <input id="serviceSearch" class="form-control" type="text" placeholder="Search services...">
        </div>

        <div class="table-container">
            <% if (services == null || services.isEmpty()) { %>
                <div style="text-align: center; padding: 60px; color: var(--text-muted);">
                    <h3>No dental services defined</h3>
                    <p style="margin-top: 8px;">Click "+ Add Service" above to add procedures to the catalog.</p>
                </div>
            <% } else { %>
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Service Name</th>
                            <th>Category</th>
                            <th>Duration</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th style="text-align: right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="serviceTable">
                        <% for (Service service : services) { %>
                            <tr>
                                <td>
                                    <strong><%= service.getServiceName() %></strong>
                                    <% if (service.getDescription() != null && !service.getDescription().isBlank()) { %>
                                        <span style="display: block; font-size: 12px; color: var(--text-muted);"><%= service.getDescription() %></span>
                                    <% } %>
                                </td>
                                <td><span class="badge badge-info"><%= service.getCategoryName() %></span></td>
                                <td><%= service.getDurationMinutes() %> min</td>
                                <td><strong>LKR <%= String.format("%,.2f", service.getStandardPrice()) %></strong></td>
                                <td>
                                    <% if (service.isActive()) { %>
                                        <span class="badge badge-success">Active</span>
                                    <% } else { %>
                                        <span class="badge badge-danger">Inactive</span>
                                    <% } %>
                                </td>
                                <td style="text-align: right;">
                                    <div style="display: inline-flex; gap: 8px; align-items: center;">
                                        <button type="button" class="btn btn-secondary btn-sm"
                                            onclick="openEditModal(<%= service.getServiceId() %>, <%= service.getCategoryId() %>, '<%= service.getServiceName().replace("'", "\\'") %>', '<%= service.getDescription() != null ? service.getDescription().replace("'", "\\'").replace("\n", " ") : "" %>', <%= service.getDurationMinutes() %>, <%= service.getStandardPrice() %>, <%= service.isActive() %>)">
                                            Edit
                                        </button>

                                        <form method="post" action="${pageContext.request.contextPath}/admin/services" style="display: inline;">
                                            <input type="hidden" name="action" value="toggleStatus">
                                            <input type="hidden" name="serviceId" value="<%= service.getServiceId() %>">
                                            <% if (service.isActive()) { %>
                                                <button type="submit" class="btn btn-logout btn-sm" onclick="return confirm('Deactivate this service? It will no longer appear for new bookings.');">
                                                    Deactivate
                                                </button>
                                            <% } else { %>
                                                <button type="submit" class="btn btn-primary btn-sm" style="background: #10b981; border-color: #10b981;">
                                                    Activate
                                                </button>
                                            <% } %>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </main>

    <!-- ADD SERVICE MODAL -->
    <div id="addModal" class="modal-overlay">
        <div class="modal-box">
            <h3 class="card-title" style="margin-bottom: 20px;">+ Add New Service</h3>
            <form method="post" action="${pageContext.request.contextPath}/admin/services">
                <input type="hidden" name="action" value="create">

                <div class="form-group">
                    <label class="form-label">Service Name</label>
                    <input type="text" name="serviceName" class="form-control" placeholder="e.g. Teeth Cleaning" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Category</label>
                    <select name="categoryId" class="form-control" required>
                        <option value="">-- Select Category --</option>
                        <% if (categories != null) { for (ServiceCategory cat : categories) { %>
                            <option value="<%= cat.getCategoryId() %>"><%= cat.getCategoryName() %></option>
                        <% } } %>
                    </select>
                </div>

                <div class="grid-2">
                    <div class="form-group">
                        <label class="form-label">Duration (Minutes)</label>
                        <input type="number" name="durationMinutes" class="form-control" min="5" step="5" value="30" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Standard Price (LKR)</label>
                        <input type="number" name="standardPrice" class="form-control" min="0" step="100" placeholder="0.00" required>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Description (Optional)</label>
                    <textarea name="description" class="form-control" rows="2" placeholder="Brief service procedure summary..."></textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">Status</label>
                    <select name="isActive" class="form-control">
                        <option value="true">Active</option>
                        <option value="false">Inactive</option>
                    </select>
                </div>

                <div style="display: flex; gap: 12px; justify-content: flex-end; margin-top: 24px;">
                    <button type="button" class="btn btn-secondary" onclick="closeAddModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Service</button>
                </div>
            </form>
        </div>
    </div>

    <!-- EDIT SERVICE MODAL -->
    <div id="editModal" class="modal-overlay">
        <div class="modal-box">
            <h3 class="card-title" style="margin-bottom: 20px;">Edit Service Details</h3>
            <form method="post" action="${pageContext.request.contextPath}/admin/services">
                <input type="hidden" name="action" value="update">
                <input type="hidden" id="editServiceId" name="serviceId">

                <div class="form-group">
                    <label class="form-label">Service Name</label>
                    <input type="text" id="editServiceName" name="serviceName" class="form-control" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Category</label>
                    <select id="editCategoryId" name="categoryId" class="form-control" required>
                        <% if (categories != null) { for (ServiceCategory cat : categories) { %>
                            <option value="<%= cat.getCategoryId() %>"><%= cat.getCategoryName() %></option>
                        <% } } %>
                    </select>
                </div>

                <div class="grid-2">
                    <div class="form-group">
                        <label class="form-label">Duration (Minutes)</label>
                        <input type="number" id="editDurationMinutes" name="durationMinutes" class="form-control" min="5" step="5" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Standard Price (LKR)</label>
                        <input type="number" id="editStandardPrice" name="standardPrice" class="form-control" min="0" step="100" required>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Description</label>
                    <textarea id="editDescription" name="description" class="form-control" rows="2"></textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">Status</label>
                    <select id="editIsActive" name="isActive" class="form-control">
                        <option value="true">Active</option>
                        <option value="false">Inactive</option>
                    </select>
                </div>

                <div style="display: flex; gap: 12px; justify-content: flex-end; margin-top: 24px;">
                    <button type="button" class="btn btn-secondary" onclick="closeEditModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update Service</button>
                </div>
            </form>
        </div>
    </div>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

    <script>
        const searchBox = document.getElementById("serviceSearch");
        const table = document.getElementById("serviceTable");
        if (searchBox && table) {
            searchBox.addEventListener("input", function () {
                const search = this.value.toLowerCase().trim();
                const rows = table.querySelectorAll("tr");
                rows.forEach(function (row) {
                    const text = row.innerText.toLowerCase();
                    row.style.display = text.includes(search) ? "" : "none";
                });
            });
        }

        function openAddModal() {
            document.getElementById("addModal").classList.add("active");
        }
        function closeAddModal() {
            document.getElementById("addModal").classList.remove("active");
        }

        function openEditModal(id, categoryId, name, desc, duration, price, active) {
            document.getElementById("editServiceId").value = id;
            document.getElementById("editCategoryId").value = categoryId;
            document.getElementById("editServiceName").value = name;
            document.getElementById("editDescription").value = desc;
            document.getElementById("editDurationMinutes").value = duration;
            document.getElementById("editStandardPrice").value = price;
            document.getElementById("editIsActive").value = active ? "true" : "false";

            document.getElementById("editModal").classList.add("active");
        }
        function closeEditModal() {
            document.getElementById("editModal").classList.remove("active");
        }
    </script>

</body>
</html>
