# 📚 SQL Fundamentals - Lý Thuyết

Hiểu các khái niệm cơ bản của SQL và cách sử dụng chúng để truy vấn dữ liệu.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu SQL là gì và tại sao nó quan trọng
- ✅ Biết các câu lệnh SQL cơ bản (SELECT, INSERT, UPDATE, DELETE)
- ✅ Viết được queries để truy vấn dữ liệu
- ✅ Sử dụng WHERE, ORDER BY, LIMIT để lọc và sắp xếp dữ liệu
- ✅ Hiểu cấu trúc cơ bản của một database

---

## 📖 SQL Là Gì?

**SQL** (Structured Query Language) là ngôn ngữ được sử dụng để:
- **Truy vấn dữ liệu** (SELECT)
- **Thêm dữ liệu** (INSERT)
- **Cập nhật dữ liệu** (UPDATE)
- **Xóa dữ liệu** (DELETE)
- **Tạo cấu trúc** (CREATE, ALTER, DROP)

SQL là **ngôn ngữ tiêu chuẩn** cho tất cả các database systems (PostgreSQL, MySQL, SQL Server, Oracle, etc.)

### Tại Sao SQL Quan Trọng?

1. **Phổ biến** - Được sử dụng ở hầu hết các công ty
2. **Mạnh mẽ** - Có thể truy vấn dữ liệu phức tạp
3. **Dễ học** - Cú pháp gần với tiếng Anh
4. **Linh hoạt** - Hoạt động với mọi database

---

## 🗂️ Cấu Trúc Database

### Database Hierarchy

```
Database Server
    ├── Database 1
    │   ├── Schema
    │   │   ├── Table 1
    │   │   │   ├── Column 1
    │   │   │   ├── Column 2
    │   │   │   └── Row 1, Row 2, ...
    │   │   └── Table 2
    │   └── Schema 2
    └── Database 2
```

### Ví Dụ: Database "learning"

```
Database: learning
├── Table: users
│   ├── Columns: id, name, email, created_at
│   └── Rows: (1, 'John', 'john@example.com', '2024-01-01')
│
└── Table: orders
    ├── Columns: id, user_id, total_amount, created_at
    └── Rows: (1, 1, 99.99, '2024-01-05')
```

---

## 🔍 SELECT - Truy Vấn Dữ Liệu

### Cú Pháp Cơ Bản

```sql
SELECT column1, column2, ...
FROM table_name;
```

### Ví Dụ 1: Lấy Tất Cả Columns

```sql
-- Lấy tất cả columns từ table users
SELECT * FROM users;

-- Output:
-- id | name  | email              | created_at
-- 1  | John  | john@example.com   | 2024-01-01
-- 2  | Jane  | jane@example.com   | 2024-01-02
```

### Ví Dụ 2: Lấy Columns Cụ Thể

```sql
-- Chỉ lấy name và email
SELECT name, email FROM users;

-- Output:
-- name | email
-- John | john@example.com
-- Jane | jane@example.com
```

### Ví Dụ 3: Sử Dụng Alias

```sql
-- Đặt tên khác cho columns
SELECT name AS "Tên Người Dùng", email AS "Email" FROM users;

-- Output:
-- Tên Người Dùng | Email
-- John           | john@example.com
-- Jane           | jane@example.com
```

---

## 🔎 WHERE - Lọc Dữ Liệu

### Cú Pháp

```sql
SELECT column1, column2, ...
FROM table_name
WHERE condition;
```

### Ví Dụ 1: So Sánh Bằng

```sql
-- Lấy user có id = 1
SELECT * FROM users WHERE id = 1;

-- Lấy users có name = 'John'
SELECT * FROM users WHERE name = 'John';
```

### Ví Dụ 2: So Sánh Số

```sql
-- Lấy orders có total_amount > 50
SELECT * FROM orders WHERE total_amount > 50;

-- Lấy orders có total_amount >= 100
SELECT * FROM orders WHERE total_amount >= 100;

-- Lấy orders có total_amount < 100
SELECT * FROM orders WHERE total_amount < 100;
```

### Ví Dụ 3: So Sánh Text

```sql
-- Lấy users có email chứa 'example.com'
SELECT * FROM users WHERE email LIKE '%example.com%';

-- Lấy users có name bắt đầu bằng 'J'
SELECT * FROM users WHERE name LIKE 'J%';

-- Lấy users có name kết thúc bằng 'n'
SELECT * FROM users WHERE name LIKE '%n';
```

### Ví Dụ 4: Điều Kiện Kết Hợp

```sql
-- AND: Cả hai điều kiện phải đúng
SELECT * FROM orders 
WHERE total_amount > 50 AND user_id = 1;

-- OR: Một trong hai điều kiện đúng
SELECT * FROM users 
WHERE name = 'John' OR name = 'Jane';

-- NOT: Phủ định điều kiện
SELECT * FROM users WHERE NOT name = 'John';
```

---

## 📊 ORDER BY - Sắp Xếp Dữ Liệu

### Cú Pháp

```sql
SELECT column1, column2, ...
FROM table_name
ORDER BY column1 [ASC|DESC];
```

### Ví Dụ 1: Sắp Xếp Tăng Dần (ASC)

```sql
-- Sắp xếp users theo name từ A-Z
SELECT * FROM users ORDER BY name ASC;

-- ASC là mặc định, có thể bỏ
SELECT * FROM users ORDER BY name;
```

### Ví Dụ 2: Sắp Xếp Giảm Dần (DESC)

```sql
-- Sắp xếp orders theo total_amount từ cao xuống thấp
SELECT * FROM orders ORDER BY total_amount DESC;
```

### Ví Dụ 3: Sắp Xếp Theo Nhiều Columns

```sql
-- Sắp xếp theo user_id tăng, sau đó total_amount giảm
SELECT * FROM orders 
ORDER BY user_id ASC, total_amount DESC;
```

---

## 📌 LIMIT - Giới Hạn Kết Quả

### Cú Pháp

```sql
SELECT column1, column2, ...
FROM table_name
LIMIT number;
```

### Ví Dụ 1: Lấy 5 Rows Đầu Tiên

```sql
-- Lấy 5 users đầu tiên
SELECT * FROM users LIMIT 5;
```

### Ví Dụ 2: Lấy Rows Từ Vị Trí Cụ Thể

```sql
-- Lấy 5 users, bắt đầu từ vị trí thứ 3 (OFFSET)
SELECT * FROM users LIMIT 5 OFFSET 2;

-- Hoặc sử dụng cú pháp khác
SELECT * FROM users LIMIT 2, 5;
```

### Ví Dụ 3: Kết Hợp ORDER BY + LIMIT

```sql
-- Lấy 3 orders có total_amount cao nhất
SELECT * FROM orders 
ORDER BY total_amount DESC 
LIMIT 3;
```

---

## ➕ INSERT - Thêm Dữ Liệu

### Cú Pháp

```sql
INSERT INTO table_name (column1, column2, ...)
VALUES (value1, value2, ...);
```

### Ví Dụ 1: Thêm Một Row

```sql
-- Thêm một user mới
INSERT INTO users (name, email)
VALUES ('Bob', 'bob@example.com');
```

### Ví Dụ 2: Thêm Nhiều Rows

```sql
-- Thêm nhiều users cùng lúc
INSERT INTO users (name, email) VALUES
('Alice', 'alice@example.com'),
('Charlie', 'charlie@example.com'),
('Diana', 'diana@example.com');
```

### Ví Dụ 3: Thêm Tất Cả Columns

```sql
-- Nếu thêm tất cả columns, có thể bỏ danh sách columns
INSERT INTO users VALUES (5, 'Eve', 'eve@example.com', '2024-01-10');
```

---

## ✏️ UPDATE - Cập Nhật Dữ Liệu

### Cú Pháp

```sql
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;
```

### Ví Dụ 1: Cập Nhật Một Row

```sql
-- Cập nhật email của user có id = 1
UPDATE users
SET email = 'newemail@example.com'
WHERE id = 1;
```

### Ví Dụ 2: Cập Nhật Nhiều Columns

```sql
-- Cập nhật name và email của user có id = 2
UPDATE users
SET name = 'Jane Doe', email = 'jane.doe@example.com'
WHERE id = 2;
```

### Ví Dụ 3: Cập Nhật Nhiều Rows

```sql
-- Cập nhật tất cả orders của user 1 thành status 'completed'
UPDATE orders
SET status = 'completed'
WHERE user_id = 1;
```

### ⚠️ Cảnh Báo: WHERE Clause Rất Quan Trọng!

```sql
-- ❌ NGUY HIỂM: Cập nhật tất cả rows!
UPDATE users SET email = 'test@example.com';

-- ✅ ĐÚNG: Chỉ cập nhật rows cụ thể
UPDATE users SET email = 'test@example.com' WHERE id = 1;
```

---

## 🗑️ DELETE - Xóa Dữ Liệu

### Cú Pháp

```sql
DELETE FROM table_name
WHERE condition;
```

### Ví Dụ 1: Xóa Một Row

```sql
-- Xóa user có id = 5
DELETE FROM users WHERE id = 5;
```

### Ví Dụ 2: Xóa Nhiều Rows

```sql
-- Xóa tất cả orders của user 1
DELETE FROM orders WHERE user_id = 1;
```

### ⚠️ Cảnh Báo: WHERE Clause Rất Quan Trọng!

```sql
-- ❌ NGUY HIỂM: Xóa tất cả rows!
DELETE FROM users;

-- ✅ ĐÚNG: Chỉ xóa rows cụ thể
DELETE FROM users WHERE id = 5;
```

---

## 📊 Tóm Tắt SQL Cơ Bản

| Câu Lệnh | Mục Đích | Ví Dụ |
|---------|---------|-------|
| **SELECT** | Truy vấn dữ liệu | `SELECT * FROM users;` |
| **WHERE** | Lọc dữ liệu | `WHERE id = 1` |
| **ORDER BY** | Sắp xếp dữ liệu | `ORDER BY name ASC` |
| **LIMIT** | Giới hạn kết quả | `LIMIT 10` |
| **INSERT** | Thêm dữ liệu | `INSERT INTO users VALUES (...)` |
| **UPDATE** | Cập nhật dữ liệu | `UPDATE users SET name = '...'` |
| **DELETE** | Xóa dữ liệu | `DELETE FROM users WHERE id = 1` |

---

## 🎓 Key Takeaways

1. **SELECT** - Luôn bắt đầu với SELECT để truy vấn dữ liệu
2. **WHERE** - Sử dụng WHERE để lọc dữ liệu cụ thể
3. **ORDER BY** - Sắp xếp kết quả theo cách bạn muốn
4. **LIMIT** - Giới hạn số lượng kết quả
5. **INSERT/UPDATE/DELETE** - Sửa đổi dữ liệu (luôn cẩn thận!)
6. **WHERE là quan trọng** - Luôn sử dụng WHERE khi UPDATE/DELETE

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL SELECT Documentation](https://www.postgresql.org/docs/current/sql-select.html)
- [PostgreSQL INSERT Documentation](https://www.postgresql.org/docs/current/sql-insert.html)
- [PostgreSQL UPDATE Documentation](https://www.postgresql.org/docs/current/sql-update.html)
- [PostgreSQL DELETE Documentation](https://www.postgresql.org/docs/current/sql-delete.html)

---

**Bây giờ bạn đã hiểu SQL cơ bản! Hãy chuyển sang phần thực hành. 💪**

