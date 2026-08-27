CREATE DATABASE IF NOT EXISTS dental_clinic
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE dental_clinic;

CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    role_id INT NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    last_login DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_users_role
        FOREIGN KEY (role_id)
        REFERENCES roles(role_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    date_of_birth DATE,
    gender VARCHAR(20),
    address VARCHAR(255),
    emergency_contact_name VARCHAR(150),
    emergency_contact_phone VARCHAR(20),
    medical_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_patients_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(150) NOT NULL,
    registration_no VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    email VARCHAR(150),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE service_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    service_name VARCHAR(150) NOT NULL,
    description TEXT,
    duration_minutes INT NOT NULL,
    standard_price DECIMAL(10,2) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_service_duration
        CHECK (duration_minutes > 0),

    CONSTRAINT chk_service_price
        CHECK (standard_price >= 0),

    CONSTRAINT fk_services_category
        FOREIGN KEY (category_id)
        REFERENCES service_categories(category_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE doctor_services (
    doctor_id INT NOT NULL,
    service_id INT NOT NULL,

    PRIMARY KEY (doctor_id, service_id),

    CONSTRAINT fk_doctor_services_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_doctor_services_service
        FOREIGN KEY (service_id)
        REFERENCES services(service_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE doctor_schedules (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    day_of_week TINYINT NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    max_appointments INT NOT NULL DEFAULT 10,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT chk_schedule_day
        CHECK (day_of_week BETWEEN 1 AND 7),

    CONSTRAINT chk_schedule_time
        CHECK (start_time < end_time),

    CONSTRAINT chk_schedule_capacity
        CHECK (max_appointments > 0),

    CONSTRAINT fk_schedules_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE appointment_statuses (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_code VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    service_id INT NOT NULL,
    doctor_id INT NULL,
    requested_date DATE NOT NULL,
    requested_time TIME NULL,
    scheduled_start DATETIME NULL,
    scheduled_end DATETIME NULL,
    status_id INT NOT NULL,
    patient_reason TEXT,
    reviewed_by_user_id INT NULL,
    last_modified_by_user_id INT NULL,
    reviewed_at DATETIME NULL,
    cancellation_reason VARCHAR(500) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_appointments_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_appointments_service
        FOREIGN KEY (service_id)
        REFERENCES services(service_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_appointments_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_appointments_status
        FOREIGN KEY (status_id)
        REFERENCES appointment_statuses(status_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_appointments_reviewer
        FOREIGN KEY (reviewed_by_user_id)
        REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_appointments_last_modified_by
        FOREIGN KEY (last_modified_by_user_id)
        REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT chk_scheduled_range
        CHECK (
            scheduled_start IS NULL
            OR scheduled_end IS NULL
            OR scheduled_start < scheduled_end
        ),

    INDEX idx_appointments_patient (patient_id),
    INDEX idx_appointments_doctor (doctor_id),
    INDEX idx_appointments_status (status_id),
    INDEX idx_appointments_schedule (scheduled_start)
) ENGINE=InnoDB;

CREATE TABLE doctor_approvals (
    approval_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    doctor_id INT NOT NULL,
    decision VARCHAR(30) NOT NULL,
    decision_note VARCHAR(1000),
    decision_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recorded_by_user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_approval_decision
        CHECK (
            decision IN (
                'APPROVED',
                'REJECTED',
                'RESCHEDULE_REQUIRED'
            )
        ),

    CONSTRAINT fk_approvals_appointment
        FOREIGN KEY (appointment_id)
        REFERENCES appointments(appointment_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_approvals_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_approvals_recorded_by
        FOREIGN KEY (recorded_by_user_id)
        REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    INDEX idx_doctor_approvals_appointment (appointment_id),
    INDEX idx_doctor_approvals_doctor (doctor_id)
) ENGINE=InnoDB;

CREATE TABLE appointment_status_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    old_status_id INT NULL,
    new_status_id INT NOT NULL,
    changed_by_user_id INT NULL,
    change_reason VARCHAR(500),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_status_history_appointment
        FOREIGN KEY (appointment_id)
        REFERENCES appointments(appointment_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_status_history_old
        FOREIGN KEY (old_status_id)
        REFERENCES appointment_statuses(status_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_status_history_new
        FOREIGN KEY (new_status_id)
        REFERENCES appointment_statuses(status_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_status_history_user
        FOREIGN KEY (changed_by_user_id)
        REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    INDEX idx_status_history_appointment (appointment_id),
    INDEX idx_status_history_changed_at (changed_at)
) ENGINE=InnoDB;

CREATE TABLE patient_visits (
    visit_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE,
    checked_in_at DATETIME NULL,
    consultation_started_at DATETIME NULL,
    consultation_completed_at DATETIME NULL,
    visit_notes TEXT,
    recorded_by_user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_visits_appointment
        FOREIGN KEY (appointment_id)
        REFERENCES appointments(appointment_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_visits_recorded_by
        FOREIGN KEY (recorded_by_user_id)
        REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_visit_times
        CHECK (
            consultation_started_at IS NULL
            OR consultation_completed_at IS NULL
            OR consultation_started_at <= consultation_completed_at
        )
) ENGINE=InnoDB;

CREATE TABLE invoices (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    visit_id INT NOT NULL UNIQUE,
    patient_id INT NOT NULL,
    invoice_number VARCHAR(50) NOT NULL UNIQUE,
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    discount_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    tax_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    invoice_status VARCHAR(30) NOT NULL DEFAULT 'UNPAID',
    issued_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    due_date DATE NULL,
    created_by_user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_invoice_amounts
        CHECK (
            subtotal >= 0
            AND discount_amount >= 0
            AND tax_amount >= 0
            AND total_amount >= 0
        ),

    CONSTRAINT chk_invoice_status
        CHECK (
            invoice_status IN (
                'UNPAID',
                'PARTIALLY_PAID',
                'PAID',
                'CANCELLED'
            )
        ),

    CONSTRAINT fk_invoices_visit
        FOREIGN KEY (visit_id)
        REFERENCES patient_visits(visit_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_invoices_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_invoices_created_by
        FOREIGN KEY (created_by_user_id)
        REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE invoice_items (
    invoice_item_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT NOT NULL,
    service_id INT NULL,
    item_description VARCHAR(255) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    line_total DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_invoice_item_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_invoice_item_price
        CHECK (unit_price >= 0),

    CONSTRAINT chk_invoice_item_total
        CHECK (line_total >= 0),

    CONSTRAINT fk_invoice_items_invoice
        FOREIGN KEY (invoice_id)
        REFERENCES invoices(invoice_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_invoice_items_service
        FOREIGN KEY (service_id)
        REFERENCES services(service_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT NOT NULL,
    payment_reference VARCHAR(100) NOT NULL UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    payment_status VARCHAR(30) NOT NULL DEFAULT 'COMPLETED',
    transaction_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    processed_by_user_id INT NOT NULL,
    notes VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_payment_amount
        CHECK (amount > 0),

    CONSTRAINT chk_payment_method
        CHECK (
            payment_method IN (
                'CASH',
                'CARD',
                'BANK_TRANSFER',
                'ONLINE'
            )
        ),

    CONSTRAINT chk_payment_status
        CHECK (
            payment_status IN (
                'PENDING',
                'COMPLETED',
                'FAILED',
                'REFUNDED'
            )
        ),

    CONSTRAINT fk_payments_invoice
        FOREIGN KEY (invoice_id)
        REFERENCES invoices(invoice_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_payments_processed_by
        FOREIGN KEY (processed_by_user_id)
        REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE receipts (
    receipt_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_id INT NOT NULL UNIQUE,
    receipt_number VARCHAR(50) NOT NULL UNIQUE,
    issued_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    issued_by_user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_receipts_payment
        FOREIGN KEY (payment_id)
        REFERENCES payments(payment_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_receipts_issued_by
        FOREIGN KEY (issued_by_user_id)
        REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    recipient_user_id INT NOT NULL,
    appointment_id INT NULL,
    notification_type VARCHAR(50) NOT NULL,
    channel VARCHAR(30) NOT NULL,
    subject VARCHAR(255),
    message TEXT NOT NULL,
    notification_status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    scheduled_at DATETIME NULL,
    sent_at DATETIME NULL,
    read_at DATETIME NULL,
    retry_count INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_notification_channel
        CHECK (
            channel IN (
                'EMAIL',
                'SMS',
                'IN_APP'
            )
        ),

    CONSTRAINT chk_notification_status
        CHECK (
            notification_status IN (
                'PENDING',
                'SENT',
                'FAILED',
                'READ',
                'CANCELLED'
            )
        ),

    CONSTRAINT chk_notification_retry
        CHECK (retry_count >= 0),

    CONSTRAINT fk_notifications_user
        FOREIGN KEY (recipient_user_id)
        REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_notifications_appointment
        FOREIGN KEY (appointment_id)
        REFERENCES appointments(appointment_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE notification_delivery_logs (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    notification_id INT NOT NULL,
    attempt_number INT NOT NULL DEFAULT 1,
    provider_name VARCHAR(100),
    provider_reference VARCHAR(150),
    delivery_status VARCHAR(30) NOT NULL,
    error_message VARCHAR(1000),
    attempted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_delivery_attempt
        CHECK (attempt_number > 0),

    CONSTRAINT chk_delivery_status
        CHECK (
            delivery_status IN (
                'SUCCESS',
                'FAILED'
            )
        ),

    CONSTRAINT fk_delivery_notification
        FOREIGN KEY (notification_id)
        REFERENCES notifications(notification_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE audit_logs (
    audit_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100),
    entity_id VARCHAR(100),
    old_data LONGTEXT,
    new_data LONGTEXT,
    ip_address VARCHAR(45),
    user_agent VARCHAR(500),
    severity VARCHAR(20) NOT NULL DEFAULT 'INFO',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_audit_severity
        CHECK (
            severity IN (
                'INFO',
                'WARNING',
                'CRITICAL'
            )
        ),

    CONSTRAINT fk_audit_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB;
