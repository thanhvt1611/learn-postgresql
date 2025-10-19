-- 🛒 Project 1: E-commerce Database Design - Solution

-- ============================================
-- Task 1: Tạo Database & Tables
-- ============================================

-- Tạo database
CREATE DATABASE ecommerce_project;
\c ecommerce_project

-- Users Table
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  address TEXT,
  city VARCHAR(50),
  country VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories Table
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products Table
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  category_id INT NOT NULL REFERENCES categories(id),
  price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
  stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
  sku VARCHAR(50) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders Table
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES users(id),
  total_amount DECIMAL(10, 2) NOT NULL,
  status VARCHAR(50) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Order Items Table
CREATE TABLE order_items (
  id SERIAL PRIMARY KEY,
  order_id INT NOT NULL REFERENCES orders(id),
  product_id INT NOT NULL REFERENCES products(id),
  quantity INT NOT NULL CHECK (quantity > 0),
  unit_price DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reviews Table
CREATE TABLE reviews (
  id SERIAL PRIMARY KEY,
  product_id INT NOT NULL REFERENCES products(id),
  user_id INT NOT NULL REFERENCES users(id),
  rating INT CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Task 2: Tạo Indexes
-- ============================================

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

-- ============================================
-- Task 3: Tạo Views
-- ============================================

-- Product Summary View
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

-- User Order Summary View
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

-- Order Details View
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

-- ============================================
-- Task 4: Tạo Stored Procedures
-- ============================================

-- Create Order Procedure
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

-- Get User Orders Procedure
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

-- ============================================
-- Task 5: Thêm Sample Data
-- ============================================

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

-- Orders & Order Items
INSERT INTO orders (user_id, total_amount, status) VALUES
  (1, 1029.98, 'completed'),
  (2, 49.99, 'completed'),
  (3, 1049.97, 'pending');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
  (1, 1, 1, 999.99),
  (1, 2, 1, 29.99),
  (2, 3, 1, 49.99),
  (3, 4, 50, 19.99);

-- Reviews
INSERT INTO reviews (product_id, user_id, rating, comment) VALUES
  (1, 1, 5, 'Excellent laptop!'),
  (2, 1, 4, 'Good mouse'),
  (3, 2, 5, 'Very helpful book'),
  (4, 3, 4, 'Nice quality');

-- ============================================
-- Task 6: Test Queries
-- ============================================

-- Kiểm tra tables
SELECT * FROM users;
SELECT * FROM categories;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM reviews;

-- Kiểm tra views
SELECT * FROM product_summary;
SELECT * FROM user_order_summary;
SELECT * FROM order_details;

-- Kiểm tra indexes
SELECT * FROM pg_indexes WHERE schemaname = 'public';

-- ============================================
-- Task 7: Tối ưu hóa Performance
-- ============================================

-- EXPLAIN queries
EXPLAIN ANALYZE SELECT * FROM products WHERE category_id = 1;
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = 1;
EXPLAIN ANALYZE SELECT * FROM order_details WHERE user_id = 1;

-- Kiểm tra query performance
SELECT 
  p.name,
  COUNT(oi.id) AS times_ordered,
  SUM(oi.quantity) AS total_quantity
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.name
ORDER BY total_quantity DESC;

