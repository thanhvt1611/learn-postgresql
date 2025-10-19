# 🛠️ Query Optimization & EXPLAIN - Thực Hành

Thực hành tối ưu hóa queries & phân tích query plans.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Sử dụng được EXPLAIN & EXPLAIN ANALYZE
- ✅ Đọc được query plans
- ✅ Hiểu các loại scans
- ✅ Tối ưu hóa slow queries
- ✅ Tạo được effective indexes

---

## 📋 Bước 1: Chuẩn Bị Database

### Bước 1.1: Kết Nối Database

```sql
-- Kết nối
psql -U postgres -d ecommerce_practice

-- Kiểm tra tables
\dt
```

---

## 🔍 Bước 2: Thực Hành EXPLAIN

### Thực Hành 2.1: Simple EXPLAIN

```sql
-- EXPLAIN without execution
EXPLAIN SELECT * FROM products WHERE price > 100;

-- Output:
-- Seq Scan on products  (cost=0.00..35.50 rows=100 width=32)
--   Filter: (price > 100)
```

### Thực Hành 2.2: EXPLAIN ANALYZE

```sql
-- EXPLAIN with execution
EXPLAIN ANALYZE SELECT * FROM products WHERE price > 100;

-- Output:
-- Seq Scan on products  (cost=0.00..35.50 rows=100 width=32) (actual time=0.123..0.456 rows=100 loops=1)
--   Filter: (price > 100)
```

### Thực Hành 2.3: EXPLAIN with Verbose

```sql
-- EXPLAIN with verbose output
EXPLAIN (ANALYZE, VERBOSE) SELECT * FROM products WHERE price > 100;
```

---

## 📊 Bước 3: Thực Hành Scans

### Thực Hành 3.1: Seq Scan

```sql
-- Seq Scan (no index)
EXPLAIN ANALYZE SELECT * FROM products WHERE price > 100;
```

### Thực Hành 3.2: Create Index

```sql
-- Create index
CREATE INDEX idx_products_price ON products(price);
```

### Thực Hành 3.3: Index Scan

```sql
-- Index Scan (with index)
EXPLAIN ANALYZE SELECT * FROM products WHERE price > 100;
```

### Thực Hành 3.4: Index Only Scan

```sql
-- Create covering index
CREATE INDEX idx_products_covering ON products(price) INCLUDE (name, category);

-- Index Only Scan
EXPLAIN ANALYZE SELECT name, price FROM products WHERE price > 100;
```

---

## 🔗 Bước 4: Thực Hành Joins

### Thực Hành 4.1: Nested Loop Join

```sql
-- Nested Loop Join
EXPLAIN ANALYZE 
SELECT p.name, o.total_amount
FROM products p
JOIN order_items oi ON p.id = oi.product_id
JOIN orders o ON oi.order_id = o.id
WHERE p.price > 100;
```

### Thực Hành 4.2: Hash Join

```sql
-- Hash Join (large tables)
EXPLAIN ANALYZE
SELECT u.name, COUNT(o.id) AS order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;
```

### Thực Hành 4.3: Merge Join

```sql
-- Merge Join (sorted data)
EXPLAIN ANALYZE
SELECT u.name, o.total_amount
FROM users u
JOIN orders o ON u.id = o.user_id
ORDER BY u.id, o.id;
```

---

## 🎯 Bước 5: Query Optimization

### Thực Hành 5.1: Optimize with Index

```sql
-- Before: Seq Scan
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = 1;

-- Create index
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- After: Index Scan
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = 1;
```

### Thực Hành 5.2: Optimize with LIMIT

```sql
-- Without LIMIT
EXPLAIN ANALYZE SELECT * FROM products;

-- With LIMIT
EXPLAIN ANALYZE SELECT * FROM products LIMIT 10;
```

### Thực Hành 5.3: Optimize with Specific Columns

```sql
-- SELECT *
EXPLAIN ANALYZE SELECT * FROM products;

-- Specific columns
EXPLAIN ANALYZE SELECT id, name, price FROM products;
```

---

## 📈 Bước 6: Analyze Query Performance

### Thực Hành 6.1: Compare Query Plans

```sql
-- Query 1: Without index
EXPLAIN ANALYZE SELECT * FROM products WHERE category = 'Electronics';

-- Query 2: With index
CREATE INDEX idx_products_category ON products(category);
EXPLAIN ANALYZE SELECT * FROM products WHERE category = 'Electronics';
```

### Thực Hành 6.2: Analyze Join Performance

```sql
-- Analyze join performance
EXPLAIN (ANALYZE, BUFFERS) 
SELECT u.name, COUNT(o.id) AS order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;
```

### Thực Hành 6.3: Identify Slow Queries

```sql
-- Identify slow queries
EXPLAIN ANALYZE
SELECT p.name, COUNT(oi.id) AS item_count
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.id
WHERE o.created_at > CURRENT_DATE - INTERVAL '30 days'
GROUP BY p.id, p.name;
```

---

## 🔧 Bước 7: Index Strategies

### Thực Hành 7.1: Single Column Index

```sql
-- Single column index
CREATE INDEX idx_users_email ON users(email);
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'test@example.com';
```

### Thực Hành 7.2: Multi-Column Index

```sql
-- Multi-column index
CREATE INDEX idx_orders_user_date ON orders(user_id, created_at);
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = 1 AND created_at > '2024-01-01';
```

### Thực Hành 7.3: Partial Index

```sql
-- Partial index
CREATE INDEX idx_orders_pending ON orders(id) WHERE status = 'pending';
EXPLAIN ANALYZE SELECT * FROM orders WHERE status = 'pending';
```

---

## ✅ Checklist Thực Hành

- [ ] Thực hành EXPLAIN & EXPLAIN ANALYZE
- [ ] Hiểu query plan components
- [ ] Thực hành Seq Scan & Index Scan
- [ ] Thực hành Index Only Scan
- [ ] Thực hành Join types
- [ ] Optimize queries với indexes
- [ ] Analyze query performance
- [ ] Create effective indexes

---

## 💡 Tips

1. **Sử dụng EXPLAIN ANALYZE** - Để debug queries
2. **Tạo indexes** - Trên frequently queried columns
3. **Tránh SELECT *** - Chỉ select cần thiết columns
4. **Sử dụng LIMIT** - Để giới hạn results
5. **Monitor performance** - Thường xuyên

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

