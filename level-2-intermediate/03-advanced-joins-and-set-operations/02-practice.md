# 🛠️ Advanced Joins & Set Operations - Thực Hành

Thực hành sử dụng advanced joins & set operations.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Sử dụng được Self Joins
- ✅ Sử dụng được Cross Joins
- ✅ Sử dụng được UNION & UNION ALL
- ✅ Sử dụng được INTERSECT
- ✅ Sử dụng được EXCEPT

---

## 📋 Bước 1: Chuẩn Bị Database

### Bước 1.1: Sử Dụng Database Từ Level 1

```sql
-- Kết nối
psql -U postgres -d ecommerce_practice

-- Kiểm tra tables
\dt
```

---

## 🔗 Bước 2: Thực Hành Self Joins

### Thực Hành 2.1: Find Duplicate Products

```sql
-- Tìm products có cùng name
SELECT 
  p1.id,
  p1.name,
  p2.id,
  p2.name
FROM products p1
JOIN products p2 ON p1.name = p2.name AND p1.id < p2.id;
```

### Thực Hành 2.2: Find Products with Same Price

```sql
-- Tìm products có cùng price
SELECT 
  p1.id,
  p1.name,
  p1.price,
  p2.id,
  p2.name,
  p2.price
FROM products p1
JOIN products p2 ON p1.price = p2.price AND p1.id < p2.id;
```

### Thực Hành 2.3: Find Users with Same City

```sql
-- Tìm users ở cùng city
SELECT 
  u1.id,
  u1.name,
  u1.city,
  u2.id,
  u2.name,
  u2.city
FROM users u1
JOIN users u2 ON u1.city = u2.city AND u1.id < u2.id
WHERE u1.city IS NOT NULL;
```

---

## ✖️ Bước 3: Thực Hành Cross Joins

### Thực Hành 3.1: Generate All Combinations

```sql
-- Tạo tất cả combinations của categories & users
SELECT 
  c.id AS category_id,
  c.name AS category,
  u.id AS user_id,
  u.name AS user
FROM categories c
CROSS JOIN users u
LIMIT 20;
```

### Thực Hành 3.2: Generate Date Range

```sql
-- Tạo tất cả combinations của dates & products
SELECT 
  d.date,
  p.id,
  p.name
FROM (
  SELECT CURRENT_DATE + i AS date
  FROM generate_series(0, 7) AS i
) d
CROSS JOIN products p
ORDER BY d.date, p.id;
```

---

## 🔀 Bước 4: Thực Hành UNION & UNION ALL

### Thực Hành 4.1: UNION - Remove Duplicates

```sql
-- Kết hợp users từ 2 queries, loại bỏ duplicates
SELECT name, email FROM users WHERE age > 25
UNION
SELECT name, email FROM users WHERE city = 'New York';
```

### Thực Hành 4.2: UNION ALL - Keep Duplicates

```sql
-- Kết hợp users từ 2 queries, giữ duplicates
SELECT name, email FROM users WHERE age > 25
UNION ALL
SELECT name, email FROM users WHERE city = 'New York';
```

### Thực Hành 4.3: UNION with ORDER BY

```sql
-- Kết hợp & sắp xếp
SELECT name, 'user' AS type FROM users
UNION
SELECT name, 'category' AS type FROM categories
ORDER BY name;
```

---

## ∩ Bước 5: Thực Hành INTERSECT

### Thực Hành 5.1: Find Common Products

```sql
-- Tìm products được order bởi user 1 & user 2
SELECT DISTINCT product_id FROM order_items
WHERE order_id IN (SELECT id FROM orders WHERE user_id = 1)
INTERSECT
SELECT DISTINCT product_id FROM order_items
WHERE order_id IN (SELECT id FROM orders WHERE user_id = 2);
```

### Thực Hành 5.2: Find Common Categories

```sql
-- Tìm categories có products & có orders
SELECT DISTINCT category_id FROM products
INTERSECT
SELECT DISTINCT p.category_id FROM products p
JOIN order_items oi ON p.id = oi.product_id;
```

---

## − Bước 6: Thực Hành EXCEPT

### Thực Hành 6.1: Find Products Not Ordered

```sql
-- Tìm products không được order
SELECT id FROM products
EXCEPT
SELECT DISTINCT product_id FROM order_items;
```

### Thực Hành 6.2: Find Inactive Users

```sql
-- Tìm users không có orders
SELECT id FROM users
EXCEPT
SELECT DISTINCT user_id FROM orders;
```

### Thực Hành 6.3: Find Categories Without Products

```sql
-- Tìm categories không có products
SELECT id FROM categories
EXCEPT
SELECT DISTINCT category_id FROM products;
```

---

## 🔄 Bước 7: Complex Set Operations

### Thực Hành 7.1: Multiple UNION

```sql
-- Kết hợp 3 queries
SELECT name, 'user' AS type FROM users
UNION
SELECT name, 'category' AS type FROM categories
UNION
SELECT name, 'product' AS type FROM products
ORDER BY type, name;
```

### Thực Hành 7.2: UNION with Aggregations

```sql
-- Kết hợp aggregations từ 2 tables
SELECT 'users' AS table_name, COUNT(*) AS count FROM users
UNION ALL
SELECT 'products' AS table_name, COUNT(*) AS count FROM products
UNION ALL
SELECT 'orders' AS table_name, COUNT(*) AS count FROM orders;
```

---

## ✅ Checklist Thực Hành

- [ ] Thực hành Self Joins
- [ ] Thực hành Cross Joins
- [ ] Thực hành UNION
- [ ] Thực hành UNION ALL
- [ ] Thực hành INTERSECT
- [ ] Thực hành EXCEPT
- [ ] Thực hành Complex Set Operations

---

## 💡 Tips

1. **Self Joins** - Sử dụng aliases để phân biệt
2. **Cross Joins** - Cẩn thận với kích thước result set
3. **UNION** - Loại bỏ duplicates (chậm hơn)
4. **UNION ALL** - Giữ duplicates (nhanh hơn)
5. **Set Operations** - Phải có cùng số columns & data types

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

