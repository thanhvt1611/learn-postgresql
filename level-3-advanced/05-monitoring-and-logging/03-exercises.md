# 💪 Monitoring & Logging - Bài Tập

Thực hành monitor database & implement logging.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có database "ecommerce_practice" với sample data

---

## 🎯 Bài Tập 1: View Database Stats (Dễ)

### Yêu Cầu
View database statistics.

### Gợi Ý
- Sử dụng SELECT FROM pg_stat_database
- Filter by datname

### Solution
```sql
SELECT datname, numbackends, tup_returned, tup_fetched, tup_inserted, tup_updated, tup_deleted
FROM pg_stat_database
WHERE datname = 'ecommerce_practice';
```

---

## 🎯 Bài Tập 2: View Table Statistics (Dễ)

### Yêu Cầu
View table statistics.

### Gợi Ý
- Sử dụng SELECT FROM pg_stat_user_tables
- Order by seq_scan DESC

### Solution
```sql
SELECT schemaname, tablename, seq_scan, seq_tup_read, idx_scan, idx_tup_fetch
FROM pg_stat_user_tables
ORDER BY seq_scan DESC;
```

---

## 🎯 Bài Tập 3: View Index Statistics (Dễ)

### Yêu Cầu
View index statistics.

### Gợi Ý
- Sử dụng SELECT FROM pg_stat_user_indexes
- Order by idx_scan DESC

### Solution
```sql
SELECT schemaname, tablename, indexname, idx_scan, idx_tup_read, idx_tup_fetch
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;
```

---

## 🎯 Bài Tập 4: Enable pg_stat_statements (Trung Bình)

### Yêu Cầu
Enable pg_stat_statements extension.

### Gợi Ý
- Sử dụng CREATE EXTENSION IF NOT EXISTS

### Solution
```sql
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
```

---

## 🎯 Bài Tập 5: View Query Statistics (Trung Bình)

### Yêu Cầu
View query statistics từ pg_stat_statements.

### Gợi Ý
- Sử dụng SELECT FROM pg_stat_statements
- Order by total_time DESC

### Solution
```sql
SELECT query, calls, mean_time, max_time, total_time
FROM pg_stat_statements
ORDER BY total_time DESC
LIMIT 10;
```

---

## 🎯 Bài Tập 6: Analyze Query Performance (Trung Bình)

### Yêu Cầu
Analyze query performance với EXPLAIN ANALYZE.

### Gợi Ý
- Sử dụng EXPLAIN ANALYZE
- Sử dụng complex query

### Solution
```sql
EXPLAIN ANALYZE
SELECT p.name, COUNT(oi.id) AS item_count
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.name;
```

---

## 🎯 Bài Tập 7: View Active Connections (Trung Bình)

### Yêu Cầu
View active connections.

### Gợi Ý
- Sử dụng SELECT FROM pg_stat_activity
- Filter by state != 'idle'

### Solution
```sql
SELECT pid, usename, application_name, state, query
FROM pg_stat_activity
WHERE state != 'idle';
```

---

## 🎯 Bài Tập 8: View Long-Running Queries (Nâng Cao)

### Yêu Cầu
View long-running queries.

### Gợi Ý
- Sử dụng SELECT FROM pg_stat_activity
- Filter by query_start < CURRENT_TIMESTAMP - INTERVAL

### Solution
```sql
SELECT pid, usename, query_start, state, query
FROM pg_stat_activity
WHERE state != 'idle'
AND query_start < CURRENT_TIMESTAMP - INTERVAL '5 minutes';
```

---

## 🎯 Bài Tập 9: View Locks (Nâng Cao)

### Yêu Cầu
View locks.

### Gợi Ý
- Sử dụng SELECT FROM pg_locks
- Join with pg_stat_activity

### Solution
```sql
SELECT l.pid, l.mode, l.granted, a.usename, a.query
FROM pg_locks l
JOIN pg_stat_activity a ON l.pid = a.pid
WHERE NOT l.granted;
```

---

## 🎯 Bài Tập 10: Monitor Cache Hit Ratio (Nâng Cao)

### Yêu Cầu
Monitor cache hit ratio.

### Gợi Ý
- Sử dụng SELECT FROM pg_statio_user_tables
- Calculate ratio

### Solution
```sql
SELECT 
  sum(heap_blks_read) as heap_read, 
  sum(heap_blks_hit) as heap_hit, 
  sum(heap_blks_hit) / (sum(heap_blks_hit) + sum(heap_blks_read)) as ratio
FROM pg_statio_user_tables;
```

---

## 🎯 Bài Tập 11: Monitor Disk Usage (Nâng Cao)

### Yêu Cầu
Monitor disk usage per table.

### Gợi Ý
- Sử dụng SELECT FROM pg_tables
- Sử dụng pg_total_relation_size()
- Sử dụng pg_size_pretty()

### Solution
```sql
SELECT schemaname, tablename, pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

---

## 🎯 Bài Tập 12: Reset Statistics (Nâng Cao)

### Yêu Cầu
Reset pg_stat_statements.

### Gợi Ý
- Sử dụng SELECT pg_stat_statements_reset()

### Solution
```sql
SELECT pg_stat_statements_reset();
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-3: Database & Table Statistics
- [ ] Bài 4-6: Query Performance
- [ ] Bài 7-9: Connections & Locks
- [ ] Bài 10-12: Performance Metrics

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ Database statistics
- ✅ Table statistics
- ✅ Index statistics
- ✅ Query performance
- ✅ Active connections
- ✅ Long-running queries
- ✅ Lock monitoring
- ✅ Performance metrics

---

**Chúc mừng! Bạn đã hoàn thành Module 5 - Monitoring & Logging! 🎉**

