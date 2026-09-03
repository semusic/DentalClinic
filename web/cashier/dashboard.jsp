<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dentalclinic.model.User" %>
<%
    request.setAttribute("activeNav", "dashboard");
    User user = (User) session.getAttribute("authenticatedUser");
    String userName = (user != null && user.getUsername() != null) ? user.getUsername() : "Cashier";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Cashier Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
</head>
<body>

    <jsp:include page="/WEB-INF/includes/cashier-header.jsp" />

    <main class="main-container">
        <div class="page-header">
            <div class="page-title-group">
                <h1>Cashier & Billing Desk</h1>
                <p>Generate patient invoices, collect payments, issue receipts, and manage transaction history.</p>
            </div>
        </div>

        <div class="grid-2" style="margin-bottom: 32px;">
            <a href="${pageContext.request.contextPath}/cashier/invoices" class="action-card">
                <div>
                    <div class="action-icon" style="background: #fefce8; color: #ca8a04;">🧾</div>
                    <div class="action-title">Invoices & Billing</div>
                    <div class="action-desc">Generate official billing invoices for completed patient visits, apply discounts, review itemized totals, and initiate payment collection.</div>
                </div>
                <div class="action-footer" style="color: #ca8a04;">
                    <span>Open Invoices</span> →
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/cashier/invoice-history" class="action-card">
                <div>
                    <div class="action-icon" style="background: #f0fdf4; color: #16a34a;">📜</div>
                    <div class="action-title">Invoice & Payment History</div>
                    <div class="action-desc">Browse historical invoices, search past receipts, review settled balances, and inspect complete transaction records.</div>
                </div>
                <div class="action-footer" style="color: #16a34a;">
                    <span>View History</span> →
                </div>
            </a>
        </div>

        <div class="card">
            <div class="card-title">Cashier Workflow Overview</div>
            <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 16px;">
                1. <strong>Invoice Generation:</strong> When a patient completes their consultation, select their visit in Invoices to generate a detailed invoice.<br>
                2. <strong>Payment Recording:</strong> Process cash, card, or online payments under Cashier Payments.<br>
                3. <strong>Receipt Generation:</strong> Provide official clinic receipts and review invoice status in Invoice History.
            </p>
            <div style="display: flex; gap: 12px; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/cashier/invoices" class="btn btn-primary btn-sm">Process Pending Invoices</a>
                <a href="${pageContext.request.contextPath}/cashier/invoice-history" class="btn btn-secondary btn-sm">Audit History</a>
            </div>
        </div>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>