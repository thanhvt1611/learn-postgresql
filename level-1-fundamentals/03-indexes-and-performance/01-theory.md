# 📚 Indexes & Performance - Lý Thuyết

Hiểu cách tối ưu hóa queries và cải thiện hiệu suất database.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu Indexes là gì và tại sao quan trọng
- ✅ Biết các loại Indexes (B-tree, Hash, GiST, GIN)
- ✅ Biết cách tạo & xóa Indexes
- ✅ Hiểu EXPLAIN & EXPLAIN ANALYZE
- ✅ Biết cách tối ưu hóa queries
- ✅ Hiểu Query Performance

---

## 🔍 Indexes - Chỉ Mục

### Định Nghĩa

**Index** là cấu trúc dữ liệu giúp tìm kiếm dữ liệu nhanh hơn, giống như chỉ mục trong sách.

### Tại Sao Indexes Quan Trọng?

1. **Tìm kiếm nhanh** - Giảm thời gian tìm kiếm từ O(n) → O(log n)
2. **Sắp xếp nhanh** - ORDER BY nhanh hơn
3. **JOINs nhanh** - Kết hợp tables nhanh hơn
4. **Giảm I/O** - Ít đọc disk hơn

### Ví Dụ: Với & Không Có Index

```
Không có Index (Full Table Scan):
┌─────────────────────────────────────┐
│ Phải quét tất cả 1,000,000 rows     │
│ Thời gian: 5 giây                   │
└─────────────────────────────────────┘

Có Index (Index Scan):
┌─────────────────────────────────────┐
│ Chỉ quét ~20 rows                   │
│ Thời gian: 0.05 giây                │
└─────────────────────────────────────┘
```

---

## 📊 Loại Indexes

### 1. B-tree Index (Mặc Định)

**Định nghĩa:** Cấu trúc cây cân bằng, phù hợp cho hầu hết queries.

**Khi dùng:**
- ✅ Equality (=)
- ✅ Range (<, >, <=, >=)
- ✅ LIKE (với prefix)
- ✅ ORDER BY

**Ví dụ:**
```sql
CREATE INDEX idx_users_email ON users(email);
```

### 2. Hash Index

**Định nghĩa:** Sử dụng hash function, chỉ phù hợp cho equality.

**Khi dùng:**
- ✅ Equality (=) chỉ

**Ví dụ:**
```sql
CREATE INDEX idx_users_email_hash ON users USING HASH (email);
```

### 3. GiST Index (Generalized Search Tree)

**Định nghĩa:** Phù hợp cho spatial data, full-text search.

**Khi dùng:**
- ✅ Geometric data
- ✅ Full-text search
- ✅ Range queries

### 4. GIN Index (Generalized Inverted Index)

**Định nghĩa:** Phù hợp cho array, JSON, full-text search.

**Khi dùng:**
- ✅ Array columns
- ✅ JSON columns
- ✅ Full-text search

---

## 🔧 Tạo Indexes

### Cú Pháp Cơ Bản

```sql
CREATE INDEX index_name ON table_name (column_name);
```

### Ví Dụ 1: Single Column Index

```sql
-- Tạo index trên email
CREATE INDEX idx_users_email ON users(email);

-- Tạo index trên user_id
CREATE INDEX idx_orders_user_id ON orders(user_id);
```

### Ví Dụ 2: Multi-Column Index

```sql
-- Tạo index trên user_id & status
CREATE INDEX idx_orders_user_status ON orders(user_id, status);
```

### Ví Dụ 3: Unique Index

```sql
-- Tạo unique index (tự động enforce uniqueness)
CREATE UNIQUE INDEX idx_users_email_unique ON users(email);
```

### Ví Dụ 4: Partial Index

```sql
-- Tạo index chỉ cho completed orders
CREATE INDEX idx_orders_completed ON orders(user_id) 
WHERE status = 'completed';
```

---

## 🗑️ Xóa Indexes

### Cú Pháp

```sql
DROP INDEX index_name;
DROP INDEX IF EXISTS index_name;
```

### Ví Dụ

```sql
-- Xóa index
DROP INDEX idx_users_email;

-- Xóa nếu tồn tại
DROP INDEX IF EXISTS idx_users_email;
```

---

## 📊 Xem Indexes

### Liệt Kê Indexes

```sql
-- Liệt kê tất cả indexes
SELECT * FROM pg_indexes WHERE tablename = 'users';

-- Hoặc sử dụng psql command
\d users
```

### Output

```
 schemaname | tablename | indexname | tablespace | indexdef
-------------+-----------+------------------+------------+------------------
 public     | users     | users_pkey       |            | CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id)
 public     | users     | idx_users_email  |            | CREATE INDEX idx_users_email ON public.users USING btree (email)
```

---

## 🔍 EXPLAIN & EXPLAIN ANALYZE

### Định Nghĩa

**EXPLAIN** hiển thị query plan (cách PostgreSQL thực thi query).
**EXPLAIN ANALYZE** thực thi query & hiển thị actual statistics.

### Cú Pháp

```sql
EXPLAIN query;
EXPLAIN ANALYZE query;
```

### Ví Dụ 1: Không Có Index

```sql
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

### Ví Dụ 2: Có Index

```sql
-- Tạo index
CREATE INDEX idx_users_email ON users(email);

-- Chạy EXPLAIN lại
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

### Ví Dụ 3: EXPLAIN ANALYZE

```sql
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

## 📊 Hiểu EXPLAIN Output

### Các Thành Phần Chính

| Thành Phần | Mô Tả |
|-----------|-------|
| **Seq Scan** | Quét toàn bộ table (chậm) |
| **Index Scan** | Sử dụng index (nhanh) |
| **cost** | Ước tính chi phí (0.00..35.50) |
| **rows** | Ước tính số rows trả về |
| **actual time** | Thời gian thực tế (ms) |
| **loops** | Số lần thực thi |

---

## ⚡ Query Performance Tips

### 1. Sử Dụng Indexes Cho Columns Thường Xuyên Tìm Kiếm

```sql
-- ✅ GOOD: Có index
CREATE INDEX idx_orders_user_id ON orders(user_id);
SELECT * FROM orders WHERE user_id = 1;

-- ❌ BAD: Không có index
SELECT * FROM orders WHERE created_at > '2024-01-01';
```

### 2. Tránh Calculations Trên Indexed Columns

```sql
-- ❌ BAD: Calculation trên indexed column
SELECT * FROM orders WHERE YEAR(created_at) = 2024;

-- ✅ GOOD: Sử dụng range
SELECT * FROM orders WHERE created_at >= '2024-01-01' AND created_at < '2025-01-01';
```

### 3. Sử Dụng LIMIT Cho Large Result Sets

```sql
-- ❌ BAD: Lấy tất cả rows
SELECT * FROM orders;

-- ✅ GOOD: Giới hạn rows
SELECT * FROM orders LIMIT 10;
```

### 4. Tránh SELECT *

```sql
-- ❌ BAD: Lấy tất cả columns
SELECT * FROM orders;

-- ✅ GOOD: Chỉ lấy columns cần thiết
SELECT id, user_id, total_amount FROM orders;
```

### 5. Sử Dụng JOINs Thay Vì Subqueries (Thường)

```sql
-- ❌ BAD: Subquery (có thể chậm)
SELECT * FROM users WHERE id IN (SELECT user_id FROM orders);

-- ✅ GOOD: JOIN (thường nhanh hơn)
SELECT DISTINCT u.* FROM users u JOIN orders o ON u.id = o.user_id;
```

---

## 🎯 Index Best Practices

### ✅ DO

1. **Tạo indexes cho columns trong WHERE** - Tìm kiếm nhanh
2. **Tạo indexes cho columns trong JOIN** - Kết hợp nhanh
3. **Tạo indexes cho columns trong ORDER BY** - Sắp xếp nhanh
4. **Sử dụng EXPLAIN** - Kiểm tra query plan
5. **Monitor indexes** - Xóa unused indexes

### ❌ DON'T

1. **Tạo quá nhiều indexes** - Chậm INSERT/UPDATE/DELETE
2. **Tạo indexes trên columns ít dùng** - Lãng phí không gian
3. **Tạo indexes trên columns có low cardinality** - Không hiệu quả
4. **Quên ANALYZE** - Outdated statistics
5. **Tạo duplicate indexes** - Lãng phí không gian

---

## 📊 Tóm Tắt Indexes & Performance

| Khái Niệm | Mô Tả |
|-----------|-------|
| **Index** | Cấu trúc tìm kiếm nhanh |
| **B-tree** | Index mặc định, phù hợp hầu hết |
| **Hash** | Chỉ cho equality |
| **GiST** | Cho spatial & full-text |
| **GIN** | Cho array & JSON |
| **EXPLAIN** | Hiển thị query plan |
| **EXPLAIN ANALYZE** | Thực thi & hiển thị statistics |
| **Performance** | Sử dụng indexes, tránh calculations |

---

## 🎓 Key Takeaways

1. **Indexes** - Tìm kiếm nhanh hơn
2. **B-tree** - Index mặc định & phổ biến
3. **EXPLAIN** - Kiểm tra query plan
4. **Performance** - Sử dụng indexes, tránh calculations
5. **Best Practices** - Tạo indexes cho WHERE, JOIN, ORDER BY

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL Indexes](https://www.postgresql.org/docs/current/indexes.html)
- [PostgreSQL EXPLAIN](https://www.postgresql.org/docs/current/sql-explain.html)
- [PostgreSQL Performance Tips](https://www.postgresql.org/docs/current/performance-tips.html)

---

**Bây giờ bạn đã hiểu Indexes & Performance! Hãy chuyển sang phần thực hành. 💪**

