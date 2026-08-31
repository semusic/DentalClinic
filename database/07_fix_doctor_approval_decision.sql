USE dental_clinic;

ALTER TABLE doctor_approvals
DROP CONSTRAINT chk_approval_decision;

ALTER TABLE doctor_approvals
ADD CONSTRAINT chk_approval_decision
CHECK (
    decision IN (
        'PENDING',
        'APPROVED',
        'REJECTED',
        'RESCHEDULE_REQUIRED'
    )
);