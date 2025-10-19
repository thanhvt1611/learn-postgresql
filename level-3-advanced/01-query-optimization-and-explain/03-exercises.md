# 💪 Query Optimization & EXPLAIN - Bài Tập

Thực hành tối ưu hóa queries & phân tích query plans.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có database "ecommerce_practice" với sample data

---

## 🎯 Bài Tập 1: Simple EXPLAIN (Dễ)

### Yêu Cầu
Sử dụng EXPLAIN để xem query plan.

### Gợi Ý
- Sử dụng EXPLAIN
- Sử dụng SELECT

### Solution
```sql
EXPLAIN SELECT * FROM products WHERE price > 100;
```

---

## 🎯 Bài Tập 2: EXPLAIN ANALYZE (Dễ)

### Yêu Cầu
Sử dụng EXPLAIN ANALYZE để xem actual execution stats.

### Gợi Ý
- Sử dụng EXPLAIN ANALYZE
- Sử dụng SELECT

### Solution
```sql
EXPLAIN ANALYZE SELECT * FROM products WHERE price > 100;
```

---

## 🎯 Bài Tập 3: Seq Scan (Dễ)

### Yêu Cầu
Xem Seq Scan query plan.

### Gợi Ý
- Sử dụng EXPLAIN ANALYZE
- Không có index

### Solution
```sql
EXPLAIN ANALYZE SELECT * FROM products WHERE category = 'Electronics';
```

---

## 🎯 Bài Tập 4: Create Index (Trung Bình)

### Yêu Cầu
Tạo index trên price column.

### Gợi Ý
- Sử dụng CREATE INDEX
- Sử dụng price column

### Solution
```sql
CREATE INDEX idx_products_price ON products(price);
```

---

## 🎯 Bài Tập 5: Index Scan (Trung Bình)

### Yêu Cầu
Xem Index Scan query plan sau khi tạo index.

### Gợi Ý
- Sử dụng EXPLAIN ANALYZE
- Sử dụng indexed column

### Solution
```sql
EXPLAIN ANALYZE SELECT * FROM products WHERE price > 100;
```

---

## 🎯 Bài Tập 6: Index Only Scan (Trung Bình)

### Yêu Cầu
Tạo covering index & xem Index Only Scan.

### Gợi Ý
- Sử dụng CREATE INDEX
- Sử dụng INCLUDE clause

### Solution
```sql
CREATE INDEX idx_products_covering ON products(price) INCLUDE (name, category);
EXPLAIN ANALYZE SELECT name, price FROM products WHERE price > 100;
```

---

## 🎯 Bài Tập 7: Join Performance (Trung Bình)

### Yêu Cầu
Analyze join query performance.

### Gợi Ý
- Sử dụng EXPLAIN ANALYZE
- Sử dụng JOIN

### Solution
```sql
EXPLAIN ANALYZE
SELECT p.name, o.total_amount
FROM products p
JOIN order_items oi ON p.id = oi.product_id
JOIN orders o ON oi.order_id = o.id
WHERE p.price > 100;
```

---

## 🎯 Bài Tập 8: Multi-Column Index (Nâng Cao)

### Yêu Cầu
Tạo multi-column index & analyze performance.

### Gợi Ý
- Sử dụng CREATE INDEX
- Sử dụng multiple columns

### Solution
```sql
CREATE INDEX idx_orders_user_date ON orders(user_id, created_at);
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = 1 AND created_at > '2024-01-01';
```

---

## 🎯 Bài Tập 9: Partial Index (Nâng Cao)

### Yêu Cầu
Tạo partial index cho pending orders.

### Gợi Ý
- Sử dụng CREATE INDEX
- Sử dụng WHERE clause

### Solution
```sql
CREATE INDEX idx_orders_pending ON orders(id) WHERE status = 'pending';
EXPLAIN ANALYZE SELECT * FROM orders WHERE status = 'pending';
```

---

## 🎯 Bài Tập 10: Optimize with LIMIT (Nâng Cao)

### Yêu Cầu
Compare query performance với & tanpa LIMIT.

### Gợi Ý
- Sử dụng EXPLAIN ANALYZE
- Sử dụng LIMIT

### Solution
```sql
-- Without LIMIT
EXPLAIN ANALYZE SELECT * FROM products;

-- With LIMIT
EXPLAIN ANALYZE SELECT * FROM products LIMIT 10;
```

---

## 🎯 Bài Tập 11: Optimize Column Selection (Nâng Cao)

### Yêu Cầu
Compare SELECT * vs specific columns.

### Gợi Ý
- Sử dụng EXPLAIN ANALYZE
- Sử dụng specific columns

### Solution
```sql
-- SELECT *
EXPLAIN ANALYZE SELECT * FROM products;

-- Specific columns
EXPLAIN ANALYZE SELECT id, name, price FROM products;
```

---

## 🎯 Bài Tập 12: Complex Query Optimization (Nâng Cao)

### Yêu Cầu
Optimize complex query với multiple joins & aggregations.

### Gợi Ý
- Sử dụng EXPLAIN ANALYZE
- Tạo appropriate indexes

### Solution
```sql
-- Create indexes
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- Analyze query
EXPLAIN ANALYZE
SELECT p.name, COUNT(oi.id) AS item_count, SUM(oi.quantity * oi.unit_price) AS revenue
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.id
WHERE o.created_at > CURRENT_DATE - INTERVAL '30 days'
GROUP BY p.id, p.name
ORDER BY revenue DESC;
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-3: EXPLAIN & Seq Scan
- [ ] Bài 4-6: Indexes & Index Scans
- [ ] Bài 7-9: Joins & Partial Indexes
- [ ] Bài 10-12: Query Optimization

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ EXPLAIN & EXPLAIN ANALYZE
- ✅ Query plan analysis
- ✅ Seq Scan & Index Scan
- ✅ Index Only Scan
- ✅ Join performance
- ✅ Multi-column indexes
- ✅ Partial indexes
- ✅ Query optimization

---

**Chúc mừng! Bạn đã hoàn thành Module 1 - Query Optimization & EXPLAIN! 🎉**

