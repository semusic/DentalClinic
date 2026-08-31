USE dental_clinic;

ALTER TABLE doctor_approvals
    ADD COLUMN approval_token_hash CHAR(64) NULL,
    ADD COLUMN token_expires_at DATETIME NULL,
    ADD COLUMN token_used_at DATETIME NULL;

CREATE UNIQUE INDEX uq_doctor_approval_token_hash
    ON doctor_approvals (approval_token_hash);