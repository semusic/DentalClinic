<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String activeNav = (String) request.getAttribute("activeNav");
    if (activeNav == null) {
        activeNav = "";
    }
%>
<header class="app-navbar no-print">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/assistant/dashboard" class="nav-brand">
            <div class="brand-icon">🦷</div>
            <div class="brand-title">Dental<span>Care</span></div>
            <span class="role-badge assistant">Assistant</span>
        </a>

        <div class="nav-menu">
            <a href="${pageContext.request.contextPath}/assistant/dashboard" class="nav-link <%= "dashboard".equalsIgnoreCase(activeNav) ? "active" : "" %>">Dashboard</a>
            <a href="${pageContext.request.contextPath}/assistant/appointments" class="nav-link <%= "appointments".equalsIgnoreCase(activeNav) ? "active" : "" %>">Requests</a>
            <a href="${pageContext.request.contextPath}/assistant/visits" class="nav-link <%= "visits".equalsIgnoreCase(activeNav) ? "active" : "" %>">Visits & Check-in</a>
            <a href="${pageContext.request.contextPath}/assistant/appointments/search" class="nav-link <%= "search".equalsIgnoreCase(activeNav) ? "active" : "" %>">Search</a>
            <a href="${pageContext.request.contextPath}/help" class="nav-link <%= "help".equalsIgnoreCase(activeNav) ? "active" : "" %>">Help Guide</a>
        </div>

        <div class="nav-actions">
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout btn-sm">Logout</a>
        </div>
    </div>
</header>
