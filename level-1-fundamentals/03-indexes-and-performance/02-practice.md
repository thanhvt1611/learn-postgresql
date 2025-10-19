# 🛠️ Indexes & Performance - Thực Hành

Thực hành tạo indexes và tối ưu hóa queries.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Tạo được các loại indexes
- ✅ Sử dụng được EXPLAIN & EXPLAIN ANALYZE
- ✅ Tối ưu hóa được queries
- ✅ Hiểu query performance

---

## 📋 Bước 1: Chuẩn Bị Database

### Bước 1.1: Sử Dụng Database Từ Module 1-2

```sql
-- Kết nối
psql -U postgres -d ecommerce_practice

-- Kiểm tra tables
\dt
```

---

## 🔍 Bước 2: Thực Hành EXPLAIN (Không Có Index)

### Thực Hành 2.1: EXPLAIN Cơ Bản

```sql
-- Xem query plan (không có index)
EXPLAIN SELECT * FROM users WHERE email = 'john@example.com';
```

**Output:**
```
                        QUERY PLAN
──────────────────────────────────────────────────
 Seq Scan on users  (cost=0.00..35.50 rows=1 width=100)
   Filter: (email = 'john@example.com'::text)
(2 rows)
```

**Giải thích:**
- `Seq Scan` - Quét toàn bộ table (chậm)
- `cost=0.00..35.50` - Chi phí ước tính
- `rows=1` - Ước tính 1 row trả về

### Thực Hành 2.2: EXPLAIN ANALYZE

```sql
-- Thực thi query & xem statistics
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'john@example.com';
```

**Output:**
```
                                    QUERY PLAN
──────────────────────────────────────────────────────────────
 Seq Scan on users  (cost=0.00..35.50 rows=1 width=100)
   (actual time=0.045..0.048 rows=1 loops=1)
   Filter: (email = 'john@example.com'::text)
 Planning Time: 0.123 ms
 Execution Time: 0.089 ms
(5 rows)
```

---

## 🔧 Bước 3: Tạo Indexes

### Thực Hành 3.1: Tạo Single Column Index

```sql
-- Tạo index trên email
CREATE INDEX idx_users_email ON users(email);

-- Kiểm tra index
\d users
```

**Output:**
```
Indexes:
    "users_pkey" PRIMARY KEY, btree (id)
    "idx_users_email" btree (email)
```

### Thực Hành 3.2: Tạo Multi-Column Index

```sql
-- Tạo index trên user_id & status
CREATE INDEX idx_orders_user_status ON orders(user_id, status);

-- Kiểm tra
\d orders
```

### Thực Hành 3.3: Tạo Partial Index

```sql
-- Tạo index chỉ cho completed orders
CREATE INDEX idx_orders_completed ON orders(user_id) 
WHERE status = 'completed';
```

---

## 🔍 Bước 4: Thực Hành EXPLAIN (Có Index)

### Thực Hành 4.1: EXPLAIN Sau Khi Tạo Index

```sql
-- Xem query plan (có index)
EXPLAIN SELECT * FROM users WHERE email = 'john@example.com';
```

**Output:**
```
                              QUERY PLAN
──────────────────────────────────────────────────────────
 Index Scan using idx_users_email on users  (cost=0.29..8.30 rows=1 width=100)
   Index Cond: (email = 'john@example.com'::text)
(2 rows)
```

**Giải thích:**
- `Index Scan` - Sử dụng index (nhanh)
- `cost=0.29..8.30` - Chi phí giảm từ 35.50 → 8.30
- Tốc độ tăng ~4x

### Thực Hành 4.2: EXPLAIN ANALYZE Sau Index

```sql
-- Thực thi & xem statistics
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'john@example.com';
```

**Output:**
```
                                    QUERY PLAN
──────────────────────────────────────────────────────────────
 Index Scan using idx_users_email on users  (cost=0.29..8.30 rows=1 width=100)
   (actual time=0.045..0.048 rows=1 loops=1)
   Index Cond: (email = 'john@example.com'::text)
 Planning Time: 0.123 ms
 Execution Time: 0.089 ms
(5 rows)
```

---

## 📊 Bước 5: Thực Hành Xem Indexes

### Thực Hành 5.1: Liệt Kê Indexes

```sql
-- Liệt kê tất cả indexes
SELECT * FROM pg_indexes WHERE tablename = 'users';
```

**Output:**
```
 schemaname | tablename | indexname | tablespace | indexdef
─────────────┼───────────┼──────────────────┼────────────┼──────────────────────────────
 public     | users     | users_pkey       |            | CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id)
 public     | users     | idx_users_email  |            | CREATE INDEX idx_users_email ON public.users USING btree (email)
```

### Thực Hành 5.2: Xem Index Size

```sql
-- Xem kích thước indexes
SELECT 
    indexname,
    pg_size_pretty(pg_relation_size(indexrelid)) AS index_size
FROM pg_indexes
JOIN pg_class ON pg_indexes.indexname = pg_class.relname
WHERE tablename = 'users';
```

---

## ⚡ Bước 6: Thực Hành Query Optimization

### Thực Hành 6.1: Tránh Calculations

```sql
-- ❌ BAD: Calculation trên indexed column
EXPLAIN SELECT * FROM orders WHERE EXTRACT(YEAR FROM created_at) = 2024;

-- ✅ GOOD: Sử dụng range
EXPLAIN SELECT * FROM orders 
WHERE created_at >= '2024-01-01' AND created_at < '2025-01-01';
```

### Thực Hành 6.2: Sử Dụng LIMIT

```sql
-- ❌ BAD: Lấy tất cả rows
EXPLAIN SELECT * FROM orders;

-- ✅ GOOD: Giới hạn rows
EXPLAIN SELECT * FROM orders LIMIT 10;
```

### Thực Hành 6.3: Tránh SELECT *

```sql
-- ❌ BAD: Lấy tất cả columns
EXPLAIN SELECT * FROM orders;

-- ✅ GOOD: Chỉ lấy columns cần thiết
EXPLAIN SELECT id, user_id, total_amount FROM orders;
```

---

## 🔗 Bước 7: Thực Hành JOINs Performance

### Thực Hành 7.1: EXPLAIN Cho JOINs

```sql
-- Xem query plan cho JOIN
EXPLAIN ANALYZE 
SELECT u.name, o.id, o.total_amount
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE u.email = 'john@example.com';
```

**Output:**
```
                                    QUERY PLAN
──────────────────────────────────────────────────────────────
 Nested Loop  (cost=0.29..16.60 rows=2 width=...)
   ->  Index Scan using idx_users_email on users u  (cost=0.29..8.30 rows=1 width=...)
         Index Cond: (email = 'john@example.com'::text)
   ->  Seq Scan on orders o  (cost=0.00..8.30 rows=2 width=...)
         Filter: (user_id = u.id)
(5 rows)
```

### Thực Hành 7.2: Tạo Index Cho JOIN

```sql
-- Tạo index trên user_id (foreign key)
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- Chạy EXPLAIN lại
EXPLAIN ANALYZE 
SELECT u.name, o.id, o.total_amount
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE u.email = 'john@example.com';
```

---

## 🗑️ Bước 8: Xóa Indexes

### Thực Hành 8.1: Xóa Index

```sql
-- Xóa index
DROP INDEX idx_users_email;

-- Kiểm tra
\d users
```

### Thực Hành 8.2: Xóa Nếu Tồn Tại

```sql
-- Xóa nếu tồn tại (không lỗi nếu không tồn tại)
DROP INDEX IF EXISTS idx_users_email;
```

---

## 📊 Bước 9: Thực Hành Aggregate Performance

### Thực Hành 9.1: EXPLAIN Cho Aggregates

```sql
-- Xem query plan cho aggregate
EXPLAIN ANALYZE 
SELECT user_id, COUNT(*) AS order_count
FROM orders
GROUP BY user_id;
```

### Thực Hành 9.2: Tạo Index Cho GROUP BY

```sql
-- Tạo index trên user_id
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- Chạy EXPLAIN lại
EXPLAIN ANALYZE 
SELECT user_id, COUNT(*) AS order_count
FROM orders
GROUP BY user_id;
```

---

## ✅ Checklist Thực Hành

- [ ] Thực hành EXPLAIN (không có index)
- [ ] Thực hành EXPLAIN ANALYZE
- [ ] Tạo single column index
- [ ] Tạo multi-column index
- [ ] Tạo partial index
- [ ] Thực hành EXPLAIN (có index)
- [ ] Liệt kê indexes
- [ ] Xem index size
- [ ] Tối ưu hóa queries
- [ ] Thực hành JOINs performance
- [ ] Thực hành Aggregate performance
- [ ] Xóa indexes

---

## 💡 Tips

1. **Luôn sử dụng EXPLAIN** - Kiểm tra query plan trước & sau
2. **So sánh costs** - Xem chi phí giảm bao nhiêu
3. **Kiểm tra actual time** - Xem thời gian thực tế
4. **Không tạo quá nhiều indexes** - Chậm INSERT/UPDATE/DELETE
5. **Monitor indexes** - Xóa unused indexes

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

