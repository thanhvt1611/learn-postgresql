# 💪 Window Functions - Bài Tập

Thực hành sử dụng Window Functions để phân tích dữ liệu.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có database "ecommerce_practice" với sample data

---

## 🎯 Bài Tập 1: ROW_NUMBER() (Dễ)

### Yêu Cầu
Ranking tất cả orders theo total_amount (cao nhất trước).

### Gợi Ý
- Sử dụng ROW_NUMBER()
- Sử dụng ORDER BY DESC

### Solution
```sql
SELECT 
  id,
  user_id,
  total_amount,
  ROW_NUMBER() OVER (ORDER BY total_amount DESC) AS rank
FROM orders;
```

---

## 🎯 Bài Tập 2: RANK() vs DENSE_RANK() (Trung Bình)

### Yêu Cầu
So sánh RANK() & DENSE_RANK() cho products theo price.

### Gợi Ý
- Sử dụng RANK() & DENSE_RANK()
- Sắp xếp theo price DESC

### Solution
```sql
SELECT 
  name,
  price,
  RANK() OVER (ORDER BY price DESC) AS rank,
  DENSE_RANK() OVER (ORDER BY price DESC) AS dense_rank
FROM products;
```

---

## 🎯 Bài Tập 3: NTILE() (Trung Bình)

### Yêu Cầu
Chia users thành 4 quartiles theo total_spent.

### Gợi Ý
- Sử dụng NTILE(4)
- Sử dụng GROUP BY & SUM

### Solution
```sql
SELECT 
  u.name,
  SUM(o.total_amount) AS total_spent,
  NTILE(4) OVER (ORDER BY SUM(o.total_amount) DESC) AS quartile
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;
```

---

## 🎯 Bài Tập 4: SUM() OVER - Running Total (Trung Bình)

### Yêu Cầu
Tính running total doanh thu theo ngày.

### Gợi Ý
- Sử dụng SUM() OVER
- Sử dụng ORDER BY DATE

### Solution
```sql
SELECT 
  DATE(created_at) AS order_date,
  SUM(total_amount) AS daily_revenue,
  SUM(SUM(total_amount)) OVER (ORDER BY DATE(created_at)) AS running_total
FROM orders
GROUP BY DATE(created_at)
ORDER BY order_date;
```

---

## 🎯 Bài Tập 5: AVG() OVER - Category Average (Trung Bình)

### Yêu Cầu
Tính average price per category & so sánh với category average.

### Gợi Ý
- Sử dụng AVG() OVER
- Sử dụng PARTITION BY category_id

### Solution
```sql
SELECT 
  p.name,
  p.price,
  c.name AS category,
  AVG(p.price) OVER (PARTITION BY c.id) AS category_avg,
  ROUND(p.price - AVG(p.price) OVER (PARTITION BY c.id), 2) AS diff
FROM products p
JOIN categories c ON p.category_id = c.id;
```

---

## 🎯 Bài Tập 6: LAG() - Previous Value (Trung Bình)

### Yêu Cầu
So sánh mỗi order với order trước đó của cùng user.

### Gợi Ý
- Sử dụng LAG()
- Sử dụng PARTITION BY user_id

### Solution
```sql
SELECT 
  u.name,
  o.created_at,
  o.total_amount,
  LAG(o.total_amount) OVER (PARTITION BY u.id ORDER BY o.created_at) AS prev_order,
  o.total_amount - LAG(o.total_amount) OVER (PARTITION BY u.id ORDER BY o.created_at) AS diff
FROM users u
JOIN orders o ON u.id = o.user_id
ORDER BY u.id, o.created_at;
```

---

## 🎯 Bài Tập 7: LEAD() - Next Value (Trung Bình)

### Yêu Cầu
Lấy next order amount cho mỗi order.

### Gợi Ý
- Sử dụng LEAD()
- Sử dụng PARTITION BY user_id

### Solution
```sql
SELECT 
  u.name,
  o.created_at,
  o.total_amount,
  LEAD(o.total_amount) OVER (PARTITION BY u.id ORDER BY o.created_at) AS next_order
FROM users u
JOIN orders o ON u.id = o.user_id
ORDER BY u.id, o.created_at;
```

---

## 🎯 Bài Tập 8: FIRST_VALUE() & LAST_VALUE() (Nâng Cao)

### Yêu Cầu
Lấy first & last order amount per user.

### Gợi Ý
- Sử dụng FIRST_VALUE() & LAST_VALUE()
- Sử dụng ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

### Solution
```sql
SELECT 
  u.name,
  o.created_at,
  o.total_amount,
  FIRST_VALUE(o.total_amount) OVER (PARTITION BY u.id ORDER BY o.created_at) AS first_order,
  LAST_VALUE(o.total_amount) OVER (
    PARTITION BY u.id 
    ORDER BY o.created_at
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS last_order
FROM users u
JOIN orders o ON u.id = o.user_id
ORDER BY u.id, o.created_at;
```

---

## 🎯 Bài Tập 9: Moving Average (Nâng Cao)

### Yêu Cầu
Tính 3-day moving average của daily revenue.

### Gợi Ý
- Sử dụng AVG() OVER
- Sử dụng ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING

### Solution
```sql
SELECT 
  DATE(created_at) AS order_date,
  SUM(total_amount) AS daily_revenue,
  AVG(SUM(total_amount)) OVER (
    ORDER BY DATE(created_at)
    ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
  ) AS moving_avg
FROM orders
GROUP BY DATE(created_at)
ORDER BY order_date;
```

---

## 🎯 Bài Tập 10: Cumulative Sum (Nâng Cao)

### Yêu Cầu
Tính cumulative sum per user.

### Gợi Ý
- Sử dụng SUM() OVER
- Sử dụng ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

### Solution
```sql
SELECT 
  u.name,
  o.created_at,
  o.total_amount,
  SUM(o.total_amount) OVER (
    PARTITION BY u.id
    ORDER BY o.created_at
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS cumulative_total
FROM users u
JOIN orders o ON u.id = o.user_id
ORDER BY u.id, o.created_at;
```

---

## 🎯 Bài Tập 11: Ranking Per Category (Nâng Cao)

### Yêu Cầu
Rank products per category theo price (cao nhất trước).

### Gợi Ý
- Sử dụng RANK()
- Sử dụng PARTITION BY category_id

### Solution
```sql
SELECT 
  c.name AS category,
  p.name,
  p.price,
  RANK() OVER (PARTITION BY c.id ORDER BY p.price DESC) AS price_rank
FROM products p
JOIN categories c ON p.category_id = c.id;
```

---

## 🎯 Bài Tập 12: Complex Analytics (Nâng Cao)

### Yêu Cầu
Tính multiple analytics per user:
- Order count
- Total spent
- Average order
- Max order
- Order number

### Gợi Ý
- Sử dụng Multiple Window Functions
- Sử dụng PARTITION BY & ORDER BY

### Solution
```sql
SELECT 
  u.name,
  COUNT(o.id) OVER (PARTITION BY u.id) AS order_count,
  SUM(o.total_amount) OVER (PARTITION BY u.id) AS total_spent,
  AVG(o.total_amount) OVER (PARTITION BY u.id) AS avg_order,
  MAX(o.total_amount) OVER (PARTITION BY u.id) AS max_order,
  ROW_NUMBER() OVER (PARTITION BY u.id ORDER BY o.created_at) AS order_number
FROM users u
LEFT JOIN orders o ON u.id = o.user_id;
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-3: Ranking Functions
- [ ] Bài 4-5: Aggregate Window Functions
- [ ] Bài 6-7: Lag/Lead Functions
- [ ] Bài 8-10: Advanced Functions
- [ ] Bài 11-12: Complex Queries

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ ROW_NUMBER(), RANK(), DENSE_RANK(), NTILE()
- ✅ SUM(), AVG(), COUNT(), MIN(), MAX() OVER
- ✅ LAG(), LEAD()
- ✅ FIRST_VALUE(), LAST_VALUE()
- ✅ Frame Clauses
- ✅ Complex Analytics

---

**Chúc mừng! Bạn đã hoàn thành Module 1 - Window Functions! 🎉**

