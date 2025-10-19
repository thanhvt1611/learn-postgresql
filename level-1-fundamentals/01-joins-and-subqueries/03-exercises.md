# 💪 JOINs & Subqueries - Bài Tập

Thực hành viết complex queries sử dụng JOINs và Subqueries.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có database "ecommerce_practice" với sample data

---

## 🎯 Bài Tập 1: INNER JOIN (Dễ)

### Yêu Cầu
Viết query để lấy tất cả orders với user name và total amount.

### Gợi Ý
- Sử dụng INNER JOIN
- Kết hợp users & orders tables

### Solution
```sql
SELECT 
    o.id AS order_id,
    u.name AS user_name,
    o.total_amount,
    o.status
FROM orders o
INNER JOIN users u ON o.user_id = u.id;
```

---

## 🎯 Bài Tập 2: Multiple JOINs (Trung Bình)

### Yêu Cầu
Viết query để lấy tất cả order items với:
- User name
- Product name
- Category name
- Quantity & unit price

### Gợi Ý
- Sử dụng 4 JOINs (orders, users, order_items, products, categories)
- Sắp xếp theo order_id

### Solution
```sql
SELECT 
    u.name AS user_name,
    o.id AS order_id,
    c.name AS category,
    p.name AS product_name,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS line_total
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
JOIN categories c ON p.category_id = c.id
ORDER BY o.id, oi.id;
```

---

## 🎯 Bài Tập 3: LEFT JOIN (Trung Bình)

### Yêu Cầu
Viết query để lấy tất cả categories với số lượng products.

### Gợi Ý
- Sử dụng LEFT JOIN
- Sử dụng COUNT() & GROUP BY
- Bao gồm categories không có products

### Solution
```sql
SELECT 
    c.id,
    c.name,
    COUNT(p.id) AS product_count
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
GROUP BY c.id, c.name
ORDER BY product_count DESC;
```

---

## 🎯 Bài Tập 4: Subquery Trong WHERE (Trung Bình)

### Yêu Cầu
Viết query để lấy products có giá cao hơn average price.

### Gợi Ý
- Sử dụng Subquery trong WHERE
- Sử dụng AVG()

### Solution
```sql
SELECT 
    id,
    name,
    price,
    (SELECT AVG(price) FROM products) AS avg_price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price DESC;
```

---

## 🎯 Bài Tập 5: Subquery Với IN (Trung Bình)

### Yêu Cầu
Viết query để lấy users có ít nhất 1 order.

### Gợi Ý
- Sử dụng Subquery với IN
- Lấy DISTINCT user_id từ orders

### Solution
```sql
SELECT 
    id,
    name,
    email
FROM users
WHERE id IN (SELECT DISTINCT user_id FROM orders)
ORDER BY name;
```

---

## 🎯 Bài Tập 6: Subquery Với EXISTS (Nâng Cao)

### Yêu Cầu
Viết query để lấy categories có products.

### Gợi Ý
- Sử dụng EXISTS
- Kiểm tra sự tồn tại của products

### Solution
```sql
SELECT 
    id,
    name
FROM categories c
WHERE EXISTS (SELECT 1 FROM products p WHERE p.category_id = c.id)
ORDER BY name;
```

---

## 🎯 Bài Tập 7: Subquery Trong SELECT (Nâng Cao)

### Yêu Cầu
Viết query để lấy users với:
- Số lượng orders
- Tổng tiền đã chi tiêu
- Average order value

### Gợi Ý
- Sử dụng Subqueries trong SELECT
- Sử dụng COUNT(), SUM(), AVG()

### Solution
```sql
SELECT 
    u.id,
    u.name,
    (SELECT COUNT(*) FROM orders WHERE user_id = u.id) AS order_count,
    (SELECT SUM(total_amount) FROM orders WHERE user_id = u.id) AS total_spent,
    (SELECT AVG(total_amount) FROM orders WHERE user_id = u.id) AS avg_order_value
FROM users u
ORDER BY total_spent DESC NULLS LAST;
```

---

## 🎯 Bài Tập 8: Subquery Trong FROM (Nâng Cao)

### Yêu Cầu
Viết query để lấy users có tổng chi tiêu > 500.

### Gợi Ý
- Sử dụng Subquery trong FROM
- Tính tổng chi tiêu trong subquery
- Lọc trong WHERE

### Solution
```sql
SELECT * FROM (
    SELECT 
        u.id,
        u.name,
        COUNT(o.id) AS order_count,
        SUM(o.total_amount) AS total_spent
    FROM users u
    LEFT JOIN orders o ON u.id = o.user_id
    GROUP BY u.id, u.name
) AS user_stats
WHERE total_spent > 500
ORDER BY total_spent DESC;
```

---

## 🎯 Bài Tập 9: Complex Query (Nâng Cao)

### Yêu Cầu
Viết query để lấy products được order nhiều nhất với:
- Product name & category
- Số lần được order
- Tổng quantity đã bán
- Tổng revenue

### Gợi Ý
- Sử dụng Multiple JOINs
- Sử dụng COUNT(), SUM()
- Sắp xếp theo total_revenue DESC

### Solution
```sql
SELECT 
    p.id,
    p.name,
    c.name AS category,
    COUNT(DISTINCT oi.order_id) AS times_ordered,
    SUM(oi.quantity) AS total_quantity,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
JOIN categories c ON p.category_id = c.id
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.name, c.name
ORDER BY total_revenue DESC NULLS LAST;
```

---

## 🎯 Bài Tập 10: JOINs + Subqueries (Nâng Cao)

### Yêu Cầu
Viết query để lấy orders có total_amount cao hơn average, với:
- User name
- Order ID & total amount
- Average order amount
- Difference từ average

### Gợi Ý
- Sử dụng JOINs & Subqueries
- Tính difference: total_amount - avg_amount

### Solution
```sql
SELECT 
    u.name,
    o.id AS order_id,
    o.total_amount,
    (SELECT AVG(total_amount) FROM orders) AS avg_order_amount,
    o.total_amount - (SELECT AVG(total_amount) FROM orders) AS difference
FROM orders o
JOIN users u ON o.user_id = u.id
WHERE o.total_amount > (SELECT AVG(total_amount) FROM orders)
ORDER BY o.total_amount DESC;
```

---

## 🎯 Bài Tập 11: Self JOIN (Nâng Cao)

### Yêu Cầu
Tạo table "employees" với manager_id, rồi viết query để lấy employees với manager name.

### Gợi Ý
- Tạo table employees (id, name, manager_id)
- Sử dụng Self JOIN
- Alias table 2 lần

### Solution
```sql
-- Tạo table
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    manager_id INTEGER REFERENCES employees(id)
);

-- Thêm data
INSERT INTO employees (name, manager_id) VALUES
('Alice', NULL),
('Bob', 1),
('Charlie', 1),
('David', 2);

-- Query
SELECT 
    e.id,
    e.name AS employee_name,
    m.name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;
```

---

## 🎯 Bài Tập 12: UNION (Nâng Cao)

### Yêu Cầu
Viết query để lấy tất cả users & products (kết hợp 2 tables).

### Gợi Ý
- Sử dụng UNION
- Chọn columns tương tự

### Solution
```sql
SELECT id, name, 'User' AS type FROM users
UNION
SELECT id, name, 'Product' AS type FROM products
ORDER BY type, name;
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-2: INNER JOINs
- [ ] Bài 3: LEFT JOINs
- [ ] Bài 4-5: Subqueries trong WHERE
- [ ] Bài 6: EXISTS
- [ ] Bài 7-8: Subqueries trong SELECT & FROM
- [ ] Bài 9-10: Complex queries
- [ ] Bài 11: Self JOINs
- [ ] Bài 12: UNION

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ INNER JOINs
- ✅ Multiple JOINs
- ✅ LEFT JOINs
- ✅ Subqueries (WHERE, SELECT, FROM)
- ✅ EXISTS & IN operators
- ✅ Complex queries
- ✅ Self JOINs
- ✅ UNION

---

**Chúc mừng! Bạn đã hoàn thành Module 1 - JOINs & Subqueries! 🎉**

