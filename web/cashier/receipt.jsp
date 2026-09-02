<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.model.Invoice" %>
<%@ page import="com.dentalclinic.model.InvoiceItem" %>
<%@ page import="com.dentalclinic.model.Payment" %>
<%@ page import="com.dentalclinic.model.Receipt" %>

<%
    Invoice invoice = (Invoice) request.getAttribute("invoice");
    Payment payment = (Payment) request.getAttribute("payment");
    Receipt receipt = (Receipt) request.getAttribute("receipt");
    List<InvoiceItem> items = (List<InvoiceItem>) request.getAttribute("invoiceItems");

    boolean qrAvailable = invoice != null && invoice.getQrToken() != null && !invoice.getQrToken().isBlank();
    String encodedQrToken = qrAvailable ? java.net.URLEncoder.encode(invoice.getQrToken(), java.nio.charset.StandardCharsets.UTF_8) : "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Payment Receipt</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
</head>
<body>

    <header class="app-navbar no-print">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/cashier/dashboard" class="nav-brand">
                <div class="brand-icon">🦷</div>
                <div class="brand-title">Dental<span>Care</span></div>
                <span class="role-badge cashier">Cashier</span>
            </a>

            <div class="nav-menu">
                <a href="${pageContext.request.contextPath}/cashier/dashboard" class="nav-link">Dashboard</a>
                <a href="${pageContext.request.contextPath}/cashier/invoices" class="nav-link">Invoices</a>
                <a href="${pageContext.request.contextPath}/cashier/invoice-history" class="nav-link active">Invoice History</a>
            </div>

            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/cashier/invoice-history" class="btn btn-secondary btn-sm">← Back to History</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout btn-sm">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-container">
        <div class="card" style="max-width: 850px; margin: 0 auto; padding: 40px;">
            <% if (receipt == null || invoice == null || payment == null) { %>
                <div style="text-align: center; padding: 40px; color: var(--text-muted);">
                    <h2>Receipt Details Not Available</h2>
                </div>
            <% } else { %>

                <div style="display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 2px solid var(--border-color); padding-bottom: 20px; margin-bottom: 24px;">
                    <div>
                        <div style="font-size: 26px; font-weight: 800; color: var(--primary);">DentalCare</div>
                        <div style="font-size: 14px; color: var(--text-muted);">Official Payment Receipt</div>
                    </div>
                    <div style="text-align: right;">
                        <span class="badge badge-success" style="font-size: 12px; margin-bottom: 4px;">RECEIPT ISSUED</span>
                        <h2 style="font-size: 18px; font-weight: 800; color: var(--text-heading);"><%= receipt.getReceiptNumber() %></h2>
                    </div>
                </div>

                <div class="grid-3" style="background: var(--bg-body); padding: 18px; border-radius: var(--radius-md); margin-bottom: 24px;">
                    <div>
                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Receipt No.</span>
                        <strong><%= receipt.getReceiptNumber() %></strong>
                    </div>
                    <div>
                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Invoice Reference</span>
                        <strong><%= invoice.getInvoiceNumber() %></strong>
                    </div>
                    <div>
                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Patient ID</span>
                        <strong>#<%= invoice.getPatientId() %></strong>
                    </div>
                    <div style="margin-top: 10px;">
                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Payment Reference</span>
                        <code><%= payment.getPaymentReference() %></code>
                    </div>
                    <div style="margin-top: 10px;">
                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Payment Method</span>
                        <strong><%= payment.getPaymentMethod() %></strong>
                    </div>
                    <div style="margin-top: 10px;">
                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Transaction Date</span>
                        <strong><%= payment.getTransactionDate() %></strong>
                    </div>
                </div>

                <div class="table-container" style="margin-bottom: 24px;">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Item Description</th>
                                <th>Qty</th>
                                <th style="text-align: right;">Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (items != null) { for (InvoiceItem item : items) { %>
                                <tr>
                                    <td><strong><%= item.getItemDescription() %></strong></td>
                                    <td><%= item.getQuantity() %></td>
                                    <td style="text-align: right;">LKR <%= item.getLineTotal() %></td>
                                </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>

                <div style="background: #f0fdf4; border: 1px solid #bbf7d0; padding: 20px; border-radius: var(--radius-md); text-align: center; margin-bottom: 28px;">
                    <div style="font-size: 13px; font-weight: 700; color: #166534; text-transform: uppercase;">Total Amount Paid</div>
                    <div style="font-size: 32px; font-weight: 800; color: #15803d; margin: 4px 0;">LKR <%= payment.getAmount() %></div>
                    <div style="font-size: 12px; color: #166534;">Payment Status: <strong><%= payment.getPaymentStatus() %></strong></div>
                </div>

                <% if (qrAvailable) { %>
                    <div style="text-align: center; background: var(--bg-body); border: 1px solid var(--border-color); padding: 24px; border-radius: var(--radius-md); margin-bottom: 28px;">
                        <h3 style="font-size: 18px; font-weight: 700; color: var(--text-heading); margin-bottom: 8px;">Patient Medical Record QR</h3>
                        <p style="font-size: 13px; color: var(--text-muted); margin-bottom: 16px;">Scan to view verified patient visit record on mobile device</p>
                        <img src="${pageContext.request.contextPath}/qr?t=<%= encodedQrToken %>" alt="Visit QR Code" style="width: 220px; height: 220px; border: 1px solid var(--border-color); border-radius: var(--radius-md); background: white; padding: 10px;">
                    </div>
                <% } %>

                <div class="no-print" style="display: flex; gap: 12px; border-top: 1px solid var(--border-color); padding-top: 24px; flex-wrap: wrap;">
                    <button onclick="window.print()" class="btn btn-primary" style="flex: 1;">🖨️ Print Official Receipt</button>
                    <a href="${pageContext.request.contextPath}/cashier/invoice-history?invoiceId=<%= invoice.getInvoiceId() %>" class="btn btn-secondary" style="flex: 1;">View Invoice Details</a>
                    <a href="${pageContext.request.contextPath}/cashier/invoice-history" class="btn btn-secondary" style="flex: 1;">View History Log</a>
                </div>
            <% } %>
        </div>
    </main>

    <footer class="app-footer no-print">
        DentalCare Clinic Management System
    </footer>

</body>
</html>