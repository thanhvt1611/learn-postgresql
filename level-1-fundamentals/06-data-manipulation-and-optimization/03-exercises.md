# 💪 Data Manipulation & Optimization - Bài Tập

Thực hành INSERT, UPDATE, DELETE & tối ưu hóa performance.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có database "ecommerce_practice" với sample data

---

## 🎯 Bài Tập 1: Simple INSERT (Dễ)

### Yêu Cầu
Thêm 5 users mới:
1. User1, user1@example.com, 25
2. User2, user2@example.com, 30
3. User3, user3@example.com, 28
4. User4, user4@example.com, 32
5. User5, user5@example.com, 26

### Gợi Ý
- Sử dụng INSERT
- Sử dụng Multiple VALUES

### Solution
```sql
INSERT INTO users (name, email, age)
VALUES 
  ('User1', 'user1@example.com', 25),
  ('User2', 'user2@example.com', 30),
  ('User3', 'user3@example.com', 28),
  ('User4', 'user4@example.com', 32),
  ('User5', 'user5@example.com', 26);

-- Kiểm tra
SELECT * FROM users WHERE email LIKE 'user%@example.com';
```

---

## 🎯 Bài Tập 2: INSERT FROM SELECT (Trung Bình)

### Yêu Cầu
Tạo bảng users_archive & copy users có age > 25:
1. Tạo bảng users_archive
2. Copy dữ liệu từ users
3. Kiểm tra dữ liệu

### Gợi Ý
- Sử dụng CREATE TABLE AS
- Sử dụng INSERT INTO ... SELECT

### Solution
```sql
-- Tạo bảng
CREATE TABLE users_archive (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    age INT
);

-- Copy dữ liệu
INSERT INTO users_archive (name, email, age)
SELECT name, email, age FROM users WHERE age > 25;

-- Kiểm tra
SELECT COUNT(*) FROM users_archive;
SELECT * FROM users_archive;
```

---

## 🎯 Bài Tập 3: Simple UPDATE (Dễ)

### Yêu Cầu
Cập nhật age của User1 thành 26.

### Gợi Ý
- Sử dụng UPDATE
- Sử dụng WHERE

### Solution
```sql
UPDATE users
SET age = 26
WHERE email = 'user1@example.com';

-- Kiểm tra
SELECT * FROM users WHERE email = 'user1@example.com';
```

---

## 🎯 Bài Tập 4: UPDATE Multiple Columns (Trung Bình)

### Yêu Cầu
Cập nhật User2:
1. age = 31
2. email = 'user2_new@example.com'

### Gợi Ý
- Sử dụng UPDATE
- Cập nhật 2 columns

### Solution
```sql
UPDATE users
SET age = 31, email = 'user2_new@example.com'
WHERE email = 'user2@example.com';

-- Kiểm tra
SELECT * FROM users WHERE email = 'user2_new@example.com';
```

---

## 🎯 Bài Tập 5: UPDATE WITH Expression (Trung Bình)

### Yêu Cầu
Tăng age của tất cả users có age < 30 lên 1.

### Gợi Ý
- Sử dụng UPDATE
- Sử dụng Expression (age + 1)

### Solution
```sql
UPDATE users
SET age = age + 1
WHERE age < 30;

-- Kiểm tra
SELECT * FROM users WHERE email LIKE 'user%@example.com';
```

---

## 🎯 Bài Tập 6: Simple DELETE (Dễ)

### Yêu Cầu
Xóa User5.

### Gợi Ý
- Sử dụng DELETE
- Sử dụng WHERE

### Solution
```sql
DELETE FROM users
WHERE email = 'user5@example.com';

-- Kiểm tra
SELECT * FROM users WHERE email = 'user5@example.com';
```

---

## 🎯 Bài Tập 7: DELETE Multiple Rows (Trung Bình)

### Yêu Cầu
Xóa tất cả users có age > 30.

### Gợi Ý
- Sử dụng DELETE
- Sử dụng WHERE

### Solution
```sql
DELETE FROM users
WHERE age > 30;

-- Kiểm tra
SELECT COUNT(*) FROM users WHERE age > 30;
```

---

## 🎯 Bài Tập 8: UPSERT (Nâng Cao)

### Yêu Cầu
Tạo bảng user_preferences & UPSERT:
1. Tạo bảng user_preferences (user_id, theme, language)
2. UPSERT user_id=1, theme='dark', language='en'
3. UPSERT user_id=1, theme='light', language='vi'
4. Kiểm tra (theme='light', language='vi')

### Gợi Ý
- Sử dụng CREATE TABLE
- Sử dụng INSERT ... ON CONFLICT

### Solution
```sql
-- Tạo bảng
CREATE TABLE user_preferences (
    user_id INT PRIMARY KEY,
    theme VARCHAR(50),
    language VARCHAR(50)
);

-- UPSERT 1
INSERT INTO user_preferences (user_id, theme, language)
VALUES (1, 'dark', 'en')
ON CONFLICT (user_id)
DO UPDATE SET theme = 'dark', language = 'en';

-- UPSERT 2
INSERT INTO user_preferences (user_id, theme, language)
VALUES (1, 'light', 'vi')
ON CONFLICT (user_id)
DO UPDATE SET theme = EXCLUDED.theme, language = EXCLUDED.language;

-- Kiểm tra
SELECT * FROM user_preferences WHERE user_id = 1;
```

---

## 🎯 Bài Tập 9: BULK INSERT (Nâng Cao)

### Yêu Cầu
Bulk insert 100 users:
1. Tên: BulkUser1, BulkUser2, ...
2. Email: bulkuser1@example.com, bulkuser2@example.com, ...
3. Age: 20-69 (random)

### Gợi Ý
- Sử dụng generate_series
- Sử dụng INSERT ... SELECT

### Solution
```sql
INSERT INTO users (name, email, age)
SELECT 
  'BulkUser' || i,
  'bulkuser' || i || '@example.com',
  20 + (i % 50)
FROM generate_series(1, 100) AS i;

-- Kiểm tra
SELECT COUNT(*) FROM users WHERE name LIKE 'BulkUser%';
```

---

## 🎯 Bài Tập 10: COPY Export (Nâng Cao)

### Yêu Cầu
Export users to CSV:
1. Export tất cả users
2. File: /tmp/users_export.csv
3. Format: CSV với header

### Gợi Ý
- Sử dụng COPY ... TO
- Sử dụng FORMAT csv, HEADER true

### Solution
```sql
COPY users (id, name, email, age)
TO '/tmp/users_export.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Kiểm tra
\! head /tmp/users_export.csv
```

---

## 🎯 Bài Tập 11: COPY Import (Nâng Cao)

### Yêu Cầu
Import users from CSV:
1. Tạo bảng users_import
2. Import từ /tmp/users_export.csv
3. Kiểm tra dữ liệu

### Gợi Ý
- Sử dụng CREATE TABLE
- Sử dụng COPY ... FROM

### Solution
```sql
-- Tạo bảng
CREATE TABLE users_import (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    age INT
);

-- Import
COPY users_import (id, name, email, age)
FROM '/tmp/users_export.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Kiểm tra
SELECT COUNT(*) FROM users_import;
SELECT * FROM users_import LIMIT 5;
```

---

## 🎯 Bài Tập 12: Optimization (Nâng Cao)

### Yêu Cầu
So sánh performance:
1. Cách 1: Nhiều UPDATEs riêng lẻ
2. Cách 2: Một UPDATE với IN
3. Ghi lại thời gian

### Gợi Ý
- Sử dụng \timing
- So sánh 2 cách

### Solution
```sql
-- Bật timing
\timing

-- Cách 1: Nhiều UPDATEs (chậm)
UPDATE users SET age = 40 WHERE id = 1;
UPDATE users SET age = 40 WHERE id = 2;
UPDATE users SET age = 40 WHERE id = 3;

-- Cách 2: Một UPDATE (nhanh)
UPDATE users SET age = 40 WHERE id IN (1, 2, 3);

-- Tắt timing
\timing
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-2: INSERT
- [ ] Bài 3-5: UPDATE
- [ ] Bài 6-7: DELETE
- [ ] Bài 8: UPSERT
- [ ] Bài 9: BULK INSERT
- [ ] Bài 10-11: COPY
- [ ] Bài 12: Optimization

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ INSERT, UPDATE, DELETE
- ✅ UPSERT
- ✅ BULK INSERT
- ✅ COPY (export & import)
- ✅ Optimization

---

**Chúc mừng! Bạn đã hoàn thành Module 6 - Data Manipulation & Optimization! 🎉**

