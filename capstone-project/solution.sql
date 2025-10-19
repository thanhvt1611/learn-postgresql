-- ============================================
-- Capstone Project: Global E-Commerce Platform
-- ============================================

-- Task 1: Database Design & Schema
-- ============================================

CREATE DATABASE IF NOT EXISTS ecommerce_global;
\c ecommerce_global

-- Create companies table
CREATE TABLE companies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL UNIQUE,
  type VARCHAR(50),
  country VARCHAR(100),
  rating DECIMAL(3, 2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create users table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID REFERENCES companies(id),
  email VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(255),
  role VARCHAR(50) DEFAULT 'customer',
  status VARCHAR(50) DEFAULT 'active',
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create categories table
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  description TEXT,
  parent_id INT REFERENCES categories(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create products table
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(id),
  category_id INT NOT NULL REFERENCES categories(id),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2),
  tags TEXT[],
  metadata JSONB DEFAULT '{}',
  search_vector tsvector,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create inventory table
CREATE TABLE inventory (
  id SERIAL PRIMARY KEY,
  product_id UUID NOT NULL REFERENCES products(id),
  quantity INT DEFAULT 0,
  reserved INT DEFAULT 0,
  warehouse_location VARCHAR(255),
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create orders table
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  status VARCHAR(50) DEFAULT 'pending',
  total_amount DECIMAL(12, 2),
  shipping_address JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create order_items table
CREATE TABLE order_items (
  id SERIAL PRIMARY KEY,
  order_id UUID NOT NULL REFERENCES orders(id),
  product_id UUID NOT NULL REFERENCES products(id),
  quantity INT,
  unit_price DECIMAL(10, 2),
  total_price DECIMAL(12, 2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create payments table
CREATE TABLE payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES orders(id),
  amount DECIMAL(12, 2),
  method VARCHAR(50),
  status VARCHAR(50) DEFAULT 'pending',
  transaction_id VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create reviews table
CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID NOT NULL REFERENCES products(id),
  user_id UUID NOT NULL REFERENCES users(id),
  rating INT CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create audit_logs table
CREATE TABLE audit_logs (
  id SERIAL PRIMARY KEY,
  table_name VARCHAR(100),
  action VARCHAR(50),
  user_id UUID,
  old_data JSONB,
  new_data JSONB,
  changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create comprehensive indexes
CREATE INDEX idx_users_company_id ON users(company_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_products_company_id ON products(company_id);
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_products_search ON products USING GIN(search_vector);
CREATE INDEX idx_inventory_product_id ON inventory(product_id);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_payments_order_id ON payments(order_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_reviews_product_id ON reviews(product_id);
CREATE INDEX idx_reviews_user_id ON reviews(user_id);
CREATE INDEX idx_audit_logs_table ON audit_logs(table_name);
CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);

-- Task 2: Sample Data & Population
-- ============================================

-- Insert companies
INSERT INTO companies (name, type, country, rating) VALUES
('Amazon', 'marketplace', 'USA', 4.8),
('eBay', 'marketplace', 'USA', 4.5),
('Alibaba', 'marketplace', 'China', 4.6),
('Shopify', 'platform', 'Canada', 4.7),
('Etsy', 'marketplace', 'USA', 4.4);

-- Insert categories
INSERT INTO categories (name, description) VALUES
('Electronics', 'Electronic devices and accessories'),
('Clothing', 'Apparel and fashion items'),
('Books', 'Physical and digital books'),
('Home & Garden', 'Home and garden products'),
('Sports', 'Sports and outdoor equipment');

-- Insert users
INSERT INTO users (company_id, email, name, role) 
SELECT c.id, 'user' || (random() * 10000)::INT || '@example.com', 'User ' || (random() * 10000)::INT, 
  CASE WHEN random() < 0.1 THEN 'admin' WHEN random() < 0.3 THEN 'seller' ELSE 'customer' END
FROM companies c
CROSS JOIN generate_series(1, 20);

-- Insert products
INSERT INTO products (company_id, category_id, name, price, tags, metadata)
SELECT c.id, (random() * 4 + 1)::INT, 'Product ' || (random() * 50000)::INT, 
  (random() * 1000 + 10)::DECIMAL(10, 2), ARRAY['tag1', 'tag2'], 
  jsonb_build_object('color', 'blue', 'size', 'M')
FROM companies c
CROSS JOIN generate_series(1, 100);

-- Insert inventory
INSERT INTO inventory (product_id, quantity, reserved)
SELECT id, (random() * 1000)::INT, (random() * 100)::INT FROM products;

-- Insert orders
INSERT INTO orders (user_id, status, total_amount)
SELECT u.id, CASE WHEN random() < 0.3 THEN 'pending' WHEN random() < 0.6 THEN 'processing' ELSE 'completed' END,
  (random() * 5000 + 100)::DECIMAL(12, 2)
FROM users u WHERE u.role = 'customer'
CROSS JOIN generate_series(1, 5);

-- Insert order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price)
SELECT o.id, p.id, (random() * 5 + 1)::INT, p.price, (p.price * (random() * 5 + 1))::DECIMAL(12, 2)
FROM orders o
CROSS JOIN products p
WHERE random() < 0.1;

-- Insert payments
INSERT INTO payments (order_id, amount, method, status)
SELECT id, total_amount, CASE WHEN random() < 0.5 THEN 'credit_card' ELSE 'paypal' END,
  CASE WHEN random() < 0.8 THEN 'completed' ELSE 'pending' END
FROM orders;

-- Insert reviews
INSERT INTO reviews (product_id, user_id, rating, comment)
SELECT p.id, u.id, (random() * 4 + 1)::INT, 'Great product!'
FROM products p
CROSS JOIN users u
WHERE u.role = 'customer' AND random() < 0.05;

-- Task 3: Advanced Functions & Procedures
-- ============================================

-- Function: Calculate order total
CREATE OR REPLACE FUNCTION calculate_order_total(order_id UUID)
RETURNS DECIMAL AS $$
BEGIN
  RETURN (SELECT SUM(total_price) FROM order_items WHERE order_id = $1);
END;
$$ LANGUAGE plpgsql;

-- Procedure: Process order
CREATE OR REPLACE PROCEDURE process_order(order_id UUID, OUT status VARCHAR)
AS $$
BEGIN
  UPDATE orders SET status = 'processing' WHERE id = order_id;
  UPDATE inventory SET reserved = reserved + oi.quantity
  FROM order_items oi WHERE oi.order_id = order_id;
  status := 'Order processed successfully';
END;
$$ LANGUAGE plpgsql;

-- Function: Get product average rating
CREATE OR REPLACE FUNCTION get_product_rating(product_id UUID)
RETURNS DECIMAL AS $$
BEGIN
  RETURN (SELECT AVG(rating) FROM reviews WHERE product_id = $1);
END;
$$ LANGUAGE plpgsql;

-- Procedure: Generate sales report
CREATE OR REPLACE PROCEDURE generate_sales_report(report_date DATE)
AS $$
BEGIN
  INSERT INTO audit_logs (table_name, action, new_data)
  SELECT 'orders', 'report_generated', 
    jsonb_build_object('date', report_date, 'total_orders', COUNT(*), 'total_revenue', SUM(total_amount))
  FROM orders WHERE DATE(created_at) = report_date;
END;
$$ LANGUAGE plpgsql;

-- Task 4: Triggers & Automation
-- ============================================

-- Trigger: Update product search vector
CREATE OR REPLACE FUNCTION update_product_search() RETURNS TRIGGER AS $$
BEGIN
  NEW.search_vector := to_tsvector('english', NEW.name || ' ' || COALESCE(NEW.description, ''));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_product_search
BEFORE INSERT OR UPDATE ON products
FOR EACH ROW EXECUTE FUNCTION update_product_search();

-- Trigger: Audit all changes
CREATE OR REPLACE FUNCTION audit_changes() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_logs (table_name, action, old_data, new_data)
  VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), row_to_json(NEW));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_audit_orders
AFTER INSERT OR UPDATE OR DELETE ON orders
FOR EACH ROW EXECUTE FUNCTION audit_changes();

CREATE TRIGGER trigger_audit_payments
AFTER INSERT OR UPDATE OR DELETE ON payments
FOR EACH ROW EXECUTE FUNCTION audit_changes();

-- Trigger: Update timestamps
CREATE OR REPLACE FUNCTION update_timestamp() RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at := CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_orders_timestamp
BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trigger_update_products_timestamp
BEFORE UPDATE ON products FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- Task 5: Security Implementation
-- ============================================

-- Create roles
CREATE ROLE admin_role WITH CREATEDB CREATEROLE;
CREATE ROLE seller_role;
CREATE ROLE customer_role;

-- Grant permissions
GRANT ALL ON ALL TABLES IN SCHEMA public TO admin_role;
GRANT SELECT, INSERT, UPDATE ON products, orders, order_items TO seller_role;
GRANT SELECT ON products, reviews TO customer_role;
GRANT INSERT ON orders, reviews TO customer_role;

-- Enable RLS
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY order_access ON orders FOR SELECT USING (true);
CREATE POLICY review_access ON reviews FOR SELECT USING (true);

-- Task 6: Performance Optimization
-- ============================================

-- Create materialized view for sales summary
CREATE MATERIALIZED VIEW mv_sales_summary AS
SELECT 
  DATE(o.created_at) AS sale_date,
  COUNT(*) AS order_count,
  SUM(o.total_amount) AS total_revenue,
  AVG(o.total_amount) AS avg_order_value
FROM orders o
GROUP BY DATE(o.created_at);

CREATE INDEX idx_mv_sales_summary_date ON mv_sales_summary(sale_date);

-- Create materialized view for product performance
CREATE MATERIALIZED VIEW mv_product_performance AS
SELECT 
  p.id,
  p.name,
  COUNT(DISTINCT oi.order_id) AS order_count,
  SUM(oi.quantity) AS total_sold,
  AVG(r.rating) AS avg_rating
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN reviews r ON p.id = r.product_id
GROUP BY p.id, p.name;

-- Task 7: Monitoring & Logging
-- ============================================

-- Create monitoring views
CREATE OR REPLACE VIEW v_order_summary AS
SELECT 
  DATE(created_at) AS order_date,
  status,
  COUNT(*) AS order_count,
  SUM(total_amount) AS total_revenue
FROM orders
GROUP BY DATE(created_at), status;

CREATE OR REPLACE VIEW v_user_activity AS
SELECT 
  u.id,
  u.email,
  u.role,
  COUNT(DISTINCT o.id) AS order_count,
  COUNT(DISTINCT r.id) AS review_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
LEFT JOIN reviews r ON u.id = r.user_id
GROUP BY u.id, u.email, u.role;

-- Task 8: Concurrency & Transactions
-- ============================================

-- Example transaction with lock ordering
-- BEGIN;
-- SELECT * FROM inventory WHERE product_id = '...' FOR UPDATE;
-- UPDATE inventory SET quantity = quantity - 1 WHERE product_id = '...';
-- COMMIT;

-- Task 9: Disaster Recovery
-- ============================================

-- Backup command (run from shell):
-- pg_dump -U postgres -d ecommerce_global -Fc > ecommerce_global_backup.dump

-- Restore command (run from shell):
-- pg_restore -U postgres -d ecommerce_global ecommerce_global_backup.dump

-- Task 10: High Availability
-- ============================================

-- Replication configuration (in postgresql.conf):
-- wal_level = replica
-- max_wal_senders = 10
-- wal_keep_size = 1GB

-- Verify data
SELECT COUNT(*) AS company_count FROM companies;
SELECT COUNT(*) AS user_count FROM users;
SELECT COUNT(*) AS product_count FROM products;
SELECT COUNT(*) AS order_count FROM orders;
SELECT COUNT(*) AS payment_count FROM payments;
SELECT COUNT(*) AS review_count FROM reviews;
SELECT COUNT(*) AS audit_count FROM audit_logs;

