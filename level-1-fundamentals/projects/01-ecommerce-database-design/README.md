# 🛒 Project 1: E-commerce Database Design

Thiết kế & xây dựng một database hoàn chỉnh cho hệ thống e-commerce.

## 🎯 Mục Tiêu Project

Sau khi hoàn thành project này, bạn sẽ:
- ✅ Thiết kế schema cho e-commerce
- ✅ Tạo tables với relationships
- ✅ Tạo indexes cho performance
- ✅ Tạo views cho common queries
- ✅ Tạo stored procedures cho business logic
- ✅ Hiểu database design best practices

---

## 📋 Yêu Cầu Project

### 1. Database Schema

Thiết kế database với các tables sau:

#### 1.1 Users Table
```sql
users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  address TEXT,
  city VARCHAR(50),
  country VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
```

#### 1.2 Categories Table
```sql
categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
```

#### 1.3 Products Table
```sql
products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  category_id INT NOT NULL REFERENCES categories(id),
  price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
  stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
  sku VARCHAR(50) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
```

#### 1.4 Orders Table
```sql
orders (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES users(id),
  total_amount DECIMAL(10, 2) NOT NULL,
  status VARCHAR(50) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
```

#### 1.5 Order Items Table
```sql
order_items (
  id SERIAL PRIMARY KEY,
  order_id INT NOT NULL REFERENCES orders(id),
  product_id INT NOT NULL REFERENCES products(id),
  quantity INT NOT NULL CHECK (quantity > 0),
  unit_price DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
```

#### 1.6 Reviews Table
```sql
reviews (
  id SERIAL PRIMARY KEY,
  product_id INT NOT NULL REFERENCES products(id),
  user_id INT NOT NULL REFERENCES users(id),
  rating INT CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
```

---

### 2. Indexes

Tạo indexes cho performance:

```sql
-- Users indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_created_at ON users(created_at);

-- Products indexes
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_products_sku ON products(sku);

-- Orders indexes
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at);

-- Order Items indexes
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- Reviews indexes
CREATE INDEX idx_reviews_product_id ON reviews(product_id);
CREATE INDEX idx_reviews_user_id ON reviews(user_id);
```

---

### 3. Views

Tạo views cho common queries:

#### 3.1 Product Summary View
```sql
CREATE VIEW product_summary AS
SELECT 
  p.id,
  p.name,
  c.name AS category,
  p.price,
  p.stock,
  COUNT(DISTINCT r.id) AS review_count,
  AVG(r.rating) AS avg_rating
FROM products p
JOIN categories c ON p.category_id = c.id
LEFT JOIN reviews r ON p.id = r.product_id
GROUP BY p.id, p.name, c.name, p.price, p.stock;
```

#### 3.2 User Order Summary View
```sql
CREATE VIEW user_order_summary AS
SELECT 
  u.id,
  u.name,
  u.email,
  COUNT(o.id) AS order_count,
  SUM(o.total_amount) AS total_spent,
  AVG(o.total_amount) AS avg_order_value,
  MAX(o.created_at) AS last_order_date
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name, u.email;
```

#### 3.3 Order Details View
```sql
CREATE VIEW order_details AS
SELECT 
  o.id AS order_id,
  u.name AS user_name,
  u.email,
  p.name AS product_name,
  oi.quantity,
  oi.unit_price,
  (oi.quantity * oi.unit_price) AS line_total,
  o.total_amount,
  o.status,
  o.created_at
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id;
```

---

### 4. Stored Procedures

Tạo stored procedures cho business logic:

#### 4.1 Create Order Procedure
```sql
CREATE PROCEDURE create_order(
  p_user_id INT,
  p_product_id INT,
  p_quantity INT
)
AS $$
DECLARE
  v_price DECIMAL;
  v_total DECIMAL;
  v_order_id INT;
BEGIN
  -- Lấy giá sản phẩm
  SELECT price INTO v_price FROM products WHERE id = p_product_id;
  
  -- Tính tổng
  v_total := p_quantity * v_price;
  
  -- Tạo order
  INSERT INTO orders (user_id, total_amount, status)
  VALUES (p_user_id, v_total, 'pending')
  RETURNING id INTO v_order_id;
  
  -- Thêm order item
  INSERT INTO order_items (order_id, product_id, quantity, unit_price)
  VALUES (v_order_id, p_product_id, p_quantity, v_price);
  
  -- Cập nhật stock
  UPDATE products SET stock = stock - p_quantity WHERE id = p_product_id;
  
  COMMIT;
END;
$$ LANGUAGE plpgsql;
```

#### 4.2 Get User Orders Procedure
```sql
CREATE PROCEDURE get_user_orders(p_user_id INT)
AS $$
BEGIN
  SELECT 
    o.id,
    o.total_amount,
    o.status,
    COUNT(oi.id) AS item_count,
    o.created_at
  FROM orders o
  LEFT JOIN order_items oi ON o.id = oi.order_id
  WHERE o.user_id = p_user_id
  GROUP BY o.id, o.total_amount, o.status, o.created_at
  ORDER BY o.created_at DESC;
END;
$$ LANGUAGE plpgsql;
```

---

### 5. Sample Data

Thêm sample data:

```sql
-- Categories
INSERT INTO categories (name, description) VALUES
  ('Electronics', 'Electronic devices'),
  ('Books', 'Books and publications'),
  ('Clothing', 'Apparel and accessories');

-- Products
INSERT INTO products (name, description, category_id, price, stock, sku) VALUES
  ('Laptop', 'High-performance laptop', 1, 999.99, 10, 'LAPTOP001'),
  ('Mouse', 'Wireless mouse', 1, 29.99, 50, 'MOUSE001'),
  ('PostgreSQL Guide', 'Learn PostgreSQL', 2, 49.99, 20, 'BOOK001'),
  ('T-Shirt', 'Cotton t-shirt', 3, 19.99, 100, 'TSHIRT001');

-- Users
INSERT INTO users (name, email, phone, address, city, country) VALUES
  ('John Doe', 'john@example.com', '123456789', '123 Main St', 'New York', 'USA'),
  ('Jane Smith', 'jane@example.com', '987654321', '456 Oak Ave', 'Los Angeles', 'USA'),
  ('Bob Johnson', 'bob@example.com', '555555555', '789 Pine Rd', 'Chicago', 'USA');
```

---

## 📝 Tasks

- [ ] Task 1: Tạo database & tables
- [ ] Task 2: Tạo indexes
- [ ] Task 3: Tạo views
- [ ] Task 4: Tạo stored procedures
- [ ] Task 5: Thêm sample data
- [ ] Task 6: Viết test queries
- [ ] Task 7: Tối ưu hóa performance

---

## 🎓 Learning Outcomes

Sau khi hoàn thành project này, bạn sẽ hiểu:
- ✅ Database design principles
- ✅ Relationships & constraints
- ✅ Indexes & performance
- ✅ Views & stored procedures
- ✅ Sample data & testing

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL CREATE TABLE](https://www.postgresql.org/docs/current/sql-createtable.html)
- [PostgreSQL Constraints](https://www.postgresql.org/docs/current/ddl-constraints.html)
- [PostgreSQL Indexes](https://www.postgresql.org/docs/current/indexes.html)

---

**Bây giờ hãy bắt đầu project! 🚀**

