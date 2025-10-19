# 📚 Aggregate Functions & GROUP BY - Lý Thuyết

Hiểu cách tính toán dữ liệu và nhóm kết quả.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu các Aggregate Functions (COUNT, SUM, AVG, MIN, MAX)
- ✅ Biết cách sử dụng GROUP BY
- ✅ Hiểu HAVING clause
- ✅ Biết cách kết hợp Aggregate Functions với JOINs
- ✅ Viết được complex aggregation queries

---

## 📊 Aggregate Functions

### Định Nghĩa

**Aggregate Functions** là các hàm tính toán trên tập hợp rows và trả về một giá trị duy nhất.

### Các Aggregate Functions Chính

| Hàm | Mô Tả | Ví Dụ |
|-----|-------|-------|
| **COUNT()** | Đếm số rows | COUNT(*), COUNT(id) |
| **SUM()** | Tính tổng | SUM(price) |
| **AVG()** | Tính trung bình | AVG(price) |
| **MIN()** | Tìm giá trị nhỏ nhất | MIN(price) |
| **MAX()** | Tìm giá trị lớn nhất | MAX(price) |

---

## 1️⃣ COUNT()

### Định Nghĩa

**COUNT()** đếm số rows hoặc số non-NULL values.

### Cú Pháp

```sql
COUNT(*)           -- Đếm tất cả rows
COUNT(column)      -- Đếm non-NULL values
COUNT(DISTINCT column)  -- Đếm unique values
```

### Ví Dụ

```sql
-- Đếm tất cả orders
SELECT COUNT(*) FROM orders;

-- Đếm orders có status = 'completed'
SELECT COUNT(*) FROM orders WHERE status = 'completed';

-- Đếm unique users có orders
SELECT COUNT(DISTINCT user_id) FROM orders;
```

### Output

```
 count
-------
     5

 count
-------
     2

 count
-------
     4
```

---

## 2️⃣ SUM()

### Định Nghĩa

**SUM()** tính tổng giá trị của một column.

### Cú Pháp

```sql
SUM(column)
```

### Ví Dụ

```sql
-- Tính tổng tiền từ tất cả orders
SELECT SUM(total_amount) FROM orders;

-- Tính tổng tiền từ orders của user 1
SELECT SUM(total_amount) FROM orders WHERE user_id = 1;
```

### Output

```
    sum
-----------
 2579.91

    sum
-----------
 1049.97
```

---

## 3️⃣ AVG()

### Định Nghĩa

**AVG()** tính trung bình giá trị của một column.

### Cú Pháp

```sql
AVG(column)
```

### Ví Dụ

```sql
-- Tính average price của products
SELECT AVG(price) FROM products;

-- Tính average order amount
SELECT AVG(total_amount) FROM orders;
```

### Output

```
        avg
--------------------
 308.3233333333333

        avg
--------------------
 515.982
```

---

## 4️⃣ MIN() & MAX()

### Định Nghĩa

**MIN()** tìm giá trị nhỏ nhất, **MAX()** tìm giá trị lớn nhất.

### Cú Pháp

```sql
MIN(column)
MAX(column)
```

### Ví Dụ

```sql
-- Tìm product có giá thấp nhất & cao nhất
SELECT MIN(price) AS min_price, MAX(price) AS max_price FROM products;

-- Tìm order có amount thấp nhất & cao nhất
SELECT MIN(total_amount) AS min_order, MAX(total_amount) AS max_order FROM orders;
```

### Output

```
 min_price | max_price
-----------+-----------
     19.99 |    999.99

 min_order | max_order
-----------+-----------
     19.99 |   1379.97
```

---

## 🔀 GROUP BY

### Định Nghĩa

**GROUP BY** nhóm rows dựa trên một hoặc nhiều columns, thường kết hợp với Aggregate Functions.

### Cú Pháp

```sql
SELECT column1, COUNT(*)
FROM table
GROUP BY column1;
```

### Ví Dụ 1: GROUP BY Một Column

```sql
-- Đếm số orders của mỗi user
SELECT user_id, COUNT(*) AS order_count
FROM orders
GROUP BY user_id;
```

### Output

```
 user_id | order_count
---------+-------------
       1 |           2
       2 |           1
       3 |           1
       4 |           1
```

### Ví Dụ 2: GROUP BY Nhiều Columns

```sql
-- Đếm số orders theo user & status
SELECT user_id, status, COUNT(*) AS order_count
FROM orders
GROUP BY user_id, status;
```

### Output

```
 user_id | status    | order_count
---------+-----------+-------------
       1 | completed |           2
       2 | pending   |           1
       3 | completed |           1
       4 | pending   |           1
```

---

## 🔍 HAVING

### Định Nghĩa

**HAVING** lọc kết quả GROUP BY (giống WHERE nhưng cho aggregate results).

### Cú Pháp

```sql
SELECT column, COUNT(*)
FROM table
GROUP BY column
HAVING COUNT(*) > 1;
```

### Ví Dụ

```sql
-- Lấy users có > 1 order
SELECT user_id, COUNT(*) AS order_count
FROM orders
GROUP BY user_id
HAVING COUNT(*) > 1;
```

### Output

```
 user_id | order_count
---------+-------------
       1 |           2
```

---

## 🆚 WHERE vs HAVING

### Khác Nhau

| Aspect | WHERE | HAVING |
|--------|-------|--------|
| **Khi dùng** | Lọc rows trước GROUP BY | Lọc groups sau GROUP BY |
| **Với Aggregate** | ❌ Không | ✅ Có |
| **Ví dụ** | WHERE price > 100 | HAVING COUNT(*) > 5 |

### Ví Dụ So Sánh

```sql
-- WHERE: Lọc trước GROUP BY
SELECT category_id, COUNT(*) AS product_count
FROM products
WHERE price > 50
GROUP BY category_id;

-- HAVING: Lọc sau GROUP BY
SELECT category_id, COUNT(*) AS product_count
FROM products
GROUP BY category_id
HAVING COUNT(*) > 2;

-- Cả 2: Lọc trước & sau GROUP BY
SELECT category_id, COUNT(*) AS product_count
FROM products
WHERE price > 50
GROUP BY category_id
HAVING COUNT(*) > 1;
```

---

## 🔗 Aggregate Functions Với JOINs

### Ví Dụ 1: COUNT Với JOIN

```sql
-- Đếm số products trong mỗi category
SELECT c.name, COUNT(p.id) AS product_count
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
GROUP BY c.id, c.name;
```

### Ví Dụ 2: SUM Với JOIN

```sql
-- Tính tổng revenue của mỗi category
SELECT 
    c.name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM categories c
JOIN products p ON c.id = p.category_id
JOIN order_items oi ON p.id = oi.product_id
GROUP BY c.id, c.name;
```

### Ví Dụ 3: Multiple Aggregates

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
GROUP BY u.id, u.name;
```

---

## 📊 ORDER BY Với GROUP BY

### Ví Dụ

```sql
-- Lấy top 3 users theo tổng chi tiêu
SELECT 
    u.name,
    COUNT(o.id) AS order_count,
    SUM(o.total_amount) AS total_spent
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name
ORDER BY total_spent DESC NULLS LAST
LIMIT 3;
```

---

## 🔢 DISTINCT vs GROUP BY

### Khác Nhau

```sql
-- DISTINCT: Lấy unique values
SELECT DISTINCT category_id FROM products;

-- GROUP BY: Nhóm & có thể aggregate
SELECT category_id, COUNT(*) FROM products GROUP BY category_id;
```

---

## 📊 Tóm Tắt Aggregate Functions & GROUP BY

| Khái Niệm | Mô Tả |
|-----------|-------|
| **COUNT()** | Đếm rows |
| **SUM()** | Tính tổng |
| **AVG()** | Tính trung bình |
| **MIN()** | Tìm giá trị nhỏ nhất |
| **MAX()** | Tìm giá trị lớn nhất |
| **GROUP BY** | Nhóm rows |
| **HAVING** | Lọc groups |
| **WHERE vs HAVING** | WHERE trước, HAVING sau GROUP BY |

---

## 🎓 Key Takeaways

1. **Aggregate Functions** - COUNT, SUM, AVG, MIN, MAX
2. **GROUP BY** - Nhóm rows dựa trên columns
3. **HAVING** - Lọc groups (sau GROUP BY)
4. **WHERE vs HAVING** - WHERE trước, HAVING sau
5. **Kết hợp** - Aggregate Functions + JOINs + GROUP BY

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL Aggregate Functions](https://www.postgresql.org/docs/current/functions-aggregate.html)
- [PostgreSQL GROUP BY](https://www.postgresql.org/docs/current/sql-select.html#SQL-GROUPBY)

---

**Bây giờ bạn đã hiểu Aggregate Functions & GROUP BY! Hãy chuyển sang phần thực hành. 💪**

