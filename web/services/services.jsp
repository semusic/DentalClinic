<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dentalclinic.model.User" %>
<%@ page import="com.dentalclinic.pattern.composite.DentalServiceComponent" %>
<%@ page import="com.dentalclinic.pattern.composite.DentalServiceLeaf" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Dental Services & Pricing</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
</head>
<body>

<%
    User userObj = (com.dentalclinic.model.User) session.getAttribute("authenticatedUser");
    String userRole = (userObj != null && userObj.getRoleName() != null) ? userObj.getRoleName() : "";
    if ("PATIENT".equalsIgnoreCase(userRole)) {
        request.setAttribute("activeNav", "services");
%>
        <jsp:include page="/WEB-INF/includes/patient-header.jsp" />
<%
    } else if ("ADMIN".equalsIgnoreCase(userRole)) {
        request.setAttribute("activeNav", "services");
%>
        <jsp:include page="/WEB-INF/includes/admin-header.jsp" />
<%
    } else {
%>
        <header class="app-navbar">
            <div class="nav-container">
                <a href="${pageContext.request.contextPath}/services" class="nav-brand">
                    <div class="brand-icon">🦷</div>
                    <div class="brand-title">Dental<span>Care</span></div>
                </a>
                <div class="nav-actions">
                    <% if (userObj != null) { %>
                        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary btn-sm">Go to Dashboard</a>
                    <% } else { %>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary btn-sm">Sign In</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-sm">Register</a>
                    <% } %>
                </div>
            </div>
        </header>
<%
    }
%>

    <main class="main-container">
        <div class="page-header" style="text-align: center; margin-bottom: 40px;">
            <div class="page-title-group" style="width: 100%;">
                <h1 style="font-size: 36px; font-weight: 800;">Our Dental Services</h1>
                <p style="font-size: 17px; max-width: 600px; margin: 8px auto 0;">Comprehensive oral health services provided by qualified dental specialists</p>
            </div>
        </div>

        <%
            DentalServiceComponent catalog = (DentalServiceComponent) request.getAttribute("serviceCatalog");
            if (catalog == null || catalog.getChildren().isEmpty()) {
        %>
            <div class="card" style="text-align: center; padding: 60px; color: var(--text-muted);">
                <h3>No dental services are currently listed</h3>
                <p style="margin-top: 8px;">Please check back later or contact the clinic reception.</p>
            </div>
        <%
            } else {
                for (DentalServiceComponent category : catalog.getChildren()) {
        %>
            <section style="margin-bottom: 40px;">
                <h2 style="font-size: 22px; font-weight: 800; color: var(--primary); margin-bottom: 20px; border-bottom: 2px solid var(--primary-light); padding-bottom: 10px; display: flex; align-items: center; gap: 10px;">
                    <span>🔹</span> <%= category.getName() %>
                </h2>

                <div class="grid-3">
                    <%
                        for (DentalServiceComponent component : category.getChildren()) {
                            DentalServiceLeaf service = (DentalServiceLeaf) component;
                    %>
                        <div class="card action-card">
                            <div>
                                <div class="action-icon" style="background: var(--primary-light); color: var(--primary);">
                                    🦷
                                </div>
                                <h3 class="action-title"><%= service.getName() %></h3>
                                <p class="action-desc">
                                    <%= service.getDescription() == null || service.getDescription().isBlank() ? "Professional dental care and examination service." : service.getDescription() %>
                                </p>
                            </div>
                            <div style="margin-top: 20px; border-top: 1px solid var(--border-color); padding-top: 16px; display: flex; align-items: center; justify-content: space-between;">
                                <div>
                                    <span style="font-size: 12px; color: var(--text-muted); display: block;">Standard Price</span>
                                    <span style="font-size: 20px; font-weight: 800; color: var(--primary);">LKR <%= service.getPrice() %></span>
                                </div>
                                <a href="${pageContext.request.contextPath}/patient/appointments/request?serviceId=<%= service.getService().getServiceId() %>" class="btn btn-primary btn-sm">
                                    Book Now
                                </a>
                            </div>
                        </div>
                    <%
                        }
                    %>
                </div>
            </section>
        <%
                }
            }
        %>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>