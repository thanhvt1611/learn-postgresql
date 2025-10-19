# 🔧 Troubleshooting Guide

## 🚨 Common Issues & Solutions

---

## Issue 1: Slow Queries

### Symptoms
- Queries taking > 1 second
- High CPU usage
- Timeout errors

### Diagnosis

```sql
-- Check slow queries
SELECT query, calls, mean_time, max_time
FROM pg_stat_statements
WHERE mean_time > 1000
ORDER BY mean_time DESC;

-- Analyze query plan
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = '...';
```

### Solutions

```sql
-- 1. Add missing index
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- 2. Analyze table statistics
ANALYZE orders;

-- 3. Reindex if corrupted
REINDEX INDEX idx_orders_user_id;

-- 4. Check for sequential scans
EXPLAIN SELECT * FROM orders WHERE status = 'completed';

-- 5. Use LIMIT for large result sets
SELECT * FROM orders LIMIT 100;
```

---

## Issue 2: Deadlocks

### Symptoms
- "Deadlock detected" errors
- Transaction rollbacks
- Application errors

### Diagnosis

```sql
-- Check for blocked queries
SELECT blocked_locks.pid AS blocked_pid,
       blocking_locks.pid AS blocking_pid,
       blocked_activity.query AS blocked_statement,
       blocking_activity.query AS blocking_statement
FROM pg_catalog.pg_locks blocked_locks
JOIN pg_catalog.pg_stat_activity blocked_activity ON blocked_activity.pid = blocked_locks.pid
JOIN pg_catalog.pg_locks blocking_locks ON blocking_locks.locktype = blocked_locks.locktype
JOIN pg_catalog.pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid
WHERE NOT blocked_locks.granted;
```

### Solutions

```sql
-- 1. Lock in consistent order
BEGIN;
UPDATE inventory SET quantity = quantity - 1 WHERE product_id = '...' ORDER BY product_id;
UPDATE orders SET status = 'processing' WHERE id = '...';
COMMIT;

-- 2. Minimize transaction duration
BEGIN;
UPDATE inventory SET quantity = quantity - 1 WHERE product_id = '...';
COMMIT;

-- 3. Use appropriate isolation level
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- 4. Kill blocking query if necessary
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE pid = ...;
```

---

## Issue 3: High Memory Usage

### Symptoms
- Out of memory errors
- Slow performance
- System crashes

### Diagnosis

```sql
-- Check cache hit ratio
SELECT 
  sum(heap_blks_read) as heap_read, 
  sum(heap_blks_hit) as heap_hit, 
  sum(heap_blks_hit) / (sum(heap_blks_hit) + sum(heap_blks_read)) as ratio
FROM pg_statio_user_tables;

-- Check table sizes
SELECT schemaname, tablename, pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename))
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

### Solutions

```sql
-- 1. Increase shared_buffers in postgresql.conf
shared_buffers = 256MB

-- 2. Vacuum to reclaim space
VACUUM FULL;

-- 3. Archive old data
CREATE TABLE orders_archive AS
SELECT * FROM orders WHERE created_at < '2023-01-01';
DELETE FROM orders WHERE created_at < '2023-01-01';

-- 4. Reduce work_mem for large queries
SET work_mem = '256MB';
```

---

## Issue 4: Replication Lag

### Symptoms
- Standby behind primary
- Stale data on replicas
- Replication errors

### Diagnosis

```sql
-- Check replication status
SELECT slot_name, restart_lsn, confirmed_flush_lsn
FROM pg_replication_slots;

-- Check standby lag
SELECT client_addr, state, sync_state, write_lag, flush_lag, replay_lag
FROM pg_stat_replication;
```

### Solutions

```sql
-- 1. Increase wal_keep_size
wal_keep_size = 2GB

-- 2. Check network connectivity
ping standby_server

-- 3. Restart replication
SELECT pg_wal_replay_resume();

-- 4. Monitor replication
SELECT now() - pg_postmaster_start_time() AS uptime;
```

---

## Issue 5: Backup Failures

### Symptoms
- Backup errors
- Incomplete backups
- Restore failures

### Diagnosis

```bash
# Check backup size
ls -lh ecommerce_backup.dump

# Verify backup integrity
pg_restore --list ecommerce_backup.dump | head -20

# Check disk space
df -h
```

### Solutions

```bash
# 1. Ensure sufficient disk space
df -h /backup

# 2. Use parallel backup
pg_dump -U postgres -d ecommerce_global -Fc -j 4 > backup.dump

# 3. Compress backup
pg_dump -U postgres -d ecommerce_global -Fc -Z 9 > backup.dump

# 4. Test restore
pg_restore -U postgres -d test_db backup.dump

# 5. Verify backup
pg_restore --list backup.dump | wc -l
```

---

## Issue 6: Trigger Not Firing

### Symptoms
- Audit logs not updated
- Timestamps not updated
- Inventory not updated

### Diagnosis

```sql
-- Check trigger status
SELECT * FROM information_schema.triggers
WHERE trigger_schema = 'public';

-- Check trigger function
SELECT * FROM pg_proc WHERE proname = 'audit_changes';

-- Test trigger manually
INSERT INTO orders (user_id, status, total_amount) VALUES ('...', 'pending', 100);
SELECT * FROM audit_logs ORDER BY changed_at DESC LIMIT 1;
```

### Solutions

```sql
-- 1. Enable trigger if disabled
ALTER TABLE orders ENABLE TRIGGER trigger_audit_orders;

-- 2. Recreate trigger
DROP TRIGGER trigger_audit_orders ON orders;
CREATE TRIGGER trigger_audit_orders
AFTER INSERT OR UPDATE OR DELETE ON orders
FOR EACH ROW EXECUTE FUNCTION audit_changes();

-- 3. Check trigger function
SELECT pg_get_functiondef('audit_changes'::regprocedure);

-- 4. Test with verbose output
SET log_statement = 'all';
INSERT INTO orders (user_id, status, total_amount) VALUES ('...', 'pending', 100);
```

---

## Issue 7: RLS Policy Not Working

### Symptoms
- Users seeing other users' data
- Security policy not enforced
- Unauthorized access

### Diagnosis

```sql
-- Check RLS status
SELECT * FROM pg_tables WHERE tablename = 'orders';

-- Check RLS policies
SELECT * FROM pg_policies WHERE tablename = 'orders';

-- Test policy
SELECT * FROM orders;
```

### Solutions

```sql
-- 1. Enable RLS
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- 2. Create policy
CREATE POLICY order_access ON orders
FOR SELECT USING (user_id = current_user_id());

-- 3. Grant permissions
GRANT SELECT ON orders TO customer_role;

-- 4. Test as different user
SET ROLE customer_role;
SELECT * FROM orders;
```

---

## Issue 8: Full Disk

### Symptoms
- "No space left on device" errors
- Queries failing
- Backups failing

### Diagnosis

```bash
# Check disk usage
df -h

# Check PostgreSQL data directory
du -sh /var/lib/postgresql/data

# Find large files
find /var/lib/postgresql/data -type f -size +100M
```

### Solutions

```bash
# 1. Clean old log files
rm /var/log/postgresql/*.log

# 2. Archive old data
psql -d ecommerce_global -c "DELETE FROM audit_logs WHERE changed_at < '2023-01-01';"

# 3. Vacuum database
psql -d ecommerce_global -c "VACUUM FULL;"

# 4. Expand disk space
# Add new disk or expand existing partition
```

---

## 🔍 Monitoring Commands

```sql
-- Check database health
SELECT datname, numbackends, tup_returned, tup_fetched, tup_inserted, tup_updated, tup_deleted
FROM pg_stat_database
WHERE datname = 'ecommerce_global';

-- Check active connections
SELECT pid, usename, application_name, state, query
FROM pg_stat_activity
WHERE state != 'idle';

-- Check locks
SELECT l.pid, l.mode, l.granted, a.usename, a.query
FROM pg_locks l
JOIN pg_stat_activity a ON l.pid = a.pid
WHERE NOT l.granted;

-- Check index usage
SELECT schemaname, tablename, indexname, idx_scan
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;
```

---

## 📞 Getting Help

1. **Check PostgreSQL logs**
   ```bash
   tail -f /var/log/postgresql/postgresql.log
   ```

2. **Enable query logging**
   ```sql
   ALTER SYSTEM SET log_statement = 'all';
   SELECT pg_reload_conf();
   ```

3. **Use EXPLAIN ANALYZE**
   ```sql
   EXPLAIN ANALYZE SELECT ...;
   ```

4. **Check PostgreSQL documentation**
   - https://www.postgresql.org/docs/

---

**Remember: Always backup before making changes! 🔒**

