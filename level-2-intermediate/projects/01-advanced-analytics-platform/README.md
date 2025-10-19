# 📊 Project 1: Advanced Analytics Platform

Xây dựng một advanced analytics platform sử dụng Window Functions, CTEs, và JSON data.

## 🎯 Mục Tiêu Project

Sau khi hoàn thành project này, bạn sẽ:
- ✅ Sử dụng được Window Functions cho analytics
- ✅ Sử dụng được CTEs cho complex queries
- ✅ Lưu trữ & truy vấn JSON data
- ✅ Tạo được advanced analytics queries
- ✅ Tối ưu hóa performance

---

## 📋 Project Requirements

### Database Schema

```sql
-- Tables
users (id, name, email, country, created_at)
products (id, name, category, price, created_at)
orders (id, user_id, total_amount, status, created_at)
order_items (id, order_id, product_id, quantity, unit_price)
analytics_events (id, user_id, event_type, event_data JSONB, created_at)
```

### Features

1. **User Analytics**
   - User segmentation (VIP, Premium, Regular, New)
   - User lifetime value
   - User retention rate
   - User activity trends

2. **Product Analytics**
   - Top products by revenue
   - Product performance ranking
   - Category analysis
   - Product trends

3. **Order Analytics**
   - Order trends (daily, weekly, monthly)
   - Average order value
   - Order status distribution
   - Customer order patterns

4. **Event Analytics**
   - Event tracking (JSON data)
   - Event aggregation
   - User behavior analysis
   - Funnel analysis

---

## 🔧 Tasks

### Task 1: Create Database & Tables
- [ ] Create analytics database
- [ ] Create all tables with proper constraints
- [ ] Create indexes for performance

### Task 2: Create Window Function Queries
- [ ] User ranking by spending
- [ ] Product ranking by revenue
- [ ] Running totals & cumulative sums
- [ ] Moving averages

### Task 3: Create CTE Queries
- [ ] User segmentation CTEs
- [ ] Product performance CTEs
- [ ] Order analytics CTEs
- [ ] Complex multi-CTE queries

### Task 4: Create JSON Analytics
- [ ] Store event data as JSON
- [ ] Query JSON events
- [ ] Aggregate JSON data
- [ ] Create event analytics views

### Task 5: Create Analytics Views
- [ ] User analytics view
- [ ] Product analytics view
- [ ] Order analytics view
- [ ] Event analytics view

### Task 6: Create Stored Procedures
- [ ] Procedure to calculate user segments
- [ ] Procedure to update analytics
- [ ] Procedure to generate reports

### Task 7: Performance Optimization
- [ ] Create appropriate indexes
- [ ] Analyze query performance
- [ ] Optimize slow queries
- [ ] Test with large datasets

---

## 📊 Sample Data

```sql
-- Sample users
INSERT INTO users (name, email, country, created_at)
VALUES 
  ('Nguyen Van A', 'a@example.com', 'Vietnam', '2024-01-01'),
  ('Jean Dupont', 'jean@example.com', 'France', '2024-02-01'),
  ('John Smith', 'john@example.com', 'USA', '2024-03-01');

-- Sample products
INSERT INTO products (name, category, price, created_at)
VALUES 
  ('Laptop', 'Electronics', 1200, '2024-01-01'),
  ('Mouse', 'Electronics', 50, '2024-01-01'),
  ('Keyboard', 'Electronics', 150, '2024-01-01');

-- Sample orders
INSERT INTO orders (user_id, total_amount, status, created_at)
VALUES 
  (1, 1250, 'completed', '2024-01-15'),
  (2, 200, 'completed', '2024-02-20'),
  (3, 1350, 'completed', '2024-03-10');

-- Sample events
INSERT INTO analytics_events (user_id, event_type, event_data, created_at)
VALUES 
  (1, 'page_view', '{"page": "products", "duration": 120}', '2024-01-15'),
  (2, 'add_to_cart', '{"product_id": 1, "quantity": 1}', '2024-02-20'),
  (3, 'purchase', '{"order_id": 3, "amount": 1350}', '2024-03-10');
```

---

## 🎓 Learning Outcomes

Bạn sẽ học được:
- ✅ Window Functions cho analytics
- ✅ CTEs cho complex queries
- ✅ JSON data handling
- ✅ Advanced SQL techniques
- ✅ Performance optimization
- ✅ Real-world analytics scenarios

---

## 📚 Resources

- [PostgreSQL Window Functions](https://www.postgresql.org/docs/current/functions-window.html)
- [PostgreSQL CTEs](https://www.postgresql.org/docs/current/queries-with.html)
- [PostgreSQL JSON](https://www.postgresql.org/docs/current/datatype-json.html)

---

## ✅ Completion Checklist

- [ ] Database & tables created
- [ ] Window function queries working
- [ ] CTE queries working
- [ ] JSON analytics working
- [ ] Views created
- [ ] Stored procedures created
- [ ] Performance optimized
- [ ] All tasks completed

---

**Hãy bắt đầu với solution.sql để xem implementation! 🚀**

