-- =========================================================
-- SAFE UPDATE OPERATIONS
-- Database: CodeJudge
-- =========================================================


-- =========================================================
-- UPDATE 1: Correct Invalid Email Values
-- =========================================================

-- BEFORE UPDATE
SELECT student_id, full_name, email
FROM students
WHERE email NOT LIKE '%@%.%';

-- SAFE UPDATE
UPDATE students
SET email = CONCAT(student_id, '@codejudge.com')
WHERE email NOT LIKE '%@%.%';

-- AFTER UPDATE
SELECT student_id, full_name, email
FROM students
WHERE email LIKE '%@codejudge.com';

-- Safety Explanation:
-- The WHERE clause updates only rows having invalid email format.
-- Valid email records remain unchanged.



-- =========================================================
-- UPDATE 2: Fix Missing Batch Values
-- =========================================================

-- BEFORE UPDATE
SELECT student_id, full_name, graduation_year
FROM students
WHERE graduation_year IS NULL;

-- SAFE UPDATE
UPDATE students
SET graduation_year = '2025A'
WHERE graduation_year IS NULL;

-- AFTER UPDATE
SELECT student_id, full_name, graduation_year
FROM students
WHERE graduation_year = '2025A';

-- Safety Explanation:
-- Only records with NULL batch values are updated.
-- Existing valid batch values are preserved.



-- =========================================================
-- UPDATE 3: Correct Negative Scores
-- =========================================================

-- BEFORE UPDATE
SELECT submission_id, score
FROM submissions
WHERE score < 0;

-- SAFE UPDATE
UPDATE submissions
SET score = 0
WHERE score < 0;

-- AFTER UPDATE
SELECT submission_id, score
FROM submissions
WHERE score = 0;

-- Safety Explanation:
-- The WHERE clause ensures only invalid negative scores are corrected.
-- Positive and valid scores are untouched.



-- =========================================================
-- UPDATE 4: Update Submission Status Based on Test Results
-- =========================================================

-- BEFORE UPDATE
SELECT s.submission_id,
       s.status,
       t.result_status
FROM submissions s
JOIN test_results t
ON s.submission_id = t.submission_id
WHERE t.result_status = 'Passed'
AND s.status <> 'Accepted';

-- SAFE UPDATE
UPDATE submissions
SET status = 'Accepted'
WHERE submission_id IN (
    SELECT t.submission_id
    FROM test_results t
    WHERE t.result_status = 'Passed'
);

-- AFTER UPDATE
SELECT s.submission_id,
       s.status,
       t.result_status
FROM submissions s
JOIN test_results t
ON s.submission_id = t.submission_id
WHERE t.result_status = 'Passed';

-- Safety Explanation:
-- Only submissions with passing test results are updated.
-- The subquery restricts updates to verified submission IDs only.