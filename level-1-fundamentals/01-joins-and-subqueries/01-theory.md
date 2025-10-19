# 📚 JOINs & Subqueries - Lý Thuyết

Hiểu cách kết hợp dữ liệu từ nhiều tables và viết queries lồng nhau.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu các loại JOINs (INNER, LEFT, RIGHT, FULL, CROSS)
- ✅ Biết cách sử dụng JOINs để kết hợp dữ liệu
- ✅ Hiểu Subqueries (nested queries)
- ✅ Biết cách sử dụng Subqueries trong SELECT, WHERE, FROM
- ✅ Hiểu khi nào dùng JOINs vs Subqueries
- ✅ Viết được complex queries kết hợp JOINs & Subqueries

---

## 🔗 JOINs - Kết Hợp Dữ Liệu

### Định Nghĩa

**JOIN** là cách kết hợp rows từ 2 hoặc nhiều tables dựa trên điều kiện liên kết.

### Cú Pháp Cơ Bản

```sql
SELECT columns
FROM table1
JOIN table2 ON table1.column = table2.column;
```

---

## 1️⃣ INNER JOIN

### Định Nghĩa

**INNER JOIN** trả về rows từ cả 2 tables khi điều kiện khớp.

### Diagram

```
Table A          Table B
┌────┬────┐    ┌────┬────┐
│ id │ val│    │ id │ val│
├────┼────┤    ├────┼────┤
│ 1  │ A  │    │ 1  │ X  │
│ 2  │ B  │    │ 3  │ Y  │
│ 3  │ C  │    │ 4  │ Z  │
└────┴────┘    └────┴────┘

INNER JOIN Result:
┌────┬────┬────┬────┐
│ id │ val│ id │ val│
├────┼────┼────┼────┤
│ 1  │ A  │ 1  │ X  │
│ 3  │ C  │ 3  │ Y  │
└────┴────┴────┴────┘
```

### Ví Dụ

```sql
-- Lấy users với orders
SELECT u.id, u.name, o.id AS order_id, o.total_amount
FROM users u
INNER JOIN orders o ON u.id = o.user_id;

-- Hoặc (INNER là mặc định)
SELECT u.id, u.name, o.id AS order_id, o.total_amount
FROM users u
JOIN orders o ON u.id = o.user_id;
```

### Output

```
 id |    name    | order_id | total_amount
----+------------+----------+--------------
  1 | John Doe   |        1 |      1029.98
  1 | John Doe   |        3 |        19.99
  2 | Jane Smith |        2 |        39.99
```

---

## 2️⃣ LEFT JOIN (LEFT OUTER JOIN)

### Định Nghĩa

**LEFT JOIN** trả về tất cả rows từ table bên trái, và rows khớp từ table bên phải.

### Diagram

```
Table A          Table B
┌────┬────┐    ┌────┬────┐
│ id │ val│    │ id │ val│
├────┼────┤    ├────┼────┤
│ 1  │ A  │    │ 1  │ X  │
│ 2  │ B  │    │ 3  │ Y  │
│ 3  │ C  │    │ 4  │ Z  │
└────┴────┘    └────┴────┘

LEFT JOIN Result:
┌────┬────┬────┬────┐
│ id │ val│ id │ val│
├────┼────┼────┼────┤
│ 1  │ A  │ 1  │ X  │
│ 2  │ B  │NULL│NULL│
│ 3  │ C  │ 3  │ Y  │
└────┴────┴────┴────┘
```

### Ví Dụ

```sql
-- Lấy tất cả users, kể cả những không có orders
SELECT u.id, u.name, o.id AS order_id, o.total_amount
FROM users u
LEFT JOIN orders o ON u.id = o.user_id;
```

### Output

```
 id |    name    | order_id | total_amount
----+------------+----------+--------------
  1 | John Doe   |        1 |      1029.98
  1 | John Doe   |        3 |        19.99
  2 | Jane Smith |        2 |        39.99
  3 | Bob Johnson|     NULL |         NULL
```

---

## 3️⃣ RIGHT JOIN (RIGHT OUTER JOIN)

### Định Nghĩa

**RIGHT JOIN** trả về tất cả rows từ table bên phải, và rows khớp từ table bên trái.

### Diagram

```
LEFT JOIN vs RIGHT JOIN:

LEFT JOIN:  A ◄─── B
RIGHT JOIN: A ───► B
```

### Ví Dụ

```sql
-- Lấy tất cả orders, kể cả những không có users
SELECT u.id, u.name, o.id AS order_id, o.total_amount
FROM users u
RIGHT JOIN orders o ON u.id = o.user_id;
```

---

## 4️⃣ FULL OUTER JOIN

### Định Nghĩa

**FULL OUTER JOIN** trả về tất cả rows từ cả 2 tables.

### Diagram

```
Table A          Table B
┌────┬────┐    ┌────┬────┐
│ id │ val│    │ id │ val│
├────┼────┤    ├────┼────┤
│ 1  │ A  │    │ 1  │ X  │
│ 2  │ B  │    │ 3  │ Y  │
│ 3  │ C  │    │ 4  │ Z  │
└────┴────┘    └────┴────┘

FULL OUTER JOIN Result:
┌────┬────┬────┬────┐
│ id │ val│ id │ val│
├────┼────┼────┼────┤
│ 1  │ A  │ 1  │ X  │
│ 2  │ B  │NULL│NULL│
│ 3  │ C  │ 3  │ Y  │
│NULL│NULL│ 4  │ Z  │
└────┴────┴────┴────┘
```

### Ví Dụ

```sql
-- Lấy tất cả users & orders
SELECT u.id, u.name, o.id AS order_id, o.total_amount
FROM users u
FULL OUTER JOIN orders o ON u.id = o.user_id;
```

---

## 5️⃣ CROSS JOIN

### Định Nghĩa

**CROSS JOIN** trả về tích Descartes (mỗi row từ table A kết hợp với mỗi row từ table B).

### Ví Dụ

```sql
-- Lấy tất cả kết hợp users & products
SELECT u.name, p.name
FROM users u
CROSS JOIN products p;

-- Hoặc
SELECT u.name, p.name
FROM users u, products p;
```

### Output (3 users × 4 products = 12 rows)

```
    name    |     name
------------+---------------
 John Doe   | Laptop
 John Doe   | Mouse
 John Doe   | Python Book
 John Doe   | T-Shirt
 Jane Smith | Laptop
 ...
```

---

## 🔀 Multiple JOINs

### Ví Dụ: 3 Tables

```sql
-- Lấy order items với product & user info
SELECT 
    u.name AS user_name,
    o.id AS order_id,
    p.name AS product_name,
    oi.quantity,
    oi.unit_price
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id;
```

### Output

```
 user_name  | order_id | product_name | quantity | unit_price
------------+----------+--------------+----------+------------
 John Doe   |        1 | Laptop       |        1 |     999.99
 John Doe   |        1 | Mouse        |        1 |      29.99
 Jane Smith |        2 | Python Book  |        1 |      39.99
```

---

## 🔍 Subqueries - Queries Lồng Nhau

### Định Nghĩa

**Subquery** (hay nested query) là query bên trong query khác.

### Cú Pháp

```sql
SELECT columns
FROM table
WHERE column IN (SELECT column FROM table WHERE condition);
```

---

## 1️⃣ Subquery Trong WHERE

### Ví Dụ 1: IN Operator

```sql
-- Lấy users có orders
SELECT * FROM users
WHERE id IN (SELECT user_id FROM orders);
```

### Ví Dụ 2: Comparison Operator

```sql
-- Lấy products có giá cao hơn average
SELECT * FROM products
WHERE price > (SELECT AVG(price) FROM products);
```

### Ví Dụ 3: EXISTS Operator

```sql
-- Lấy users có ít nhất 1 order
SELECT * FROM users u
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.user_id = u.id);
```

---

## 2️⃣ Subquery Trong SELECT

### Ví Dụ

```sql
-- Lấy users với số lượng orders
SELECT 
    u.id,
    u.name,
    (SELECT COUNT(*) FROM orders WHERE user_id = u.id) AS order_count
FROM users u;
```

### Output

```
 id |    name    | order_count
----+------------+-------------
  1 | John Doe   |           2
  2 | Jane Smith |           1
  3 | Bob Johnson|           0
```

---

## 3️⃣ Subquery Trong FROM

### Ví Dụ

```sql
-- Lấy users với order count > 1
SELECT * FROM (
    SELECT 
        u.id,
        u.name,
        COUNT(o.id) AS order_count
    FROM users u
    LEFT JOIN orders o ON u.id = o.user_id
    GROUP BY u.id, u.name
) AS user_orders
WHERE order_count > 1;
```

---

## 🆚 JOINs vs Subqueries

### Khi Nào Dùng JOINs?

✅ Kết hợp dữ liệu từ nhiều tables  
✅ Hiệu suất tốt hơn (thường)  
✅ Dễ đọc & maintain  

### Khi Nào Dùng Subqueries?

✅ Lọc dữ liệu dựa trên điều kiện phức tạp  
✅ Tính toán giá trị từ table khác  
✅ Kiểm tra sự tồn tại (EXISTS)  

### Ví Dụ So Sánh

```sql
-- Cách 1: JOINs
SELECT u.id, u.name, COUNT(o.id) AS order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name
HAVING COUNT(o.id) > 1;

-- Cách 2: Subqueries
SELECT * FROM (
    SELECT u.id, u.name, COUNT(o.id) AS order_count
    FROM users u
    LEFT JOIN orders o ON u.id = o.user_id
    GROUP BY u.id, u.name
) AS user_orders
WHERE order_count > 1;

-- Cách 1 thường nhanh hơn!
```

---

## 📊 Tóm Tắt JOINs & Subqueries

| Loại | Mô Tả | Khi Dùng |
|------|-------|---------|
| **INNER JOIN** | Rows khớp từ cả 2 tables | Kết hợp dữ liệu liên quan |
| **LEFT JOIN** | Tất cả từ trái + khớp từ phải | Giữ tất cả từ table chính |
| **RIGHT JOIN** | Tất cả từ phải + khớp từ trái | Giữ tất cả từ table phụ |
| **FULL OUTER JOIN** | Tất cả từ cả 2 tables | Lấy tất cả dữ liệu |
| **CROSS JOIN** | Tích Descartes | Kết hợp tất cả |
| **Subquery WHERE** | Lọc dựa trên điều kiện | Kiểm tra IN, EXISTS |
| **Subquery SELECT** | Tính toán từ table khác | Lấy giá trị tính toán |
| **Subquery FROM** | Query từ kết quả query | Lọc kết quả phức tạp |

---

## 🎓 Key Takeaways

1. **INNER JOIN** - Rows khớp từ cả 2 tables
2. **LEFT/RIGHT/FULL JOIN** - Giữ rows từ một hoặc cả 2 tables
3. **CROSS JOIN** - Tích Descartes
4. **Multiple JOINs** - Kết hợp 3+ tables
5. **Subqueries** - Queries lồng nhau
6. **JOINs vs Subqueries** - JOINs thường nhanh hơn

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL JOINs](https://www.postgresql.org/docs/current/queries-table-expressions.html#QUERIES-JOIN)
- [PostgreSQL Subqueries](https://www.postgresql.org/docs/current/sql-syntax.html)

---

**Bây giờ bạn đã hiểu JOINs & Subqueries! Hãy chuyển sang phần thực hành. 💪**

