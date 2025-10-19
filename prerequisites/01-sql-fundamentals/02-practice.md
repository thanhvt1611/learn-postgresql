# 🛠️ SQL Fundamentals - Thực Hành

Thực hành các câu lệnh SQL cơ bản với sample database.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Tạo được sample database
- ✅ Viết được SELECT queries
- ✅ Sử dụng được WHERE, ORDER BY, LIMIT
- ✅ Thêm, cập nhật, xóa dữ liệu
- ✅ Hiểu cách dữ liệu được lưu trữ

---

## 📋 Bước 1: Tạo Sample Database

### Bước 1.1: Kết Nối PostgreSQL

```bash
# Mở terminal/command prompt
psql -U postgres

# Nhập password nếu được hỏi
```

### Bước 1.2: Tạo Database

```sql
-- Tạo database mới
CREATE DATABASE learning;

-- Kết nối vào database
\c learning
```

### Bước 1.3: Tạo Tables

```sql
-- Tạo table users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    age INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tạo table orders
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    product_name VARCHAR(100),
    total_amount DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Kiểm tra tables đã tạo
\dt
```

---

## 📝 Bước 2: Thêm Sample Data

### Bước 2.1: Thêm Users

```sql
-- Thêm users
INSERT INTO users (name, email, age) VALUES
('John Doe', 'john@example.com', 28),
('Jane Smith', 'jane@example.com', 32),
('Bob Johnson', 'bob@example.com', 25),
('Alice Williams', 'alice@example.com', 30),
('Charlie Brown', 'charlie@example.com', 35);

-- Kiểm tra dữ liệu
SELECT * FROM users;
```

**Output:**
```
 id |      name       |        email         | age |         created_at
----+-----------------+----------------------+-----+----------------------------
  1 | John Doe        | john@example.com     |  28 | 2024-01-15 10:30:00
  2 | Jane Smith      | jane@example.com     |  32 | 2024-01-15 10:30:00
  3 | Bob Johnson     | bob@example.com      |  25 | 2024-01-15 10:30:00
  4 | Alice Williams  | alice@example.com    |  30 | 2024-01-15 10:30:00
  5 | Charlie Brown   | charlie@example.com  |  35 | 2024-01-15 10:30:00
```

### Bước 2.2: Thêm Orders

```sql
-- Thêm orders
INSERT INTO orders (user_id, product_name, total_amount) VALUES
(1, 'Laptop', 999.99),
(1, 'Mouse', 29.99),
(2, 'Keyboard', 79.99),
(3, 'Monitor', 299.99),
(2, 'USB Cable', 9.99),
(4, 'Headphones', 149.99),
(5, 'Laptop', 1299.99);

-- Kiểm tra dữ liệu
SELECT * FROM orders;
```

**Output:**
```
 id | user_id | product_name |  total_amount  |         created_at
----+---------+--------------+----------------+----------------------------
  1 |       1 | Laptop       |         999.99 | 2024-01-15 10:31:00
  2 |       1 | Mouse        |          29.99 | 2024-01-15 10:31:00
  3 |       2 | Keyboard     |          79.99 | 2024-01-15 10:31:00
  4 |       3 | Monitor      |         299.99 | 2024-01-15 10:31:00
  5 |       2 | USB Cable    |           9.99 | 2024-01-15 10:31:00
  6 |       4 | Headphones   |         149.99 | 2024-01-15 10:31:00
  7 |       5 | Laptop       |        1299.99 | 2024-01-15 10:31:00
```

---

## 🔍 Bước 3: Thực Hành SELECT

### Thực Hành 3.1: Lấy Tất Cả Dữ Liệu

```sql
-- Lấy tất cả users
SELECT * FROM users;

-- Lấy tất cả orders
SELECT * FROM orders;
```

### Thực Hành 3.2: Lấy Columns Cụ Thể

```sql
-- Lấy chỉ name và email từ users
SELECT name, email FROM users;

-- Lấy chỉ product_name và total_amount từ orders
SELECT product_name, total_amount FROM orders;
```

### Thực Hành 3.3: Sử Dụng Alias

```sql
-- Đặt tên khác cho columns
SELECT name AS "Tên Người Dùng", email AS "Email" FROM users;

-- Đặt tên khác cho orders
SELECT product_name AS "Sản Phẩm", total_amount AS "Giá" FROM orders;
```

---

## 🔎 Bước 4: Thực Hành WHERE

### Thực Hành 4.1: So Sánh Bằng

```sql
-- Lấy user có id = 1
SELECT * FROM users WHERE id = 1;

-- Lấy orders của user 2
SELECT * FROM orders WHERE user_id = 2;
```

### Thực Hành 4.2: So Sánh Số

```sql
-- Lấy users có age > 30
SELECT * FROM users WHERE age > 30;

-- Lấy orders có total_amount >= 100
SELECT * FROM orders WHERE total_amount >= 100;

-- Lấy orders có total_amount < 50
SELECT * FROM orders WHERE total_amount < 50;
```

### Thực Hành 4.3: So Sánh Text

```sql
-- Lấy users có email chứa 'example.com'
SELECT * FROM users WHERE email LIKE '%example.com%';

-- Lấy users có name bắt đầu bằng 'J'
SELECT * FROM users WHERE name LIKE 'J%';

-- Lấy orders có product_name chứa 'Laptop'
SELECT * FROM orders WHERE product_name LIKE '%Laptop%';
```

### Thực Hành 4.4: Điều Kiện Kết Hợp

```sql
-- AND: Lấy users có age > 25 AND age < 35
SELECT * FROM users WHERE age > 25 AND age < 35;

-- OR: Lấy users có name = 'John Doe' OR name = 'Jane Smith'
SELECT * FROM users WHERE name = 'John Doe' OR name = 'Jane Smith';

-- NOT: Lấy users không phải age = 30
SELECT * FROM users WHERE NOT age = 30;
```

---

## 📊 Bước 5: Thực Hành ORDER BY

### Thực Hành 5.1: Sắp Xếp Tăng Dần

```sql
-- Sắp xếp users theo name từ A-Z
SELECT * FROM users ORDER BY name ASC;

-- Sắp xếp orders theo total_amount từ thấp đến cao
SELECT * FROM orders ORDER BY total_amount ASC;
```

### Thực Hành 5.2: Sắp Xếp Giảm Dần

```sql
-- Sắp xếp users theo age từ cao xuống thấp
SELECT * FROM users ORDER BY age DESC;

-- Sắp xếp orders theo total_amount từ cao xuống thấp
SELECT * FROM orders ORDER BY total_amount DESC;
```

### Thực Hành 5.3: Sắp Xếp Theo Nhiều Columns

```sql
-- Sắp xếp orders theo user_id tăng, sau đó total_amount giảm
SELECT * FROM orders ORDER BY user_id ASC, total_amount DESC;
```

---

## 📌 Bước 6: Thực Hành LIMIT

### Thực Hành 6.1: Lấy N Rows Đầu Tiên

```sql
-- Lấy 3 users đầu tiên
SELECT * FROM users LIMIT 3;

-- Lấy 2 orders đầu tiên
SELECT * FROM orders LIMIT 2;
```

### Thực Hành 6.2: Lấy Rows Từ Vị Trí Cụ Thể

```sql
-- Lấy 2 users, bắt đầu từ vị trí thứ 2 (OFFSET)
SELECT * FROM users LIMIT 2 OFFSET 1;

-- Lấy 3 orders, bắt đầu từ vị trí thứ 3
SELECT * FROM orders LIMIT 3 OFFSET 2;
```

### Thực Hành 6.3: Kết Hợp ORDER BY + LIMIT

```sql
-- Lấy 3 orders có total_amount cao nhất
SELECT * FROM orders ORDER BY total_amount DESC LIMIT 3;

-- Lấy 2 users có age cao nhất
SELECT * FROM users ORDER BY age DESC LIMIT 2;
```

---

## ➕ Bước 7: Thực Hành INSERT

### Thực Hành 7.1: Thêm Một User

```sql
-- Thêm một user mới
INSERT INTO users (name, email, age) VALUES ('Diana Prince', 'diana@example.com', 29);

-- Kiểm tra
SELECT * FROM users WHERE name = 'Diana Prince';
```

### Thực Hành 7.2: Thêm Nhiều Users

```sql
-- Thêm nhiều users cùng lúc
INSERT INTO users (name, email, age) VALUES
('Eve Adams', 'eve@example.com', 26),
('Frank Miller', 'frank@example.com', 33);

-- Kiểm tra
SELECT * FROM users ORDER BY id DESC LIMIT 3;
```

### Thực Hành 7.3: Thêm Orders

```sql
-- Thêm orders mới
INSERT INTO orders (user_id, product_name, total_amount) VALUES
(1, 'Monitor', 399.99),
(3, 'Keyboard', 89.99);

-- Kiểm tra
SELECT * FROM orders ORDER BY id DESC LIMIT 2;
```

---

## ✏️ Bước 8: Thực Hành UPDATE

### Thực Hành 8.1: Cập Nhật Một Row

```sql
-- Cập nhật email của user có id = 1
UPDATE users SET email = 'john.doe@example.com' WHERE id = 1;

-- Kiểm tra
SELECT * FROM users WHERE id = 1;
```

### Thực Hành 8.2: Cập Nhật Nhiều Columns

```sql
-- Cập nhật name và age của user có id = 2
UPDATE users SET name = 'Jane Doe', age = 33 WHERE id = 2;

-- Kiểm tra
SELECT * FROM users WHERE id = 2;
```

### Thực Hành 8.3: Cập Nhật Nhiều Rows

```sql
-- Cập nhật tất cả orders của user 1 (thêm prefix)
UPDATE orders SET product_name = 'Premium ' || product_name WHERE user_id = 1;

-- Kiểm tra
SELECT * FROM orders WHERE user_id = 1;
```

---

## 🗑️ Bước 9: Thực Hành DELETE

### Thực Hành 9.1: Xóa Một Row

```sql
-- Xóa order có id = 7
DELETE FROM orders WHERE id = 7;

-- Kiểm tra
SELECT COUNT(*) FROM orders;
```

### Thực Hành 9.2: Xóa Nhiều Rows

```sql
-- Xóa tất cả orders có total_amount < 20
DELETE FROM orders WHERE total_amount < 20;

-- Kiểm tra
SELECT * FROM orders;
```

---

## 🎯 Bước 10: Thực Hành Kết Hợp

### Thực Hành 10.1: Query Phức Tạp

```sql
-- Lấy 5 orders có total_amount cao nhất, sắp xếp theo giá giảm dần
SELECT product_name, total_amount FROM orders 
ORDER BY total_amount DESC 
LIMIT 5;

-- Lấy users có age > 25, sắp xếp theo name
SELECT name, email, age FROM users 
WHERE age > 25 
ORDER BY name ASC;

-- Lấy orders của users có age > 30
SELECT o.product_name, o.total_amount, u.name, u.age 
FROM orders o, users u 
WHERE o.user_id = u.id AND u.age > 30;
```

---

## ✅ Checklist Thực Hành

- [ ] Tạo database "learning"
- [ ] Tạo tables users và orders
- [ ] Thêm sample data
- [ ] Thực hành SELECT (tất cả columns, columns cụ thể, alias)
- [ ] Thực hành WHERE (so sánh, LIKE, AND/OR/NOT)
- [ ] Thực hành ORDER BY (ASC, DESC, multiple columns)
- [ ] Thực hành LIMIT (basic, OFFSET, kết hợp ORDER BY)
- [ ] Thực hành INSERT (một row, nhiều rows)
- [ ] Thực hành UPDATE (một row, nhiều columns, nhiều rows)
- [ ] Thực hành DELETE (một row, nhiều rows)
- [ ] Thực hành kết hợp các câu lệnh

---

## 💡 Tips

1. **Luôn kiểm tra kết quả** - Sau mỗi câu lệnh, chạy SELECT để xem kết quả
2. **Sử dụng WHERE cẩn thận** - Đặc biệt với UPDATE/DELETE
3. **Thử thay đổi queries** - Thay đổi WHERE, ORDER BY, LIMIT để hiểu sâu hơn
4. **Ghi chú** - Ghi lại những queries quan trọng

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

