<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.dentalclinic.model.Invoice" %>
<%@ page import="com.dentalclinic.model.InvoiceItem" %>
<%@ page import="com.dentalclinic.model.Payment" %>

<%
    Invoice invoice = (Invoice) request.getAttribute("invoice");
    List<InvoiceItem> items = (List<InvoiceItem>) request.getAttribute("invoiceItems");
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
    BigDecimal alreadyPaid = (BigDecimal) request.getAttribute("alreadyPaid");
    BigDecimal outstanding = (BigDecimal) request.getAttribute("outstanding");
    String error = (String) request.getAttribute("error");
%>

<%
    request.setAttribute("activeNav", "invoices");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Process Payment</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
</head>
<body>

    <jsp:include page="/WEB-INF/includes/cashier-header.jsp" />

    <main class="main-container">
        <div class="card" style="max-width: 900px; margin: 0 auto;">
            <div class="page-header" style="margin-bottom: 20px;">
                <div class="page-title-group">
                    <h1>Process Payment</h1>
                    <p>Collect patient payments, record method of transaction, and issue receipts.</p>
                </div>
            </div>

            <% if (error != null && !error.isBlank()) { %>
                <div class="alert alert-error"><%= error %></div>
            <% } %>

            <% if (invoice != null) { %>
                <div class="grid-3" style="background: var(--bg-body); padding: 18px; border-radius: var(--radius-md); margin-bottom: 24px;">
                    <div>
                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Invoice Number</span>
                        <strong style="font-size: 16px; color: var(--primary);"><%= invoice.getInvoiceNumber() %></strong>
                    </div>
                    <div>
                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Patient ID</span>
                        <strong>#<%= invoice.getPatientId() %></strong>
                    </div>
                    <div>
                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Invoice Status</span>
                        <span class="badge badge-info"><%= invoice.getInvoiceStatus() %></span>
                    </div>
                </div>

                <div class="card" style="margin-bottom: 24px; background: #ffffff; border: 1px solid var(--border-color);">
                    <h3 class="card-title">Invoice Breakdown</h3>
                    <div class="table-container" style="margin-bottom: 16px;">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Description</th>
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

                    <div style="max-width: 320px; margin-left: auto;">
                        <div style="display: flex; justify-content: space-between; padding: 4px 0; font-size: 14px;">
                            <span>Invoice Total:</span>
                            <strong>LKR <%= invoice.getTotalAmount() %></strong>
                        </div>
                        <div style="display: flex; justify-content: space-between; padding: 4px 0; font-size: 14px;">
                            <span>Already Paid:</span>
                            <strong>LKR <%= alreadyPaid %></strong>
                        </div>
                        <div style="display: flex; justify-content: space-between; padding: 10px 0; border-top: 2px solid var(--text-heading); font-size: 18px; font-weight: 800; color: #10b981;">
                            <span>Outstanding Balance:</span>
                            <span>LKR <%= outstanding %></span>
                        </div>
                    </div>
                </div>

                <!-- Record Payment Form -->
                <div class="card" style="margin-bottom: 24px; background: var(--bg-body); border: none;">
                    <h3 class="card-title">Collect Payment</h3>
                    <form method="post" action="${pageContext.request.contextPath}/cashier/payments">
                        <input type="hidden" name="action" value="makePayment">
                        <input type="hidden" name="invoiceId" value="<%= invoice.getInvoiceId() %>">

                        <div class="grid-2" style="margin-bottom: 16px;">
                            <div class="form-group">
                                <label class="form-label">Payment Amount (LKR)</label>
                                <input class="form-control" type="number" name="amount" min="0.01" step="0.01" max="<%= outstanding %>" value="<%= outstanding %>" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Payment Method</label>
                                <select class="form-control" name="paymentMethod" required>
                                    <option value="">-- Select Payment Method --</option>
                                    <option value="CASH">Cash</option>
                                    <option value="CARD">Debit / Credit Card</option>
                                    <option value="BANK_TRANSFER">Bank Transfer / Online</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Payment Notes (Optional)</label>
                            <textarea class="form-control" name="notes" maxlength="500" rows="2" placeholder="Reference number or cashier notes..."></textarea>
                        </div>

                        <button type="submit" class="btn btn-primary" style="width: 100%;">Record & Confirm Payment</button>
                    </form>
                </div>

                <!-- Transaction History -->
                <div class="card">
                    <h3 class="card-title">Transaction Log</h3>
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Reference</th>
                                    <th>Method</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (payments == null || payments.isEmpty()) { %>
                                    <tr><td colspan="5" style="text-align: center; color: var(--text-muted);">No payment transactions recorded yet.</td></tr>
                                <% } else {
                                    for (Payment payment : payments) {
                                %>
                                    <tr>
                                        <td><code><%= payment.getPaymentReference() %></code></td>
                                        <td><span class="badge badge-info"><%= payment.getPaymentMethod() %></span></td>
                                        <td><strong>LKR <%= payment.getAmount() %></strong></td>
                                        <td><span class="badge badge-success"><%= payment.getPaymentStatus() %></span></td>
                                        <td><%= payment.getTransactionDate() %></td>
                                    </tr>
                                <% } } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            <% } %>
        </div>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

</body>
</html>