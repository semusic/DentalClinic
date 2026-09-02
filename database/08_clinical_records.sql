USE dental_clinic;

CREATE TABLE visit_services (
    visit_service_id INT AUTO_INCREMENT PRIMARY KEY,

    visit_id INT NOT NULL,
    service_id INT NOT NULL,
    performed_by_doctor_id INT NOT NULL,

    quantity INT NOT NULL DEFAULT 1,

    unit_price DECIMAL(10,2) NOT NULL,
    line_total DECIMAL(10,2) NOT NULL,

    treatment_notes TEXT,

    performed_at DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_visit_services_visit
        FOREIGN KEY (visit_id)
        REFERENCES patient_visits(visit_id),

    CONSTRAINT fk_visit_services_service
        FOREIGN KEY (service_id)
        REFERENCES services(service_id),

    CONSTRAINT fk_visit_services_doctor
        FOREIGN KEY (performed_by_doctor_id)
        REFERENCES doctors(doctor_id),

    CONSTRAINT chk_visit_services_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_visit_services_price
        CHECK (unit_price >= 0),

    CONSTRAINT chk_visit_services_total
        CHECK (line_total >= 0)
) ENGINE=InnoDB;


CREATE TABLE visit_medications (
    visit_medication_id INT AUTO_INCREMENT PRIMARY KEY,

    visit_id INT NOT NULL,
    prescribed_by_doctor_id INT NOT NULL,

    medication_name VARCHAR(150) NOT NULL,
    dosage VARCHAR(100),
    quantity INT,
    instructions VARCHAR(500),

    provided_to_patient BOOLEAN NOT NULL DEFAULT FALSE,

    prescribed_at DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_visit_medications_visit
        FOREIGN KEY (visit_id)
        REFERENCES patient_visits(visit_id),

    CONSTRAINT fk_visit_medications_doctor
        FOREIGN KEY (prescribed_by_doctor_id)
        REFERENCES doctors(doctor_id),

    CONSTRAINT chk_visit_medications_quantity
        CHECK (
            quantity IS NULL
            OR quantity > 0
        )
) ENGINE=InnoDB;


CREATE TABLE follow_ups (
    follow_up_id INT AUTO_INCREMENT PRIMARY KEY,

    visit_id INT NOT NULL,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,

    follow_up_type VARCHAR(50) NOT NULL,

    due_date DATE NOT NULL,

    notes VARCHAR(1000),

    status VARCHAR(30) NOT NULL DEFAULT 'SCHEDULED',

    completed_at DATETIME NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_follow_ups_visit
        FOREIGN KEY (visit_id)
        REFERENCES patient_visits(visit_id),

    CONSTRAINT fk_follow_ups_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),

    CONSTRAINT fk_follow_ups_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id),

    CONSTRAINT chk_follow_up_status
        CHECK (
            status IN (
                'SCHEDULED',
                'COMPLETED',
                'CANCELLED',
                'MISSED'
            )
        )
) ENGINE=InnoDB;