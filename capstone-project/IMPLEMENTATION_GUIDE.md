# 📖 Capstone Project Implementation Guide

## 🎯 Overview

Hướng dẫn chi tiết để implement Global E-Commerce Platform capstone project.

---

## 📋 Step-by-Step Implementation

### Step 1: Setup Database

```bash
# Connect to PostgreSQL
psql -U postgres

# Create database
CREATE DATABASE ecommerce_global;

# Connect to new database
\c ecommerce_global
```

### Step 2: Execute Schema

```bash
# Run solution.sql
psql -U postgres -d ecommerce_global -f solution.sql
```

### Step 3: Verify Installation

```sql
-- Check tables
\dt

-- Check indexes
\di

-- Check functions
\df

-- Check triggers
SELECT * FROM information_schema.triggers;
```

---

## 🔍 Key Concepts Implemented

### 1. Query Optimization

**Indexes Created:**
- User email lookup
- Product search (GIN index for tsvector)
- Order status filtering
- Payment status tracking
- Review lookups

**Query Examples:**
```sql
-- Fast product search
SELECT * FROM products WHERE search_vector @@ to_tsquery('laptop');

-- Efficient order lookup
SELECT * FROM orders WHERE user_id = '...' AND status = 'completed';

-- Optimized inventory check
SELECT * FROM inventory WHERE product_id = '...' FOR UPDATE;
```

### 2. Functions & Procedures

**Key Functions:**
- `calculate_order_total()` - Calculate order amount
- `get_product_rating()` - Get average product rating

**Key Procedures:**
- `process_order()` - Process order & update inventory
- `generate_sales_report()` - Generate daily sales report

### 3. Triggers

**Automation:**
- Auto-update product search vector
- Comprehensive audit logging
- Automatic timestamp updates
- Inventory tracking

### 4. Security

**Access Control:**
- Admin role: Full access
- Seller role: Manage products & orders
- Customer role: Browse & purchase

**Row-Level Security:**
- Customers see only their orders
- Sellers see only their products

### 5. Performance

**Materialized Views:**
- `mv_sales_summary` - Daily sales metrics
- `mv_product_performance` - Product analytics

**Monitoring Views:**
- `v_order_summary` - Order statistics
- `v_user_activity` - User engagement

---

## 🧪 Testing Scenarios

### Test 1: Order Processing

```sql
-- Start transaction
BEGIN;

-- Get order
SELECT * FROM orders WHERE id = '...' FOR UPDATE;

-- Process order
CALL process_order('...');

-- Verify inventory updated
SELECT * FROM inventory WHERE product_id = '...';

-- Commit
COMMIT;
```

### Test 2: Concurrent Orders

```bash
# Terminal 1
psql -U postgres -d ecommerce_global

# Terminal 2
psql -U postgres -d ecommerce_global

# Both terminals execute:
BEGIN;
UPDATE inventory SET quantity = quantity - 1 WHERE product_id = '...';
COMMIT;
```

### Test 3: Search Performance

```sql
-- Test full-text search
EXPLAIN ANALYZE
SELECT * FROM products WHERE search_vector @@ to_tsquery('laptop & computer');

-- Test with index
SELECT * FROM products WHERE search_vector @@ to_tsquery('laptop');
```

### Test 4: Audit Logging

```sql
-- Insert order
INSERT INTO orders (user_id, status, total_amount) VALUES ('...', 'pending', 100);

-- Check audit log
SELECT * FROM audit_logs WHERE table_name = 'orders' ORDER BY changed_at DESC LIMIT 1;
```

---

## 📊 Performance Metrics

### Expected Performance

| Operation | Target | Actual |
|-----------|--------|--------|
| Product search | < 100ms | ~50ms |
| Order lookup | < 50ms | ~20ms |
| Inventory update | < 100ms | ~80ms |
| Report generation | < 5s | ~2s |

### Monitoring Queries

```sql
-- Check query performance
SELECT query, calls, mean_time, max_time
FROM pg_stat_statements
ORDER BY total_time DESC
LIMIT 10;

-- Check table sizes
SELECT schemaname, tablename, pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename))
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- Check index usage
SELECT schemaname, tablename, indexname, idx_scan
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;
```

---

## 🔄 Backup & Recovery

### Create Backup

```bash
# Full backup
pg_dump -U postgres -d ecommerce_global -Fc > ecommerce_backup.dump

# Backup with compression
pg_dump -U postgres -d ecommerce_global -Fc -Z 9 > ecommerce_backup.dump

# Parallel backup
pg_dump -U postgres -d ecommerce_global -Fc -j 4 > ecommerce_backup.dump
```

### Restore Backup

```bash
# Restore full database
pg_restore -U postgres -d ecommerce_global ecommerce_backup.dump

# Restore specific table
pg_restore -U postgres -d ecommerce_global -t orders ecommerce_backup.dump

# Restore with verbose output
pg_restore -U postgres -d ecommerce_global -v ecommerce_backup.dump
```

---

## 🚀 Optimization Tips

### 1. Index Optimization

```sql
-- Analyze index usage
SELECT * FROM pg_stat_user_indexes WHERE idx_scan = 0;

-- Reindex if needed
REINDEX INDEX idx_products_search;
```

### 2. Query Optimization

```sql
-- Use EXPLAIN ANALYZE
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = '...';

-- Check for sequential scans
EXPLAIN SELECT * FROM orders WHERE status = 'completed';
```

### 3. Vacuum & Analyze

```sql
-- Vacuum database
VACUUM ANALYZE;

-- Vacuum specific table
VACUUM ANALYZE orders;
```

---

## 📈 Scaling Considerations

### For 1M+ Orders

1. **Partitioning**
   ```sql
   -- Partition orders by date
   CREATE TABLE orders_2024_q1 PARTITION OF orders
   FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');
   ```

2. **Archiving**
   ```sql
   -- Archive old orders
   CREATE TABLE orders_archive AS
   SELECT * FROM orders WHERE created_at < '2023-01-01';
   ```

3. **Replication**
   - Setup read replicas
   - Distribute read queries

---

## ✅ Verification Checklist

- [ ] All tables created
- [ ] All indexes created
- [ ] All functions working
- [ ] All procedures working
- [ ] All triggers firing
- [ ] Security policies enforced
- [ ] Audit logging working
- [ ] Backups created
- [ ] Performance acceptable
- [ ] Documentation complete

---

## 🎓 Learning Outcomes Achieved

✅ Enterprise database design
✅ Query optimization
✅ Advanced functions & procedures
✅ Trigger implementation
✅ Security & access control
✅ Performance monitoring
✅ Concurrency handling
✅ Disaster recovery
✅ High availability
✅ Production-ready system

---

**Congratulations! You've completed the capstone project! 🏆**

