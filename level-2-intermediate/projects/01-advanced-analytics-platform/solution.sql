-- ============================================
-- Project 1: Advanced Analytics Platform
-- ============================================

-- Task 1: Create Database & Tables
-- ============================================

CREATE DATABASE IF NOT EXISTS analytics_platform;
\c analytics_platform

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  country VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products table
CREATE TABLE IF NOT EXISTS products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  category VARCHAR(100),
  price DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES users(id),
  total_amount DECIMAL(10, 2) NOT NULL,
  status VARCHAR(50) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Order items table
CREATE TABLE IF NOT EXISTS order_items (
  id SERIAL PRIMARY KEY,
  order_id INT NOT NULL REFERENCES orders(id),
  product_id INT NOT NULL REFERENCES products(id),
  quantity INT NOT NULL,
  unit_price DECIMAL(10, 2) NOT NULL
);

-- Analytics events table
CREATE TABLE IF NOT EXISTS analytics_events (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES users(id),
  event_type VARCHAR(100) NOT NULL,
  event_data JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_created_at ON orders(created_at);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_analytics_events_user_id ON analytics_events(user_id);
CREATE INDEX idx_analytics_events_created_at ON analytics_events(created_at);
CREATE INDEX idx_analytics_events_data ON analytics_events USING GIN (event_data);

-- Task 2: Insert Sample Data
-- ============================================

INSERT INTO users (name, email, country, created_at) VALUES
  ('Nguyen Van A', 'a@example.com', 'Vietnam', '2024-01-01'),
  ('Jean Dupont', 'jean@example.com', 'France', '2024-02-01'),
  ('John Smith', 'john@example.com', 'USA', '2024-03-01'),
  ('Maria Garcia', 'maria@example.com', 'Spain', '2024-04-01'),
  ('Li Wei', 'li@example.com', 'China', '2024-05-01');

INSERT INTO products (name, category, price, created_at) VALUES
  ('Laptop', 'Electronics', 1200, '2024-01-01'),
  ('Mouse', 'Electronics', 50, '2024-01-01'),
  ('Keyboard', 'Electronics', 150, '2024-01-01'),
  ('Monitor', 'Electronics', 400, '2024-01-01'),
  ('Headphones', 'Electronics', 200, '2024-01-01');

INSERT INTO orders (user_id, total_amount, status, created_at) VALUES
  (1, 1250, 'completed', '2024-01-15'),
  (1, 200, 'completed', '2024-02-10'),
  (2, 1350, 'completed', '2024-02-20'),
  (3, 600, 'completed', '2024-03-10'),
  (4, 1450, 'completed', '2024-04-05'),
  (5, 250, 'completed', '2024-05-15');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
  (1, 1, 1, 1200),
  (1, 2, 1, 50),
  (2, 3, 1, 150),
  (2, 5, 1, 50),
  (3, 1, 1, 1200),
  (3, 2, 1, 150),
  (4, 4, 1, 400),
  (4, 5, 1, 200),
  (5, 1, 1, 1200),
  (5, 3, 1, 150),
  (5, 5, 1, 100),
  (6, 2, 5, 50);

INSERT INTO analytics_events (user_id, event_type, event_data, created_at) VALUES
  (1, 'page_view', '{"page": "products", "duration": 120}', '2024-01-15'),
  (1, 'add_to_cart', '{"product_id": 1, "quantity": 1}', '2024-01-15'),
  (1, 'purchase', '{"order_id": 1, "amount": 1250}', '2024-01-15'),
  (2, 'page_view', '{"page": "products", "duration": 180}', '2024-02-20'),
  (2, 'add_to_cart', '{"product_id": 1, "quantity": 1}', '2024-02-20'),
  (2, 'purchase', '{"order_id": 3, "amount": 1350}', '2024-02-20'),
  (3, 'page_view', '{"page": "products", "duration": 90}', '2024-03-10'),
  (3, 'purchase', '{"order_id": 4, "amount": 600}', '2024-03-10');

-- Task 3: Window Function Queries
-- ============================================

-- User ranking by spending
SELECT 
  u.name,
  SUM(o.total_amount) AS total_spent,
  RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS spending_rank,
  ROW_NUMBER() OVER (ORDER BY SUM(o.total_amount) DESC) AS row_num
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name
ORDER BY spending_rank;

-- Running total by date
SELECT 
  DATE(created_at) AS order_date,
  SUM(total_amount) AS daily_revenue,
  SUM(SUM(total_amount)) OVER (ORDER BY DATE(created_at)) AS running_total
FROM orders
GROUP BY DATE(created_at)
ORDER BY order_date;

-- Task 4: CTE Queries
-- ============================================

-- User segmentation
WITH user_stats AS (
  SELECT 
    u.id,
    u.name,
    COUNT(o.id) AS order_count,
    SUM(o.total_amount) AS total_spent,
    AVG(o.total_amount) AS avg_order
  FROM users u
  LEFT JOIN orders o ON u.id = o.user_id
  GROUP BY u.id, u.name
),
user_segments AS (
  SELECT 
    id,
    name,
    order_count,
    total_spent,
    CASE 
      WHEN total_spent > 1000 THEN 'VIP'
      WHEN total_spent > 500 THEN 'Premium'
      WHEN total_spent > 100 THEN 'Regular'
      ELSE 'New'
    END AS segment
  FROM user_stats
)
SELECT * FROM user_segments ORDER BY total_spent DESC NULLS LAST;

-- Product performance
WITH product_revenue AS (
  SELECT 
    p.id,
    p.name,
    p.category,
    SUM(oi.quantity * oi.unit_price) AS revenue,
    COUNT(DISTINCT oi.order_id) AS order_count
  FROM products p
  LEFT JOIN order_items oi ON p.id = oi.product_id
  GROUP BY p.id, p.name, p.category
),
ranked_products AS (
  SELECT 
    name,
    category,
    revenue,
    order_count,
    RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS category_rank
  FROM product_revenue
)
SELECT * FROM ranked_products WHERE category_rank <= 3;

-- Task 5: JSON Analytics
-- ============================================

-- Event aggregation
SELECT 
  event_type,
  COUNT(*) AS event_count,
  jsonb_object_agg(event_type, COUNT(*)) AS event_stats
FROM analytics_events
GROUP BY event_type;

-- User event summary
SELECT 
  u.name,
  COUNT(ae.id) AS total_events,
  COUNT(CASE WHEN ae.event_type = 'purchase' THEN 1 END) AS purchases,
  COUNT(CASE WHEN ae.event_type = 'page_view' THEN 1 END) AS page_views
FROM users u
LEFT JOIN analytics_events ae ON u.id = ae.user_id
GROUP BY u.id, u.name;

-- Task 6: Create Views
-- ============================================

-- User analytics view
CREATE OR REPLACE VIEW v_user_analytics AS
WITH user_stats AS (
  SELECT 
    u.id,
    u.name,
    u.email,
    u.country,
    COUNT(o.id) AS order_count,
    SUM(o.total_amount) AS total_spent,
    AVG(o.total_amount) AS avg_order,
    MAX(o.created_at) AS last_order_date
  FROM users u
  LEFT JOIN orders o ON u.id = o.user_id
  GROUP BY u.id, u.name, u.email, u.country
)
SELECT 
  id,
  name,
  email,
  country,
  order_count,
  total_spent,
  avg_order,
  last_order_date,
  CASE 
    WHEN total_spent > 1000 THEN 'VIP'
    WHEN total_spent > 500 THEN 'Premium'
    WHEN total_spent > 100 THEN 'Regular'
    ELSE 'New'
  END AS segment
FROM user_stats;

-- Product analytics view
CREATE OR REPLACE VIEW v_product_analytics AS
SELECT 
  p.id,
  p.name,
  p.category,
  p.price,
  COUNT(DISTINCT oi.order_id) AS times_ordered,
  SUM(oi.quantity) AS total_quantity,
  SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.name, p.category, p.price;

-- Order analytics view
CREATE OR REPLACE VIEW v_order_analytics AS
SELECT 
  DATE(o.created_at) AS order_date,
  COUNT(*) AS order_count,
  SUM(o.total_amount) AS daily_revenue,
  AVG(o.total_amount) AS avg_order_value,
  MIN(o.total_amount) AS min_order,
  MAX(o.total_amount) AS max_order
FROM orders o
GROUP BY DATE(o.created_at);

-- Task 7: Verify Results
-- ============================================

-- Check user analytics
SELECT * FROM v_user_analytics ORDER BY total_spent DESC NULLS LAST;

-- Check product analytics
SELECT * FROM v_product_analytics ORDER BY total_revenue DESC NULLS LAST;

-- Check order analytics
SELECT * FROM v_order_analytics ORDER BY order_date DESC;

-- ============================================
-- Project 1 Complete!
-- ============================================

