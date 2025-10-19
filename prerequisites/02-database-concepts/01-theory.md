# 📚 Database Concepts - Lý Thuyết

Hiểu các khái niệm cơ bản về cấu trúc database, tables, schemas, và relationships.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu cấu trúc database (tables, columns, rows)
- ✅ Biết các loại data types cơ bản
- ✅ Hiểu Primary Keys và Foreign Keys
- ✅ Biết các loại relationships (1-to-1, 1-to-many, many-to-many)
- ✅ Hiểu Schemas và cách tổ chức database
- ✅ Biết về Constraints và tại sao chúng quan trọng

---

## 🗂️ Cấu Trúc Database

### Database Hierarchy

```
Database Server (PostgreSQL)
    ├── Database 1 (learning)
    │   ├── Schema (public)
    │   │   ├── Table (users)
    │   │   │   ├── Column (id, name, email, age)
    │   │   │   └── Rows (data)
    │   │   └── Table (orders)
    │   │       ├── Column (id, user_id, product_name, total_amount)
    │   │       └── Rows (data)
    │   └── Schema (archive)
    │       └── Table (old_users)
    └── Database 2 (production)
```

### Các Thành Phần Chính

| Thành Phần | Mô Tả | Ví Dụ |
|-----------|-------|-------|
| **Database** | Tập hợp các tables & schemas | learning, production |
| **Schema** | Tập hợp các tables liên quan | public, archive |
| **Table** | Tập hợp các rows & columns | users, orders |
| **Column** | Một trường dữ liệu | id, name, email |
| **Row** | Một bản ghi dữ liệu | (1, 'John', 'john@example.com') |
| **Data Type** | Loại dữ liệu của column | INTEGER, VARCHAR, DATE |

---

## 📋 Tables & Columns

### Ví Dụ: Table Users

```
Table: users
┌────┬──────────────┬──────────────────────┬─────┐
│ id │ name         │ email                │ age │
├────┼──────────────┼──────────────────────┼─────┤
│ 1  │ John Doe     │ john@example.com     │ 28  │
│ 2  │ Jane Smith   │ jane@example.com     │ 32  │
│ 3  │ Bob Johnson  │ bob@example.com      │ 25  │
└────┴──────────────┴──────────────────────┴─────┘

Columns: id, name, email, age
Rows: 3 rows
```

### Ví Dụ: Table Orders

```
Table: orders
┌────┬─────────┬──────────────┬──────────────┐
│ id │ user_id │ product_name │ total_amount │
├────┼─────────┼──────────────┼──────────────┤
│ 1  │ 1       │ Laptop       │ 999.99       │
│ 2  │ 1       │ Mouse        │ 29.99        │
│ 3  │ 2       │ Keyboard     │ 79.99        │
└────┴─────────┴──────────────┴──────────────┘

Columns: id, user_id, product_name, total_amount
Rows: 3 rows
```

---

## 🔑 Primary Keys (PK)

### Định Nghĩa

**Primary Key** là một column (hoặc tập hợp columns) mà:
- ✅ Định danh duy nhất cho mỗi row
- ✅ Không thể NULL
- ✅ Không thể trùng lặp
- ✅ Chỉ có một PK cho mỗi table

### Ví Dụ

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,  -- id là Primary Key
    name VARCHAR(100),
    email VARCHAR(100)
);

-- id = 1, 2, 3, ... (mỗi id là duy nhất)
```

### Tại Sao Primary Key Quan Trọng?

1. **Định danh duy nhất** - Mỗi row có ID riêng
2. **Tìm kiếm nhanh** - Tìm row theo PK rất nhanh
3. **Tránh trùng lặp** - Không thể có 2 rows với cùng PK
4. **Relationships** - Dùng để liên kết với tables khác

---

## 🔗 Foreign Keys (FK)

### Định Nghĩa

**Foreign Key** là một column mà:
- ✅ Tham chiếu đến Primary Key của table khác
- ✅ Tạo mối quan hệ giữa 2 tables
- ✅ Đảm bảo data integrity

### Ví Dụ

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),  -- FK tham chiếu đến users.id
    product_name VARCHAR(100)
);

-- orders.user_id phải tồn tại trong users.id
```

### Diagram

```
users table                orders table
┌────┬──────────┐        ┌────┬─────────┬──────────────┐
│ id │ name     │        │ id │ user_id │ product_name │
├────┼──────────┤        ├────┼─────────┼──────────────┤
│ 1  │ John     │◄───────│ 1  │ 1       │ Laptop       │
│ 2  │ Jane     │◄───────│ 2  │ 2       │ Keyboard     │
│ 3  │ Bob      │◄───────│ 3  │ 1       │ Mouse        │
└────┴──────────┘        └────┴─────────┴──────────────┘
  PK                        FK (tham chiếu đến users.id)
```

---

## 🔄 Relationships (Mối Quan Hệ)

### 1. One-to-One (1:1)

**Định nghĩa:** Một row trong table A liên kết với một row trong table B.

**Ví dụ:** Một user có một profile

```
users table              user_profiles table
┌────┬──────────┐      ┌────┬─────────┬──────────────┐
│ id │ name     │      │ id │ user_id │ bio          │
├────┼──────────┤      ├────┼─────────┼──────────────┤
│ 1  │ John     │◄─────│ 1  │ 1       │ Software Dev │
│ 2  │ Jane     │◄─────│ 2  │ 2       │ Designer     │
└────┴──────────┘      └────┴─────────┴──────────────┘
```

### 2. One-to-Many (1:N)

**Định nghĩa:** Một row trong table A liên kết với nhiều rows trong table B.

**Ví dụ:** Một user có nhiều orders

```
users table              orders table
┌────┬──────────┐      ┌────┬─────────┬──────────────┐
│ id │ name     │      │ id │ user_id │ product_name │
├────┼──────────┤      ├────┼─────────┼──────────────┤
│ 1  │ John     │◄─────│ 1  │ 1       │ Laptop       │
│    │          │◄─────│ 2  │ 1       │ Mouse        │
│ 2  │ Jane     │◄─────│ 3  │ 2       │ Keyboard     │
└────┴──────────┘      └────┴─────────┴──────────────┘
```

### 3. Many-to-Many (N:M)

**Định nghĩa:** Nhiều rows trong table A liên kết với nhiều rows trong table B.

**Ví dụ:** Nhiều students có nhiều courses

```
students table          enrollments table       courses table
┌────┬──────────┐      ┌────┬──────────┬──────────┐      ┌────┬──────────┐
│ id │ name     │      │ id │ student_ │ course_  │      │ id │ name     │
├────┼──────────┤      │    │ id       │ id       │      ├────┼──────────┤
│ 1  │ John     │◄─────│ 1  │ 1        │ 1        │─────►│ 1  │ Python   │
│    │          │◄─────│ 2  │ 1        │ 2        │      │    │          │
│ 2  │ Jane     │◄─────│ 3  │ 2        │ 1        │─────►│ 2  │ SQL      │
└────┴──────────┘      └────┴──────────┴──────────┘      └────┴──────────┘
                       (Junction Table)
```

---

## 📊 Data Types Cơ Bản

### Numeric Types

| Type | Mô Tả | Ví Dụ |
|------|-------|-------|
| **SERIAL** | Auto-increment integer | 1, 2, 3, ... |
| **INTEGER** | Số nguyên | 25, 100, -50 |
| **BIGINT** | Số nguyên lớn | 9223372036854775807 |
| **DECIMAL(10,2)** | Số thập phân | 99.99, 1000.50 |
| **FLOAT** | Số thực | 3.14, 2.71 |

### Text Types

| Type | Mô Tả | Ví Dụ |
|------|-------|-------|
| **VARCHAR(n)** | Text có độ dài tối đa n | 'John', 'john@example.com' |
| **TEXT** | Text không giới hạn độ dài | Nội dung bài viết dài |
| **CHAR(n)** | Text cố định độ dài n | 'US', 'NY' |

### Date/Time Types

| Type | Mô Tả | Ví Dụ |
|------|-------|-------|
| **DATE** | Ngày | '2024-01-15' |
| **TIME** | Giờ | '14:30:00' |
| **TIMESTAMP** | Ngày và giờ | '2024-01-15 14:30:00' |
| **INTERVAL** | Khoảng thời gian | '1 day', '2 hours' |

### Boolean Type

| Type | Mô Tả | Ví Dụ |
|------|-------|-------|
| **BOOLEAN** | True/False | true, false |

---

## 🛡️ Constraints (Ràng Buộc)

### 1. PRIMARY KEY

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,  -- Không thể NULL, không thể trùng
    name VARCHAR(100)
);
```

### 2. UNIQUE

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) UNIQUE  -- Không thể trùng, nhưng có thể NULL
);
```

### 3. NOT NULL

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL  -- Bắt buộc phải có giá trị
);
```

### 4. FOREIGN KEY

```sql
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id)  -- Phải tồn tại trong users
);
```

### 5. CHECK

```sql
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    price DECIMAL(10, 2) CHECK (price > 0)  -- Giá phải > 0
);
```

### 6. DEFAULT

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Giá trị mặc định
);
```

---

## 📐 Schemas

### Định Nghĩa

**Schema** là một tập hợp các tables, views, functions, ... được tổ chức theo logic.

### Ví Dụ

```sql
-- Tạo schema
CREATE SCHEMA archive;

-- Tạo table trong schema
CREATE TABLE archive.old_users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

-- Query từ schema
SELECT * FROM archive.old_users;
```

### Tại Sao Sử Dụng Schemas?

1. **Tổ chức** - Nhóm các tables liên quan
2. **Tránh xung đột** - Có thể có tables cùng tên trong schemas khác
3. **Bảo mật** - Kiểm soát quyền truy cập theo schema
4. **Quản lý** - Dễ dàng quản lý các phần của database

---

## 🔍 Normalization (Chuẩn Hóa)

### Tại Sao Chuẩn Hóa?

1. **Tránh trùng lặp dữ liệu** - Lưu trữ dữ liệu một lần
2. **Dễ bảo trì** - Cập nhật dữ liệu ở một chỗ
3. **Tiết kiệm không gian** - Giảm kích thước database
4. **Tính toàn vẹn dữ liệu** - Tránh inconsistency

### Ví Dụ: Không Chuẩn Hóa (❌ BAD)

```
users table
┌────┬──────────┬──────────────────────────────────────┐
│ id │ name     │ orders                               │
├────┼──────────┼──────────────────────────────────────┤
│ 1  │ John     │ Laptop (999.99), Mouse (29.99)       │
│ 2  │ Jane     │ Keyboard (79.99)                     │
└────┴──────────┴──────────────────────────────────────┘

❌ Vấn đề: Dữ liệu trùng lặp, khó cập nhật
```

### Ví Dụ: Chuẩn Hóa (✅ GOOD)

```
users table                    orders table
┌────┬──────────┐            ┌────┬─────────┬──────────────┐
│ id │ name     │            │ id │ user_id │ product_name │
├────┼──────────┤            ├────┼─────────┼──────────────┤
│ 1  │ John     │◄───────────│ 1  │ 1       │ Laptop       │
│ 2  │ Jane     │◄───────────│ 2  │ 1       │ Mouse        │
└────┴──────────┘            │ 3  │ 2       │ Keyboard     │
                             └────┴─────────┴──────────────┘

✅ Lợi ích: Dữ liệu sạch, dễ cập nhật, tiết kiệm không gian
```

---

## 📚 Tóm Tắt Database Concepts

| Khái Niệm | Mô Tả |
|-----------|-------|
| **Table** | Tập hợp rows & columns |
| **Column** | Một trường dữ liệu |
| **Row** | Một bản ghi dữ liệu |
| **Primary Key** | Định danh duy nhất cho mỗi row |
| **Foreign Key** | Tham chiếu đến PK của table khác |
| **1:1 Relationship** | Một row liên kết với một row |
| **1:N Relationship** | Một row liên kết với nhiều rows |
| **N:M Relationship** | Nhiều rows liên kết với nhiều rows |
| **Constraints** | Ràng buộc dữ liệu (PK, FK, UNIQUE, NOT NULL, CHECK) |
| **Schema** | Tập hợp các tables được tổ chức |
| **Normalization** | Tổ chức dữ liệu để tránh trùng lặp |

---

## 🎓 Key Takeaways

1. **Tables** - Cấu trúc cơ bản để lưu trữ dữ liệu
2. **Primary Keys** - Định danh duy nhất cho mỗi row
3. **Foreign Keys** - Tạo mối quan hệ giữa tables
4. **Relationships** - 1:1, 1:N, N:M
5. **Constraints** - Đảm bảo data integrity
6. **Normalization** - Tổ chức dữ liệu hiệu quả

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL Data Types](https://www.postgresql.org/docs/current/datatype.html)
- [PostgreSQL Constraints](https://www.postgresql.org/docs/current/ddl-constraints.html)
- [PostgreSQL Schemas](https://www.postgresql.org/docs/current/ddl-schemas.html)

---

**Bây giờ bạn đã hiểu database concepts! Hãy chuyển sang phần thực hành. 💪**

