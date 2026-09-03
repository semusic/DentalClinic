<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String activeNav = (String) request.getAttribute("activeNav");
    if (activeNav == null) {
        activeNav = "";
    }
%>
<header class="app-navbar no-print">
    <div class="nav-container">
        <div class="nav-left">
            <a href="${pageContext.request.contextPath}/patient/dashboard" class="nav-brand">
                <div class="brand-icon">🦷</div>
                <div class="brand-title">Dental<span>Care</span></div>
            </a>
            <span class="role-badge patient">Patient</span>
        </div>

        <div class="nav-menu">
            <a href="${pageContext.request.contextPath}/patient/dashboard" class="nav-link <%= "dashboard".equalsIgnoreCase(activeNav) ? "active" : "" %>">Dashboard</a>
            <a href="${pageContext.request.contextPath}/patient/appointments/request" class="nav-link <%= "book".equalsIgnoreCase(activeNav) ? "active" : "" %>">Book Appointment</a>
            <a href="${pageContext.request.contextPath}/services" class="nav-link <%= "services".equalsIgnoreCase(activeNav) ? "active" : "" %>">Service Catalog</a>
            <a href="${pageContext.request.contextPath}/help" class="nav-link <%= "help".equalsIgnoreCase(activeNav) ? "active" : "" %>">Help Guide</a>
        </div>

        <div class="nav-actions">
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout btn-sm">Logout</a>
        </div>
    </div>
</header>
