<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dentalclinic.model.Service" %>
<%@ page import="com.dentalclinic.model.Doctor" %>
<%@ page import="com.dentalclinic.model.Appointment" %>
<%@ page import="com.dentalclinic.dto.DoctorApprovalReviewDTO" %>

<%
    request.setAttribute("activeNav", "book");
    Appointment rescheduleApp = (Appointment) request.getAttribute("rescheduleAppointment");
    DoctorApprovalReviewDTO doctorReview = (DoctorApprovalReviewDTO) request.getAttribute("doctorReview");
    boolean isRescheduling = rescheduleApp != null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DentalCare | <%= isRescheduling ? "Reschedule Appointment" : "Request Appointment" %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/dental.css">
</head>
<body>

    <jsp:include page="/WEB-INF/includes/patient-header.jsp" />

    <main class="main-container">
        <div class="card" style="max-width: 850px; margin: 0 auto;">
            <div class="page-header" style="margin-bottom: 24px;">
                <div class="page-title-group">
                    <h1><%= isRescheduling ? "Reschedule Appointment" : "Request an Appointment" %></h1>
                    <p><%= isRescheduling ? "Select a new date and available time slot requested by your doctor." : "Select your service, doctor, and preferred time slot. Availability is calculated in real time." %></p>
                </div>
            </div>

            <% if (isRescheduling) { %>
                <div class="alert alert-warning" style="margin-bottom: 24px; border-left: 4px solid #f59e0b;">
                    <div style="font-weight: 800; font-size: 16px; margin-bottom: 4px; color: #92400e;">⚠️ Doctor Requested Reschedule</div>
                    <div style="font-size: 14px; color: #78350f;">
                        Your attending doctor requested a different appointment time.
                        <% if (doctorReview != null && doctorReview.getPatientReason() != null) { %>
                            <br><strong>Doctor's Note:</strong> <%= doctorReview.getPatientReason() %>
                        <% } %>
                    </div>
                </div>
            <% } %>

            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="alert alert-error" style="margin-bottom: 20px;">
                    <%= error %>
                </div>
            <%
                }

                List<Service> services = (List<Service>) request.getAttribute("services");
                List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
                Integer selectedServiceId = (Integer) request.getAttribute("selectedServiceId");
            %>

            <form action="${pageContext.request.contextPath}/patient/appointments/request" method="post" id="appointmentForm">
                <% if (isRescheduling) { %>
                    <input type="hidden" name="rescheduleId" value="<%= rescheduleApp.getAppointmentId() %>">
                <% } %>

                <div class="form-group">
                    <label class="form-label" for="serviceId">Dental Service</label>
                    <select class="form-control" id="serviceId" name="serviceId" required onchange="loadDoctors(this.value)" <%= isRescheduling ? "disabled" : "" %>>
                        <option value="">-- Select a Service --</option>
                        <%
                            if (services != null) {
                                for (Service service : services) {
                                    boolean selected = selectedServiceId != null && selectedServiceId.equals(service.getServiceId());
                        %>
                            <option value="<%= service.getServiceId() %>" <%= selected ? "selected" : "" %>>
                                <%= service.getServiceName() %> — LKR <%= service.getStandardPrice() %> (<%= service.getDurationMinutes() %> mins)
                            </option>
                        <%
                                }
                            }
                        %>
                    </select>
                    <% if (isRescheduling) { %>
                        <input type="hidden" name="serviceId" value="<%= rescheduleApp.getServiceId() %>">
                    <% } %>
                </div>

                <div class="form-group">
                    <label class="form-label" for="doctorId">Preferred Doctor</label>
                    <select class="form-control" id="doctorId" name="doctorId" required onchange="fetchAvailableSlots()" <%= isRescheduling ? "disabled" : "" %>>
                        <option value="">-- Select a Service First --</option>
                        <%
                            if (doctors != null && !doctors.isEmpty()) {
                                for (Doctor doctor : doctors) {
                                    boolean selectedDoc = isRescheduling && rescheduleApp.getDoctorId() != null && rescheduleApp.getDoctorId().equals(doctor.getDoctorId());
                        %>
                            <option value="<%= doctor.getDoctorId() %>" <%= selectedDoc ? "selected" : "" %>>
                                Dr. <%= doctor.getFullName() %> (<%= doctor.getSpecialization() %>)
                            </option>
                        <%
                                }
                            }
                        %>
                    </select>
                    <% if (isRescheduling) { %>
                        <input type="hidden" name="doctorId" value="<%= rescheduleApp.getDoctorId() %>">
                    <% } %>
                </div>

                <div class="form-group">
                    <label class="form-label" for="requestedDate">Appointment Date</label>
                    <input class="form-control" type="date" id="requestedDate" name="requestedDate" required onchange="fetchAvailableSlots()" min="<%= java.time.LocalDate.now() %>">
                </div>

                <!-- REAL-TIME SLOT PICKER CONTAINER -->
                <div class="form-group">
                    <label class="form-label">Available Appointment Time Slots</label>
                    <input type="hidden" id="requestedTime" value="">

                    <div class="slot-picker-box" id="slotPickerBox">
                        <div class="slot-picker-header">
                            <span class="slot-picker-title">Select a Time</span>
                            <div class="slot-legend">
                                <span class="slot-legend-item"><span class="slot-dot available-dot"></span> Available</span>
                                <span class="slot-legend-item"><span class="slot-dot unavailable-dot"></span> Unavailable</span>
                            </div>
                        </div>

                        <div id="slotMessage" style="font-size: 13px; color: var(--text-muted); padding: 8px 0;">
                            Please select a Service, Doctor, and Date above to view available time slots.
                        </div>

                        <div class="time-slot-grid" id="slotGrid" style="display: none;">
                            <!-- Dynamically populated slot radio & label controls -->
                        </div>
                    </div>
                </div>

                <div class="form-group" style="margin-top: 20px;">
                    <label class="form-label" for="patientReason">Reason for Visit / Note</label>
                    <textarea class="form-control" id="patientReason" name="patientReason" maxlength="2000" rows="3" placeholder="Briefly describe your symptoms or note for doctor..."><%= isRescheduling ? (rescheduleApp.getPatientReason() != null ? rescheduleApp.getPatientReason() : "") : "" %></textarea>
                </div>

                <div style="display: flex; gap: 12px; margin-top: 28px;">
                    <a href="${pageContext.request.contextPath}/patient/dashboard" class="btn btn-secondary" style="flex: 1;">Cancel</a>
                    <button type="submit" class="btn btn-primary" style="flex: 2;" id="submitBtn" disabled>
                        <%= isRescheduling ? "Submit Rescheduled Time →" : "Submit Request →" %>
                    </button>
                </div>
            </form>
        </div>
    </main>

    <footer class="app-footer">
        DentalCare Clinic Management System
    </footer>

    <script>
        function loadDoctors(serviceId) {
            if (!serviceId) {
                window.location = '${pageContext.request.contextPath}/patient/appointments/request';
                return;
            }
            window.location = '${pageContext.request.contextPath}/patient/appointments/request?serviceId=' + encodeURIComponent(serviceId);
        }

        async function fetchAvailableSlots() {
            const serviceId = document.getElementById('serviceId').value;
            const doctorId = document.getElementById('doctorId').value;
            const date = document.getElementById('requestedDate').value;
            const slotGrid = document.getElementById('slotGrid');
            const slotMessage = document.getElementById('slotMessage');
            const requestedTimeInput = document.getElementById('requestedTime');
            const submitBtn = document.getElementById('submitBtn');
            const excludeId = '<%= isRescheduling ? rescheduleApp.getAppointmentId() : "" %>';

            requestedTimeInput.value = '';
            submitBtn.disabled = true;

            if (!serviceId || !doctorId || !date) {
                slotGrid.style.display = 'none';
                slotMessage.style.display = 'block';
                slotMessage.innerHTML = 'Please select a Service, Doctor, and Date above to view available time slots.';
                return;
            }

            slotMessage.style.display = 'block';
            slotMessage.innerHTML = '⏳ Calculating doctor working schedule and appointment availability...';
            slotGrid.style.display = 'none';

            try {
                let url = '${pageContext.request.contextPath}/api/available-slots?doctorId=' + encodeURIComponent(doctorId)
                    + '&serviceId=' + encodeURIComponent(serviceId)
                    + '&date=' + encodeURIComponent(date);
                if (excludeId) {
                    url += '&excludeId=' + encodeURIComponent(excludeId);
                }

                const response = await fetch(url);
                const slots = await response.json();

                if (!response.ok || slots.error) {
                    slotMessage.innerHTML = '❌ ' + (slots.message || 'Unable to load slots.');
                    return;
                }

                if (!slots || slots.length === 0) {
                    slotMessage.innerHTML = '⚠️ No working hours or schedule available for the selected doctor on this date.';
                    return;
                }

                slotMessage.style.display = 'none';
                slotGrid.innerHTML = '';
                slotGrid.className = 'time-slot-grid';
                slotGrid.style.display = 'grid';

                let availableCount = 0;
                slots.forEach((slot, idx) => {
                    const slotId = 'requestedTime_' + idx;

                    const radio = document.createElement('input');
                    radio.type = 'radio';
                    radio.id = slotId;
                    radio.name = 'requestedTime';
                    radio.value = slot.time;
                    radio.className = 'time-slot-radio';

                    const label = document.createElement('label');
                    label.htmlFor = slotId;

                    if (!slot.available) {
                        radio.disabled = true;
                        label.className = 'time-slot-label unavailable';
                        label.innerHTML = '<span class="slot-time">' + slot.formattedTime + '</span>'
                            + (slot.reason ? '<span class="slot-reason">' + slot.reason + '</span>' : '');
                    } else {
                        availableCount++;
                        label.className = 'time-slot-label available';
                        radio.required = true;
                        radio.onchange = function() {
                            if (radio.checked) {
                                requestedTimeInput.value = slot.time;
                                submitBtn.disabled = false;
                            }
                        };
                        label.innerHTML = '<span class="slot-time">' + slot.formattedTime + '</span>';
                    }

                    slotGrid.appendChild(radio);
                    slotGrid.appendChild(label);
                });

                if (availableCount === 0) {
                    const note = document.createElement('div');
                    note.style.gridColumn = '1 / -1';
                    note.style.color = 'var(--danger)';
                    note.style.fontSize = '13px';
                    note.style.padding = '8px 0';
                    note.innerHTML = 'All time slots on this date are fully booked or unavailable. Please choose another date.';
                    slotGrid.appendChild(note);
                }

            } catch (err) {
                slotMessage.style.display = 'block';
                slotMessage.innerHTML = '❌ Connection error fetching availability: ' + err.message;
            }
        }

        // Auto-fetch if fields are pre-filled on load (e.g. rescheduling)
        document.addEventListener('DOMContentLoaded', function() {
            const docVal = document.getElementById('doctorId').value;
            const dateVal = document.getElementById('requestedDate').value;
            if (docVal && dateVal) {
                fetchAvailableSlots();
            }
        });
    </script>

</body>
</html>