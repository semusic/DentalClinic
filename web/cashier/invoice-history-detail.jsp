<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.model.Invoice" %>
<%@ page import="com.dentalclinic.model.InvoiceItem" %>

<%
    Invoice invoice = (Invoice) request.getAttribute("invoice");
    List<InvoiceItem> items = (List<InvoiceItem>) request.getAttribute("invoiceItems");
    String error = (String) request.getAttribute("error");

    boolean isUnpaid = invoice != null && "UNPAID".equalsIgnoreCase(invoice.getInvoiceStatus());
    boolean isVoid = invoice != null && "VOID".equalsIgnoreCase(invoice.getInvoiceStatus());
    boolean isPaid = invoice != null && "PAID".equalsIgnoreCase(invoice.getInvoiceStatus());
%>

<%
    request.setAttribute("activeNav", "history");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Invoice Audit Detail</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
</head>
<body>

    <jsp:include page="/WEB-INF/includes/cashier-header.jsp" />

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
                        <div style="font-size: 13px; color: var(--text-muted);">Historical Invoice Audit</div>
                    </div>
                    <div style="text-align: right;">
                        <span class="badge <%= isPaid ? "badge-success" : isVoid ? "badge-danger" : "badge-warning" %>" style="font-size: 12px; margin-bottom: 4px;">
                            <%= invoice.getInvoiceStatus() %>
                        </span>
                        <h2 style="font-size: 20px; font-weight: 800; color: var(--text-heading);"><%= invoice.getInvoiceNumber() %></h2>
                    </div>
                </div>

                <% if (error != null && !error.isBlank()) { %>
                    <div class="alert alert-error"><%= error %></div>
                <% } %>

                <div class="grid-3" style="background: var(--bg-body); padding: 16px; border-radius: var(--radius-md); margin-bottom: 24px;">
                    <div>
                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Invoice ID</span>
                        <strong>#<%= invoice.getInvoiceId() %></strong>
                    </div>
                    <div>
                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Visit ID</span>
                        <strong>#<%= invoice.getVisitId() %></strong>
                    </div>
                    <div>
                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Patient ID</span>
                        <strong>#<%= invoice.getPatientId() %></strong>
                    </div>
                    <div style="margin-top: 10px;">
                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Issued Date</span>
                        <strong><%= invoice.getIssuedAt() %></strong>
                    </div>
                    <div style="margin-top: 10px;">
                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Due Date</span>
                        <strong><%= invoice.getDueDate() %></strong>
                    </div>
                    <div style="margin-top: 10px;">
                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Created By</span>
                        <strong>User #<%= invoice.getCreatedByUserId() %></strong>
                    </div>
                </div>

                <div class="table-container" style="margin-bottom: 24px;">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Item Description</th>
                                <th>Qty</th>
                                <th style="text-align: right;">Unit Price</th>
                                <th style="text-align: right;">Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (items != null) { for (InvoiceItem item : items) { %>
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
                    <div style="display: flex; justify-content: space-between; padding: 4px 0; font-size: 14px;">
                        <span>Subtotal:</span>
                        <strong>LKR <%= invoice.getSubtotal() %></strong>
                    </div>
                    <div style="display: flex; justify-content: space-between; padding: 4px 0; font-size: 14px;">
                        <span>Discount:</span>
                        <strong>LKR <%= invoice.getDiscountAmount() %></strong>
                    </div>
                    <div style="display: flex; justify-content: space-between; padding: 4px 0; font-size: 14px;">
                        <span>Tax:</span>
                        <strong>LKR <%= invoice.getTaxAmount() %></strong>
                    </div>
                    <div style="display: flex; justify-content: space-between; padding: 12px 0; border-top: 2px solid var(--text-heading); font-size: 20px; font-weight: 800; color: var(--text-heading);">
                        <span>Total:</span>
                        <span style="color: var(--primary);">LKR <%= invoice.getTotalAmount() %></span>
                    </div>
                </div>

                <% if (isVoid) { %>
                    <div class="alert alert-error" style="margin-bottom: 24px;">
                        <strong>VOIDED INVOICE</strong><br>
                        Reason: <%= invoice.getVoidReason() %><br>
                        Voided At: <%= invoice.getVoidedAt() %> (User #<%= invoice.getVoidedByUserId() %>)
                    </div>
                <% } %>

                <% if (isUnpaid) { %>
                    <div class="card" style="background: var(--bg-body); border: none; margin-bottom: 24px;">
                        <h4 style="font-size: 15px; font-weight: 700; color: var(--danger); margin-bottom: 8px;">Void Invoice Option</h4>
                        <p style="font-size: 13px; color: var(--text-muted); margin-bottom: 12px;">If this unpaid invoice was issued by error, you may void it with an audit note.</p>
                        <form method="post" action="${pageContext.request.contextPath}/cashier/invoice-history" onsubmit="return confirm('Are you sure you want to void this invoice?');">
                            <input type="hidden" name="action" value="voidInvoice">
                            <input type="hidden" name="invoiceId" value="<%= invoice.getInvoiceId() %>">
                            <div class="form-group">
                                <textarea class="form-control" name="reason" rows="2" required placeholder="Reason for voiding invoice..."></textarea>
                            </div>
                            <button type="submit" class="btn btn-danger btn-sm">Void Invoice</button>
                        </form>
                    </div>
                <% } %>

                <div class="no-print" style="display: flex; gap: 12px; border-top: 1px solid var(--border-color); padding-top: 24px; flex-wrap: wrap;">
                    <a href="${pageContext.request.contextPath}/cashier/invoice-history" class="btn btn-secondary">← Back to History</a>
                    <button onclick="window.print()" class="btn btn-secondary">🖨️ Print Invoice</button>
                    <% if (isPaid) { %>
                        <a href="${pageContext.request.contextPath}/cashier/payments?invoiceId=<%= invoice.getInvoiceId() %>" class="btn btn-primary" style="margin-left: auto;">
                            View Receipt →
                        </a>
                    <% } else if (isUnpaid) { %>
                        <a href="${pageContext.request.contextPath}/cashier/payments?invoiceId=<%= invoice.getInvoiceId() %>" class="btn btn-primary" style="margin-left: auto;">
                            Proceed to Payment →
                        </a>
                    <% } %>
                </div>
            <% } %>
        </div>
    </main>

    <footer class="app-footer no-print">
        DentalCare Clinic Management System
    </footer>

</body>
</html>