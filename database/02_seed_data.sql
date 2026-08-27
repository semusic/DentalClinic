USE dental_clinic;

-- =========================================================
-- ROLES
-- =========================================================

INSERT INTO roles (role_name, description)
SELECT 'PATIENT', 'Registered clinic patient'
WHERE NOT EXISTS (
    SELECT 1 FROM roles WHERE role_name = 'PATIENT'
);

INSERT INTO roles (role_name, description)
SELECT 'ASSISTANT', 'Clinic assistant or receptionist'
WHERE NOT EXISTS (
    SELECT 1 FROM roles WHERE role_name = 'ASSISTANT'
);

INSERT INTO roles (role_name, description)
SELECT 'CASHIER', 'Staff member responsible for billing and payments'
WHERE NOT EXISTS (
    SELECT 1 FROM roles WHERE role_name = 'CASHIER'
);

INSERT INTO roles (role_name, description)
SELECT 'ADMIN', 'System administrator'
WHERE NOT EXISTS (
    SELECT 1 FROM roles WHERE role_name = 'ADMIN'
);


-- =========================================================
-- APPOINTMENT STATUSES
-- =========================================================

INSERT INTO appointment_statuses (status_code, description)
SELECT 'PENDING', 'Appointment request submitted by patient'
WHERE NOT EXISTS (
    SELECT 1 FROM appointment_statuses WHERE status_code = 'PENDING'
);

INSERT INTO appointment_statuses (status_code, description)
SELECT 'UNDER_REVIEW', 'Assistant is reviewing the request'
WHERE NOT EXISTS (
    SELECT 1 FROM appointment_statuses WHERE status_code = 'UNDER_REVIEW'
);

INSERT INTO appointment_statuses (status_code, description)
SELECT 'AWAITING_DOCTOR_APPROVAL', 'Waiting for doctor decision'
WHERE NOT EXISTS (
    SELECT 1 FROM appointment_statuses
    WHERE status_code = 'AWAITING_DOCTOR_APPROVAL'
);

INSERT INTO appointment_statuses (status_code, description)
SELECT 'DOCTOR_APPROVED', 'Doctor has approved the request'
WHERE NOT EXISTS (
    SELECT 1 FROM appointment_statuses
    WHERE status_code = 'DOCTOR_APPROVED'
);

INSERT INTO appointment_statuses (status_code, description)
SELECT 'CONFIRMED', 'Appointment has been confirmed'
WHERE NOT EXISTS (
    SELECT 1 FROM appointment_statuses WHERE status_code = 'CONFIRMED'
);

INSERT INTO appointment_statuses (status_code, description)
SELECT 'REJECTED', 'Appointment request was rejected'
WHERE NOT EXISTS (
    SELECT 1 FROM appointment_statuses WHERE status_code = 'REJECTED'
);

INSERT INTO appointment_statuses (status_code, description)
SELECT 'RESCHEDULE_REQUIRED', 'A different appointment time is required'
WHERE NOT EXISTS (
    SELECT 1 FROM appointment_statuses
    WHERE status_code = 'RESCHEDULE_REQUIRED'
);

INSERT INTO appointment_statuses (status_code, description)
SELECT 'CANCELLED', 'Appointment was cancelled'
WHERE NOT EXISTS (
    SELECT 1 FROM appointment_statuses WHERE status_code = 'CANCELLED'
);

INSERT INTO appointment_statuses (status_code, description)
SELECT 'CHECKED_IN', 'Patient has arrived and checked in'
WHERE NOT EXISTS (
    SELECT 1 FROM appointment_statuses WHERE status_code = 'CHECKED_IN'
);

INSERT INTO appointment_statuses (status_code, description)
SELECT 'IN_PROGRESS', 'Consultation is in progress'
WHERE NOT EXISTS (
    SELECT 1 FROM appointment_statuses WHERE status_code = 'IN_PROGRESS'
);

INSERT INTO appointment_statuses (status_code, description)
SELECT 'COMPLETED', 'Consultation has been completed'
WHERE NOT EXISTS (
    SELECT 1 FROM appointment_statuses WHERE status_code = 'COMPLETED'
);

INSERT INTO appointment_statuses (status_code, description)
SELECT 'NO_SHOW', 'Patient did not attend'
WHERE NOT EXISTS (
    SELECT 1 FROM appointment_statuses WHERE status_code = 'NO_SHOW'
);

INSERT INTO appointment_statuses (status_code, description)
SELECT 'INVOICED', 'Invoice has been generated'
WHERE NOT EXISTS (
    SELECT 1 FROM appointment_statuses WHERE status_code = 'INVOICED'
);

INSERT INTO appointment_statuses (status_code, description)
SELECT 'PAID', 'Payment has been completed'
WHERE NOT EXISTS (
    SELECT 1 FROM appointment_statuses WHERE status_code = 'PAID'
);


-- =========================================================
-- SERVICE CATEGORIES
-- =========================================================

INSERT INTO service_categories (category_name, description)
SELECT 'Preventive', 'Preventive dental care and examinations'
WHERE NOT EXISTS (
    SELECT 1 FROM service_categories
    WHERE category_name = 'Preventive'
);

INSERT INTO service_categories (category_name, description)
SELECT 'Restorative', 'Restorative dental treatments'
WHERE NOT EXISTS (
    SELECT 1 FROM service_categories
    WHERE category_name = 'Restorative'
);

INSERT INTO service_categories (category_name, description)
SELECT 'Cosmetic', 'Cosmetic and aesthetic dental services'
WHERE NOT EXISTS (
    SELECT 1 FROM service_categories
    WHERE category_name = 'Cosmetic'
);

INSERT INTO service_categories (category_name, description)
SELECT 'Oral Surgery', 'Dental extraction and surgical procedures'
WHERE NOT EXISTS (
    SELECT 1 FROM service_categories
    WHERE category_name = 'Oral Surgery'
);


-- =========================================================
-- SERVICES
-- =========================================================

INSERT INTO services
(category_id, service_name, description, duration_minutes, standard_price)
SELECT category_id,
       'Dental Consultation',
       'Initial dental examination and consultation',
       30,
       3000.00
FROM service_categories
WHERE category_name = 'Preventive'
AND NOT EXISTS (
    SELECT 1 FROM services
    WHERE service_name = 'Dental Consultation'
);

INSERT INTO services
(category_id, service_name, description, duration_minutes, standard_price)
SELECT category_id,
       'Dental Cleaning',
       'Professional dental cleaning and polishing',
       45,
       6000.00
FROM service_categories
WHERE category_name = 'Preventive'
AND NOT EXISTS (
    SELECT 1 FROM services
    WHERE service_name = 'Dental Cleaning'
);

INSERT INTO services
(category_id, service_name, description, duration_minutes, standard_price)
SELECT category_id,
       'Dental Filling',
       'Tooth restoration using a dental filling',
       60,
       8000.00
FROM service_categories
WHERE category_name = 'Restorative'
AND NOT EXISTS (
    SELECT 1 FROM services
    WHERE service_name = 'Dental Filling'
);

INSERT INTO services
(category_id, service_name, description, duration_minutes, standard_price)
SELECT category_id,
       'Teeth Whitening',
       'Professional cosmetic teeth whitening',
       60,
       25000.00
FROM service_categories
WHERE category_name = 'Cosmetic'
AND NOT EXISTS (
    SELECT 1 FROM services
    WHERE service_name = 'Teeth Whitening'
);

INSERT INTO services
(category_id, service_name, description, duration_minutes, standard_price)
SELECT category_id,
       'Tooth Extraction',
       'Routine dental extraction',
       45,
       7000.00
FROM service_categories
WHERE category_name = 'Oral Surgery'
AND NOT EXISTS (
    SELECT 1 FROM services
    WHERE service_name = 'Tooth Extraction'
);


-- =========================================================
-- DEMONSTRATION DOCTORS
-- =========================================================

INSERT INTO doctors
(first_name, last_name, specialization, registration_no, phone, email)
SELECT 'Amara', 'Perera', 'General Dentistry',
       'SL-DENT-001', '0771000001',
       'amara.perera@example.com'
WHERE NOT EXISTS (
    SELECT 1 FROM doctors
    WHERE registration_no = 'SL-DENT-001'
);

INSERT INTO doctors
(first_name, last_name, specialization, registration_no, phone, email)
SELECT 'Nimal', 'Fernando', 'Restorative Dentistry',
       'SL-DENT-002', '0771000002',
       'nimal.fernando@example.com'
WHERE NOT EXISTS (
    SELECT 1 FROM doctors
    WHERE registration_no = 'SL-DENT-002'
);

INSERT INTO doctors
(first_name, last_name, specialization, registration_no, phone, email)
SELECT 'Kavitha', 'Raj', 'Cosmetic Dentistry',
       'SL-DENT-003', '0771000003',
       'kavitha.raj@example.com'
WHERE NOT EXISTS (
    SELECT 1 FROM doctors
    WHERE registration_no = 'SL-DENT-003'
);


-- =========================================================
-- DOCTOR ↔ SERVICE ASSIGNMENTS
-- =========================================================

INSERT IGNORE INTO doctor_services (doctor_id, service_id)
SELECT d.doctor_id, s.service_id
FROM doctors d
JOIN services s
WHERE d.registration_no = 'SL-DENT-001'
AND s.service_name IN (
    'Dental Consultation',
    'Dental Cleaning',
    'Tooth Extraction'
);

INSERT IGNORE INTO doctor_services (doctor_id, service_id)
SELECT d.doctor_id, s.service_id
FROM doctors d
JOIN services s
WHERE d.registration_no = 'SL-DENT-002'
AND s.service_name IN (
    'Dental Consultation',
    'Dental Filling',
    'Tooth Extraction'
);

INSERT IGNORE INTO doctor_services (doctor_id, service_id)
SELECT d.doctor_id, s.service_id
FROM doctors d
JOIN services s
WHERE d.registration_no = 'SL-DENT-003'
AND s.service_name IN (
    'Dental Consultation',
    'Dental Cleaning',
    'Teeth Whitening'
);


-- =========================================================
-- BASIC WEEKLY DOCTOR SCHEDULES
-- =========================================================

INSERT INTO doctor_schedules
(doctor_id, day_of_week, start_time, end_time, max_appointments)
SELECT doctor_id, 1, '09:00:00', '16:00:00', 10
FROM doctors
WHERE registration_no = 'SL-DENT-001'
AND NOT EXISTS (
    SELECT 1 FROM doctor_schedules ds
    WHERE ds.doctor_id = doctors.doctor_id
      AND ds.day_of_week = 1
);

INSERT INTO doctor_schedules
(doctor_id, day_of_week, start_time, end_time, max_appointments)
SELECT doctor_id, 2, '09:00:00', '16:00:00', 10
FROM doctors
WHERE registration_no = 'SL-DENT-001'
AND NOT EXISTS (
    SELECT 1 FROM doctor_schedules ds
    WHERE ds.doctor_id = doctors.doctor_id
      AND ds.day_of_week = 2
);

INSERT INTO doctor_schedules
(doctor_id, day_of_week, start_time, end_time, max_appointments)
SELECT doctor_id, 3, '09:00:00', '16:00:00', 10
FROM doctors
WHERE registration_no = 'SL-DENT-001'
AND NOT EXISTS (
    SELECT 1 FROM doctor_schedules ds
    WHERE ds.doctor_id = doctors.doctor_id
      AND ds.day_of_week = 3
);

INSERT INTO doctor_schedules
(doctor_id, day_of_week, start_time, end_time, max_appointments)
SELECT doctor_id, 4, '09:00:00', '16:00:00', 10
FROM doctors
WHERE registration_no = 'SL-DENT-001'
AND NOT EXISTS (
    SELECT 1 FROM doctor_schedules ds
    WHERE ds.doctor_id = doctors.doctor_id
      AND ds.day_of_week = 4
);

INSERT INTO doctor_schedules
(doctor_id, day_of_week, start_time, end_time, max_appointments)
SELECT doctor_id, 5, '09:00:00', '16:00:00', 10
FROM doctors
WHERE registration_no = 'SL-DENT-001'
AND NOT EXISTS (
    SELECT 1 FROM doctor_schedules ds
    WHERE ds.doctor_id = doctors.doctor_id
      AND ds.day_of_week = 5
);
