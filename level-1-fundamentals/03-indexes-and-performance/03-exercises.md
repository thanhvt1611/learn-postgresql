# 💪 Indexes & Performance - Bài Tập

Thực hành tạo indexes và tối ưu hóa queries.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có database "ecommerce_practice" với sample data

---

## 🎯 Bài Tập 1: Tạo Single Column Index (Dễ)

### Yêu Cầu
Tạo indexes cho các columns sau:
1. users.email
2. products.category_id
3. orders.status

### Gợi Ý
- Sử dụng CREATE INDEX
- Đặt tên index theo quy ước: idx_tablename_columnname

### Solution
```sql
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_orders_status ON orders(status);

-- Kiểm tra
SELECT * FROM pg_indexes WHERE tablename IN ('users', 'products', 'orders');
```

---

## 🎯 Bài Tập 2: Tạo Multi-Column Index (Trung Bình)

### Yêu Cầu
Tạo multi-column index cho:
1. orders(user_id, status)
2. order_items(order_id, product_id)

### Gợi Ý
- Sử dụng CREATE INDEX với 2 columns
- Thứ tự columns quan trọng

### Solution
```sql
CREATE INDEX idx_orders_user_status ON orders(user_id, status);
CREATE INDEX idx_order_items_order_product ON order_items(order_id, product_id);

-- Kiểm tra
\d orders
\d order_items
```

---

## 🎯 Bài Tập 3: Tạo Partial Index (Trung Bình)

### Yêu Cầu
Tạo partial index cho:
1. orders(user_id) WHERE status = 'completed'
2. products(id) WHERE stock > 0

### Gợi Ý
- Sử dụng WHERE clause
- Giảm kích thước index

### Solution
```sql
CREATE INDEX idx_orders_completed ON orders(user_id) 
WHERE status = 'completed';

CREATE INDEX idx_products_in_stock ON products(id) 
WHERE stock > 0;

-- Kiểm tra
SELECT * FROM pg_indexes WHERE indexname LIKE 'idx_orders_completed%';
```

---

## 🎯 Bài Tập 4: EXPLAIN Không Có Index (Trung Bình)

### Yêu Cầu
Chạy EXPLAIN cho queries sau (trước khi tạo index):
1. SELECT * FROM users WHERE email = 'jane@example.com'
2. SELECT * FROM products WHERE category_id = 1
3. SELECT * FROM orders WHERE status = 'pending'

### Gợi Ý
- Sử dụng EXPLAIN
- Ghi lại cost & rows

### Solution
```sql
-- Query 1
EXPLAIN SELECT * FROM users WHERE email = 'jane@example.com';

-- Query 2
EXPLAIN SELECT * FROM products WHERE category_id = 1;

-- Query 3
EXPLAIN SELECT * FROM orders WHERE status = 'pending';
```

---

## 🎯 Bài Tập 5: EXPLAIN ANALYZE (Trung Bình)

### Yêu Cầu
Chạy EXPLAIN ANALYZE cho queries từ Bài Tập 4.

### Gợi Ý
- Sử dụng EXPLAIN ANALYZE
- Ghi lại actual time

### Solution
```sql
-- Query 1
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'jane@example.com';

-- Query 2
EXPLAIN ANALYZE SELECT * FROM products WHERE category_id = 1;

-- Query 3
EXPLAIN ANALYZE SELECT * FROM orders WHERE status = 'pending';
```

---

## 🎯 Bài Tập 6: So Sánh Performance (Nâng Cao)

### Yêu Cầu
So sánh performance trước & sau tạo index:
1. Chạy EXPLAIN ANALYZE trước tạo index
2. Tạo index
3. Chạy EXPLAIN ANALYZE sau tạo index
4. So sánh costs & times

### Gợi Ý
- Ghi lại costs trước & sau
- Tính % giảm

### Solution
```sql
-- Trước tạo index
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'jane@example.com';

-- Tạo index
CREATE INDEX idx_users_email_test ON users(email);

-- Sau tạo index
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'jane@example.com';

-- Xóa index
DROP INDEX idx_users_email_test;
```

---

## 🎯 Bài Tập 7: Tối Ưu Hóa Query (Nâng Cao)

### Yêu Cầu
Tối ưu hóa queries sau:
1. Tránh calculations trên indexed columns
2. Sử dụng LIMIT
3. Tránh SELECT *

### Gợi Ý
- Sử dụng EXPLAIN để so sánh
- Tạo indexes nếu cần

### Solution
```sql
-- ❌ BAD: Calculation
EXPLAIN SELECT * FROM orders WHERE EXTRACT(YEAR FROM created_at) = 2024;

-- ✅ GOOD: Range
EXPLAIN SELECT * FROM orders 
WHERE created_at >= '2024-01-01' AND created_at < '2025-01-01';

-- ❌ BAD: SELECT *
EXPLAIN SELECT * FROM orders;

-- ✅ GOOD: Specific columns
EXPLAIN SELECT id, user_id, total_amount FROM orders;

-- ❌ BAD: Không có LIMIT
EXPLAIN SELECT * FROM orders;

-- ✅ GOOD: Có LIMIT
EXPLAIN SELECT * FROM orders LIMIT 10;
```

---

## 🎯 Bài Tập 8: JOINs Performance (Nâng Cao)

### Yêu Cầu
Tối ưu hóa JOIN query:
1. Chạy EXPLAIN ANALYZE trước tạo index
2. Tạo indexes cho foreign keys
3. Chạy EXPLAIN ANALYZE sau tạo index
4. So sánh performance

### Gợi Ý
- Tạo index trên foreign keys
- Sử dụng EXPLAIN ANALYZE

### Solution
```sql
-- Trước tạo index
EXPLAIN ANALYZE 
SELECT u.name, o.id, o.total_amount
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE u.email = 'john@example.com';

-- Tạo index
CREATE INDEX idx_orders_user_id_test ON orders(user_id);

-- Sau tạo index
EXPLAIN ANALYZE 
SELECT u.name, o.id, o.total_amount
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE u.email = 'john@example.com';

-- Xóa index
DROP INDEX idx_orders_user_id_test;
```

---

## 🎯 Bài Tập 9: Aggregate Performance (Nâng Cao)

### Yêu Cầu
Tối ưu hóa aggregate query:
1. Chạy EXPLAIN ANALYZE trước tạo index
2. Tạo index trên GROUP BY column
3. Chạy EXPLAIN ANALYZE sau tạo index

### Gợi Ý
- Tạo index trên user_id
- Sử dụng EXPLAIN ANALYZE

### Solution
```sql
-- Trước tạo index
EXPLAIN ANALYZE 
SELECT user_id, COUNT(*) AS order_count
FROM orders
GROUP BY user_id;

-- Tạo index
CREATE INDEX idx_orders_user_id_agg ON orders(user_id);

-- Sau tạo index
EXPLAIN ANALYZE 
SELECT user_id, COUNT(*) AS order_count
FROM orders
GROUP BY user_id;

-- Xóa index
DROP INDEX idx_orders_user_id_agg;
```

---

## 🎯 Bài Tập 10: Liệt Kê & Quản Lý Indexes (Nâng Cao)

### Yêu Cầu
Viết queries để:
1. Liệt kê tất cả indexes
2. Xem kích thước indexes
3. Tìm unused indexes
4. Xóa indexes

### Gợi Ý
- Sử dụng pg_indexes
- Sử dụng pg_relation_size()

### Solution
```sql
-- Liệt kê tất cả indexes
SELECT * FROM pg_indexes WHERE schemaname = 'public';

-- Xem kích thước indexes
SELECT 
    indexname,
    pg_size_pretty(pg_relation_size(indexrelid)) AS index_size
FROM pg_indexes
JOIN pg_class ON pg_indexes.indexname = pg_class.relname
WHERE schemaname = 'public'
ORDER BY pg_relation_size(indexrelid) DESC;

-- Xóa index
DROP INDEX IF EXISTS idx_users_email;
```

---

## 🎯 Bài Tập 11: Index Best Practices (Nâng Cao)

### Yêu Cầu
Tạo indexes theo best practices:
1. Tạo indexes cho WHERE columns
2. Tạo indexes cho JOIN columns
3. Tạo indexes cho ORDER BY columns
4. Tránh duplicate indexes

### Gợi Ý
- Phân tích queries
- Tạo indexes strategically

### Solution
```sql
-- Indexes cho WHERE
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_orders_status ON orders(status);

-- Indexes cho JOIN (Foreign Keys)
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- Indexes cho ORDER BY
CREATE INDEX idx_orders_created_at ON orders(created_at);

-- Kiểm tra
SELECT * FROM pg_indexes WHERE schemaname = 'public' ORDER BY tablename;
```

---

## 🎯 Bài Tập 12: Performance Tuning (Nâng Cao)

### Yêu Cầu
Viết complex query & tối ưu hóa:
1. Viết query ban đầu
2. Chạy EXPLAIN ANALYZE
3. Tạo indexes cần thiết
4. Tối ưu hóa query
5. So sánh performance

### Gợi Ý
- Sử dụng EXPLAIN ANALYZE
- Tạo indexes strategically
- Tối ưu hóa query logic

### Solution
```sql
-- Query ban đầu
EXPLAIN ANALYZE 
SELECT 
    u.name,
    COUNT(o.id) AS order_count,
    SUM(o.total_amount) AS total_spent
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name
ORDER BY total_spent DESC;

-- Tạo indexes
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- Chạy lại
EXPLAIN ANALYZE 
SELECT 
    u.name,
    COUNT(o.id) AS order_count,
    SUM(o.total_amount) AS total_spent
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name
ORDER BY total_spent DESC;
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-3: Tạo indexes
- [ ] Bài 4-5: EXPLAIN & EXPLAIN ANALYZE
- [ ] Bài 6-9: So sánh & tối ưu hóa performance
- [ ] Bài 10-12: Quản lý & best practices

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ Tạo single & multi-column indexes
- ✅ Tạo partial indexes
- ✅ EXPLAIN & EXPLAIN ANALYZE
- ✅ So sánh performance
- ✅ Tối ưu hóa queries
- ✅ JOINs & Aggregate performance
- ✅ Quản lý indexes
- ✅ Best practices

---

**Chúc mừng! Bạn đã hoàn thành Module 3 - Indexes & Performance! 🎉**

