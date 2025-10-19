# 🛠️ Data Manipulation & Optimization - Thực Hành

Thực hành INSERT, UPDATE, DELETE & tối ưu hóa performance.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Sử dụng được INSERT, UPDATE, DELETE
- ✅ Sử dụng được UPSERT
- ✅ Sử dụng được BULK INSERT
- ✅ Sử dụng được COPY
- ✅ Tối ưu hóa được data manipulation

---

## 📋 Bước 1: Chuẩn Bị Database

### Bước 1.1: Sử Dụng Database Từ Module 1-5

```sql
-- Kết nối
psql -U postgres -d ecommerce_practice

-- Kiểm tra tables
\dt
```

---

## ➕ Bước 2: Thực Hành INSERT

### Thực Hành 2.1: Simple INSERT

```sql
-- Thêm một user
INSERT INTO users (name, email, age)
VALUES ('Test User', 'test@example.com', 25);

-- Kiểm tra
SELECT * FROM users WHERE email = 'test@example.com';
```

### Thực Hành 2.2: INSERT Multiple Rows

```sql
-- Thêm nhiều users
INSERT INTO users (name, email, age)
VALUES 
  ('User1', 'user1@example.com', 25),
  ('User2', 'user2@example.com', 30),
  ('User3', 'user3@example.com', 28);

-- Kiểm tra
SELECT * FROM users WHERE email LIKE 'user%@example.com';
```

### Thực Hành 2.3: INSERT FROM SELECT

```sql
-- Tạo bảng backup
CREATE TABLE users_backup AS SELECT * FROM users WHERE 1=0;

-- Copy dữ liệu
INSERT INTO users_backup (id, name, email, age)
SELECT id, name, email, age FROM users WHERE age > 25;

-- Kiểm tra
SELECT COUNT(*) FROM users_backup;
```

---

## 🔄 Bước 3: Thực Hành UPDATE

### Thực Hành 3.1: Simple UPDATE

```sql
-- Cập nhật age
UPDATE users
SET age = 26
WHERE email = 'test@example.com';

-- Kiểm tra
SELECT * FROM users WHERE email = 'test@example.com';
```

### Thực Hành 3.2: UPDATE Multiple Columns

```sql
-- Cập nhật nhiều columns
UPDATE users
SET age = 27, email = 'newemail@example.com'
WHERE email = 'test@example.com';

-- Kiểm tra
SELECT * FROM users WHERE email = 'newemail@example.com';
```

### Thực Hành 3.3: UPDATE WITH Expression

```sql
-- Tăng age lên 1
UPDATE users
SET age = age + 1
WHERE email LIKE 'user%@example.com';

-- Kiểm tra
SELECT * FROM users WHERE email LIKE 'user%@example.com';
```

### Thực Hành 3.4: UPDATE Multiple Rows

```sql
-- Cập nhật tất cả users có age < 30
UPDATE users
SET age = 30
WHERE age < 30;

-- Kiểm tra
SELECT COUNT(*) FROM users WHERE age = 30;
```

---

## 🗑️ Bước 4: Thực Hành DELETE

### Thực Hành 4.1: Simple DELETE

```sql
-- Xóa một user
DELETE FROM users
WHERE email = 'newemail@example.com';

-- Kiểm tra
SELECT COUNT(*) FROM users;
```

### Thực Hành 4.2: DELETE Multiple Rows

```sql
-- Xóa users có age > 30
DELETE FROM users
WHERE age > 30;

-- Kiểm tra
SELECT COUNT(*) FROM users;
```

---

## 🔀 Bước 5: Thực Hành UPSERT

### Thực Hành 5.1: UPSERT Cơ Bản

```sql
-- Tạo bảng test
CREATE TABLE user_settings (
    user_id INT PRIMARY KEY,
    theme VARCHAR(50),
    language VARCHAR(50)
);

-- UPSERT (insert nếu không tồn tại, update nếu tồn tại)
INSERT INTO user_settings (user_id, theme, language)
VALUES (1, 'dark', 'en')
ON CONFLICT (user_id)
DO UPDATE SET theme = 'dark', language = 'en';

-- Kiểm tra
SELECT * FROM user_settings;
```

### Thực Hành 5.2: UPSERT Với EXCLUDED

```sql
-- UPSERT sử dụng EXCLUDED
INSERT INTO user_settings (user_id, theme, language)
VALUES (1, 'light', 'vi')
ON CONFLICT (user_id)
DO UPDATE SET 
  theme = EXCLUDED.theme,
  language = EXCLUDED.language;

-- Kiểm tra
SELECT * FROM user_settings;
```

---

## 📦 Bước 6: Thực Hành BULK INSERT

### Thực Hành 6.1: Bulk INSERT Với Multiple VALUES

```sql
-- Bulk insert 100 users
INSERT INTO users (name, email, age)
SELECT 
  'BulkUser' || i,
  'bulkuser' || i || '@example.com',
  20 + (i % 50)
FROM generate_series(1, 100) AS i;

-- Kiểm tra
SELECT COUNT(*) FROM users WHERE name LIKE 'BulkUser%';
```

### Thực Hành 6.2: Bulk INSERT Với Transaction

```sql
-- Bulk insert trong transaction
BEGIN;
INSERT INTO users (name, email, age)
SELECT 
  'TxUser' || i,
  'txuser' || i || '@example.com',
  25
FROM generate_series(1, 50) AS i;
COMMIT;

-- Kiểm tra
SELECT COUNT(*) FROM users WHERE name LIKE 'TxUser%';
```

---

## 📊 Bước 7: Thực Hành COPY

### Thực Hành 7.1: Export CSV

```sql
-- Export users to CSV
COPY users (id, name, email, age)
TO '/tmp/users_export.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Kiểm tra file
\! head /tmp/users_export.csv
```

### Thực Hành 7.2: Import CSV

```sql
-- Tạo bảng temp
CREATE TABLE users_import (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    age INT
);

-- Import từ CSV
COPY users_import (name, email, age)
FROM '/tmp/users_export.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Kiểm tra
SELECT COUNT(*) FROM users_import;
```

---

## ⚡ Bước 8: Thực Hành Optimization

### Thực Hành 8.1: Batch UPDATE

```sql
-- ❌ BAD: Nhiều UPDATEs
UPDATE users SET age = 40 WHERE id = 1;
UPDATE users SET age = 40 WHERE id = 2;
UPDATE users SET age = 40 WHERE id = 3;

-- ✅ GOOD: Một UPDATE
UPDATE users SET age = 40 WHERE id IN (1, 2, 3);
```

### Thực Hành 8.2: Batch DELETE

```sql
-- ❌ BAD: Nhiều DELETEs
DELETE FROM users WHERE id = 1;
DELETE FROM users WHERE id = 2;

-- ✅ GOOD: Một DELETE
DELETE FROM users WHERE id IN (1, 2);
```

### Thực Hành 8.3: Disable Triggers Khi Bulk Insert

```sql
-- Disable triggers
ALTER TABLE users DISABLE TRIGGER ALL;

-- Bulk insert
INSERT INTO users (name, email, age)
SELECT 
  'FastUser' || i,
  'fastuser' || i || '@example.com',
  25
FROM generate_series(1, 1000) AS i;

-- Enable triggers
ALTER TABLE users ENABLE TRIGGER ALL;

-- Kiểm tra
SELECT COUNT(*) FROM users WHERE name LIKE 'FastUser%';
```

---

## ✅ Checklist Thực Hành

- [ ] Thực hành INSERT
- [ ] Thực hành UPDATE
- [ ] Thực hành DELETE
- [ ] Thực hành UPSERT
- [ ] Thực hành BULK INSERT
- [ ] Thực hành COPY (export & import)
- [ ] Thực hành Optimization

---

## 💡 Tips

1. **Sử dụng BULK INSERT** - Nhanh hơn nhiều lần
2. **Sử dụng COPY** - Nhanh nhất cho import/export
3. **Batch operations** - Giảm I/O
4. **Disable triggers** - Khi bulk insert
5. **Sử dụng transactions** - Đảm bảo atomicity

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

