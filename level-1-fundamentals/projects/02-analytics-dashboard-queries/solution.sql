-- 📊 Project 2: Analytics Dashboard Queries - Solution

-- ============================================
-- Task 1: Sales Analytics
-- ============================================

-- Total Sales by Category
SELECT 
  c.name AS category,
  COUNT(DISTINCT o.id) AS order_count,
  SUM(oi.quantity) AS total_quantity,
  SUM(oi.quantity * oi.unit_price) AS total_revenue,
  AVG(oi.unit_price) AS avg_price
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.id
GROUP BY c.id, c.name
ORDER BY total_revenue DESC NULLS LAST;

-- Top Products by Revenue
SELECT 
  p.id,
  p.name,
  c.name AS category,
  COUNT(DISTINCT oi.order_id) AS times_ordered,
  SUM(oi.quantity) AS total_quantity,
  SUM(oi.quantity * oi.unit_price) AS total_revenue,
  AVG(oi.unit_price) AS avg_price
FROM products p
JOIN categories c ON p.category_id = c.id
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.name, c.id, c.name
ORDER BY total_revenue DESC NULLS LAST
LIMIT 10;

-- Sales Trend by Date
SELECT 
  DATE(o.created_at) AS order_date,
  COUNT(DISTINCT o.id) AS order_count,
  SUM(o.total_amount) AS daily_revenue,
  AVG(o.total_amount) AS avg_order_value,
  COUNT(DISTINCT o.user_id) AS unique_customers
FROM orders o
GROUP BY DATE(o.created_at)
ORDER BY order_date DESC;

-- ============================================
-- Task 2: Customer Analytics
-- ============================================

-- Customer Segmentation
SELECT 
  u.id,
  u.name,
  u.email,
  COUNT(o.id) AS order_count,
  SUM(o.total_amount) AS total_spent,
  AVG(o.total_amount) AS avg_order_value,
  MAX(o.created_at) AS last_order_date,
  CASE 
    WHEN SUM(o.total_amount) > 1000 THEN 'VIP'
    WHEN SUM(o.total_amount) > 500 THEN 'Premium'
    WHEN SUM(o.total_amount) > 100 THEN 'Regular'
    ELSE 'New'
  END AS customer_segment
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name, u.email
ORDER BY total_spent DESC NULLS LAST;

-- Customer Lifetime Value
SELECT 
  u.id,
  u.name,
  u.email,
  u.created_at AS signup_date,
  COUNT(o.id) AS total_orders,
  SUM(o.total_amount) AS lifetime_value,
  AVG(o.total_amount) AS avg_order_value,
  MAX(o.created_at) AS last_purchase_date
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name, u.email, u.created_at
ORDER BY lifetime_value DESC NULLS LAST;

-- Repeat Customer Rate
SELECT 
  COUNT(DISTINCT CASE WHEN order_count > 1 THEN user_id END) AS repeat_customers,
  COUNT(DISTINCT user_id) AS total_customers,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN order_count > 1 THEN user_id END) / 
    COUNT(DISTINCT user_id), 2) AS repeat_rate_percent
FROM (
  SELECT user_id, COUNT(*) AS order_count
  FROM orders
  GROUP BY user_id
) subquery;

-- ============================================
-- Task 3: Product Analytics
-- ============================================

-- Product Performance
SELECT 
  p.id,
  p.name,
  p.price,
  p.stock,
  COUNT(DISTINCT oi.order_id) AS times_ordered,
  SUM(oi.quantity) AS total_sold,
  SUM(oi.quantity * oi.unit_price) AS total_revenue,
  COUNT(DISTINCT r.id) AS review_count,
  AVG(r.rating) AS avg_rating
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN reviews r ON p.id = r.product_id
GROUP BY p.id, p.name, p.price, p.stock
ORDER BY total_revenue DESC NULLS LAST;

-- Low Stock Products
SELECT 
  p.id,
  p.name,
  p.stock,
  p.price,
  COUNT(DISTINCT oi.order_id) AS monthly_orders,
  CASE 
    WHEN p.stock < 5 THEN 'Critical'
    WHEN p.stock < 20 THEN 'Low'
    ELSE 'Adequate'
  END AS stock_status
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
WHERE p.stock < 50
GROUP BY p.id, p.name, p.stock, p.price
ORDER BY p.stock ASC;

-- Product Rating Distribution
SELECT 
  p.id,
  p.name,
  COUNT(CASE WHEN r.rating = 5 THEN 1 END) AS five_star,
  COUNT(CASE WHEN r.rating = 4 THEN 1 END) AS four_star,
  COUNT(CASE WHEN r.rating = 3 THEN 1 END) AS three_star,
  COUNT(CASE WHEN r.rating = 2 THEN 1 END) AS two_star,
  COUNT(CASE WHEN r.rating = 1 THEN 1 END) AS one_star,
  COUNT(r.id) AS total_reviews,
  AVG(r.rating) AS avg_rating
FROM products p
LEFT JOIN reviews r ON p.id = r.product_id
GROUP BY p.id, p.name
ORDER BY avg_rating DESC NULLS LAST;

-- ============================================
-- Task 4: Order Analytics
-- ============================================

-- Order Status Distribution
SELECT 
  status,
  COUNT(*) AS order_count,
  SUM(total_amount) AS total_revenue,
  AVG(total_amount) AS avg_order_value,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM orders
GROUP BY status
ORDER BY order_count DESC;

-- Average Order Value Trend
SELECT 
  DATE_TRUNC('month', o.created_at) AS month,
  COUNT(o.id) AS order_count,
  SUM(o.total_amount) AS total_revenue,
  AVG(o.total_amount) AS avg_order_value,
  MIN(o.total_amount) AS min_order_value,
  MAX(o.total_amount) AS max_order_value
FROM orders o
GROUP BY DATE_TRUNC('month', o.created_at)
ORDER BY month DESC;

-- Orders with Multiple Items
SELECT 
  o.id,
  u.name,
  COUNT(oi.id) AS item_count,
  SUM(oi.quantity) AS total_quantity,
  o.total_amount,
  o.status,
  o.created_at
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id, u.name, o.total_amount, o.status, o.created_at
HAVING COUNT(oi.id) > 1
ORDER BY item_count DESC;

-- ============================================
-- Task 5: Dashboard Views
-- ============================================

-- Sales Summary View
CREATE VIEW sales_summary AS
SELECT 
  COUNT(DISTINCT id) AS total_orders,
  SUM(total_amount) AS total_revenue,
  AVG(total_amount) AS avg_order_value,
  COUNT(DISTINCT user_id) AS unique_customers
FROM orders;

-- Top Categories View
CREATE VIEW top_categories AS
SELECT 
  c.name,
  COUNT(DISTINCT o.id) AS order_count,
  SUM(oi.quantity * oi.unit_price) AS revenue
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.id
GROUP BY c.id, c.name
ORDER BY revenue DESC NULLS LAST
LIMIT 5;

-- Customer Segments View
CREATE VIEW customer_segments AS
SELECT 
  CASE 
    WHEN SUM(o.total_amount) > 1000 THEN 'VIP'
    WHEN SUM(o.total_amount) > 500 THEN 'Premium'
    WHEN SUM(o.total_amount) > 100 THEN 'Regular'
    ELSE 'New'
  END AS segment,
  COUNT(DISTINCT u.id) AS customer_count,
  SUM(o.total_amount) AS total_revenue
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY segment;

-- ============================================
-- Task 6: Test Dashboard Views
-- ============================================

SELECT * FROM sales_summary;
SELECT * FROM top_categories;
SELECT * FROM customer_segments;

-- ============================================
-- Task 7: Performance Optimization
-- ============================================

-- EXPLAIN queries
EXPLAIN ANALYZE SELECT * FROM sales_summary;
EXPLAIN ANALYZE SELECT * FROM top_categories;
EXPLAIN ANALYZE SELECT * FROM customer_segments;

-- Kiểm tra indexes
SELECT * FROM pg_indexes WHERE schemaname = 'public' ORDER BY tablename;

