# 🛠️ Common Table Expressions (CTEs) - Thực Hành

Thực hành sử dụng CTEs để viết complex queries.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Tạo được Simple CTEs
- ✅ Tạo được Multiple CTEs
- ✅ Tạo được Recursive CTEs
- ✅ Sử dụng được CTEs với Window Functions
- ✅ Viết được complex queries với CTEs

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

## 📊 Bước 2: Thực Hành Simple CTEs

### Thực Hành 2.1: Basic CTE

```sql
-- Tính order statistics per user
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

### Thực Hành 2.2: CTE with JOIN

```sql
-- Tính product revenue
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

### Thực Hành 2.3: CTE with Window Functions

```sql
-- Ranking products per category
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

## 🔗 Bước 3: Thực Hành Multiple CTEs

### Thực Hành 3.1: Two CTEs

```sql
-- Tính user order statistics
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

### Thực Hành 3.2: Three CTEs

```sql
-- Tính category statistics
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

## 🔄 Bước 4: Thực Hành Recursive CTEs

### Thực Hành 4.1: Number Series

```sql
-- Tạo series từ 1 đến 10
WITH RECURSIVE numbers AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM numbers WHERE n < 10
)
SELECT * FROM numbers;
```

### Thực Hành 4.2: Date Series

```sql
-- Tạo date series từ hôm nay đến 7 ngày sau
WITH RECURSIVE date_series AS (
  SELECT CURRENT_DATE AS date
  UNION ALL
  SELECT date + INTERVAL '1 day' FROM date_series WHERE date < CURRENT_DATE + INTERVAL '7 days'
)
SELECT * FROM date_series;
```

### Thực Hành 4.3: Hierarchical Data

```sql
-- Tạo hierarchy từ 1 đến 5
WITH RECURSIVE hierarchy AS (
  SELECT 1 AS level, 'Level 1' AS name, NULL::INT AS parent_level
  UNION ALL
  SELECT level + 1, 'Level ' || (level + 1), level
  FROM hierarchy
  WHERE level < 5
)
SELECT * FROM hierarchy;
```

---

## 🎯 Bước 5: Complex CTE Queries

### Thực Hành 5.1: Customer Segmentation

```sql
-- Phân loại khách hàng
WITH customer_stats AS (
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

### Thực Hành 5.2: Top Products per Category

```sql
-- Top 3 products per category
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

## 📊 Bước 6: CTE with Aggregations

### Thực Hành 6.1: Monthly Sales Trend

```sql
-- Doanh thu theo tháng
WITH monthly_sales AS (
  SELECT 
    DATE_TRUNC('month', created_at) AS month,
    COUNT(*) AS order_count,
    SUM(total_amount) AS revenue,
    AVG(total_amount) AS avg_order
  FROM orders
  GROUP BY DATE_TRUNC('month', created_at)
)
SELECT 
  month,
  order_count,
  revenue,
  avg_order,
  LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue
FROM monthly_sales
ORDER BY month DESC;
```

### Thực Hành 6.2: Customer Lifetime Value

```sql
-- Giá trị suốt đời của khách hàng
WITH customer_lifetime AS (
  SELECT 
    u.id,
    u.name,
    u.created_at,
    COUNT(o.id) AS total_orders,
    SUM(o.total_amount) AS lifetime_value,
    MAX(o.created_at) AS last_purchase
  FROM users u
  LEFT JOIN orders o ON u.id = o.user_id
  GROUP BY u.id, u.name, u.created_at
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

## ✅ Checklist Thực Hành

- [ ] Thực hành Simple CTEs
- [ ] Thực hành CTEs with JOINs
- [ ] Thực hành CTEs with Window Functions
- [ ] Thực hành Multiple CTEs
- [ ] Thực hành Recursive CTEs
- [ ] Thực hành Complex CTE Queries
- [ ] Thực hành CTEs with Aggregations

---

## 💡 Tips

1. **Đặt tên rõ ràng** - Mô tả nội dung CTE
2. **Chia nhỏ logic** - Sử dụng Multiple CTEs
3. **Comment CTEs** - Giải thích mục đích
4. **Test từng CTE** - Trước khi kết hợp
5. **Sử dụng UNION ALL** - Trong recursive CTEs

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

