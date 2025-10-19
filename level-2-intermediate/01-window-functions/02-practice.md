# 🛠️ Window Functions - Thực Hành

Thực hành sử dụng Window Functions để phân tích dữ liệu.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Sử dụng được OVER & PARTITION BY
- ✅ Sử dụng được Ranking Functions
- ✅ Sử dụng được Aggregate Window Functions
- ✅ Sử dụng được Lag/Lead Functions
- ✅ Sử dụng được Frame Clauses

---

## 📋 Bước 1: Chuẩn Bị Database

### Bước 1.1: Sử Dụng Database Từ Level 1

```sql
-- Kết nối
psql -U postgres -d ecommerce_practice

-- Kiểm tra tables
\dt
```

---

## 🏆 Bước 2: Thực Hành Ranking Functions

### Thực Hành 2.1: ROW_NUMBER()

```sql
-- Ranking users theo total_amount
SELECT 
  u.name,
  o.total_amount,
  ROW_NUMBER() OVER (ORDER BY o.total_amount DESC) AS rank
FROM users u
JOIN orders o ON u.id = o.user_id
LIMIT 10;
```

### Thực Hành 2.2: RANK() vs DENSE_RANK()

```sql
-- RANK() - có gaps
SELECT 
  name,
  total_amount,
  RANK() OVER (ORDER BY total_amount DESC) AS rank
FROM (SELECT u.name, o.total_amount FROM users u JOIN orders o ON u.id = o.user_id) t
LIMIT 10;

-- DENSE_RANK() - không có gaps
SELECT 
  name,
  total_amount,
  DENSE_RANK() OVER (ORDER BY total_amount DESC) AS rank
FROM (SELECT u.name, o.total_amount FROM users u JOIN orders o ON u.id = o.user_id) t
LIMIT 10;
```

### Thực Hành 2.3: NTILE()

```sql
-- Chia users thành 4 quartiles
SELECT 
  u.name,
  SUM(o.total_amount) AS total_spent,
  NTILE(4) OVER (ORDER BY SUM(o.total_amount) DESC) AS quartile
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;
```

---

## 📊 Bước 3: Thực Hành Aggregate Window Functions

### Thực Hành 3.1: SUM() OVER - Running Total

```sql
-- Running total theo ngày
SELECT 
  DATE(created_at) AS order_date,
  total_amount,
  SUM(total_amount) OVER (ORDER BY DATE(created_at)) AS running_total
FROM orders
ORDER BY order_date;
```

### Thực Hành 3.2: AVG() OVER - Category Average

```sql
-- Average price per category
SELECT 
  p.name,
  p.price,
  c.name AS category,
  AVG(p.price) OVER (PARTITION BY c.id) AS category_avg,
  p.price - AVG(p.price) OVER (PARTITION BY c.id) AS diff_from_avg
FROM products p
JOIN categories c ON p.category_id = c.id;
```

### Thực Hành 3.3: COUNT() OVER - Per Group

```sql
-- Count orders per user
SELECT 
  u.name,
  o.id AS order_id,
  COUNT(*) OVER (PARTITION BY u.id) AS user_order_count
FROM users u
JOIN orders o ON u.id = o.user_id;
```

### Thực Hành 3.4: MIN/MAX OVER

```sql
-- Min & max price per category
SELECT 
  p.name,
  p.price,
  c.name AS category,
  MIN(p.price) OVER (PARTITION BY c.id) AS min_price,
  MAX(p.price) OVER (PARTITION BY c.id) AS max_price
FROM products p
JOIN categories c ON p.category_id = c.id;
```

---

## ⬅️➡️ Bước 4: Thực Hành Lag & Lead

### Thực Hành 4.1: LAG() - Previous Value

```sql
-- So sánh với order trước đó
SELECT 
  DATE(created_at) AS order_date,
  total_amount,
  LAG(total_amount) OVER (ORDER BY created_at) AS prev_amount,
  total_amount - LAG(total_amount) OVER (ORDER BY created_at) AS difference
FROM orders
ORDER BY order_date;
```

### Thực Hành 4.2: LEAD() - Next Value

```sql
-- So sánh với order tiếp theo
SELECT 
  DATE(created_at) AS order_date,
  total_amount,
  LEAD(total_amount) OVER (ORDER BY created_at) AS next_amount
FROM orders
ORDER BY order_date;
```

### Thực Hành 4.3: LAG/LEAD Per User

```sql
-- Previous & next order per user
SELECT 
  u.name,
  o.created_at,
  o.total_amount,
  LAG(o.total_amount) OVER (PARTITION BY u.id ORDER BY o.created_at) AS prev_order,
  LEAD(o.total_amount) OVER (PARTITION BY u.id ORDER BY o.created_at) AS next_order
FROM users u
JOIN orders o ON u.id = o.user_id
ORDER BY u.id, o.created_at;
```

---

## 📍 Bước 5: Thực Hành FIRST_VALUE & LAST_VALUE

### Thực Hành 5.1: FIRST_VALUE()

```sql
-- First order per user
SELECT 
  u.name,
  o.created_at,
  o.total_amount,
  FIRST_VALUE(o.total_amount) OVER (PARTITION BY u.id ORDER BY o.created_at) AS first_order
FROM users u
JOIN orders o ON u.id = o.user_id
ORDER BY u.id, o.created_at;
```

### Thực Hành 5.2: LAST_VALUE()

```sql
-- Last order per user
SELECT 
  u.name,
  o.created_at,
  o.total_amount,
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

## 📐 Bước 6: Thực Hành Frame Clauses

### Thực Hành 6.1: Moving Average

```sql
-- 3-row moving average
SELECT 
  DATE(created_at) AS order_date,
  total_amount,
  AVG(total_amount) OVER (
    ORDER BY created_at
    ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
  ) AS moving_avg
FROM orders
ORDER BY order_date;
```

### Thực Hành 6.2: Cumulative Sum

```sql
-- Cumulative sum per user
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

## 🔄 Bước 7: Complex Window Queries

### Thực Hành 7.1: Ranking with Partitioning

```sql
-- Rank products per category
SELECT 
  c.name AS category,
  p.name,
  p.price,
  RANK() OVER (PARTITION BY c.id ORDER BY p.price DESC) AS price_rank
FROM products p
JOIN categories c ON p.category_id = c.id;
```

### Thực Hành 7.2: Multiple Window Functions

```sql
-- Multiple analytics per user
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

## ✅ Checklist Thực Hành

- [ ] Thực hành ROW_NUMBER()
- [ ] Thực hành RANK() & DENSE_RANK()
- [ ] Thực hành NTILE()
- [ ] Thực hành SUM() OVER
- [ ] Thực hành AVG() OVER
- [ ] Thực hành COUNT() OVER
- [ ] Thực hành LAG() & LEAD()
- [ ] Thực hành FIRST_VALUE() & LAST_VALUE()
- [ ] Thực hành Frame Clauses
- [ ] Thực hành Complex Queries

---

## 💡 Tips

1. **PARTITION BY** - Chia thành groups
2. **ORDER BY** - Sắp xếp trong window
3. **ROWS BETWEEN** - Định nghĩa frame
4. **LAG/LEAD** - So sánh với rows khác
5. **UNBOUNDED PRECEDING/FOLLOWING** - Toàn bộ window

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

