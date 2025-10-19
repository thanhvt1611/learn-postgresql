# 📚 Views & Stored Procedures - Lý Thuyết

Hiểu cách tạo views & stored procedures để tái sử dụng logic.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu Views là gì và tại sao quan trọng
- ✅ Biết cách tạo & sửa Views
- ✅ Hiểu Materialized Views
- ✅ Hiểu Stored Procedures là gì
- ✅ Biết cách tạo & gọi Stored Procedures
- ✅ Hiểu Functions & Triggers

---

## 👁️ Views - Bảng Ảo

### Định Nghĩa

**View** là một query được lưu trữ & có thể được sử dụng như một table.

### Tại Sao Views Quan Trọng?

1. **Tái sử dụng logic** - Không cần viết lại query
2. **Đơn giản hóa queries** - Ẩn complexity
3. **Bảo mật** - Giới hạn quyền truy cập
4. **Consistency** - Cùng logic ở nhiều nơi

### Ví Dụ

```sql
-- Tạo view
CREATE VIEW user_order_summary AS
SELECT 
    u.id,
    u.name,
    COUNT(o.id) AS order_count,
    SUM(o.total_amount) AS total_spent
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;

-- Sử dụng view
SELECT * FROM user_order_summary WHERE total_spent > 500;
```

---

## 🔧 Tạo Views

### Cú Pháp

```sql
CREATE VIEW view_name AS
SELECT ...;
```

### Ví Dụ 1: Simple View

```sql
-- Tạo view cho active users
CREATE VIEW active_users AS
SELECT id, name, email
FROM users
WHERE age >= 18;

-- Sử dụng
SELECT * FROM active_users;
```

### Ví Dụ 2: Complex View

```sql
-- Tạo view cho order statistics
CREATE VIEW order_statistics AS
SELECT 
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

---

## ✏️ Sửa Views

### Cú Pháp

```sql
-- Sửa view (thay thế)
CREATE OR REPLACE VIEW view_name AS
SELECT ...;

-- Hoặc
ALTER VIEW view_name RENAME TO new_name;
```

### Ví Dụ

```sql
-- Sửa view
CREATE OR REPLACE VIEW active_users AS
SELECT id, name, email, age
FROM users
WHERE age >= 21;  -- Thay đổi từ 18 → 21
```

---

## 🗑️ Xóa Views

### Cú Pháp

```sql
DROP VIEW view_name;
DROP VIEW IF EXISTS view_name;
```

### Ví Dụ

```sql
-- Xóa view
DROP VIEW active_users;

-- Xóa nếu tồn tại
DROP VIEW IF EXISTS active_users;
```

---

## 📊 Materialized Views

### Định Nghĩa

**Materialized View** là view có dữ liệu được lưu trữ (không phải query real-time).

### Ưu & Nhược Điểm

| Aspect | Regular View | Materialized View |
|--------|--------------|-------------------|
| **Dữ liệu** | Real-time | Snapshot |
| **Tốc độ** | Chậm (query mỗi lần) | Nhanh (dữ liệu cached) |
| **Dung lượng** | Không | Có |
| **Cập nhật** | Tự động | Manual (REFRESH) |

### Ví Dụ

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

-- Cập nhật dữ liệu
REFRESH MATERIALIZED VIEW user_order_summary_mv;
```

---

## 🔧 Stored Procedures

### Định Nghĩa

**Stored Procedure** là một tập hợp SQL statements được lưu trữ & có thể được gọi lại.

### Tại Sao Quan Trọng?

1. **Tái sử dụng logic** - Gọi lại nhiều lần
2. **Performance** - Thực thi trên server
3. **Bảo mật** - Kiểm soát quyền truy cập
4. **Consistency** - Cùng logic ở nhiều nơi

### Ví Dụ

```sql
-- Tạo stored procedure
CREATE PROCEDURE get_user_orders(user_id INT)
AS $$
BEGIN
    SELECT * FROM orders WHERE user_id = user_id;
END;
$$ LANGUAGE plpgsql;

-- Gọi procedure
CALL get_user_orders(1);
```

---

## 🔧 Tạo Stored Procedures

### Cú Pháp

```sql
CREATE PROCEDURE procedure_name(parameters)
AS $$
BEGIN
    -- SQL statements
END;
$$ LANGUAGE plpgsql;
```

### Ví Dụ 1: Simple Procedure

```sql
-- Tạo procedure để thêm user
CREATE PROCEDURE add_user(name VARCHAR, email VARCHAR, age INT)
AS $$
BEGIN
    INSERT INTO users (name, email, age) VALUES (name, email, age);
END;
$$ LANGUAGE plpgsql;

-- Gọi
CALL add_user('John Doe', 'john@example.com', 28);
```

### Ví Dụ 2: Procedure Với Logic

```sql
-- Tạo procedure để tính order statistics
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

-- Gọi
CALL get_user_stats(1);
```

---

## 🔧 Functions

### Định Nghĩa

**Function** là một stored procedure trả về giá trị.

### Ví Dụ

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

---

## 🔔 Triggers

### Định Nghĩa

**Trigger** là một function được thực thi tự động khi có event (INSERT, UPDATE, DELETE).

### Ví Dụ

```sql
-- Tạo trigger để cập nhật updated_at
CREATE TRIGGER update_users_timestamp
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
END;
```

---

## 📊 Tóm Tắt Views & Stored Procedures

| Khái Niệm | Mô Tả | Khi Dùng |
|-----------|-------|---------|
| **View** | Query được lưu trữ | Tái sử dụng queries |
| **Materialized View** | View với dữ liệu cached | Queries phức tạp & chậm |
| **Stored Procedure** | Tập hợp SQL statements | Tái sử dụng logic |
| **Function** | Procedure trả về giá trị | Tính toán & trả về kết quả |
| **Trigger** | Function tự động | Cập nhật tự động |

---

## 🎓 Key Takeaways

1. **Views** - Query được lưu trữ
2. **Materialized Views** - View với dữ liệu cached
3. **Stored Procedures** - Tập hợp SQL statements
4. **Functions** - Procedure trả về giá trị
5. **Triggers** - Function tự động

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL Views](https://www.postgresql.org/docs/current/sql-createview.html)
- [PostgreSQL Stored Procedures](https://www.postgresql.org/docs/current/sql-createprocedure.html)
- [PostgreSQL Functions](https://www.postgresql.org/docs/current/sql-createfunction.html)
- [PostgreSQL Triggers](https://www.postgresql.org/docs/current/sql-createtrigger.html)

---

**Bây giờ bạn đã hiểu Views & Stored Procedures! Hãy chuyển sang phần thực hành. 💪**

