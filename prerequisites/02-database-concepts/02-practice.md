# 🛠️ Database Concepts - Thực Hành

Thực hành tạo tables với Primary Keys, Foreign Keys, và Constraints.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Tạo được tables với Primary Keys
- ✅ Tạo được Foreign Keys để liên kết tables
- ✅ Sử dụng được Constraints (UNIQUE, NOT NULL, CHECK)
- ✅ Hiểu cách dữ liệu được tổ chức
- ✅ Thực hành với 1:1, 1:N, N:M relationships

---

## 📋 Bước 1: Tạo Database & Schema

### Bước 1.1: Kết Nối PostgreSQL

```bash
psql -U postgres
```

### Bước 1.2: Tạo Database

```sql
-- Tạo database mới
CREATE DATABASE ecommerce;

-- Kết nối vào database
\c ecommerce
```

### Bước 1.3: Tạo Schema (Optional)

```sql
-- Tạo schema
CREATE SCHEMA shop;

-- Kiểm tra schemas
\dn
```

---

## 🔑 Bước 2: Tạo Tables Với Primary Keys

### Bước 2.1: Tạo Table Users

```sql
-- Tạo table users với Primary Key
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    age INTEGER CHECK (age >= 18),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Kiểm tra table
\d users
```

**Output:**
```
                                    Table "public.users"
   Column   |            Type             | Collation | Nullable |              Default
------------+-----------------------------+-----------+----------+-----------------------------------
 id         | integer                     |           | not null | nextval('users_id_seq'::regclass)
 name       | character varying(100)      |           | not null |
 email      | character varying(100)      |           | not null |
 age        | integer                     |           |          |
 created_at | timestamp without time zone |           |          | CURRENT_TIMESTAMP
Indexes:
    "users_pkey" PRIMARY KEY, btree (id)
    "users_email_key" UNIQUE CONSTRAINT, btree (email)
Check constraints:
    "users_age_check" CHECK (age >= 18)
```

### Bước 2.2: Tạo Table Categories

```sql
-- Tạo table categories
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- Kiểm tra table
\d categories
```

---

## 🔗 Bước 3: Tạo Tables Với Foreign Keys (1:N)

### Bước 3.1: Tạo Table Products

```sql
-- Tạo table products với Foreign Key
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category_id INTEGER NOT NULL REFERENCES categories(id),
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    stock INTEGER NOT NULL CHECK (stock >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Kiểm tra table
\d products
```

**Output:**
```
                                     Table "public.products"
   Column    |            Type             | Collation | Nullable |               Default
-------------+-----------------------------+-----------+----------+-------------------------------------
 id          | integer                     |           | not null | nextval('products_id_seq'::regclass)
 name        | character varying(100)      |           | not null |
 category_id | integer                     |           | not null |
 price       | numeric(10,2)               |           | not null |
 stock       | integer                     |           | not null |
 created_at  | timestamp without time zone |           |          | CURRENT_TIMESTAMP
Indexes:
    "products_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "products_category_id_fkey" FOREIGN KEY (category_id) REFERENCES categories(id)
Check constraints:
    "products_price_check" CHECK (price > 0)
    "products_stock_check" CHECK (stock >= 0)
```

### Bước 3.2: Tạo Table Orders

```sql
-- Tạo table orders với Foreign Key
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount > 0),
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Kiểm tra table
\d orders
```

---

## 🔄 Bước 4: Tạo Tables Với Many-to-Many Relationship

### Bước 4.1: Tạo Table Order Items (Junction Table)

```sql
-- Tạo table order_items (liên kết orders và products)
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(id),
    product_id INTEGER NOT NULL REFERENCES products(id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price > 0)
);

-- Kiểm tra table
\d order_items
```

---

## 📝 Bước 5: Thêm Sample Data

### Bước 5.1: Thêm Categories

```sql
-- Thêm categories
INSERT INTO categories (name, description) VALUES
('Electronics', 'Electronic devices and gadgets'),
('Books', 'Books and educational materials'),
('Clothing', 'Apparel and fashion items');

-- Kiểm tra
SELECT * FROM categories;
```

### Bước 5.2: Thêm Users

```sql
-- Thêm users
INSERT INTO users (name, email, age) VALUES
('John Doe', 'john@example.com', 28),
('Jane Smith', 'jane@example.com', 32),
('Bob Johnson', 'bob@example.com', 25);

-- Kiểm tra
SELECT * FROM users;
```

### Bước 5.3: Thêm Products

```sql
-- Thêm products
INSERT INTO products (name, category_id, price, stock) VALUES
('Laptop', 1, 999.99, 10),
('Mouse', 1, 29.99, 50),
('Python Book', 2, 39.99, 20),
('T-Shirt', 3, 19.99, 100);

-- Kiểm tra
SELECT * FROM products;
```

### Bước 5.4: Thêm Orders

```sql
-- Thêm orders
INSERT INTO orders (user_id, total_amount, status) VALUES
(1, 1029.98, 'completed'),
(2, 39.99, 'pending'),
(1, 19.99, 'completed');

-- Kiểm tra
SELECT * FROM orders;
```

### Bước 5.5: Thêm Order Items

```sql
-- Thêm order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 999.99),  -- Order 1: 1 Laptop
(1, 2, 1, 29.99),   -- Order 1: 1 Mouse
(2, 3, 1, 39.99),   -- Order 2: 1 Python Book
(3, 4, 1, 19.99);   -- Order 3: 1 T-Shirt

-- Kiểm tra
SELECT * FROM order_items;
```

---

## 🔍 Bước 6: Thực Hành Queries Với Relationships

### Thực Hành 6.1: Query Với Foreign Keys

```sql
-- Lấy tất cả products với category name
SELECT p.id, p.name, c.name AS category, p.price
FROM products p
JOIN categories c ON p.category_id = c.id;
```

**Output:**
```
 id |     name     |  category   | price
----+--------------+-------------+--------
  1 | Laptop       | Electronics | 999.99
  2 | Mouse        | Electronics |  29.99
  3 | Python Book  | Books       |  39.99
  4 | T-Shirt      | Clothing    |  19.99
```

### Thực Hành 6.2: Query Orders Với User Info

```sql
-- Lấy tất cả orders với user name
SELECT o.id, u.name, o.total_amount, o.status
FROM orders o
JOIN users u ON o.user_id = u.id;
```

### Thực Hành 6.3: Query Order Items Với Product Info

```sql
-- Lấy chi tiết order items
SELECT oi.id, o.id AS order_id, p.name, oi.quantity, oi.unit_price
FROM order_items oi
JOIN orders o ON oi.order_id = o.id
JOIN products p ON oi.product_id = p.id;
```

---

## 🛡️ Bước 7: Thực Hành Constraints

### Thực Hành 7.1: NOT NULL Constraint

```sql
-- ❌ Lỗi: name không thể NULL
INSERT INTO users (email, age) VALUES ('test@example.com', 25);

-- ✅ Đúng: phải có name
INSERT INTO users (name, email, age) VALUES ('Test User', 'test@example.com', 25);
```

### Thực Hành 7.2: UNIQUE Constraint

```sql
-- ❌ Lỗi: email đã tồn tại
INSERT INTO users (name, email, age) VALUES ('Another John', 'john@example.com', 30);

-- ✅ Đúng: email mới
INSERT INTO users (name, email, age) VALUES ('Another John', 'anotherjohn@example.com', 30);
```

### Thực Hành 7.3: CHECK Constraint

```sql
-- ❌ Lỗi: age < 18
INSERT INTO users (name, email, age) VALUES ('Young User', 'young@example.com', 15);

-- ❌ Lỗi: price <= 0
INSERT INTO products (name, category_id, price, stock) VALUES ('Free Item', 1, 0, 10);

-- ✅ Đúng: age >= 18, price > 0
INSERT INTO users (name, email, age) VALUES ('Adult User', 'adult@example.com', 21);
INSERT INTO products (name, category_id, price, stock) VALUES ('Paid Item', 1, 9.99, 10);
```

### Thực Hành 7.4: Foreign Key Constraint

```sql
-- ❌ Lỗi: category_id không tồn tại
INSERT INTO products (name, category_id, price, stock) VALUES ('Item', 999, 10.00, 5);

-- ✅ Đúng: category_id tồn tại
INSERT INTO products (name, category_id, price, stock) VALUES ('Item', 1, 10.00, 5);
```

---

## 📊 Bước 8: Xem Cấu Trúc Database

### Thực Hành 8.1: Liệt Kê Tất Cả Tables

```sql
-- Liệt kê tất cả tables
\dt

-- Hoặc query từ system catalog
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public';
```

### Thực Hành 8.2: Xem Chi Tiết Table

```sql
-- Xem chi tiết table users
\d users

-- Xem chi tiết table products
\d products
```

### Thực Hành 8.3: Xem Foreign Keys

```sql
-- Query để xem tất cả foreign keys
SELECT 
    constraint_name,
    table_name,
    column_name,
    referenced_table_name,
    referenced_column_name
FROM information_schema.key_column_usage
WHERE referenced_table_name IS NOT NULL;
```

---

## 🔄 Bước 9: Thực Hành Relationships

### Thực Hành 9.1: 1:N Relationship (Users - Orders)

```sql
-- Lấy tất cả orders của user 1
SELECT * FROM orders WHERE user_id = 1;

-- Lấy user info với số lượng orders
SELECT u.id, u.name, COUNT(o.id) AS order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;
```

### Thực Hành 9.2: N:M Relationship (Orders - Products)

```sql
-- Lấy tất cả products trong order 1
SELECT p.id, p.name, oi.quantity, oi.unit_price
FROM order_items oi
JOIN products p ON oi.product_id = p.id
WHERE oi.order_id = 1;

-- Lấy tất cả orders chứa product 1
SELECT DISTINCT o.id, o.total_amount
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
WHERE oi.product_id = 1;
```

---

## ✅ Checklist Thực Hành

- [ ] Tạo database "ecommerce"
- [ ] Tạo tables: users, categories, products, orders, order_items
- [ ] Thêm Primary Keys cho tất cả tables
- [ ] Thêm Foreign Keys (category_id, user_id, product_id, order_id)
- [ ] Thêm Constraints (UNIQUE, NOT NULL, CHECK)
- [ ] Thêm sample data
- [ ] Thực hành queries với JOINs
- [ ] Thực hành Constraints (test lỗi)
- [ ] Xem cấu trúc database
- [ ] Thực hành 1:N relationships
- [ ] Thực hành N:M relationships

---

## 💡 Tips

1. **Kiểm tra cấu trúc** - Sử dụng `\d table_name` để xem chi tiết
2. **Test constraints** - Cố tình tạo lỗi để hiểu constraints
3. **Sử dụng JOINs** - Kết hợp data từ nhiều tables
4. **Ghi chú** - Ghi lại cấu trúc database

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

