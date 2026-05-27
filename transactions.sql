-- =========================================================
-- TRANSACTION SCENARIOS
-- Database: CodeJudge
-- =========================================================



-- =========================================================
-- TRANSACTION 1:
-- Student Submission and Test Result Insertion
-- =========================================================

START TRANSACTION;

INSERT INTO submissions (
    submission_id,
    student_id,
    problem_id,
    score,
    status
)
VALUES (
    501,
    12,
    7,
    0,
    'Submitted'
);

INSERT INTO test_results (
    result_id,
    submission_id,
    result_status,
    runtime_ms
)
VALUES (
    9001,
    501,
    'Passed',
    120
);

COMMIT;

-- Expected Final State:
-- The new submission record and corresponding test result
-- are permanently stored in the database.



-- =========================================================
-- TRANSACTION 2:
-- Enrollment Creation with ROLLBACK
-- =========================================================

START TRANSACTION;

INSERT INTO enrollments (
    enrollment_id,
    student_id,
    course_id
)
VALUES (
    3001,
    15,
    101
);

-- Validation check failed
-- Student does not meet eligibility criteria

ROLLBACK;

-- Expected Final State:
-- No enrollment record remains in the database
-- because the transaction was rolled back.



-- =========================================================
-- TRANSACTION 3:
-- Score Correction with SAVEPOINT
-- =========================================================

START TRANSACTION;

-- Update submission score
UPDATE submissions
SET score = 85
WHERE submission_id = 501;

SAVEPOINT score_updated;

-- Attempt to update status
UPDATE submissions
SET status = 'Approved'
WHERE submission_id = 501;

-- Error detected in status update
ROLLBACK TO score_updated;

COMMIT;

-- Expected Final State:
-- Score update remains committed.
-- Submission status update is undone.
-- Partial rollback achieved using SAVEPOINT.



-- =========================================================
-- TRANSACTION 4:
-- Regrade Request Resolution
-- =========================================================

START TRANSACTION;

UPDATE regrade_requests
SET request_status = 'Resolved'
WHERE request_id = 2001;

UPDATE submissions
SET score = 95
WHERE submission_id = 501;

COMMIT;

-- Expected Final State:
-- Regrade request is marked as resolved.
-- Submission score is safely updated and committed.