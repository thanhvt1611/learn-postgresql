# 💪 Views & Stored Procedures - Bài Tập

Thực hành tạo & sử dụng views & stored procedures.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có database "ecommerce_practice" với sample data

---

## 🎯 Bài Tập 1: Tạo Simple Views (Dễ)

### Yêu Cầu
Tạo views sau:
1. active_users - Users có age >= 18
2. expensive_products - Products có price > 100
3. completed_orders - Orders có status = 'completed'

### Gợi Ý
- Sử dụng CREATE VIEW
- Sử dụng WHERE clause

### Solution
```sql
CREATE VIEW active_users AS
SELECT id, name, email, age FROM users WHERE age >= 18;

CREATE VIEW expensive_products AS
SELECT id, name, price FROM products WHERE price > 100;

CREATE VIEW completed_orders AS
SELECT id, user_id, total_amount FROM orders WHERE status = 'completed';

-- Kiểm tra
SELECT * FROM active_users;
SELECT * FROM expensive_products;
SELECT * FROM completed_orders;
```

---

## 🎯 Bài Tập 2: Tạo Complex Views (Trung Bình)

### Yêu Cầu
Tạo views sau:
1. user_order_summary - Thống kê orders của mỗi user
2. category_product_count - Số lượng products trong mỗi category
3. top_products - Top 5 products theo revenue

### Gợi Ý
- Sử dụng JOINs & GROUP BY
- Sử dụng Aggregate Functions

### Solution
```sql
CREATE VIEW user_order_summary AS
SELECT 
    u.id,
    u.name,
    COUNT(o.id) AS order_count,
    SUM(o.total_amount) AS total_spent
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;

CREATE VIEW category_product_count AS
SELECT 
    c.id,
    c.name,
    COUNT(p.id) AS product_count
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
GROUP BY c.id, c.name;

CREATE VIEW top_products AS
SELECT 
    p.id,
    p.name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.name
ORDER BY total_revenue DESC NULLS LAST
LIMIT 5;
```

---

## 🎯 Bài Tập 3: Sửa Views (Trung Bình)

### Yêu Cầu
Sửa views từ Bài Tập 1:
1. Thêm email vào active_users
2. Thêm category vào expensive_products
3. Thêm user name vào completed_orders

### Gợi Ý
- Sử dụng CREATE OR REPLACE VIEW
- Thêm JOINs nếu cần

### Solution
```sql
CREATE OR REPLACE VIEW active_users AS
SELECT id, name, email, age FROM users WHERE age >= 18;

CREATE OR REPLACE VIEW expensive_products AS
SELECT p.id, p.name, p.price, c.name AS category
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE p.price > 100;

CREATE OR REPLACE VIEW completed_orders AS
SELECT o.id, o.user_id, u.name AS user_name, o.total_amount
FROM orders o
JOIN users u ON o.user_id = u.id
WHERE o.status = 'completed';
```

---

## 🎯 Bài Tập 4: Xóa Views (Dễ)

### Yêu Cầu
Xóa views từ Bài Tập 1.

### Gợi Ý
- Sử dụng DROP VIEW
- Sử dụng IF EXISTS

### Solution
```sql
DROP VIEW IF EXISTS active_users;
DROP VIEW IF EXISTS expensive_products;
DROP VIEW IF EXISTS completed_orders;

-- Kiểm tra
\dv
```

---

## 🎯 Bài Tập 5: Materialized Views (Trung Bình)

### Yêu Cầu
Tạo materialized views:
1. user_order_summary_mv
2. product_revenue_mv

### Gợi Ý
- Sử dụng CREATE MATERIALIZED VIEW
- Sử dụng REFRESH MATERIALIZED VIEW

### Solution
```sql
CREATE MATERIALIZED VIEW user_order_summary_mv AS
SELECT 
    u.id,
    u.name,
    COUNT(o.id) AS order_count,
    SUM(o.total_amount) AS total_spent
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;

CREATE MATERIALIZED VIEW product_revenue_mv AS
SELECT 
    p.id,
    p.name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.name;

-- Cập nhật
REFRESH MATERIALIZED VIEW user_order_summary_mv;
REFRESH MATERIALIZED VIEW product_revenue_mv;

-- Kiểm tra
SELECT * FROM user_order_summary_mv;
SELECT * FROM product_revenue_mv;
```

---

## 🎯 Bài Tập 6: Stored Procedures (Trung Bình)

### Yêu Cầu
Tạo stored procedures:
1. get_user_orders(user_id) - Lấy orders của user
2. get_user_stats(user_id) - Lấy thống kê user
3. add_user(name, email, age) - Thêm user mới

### Gợi Ý
- Sử dụng CREATE PROCEDURE
- Sử dụng CALL để gọi

### Solution
```sql
CREATE PROCEDURE get_user_orders(user_id INT)
AS $$
BEGIN
    SELECT * FROM orders WHERE user_id = user_id;
END;
$$ LANGUAGE plpgsql;

CREATE PROCEDURE get_user_stats(user_id INT)
AS $$
BEGIN
    SELECT 
        u.name,
        COUNT(o.id) AS order_count,
        SUM(o.total_amount) AS total_spent
    FROM users u
    LEFT JOIN orders o ON u.id = o.user_id
    WHERE u.id = user_id
    GROUP BY u.id, u.name;
END;
$$ LANGUAGE plpgsql;

CREATE PROCEDURE add_user(name VARCHAR, email VARCHAR, age INT)
AS $$
BEGIN
    INSERT INTO users (name, email, age) VALUES (name, email, age);
END;
$$ LANGUAGE plpgsql;

-- Gọi
CALL get_user_orders(1);
CALL get_user_stats(1);
CALL add_user('New User', 'new@example.com', 25);
```

---

## 🎯 Bài Tập 7: Functions (Nâng Cao)

### Yêu Cầu
Tạo functions:
1. get_user_total_spent(user_id) - Trả về tổng chi tiêu
2. get_product_revenue(product_id) - Trả về revenue
3. get_user_stats_table(user_id) - Trả về table

### Gợi Ý
- Sử dụng CREATE FUNCTION
- Sử dụng RETURNS
- Sử dụng RETURN QUERY

### Solution
```sql
CREATE FUNCTION get_user_total_spent(user_id INT)
RETURNS DECIMAL AS $$
BEGIN
    RETURN (SELECT SUM(total_amount) FROM orders WHERE user_id = user_id);
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION get_product_revenue(product_id INT)
RETURNS DECIMAL AS $$
BEGIN
    RETURN (SELECT SUM(quantity * unit_price) FROM order_items WHERE product_id = product_id);
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION get_user_stats_table(user_id INT)
RETURNS TABLE (
    user_name VARCHAR,
    order_count BIGINT,
    total_spent DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.name,
        COUNT(o.id),
        SUM(o.total_amount)
    FROM users u
    LEFT JOIN orders o ON u.id = o.user_id
    WHERE u.id = user_id
    GROUP BY u.id, u.name;
END;
$$ LANGUAGE plpgsql;

-- Sử dụng
SELECT get_user_total_spent(1);
SELECT get_product_revenue(1);
SELECT * FROM get_user_stats_table(1);
```

---

## 🎯 Bài Tập 8: Xem Views & Procedures (Dễ)

### Yêu Cầu
Liệt kê:
1. Tất cả views
2. Tất cả procedures & functions

### Gợi Ý
- Sử dụng \dv & \df
- Hoặc query information_schema

### Solution
```sql
-- Liệt kê views
\dv

-- Liệt kê procedures & functions
\df

-- Hoặc query
SELECT * FROM information_schema.views WHERE table_schema = 'public';
SELECT * FROM information_schema.routines WHERE routine_schema = 'public';
```

---

## 🎯 Bài Tập 9: Complex View (Nâng Cao)

### Yêu Cầu
Tạo view cho order details:
- Order ID, User Name, Product Name, Quantity, Unit Price, Line Total
- Sắp xếp theo Order ID

### Gợi Ý
- Sử dụng Multiple JOINs
- Tính Line Total (quantity * unit_price)

### Solution
```sql
CREATE VIEW order_details AS
SELECT 
    o.id AS order_id,
    u.name AS user_name,
    p.name AS product_name,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS line_total
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
ORDER BY o.id, oi.id;

-- Sử dụng
SELECT * FROM order_details;
```

---

## 🎯 Bài Tập 10: Procedure Với Logic (Nâng Cao)

### Yêu Cầu
Tạo procedure để:
1. Tạo order mới (insert vào orders)
2. Thêm order items (insert vào order_items)
3. Cập nhật product stock

### Gợi Ý
- Sử dụng BEGIN...END
- Sử dụng INSERT & UPDATE

### Solution
```sql
CREATE PROCEDURE create_order(
    user_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL
)
AS $$
DECLARE
    order_id INT;
    total_amount DECIMAL;
BEGIN
    -- Tính total amount
    total_amount := quantity * unit_price;
    
    -- Tạo order
    INSERT INTO orders (user_id, total_amount, status)
    VALUES (user_id, total_amount, 'pending')
    RETURNING id INTO order_id;
    
    -- Thêm order item
    INSERT INTO order_items (order_id, product_id, quantity, unit_price)
    VALUES (order_id, product_id, quantity, unit_price);
    
    -- Cập nhật stock
    UPDATE products SET stock = stock - quantity WHERE id = product_id;
    
    COMMIT;
END;
$$ LANGUAGE plpgsql;

-- Gọi
CALL create_order(1, 1, 1, 999.99);
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-4: Views
- [ ] Bài 5: Materialized Views
- [ ] Bài 6-7: Procedures & Functions
- [ ] Bài 8: Liệt kê
- [ ] Bài 9-10: Complex Views & Procedures

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ Tạo simple & complex views
- ✅ Sửa & xóa views
- ✅ Materialized views
- ✅ Stored procedures
- ✅ Functions
- ✅ Complex logic

---

**Chúc mừng! Bạn đã hoàn thành Module 4 - Views & Stored Procedures! 🎉**

