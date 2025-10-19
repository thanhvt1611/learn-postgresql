# ⚡ PostgreSQL Quick Reference Guide

## 🔗 Connection Commands

```bash
# Connect to PostgreSQL
psql -U username -d database_name

# Connect to specific host
psql -h localhost -U username -d database_name

# Connect with password prompt
psql -U username -d database_name -W

# List all databases
psql -U username -l
```

---

## 📊 Database Commands

```sql
-- Create database
CREATE DATABASE database_name;

-- Drop database
DROP DATABASE database_name;

-- List databases
\l

-- Connect to database
\c database_name

-- Show current database
SELECT current_database();
```

---

## 📋 Table Commands

```sql
-- Create table
CREATE TABLE table_name (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- List tables
\dt

-- Describe table
\d table_name

-- Drop table
DROP TABLE table_name;

-- Rename table
ALTER TABLE old_name RENAME TO new_name;

-- Add column
ALTER TABLE table_name ADD COLUMN column_name VARCHAR(255);

-- Drop column
ALTER TABLE table_name DROP COLUMN column_name;

-- Rename column
ALTER TABLE table_name RENAME COLUMN old_name TO new_name;
```

---

## 🔑 Index Commands

```sql
-- Create index
CREATE INDEX idx_name ON table_name(column_name);

-- Create unique index
CREATE UNIQUE INDEX idx_name ON table_name(column_name);

-- Create composite index
CREATE INDEX idx_name ON table_name(col1, col2);

-- Create GIN index (for arrays/JSON)
CREATE INDEX idx_name ON table_name USING GIN(column_name);

-- List indexes
\di

-- Drop index
DROP INDEX idx_name;

-- Reindex
REINDEX INDEX idx_name;

-- Analyze index usage
SELECT * FROM pg_stat_user_indexes;
```

---

## 🔐 User & Role Commands

```sql
-- Create user
CREATE USER username WITH PASSWORD 'password';

-- Create role
CREATE ROLE role_name;

-- Grant permissions
GRANT SELECT ON table_name TO role_name;
GRANT INSERT, UPDATE ON table_name TO role_name;
GRANT ALL ON table_name TO role_name;

-- Revoke permissions
REVOKE SELECT ON table_name FROM role_name;

-- Grant role to user
GRANT role_name TO username;

-- List users
\du

-- Drop user
DROP USER username;

-- Change password
ALTER USER username WITH PASSWORD 'new_password';
```

---

## 📈 Query Commands

```sql
-- Select all
SELECT * FROM table_name;

-- Select with WHERE
SELECT * FROM table_name WHERE condition;

-- Select with ORDER BY
SELECT * FROM table_name ORDER BY column_name DESC;

-- Select with LIMIT
SELECT * FROM table_name LIMIT 10;

-- Select with OFFSET
SELECT * FROM table_name LIMIT 10 OFFSET 20;

-- Select with GROUP BY
SELECT column_name, COUNT(*) FROM table_name GROUP BY column_name;

-- Select with JOIN
SELECT * FROM table1 JOIN table2 ON table1.id = table2.table1_id;

-- Select with aggregate functions
SELECT COUNT(*), AVG(column), MAX(column), MIN(column) FROM table_name;

-- Select with DISTINCT
SELECT DISTINCT column_name FROM table_name;
```

---

## 🔄 Data Manipulation

```sql
-- Insert data
INSERT INTO table_name (col1, col2) VALUES ('value1', 'value2');

-- Insert multiple rows
INSERT INTO table_name (col1, col2) VALUES 
  ('value1', 'value2'),
  ('value3', 'value4');

-- Update data
UPDATE table_name SET column_name = 'new_value' WHERE condition;

-- Delete data
DELETE FROM table_name WHERE condition;

-- Truncate table (delete all)
TRUNCATE TABLE table_name;

-- Copy data from file
COPY table_name FROM '/path/to/file.csv' WITH (FORMAT csv);

-- Export data to file
COPY table_name TO '/path/to/file.csv' WITH (FORMAT csv);
```

---

## 🔍 Query Analysis

```sql
-- Explain query plan
EXPLAIN SELECT * FROM table_name WHERE condition;

-- Explain with analysis
EXPLAIN ANALYZE SELECT * FROM table_name WHERE condition;

-- Show query statistics
SELECT query, calls, mean_time FROM pg_stat_statements;

-- Check table size
SELECT pg_size_pretty(pg_total_relation_size('table_name'));

-- Check database size
SELECT pg_size_pretty(pg_database_size('database_name'));

-- Check index usage
SELECT * FROM pg_stat_user_indexes;
```

---

## 🔧 Maintenance Commands

```sql
-- Vacuum (reclaim space)
VACUUM;

-- Vacuum specific table
VACUUM table_name;

-- Vacuum full (locks table)
VACUUM FULL;

-- Analyze (update statistics)
ANALYZE;

-- Analyze specific table
ANALYZE table_name;

-- Reindex database
REINDEX DATABASE database_name;

-- Check database integrity
REINDEX DATABASE database_name;
```

---

## 💾 Backup & Restore

```bash
# Full backup
pg_dump -U username -d database_name > backup.sql

# Backup with compression
pg_dump -U username -d database_name -Fc > backup.dump

# Parallel backup
pg_dump -U username -d database_name -Fc -j 4 > backup.dump

# Backup specific table
pg_dump -U username -d database_name -t table_name > backup.sql

# Restore from SQL file
psql -U username -d database_name < backup.sql

# Restore from dump file
pg_restore -U username -d database_name backup.dump

# Restore specific table
pg_restore -U username -d database_name -t table_name backup.dump
```

---

## 🔗 Transaction Commands

```sql
-- Start transaction
BEGIN;

-- Commit transaction
COMMIT;

-- Rollback transaction
ROLLBACK;

-- Create savepoint
SAVEPOINT savepoint_name;

-- Rollback to savepoint
ROLLBACK TO savepoint_name;

-- Set isolation level
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Lock table
LOCK TABLE table_name IN EXCLUSIVE MODE;

-- Lock row for update
SELECT * FROM table_name WHERE id = 1 FOR UPDATE;

-- Lock row for share
SELECT * FROM table_name WHERE id = 1 FOR SHARE;
```

---

## 📝 Function & Procedure Commands

```sql
-- Create function
CREATE OR REPLACE FUNCTION func_name(param1 INT)
RETURNS INT AS $$
BEGIN
  RETURN param1 * 2;
END;
$$ LANGUAGE plpgsql;

-- Create procedure
CREATE OR REPLACE PROCEDURE proc_name(param1 INT)
AS $$
BEGIN
  INSERT INTO table_name VALUES (param1);
END;
$$ LANGUAGE plpgsql;

-- Call function
SELECT func_name(5);

-- Call procedure
CALL proc_name(5);

-- List functions
\df

-- Drop function
DROP FUNCTION func_name(INT);

-- Drop procedure
DROP PROCEDURE proc_name(INT);
```

---

## 🔔 Trigger Commands

```sql
-- Create trigger function
CREATE OR REPLACE FUNCTION trigger_func()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at := CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
CREATE TRIGGER trigger_name
BEFORE UPDATE ON table_name
FOR EACH ROW EXECUTE FUNCTION trigger_func();

-- List triggers
\dy

-- Drop trigger
DROP TRIGGER trigger_name ON table_name;

-- Disable trigger
ALTER TABLE table_name DISABLE TRIGGER trigger_name;

-- Enable trigger
ALTER TABLE table_name ENABLE TRIGGER trigger_name;
```

---

## 🔐 Security Commands

```sql
-- Enable RLS
ALTER TABLE table_name ENABLE ROW LEVEL SECURITY;

-- Create RLS policy
CREATE POLICY policy_name ON table_name
FOR SELECT USING (user_id = current_user_id());

-- Drop RLS policy
DROP POLICY policy_name ON table_name;

-- List RLS policies
SELECT * FROM pg_policies;

-- Check table RLS status
SELECT * FROM pg_tables WHERE tablename = 'table_name';
```

---

## 📊 Monitoring Commands

```sql
-- Check active connections
SELECT * FROM pg_stat_activity;

-- Check locks
SELECT * FROM pg_locks;

-- Check blocked queries
SELECT blocked_locks.pid, blocking_locks.pid
FROM pg_locks blocked_locks
JOIN pg_locks blocking_locks ON blocking_locks.locktype = blocked_locks.locktype;

-- Check database stats
SELECT * FROM pg_stat_database;

-- Check table stats
SELECT * FROM pg_stat_user_tables;

-- Kill connection
SELECT pg_terminate_backend(pid);
```

---

## 🎯 Useful Shortcuts

```
\l          - List databases
\dt         - List tables
\di         - List indexes
\df         - List functions
\du         - List users/roles
\dy         - List triggers
\d table    - Describe table
\c db       - Connect to database
\q          - Quit psql
\h          - Help
\?          - Help on commands
\e          - Edit query in editor
\x          - Toggle expanded output
\timing     - Toggle query timing
```

---

## 💡 Common Patterns

```sql
-- Get last inserted ID
INSERT INTO table_name (col1) VALUES ('value') RETURNING id;

-- Update with JOIN
UPDATE table1 SET col = table2.col
FROM table2 WHERE table1.id = table2.table1_id;

-- Delete with JOIN
DELETE FROM table1 USING table2
WHERE table1.id = table2.table1_id;

-- Upsert (INSERT OR UPDATE)
INSERT INTO table_name (id, col) VALUES (1, 'value')
ON CONFLICT (id) DO UPDATE SET col = 'value';

-- Bulk insert from SELECT
INSERT INTO table1 SELECT * FROM table2;

-- Window function
SELECT col, ROW_NUMBER() OVER (ORDER BY col) FROM table_name;

-- CTE (Common Table Expression)
WITH cte AS (SELECT * FROM table1)
SELECT * FROM cte WHERE condition;
```

---

**Bookmark this page for quick reference! 📌**

