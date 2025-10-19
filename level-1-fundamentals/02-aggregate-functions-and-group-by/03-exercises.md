# 💪 Aggregate Functions & GROUP BY - Bài Tập

Thực hành viết complex aggregation queries.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có database "ecommerce_practice" với sample data

---

## 🎯 Bài Tập 1: COUNT() (Dễ)

### Yêu Cầu
Viết queries để:
1. Đếm tất cả products
2. Đếm products trong category 1
3. Đếm unique categories

### Gợi Ý
- Sử dụng COUNT(*)
- Sử dụng WHERE
- Sử dụng COUNT(DISTINCT)

### Solution
```sql
-- Đếm tất cả products
SELECT COUNT(*) AS total_products FROM products;

-- Đếm products trong category 1
SELECT COUNT(*) FROM products WHERE category_id = 1;

-- Đếm unique categories
SELECT COUNT(DISTINCT category_id) FROM products;
```

---

## 🎯 Bài Tập 2: SUM() & AVG() (Dễ)

### Yêu Cầu
Viết queries để:
1. Tính tổng stock của tất cả products
2. Tính average price
3. Tính tổng revenue từ tất cả orders

### Gợi Ý
- Sử dụng SUM()
- Sử dụng AVG()

### Solution
```sql
-- Tổng stock
SELECT SUM(stock) AS total_stock FROM products;

-- Average price
SELECT AVG(price) AS avg_price FROM products;

-- Tổng revenue
SELECT SUM(total_amount) AS total_revenue FROM orders;
```

---

## 🎯 Bài Tập 3: MIN() & MAX() (Dễ)

### Yêu Cầu
Viết queries để:
1. Tìm product có giá thấp nhất & cao nhất
2. Tìm order có amount thấp nhất & cao nhất
3. Tính price range

### Gợi Ý
- Sử dụng MIN() & MAX()

### Solution
```sql
-- Product price range
SELECT 
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    MAX(price) - MIN(price) AS price_range
FROM products;

-- Order amount range
SELECT 
    MIN(total_amount) AS min_order,
    MAX(total_amount) AS max_order
FROM orders;
```

---

## 🎯 Bài Tập 4: GROUP BY Một Column (Trung Bình)

### Yêu Cầu
Viết query để lấy số lượng products trong mỗi category.

### Gợi Ý
- Sử dụng GROUP BY category_id
- Sử dụng COUNT()
- Sắp xếp theo product_count DESC

### Solution
```sql
SELECT 
    category_id,
    COUNT(*) AS product_count
FROM products
GROUP BY category_id
ORDER BY product_count DESC;
```

---

## 🎯 Bài Tập 5: GROUP BY Nhiều Columns (Trung Bình)

### Yêu Cầu
Viết query để lấy số lượng orders theo user & status.

### Gợi Ý
- Sử dụng GROUP BY user_id, status
- Sử dụng COUNT()

### Solution
```sql
SELECT 
    user_id,
    status,
    COUNT(*) AS order_count
FROM orders
GROUP BY user_id, status
ORDER BY user_id, status;
```

---

## 🎯 Bài Tập 6: HAVING (Trung Bình)

### Yêu Cầu
Viết query để lấy categories có > 2 products.

### Gợi Ý
- Sử dụng GROUP BY
- Sử dụng HAVING COUNT(*) > 2

### Solution
```sql
SELECT 
    category_id,
    COUNT(*) AS product_count
FROM products
GROUP BY category_id
HAVING COUNT(*) > 2
ORDER BY product_count DESC;
```

---

## 🎯 Bài Tập 7: GROUP BY Với JOIN (Nâng Cao)

### Yêu Cầu
Viết query để lấy số lượng products trong mỗi category (với category name).

### Gợi Ý
- Sử dụng LEFT JOIN
- Sử dụng GROUP BY
- Bao gồm categories không có products

### Solution
```sql
SELECT 
    c.id,
    c.name,
    COUNT(p.id) AS product_count
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
GROUP BY c.id, c.name
ORDER BY product_count DESC;
```

---

## 🎯 Bài Tập 8: Multiple Aggregates (Nâng Cao)

### Yêu Cầu
Viết query để lấy thống kê cho mỗi user:
- Số lượng orders
- Tổng chi tiêu
- Average order value
- Min & Max order

### Gợi Ý
- Sử dụng LEFT JOIN
- Sử dụng COUNT(), SUM(), AVG(), MIN(), MAX()
- Sắp xếp theo total_spent DESC

### Solution
```sql
SELECT 
    u.id,
    u.name,
    COUNT(o.id) AS order_count,
    SUM(o.total_amount) AS total_spent,
    AVG(o.total_amount) AS avg_order_value,
    MIN(o.total_amount) AS min_order,
    MAX(o.total_amount) AS max_order
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name
ORDER BY total_spent DESC NULLS LAST;
```

---

## 🎯 Bài Tập 9: Complex Aggregation (Nâng Cao)

### Yêu Cầu
Viết query để lấy top 5 products theo revenue:
- Product name & category
- Số lần được order
- Tổng quantity
- Tổng revenue

### Gợi Ý
- Sử dụng Multiple JOINs
- Sử dụng COUNT(DISTINCT), SUM()
- Sắp xếp theo total_revenue DESC

### Solution
```sql
SELECT 
    p.id,
    p.name,
    c.name AS category,
    COUNT(DISTINCT oi.order_id) AS times_ordered,
    SUM(oi.quantity) AS total_quantity,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
JOIN categories c ON p.category_id = c.id
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.name, c.id, c.name
ORDER BY total_revenue DESC NULLS LAST
LIMIT 5;
```

---

## 🎯 Bài Tập 10: Aggregation Với HAVING (Nâng Cao)

### Yêu Cầu
Viết query để lấy users có tổng chi tiêu > 500.

### Gợi Ý
- Sử dụng LEFT JOIN
- Sử dụng GROUP BY
- Sử dụng HAVING SUM() > 500

### Solution
```sql
SELECT 
    u.id,
    u.name,
    COUNT(o.id) AS order_count,
    SUM(o.total_amount) AS total_spent
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name
HAVING SUM(o.total_amount) > 500
ORDER BY total_spent DESC;
```

---

## 🎯 Bài Tập 11: Aggregation Với WHERE & HAVING (Nâng Cao)

### Yêu Cầu
Viết query để lấy categories có tổng revenue > 100 từ completed orders.

### Gợi Ý
- Sử dụng WHERE status = 'completed'
- Sử dụng GROUP BY
- Sử dụng HAVING SUM() > 100

### Solution
```sql
SELECT 
    c.name,
    COUNT(DISTINCT oi.order_id) AS orders,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM categories c
JOIN products p ON c.id = p.category_id
JOIN order_items oi ON p.id = oi.product_id
JOIN orders o ON oi.order_id = o.id
WHERE o.status = 'completed'
GROUP BY c.id, c.name
HAVING SUM(oi.quantity * oi.unit_price) > 100
ORDER BY total_revenue DESC;
```

---

## 🎯 Bài Tập 12: Ranking Aggregation (Nâng Cao)

### Yêu Cầu
Viết query để lấy top 3 users theo tổng chi tiêu.

### Gợi Ý
- Sử dụng GROUP BY
- Sử dụng ORDER BY DESC
- Sử dụng LIMIT 3

### Solution
```sql
SELECT 
    u.name,
    COUNT(o.id) AS order_count,
    SUM(o.total_amount) AS total_spent
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name
ORDER BY total_spent DESC NULLS LAST
LIMIT 3;
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-3: COUNT, SUM, AVG, MIN, MAX
- [ ] Bài 4-5: GROUP BY
- [ ] Bài 6: HAVING
- [ ] Bài 7-8: GROUP BY với JOINs
- [ ] Bài 9-12: Complex aggregations

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ COUNT(), SUM(), AVG(), MIN(), MAX()
- ✅ GROUP BY một & nhiều columns
- ✅ HAVING clause
- ✅ Aggregate Functions với JOINs
- ✅ Multiple Aggregates
- ✅ Complex Aggregations
- ✅ WHERE & HAVING kết hợp
- ✅ Ranking & Limiting

---

**Chúc mừng! Bạn đã hoàn thành Module 2 - Aggregate Functions & GROUP BY! 🎉**

