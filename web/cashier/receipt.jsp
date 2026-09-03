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

<%
    request.setAttribute("activeNav", "history");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | Payment Receipt</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
    <style>
        @media print {
            body { background: white !important; font-size: 12pt; }
            .main-container { padding: 0 !important; margin: 0 !important; max-width: 100% !important; }
            .card { border: none !important; box-shadow: none !important; padding: 0 !important; }
            .no-print { display: none !important; }
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/includes/cashier-header.jsp" />

    <main class="main-container">
        <div class="card" id="receiptCard" style="max-width: 850px; margin: 0 auto; padding: 40px;">
            <% if (receipt == null || invoice == null || payment == null) { %>
                <div style="text-align: center; padding: 40px; color: var(--text-muted);">
                    <h2>Receipt Details Not Available</h2>
                    <p style="margin-top: 12px;"><a href="${pageContext.request.contextPath}/cashier/invoice-history" class="btn btn-secondary">← Back to History</a></p>
                </div>
            <% } else { %>

                <div style="display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 2px solid var(--border-color); padding-bottom: 20px; margin-bottom: 24px;">
                    <div>
                        <div style="font-size: 26px; font-weight: 800; color: var(--primary);">DentalCare</div>
                        <div style="font-size: 14px; font-weight: 700; color: var(--text-heading); text-transform: uppercase; letter-spacing: 0.5px; margin-top: 2px;">Payment Receipt</div>
                    </div>
                    <div style="text-align: right;">
                        <span class="badge badge-success" style="font-size: 12px; margin-bottom: 4px;">OFFICIAL RECEIPT</span>
                        <h2 style="font-size: 20px; font-weight: 800; color: var(--text-heading);"><%= receipt.getReceiptNumber() %></h2>
                    </div>
                </div>

                <div class="grid-3" style="background: var(--bg-body); padding: 18px; border-radius: var(--radius-md); margin-bottom: 24px;">
                    <div>
                        <span style="font-size: 11px; color: var(--text-muted); display: block; text-transform: uppercase; font-weight: 700;">Receipt Number</span>
                        <strong style="font-size: 15px; color: var(--text-heading);"><%= receipt.getReceiptNumber() %></strong>
                    </div>
                    <div>
                        <span style="font-size: 11px; color: var(--text-muted); display: block; text-transform: uppercase; font-weight: 700;">Invoice Number</span>
                        <strong style="font-size: 15px; color: var(--text-heading);"><%= invoice.getInvoiceNumber() %></strong>
                    </div>
                    <div>
                        <span style="font-size: 11px; color: var(--text-muted); display: block; text-transform: uppercase; font-weight: 700;">Patient</span>
                        <strong style="font-size: 15px; color: var(--text-heading);">Patient #<%= invoice.getPatientId() %></strong>
                    </div>
                    <div style="margin-top: 12px;">
                        <span style="font-size: 11px; color: var(--text-muted); display: block; text-transform: uppercase; font-weight: 700;">Payment Reference</span>
                        <code style="font-size: 13px;"><%= payment.getPaymentReference() %></code>
                    </div>
                    <div style="margin-top: 12px;">
                        <span style="font-size: 11px; color: var(--text-muted); display: block; text-transform: uppercase; font-weight: 700;">Payment Method</span>
                        <strong style="font-size: 14px;"><%= payment.getPaymentMethod() %></strong>
                    </div>
                    <div style="margin-top: 12px;">
                        <span style="font-size: 11px; color: var(--text-muted); display: block; text-transform: uppercase; font-weight: 700;">Payment Date</span>
                        <strong style="font-size: 14px;"><%= payment.getTransactionDate() %></strong>
                    </div>
                </div>

                <div style="margin-bottom: 24px;">
                    <h4 style="font-size: 14px; font-weight: 700; color: var(--text-heading); margin-bottom: 12px; text-transform: uppercase;">Services Rendered & Billing Items</h4>
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Item Description</th>
                                    <th style="text-align: center;">Qty</th>
                                    <th style="text-align: right;">Line Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (items != null) { for (InvoiceItem item : items) { %>
                                    <tr>
                                        <td><strong><%= item.getItemDescription() %></strong></td>
                                        <td style="text-align: center;"><%= item.getQuantity() %></td>
                                        <td style="text-align: right;">LKR <%= item.getLineTotal() %></td>
                                    </tr>
                                <% } } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div style="background: #f0fdf4; border: 1px solid #bbf7d0; padding: 20px; border-radius: var(--radius-md); text-align: center; margin-bottom: 28px;">
                    <div style="font-size: 12px; font-weight: 700; color: #166534; text-transform: uppercase; letter-spacing: 0.5px;">Amount Paid</div>
                    <div style="font-size: 32px; font-weight: 800; color: #15803d; margin: 4px 0;">LKR <%= payment.getAmount() %></div>
                    <div style="font-size: 13px; color: #166534;">Payment Status: <strong style="text-transform: uppercase;"><%= payment.getPaymentStatus() %></strong></div>
                </div>

                <% if (qrAvailable) { %>
                    <div style="text-align: center; background: var(--bg-body); border: 1px solid var(--border-color); padding: 24px; border-radius: var(--radius-md); margin-bottom: 28px;">
                        <h3 style="font-size: 16px; font-weight: 700; color: var(--text-heading); margin-bottom: 4px;">Patient Medical Record QR</h3>
                        <p style="font-size: 13px; color: var(--text-muted); margin-bottom: 16px;">Scan to view patient visit record</p>
                        <img src="${pageContext.request.contextPath}/qr?t=<%= encodedQrToken %>" alt="Patient Record QR" style="width: 200px; height: 200px; border: 1px solid var(--border-color); border-radius: var(--radius-md); background: white; padding: 10px;">
                    </div>
                <% } %>

                <div class="no-print" style="display: flex; gap: 12px; border-top: 1px solid var(--border-color); padding-top: 24px; flex-wrap: wrap;">
                    <button onclick="window.print()" class="btn btn-primary" style="flex: 1;">🖨️ Print Receipt</button>
                    <button onclick="downloadPDF()" class="btn btn-secondary" style="flex: 1;">📥 Save as PDF</button>
                    <a href="${pageContext.request.contextPath}/cashier/invoice-history?invoiceId=<%= invoice.getInvoiceId() %>" class="btn btn-secondary">Historical Invoice</a>
                    <a href="${pageContext.request.contextPath}/cashier/invoice-history" class="btn btn-secondary">← Back to History</a>
                </div>
            <% } %>
        </div>
    </main>

    <footer class="app-footer no-print">
        DentalCare Clinic Management System
    </footer>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <script>
        function downloadPDF() {
            const element = document.getElementById('receiptCard');
            if (typeof html2pdf !== 'undefined') {
                const noPrintElements = element.querySelectorAll('.no-print');
                noPrintElements.forEach(el => el.style.display = 'none');

                const opt = {
                    margin:       10,
                    filename:     'DentalCare_Receipt_<%= receipt != null ? receipt.getReceiptNumber() : "Receipt" %>.pdf',
                    image:        { type: 'jpeg', quality: 0.98 },
                    html2canvas:  { scale: 2, useCORS: true },
                    jsPDF:        { unit: 'mm', format: 'a4', orientation: 'portrait' }
                };

                html2pdf().set(opt).from(element).save().then(() => {
                    noPrintElements.forEach(el => el.style.display = '');
                }).catch(err => {
                    noPrintElements.forEach(el => el.style.display = '');
                    window.print();
                });
            } else {
                window.print();
            }
        }
    </script>

</body>
</html>