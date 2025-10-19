# 🏆 Best Practices - PostgreSQL & SQL

Tổng hợp best practices cho PostgreSQL development, từ cơ bản đến nâng cao.

## 📋 Mục Lục

1. [SQL & Query Best Practices](#sql--query-best-practices)
2. [Database Design](#database-design)
3. [Performance Optimization](#performance-optimization)
4. [Security](#security)
5. [Backup & Disaster Recovery](#backup--disaster-recovery)
6. [Monitoring & Maintenance](#monitoring--maintenance)
7. [Code Style & Naming](#code-style--naming)

---

## SQL & Query Best Practices

### ✅ DO: Viết Queries Hiệu Quả

```sql
-- ✅ GOOD: Sử dụng JOIN thay vì subquery
SELECT u.id, u.name, COUNT(o.id) as order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;

-- ✅ GOOD: Sử dụng WHERE để filter sớm
SELECT * FROM orders
WHERE created_at >= '2024-01-01'
AND status = 'completed';

-- ✅ GOOD: Sử dụng LIMIT để giới hạn kết quả
SELECT * FROM products
ORDER BY created_at DESC
LIMIT 10;
```

### ❌ DON'T: Tránh Queries Kém Hiệu Quả

```sql
-- ❌ BAD: SELECT * (lấy tất cả columns)
SELECT * FROM users;

-- ✅ GOOD: Chỉ lấy columns cần thiết
SELECT id, name, email FROM users;

-- ❌ BAD: Subquery trong SELECT
SELECT u.id, (SELECT COUNT(*) FROM orders WHERE user_id = u.id)
FROM users u;

-- ✅ GOOD: Sử dụng JOIN hoặc window function
SELECT u.id, COUNT(o.id) OVER (PARTITION BY u.id)
FROM users u
LEFT JOIN orders o ON u.id = o.user_id;

-- ❌ BAD: LIKE với wildcard ở đầu
SELECT * FROM users WHERE name LIKE '%john%';

-- ✅ GOOD: Sử dụng full-text search hoặc ILIKE
SELECT * FROM users WHERE name ILIKE 'john%';
```

### 💡 Query Optimization Tips

```sql
-- ✅ Sử dụng EXPLAIN ANALYZE để phân tích queries
EXPLAIN ANALYZE
SELECT u.id, u.name, COUNT(o.id)
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;

-- ✅ Sử dụng CTEs (Common Table Expressions) cho queries phức tạp
WITH recent_orders AS (
    SELECT * FROM orders
    WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'
)
SELECT u.id, u.name, COUNT(ro.id)
FROM users u
LEFT JOIN recent_orders ro ON u.id = ro.user_id
GROUP BY u.id, u.name;

-- ✅ Sử dụng Window Functions thay vì GROUP BY khi cần
SELECT 
    id, name, salary,
    AVG(salary) OVER (PARTITION BY department_id) as avg_salary
FROM employees;
```

---

## Database Design

### ✅ DO: Thiết Kế Schema Tốt

```sql
-- ✅ GOOD: Sử dụng PRIMARY KEY
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ✅ GOOD: Sử dụng FOREIGN KEY
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    total_amount DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ✅ GOOD: Sử dụng CHECK constraints
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    stock INTEGER NOT NULL CHECK (stock >= 0)
);

-- ✅ GOOD: Sử dụng ENUM cho fixed values
CREATE TYPE order_status AS ENUM ('pending', 'processing', 'completed', 'cancelled');
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    status order_status DEFAULT 'pending'
);
```

### ❌ DON'T: Tránh Thiết Kế Kém

```sql
-- ❌ BAD: Không có PRIMARY KEY
CREATE TABLE users (
    name VARCHAR(100),
    email VARCHAR(100)
);

-- ❌ BAD: Lưu trữ dữ liệu liên quan trong một column
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    phone_numbers VARCHAR(500)  -- Lưu nhiều số điện thoại
);

-- ✅ GOOD: Tạo table riêng cho relationships
CREATE TABLE phone_numbers (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    phone VARCHAR(20) NOT NULL
);

-- ❌ BAD: Lưu trữ dữ liệu tính toán được
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    item_price DECIMAL(10, 2),
    quantity INTEGER,
    total_price DECIMAL(10, 2)  -- Có thể tính từ item_price * quantity
);

-- ✅ GOOD: Tính toán khi cần
SELECT id, item_price * quantity as total_price FROM orders;
```

### 📐 Naming Conventions

```sql
-- ✅ GOOD: Tên rõ ràng, snake_case
CREATE TABLE user_profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    date_of_birth DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ✅ GOOD: Tên columns mô tả
-- Tránh: id, data, info, temp
-- Sử dụng: user_id, order_date, customer_email

-- ✅ GOOD: Tên tables là danh từ số nhiều
-- users, orders, products, categories

-- ✅ GOOD: Tên functions là động từ
-- get_user_orders(), calculate_total(), validate_email()
```

---

## Performance Optimization

### 🚀 Indexing Strategy

```sql
-- ✅ GOOD: Tạo index cho columns thường xuyên được query
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_created_at ON orders(created_at);

-- ✅ GOOD: Composite index cho queries với multiple columns
CREATE INDEX idx_orders_user_created ON orders(user_id, created_at);

-- ✅ GOOD: Partial index cho filtered queries
CREATE INDEX idx_active_users ON users(id) WHERE deleted_at IS NULL;

-- ✅ GOOD: BRIN index cho large tables với sequential data
CREATE INDEX idx_orders_date_brin ON orders USING BRIN (created_at);

-- ❌ DON'T: Tạo quá nhiều indexes
-- Mỗi index tăng thời gian INSERT/UPDATE/DELETE
-- Chỉ tạo index cho columns thường xuyên được query
```

### 📊 Query Performance

```sql
-- ✅ GOOD: Sử dụng VACUUM & ANALYZE
VACUUM ANALYZE users;

-- ✅ GOOD: Kiểm tra query plan
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM users WHERE email = 'test@example.com';

-- ✅ GOOD: Sử dụng prepared statements
PREPARE get_user (INTEGER) AS SELECT * FROM users WHERE id = $1;
EXECUTE get_user(1);

-- ✅ GOOD: Batch operations
INSERT INTO logs (user_id, action) VALUES
(1, 'login'),
(2, 'logout'),
(3, 'update_profile');
```

---

## Security

### 🔐 Authentication & Authorization

```sql
-- ✅ GOOD: Tạo roles với permissions cụ thể
CREATE ROLE app_user WITH LOGIN PASSWORD 'secure_password';
GRANT CONNECT ON DATABASE learning TO app_user;
GRANT USAGE ON SCHEMA public TO app_user;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO app_user;

-- ✅ GOOD: Sử dụng Row-Level Security (RLS)
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY user_orders ON orders
    FOR SELECT USING (user_id = current_user_id());

-- ❌ DON'T: Sử dụng superuser cho application
-- ❌ DON'T: Lưu trữ passwords trong plain text
-- ❌ DON'T: Sử dụng default passwords
```

### 🛡️ SQL Injection Prevention

```sql
-- ❌ BAD: String concatenation (vulnerable to SQL injection)
SELECT * FROM users WHERE email = '" + user_input + "';

-- ✅ GOOD: Sử dụng parameterized queries
SELECT * FROM users WHERE email = $1;  -- Với parameter binding

-- ✅ GOOD: Sử dụng prepared statements
PREPARE get_user_by_email (VARCHAR) AS
    SELECT * FROM users WHERE email = $1;
```

### 🔒 Data Protection

```sql
-- ✅ GOOD: Sử dụng SSL/TLS cho connections
-- Cấu hình trong postgresql.conf:
-- ssl = on
-- ssl_cert_file = 'server.crt'
-- ssl_key_file = 'server.key'

-- ✅ GOOD: Encrypt sensitive data
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100),
    ssn_encrypted BYTEA  -- Lưu trữ encrypted
);

-- ✅ GOOD: Audit logging
CREATE TABLE audit_log (
    id SERIAL PRIMARY KEY,
    table_name VARCHAR(100),
    operation VARCHAR(10),
    old_data JSONB,
    new_data JSONB,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## Backup & Disaster Recovery

### 💾 Backup Strategy

```bash
# ✅ GOOD: Regular full backups
pg_dump -U postgres learning > backup_$(date +%Y%m%d).sql

# ✅ GOOD: Compressed backups
pg_dump -U postgres -Fc learning > backup_$(date +%Y%m%d).dump

# ✅ GOOD: Incremental backups (WAL archiving)
# Cấu hình dalam postgresql.conf:
# wal_level = replica
# archive_mode = on
# archive_command = 'cp %p /backup/wal_archive/%f'

# ✅ GOOD: Automated backups
# Sử dụng cron job:
# 0 2 * * * pg_dump -U postgres learning | gzip > /backup/backup_$(date +\%Y\%m\%d).sql.gz
```

### 🔄 Recovery

```bash
# ✅ GOOD: Restore from backup
psql -U postgres learning < backup_20240101.sql

# ✅ GOOD: Restore from compressed backup
pg_restore -U postgres -d learning backup_20240101.dump

# ✅ GOOD: Point-in-time recovery
# Sử dụng WAL files để recover đến specific time
```

---

## Monitoring & Maintenance

### 📊 Monitoring

```sql
-- ✅ GOOD: Kiểm tra database size
SELECT datname, pg_size_pretty(pg_database_size(datname))
FROM pg_database
ORDER BY pg_database_size(datname) DESC;

-- ✅ GOOD: Kiểm tra table size
SELECT schemaname, tablename, pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename))
FROM pg_tables
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- ✅ GOOD: Kiểm tra slow queries
SELECT query, calls, mean_exec_time
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 10;

-- ✅ GOOD: Kiểm tra active connections
SELECT datname, usename, application_name, state
FROM pg_stat_activity
WHERE state != 'idle';
```

### 🧹 Maintenance

```sql
-- ✅ GOOD: Regular VACUUM
VACUUM ANALYZE;

-- ✅ GOOD: Reindex tables
REINDEX TABLE users;

-- ✅ GOOD: Check table integrity
ANALYZE users;

-- ✅ GOOD: Monitor transaction log
SELECT * FROM pg_stat_user_tables
ORDER BY seq_scan DESC;
```

---

## Code Style & Naming

### 📝 SQL Style Guide

```sql
-- ✅ GOOD: Consistent formatting
SELECT 
    u.id,
    u.name,
    u.email,
    COUNT(o.id) as order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE u.created_at >= '2024-01-01'
GROUP BY u.id, u.name, u.email
ORDER BY order_count DESC;

-- ✅ GOOD: Comments cho complex logic
-- Calculate average order value per user
-- Only include users with at least 5 orders
SELECT 
    u.id,
    u.name,
    AVG(o.total_amount) as avg_order_value
FROM users u
INNER JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name
HAVING COUNT(o.id) >= 5;

-- ✅ GOOD: Use uppercase cho SQL keywords
SELECT id, name FROM users WHERE status = 'active';

-- ✅ GOOD: Use lowercase cho identifiers
SELECT user_id, order_date FROM orders;
```

### 🏷️ Naming Conventions Summary

| Đối Tượng | Convention | Ví Dụ |
|-----------|-----------|-------|
| Tables | snake_case, plural | users, orders, products |
| Columns | snake_case | user_id, created_at, first_name |
| Primary Keys | id | id |
| Foreign Keys | {table}_id | user_id, product_id |
| Indexes | idx_{table}_{column} | idx_users_email |
| Functions | snake_case, verb | get_user_orders() |
| Triggers | {table}_{action}_{time} | users_update_timestamp |
| Views | v_{name} | v_active_users |

---

## 📚 Tóm Tắt Best Practices

| Lĩnh Vực | Best Practice |
|---------|---------------|
| **Queries** | Sử dụng JOINs, CTEs, Window Functions; Tránh SELECT * |
| **Design** | PRIMARY KEY, FOREIGN KEY, Constraints; Normalize data |
| **Performance** | Indexes, EXPLAIN ANALYZE, VACUUM; Monitor queries |
| **Security** | Parameterized queries, RLS, SSL; Least privilege |
| **Backup** | Regular backups, WAL archiving, Test recovery |
| **Monitoring** | Track size, slow queries, connections; Maintenance |
| **Code** | Consistent style, Clear naming, Comments |

---

**Áp dụng những best practices này sẽ giúp bạn xây dựng database systems mạnh mẽ, an toàn, và hiệu quả! 🚀**

