# 📚 Query Optimization & EXPLAIN - Lý Thuyết

Hiểu cách tối ưu hóa queries & phân tích query plans.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu EXPLAIN & EXPLAIN ANALYZE
- ✅ Biết cách đọc query plans
- ✅ Hiểu các loại scans
- ✅ Sử dụng được indexes hiệu quả
- ✅ Tối ưu hóa slow queries
- ✅ Hiểu query optimization best practices

---

## 🔍 EXPLAIN & EXPLAIN ANALYZE

### EXPLAIN

**Định nghĩa:** Hiển thị query plan mà PostgreSQL sẽ sử dụng.

**Cú Pháp:**
```sql
EXPLAIN SELECT * FROM products WHERE price > 100;
```

**Output:**
```
Seq Scan on products  (cost=0.00..35.50 rows=100 width=32)
  Filter: (price > 100)
```

### EXPLAIN ANALYZE

**Định nghĩa:** Thực thi query & hiển thị actual execution stats.

**Cú Pháp:**
```sql
EXPLAIN ANALYZE SELECT * FROM products WHERE price > 100;
```

**Output:**
```
Seq Scan on products  (cost=0.00..35.50 rows=100 width=32) (actual time=0.123..0.456 rows=100 loops=1)
  Filter: (price > 100)
```

---

## 📊 Query Plan Components

### Cost

**Định nghĩa:** Ước tính chi phí thực thi query.

```
cost=0.00..35.50
  - 0.00: Startup cost
  - 35.50: Total cost
```

### Rows

**Định nghĩa:** Ước tính số rows được trả về.

```
rows=100
```

### Width

**Định nghĩa:** Ước tính kích thước mỗi row (bytes).

```
width=32
```

### Actual Time

**Định nghĩa:** Thời gian thực tế (milliseconds).

```
actual time=0.123..0.456
  - 0.123: Startup time
  - 0.456: Total time
```

---

## 🔎 Loại Scans

### Seq Scan (Sequential Scan)

**Định nghĩa:** Quét toàn bộ table.

**Khi Dùng:**
- Không có index
- Index không hiệu quả
- Query trả về nhiều rows

**Ví Dụ:**
```sql
EXPLAIN SELECT * FROM products WHERE price > 100;
-- Seq Scan on products
```

### Index Scan

**Định nghĩa:** Sử dụng index để tìm rows.

**Khi Dùng:**
- Có index trên column
- Query trả về ít rows

**Ví Dụ:**
```sql
EXPLAIN SELECT * FROM products WHERE id = 1;
-- Index Scan using idx_products_id on products
```

### Bitmap Index Scan

**Định nghĩa:** Sử dụng bitmap để kết hợp multiple indexes.

**Khi Dùng:**
- Multiple conditions
- Multiple indexes

**Ví Dụ:**
```sql
EXPLAIN SELECT * FROM products WHERE price > 100 AND category = 'Electronics';
-- Bitmap Index Scan
```

### Index Only Scan

**Định nghĩa:** Tất cả data từ index, không cần table access.

**Khi Dùng:**
- Tất cả columns trong index
- Index covering

**Ví Dụ:**
```sql
EXPLAIN SELECT id, price FROM products WHERE price > 100;
-- Index Only Scan using idx_products_price
```

---

## 🔗 Join Types

### Nested Loop Join

**Định nghĩa:** Lặp qua outer table, tìm matches trong inner table.

**Khi Dùng:**
- Small inner table
- Có index trên join column

### Hash Join

**Định nghĩa:** Tạo hash table từ inner table, probe với outer table.

**Khi Dùng:**
- Large tables
- Không có index

### Merge Join

**Định nghĩa:** Merge 2 sorted tables.

**Khi Dùng:**
- Cả 2 tables sorted
- Có index trên join columns

---

## 🎯 Query Optimization Tips

### 1. Sử dụng Indexes

```sql
-- Tạo index trên frequently queried columns
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_orders_user_id ON orders(user_id);
```

### 2. Tránh Full Table Scans

```sql
-- ❌ BAD: Full table scan
SELECT * FROM products WHERE price > 100;

-- ✅ GOOD: Sử dụng index
CREATE INDEX idx_products_price ON products(price);
SELECT * FROM products WHERE price > 100;
```

### 3. Sử dụng LIMIT

```sql
-- ✅ GOOD: Limit results
SELECT * FROM products LIMIT 10;
```

### 4. Tránh SELECT *

```sql
-- ❌ BAD: Select all columns
SELECT * FROM products;

-- ✅ GOOD: Select specific columns
SELECT id, name, price FROM products;
```

### 5. Sử dụng Covering Indexes

```sql
-- Tạo covering index
CREATE INDEX idx_products_covering ON products(price) INCLUDE (name, category);

-- Query sử dụng index only scan
SELECT name, price FROM products WHERE price > 100;
```

---

## 📊 Tóm Tắt Query Optimization

| Khái Niệm | Mô Tả | Khi Dùng |
|-----------|-------|---------|
| **EXPLAIN** | Query plan | Analyze |
| **EXPLAIN ANALYZE** | Actual execution | Debug |
| **Seq Scan** | Full table scan | Fallback |
| **Index Scan** | Index lookup | Selective |
| **Bitmap Scan** | Multiple indexes | Complex |
| **Index Only Scan** | Covering index | Efficient |
| **Nested Loop** | Loop join | Small tables |
| **Hash Join** | Hash join | Large tables |
| **Merge Join** | Sorted join | Sorted data |

---

## 🎓 Key Takeaways

1. **EXPLAIN** - Hiển thị query plan
2. **EXPLAIN ANALYZE** - Thực thi & hiển thị stats
3. **Cost** - Ước tính chi phí
4. **Rows** - Ước tính số rows
5. **Scans** - Seq, Index, Bitmap, Index Only
6. **Joins** - Nested Loop, Hash, Merge
7. **Optimization** - Indexes, LIMIT, Covering

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL EXPLAIN](https://www.postgresql.org/docs/current/sql-explain.html)
- [PostgreSQL Query Performance](https://www.postgresql.org/docs/current/performance-tips.html)
- [PostgreSQL Indexes](https://www.postgresql.org/docs/current/indexes.html)

---

**Bây giờ bạn đã hiểu Query Optimization & EXPLAIN! Hãy chuyển sang phần thực hành. 💪**

