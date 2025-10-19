# 💪 Common Table Expressions (CTEs) - Bài Tập

Thực hành sử dụng CTEs để viết complex queries.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có database "ecommerce_practice" với sample data

---

## 🎯 Bài Tập 1: Simple CTE (Dễ)

### Yêu Cầu
Tạo CTE để tính order statistics per user.

### Gợi Ý
- Sử dụng WITH clause
- Sử dụng GROUP BY

### Solution
```sql
WITH user_stats AS (
  SELECT 
    user_id,
    COUNT(*) AS order_count,
    SUM(total_amount) AS total_spent,
    AVG(total_amount) AS avg_order
  FROM orders
  GROUP BY user_id
)
SELECT * FROM user_stats WHERE total_spent > 500;
```

---

## 🎯 Bài Tập 2: CTE with JOIN (Trung Bình)

### Yêu Cầu
Tạo CTE để tính product revenue per category.

### Gợi Ý
- Sử dụng WITH clause
- Sử dụng JOINs
- Sử dụng GROUP BY

### Solution
```sql
WITH product_revenue AS (
  SELECT 
    p.id,
    p.name,
    c.name AS category,
    SUM(oi.quantity * oi.unit_price) AS revenue
  FROM products p
  LEFT JOIN categories c ON p.category_id = c.id
  LEFT JOIN order_items oi ON p.id = oi.product_id
  GROUP BY p.id, p.name, c.id, c.name
)
SELECT * FROM product_revenue ORDER BY revenue DESC NULLS LAST;
```

---

## 🎯 Bài Tập 3: CTE with Window Functions (Trung Bình)

### Yêu Cầu
Tạo CTE để rank products per category theo price.

### Gợi Ý
- Sử dụng WITH clause
- Sử dụng RANK() OVER
- Sử dụng PARTITION BY

### Solution
```sql
WITH ranked_products AS (
  SELECT 
    p.id,
    p.name,
    c.name AS category,
    p.price,
    RANK() OVER (PARTITION BY c.id ORDER BY p.price DESC) AS price_rank
  FROM products p
  JOIN categories c ON p.category_id = c.id
)
SELECT * FROM ranked_products WHERE price_rank <= 3;
```

---

## 🎯 Bài Tập 4: Multiple CTEs (Trung Bình)

### Yêu Cầu
Tạo 2 CTEs:
1. user_orders - order statistics per user
2. user_details - user info + order stats

### Gợi Ý
- Sử dụng Multiple WITH clauses
- Sử dụng JOINs giữa CTEs

### Solution
```sql
WITH 
  user_orders AS (
    SELECT user_id, COUNT(*) AS order_count, SUM(total_amount) AS total_spent
    FROM orders
    GROUP BY user_id
  ),
  user_details AS (
    SELECT u.id, u.name, u.email, uo.order_count, uo.total_spent
    FROM users u
    LEFT JOIN user_orders uo ON u.id = uo.user_id
  )
SELECT * FROM user_details WHERE order_count > 0 ORDER BY total_spent DESC NULLS LAST;
```

---

## 🎯 Bài Tập 5: Three CTEs (Nâng Cao)

### Yêu Cầu
Tạo 3 CTEs:
1. category_products - product count per category
2. product_revenue - revenue per category
3. final_stats - kết hợp cả 2

### Gợi Ý
- Sử dụng 3 WITH clauses
- Sử dụng Multiple JOINs

### Solution
```sql
WITH 
  category_products AS (
    SELECT category_id, COUNT(*) AS product_count
    FROM products
    GROUP BY category_id
  ),
  product_revenue AS (
    SELECT p.category_id, SUM(oi.quantity * oi.unit_price) AS revenue
    FROM products p
    LEFT JOIN order_items oi ON p.id = oi.product_id
    GROUP BY p.category_id
  ),
  final_stats AS (
    SELECT 
      c.id,
      c.name,
      COALESCE(cp.product_count, 0) AS product_count,
      COALESCE(pr.revenue, 0) AS revenue
    FROM categories c
    LEFT JOIN category_products cp ON c.id = cp.category_id
    LEFT JOIN product_revenue pr ON c.id = pr.category_id
  )
SELECT * FROM final_stats ORDER BY revenue DESC;
```

---

## 🎯 Bài Tập 6: Recursive CTE - Number Series (Trung Bình)

### Yêu Cầu
Tạo recursive CTE để tạo number series từ 1 đến 10.

### Gợi Ý
- Sử dụng WITH RECURSIVE
- Sử dụng UNION ALL
- Sử dụng Base case & Recursive case

### Solution
```sql
WITH RECURSIVE numbers AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM numbers WHERE n < 10
)
SELECT * FROM numbers;
```

---

## 🎯 Bài Tập 7: Recursive CTE - Date Series (Trung Bình)

### Yêu Cầu
Tạo recursive CTE để tạo date series từ hôm nay đến 7 ngày sau.

### Gợi Ý
- Sử dụng WITH RECURSIVE
- Sử dụng CURRENT_DATE
- Sử dụng INTERVAL

### Solution
```sql
WITH RECURSIVE date_series AS (
  SELECT CURRENT_DATE AS date
  UNION ALL
  SELECT date + INTERVAL '1 day' FROM date_series WHERE date < CURRENT_DATE + INTERVAL '7 days'
)
SELECT * FROM date_series;
```

---

## 🎯 Bài Tập 8: Customer Segmentation (Nâng Cao)

### Yêu Cầu
Tạo 2 CTEs:
1. customer_stats - order statistics per user
2. customer_segments - phân loại khách hàng

### Gợi Ý
- Sử dụng CASE statement
- Sử dụng Multiple CTEs

### Solution
```sql
WITH customer_stats AS (
  SELECT 
    u.id,
    u.name,
    COUNT(o.id) AS order_count,
    SUM(o.total_amount) AS total_spent
  FROM users u
  LEFT JOIN orders o ON u.id = o.user_id
  GROUP BY u.id, u.name
),
customer_segments AS (
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
  FROM customer_stats
)
SELECT * FROM customer_segments ORDER BY total_spent DESC NULLS LAST;
```

---

## 🎯 Bài Tập 9: Top Products per Category (Nâng Cao)

### Yêu Cầu
Tạo CTE để lấy top 3 products per category theo revenue.

### Gợi Ý
- Sử dụng RANK() OVER
- Sử dụng PARTITION BY
- Sử dụng WHERE rank <= 3

### Solution
```sql
WITH ranked_products AS (
  SELECT 
    p.id,
    p.name,
    c.name AS category,
    p.price,
    SUM(oi.quantity * oi.unit_price) AS revenue,
    RANK() OVER (PARTITION BY c.id ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS rank
  FROM products p
  JOIN categories c ON p.category_id = c.id
  LEFT JOIN order_items oi ON p.id = oi.product_id
  GROUP BY p.id, p.name, c.id, c.name, p.price
)
SELECT * FROM ranked_products WHERE rank <= 3;
```

---

## 🎯 Bài Tập 10: Monthly Sales Trend (Nâng Cao)

### Yêu Cầu
Tạo CTE để tính doanh thu theo tháng & so sánh với tháng trước.

### Gợi Ý
- Sử dụng DATE_TRUNC
- Sử dụng LAG() OVER
- Sử dụng GROUP BY

### Solution
```sql
WITH monthly_sales AS (
  SELECT 
    DATE_TRUNC('month', created_at) AS month,
    COUNT(*) AS order_count,
    SUM(total_amount) AS revenue
  FROM orders
  GROUP BY DATE_TRUNC('month', created_at)
)
SELECT 
  month,
  order_count,
  revenue,
  LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
  revenue - LAG(revenue) OVER (ORDER BY month) AS revenue_change
FROM monthly_sales
ORDER BY month DESC;
```

---

## 🎯 Bài Tập 11: Customer Lifetime Value (Nâng Cao)

### Yêu Cầu
Tạo CTE để tính lifetime value & average order value per customer.

### Gợi Ý
- Sử dụng SUM() & COUNT()
- Sử dụng NULLIF để tránh division by zero

### Solution
```sql
WITH customer_lifetime AS (
  SELECT 
    u.id,
    u.name,
    COUNT(o.id) AS total_orders,
    SUM(o.total_amount) AS lifetime_value
  FROM users u
  LEFT JOIN orders o ON u.id = o.user_id
  GROUP BY u.id, u.name
)
SELECT 
  name,
  total_orders,
  lifetime_value,
  ROUND(lifetime_value / NULLIF(total_orders, 0), 2) AS avg_order_value
FROM customer_lifetime
WHERE lifetime_value > 0
ORDER BY lifetime_value DESC;
```

---

## 🎯 Bài Tập 12: Complex Multi-CTE Query (Nâng Cao)

### Yêu Cầu
Tạo 3 CTEs:
1. order_stats - order statistics
2. product_stats - product statistics
3. combined_stats - kết hợp cả 2

### Gợi Ý
- Sử dụng Multiple CTEs
- Sử dụng Complex JOINs

### Solution
```sql
WITH 
  order_stats AS (
    SELECT 
      user_id,
      COUNT(*) AS order_count,
      SUM(total_amount) AS total_spent
    FROM orders
    GROUP BY user_id
  ),
  product_stats AS (
    SELECT 
      p.id,
      p.name,
      COUNT(DISTINCT oi.order_id) AS times_ordered,
      SUM(oi.quantity * oi.unit_price) AS revenue
    FROM products p
    LEFT JOIN order_items oi ON p.id = oi.product_id
    GROUP BY p.id, p.name
  ),
  combined_stats AS (
    SELECT 
      u.name,
      os.order_count,
      os.total_spent,
      COUNT(DISTINCT ps.id) AS unique_products,
      SUM(ps.revenue) AS product_revenue
    FROM users u
    LEFT JOIN order_stats os ON u.id = os.user_id
    LEFT JOIN orders o ON u.id = o.user_id
    LEFT JOIN order_items oi ON o.id = oi.order_id
    LEFT JOIN product_stats ps ON oi.product_id = ps.id
    GROUP BY u.id, u.name, os.order_count, os.total_spent
  )
SELECT * FROM combined_stats ORDER BY total_spent DESC NULLS LAST;
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-3: Simple & Basic CTEs
- [ ] Bài 4-5: Multiple CTEs
- [ ] Bài 6-7: Recursive CTEs
- [ ] Bài 8-12: Complex CTE Queries

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ Simple CTEs
- ✅ CTEs with JOINs
- ✅ CTEs with Window Functions
- ✅ Multiple CTEs
- ✅ Recursive CTEs
- ✅ Complex CTE Queries

---

**Chúc mừng! Bạn đã hoàn thành Module 2 - Common Table Expressions! 🎉**

