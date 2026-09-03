<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String activeNav = (String) request.getAttribute("activeNav");
    if (activeNav == null) {
        activeNav = "";
    }
%>
<header class="app-navbar no-print">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/cashier/dashboard" class="nav-brand">
            <div class="brand-icon">🦷</div>
            <div class="brand-title">Dental<span>Care</span></div>
            <span class="role-badge cashier">Cashier</span>
        </a>

        <div class="nav-menu">
            <a href="${pageContext.request.contextPath}/cashier/dashboard" class="nav-link <%= "dashboard".equalsIgnoreCase(activeNav) ? "active" : "" %>">Dashboard</a>
            <a href="${pageContext.request.contextPath}/cashier/invoices" class="nav-link <%= "invoices".equalsIgnoreCase(activeNav) ? "active" : "" %>">Ready Invoices</a>
            <a href="${pageContext.request.contextPath}/cashier/invoice-history" class="nav-link <%= "history".equalsIgnoreCase(activeNav) ? "active" : "" %>">History Log</a>
            <a href="${pageContext.request.contextPath}/help" class="nav-link <%= "help".equalsIgnoreCase(activeNav) ? "active" : "" %>">Help Guide</a>
        </div>

        <div class="nav-actions">
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout btn-sm">Logout</a>
        </div>
    </div>
</header>
