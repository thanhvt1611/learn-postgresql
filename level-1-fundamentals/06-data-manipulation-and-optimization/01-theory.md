# 📚 Data Manipulation & Optimization - Lý Thuyết

Hiểu cách thao tác dữ liệu hiệu quả & tối ưu hóa performance.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu INSERT, UPDATE, DELETE
- ✅ Biết cách sử dụng BULK INSERT
- ✅ Hiểu UPSERT (INSERT ... ON CONFLICT)
- ✅ Biết cách tối ưu hóa UPDATE & DELETE
- ✅ Hiểu COPY command
- ✅ Biết cách xử lý large datasets

---

## ➕ INSERT - Thêm Dữ Liệu

### Cú Pháp Cơ Bản

```sql
INSERT INTO table_name (column1, column2, ...)
VALUES (value1, value2, ...);
```

### Ví Dụ 1: Simple INSERT

```sql
INSERT INTO users (name, email, age)
VALUES ('John Doe', 'john@example.com', 28);
```

### Ví Dụ 2: INSERT Multiple Rows

```sql
INSERT INTO users (name, email, age)
VALUES 
  ('John Doe', 'john@example.com', 28),
  ('Jane Smith', 'jane@example.com', 32),
  ('Bob Johnson', 'bob@example.com', 25);
```

### Ví Dụ 3: INSERT FROM SELECT

```sql
INSERT INTO users_backup (name, email, age)
SELECT name, email, age FROM users WHERE age > 25;
```

### Ví Dụ 4: INSERT WITH DEFAULT

```sql
INSERT INTO users (name, email, age, created_at)
VALUES ('Alice', 'alice@example.com', 30, DEFAULT);
```

---

## 🔄 UPDATE - Cập Nhật Dữ Liệu

### Cú Pháp Cơ Bản

```sql
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;
```

### Ví Dụ 1: Simple UPDATE

```sql
UPDATE users
SET age = 29
WHERE name = 'John Doe';
```

### Ví Dụ 2: UPDATE Multiple Columns

```sql
UPDATE users
SET age = 30, email = 'newemail@example.com'
WHERE id = 1;
```

### Ví Dụ 3: UPDATE WITH Expression

```sql
UPDATE users
SET age = age + 1
WHERE age < 30;
```

### Ví Dụ 4: UPDATE FROM SELECT

```sql
UPDATE users
SET age = (SELECT AVG(age) FROM users)
WHERE id = 1;
```

### Ví Dụ 5: UPDATE Multiple Rows

```sql
UPDATE users
SET status = 'active'
WHERE created_at > '2024-01-01';
```

---

## 🗑️ DELETE - Xóa Dữ Liệu

### Cú Pháp Cơ Bản

```sql
DELETE FROM table_name
WHERE condition;
```

### Ví Dụ 1: Simple DELETE

```sql
DELETE FROM users
WHERE id = 1;
```

### Ví Dụ 2: DELETE Multiple Rows

```sql
DELETE FROM users
WHERE age < 18;
```

### Ví Dụ 3: DELETE WITH JOIN

```sql
DELETE FROM orders
WHERE user_id IN (SELECT id FROM users WHERE status = 'inactive');
```

### Ví Dụ 4: DELETE All (Cẩn Thận!)

```sql
DELETE FROM users;  -- Xóa tất cả rows
```

---

## 🔀 UPSERT - INSERT ... ON CONFLICT

### Định Nghĩa

**UPSERT** là INSERT hoặc UPDATE nếu row đã tồn tại.

### Cú Pháp

```sql
INSERT INTO table_name (column1, column2, ...)
VALUES (value1, value2, ...)
ON CONFLICT (unique_column)
DO UPDATE SET column1 = value1, column2 = value2;
```

### Ví Dụ 1: UPSERT Cơ Bản

```sql
INSERT INTO users (id, name, email, age)
VALUES (1, 'John Doe', 'john@example.com', 28)
ON CONFLICT (id)
DO UPDATE SET name = 'John Doe', email = 'john@example.com', age = 28;
```

### Ví Dụ 2: UPSERT Với EXCLUDED

```sql
INSERT INTO users (id, name, email, age)
VALUES (1, 'John Doe', 'john@example.com', 28)
ON CONFLICT (id)
DO UPDATE SET 
  name = EXCLUDED.name,
  email = EXCLUDED.email,
  age = EXCLUDED.age;
```

### Ví Dụ 3: UPSERT Với Condition

```sql
INSERT INTO users (id, name, email, age)
VALUES (1, 'John Doe', 'john@example.com', 28)
ON CONFLICT (id)
DO UPDATE SET age = EXCLUDED.age
WHERE EXCLUDED.age > users.age;
```

---

## 📦 BULK INSERT - Thêm Nhiều Dữ Liệu

### Ưu Điểm

1. **Nhanh hơn** - Một lần thay vì nhiều lần
2. **Ít I/O** - Giảm disk access
3. **Ít logging** - Giảm transaction log

### Ví Dụ 1: Multiple VALUES

```sql
INSERT INTO users (name, email, age)
VALUES 
  ('User1', 'user1@example.com', 25),
  ('User2', 'user2@example.com', 30),
  ('User3', 'user3@example.com', 28),
  ('User4', 'user4@example.com', 32),
  ('User5', 'user5@example.com', 26);
```

### Ví Dụ 2: INSERT FROM SELECT

```sql
INSERT INTO users_archive (name, email, age)
SELECT name, email, age FROM users WHERE created_at < '2023-01-01';
```

### Ví Dụ 3: COPY Command (Nhanh Nhất)

```sql
COPY users (name, email, age)
FROM '/path/to/file.csv'
WITH (FORMAT csv, HEADER true);
```

---

## 📊 COPY - Import/Export Dữ Liệu

### Cú Pháp

```sql
-- Import
COPY table_name (column1, column2, ...)
FROM '/path/to/file.csv'
WITH (FORMAT csv, HEADER true);

-- Export
COPY table_name (column1, column2, ...)
TO '/path/to/file.csv'
WITH (FORMAT csv, HEADER true);
```

### Ví Dụ 1: Import CSV

```sql
COPY users (name, email, age)
FROM '/tmp/users.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');
```

### Ví Dụ 2: Export CSV

```sql
COPY users (id, name, email, age)
TO '/tmp/users_export.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');
```

---

## ⚡ Optimization Tips

### 1. Batch INSERT

```sql
-- ❌ BAD: Nhiều transactions
INSERT INTO users VALUES (...);
INSERT INTO users VALUES (...);
INSERT INTO users VALUES (...);

-- ✅ GOOD: Một transaction
BEGIN;
INSERT INTO users VALUES (...);
INSERT INTO users VALUES (...);
INSERT INTO users VALUES (...);
COMMIT;
```

### 2. Disable Indexes Khi Bulk Insert

```sql
-- Disable indexes
ALTER TABLE users DISABLE TRIGGER ALL;

-- Bulk insert
INSERT INTO users SELECT * FROM temp_users;

-- Enable indexes
ALTER TABLE users ENABLE TRIGGER ALL;
```

### 3. Sử Dụng COPY Thay Vì INSERT

```sql
-- ❌ BAD: INSERT (chậm)
INSERT INTO users VALUES (...);

-- ✅ GOOD: COPY (nhanh)
COPY users FROM '/tmp/users.csv' WITH (FORMAT csv);
```

### 4. Batch UPDATE

```sql
-- ❌ BAD: Nhiều UPDATEs
UPDATE users SET status = 'active' WHERE id = 1;
UPDATE users SET status = 'active' WHERE id = 2;

-- ✅ GOOD: Một UPDATE
UPDATE users SET status = 'active' WHERE id IN (1, 2);
```

### 5. Batch DELETE

```sql
-- ❌ BAD: Nhiều DELETEs
DELETE FROM users WHERE id = 1;
DELETE FROM users WHERE id = 2;

-- ✅ GOOD: Một DELETE
DELETE FROM users WHERE id IN (1, 2);
```

---

## 📊 Tóm Tắt Data Manipulation & Optimization

| Khái Niệm | Mô Tả | Khi Dùng |
|-----------|-------|---------|
| **INSERT** | Thêm dữ liệu | Thêm rows mới |
| **UPDATE** | Cập nhật dữ liệu | Sửa rows hiện tại |
| **DELETE** | Xóa dữ liệu | Xóa rows |
| **UPSERT** | INSERT hoặc UPDATE | Thêm hoặc sửa |
| **BULK INSERT** | Thêm nhiều rows | Thêm hàng ngàn rows |
| **COPY** | Import/Export | Thêm từ file |
| **Batch** | Nhóm operations | Tối ưu hóa performance |

---

## 🎓 Key Takeaways

1. **INSERT** - Thêm dữ liệu
2. **UPDATE** - Cập nhật dữ liệu
3. **DELETE** - Xóa dữ liệu
4. **UPSERT** - INSERT hoặc UPDATE
5. **BULK INSERT** - Thêm nhiều rows
6. **COPY** - Import/Export
7. **Batch** - Tối ưu hóa performance

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL INSERT](https://www.postgresql.org/docs/current/sql-insert.html)
- [PostgreSQL UPDATE](https://www.postgresql.org/docs/current/sql-update.html)
- [PostgreSQL DELETE](https://www.postgresql.org/docs/current/sql-delete.html)
- [PostgreSQL COPY](https://www.postgresql.org/docs/current/sql-copy.html)

---

**Bây giờ bạn đã hiểu Data Manipulation & Optimization! Hãy chuyển sang phần thực hành. 💪**

