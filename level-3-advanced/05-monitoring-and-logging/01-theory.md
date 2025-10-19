# 📚 Monitoring & Logging - Lý Thuyết

Hiểu cách monitor database & implement logging.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu Database Monitoring
- ✅ Biết cách sử dụng pg_stat_statements
- ✅ Hiểu Query Logging
- ✅ Biết cách configure logging
- ✅ Sử dụng được monitoring tools
- ✅ Hiểu Monitoring best practices

---

## 📊 Database Monitoring

### Định Nghĩa

**Monitoring** - Track database performance & health.

### Tại Sao Quan Trọng?

1. **Performance** - Identify bottlenecks
2. **Availability** - Detect issues early
3. **Capacity Planning** - Plan resources
4. **Security** - Detect anomalies

---

## 🔍 System Views

### pg_stat_database

```sql
-- View database statistics
SELECT datname, numbackends, tup_returned, tup_fetched, tup_inserted, tup_updated, tup_deleted
FROM pg_stat_database
WHERE datname = 'ecommerce_practice';
```

### pg_stat_user_tables

```sql
-- View table statistics
SELECT schemaname, tablename, seq_scan, seq_tup_read, idx_scan, idx_tup_fetch
FROM pg_stat_user_tables
ORDER BY seq_scan DESC;
```

### pg_stat_user_indexes

```sql
-- View index statistics
SELECT schemaname, tablename, indexname, idx_scan, idx_tup_read, idx_tup_fetch
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;
```

---

## 📈 Query Performance

### pg_stat_statements

```sql
-- Enable pg_stat_statements
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- View query statistics
SELECT query, calls, mean_time, max_time, total_time
FROM pg_stat_statements
ORDER BY total_time DESC
LIMIT 10;
```

### EXPLAIN ANALYZE

```sql
-- Analyze query performance
EXPLAIN ANALYZE
SELECT * FROM products WHERE price > 100;
```

---

## 📝 Query Logging

### Enable Query Logging

```sql
-- In postgresql.conf
log_statement = 'all'
log_duration = on
log_min_duration_statement = 1000  -- Log queries > 1 second
```

### Log Levels

```
DEBUG5, DEBUG4, DEBUG3, DEBUG2, DEBUG1
LOG
NOTICE
WARNING
ERROR
FATAL
PANIC
```

---

## 🔧 Logging Configuration

### Log Format

```sql
-- In postgresql.conf
log_line_prefix = '%t [%p]: [%l-1] user=%u,db=%d,app=%a,client=%h '
log_checkpoints = on
log_connections = on
log_disconnections = on
log_lock_waits = on
log_temp_files = 0
```

### Log Destination

```sql
-- In postgresql.conf
log_destination = 'stderr'
logging_collector = on
log_directory = 'pg_log'
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
log_truncate_on_rotation = on
log_rotation_age = 1d
log_rotation_size = 100MB
```

---

## 🎯 Active Connections

### View Active Connections

```sql
-- View active connections
SELECT pid, usename, application_name, state, query
FROM pg_stat_activity
WHERE state != 'idle';
```

### View Long-Running Queries

```sql
-- View long-running queries
SELECT pid, usename, query_start, state, query
FROM pg_stat_activity
WHERE state != 'idle'
AND query_start < CURRENT_TIMESTAMP - INTERVAL '5 minutes';
```

---

## 🔒 Lock Monitoring

### View Locks

```sql
-- View locks
SELECT pid, usename, application_name, state, query
FROM pg_stat_activity
WHERE state = 'active';
```

### View Blocked Queries

```sql
-- View blocked queries
SELECT blocked_locks.pid AS blocked_pid,
       blocked_activity.usename AS blocked_user,
       blocking_locks.pid AS blocking_pid,
       blocking_activity.usename AS blocking_user,
       blocked_activity.query AS blocked_statement,
       blocking_activity.query AS blocking_statement
FROM pg_catalog.pg_locks blocked_locks
JOIN pg_catalog.pg_stat_activity blocked_activity ON blocked_activity.pid = blocked_locks.pid
JOIN pg_catalog.pg_locks blocking_locks ON blocking_locks.locktype = blocked_locks.locktype
  AND blocking_locks.database IS NOT DISTINCT FROM blocked_locks.database
  AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation
  AND blocking_locks.page IS NOT DISTINCT FROM blocked_locks.page
  AND blocking_locks.tuple IS NOT DISTINCT FROM blocked_locks.tuple
  AND blocking_locks.virtualxid IS NOT DISTINCT FROM blocked_locks.virtualxid
  AND blocking_locks.transactionid IS NOT DISTINCT FROM blocked_locks.transactionid
  AND blocking_locks.classid IS NOT DISTINCT FROM blocked_locks.classid
  AND blocking_locks.objid IS NOT DISTINCT FROM blocked_locks.objid
  AND blocking_locks.objsubid IS NOT DISTINCT FROM blocked_locks.objsubid
  AND blocking_locks.pid != blocked_locks.pid
JOIN pg_catalog.pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid
WHERE NOT blocked_locks.granted;
```

---

## 📊 Tóm Tắt Monitoring

| Khái Niệm | Mô Tả | Khi Dùng |
|-----------|-------|---------|
| **pg_stat_database** | Database stats | Overall health |
| **pg_stat_user_tables** | Table stats | Table performance |
| **pg_stat_user_indexes** | Index stats | Index usage |
| **pg_stat_statements** | Query stats | Query performance |
| **pg_stat_activity** | Active connections | Connection monitoring |
| **Query Logging** | Log queries | Audit trail |
| **Lock Monitoring** | View locks | Deadlock detection |

---

## 🎓 Key Takeaways

1. **Monitoring** - Track performance
2. **System Views** - Database statistics
3. **Query Performance** - EXPLAIN ANALYZE
4. **Query Logging** - Log queries
5. **Active Connections** - Monitor connections
6. **Lock Monitoring** - Detect deadlocks
7. **Best Practices** - Regular monitoring

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL Monitoring](https://www.postgresql.org/docs/current/monitoring.html)
- [PostgreSQL System Views](https://www.postgresql.org/docs/current/monitoring-stats.html)
- [PostgreSQL Logging](https://www.postgresql.org/docs/current/runtime-config-logging.html)

---

**Bây giờ bạn đã hiểu Monitoring & Logging! Hãy chuyển sang phần thực hành. 💪**

