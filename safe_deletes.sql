-- =========================================================
-- SAFE DELETE OPERATIONS
-- Database: CodeJudge
-- =========================================================


-- =========================================================
-- DELETE 1: Remove Duplicate Records from Staging Table
-- =========================================================

-- IDENTIFY DUPLICATE ROWS
SELECT submission_id, COUNT(*) AS duplicate_count
FROM submissions_staging
GROUP BY submission_id
HAVING COUNT(*) > 1;

-- VIEW FULL DUPLICATE RECORDS
SELECT *
FROM submissions_staging
WHERE submission_id IN (
    SELECT submission_id
    FROM submissions_staging
    GROUP BY submission_id
    HAVING COUNT(*) > 1
);

-- SAFE DELETE
DELETE FROM submissions_staging
WHERE row_id NOT IN (
    SELECT MIN(row_id)
    FROM (
        SELECT row_id, submission_id
        FROM submissions_staging
    ) AS temp
    GROUP BY submission_id
);

-- VERIFY AFTER DELETE
SELECT submission_id, COUNT(*) AS remaining_count
FROM staging_submissions
GROUP BY submission_id
HAVING COUNT(*) > 1;

-- Safety Explanation:
-- The DELETE removes only extra duplicate rows.
-- The earliest row (MIN(row_id)) for each submission_id is preserved.
-- Valid records remain untouched.



-- =========================================================
-- DELETE 2: Remove Orphan Test Result Records
-- =========================================================

-- IDENTIFY ORPHAN RECORDS
SELECT t.result_id,
       t.submission_id
FROM test_results t
LEFT JOIN submissions s
ON t.submission_id = s.submission_id
WHERE s.submission_id IS NULL;

-- SAFE DELETE
DELETE FROM test_results
WHERE submission_id NOT IN (
    SELECT submission_id
    FROM submissions
);

-- VERIFY AFTER DELETE
SELECT t.result_id,
       t.submission_id
FROM test_results t
LEFT JOIN submissions s
ON t.submission_id = s.submission_id
WHERE s.submission_id IS NULL;

-- Safety Explanation:
-- Only test_results without matching submissions are deleted.
-- Valid linked records remain unchanged.