# ⚡ Project 3: Performance Optimization

Tối ưu hóa database performance & viết efficient queries.

## 🎯 Mục Tiêu Project

Sau khi hoàn thành project này, bạn sẽ:
- ✅ Hiểu query performance analysis
- ✅ Tạo & sử dụng indexes hiệu quả
- ✅ Tối ưu hóa slow queries
- ✅ Sử dụng EXPLAIN & EXPLAIN ANALYZE
- ✅ Hiểu query optimization techniques

---

## 📋 Yêu Cầu Project

### 1. Baseline Performance Analysis

#### 1.1 Kiểm tra Slow Queries
```sql
-- Bật query logging
ALTER SYSTEM SET log_min_duration_statement = 1000;  -- Log queries > 1 second
SELECT pg_reload_conf();

-- Kiểm tra slow queries
SELECT 
  query,
  calls,
  total_time,
  mean_time,
  max_time
FROM pg_stat_statements
ORDER BY mean_time DESC
LIMIT 10;
```

#### 1.2 Analyze Current Indexes
```sql
-- Liệt kê tất cả indexes
SELECT 
  schemaname,
  tablename,
  indexname,
  indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename;

-- Xem index size
SELECT 
  indexname,
  pg_size_pretty(pg_relation_size(indexrelid)) AS index_size
FROM pg_indexes
JOIN pg_class ON pg_indexes.indexname = pg_class.relname
WHERE schemaname = 'public'
ORDER BY pg_relation_size(indexrelid) DESC;
```

---

### 2. Query Optimization

#### 2.1 Optimize Complex Joins
```sql
-- ❌ SLOW: Multiple JOINs without indexes
EXPLAIN ANALYZE
SELECT 
  u.name,
  COUNT(o.id) AS order_count,
  SUM(o.total_amount) AS total_spent
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
LEFT JOIN order_items oi ON o.id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.id
GROUP BY u.id, u.name;

-- ✅ FAST: With proper indexes
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

EXPLAIN ANALYZE
SELECT 
  u.name,
  COUNT(o.id) AS order_count,
  SUM(o.total_amount) AS total_spent
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
LEFT JOIN order_items oi ON o.id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.id
GROUP BY u.id, u.name;
```

#### 2.2 Optimize Aggregations
```sql
-- ❌ SLOW: Aggregate without index
EXPLAIN ANALYZE
SELECT 
  category_id,
  COUNT(*) AS product_count,
  AVG(price) AS avg_price
FROM products
GROUP BY category_id;

-- ✅ FAST: With index
CREATE INDEX idx_products_category_id ON products(category_id);

EXPLAIN ANALYZE
SELECT 
  category_id,
  COUNT(*) AS product_count,
  AVG(price) AS avg_price
FROM products
GROUP BY category_id;
```

#### 2.3 Optimize Subqueries
```sql
-- ❌ SLOW: Subquery in WHERE
EXPLAIN ANALYZE
SELECT * FROM users
WHERE id IN (SELECT user_id FROM orders WHERE total_amount > 500);

-- ✅ FAST: Use JOIN instead
EXPLAIN ANALYZE
SELECT DISTINCT u.* FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.total_amount > 500;
```

---

### 3. Index Strategies

#### 3.1 Create Composite Indexes
```sql
-- Composite index untuk common queries
CREATE INDEX idx_orders_user_status ON orders(user_id, status);
CREATE INDEX idx_order_items_order_product ON order_items(order_id, product_id);

-- Test performance
EXPLAIN ANALYZE
SELECT * FROM orders WHERE user_id = 1 AND status = 'completed';
```

#### 3.2 Create Partial Indexes
```sql
-- Partial index untuk active orders
CREATE INDEX idx_orders_active ON orders(user_id) 
WHERE status IN ('pending', 'processing');

-- Test performance
EXPLAIN ANALYZE
SELECT * FROM orders WHERE user_id = 1 AND status = 'pending';
```

#### 3.3 Identify Unused Indexes
```sql
-- Tìm unused indexes
SELECT 
  schemaname,
  tablename,
  indexname,
  idx_scan,
  idx_tup_read,
  idx_tup_fetch
FROM pg_stat_user_indexes
WHERE idx_scan = 0
ORDER BY pg_relation_size(relid) DESC;

-- Xóa unused indexes
DROP INDEX IF EXISTS index_name;
```

---

### 4. Query Rewriting

#### 4.1 Avoid SELECT *
```sql
-- ❌ SLOW: SELECT *
EXPLAIN ANALYZE
SELECT * FROM orders;

-- ✅ FAST: Select specific columns
EXPLAIN ANALYZE
SELECT id, user_id, total_amount, status FROM orders;
```

#### 4.2 Use LIMIT for Large Result Sets
```sql
-- ❌ SLOW: No LIMIT
EXPLAIN ANALYZE
SELECT * FROM order_items;

-- ✅ FAST: With LIMIT
EXPLAIN ANALYZE
SELECT * FROM order_items LIMIT 1000;
```

#### 4.3 Avoid Calculations on Indexed Columns
```sql
-- ❌ SLOW: Calculation on indexed column
EXPLAIN ANALYZE
SELECT * FROM orders WHERE EXTRACT(YEAR FROM created_at) = 2024;

-- ✅ FAST: Use range
EXPLAIN ANALYZE
SELECT * FROM orders 
WHERE created_at >= '2024-01-01' AND created_at < '2025-01-01';
```

---

### 5. Materialized Views for Performance

#### 5.1 Create Materialized Views
```sql
-- Materialized view untuk expensive queries
CREATE MATERIALIZED VIEW user_stats_mv AS
SELECT 
  u.id,
  u.name,
  COUNT(o.id) AS order_count,
  SUM(o.total_amount) AS total_spent,
  AVG(o.total_amount) AS avg_order_value
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;

-- Create index on materialized view
CREATE INDEX idx_user_stats_mv_id ON user_stats_mv(id);

-- Refresh materialized view
REFRESH MATERIALIZED VIEW user_stats_mv;
```

#### 5.2 Compare Performance
```sql
-- Regular view (slow)
EXPLAIN ANALYZE
SELECT * FROM user_order_summary WHERE id = 1;

-- Materialized view (fast)
EXPLAIN ANALYZE
SELECT * FROM user_stats_mv WHERE id = 1;
```

---

### 6. Batch Operations

#### 6.1 Optimize Bulk Insert
```sql
-- ❌ SLOW: Individual inserts
INSERT INTO users (name, email) VALUES ('User1', 'user1@example.com');
INSERT INTO users (name, email) VALUES ('User2', 'user2@example.com');

-- ✅ FAST: Bulk insert
INSERT INTO users (name, email)
SELECT 'User' || i, 'user' || i || '@example.com'
FROM generate_series(1, 1000) AS i;
```

#### 6.2 Optimize Bulk Update
```sql
-- ❌ SLOW: Individual updates
UPDATE users SET status = 'active' WHERE id = 1;
UPDATE users SET status = 'active' WHERE id = 2;

-- ✅ FAST: Bulk update
UPDATE users SET status = 'active' WHERE id IN (1, 2, 3);
```

---

### 7. Monitoring & Tuning

#### 7.1 Monitor Query Performance
```sql
-- Enable query statistics
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- View top slow queries
SELECT 
  query,
  calls,
  total_time,
  mean_time,
  max_time
FROM pg_stat_statements
ORDER BY mean_time DESC
LIMIT 10;
```

#### 7.2 Analyze Table Statistics
```sql
-- Analyze table for better query planning
ANALYZE users;
ANALYZE orders;
ANALYZE products;

-- View table statistics
SELECT 
  schemaname,
  tablename,
  n_live_tup,
  n_dead_tup,
  last_vacuum,
  last_autovacuum
FROM pg_stat_user_tables
ORDER BY n_live_tup DESC;
```

---

## 📝 Tasks

- [ ] Task 1: Baseline Performance Analysis
- [ ] Task 2: Optimize Complex Queries
- [ ] Task 3: Create Strategic Indexes
- [ ] Task 4: Rewrite Slow Queries
- [ ] Task 5: Create Materialized Views
- [ ] Task 6: Optimize Batch Operations
- [ ] Task 7: Monitor & Tune Performance

---

## 🎓 Learning Outcomes

Sau khi hoàn thành project này, bạn sẽ hiểu:
- ✅ Query performance analysis
- ✅ Index strategies
- ✅ Query optimization techniques
- ✅ Materialized views
- ✅ Performance monitoring

---

**Bây giờ hãy bắt đầu project! 🚀**

