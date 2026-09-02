package com.dentalclinic.controller;

import com.dentalclinic.util.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/reports")
public class AdminReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String reportType = request.getParameter("type");
        if (reportType == null || reportType.isBlank()) {
            reportType = "daily_appointments";
        }

        String export = request.getParameter("export");
        if ("csv".equalsIgnoreCase(export)) {
            handleCsvExport(request, response, reportType);
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            request.setAttribute("reportType", reportType);

            if ("daily_appointments".equals(reportType)) {
                loadDailyAppointmentsReport(request, conn);
            } else if ("completed_treatments".equals(reportType)) {
                loadCompletedTreatmentsReport(request, conn);
            } else if ("revenue_payments".equals(reportType)) {
                loadRevenuePaymentsReport(request, conn);
            } else if ("outstanding_invoices".equals(reportType)) {
                loadOutstandingInvoicesReport(request, conn);
            } else if ("popular_services".equals(reportType)) {
                loadPopularServicesReport(request, conn);
            }

            request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to generate administrative clinic report.", e);
        }
    }

    private void loadDailyAppointmentsReport(HttpServletRequest request, Connection conn) throws SQLException {
        String sql = """
            SELECT a.appointment_id, a.appointment_number, a.requested_date, s.status_code,
                   ser.service_name, CONCAT(u.first_name, ' ', u.last_name) AS patient_name
            FROM appointments a
            JOIN appointment_statuses s ON a.status_id = s.status_id
            JOIN services ser ON a.service_id = ser.service_id
            JOIN patients p ON a.patient_id = p.patient_id
            JOIN users u ON p.user_id = u.user_id
            ORDER BY a.requested_date DESC, a.appointment_id DESC
            LIMIT 100
            """;
        List<Map<String, Object>> rows = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("appointmentId", rs.getInt("appointment_id"));
                map.put("appointmentNumber", rs.getString("appointment_number"));
                map.put("requestedDate", rs.getDate("requested_date"));
                map.put("statusCode", rs.getString("status_code"));
                map.put("serviceName", rs.getString("service_name"));
                map.put("patientName", rs.getString("patient_name"));
                rows.add(map);
            }
        }
        request.setAttribute("reportData", rows);
    }

    private void loadCompletedTreatmentsReport(HttpServletRequest request, Connection conn) throws SQLException {
        String sql = """
            SELECT vs.visit_service_id, s.service_name, vs.quantity, vs.unit_price, vs.line_total, vs.performed_at,
                   CONCAT('Dr. ', d.first_name, ' ', d.last_name) AS doctor_name
            FROM visit_services vs
            JOIN services s ON vs.service_id = s.service_id
            JOIN doctors d ON vs.performed_by_doctor_id = d.doctor_id
            ORDER BY vs.performed_at DESC
            LIMIT 100
            """;
        List<Map<String, Object>> rows = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("visit_service_id"));
                map.put("serviceName", rs.getString("service_name"));
                map.put("quantity", rs.getInt("quantity"));
                map.put("unitPrice", rs.getBigDecimal("unit_price"));
                map.put("lineTotal", rs.getBigDecimal("line_total"));
                map.put("doctorName", rs.getString("doctor_name"));
                map.put("performedAt", rs.getTimestamp("performed_at"));
                rows.add(map);
            }
        }
        request.setAttribute("reportData", rows);
    }

    private void loadRevenuePaymentsReport(HttpServletRequest request, Connection conn) throws SQLException {
        String sql = """
            SELECT p.payment_id, p.payment_reference, p.amount, p.payment_method, p.payment_status, p.transaction_date,
                   i.invoice_number
            FROM payments p
            JOIN invoices i ON p.invoice_id = i.invoice_id
            ORDER BY p.transaction_date DESC
            """;
        List<Map<String, Object>> rows = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("paymentId", rs.getInt("payment_id"));
                map.put("reference", rs.getString("payment_reference"));
                map.put("amount", rs.getBigDecimal("amount"));
                map.put("method", rs.getString("payment_method"));
                map.put("status", rs.getString("payment_status"));
                map.put("date", rs.getTimestamp("transaction_date"));
                map.put("invoiceNumber", rs.getString("invoice_number"));
                rows.add(map);
            }
        }
        request.setAttribute("reportData", rows);
    }

    private void loadOutstandingInvoicesReport(HttpServletRequest request, Connection conn) throws SQLException {
        String sql = """
            SELECT i.invoice_id, i.invoice_number, i.total_amount, i.invoice_status, i.issued_at,
                   CONCAT(u.first_name, ' ', u.last_name) AS patient_name
            FROM invoices i
            JOIN patients p ON i.patient_id = p.patient_id
            JOIN users u ON p.user_id = u.user_id
            WHERE i.invoice_status IN ('UNPAID', 'PARTIALLY_PAID')
            ORDER BY i.issued_at ASC
            """;
        List<Map<String, Object>> rows = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("invoiceId", rs.getInt("invoice_id"));
                map.put("invoiceNumber", rs.getString("invoice_number"));
                map.put("totalAmount", rs.getBigDecimal("total_amount"));
                map.put("status", rs.getString("invoice_status"));
                map.put("issuedAt", rs.getTimestamp("issued_at"));
                map.put("patientName", rs.getString("patient_name"));
                rows.add(map);
            }
        }
        request.setAttribute("reportData", rows);
    }

    private void loadPopularServicesReport(HttpServletRequest request, Connection conn) throws SQLException {
        String sql = """
            SELECT s.service_name, c.category_name, COUNT(a.appointment_id) AS total_bookings, s.standard_price
            FROM services s
            JOIN service_categories c ON s.category_id = c.category_id
            LEFT JOIN appointments a ON s.service_id = a.service_id
            GROUP BY s.service_id, s.service_name, c.category_name, s.standard_price
            ORDER BY total_bookings DESC
            """;
        List<Map<String, Object>> rows = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("serviceName", rs.getString("service_name"));
                map.put("categoryName", rs.getString("category_name"));
                map.put("totalBookings", rs.getInt("total_bookings"));
                map.put("standardPrice", rs.getBigDecimal("standard_price"));
                rows.add(map);
            }
        }
        request.setAttribute("reportData", rows);
    }

    private void handleCsvExport(HttpServletRequest request, HttpServletResponse response, String reportType) throws IOException {
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"clinic_report_" + reportType + ".csv\"");

        PrintWriter writer = response.getWriter();
        try (Connection conn = DatabaseConnection.getConnection()) {
            if ("revenue_payments".equals(reportType)) {
                writer.println("Payment Reference,Invoice Number,Amount (LKR),Payment Method,Status,Transaction Date");
                String sql = "SELECT p.payment_reference, i.invoice_number, p.amount, p.payment_method, p.payment_status, p.transaction_date FROM payments p JOIN invoices i ON p.invoice_id = i.invoice_id";
                try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        writer.printf("%s,%s,%.2f,%s,%s,%s\n", rs.getString(1), rs.getString(2), rs.getBigDecimal(3), rs.getString(4), rs.getString(5), rs.getTimestamp(6));
                    }
                }
            } else if ("popular_services".equals(reportType)) {
                writer.println("Service Name,Category,Total Bookings,Standard Price (LKR)");
                String sql = "SELECT s.service_name, c.category_name, COUNT(a.appointment_id) AS total_bookings, s.standard_price FROM services s JOIN service_categories c ON s.category_id = c.category_id LEFT JOIN appointments a ON s.service_id = a.service_id GROUP BY s.service_id, s.service_name, c.category_name, s.standard_price ORDER BY total_bookings DESC";
                try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        writer.printf("%s,%s,%d,%.2f\n", rs.getString(1), rs.getString(2), rs.getInt(3), rs.getBigDecimal(4));
                    }
                }
            } else {
                writer.println("Appointment Number,Requested Date,Status,Service,Patient Name");
                String sql = "SELECT a.appointment_number, a.requested_date, s.status_code, ser.service_name, CONCAT(u.first_name, ' ', u.last_name) FROM appointments a JOIN appointment_statuses s ON a.status_id = s.status_id JOIN services ser ON a.service_id = ser.service_id JOIN patients p ON a.patient_id = p.patient_id JOIN users u ON p.user_id = u.user_id";
                try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        writer.printf("%s,%s,%s,%s,%s\n", rs.getString(1), rs.getDate(2), rs.getString(3), rs.getString(4), rs.getString(5));
                    }
                }
            }
        } catch (SQLException e) {
            writer.println("Error generating CSV report.");
        }
        writer.flush();
    }
}
