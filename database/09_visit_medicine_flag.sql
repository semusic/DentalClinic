USE dental_clinic;

ALTER TABLE patient_visits
ADD COLUMN medicine_prescribed BOOLEAN
    NOT NULL DEFAULT FALSE;