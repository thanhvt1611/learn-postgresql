# 🛠️ Views & Stored Procedures - Thực Hành

Thực hành tạo & sử dụng views & stored procedures.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Tạo được Views
- ✅ Sửa & xóa Views
- ✅ Tạo được Materialized Views
- ✅ Tạo được Stored Procedures
- ✅ Tạo được Functions

---

## 📋 Bước 1: Chuẩn Bị Database

### Bước 1.1: Sử Dụng Database Từ Module 1-3

```sql
-- Kết nối
psql -U postgres -d ecommerce_practice

-- Kiểm tra tables
\dt
```

---

## 👁️ Bước 2: Tạo Simple Views

### Thực Hành 2.1: Tạo View Cho Active Users

```sql
-- Tạo view
CREATE VIEW active_users AS
SELECT id, name, email, age
FROM users
WHERE age >= 18;

-- Sử dụng view
SELECT * FROM active_users;
```

**Output:**
```
 id |    name    |       email        | age
----+------------+--------------------+-----
  1 | John Doe   | john@example.com   |  28
  2 | Jane Smith | jane@example.com   |  32
  3 | Bob Johnson| bob@example.com    |  25
  4 | Alice Brown| alice@example.com  |  30
```

### Thực Hành 2.2: Tạo View Cho Products Có Stock

```sql
-- Tạo view
CREATE VIEW products_in_stock AS
SELECT id, name, price, stock
FROM products
WHERE stock > 0;

-- Sử dụng
SELECT * FROM products_in_stock;
```

---

## 👁️ Bước 3: Tạo Complex Views

### Thực Hành 3.1: Tạo View Cho Order Statistics

```sql
-- Tạo view
CREATE VIEW order_statistics AS
SELECT 
    u.id,
    u.name,
    COUNT(o.id) AS order_count,
    SUM(o.total_amount) AS total_amount,
    AVG(o.total_amount) AS avg_amount,
    MIN(o.total_amount) AS min_amount,
    MAX(o.total_amount) AS max_amount
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;

-- Sử dụng
SELECT * FROM order_statistics ORDER BY total_amount DESC;
```

**Output:**
```
 id |    name    | order_count | total_amount | avg_amount | min_amount | max_amount
----+------------+-------------+--------------+------------+------------+------------
  3 | Bob Johnson|           1 |      1379.97 |    1379.97 |    1379.97 |    1379.97
  1 | John Doe   |           2 |      1049.97 |     524.985|      19.99 |    1029.98
  2 | Jane Smith |           1 |        39.99 |      39.99 |      39.99 |      39.99
  4 | Alice Brown|           1 |       109.98 |     109.98 |     109.98 |     109.98
```

### Thực Hành 3.2: Tạo View Cho Product Revenue

```sql
-- Tạo view
CREATE VIEW product_revenue AS
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
GROUP BY p.id, p.name, c.id, c.name;

-- Sử dụng
SELECT * FROM product_revenue ORDER BY total_revenue DESC NULLS LAST;
```

---

## ✏️ Bước 4: Sửa Views

### Thực Hành 4.1: Sửa View

```sql
-- Sửa view (thêm column)
CREATE OR REPLACE VIEW order_statistics AS
SELECT 
    u.id,
    u.name,
    u.email,
    COUNT(o.id) AS order_count,
    SUM(o.total_amount) AS total_amount,
    AVG(o.total_amount) AS avg_amount
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name, u.email;

-- Kiểm tra
SELECT * FROM order_statistics;
```

---

## 🗑️ Bước 5: Xóa Views

### Thực Hành 5.1: Xóa View

```sql
-- Xóa view
DROP VIEW active_users;

-- Xóa nếu tồn tại
DROP VIEW IF EXISTS products_in_stock;

-- Kiểm tra
\dv
```

---

## 📊 Bước 6: Materialized Views

### Thực Hành 6.1: Tạo Materialized View

```sql
-- Tạo materialized view
CREATE MATERIALIZED VIEW user_order_summary_mv AS
SELECT 
    u.id,
    u.name,
    COUNT(o.id) AS order_count,
    SUM(o.total_amount) AS total_spent
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;

-- Sử dụng
SELECT * FROM user_order_summary_mv;
```

### Thực Hành 6.2: Cập Nhật Materialized View

```sql
-- Cập nhật dữ liệu
REFRESH MATERIALIZED VIEW user_order_summary_mv;

-- Kiểm tra
SELECT * FROM user_order_summary_mv;
```

---

## 🔧 Bước 7: Tạo Stored Procedures

### Thực Hành 7.1: Simple Procedure

```sql
-- Tạo procedure để lấy orders của user
CREATE PROCEDURE get_user_orders(user_id INT)
AS $$
BEGIN
    SELECT * FROM orders WHERE user_id = user_id;
END;
$$ LANGUAGE plpgsql;

-- Gọi procedure
CALL get_user_orders(1);
```

**Output:**
```
 id | user_id | total_amount | status    | created_at
----+---------+--------------+-----------+----------------------------
  1 |       1 |      1029.98 | completed | 2024-01-15 10:30:00.123456
  3 |       1 |        19.99 | completed | 2024-01-15 10:30:02.345678
```

### Thực Hành 7.2: Procedure Với Logic

```sql
-- Tạo procedure để thêm user
CREATE PROCEDURE add_user(name VARCHAR, email VARCHAR, age INT)
AS $$
BEGIN
    INSERT INTO users (name, email, age) VALUES (name, email, age);
END;
$$ LANGUAGE plpgsql;

-- Gọi
CALL add_user('Test User', 'test@example.com', 25);

-- Kiểm tra
SELECT * FROM users WHERE email = 'test@example.com';
```

---

## 🔧 Bước 8: Tạo Functions

### Thực Hành 8.1: Function Trả Về Scalar

```sql
-- Tạo function để tính total spent
CREATE FUNCTION get_user_total_spent(user_id INT)
RETURNS DECIMAL AS $$
BEGIN
    RETURN (SELECT SUM(total_amount) FROM orders WHERE user_id = user_id);
END;
$$ LANGUAGE plpgsql;

-- Sử dụng
SELECT get_user_total_spent(1);
```

**Output:**
```
 get_user_total_spent
----------------------
              1049.97
```

### Thực Hành 8.2: Function Trả Về Table

```sql
-- Tạo function để lấy user stats
CREATE FUNCTION get_user_stats(user_id INT)
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
SELECT * FROM get_user_stats(1);
```

---

## 📋 Bước 9: Xem Views & Procedures

### Thực Hành 9.1: Liệt Kê Views

```sql
-- Liệt kê tất cả views
\dv

-- Hoặc query
SELECT * FROM information_schema.views WHERE table_schema = 'public';
```

### Thực Hành 9.2: Liệt Kê Procedures & Functions

```sql
-- Liệt kê procedures & functions
\df

-- Hoặc query
SELECT * FROM information_schema.routines WHERE routine_schema = 'public';
```

---

## ✅ Checklist Thực Hành

- [ ] Tạo simple views
- [ ] Tạo complex views
- [ ] Sửa views
- [ ] Xóa views
- [ ] Tạo materialized views
- [ ] Cập nhật materialized views
- [ ] Tạo stored procedures
- [ ] Tạo functions
- [ ] Liệt kê views & procedures

---

## 💡 Tips

1. **Sử dụng views** - Đơn giản hóa queries phức tạp
2. **Materialized views** - Cho queries chậm & phức tạp
3. **Stored procedures** - Tái sử dụng logic
4. **Functions** - Trả về giá trị
5. **Naming convention** - Đặt tên rõ ràng

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

