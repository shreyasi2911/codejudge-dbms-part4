# Reliability Incident Note

## Incident Description

A developer accidentally executed the following SQL query in the CodeJudge database:

```sql
UPDATE submissions
SET score = 100;
```

The query was executed without a `WHERE` clause.

---

# What Went Wrong

The UPDATE statement did not include a condition to limit which rows should be modified.

As a result, the query updated every row in the `submissions` table instead of updating only a specific submission record.

This caused unintended mass modification of student scores.

---

# Data That Could Be Affected

The following data could be impacted:

- submission scores of all students
- leaderboard rankings
- grading reports
- analytics based on scores
- regrade request evaluations
- instructor review records

Because the `submissions` table is connected to other tables, incorrect scores could also affect related reports and evaluation processes.

---

# How the Issue Could Be Detected

The issue could be detected through:

- sudden appearance of identical scores for all students
- abnormal leaderboard rankings
- audit logs showing a large number of updated rows
- comparison with previous database backups
- instructor complaints about incorrect grades

Database monitoring systems may also show unusually high update activity.

---

# How Rollback, Backups, or Transactions Could Help

If the query was executed inside a transaction:

```sql
START TRANSACTION;

UPDATE submissions
SET score = 100;

ROLLBACK;
```

the accidental changes could be reversed immediately using `ROLLBACK`.

If the transaction had already been committed, database backups could be used to restore the original data.

Point-in-time recovery and backup snapshots would help recover correct submission scores.

---

# Preventive Measures

The following preventive measures should be followed in future:

- always run a SELECT query before UPDATE or DELETE
- never execute UPDATE or DELETE without a WHERE clause
- use transactions while testing data modifications
- maintain regular database backups
- enable query review or approval for critical operations
- use staging databases for testing changes
- limit production database permissions for developers
- enable SQL safe update mode in MySQL Workbench

These practices reduce the risk of accidental large-scale data corruption in the CodeJudge database.
