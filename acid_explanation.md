# ACID Properties Explanation

## Transaction Scenario Used

The following transaction scenario is used as the example:

```sql
START TRANSACTION;

INSERT INTO submissions (
    submission_id,
    student_id,
    problem_id,
    score,
    submission_status
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
```

---

# 1. Atomicity

Atomicity means that all operations in the transaction are treated as a single unit.

In this transaction:

- the submission record is inserted
- the test_result record is inserted

Both operations must succeed together.

If the second INSERT fails, the entire transaction is rolled back and the submission record is also removed automatically.

This prevents partial or incomplete data from being stored in the database.

---

# 2. Consistency

Consistency ensures that the database remains valid before and after the transaction.

In this scenario:

- the `test_results.submission_id` references a valid submission
- required fields are properly inserted
- database constraints remain satisfied

The transaction moves the database from one consistent state to another without breaking relationships between tables.

---

# 3. Isolation

Isolation means that other users or transactions cannot see incomplete transaction results.

While this transaction is running:

- other users cannot see partially inserted records
- the submission and test_result inserts behave as a single isolated operation

This prevents conflicts and avoids reading temporary or incomplete data.

---

# 4. Durability

Durability means that once COMMIT is executed, the changes become permanent.

After the transaction is committed:

```sql
COMMIT;
```

the inserted submission and test_result records remain stored permanently even if:

- the database server restarts
- the application crashes
- the system shuts down unexpectedly

The committed transaction data can still be recovered from the database storage.
