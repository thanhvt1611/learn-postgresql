# 🛠️ JOINs & Subqueries - Thực Hành

Thực hành viết queries sử dụng JOINs và Subqueries.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Viết được INNER JOINs
- ✅ Viết được LEFT/RIGHT/FULL JOINs
- ✅ Viết được Multiple JOINs
- ✅ Viết được Subqueries
- ✅ Kết hợp JOINs & Subqueries

---

## 📋 Bước 1: Chuẩn Bị Database

### Bước 1.1: Kết Nối & Tạo Database

```sql
-- Kết nối
psql -U postgres

-- Tạo database
CREATE DATABASE ecommerce_practice;

-- Kết nối đến database
\c ecommerce_practice
```

### Bước 1.2: Tạo Tables

```sql
-- Tạo table categories
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- Tạo table products
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category_id INTEGER NOT NULL REFERENCES categories(id),
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    stock INTEGER NOT NULL CHECK (stock >= 0)
);

-- Tạo table users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    age INTEGER CHECK (age >= 18)
);

-- Tạo table orders
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount > 0),
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tạo table order_items
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(id),
    product_id INTEGER NOT NULL REFERENCES products(id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price > 0)
);
```

### Bước 1.3: Thêm Sample Data

```sql
-- Thêm categories
INSERT INTO categories (name) VALUES ('Electronics'), ('Books'), ('Clothing');

-- Thêm products
INSERT INTO products (name, category_id, price, stock) VALUES
('Laptop', 1, 999.99, 10),
('Mouse', 1, 29.99, 50),
('Python Book', 2, 39.99, 20),
('T-Shirt', 3, 19.99, 100),
('Monitor', 1, 299.99, 15),
('Keyboard', 1, 79.99, 30);

-- Thêm users
INSERT INTO users (name, email, age) VALUES
('John Doe', 'john@example.com', 28),
('Jane Smith', 'jane@example.com', 32),
('Bob Johnson', 'bob@example.com', 25),
('Alice Brown', 'alice@example.com', 30);

-- Thêm orders
INSERT INTO orders (user_id, total_amount, status) VALUES
(1, 1029.98, 'completed'),
(2, 39.99, 'pending'),
(1, 19.99, 'completed'),
(3, 1379.97, 'completed'),
(4, 109.98, 'pending');

-- Thêm order_items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 999.99),  -- Order 1: 1 Laptop
(1, 2, 1, 29.99),   -- Order 1: 1 Mouse
(2, 3, 1, 39.99),   -- Order 2: 1 Python Book
(3, 4, 1, 19.99),   -- Order 3: 1 T-Shirt
(4, 1, 1, 999.99),  -- Order 4: 1 Laptop
(4, 5, 1, 299.99),  -- Order 4: 1 Monitor
(4, 6, 1, 79.99),   -- Order 4: 1 Keyboard
(5, 2, 2, 29.99),   -- Order 5: 2 Mouse
(5, 3, 1, 39.99);   -- Order 5: 1 Python Book
```

---

## 🔗 Bước 2: Thực Hành INNER JOINs

### Thực Hành 2.1: Basic INNER JOIN

```sql
-- Lấy users với orders
SELECT u.id, u.name, o.id AS order_id, o.total_amount
FROM users u
INNER JOIN orders o ON u.id = o.user_id;
```

**Output:**
```
 id |    name    | order_id | total_amount
----+------------+----------+--------------
  1 | John Doe   |        1 |      1029.98
  1 | John Doe   |        3 |        19.99
  2 | Jane Smith |        2 |        39.99
  3 | Bob Johnson|        4 |      1379.97
  4 | Alice Brown|        5 |       109.98
```

### Thực Hành 2.2: Multiple INNER JOINs

```sql
-- Lấy order items với product & category info
SELECT 
    o.id AS order_id,
    p.name AS product_name,
    c.name AS category,
    oi.quantity,
    oi.unit_price
FROM orders o
INNER JOIN order_items oi ON o.id = oi.order_id
INNER JOIN products p ON oi.product_id = p.id
INNER JOIN categories c ON p.category_id = c.id;
```

**Output:**
```
 order_id | product_name | category  | quantity | unit_price
----------+--------------+-----------+----------+------------
        1 | Laptop       | Electronics|        1 |     999.99
        1 | Mouse        | Electronics|        1 |      29.99
        2 | Python Book  | Books     |        1 |      39.99
        3 | T-Shirt      | Clothing  |        1 |      19.99
        4 | Laptop       | Electronics|        1 |     999.99
        4 | Monitor      | Electronics|        1 |     299.99
        4 | Keyboard     | Electronics|        1 |      79.99
        5 | Mouse        | Electronics|        2 |      29.99
        5 | Python Book  | Books     |        1 |      39.99
```

---

## 🔀 Bước 3: Thực Hành LEFT JOINs

### Thực Hành 3.1: Basic LEFT JOIN

```sql
-- Lấy tất cả users, kể cả những không có orders
SELECT u.id, u.name, COUNT(o.id) AS order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;
```

**Output:**
```
 id |    name    | order_count
----+------------+-------------
  1 | John Doe   |           2
  2 | Jane Smith |           1
  3 | Bob Johnson|           1
  4 | Alice Brown|           1
```

### Thực Hành 3.2: LEFT JOIN Với WHERE

```sql
-- Lấy users không có orders
SELECT u.id, u.name
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE o.id IS NULL;
```

---

## 🔍 Bước 4: Thực Hành Subqueries

### Thực Hành 4.1: Subquery Trong WHERE

```sql
-- Lấy products có giá cao hơn average
SELECT id, name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);
```

**Output:**
```
 id |    name    |  price
----+------------+--------
  1 | Laptop     | 999.99
  5 | Monitor    | 299.99
```

### Thực Hành 4.2: Subquery Với IN

```sql
-- Lấy users có orders
SELECT id, name, email
FROM users
WHERE id IN (SELECT DISTINCT user_id FROM orders);
```

### Thực Hành 4.3: Subquery Với EXISTS

```sql
-- Lấy categories có products
SELECT id, name
FROM categories c
WHERE EXISTS (SELECT 1 FROM products p WHERE p.category_id = c.id);
```

---

## 🔀 Bước 5: Thực Hành Subqueries Trong SELECT

### Thực Hành 5.1: Scalar Subquery

```sql
-- Lấy users với số lượng orders
SELECT 
    u.id,
    u.name,
    (SELECT COUNT(*) FROM orders WHERE user_id = u.id) AS order_count,
    (SELECT SUM(total_amount) FROM orders WHERE user_id = u.id) AS total_spent
FROM users u;
```

**Output:**
```
 id |    name    | order_count | total_spent
----+------------+-------------+-------------
  1 | John Doe   |           2 |     1049.97
  2 | Jane Smith |           1 |       39.99
  3 | Bob Johnson|           1 |     1379.97
  4 | Alice Brown|           1 |      109.98
```

---

## 🔀 Bước 6: Thực Hành Subqueries Trong FROM

### Thực Hành 6.1: Derived Table

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

**Output:**
```
 id |  name   | order_count
----+---------+-------------
  1 | John Doe|           2
```

---

## 🔀 Bước 7: Thực Hành Complex Queries

### Thực Hành 7.1: JOINs + Subqueries

```sql
-- Lấy products được order nhiều nhất
SELECT 
    p.id,
    p.name,
    (SELECT COUNT(*) FROM order_items WHERE product_id = p.id) AS order_count,
    (SELECT SUM(quantity) FROM order_items WHERE product_id = p.id) AS total_quantity
FROM products p
WHERE p.id IN (SELECT product_id FROM order_items)
ORDER BY total_quantity DESC;
```

### Thực Hành 7.2: Multiple Subqueries

```sql
-- Lấy orders có total_amount cao hơn average
SELECT 
    u.name,
    o.id AS order_id,
    o.total_amount,
    (SELECT AVG(total_amount) FROM orders) AS avg_order_amount
FROM orders o
JOIN users u ON o.user_id = u.id
WHERE o.total_amount > (SELECT AVG(total_amount) FROM orders);
```

---

## ✅ Checklist Thực Hành

- [ ] Tạo database & tables
- [ ] Thêm sample data
- [ ] Thực hành INNER JOINs
- [ ] Thực hành Multiple JOINs
- [ ] Thực hành LEFT JOINs
- [ ] Thực hành Subqueries trong WHERE
- [ ] Thực hành Subqueries trong SELECT
- [ ] Thực hành Subqueries trong FROM
- [ ] Thực hành Complex Queries
- [ ] Hiểu khi nào dùng JOINs vs Subqueries

---

## 💡 Tips

1. **Alias** - Sử dụng alias để code dễ đọc hơn
2. **Indentation** - Format code để dễ đọc
3. **Test từng phần** - Viết subquery riêng trước
4. **EXPLAIN** - Sử dụng EXPLAIN để xem query plan

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

