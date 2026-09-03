package com.dentalclinic.controller;

import com.dentalclinic.dao.AppointmentDAO;
import com.dentalclinic.dao.InvoiceDAO;
import com.dentalclinic.dao.InvoiceItemDAO;
import com.dentalclinic.dao.PatientDAO;
import com.dentalclinic.dao.ServiceDAO;
import com.dentalclinic.dao.impl.AppointmentDAOImpl;
import com.dentalclinic.dao.impl.InvoiceDAOImpl;
import com.dentalclinic.dao.impl.InvoiceItemDAOImpl;
import com.dentalclinic.dao.impl.PatientDAOImpl;
import com.dentalclinic.dao.impl.ServiceDAOImpl;
import com.dentalclinic.model.Appointment;
import com.dentalclinic.model.Invoice;
import com.dentalclinic.model.InvoiceItem;
import com.dentalclinic.model.Patient;
import com.dentalclinic.model.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

@WebServlet("/api/*")
public class RestApiServlet extends HttpServlet {

    private ServiceDAO serviceDAO;
    private AppointmentDAO appointmentDAO;
    private PatientDAO patientDAO;
    private InvoiceDAO invoiceDAO;
    private InvoiceItemDAO invoiceItemDAO;

    @Override
    public void init() {
        serviceDAO = new ServiceDAOImpl();
        appointmentDAO = new AppointmentDAOImpl();
        patientDAO = new PatientDAOImpl();
        invoiceDAO = new InvoiceDAOImpl();
        invoiceItemDAO = new InvoiceItemDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        String pathInfo = request.getPathInfo();
        PrintWriter out = response.getWriter();

        if (pathInfo == null || pathInfo.equals("/")) {
            sendJson(response, out, HttpServletResponse.SC_OK, """
                {
                    "status": 200,
                    "message": "DentalCare REST Web Services API",
                    "endpoints": [
                        "GET /api/services",
                        "GET /api/services/{id}",
                        "GET /api/appointments/{id_or_number}",
                        "GET /api/patients/{id}",
                        "GET /api/invoices/{id}"
                    ]
                }
                """);
            return;
        }

        String[] parts = pathInfo.split("/");
        // parts[0] is empty, parts[1] is resource, parts[2] is id optional
        if (parts.length < 2) {
            sendError(response, out, HttpServletResponse.SC_BAD_REQUEST, "Invalid API path format.");
            return;
        }

        String resource = parts[1].toLowerCase();
        String idParam = parts.length > 2 ? parts[2] : null;

        try {
            switch (resource) {
                case "services":
                    handleServices(response, out, idParam);
                    break;
                case "appointments":
                    handleAppointments(response, out, idParam);
                    break;
                case "patients":
                    handlePatients(response, out, idParam);
                    break;
                case "invoices":
                    handleInvoices(response, out, idParam);
                    break;
                case "available-slots":
                case "slots":
                    handleAvailableSlots(request, response, out);
                    break;
                default:
                    sendError(response, out, HttpServletResponse.SC_NOT_FOUND, "Unknown API resource: " + resource);
            }
        } catch (Exception e) {
            sendError(response, out, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server Error: " + e.getMessage());
        }
    }

    private void handleAvailableSlots(HttpServletRequest request, HttpServletResponse response, PrintWriter out) throws SQLException {
        String doctorIdParam = request.getParameter("doctorId");
        String serviceIdParam = request.getParameter("serviceId");
        String dateParam = request.getParameter("date");
        String excludeIdParam = request.getParameter("excludeId");

        if (doctorIdParam == null || serviceIdParam == null || dateParam == null) {
            sendError(response, out, HttpServletResponse.SC_BAD_REQUEST, "doctorId, serviceId, and date parameters are required.");
            return;
        }

        try {
            int doctorId = Integer.parseInt(doctorIdParam);
            int serviceId = Integer.parseInt(serviceIdParam);
            java.time.LocalDate date = java.time.LocalDate.parse(dateParam);
            Integer excludeId = (excludeIdParam != null && !excludeIdParam.isBlank()) ? Integer.parseInt(excludeIdParam) : null;

            com.dentalclinic.service.DoctorAvailabilityService availabilityService = new com.dentalclinic.service.impl.DoctorAvailabilityServiceImpl();
            List<com.dentalclinic.dto.TimeSlotDTO> slots = availabilityService.getAvailableSlots(doctorId, serviceId, date, excludeId);

            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < slots.size(); i++) {
                com.dentalclinic.dto.TimeSlotDTO slot = slots.get(i);
                sb.append(String.format("{\"time\":\"%s\",\"formattedTime\":\"%s\",\"available\":%b,\"reason\":\"%s\"}",
                        escapeJson(slot.getTime()), escapeJson(slot.getFormattedTime()), slot.isAvailable(), escapeJson(slot.getReason())));
                if (i < slots.size() - 1) sb.append(",");
            }
            sb.append("]");

            sendJson(response, out, HttpServletResponse.SC_OK, sb.toString());
        } catch (Exception e) {
            sendError(response, out, HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters for slot search: " + e.getMessage());
        }
    }

    private void handleServices(HttpServletResponse response, PrintWriter out, String idParam) throws SQLException {
        if (idParam == null || idParam.isBlank()) {
            List<Service> services = serviceDAO.findAllActive();
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < services.size(); i++) {
                Service s = services.get(i);
                sb.append(String.format("{\"serviceId\":%d,\"categoryName\":\"%s\",\"serviceName\":\"%s\",\"durationMinutes\":%d,\"standardPrice\":%.2f,\"active\":%b}",
                        s.getServiceId(), escapeJson(s.getCategoryName()), escapeJson(s.getServiceName()), s.getDurationMinutes(), s.getStandardPrice(), s.isActive()));
                if (i < services.size() - 1) sb.append(",");
            }
            sb.append("]");
            sendJson(response, out, HttpServletResponse.SC_OK, sb.toString());
        } else {
            try {
                int id = Integer.parseInt(idParam);
                Optional<Service> opt = serviceDAO.findById(id);
                if (opt.isPresent()) {
                    Service s = opt.get();
                    String json = String.format("{\"serviceId\":%d,\"categoryId\":%d,\"categoryName\":\"%s\",\"serviceName\":\"%s\",\"description\":\"%s\",\"durationMinutes\":%d,\"standardPrice\":%.2f,\"active\":%b}",
                            s.getServiceId(), s.getCategoryId(), escapeJson(s.getCategoryName()), escapeJson(s.getServiceName()), escapeJson(s.getDescription()), s.getDurationMinutes(), s.getStandardPrice(), s.isActive());
                    sendJson(response, out, HttpServletResponse.SC_OK, json);
                } else {
                    sendError(response, out, HttpServletResponse.SC_NOT_FOUND, "Service not found with ID: " + id);
                }
            } catch (NumberFormatException e) {
                sendError(response, out, HttpServletResponse.SC_BAD_REQUEST, "Invalid service ID format.");
            }
        }
    }

    private void handleAppointments(HttpServletResponse response, PrintWriter out, String idParam) throws SQLException {
        if (idParam == null || idParam.isBlank()) {
            sendError(response, out, HttpServletResponse.SC_BAD_REQUEST, "Appointment ID or Number parameter is required.");
            return;
        }

        Optional<Appointment> opt = appointmentDAO.findByAppointmentNumber(idParam);
        if (opt.isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                opt = appointmentDAO.findById(id);
            } catch (NumberFormatException ignored) {}
        }

        if (opt.isPresent()) {
            Appointment a = opt.get();
            String json = String.format("{\"appointmentId\":%d,\"appointmentNumber\":\"%s\",\"patientId\":%d,\"serviceId\":%d,\"doctorId\":%s,\"requestedDate\":\"%s\",\"requestedTime\":\"%s\",\"statusCode\":\"%s\"}",
                    a.getAppointmentId(),
                    escapeJson(a.getAppointmentNumber() != null ? a.getAppointmentNumber() : "APT-ID-" + a.getAppointmentId()),
                    a.getPatientId(), a.getServiceId(),
                    a.getDoctorId() != null ? a.getDoctorId().toString() : "null",
                    a.getRequestedDate(),
                    a.getRequestedTime() != null ? a.getRequestedTime().toString() : "",
                    escapeJson(a.getStatusCode()));
            sendJson(response, out, HttpServletResponse.SC_OK, json);
        } else {
            sendError(response, out, HttpServletResponse.SC_NOT_FOUND, "Appointment not found: " + idParam);
        }
    }

    private void handlePatients(HttpServletResponse response, PrintWriter out, String idParam) throws SQLException {
        if (idParam == null || idParam.isBlank()) {
            sendError(response, out, HttpServletResponse.SC_BAD_REQUEST, "Patient ID parameter is required.");
            return;
        }

        try {
            int patientId = Integer.parseInt(idParam);
            Optional<Patient> opt = patientDAO.findById(patientId);
            if (opt.isPresent()) {
                Patient p = opt.get();
                String json = String.format("{\"patientId\":%d,\"userId\":%d,\"dateOfBirth\":\"%s\",\"gender\":\"%s\",\"address\":\"%s\",\"emergencyContactName\":\"%s\",\"emergencyContactPhone\":\"%s\"}",
                        p.getPatientId(), p.getUserId(),
                        p.getDateOfBirth() != null ? p.getDateOfBirth().toString() : "",
                        escapeJson(p.getGender()), escapeJson(p.getAddress()),
                        escapeJson(p.getEmergencyContactName()), escapeJson(p.getEmergencyContactPhone()));
                sendJson(response, out, HttpServletResponse.SC_OK, json);
            } else {
                sendError(response, out, HttpServletResponse.SC_NOT_FOUND, "Patient not found with ID: " + patientId);
            }
        } catch (NumberFormatException e) {
            sendError(response, out, HttpServletResponse.SC_BAD_REQUEST, "Invalid patient ID format.");
        }
    }

    private void handleInvoices(HttpServletResponse response, PrintWriter out, String idParam) throws SQLException {
        if (idParam == null || idParam.isBlank()) {
            sendError(response, out, HttpServletResponse.SC_BAD_REQUEST, "Invoice ID parameter is required.");
            return;
        }

        try {
            int invoiceId = Integer.parseInt(idParam);
            Optional<Invoice> opt = invoiceDAO.findById(invoiceId);
            if (opt.isPresent()) {
                Invoice inv = opt.get();
                List<InvoiceItem> items = invoiceItemDAO.findByInvoiceId(inv.getInvoiceId());

                StringBuilder itemsJson = new StringBuilder("[");
                for (int i = 0; i < items.size(); i++) {
                    InvoiceItem item = items.get(i);
                    itemsJson.append(String.format("{\"description\":\"%s\",\"quantity\":%d,\"unitPrice\":%.2f,\"lineTotal\":%.2f}",
                            escapeJson(item.getItemDescription()), item.getQuantity(), item.getUnitPrice(), item.getLineTotal()));
                    if (i < items.size() - 1) itemsJson.append(",");
                }
                itemsJson.append("]");

                String json = String.format("{\"invoiceId\":%d,\"invoiceNumber\":\"%s\",\"visitId\":%d,\"patientId\":%d,\"subtotal\":%.2f,\"totalAmount\":%.2f,\"status\":\"%s\",\"items\":%s}",
                        inv.getInvoiceId(), escapeJson(inv.getInvoiceNumber()), inv.getVisitId(), inv.getPatientId(),
                        inv.getSubtotal(), inv.getTotalAmount(), escapeJson(inv.getInvoiceStatus()), itemsJson.toString());

                sendJson(response, out, HttpServletResponse.SC_OK, json);
            } else {
                sendError(response, out, HttpServletResponse.SC_NOT_FOUND, "Invoice not found with ID: " + invoiceId);
            }
        } catch (NumberFormatException e) {
            sendError(response, out, HttpServletResponse.SC_BAD_REQUEST, "Invalid invoice ID format.");
        }
    }

    private void sendJson(HttpServletResponse response, PrintWriter out, int status, String json) {
        response.setStatus(status);
        out.print(json);
        out.flush();
    }

    private void sendError(HttpServletResponse response, PrintWriter out, int status, String message) {
        response.setStatus(status);
        out.print(String.format("{\"error\":true,\"status\":%d,\"message\":\"%s\"}", status, escapeJson(message)));
        out.flush();
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ").replace("\r", "");
    }
}
