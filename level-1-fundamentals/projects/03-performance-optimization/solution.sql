-- ⚡ Project 3: Performance Optimization - Solution

-- ============================================
-- Task 1: Baseline Performance Analysis
-- ============================================

-- Enable query logging
ALTER SYSTEM SET log_min_duration_statement = 1000;
SELECT pg_reload_conf();

-- View slow queries
SELECT 
  query,
  calls,
  total_time,
  mean_time,
  max_time
FROM pg_stat_statements
ORDER BY mean_time DESC
LIMIT 10;

-- List all indexes
SELECT 
  schemaname,
  tablename,
  indexname,
  indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename;

-- View index sizes
SELECT 
  indexname,
  pg_size_pretty(pg_relation_size(indexrelid)) AS index_size
FROM pg_indexes
JOIN pg_class ON pg_indexes.indexname = pg_class.relname
WHERE schemaname = 'public'
ORDER BY pg_relation_size(indexrelid) DESC;

-- ============================================
-- Task 2: Optimize Complex Queries
-- ============================================

-- SLOW: Multiple JOINs without indexes
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

-- Create indexes
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- FAST: With proper indexes
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

-- ============================================
-- Task 3: Create Strategic Indexes
-- ============================================

-- Composite indexes
CREATE INDEX idx_orders_user_status ON orders(user_id, status);
CREATE INDEX idx_order_items_order_product ON order_items(order_id, product_id);

-- Partial indexes
CREATE INDEX idx_orders_active ON orders(user_id) 
WHERE status IN ('pending', 'processing');

-- Test composite index
EXPLAIN ANALYZE
SELECT * FROM orders WHERE user_id = 1 AND status = 'completed';

-- Test partial index
EXPLAIN ANALYZE
SELECT * FROM orders WHERE user_id = 1 AND status = 'pending';

-- Find unused indexes
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

-- ============================================
-- Task 4: Query Rewriting
-- ============================================

-- SLOW: SELECT *
EXPLAIN ANALYZE
SELECT * FROM orders;

-- FAST: Select specific columns
EXPLAIN ANALYZE
SELECT id, user_id, total_amount, status FROM orders;

-- SLOW: No LIMIT
EXPLAIN ANALYZE
SELECT * FROM order_items;

-- FAST: With LIMIT
EXPLAIN ANALYZE
SELECT * FROM order_items LIMIT 1000;

-- SLOW: Calculation on indexed column
EXPLAIN ANALYZE
SELECT * FROM orders WHERE EXTRACT(YEAR FROM created_at) = 2024;

-- FAST: Use range
EXPLAIN ANALYZE
SELECT * FROM orders 
WHERE created_at >= '2024-01-01' AND created_at < '2025-01-01';

-- ============================================
-- Task 5: Materialized Views
-- ============================================

-- Create materialized view
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

-- Compare performance
EXPLAIN ANALYZE
SELECT * FROM user_stats_mv WHERE id = 1;

-- ============================================
-- Task 6: Optimize Batch Operations
-- ============================================

-- FAST: Bulk insert
INSERT INTO users (name, email)
SELECT 'BulkUser' || i, 'bulkuser' || i || '@example.com'
FROM generate_series(1, 100) AS i;

-- FAST: Bulk update
UPDATE users SET status = 'active' WHERE id IN (1, 2, 3);

-- ============================================
-- Task 7: Monitoring & Tuning
-- ============================================

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

-- Analyze tables
ANALYZE users;
ANALYZE orders;
ANALYZE products;
ANALYZE order_items;
ANALYZE reviews;

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

-- ============================================
-- Performance Comparison Queries
-- ============================================

-- Query 1: Product Revenue
EXPLAIN ANALYZE
SELECT 
  p.id,
  p.name,
  COUNT(DISTINCT oi.order_id) AS times_ordered,
  SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.name
ORDER BY total_revenue DESC;

-- Query 2: Customer Segmentation
EXPLAIN ANALYZE
SELECT 
  u.id,
  u.name,
  COUNT(o.id) AS order_count,
  SUM(o.total_amount) AS total_spent,
  CASE 
    WHEN SUM(o.total_amount) > 1000 THEN 'VIP'
    WHEN SUM(o.total_amount) > 500 THEN 'Premium'
    ELSE 'Regular'
  END AS segment
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;

-- Query 3: Order Details
EXPLAIN ANALYZE
SELECT 
  o.id,
  u.name,
  p.name AS product_name,
  oi.quantity,
  oi.unit_price
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE o.status = 'completed';

-- ============================================
-- Final Index Summary
-- ============================================

SELECT 
  schemaname,
  tablename,
  indexname,
  pg_size_pretty(pg_relation_size(indexrelid)) AS size
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

