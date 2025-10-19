# 🛠️ Monitoring & Logging - Thực Hành

Thực hành monitor database & implement logging.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Sử dụng được system views
- ✅ Monitor query performance
- ✅ Configure query logging
- ✅ Monitor active connections
- ✅ Detect locks & deadlocks

---

## 📋 Bước 1: Chuẩn Bị Database

### Bước 1.1: Kết Nối Database

```sql
-- Kết nối
psql -U postgres -d ecommerce_practice
```

---

## 📊 Bước 2: Database Statistics

### Thực Hành 2.1: View Database Stats

```sql
-- View database statistics
SELECT datname, numbackends, tup_returned, tup_fetched, tup_inserted, tup_updated, tup_deleted
FROM pg_stat_database
WHERE datname = 'ecommerce_practice';
```

### Thực Hành 2.2: View Table Statistics

```sql
-- View table statistics
SELECT schemaname, tablename, seq_scan, seq_tup_read, idx_scan, idx_tup_fetch
FROM pg_stat_user_tables
ORDER BY seq_scan DESC;
```

### Thực Hành 2.3: View Index Statistics

```sql
-- View index statistics
SELECT schemaname, tablename, indexname, idx_scan, idx_tup_read, idx_tup_fetch
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;
```

---

## 📈 Bước 3: Query Performance

### Thực Hành 3.1: Enable pg_stat_statements

```sql
-- Enable pg_stat_statements extension
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- View query statistics
SELECT query, calls, mean_time, max_time, total_time
FROM pg_stat_statements
ORDER BY total_time DESC
LIMIT 10;
```

### Thực Hành 3.2: Analyze Query Performance

```sql
-- Analyze query performance
EXPLAIN ANALYZE
SELECT p.name, COUNT(oi.id) AS item_count
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.name;
```

### Thực Hành 3.3: Reset Statistics

```sql
-- Reset pg_stat_statements
SELECT pg_stat_statements_reset();

-- Reset table statistics
SELECT pg_stat_reset();
```

---

## 📝 Bước 4: Query Logging

### Thực Hành 4.1: View Current Logging Config

```sql
-- View logging configuration
SHOW log_statement;
SHOW log_duration;
SHOW log_min_duration_statement;
SHOW log_line_prefix;
```

### Thực Hành 4.2: Enable Query Logging

```sql
-- Enable all query logging
ALTER SYSTEM SET log_statement = 'all';
ALTER SYSTEM SET log_duration = on;
ALTER SYSTEM SET log_min_duration_statement = 1000;

-- Reload configuration
SELECT pg_reload_conf();
```

### Thực Hành 4.3: View Log Files

```sql
-- View log directory
SHOW log_directory;

-- View log files (from command line)
-- ls -la /var/lib/postgresql/data/pg_log/
```

---

## 🔌 Bước 5: Active Connections

### Thực Hành 5.1: View Active Connections

```sql
-- View active connections
SELECT pid, usename, application_name, state, query
FROM pg_stat_activity
WHERE state != 'idle';
```

### Thực Hành 5.2: View Connection Details

```sql
-- View detailed connection info
SELECT pid, usename, application_name, client_addr, state, query_start, state_change
FROM pg_stat_activity
ORDER BY query_start DESC;
```

### Thực Hành 5.3: View Long-Running Queries

```sql
-- View long-running queries
SELECT pid, usename, query_start, state, query
FROM pg_stat_activity
WHERE state != 'idle'
AND query_start < CURRENT_TIMESTAMP - INTERVAL '5 minutes';
```

---

## 🔒 Bước 6: Lock Monitoring

### Thực Hành 6.1: View Locks

```sql
-- View locks
SELECT pid, usename, application_name, state, query
FROM pg_stat_activity
WHERE state = 'active';
```

### Thực Hành 6.2: View Lock Conflicts

```sql
-- View lock conflicts
SELECT l.pid, l.mode, l.granted, a.usename, a.query
FROM pg_locks l
JOIN pg_stat_activity a ON l.pid = a.pid
WHERE NOT l.granted;
```

### Thực Hành 6.3: Kill Long-Running Query

```sql
-- Kill long-running query
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE query_start < CURRENT_TIMESTAMP - INTERVAL '10 minutes'
AND state != 'idle';
```

---

## 📈 Bước 7: Performance Monitoring

### Thực Hành 7.1: Monitor Cache Hit Ratio

```sql
-- Monitor cache hit ratio
SELECT 
  sum(heap_blks_read) as heap_read, 
  sum(heap_blks_hit) as heap_hit, 
  sum(heap_blks_hit) / (sum(heap_blks_hit) + sum(heap_blks_read)) as ratio
FROM pg_statio_user_tables;
```

### Thực Hành 7.2: Monitor Disk Usage

```sql
-- Monitor disk usage
SELECT schemaname, tablename, pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

---

## ✅ Checklist Thực Hành

- [ ] View database statistics
- [ ] View table statistics
- [ ] View index statistics
- [ ] Enable pg_stat_statements
- [ ] Analyze query performance
- [ ] Configure query logging
- [ ] Monitor active connections
- [ ] Monitor locks
- [ ] Monitor performance metrics

---

## 💡 Tips

1. **Regular Monitoring** - Thường xuyên check
2. **Set Alerts** - Cho anomalies
3. **Analyze Logs** - Tìm patterns
4. **Monitor Locks** - Detect deadlocks
5. **Track Trends** - Plan capacity

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

