# 🛠️ Aggregate Functions & GROUP BY - Thực Hành

Thực hành viết queries sử dụng Aggregate Functions và GROUP BY.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Viết được queries sử dụng COUNT, SUM, AVG, MIN, MAX
- ✅ Viết được GROUP BY queries
- ✅ Viết được HAVING queries
- ✅ Kết hợp Aggregate Functions với JOINs

---

## 📋 Bước 1: Chuẩn Bị Database

### Bước 1.1: Sử Dụng Database Từ Module 1

```sql
-- Kết nối đến database từ Module 1
psql -U postgres -d ecommerce_practice

-- Kiểm tra tables
\dt
```

---

## 📊 Bước 2: Thực Hành COUNT()

### Thực Hành 2.1: COUNT(*)

```sql
-- Đếm tất cả orders
SELECT COUNT(*) AS total_orders FROM orders;
```

**Output:**
```
 total_orders
--------------
            5
```

### Thực Hành 2.2: COUNT() Với WHERE

```sql
-- Đếm completed orders
SELECT COUNT(*) AS completed_orders FROM orders WHERE status = 'completed';
```

**Output:**
```
 completed_orders
------------------
                3
```

### Thực Hành 2.3: COUNT(DISTINCT)

```sql
-- Đếm unique users có orders
SELECT COUNT(DISTINCT user_id) AS unique_users FROM orders;
```

**Output:**
```
 unique_users
--------------
            4
```

---

## 📊 Bước 3: Thực Hành SUM()

### Thực Hành 3.1: SUM() Cơ Bản

```sql
-- Tính tổng tiền từ tất cả orders
SELECT SUM(total_amount) AS total_revenue FROM orders;
```

**Output:**
```
 total_revenue
---------------
       2579.91
```

### Thực Hành 3.2: SUM() Với WHERE

```sql
-- Tính tổng tiền từ completed orders
SELECT SUM(total_amount) AS completed_revenue FROM orders WHERE status = 'completed';
```

**Output:**
```
 completed_revenue
-------------------
           1479.96
```

---

## 📊 Bước 4: Thực Hành AVG(), MIN(), MAX()

### Thực Hành 4.1: AVG()

```sql
-- Tính average order amount
SELECT AVG(total_amount) AS avg_order_amount FROM orders;
```

**Output:**
```
 avg_order_amount
------------------
 515.982
```

### Thực Hành 4.2: MIN() & MAX()

```sql
-- Tìm order amount nhỏ nhất & lớn nhất
SELECT 
    MIN(total_amount) AS min_order,
    MAX(total_amount) AS max_order,
    MAX(total_amount) - MIN(total_amount) AS range
FROM orders;
```

**Output:**
```
 min_order | max_order |  range
-----------+-----------+--------
     19.99 |   1379.97 | 1359.98
```

---

## 🔀 Bước 5: Thực Hành GROUP BY

### Thực Hành 5.1: GROUP BY Một Column

```sql
-- Đếm số orders của mỗi user
SELECT 
    user_id,
    COUNT(*) AS order_count
FROM orders
GROUP BY user_id
ORDER BY order_count DESC;
```

**Output:**
```
 user_id | order_count
---------+-------------
       1 |           2
       2 |           1
       3 |           1
       4 |           1
```

### Thực Hành 5.2: GROUP BY Nhiều Columns

```sql
-- Đếm orders theo user & status
SELECT 
    user_id,
    status,
    COUNT(*) AS order_count
FROM orders
GROUP BY user_id, status
ORDER BY user_id, status;
```

**Output:**
```
 user_id | status    | order_count
---------+-----------+-------------
       1 | completed |           2
       2 | pending   |           1
       3 | completed |           1
       4 | pending   |           1
```

---

## 🔍 Bước 6: Thực Hành HAVING

### Thực Hành 6.1: HAVING Cơ Bản

```sql
-- Lấy users có > 1 order
SELECT 
    user_id,
    COUNT(*) AS order_count
FROM orders
GROUP BY user_id
HAVING COUNT(*) > 1;
```

**Output:**
```
 user_id | order_count
---------+-------------
       1 |           2
```

### Thực Hành 6.2: HAVING Với Aggregate

```sql
-- Lấy categories có > 2 products
SELECT 
    category_id,
    COUNT(*) AS product_count
FROM products
GROUP BY category_id
HAVING COUNT(*) > 2;
```

**Output:**
```
 category_id | product_count
-------------+---------------
           1 |             4
```

---

## 🔗 Bước 7: Aggregate Functions Với JOINs

### Thực Hành 7.1: COUNT Với JOIN

```sql
-- Đếm số products trong mỗi category
SELECT 
    c.name,
    COUNT(p.id) AS product_count
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
GROUP BY c.id, c.name
ORDER BY product_count DESC;
```

**Output:**
```
    name    | product_count
------------+---------------
 Electronics|             4
 Books      |             1
 Clothing   |             1
```

### Thực Hành 7.2: SUM Với Multiple JOINs

```sql
-- Tính tổng revenue của mỗi category
SELECT 
    c.name,
    COUNT(DISTINCT oi.order_id) AS orders,
    SUM(oi.quantity) AS total_quantity,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM categories c
JOIN products p ON c.id = p.category_id
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY c.id, c.name
ORDER BY total_revenue DESC NULLS LAST;
```

**Output:**
```
    name    | orders | total_quantity | total_revenue
------------+--------+----------------+---------------
 Electronics|      4 |             10 |       2409.94
 Books      |      2 |              2 |         79.98
 Clothing   |      1 |              1 |         19.99
```

---

## 📊 Bước 8: Multiple Aggregates

### Thực Hành 8.1: Multiple Aggregates Untuk Users

```sql
-- Lấy thống kê cho mỗi user
SELECT 
    u.name,
    COUNT(o.id) AS order_count,
    SUM(o.total_amount) AS total_spent,
    AVG(o.total_amount) AS avg_order_value,
    MIN(o.total_amount) AS min_order,
    MAX(o.total_amount) AS max_order
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name
ORDER BY total_spent DESC NULLS LAST;
```

**Output:**
```
    name    | order_count | total_spent | avg_order_value | min_order | max_order
------------+-------------+-------------+-----------------+-----------+-----------
 Bob Johnson|           1 |     1379.97 |        1379.97  |   1379.97 |   1379.97
 John Doe   |           2 |     1049.97 |         524.985 |     19.99 |   1029.98
 Jane Smith |           1 |       39.99 |          39.99  |     39.99 |     39.99
 Alice Brown|           1 |      109.98 |         109.98  |    109.98 |    109.98
```

---

## 📊 Bước 9: Complex Aggregation

### Thực Hành 9.1: Top Products

```sql
-- Lấy top 5 products theo revenue
SELECT 
    p.name,
    c.name AS category,
    COUNT(DISTINCT oi.order_id) AS times_ordered,
    SUM(oi.quantity) AS total_quantity,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
JOIN categories c ON p.category_id = c.id
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.name, c.id, c.name
ORDER BY total_revenue DESC NULLS LAST
LIMIT 5;
```

---

## ✅ Checklist Thực Hành

- [ ] Thực hành COUNT()
- [ ] Thực hành SUM()
- [ ] Thực hành AVG(), MIN(), MAX()
- [ ] Thực hành GROUP BY một column
- [ ] Thực hành GROUP BY nhiều columns
- [ ] Thực hành HAVING
- [ ] Thực hành Aggregate Functions với JOINs
- [ ] Thực hành Multiple Aggregates
- [ ] Thực hành Complex Aggregation

---

## 💡 Tips

1. **Luôn GROUP BY** - Khi sử dụng aggregate functions, phải GROUP BY tất cả non-aggregate columns
2. **NULLS LAST** - Sử dụng để đặt NULL values ở cuối
3. **DISTINCT** - Sử dụng để tránh đếm duplicates
4. **ORDER BY** - Sắp xếp kết quả để dễ đọc

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

