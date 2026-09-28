# Database Systems

Coursework for **Database Systems** at the University of Tehran, Faculty of Electrical and Computer Engineering (Spring 2025), based on Ramakrishnan & Gehrke, *Database Management Systems*.

## Homework

| # | Topic | Contents |
|---|-------|----------|
| 1 | [ER modelling](hw1-er-modeling/) | Data independence, ER diagrams with participation and key constraints, overlap/covering constraints, aggregation |
| 2 | [Relational schema & constraints](hw2-relational-schema-and-constraints/) | ER-to-relational translation, with **SQL DDL** for a banking/loan system ([`q4.sql`](hw2-relational-schema-and-constraints/q4.sql)) and a gaming platform ([`q5.sql`](hw2-relational-schema-and-constraints/q5.sql)): keys, foreign keys, `ON DELETE` policies, ISA and aggregation |
| 4 | [SQL queries](hw4-sql-queries/) | 17 queries on a university database of 17 tables (students, courses, exams, dorms, library): joins, nested queries, aggregation with `GROUP BY`/`HAVING`, plus stored procedures and triggers |
| 5 | [Normalisation](hw5-normalization/) | Functional dependencies, closures, candidate keys, 3NF and BCNF decomposition |
| 6 | [Storage & indexing](hw6-storage-and-indexing/) | Disk and RAID, slotted pages, heap/sorted/hashed file organisation, clustered vs. unclustered indexes, I/O cost of equality and range queries |
| 7 | [Hash & tree indexes](hw7-hash-and-tree-indexes/) | **Extendible** and **linear hashing** (global/local depth, splits), B+ tree insertion/deletion with redistribution, triggers |
| 8 | [Query evaluation](hw8-query-evaluation/) | Query evaluation: external sorting, selection, **sort-merge**, hash and nested-loop joins, pipelining, I/O cost estimates |
| 9 | [Query optimisation](hw9-query-optimization/) | Query optimisation: evaluation plans, join ordering and access-path selection with cost estimates, plus concurrency control |

Each folder contains my report (`report.pdf`, in Persian). The SQL work is also available as plain `.sql` files.

## Verification

- **HW2:** both DDL scripts run cleanly with foreign-key checks enabled. They needed only missing statement terminators and one trailing comma fixed.
- **HW4:** queries 1–14 were run against the course's University database and return **exactly the same rows as the official solution**. Query 10 referenced a non-existent `CourseEnrollment` table; it now uses `Enrollment` and `DISTINCT`, and agrees with the official answer. Queries 15–17 are MySQL stored procedures and triggers (`DELIMITER` blocks) and need a MySQL server to run.

```bash
mysql -u root -p < University_DB.sql      # course-provided dataset (not included)
mysql -u root -p University_DB < hw4-sql-queries/queries.sql
```
