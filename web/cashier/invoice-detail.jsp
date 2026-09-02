<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.model.Invoice" %>
<%@ page import="com.dentalclinic.model.InvoiceItem" %>

<%
    Invoice invoice = (Invoice) request.getAttribute("invoice");
    List<InvoiceItem> items = (List<InvoiceItem>) request.getAttribute("invoiceItems");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Invoice Detail</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
</head>
<body>

    <header class="app-navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/cashier/dashboard" class="nav-brand">
                <div class="brand-icon">🦷</div>
                <div class="brand-title">Dental<span>Care</span></div>
                <span class="role-badge cashier">Cashier</span>
            </a>

            <div class="nav-menu">
                <a href="${pageContext.request.contextPath}/cashier/dashboard" class="nav-link">Dashboard</a>
                <a href="${pageContext.request.contextPath}/cashier/invoices" class="nav-link active">Invoices</a>
                <a href="${pageContext.request.contextPath}/cashier/invoice-history" class="nav-link">Invoice History</a>
            </div>

            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/cashier/invoices" class="btn btn-secondary btn-sm">← Back to Invoices</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout btn-sm">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-container">
        <div class="card" style="max-width: 850px; margin: 0 auto; padding: 36px;">
            <% if (invoice == null) { %>
                <div style="text-align: center; padding: 40px; color: var(--text-muted);">
                    <h2>Invoice Not Found</h2>
                </div>
            <% } else { %>

                <div style="display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 2px solid var(--border-color); padding-bottom: 20px; margin-bottom: 24px;">
                    <div>
                        <div style="font-size: 26px; font-weight: 800; color: var(--primary);">DentalCare</div>
                        <div style="font-size: 13px; color: var(--text-muted);">Clinic Management & Billing</div>
                    </div>
                    <div style="text-align: right;">
                        <span class="badge badge-warning" style="font-size: 12px; margin-bottom: 4px;"><%= invoice.getInvoiceStatus() %></span>
                        <h2 style="font-size: 20px; font-weight: 800; color: var(--text-heading);"><%= invoice.getInvoiceNumber() %></h2>
                    </div>
                </div>

                <div class="grid-3" style="background: var(--bg-body); padding: 16px; border-radius: var(--radius-md); margin-bottom: 24px;">
                    <div>
                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Invoice ID</span>
                        <strong>#<%= invoice.getInvoiceId() %></strong>
                    </div>
                    <div>
                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Patient ID</span>
                        <strong>#<%= invoice.getPatientId() %></strong>
                    </div>
                    <div>
                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Visit ID</span>
                        <strong>#<%= invoice.getVisitId() %></strong>
                    </div>
                </div>

                <div class="table-container" style="margin-bottom: 24px;">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Description</th>
                                <th>Quantity</th>
                                <th style="text-align: right;">Unit Price</th>
                                <th style="text-align: right;">Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (items != null) {
                                for (InvoiceItem item : items) {
                            %>
                                <tr>
                                    <td><strong><%= item.getItemDescription() %></strong></td>
                                    <td><%= item.getQuantity() %></td>
                                    <td style="text-align: right;">LKR <%= item.getUnitPrice() %></td>
                                    <td style="text-align: right;"><strong>LKR <%= item.getLineTotal() %></strong></td>
                                </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>

                <div style="max-width: 320px; margin-left: auto; margin-bottom: 28px;">
                    <div style="display: flex; justify-content: space-between; padding: 6px 0; font-size: 14px;">
                        <span>Subtotal:</span>
                        <strong>LKR <%= invoice.getSubtotal() %></strong>
                    </div>
                    <div style="display: flex; justify-content: space-between; padding: 6px 0; font-size: 14px;">
                        <span>Discount:</span>
                        <strong>LKR <%= invoice.getDiscountAmount() %></strong>
                    </div>
                    <div style="display: flex; justify-content: space-between; padding: 6px 0; font-size: 14px;">
                        <span>Tax:</span>
                        <strong>LKR <%= invoice.getTaxAmount() %></strong>
                    </div>
                    <div style="display: flex; justify-content: space-between; padding: 12px 0; border-top: 2px solid var(--text-heading); font-size: 20px; font-weight: 800; color: var(--text-heading);">
                        <span>Total Due:</span>
                        <span style="color: var(--primary);">LKR <%= invoice.getTotalAmount() %></span>
                    </div>
                </div>

                <div style="display: flex; gap: 12px; border-top: 1px solid var(--border-color); padding-top: 24px;">
                    <a href="${pageContext.request.contextPath}/cashier/invoices" class="btn btn-secondary" style="flex: 1;">Back to Invoices</a>
                    <a href="${pageContext.request.contextPath}/cashier/payments?invoiceId=<%= invoice.getInvoiceId() %>" class="btn btn-primary" style="flex: 2;">
                        Proceed to Process Payment →
                    </a>
                </div>
            <% } %>
        </div>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>