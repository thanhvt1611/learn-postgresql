# 📚 Common Table Expressions (CTEs) - Lý Thuyết

Hiểu cách sử dụng CTEs để viết queries rõ ràng & dễ bảo trì.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu CTEs (WITH clause) là gì
- ✅ Biết cách tạo Simple CTEs
- ✅ Biết cách tạo Multiple CTEs
- ✅ Hiểu Recursive CTEs
- ✅ Biết cách sử dụng CTEs cho complex queries
- ✅ Hiểu CTE best practices

---

## 📋 Common Table Expressions (CTEs)

### Định Nghĩa

**CTE** (Common Table Expression) là một named temporary result set được định nghĩa trong WITH clause.

### Tại Sao Quan Trọng?

1. **Readability** - Queries dễ đọc hơn
2. **Reusability** - Tái sử dụng trong query
3. **Modularity** - Chia nhỏ complex queries
4. **Recursion** - Hỗ trợ recursive queries

### Ví Dụ

```sql
-- Simple CTE
WITH user_orders AS (
  SELECT user_id, COUNT(*) AS order_count
  FROM orders
  GROUP BY user_id
)
SELECT * FROM user_orders WHERE order_count > 5;
```

---

## 🔧 Cú Pháp Cơ Bản

### Simple CTE

```sql
WITH cte_name AS (
  SELECT ...
)
SELECT * FROM cte_name;
```

### Multiple CTEs

```sql
WITH 
  cte1 AS (SELECT ...),
  cte2 AS (SELECT ...)
SELECT * FROM cte1 JOIN cte2 ON ...;
```

### Recursive CTE

```sql
WITH RECURSIVE cte_name AS (
  -- Base case
  SELECT ...
  UNION ALL
  -- Recursive case
  SELECT ... FROM cte_name WHERE ...
)
SELECT * FROM cte_name;
```

---

## 📊 Simple CTEs

### Ví Dụ 1: Basic CTE

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

### Ví Dụ 2: CTE with JOIN

```sql
-- Tính product revenue
WITH product_revenue AS (
  SELECT 
    p.id,
    p.name,
    SUM(oi.quantity * oi.unit_price) AS revenue
  FROM products p
  LEFT JOIN order_items oi ON p.id = oi.product_id
  GROUP BY p.id, p.name
)
SELECT * FROM product_revenue ORDER BY revenue DESC;
```

### Ví Dụ 3: CTE with Window Functions

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

## 🔗 Multiple CTEs

### Ví Dụ 1: Two CTEs

```sql
WITH 
  user_orders AS (
    SELECT user_id, COUNT(*) AS order_count
    FROM orders
    GROUP BY user_id
  ),
  user_details AS (
    SELECT u.id, u.name, uo.order_count
    FROM users u
    JOIN user_orders uo ON u.id = uo.user_id
  )
SELECT * FROM user_details WHERE order_count > 2;
```

### Ví Dụ 2: Three CTEs

```sql
WITH 
  category_stats AS (
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
      c.name,
      cs.product_count,
      pr.revenue
    FROM categories c
    LEFT JOIN category_stats cs ON c.id = cs.category_id
    LEFT JOIN product_revenue pr ON c.id = pr.category_id
  )
SELECT * FROM final_stats;
```

---

## 🔄 Recursive CTEs

### Định Nghĩa

**Recursive CTE** là CTE gọi chính nó để tạo hierarchical data.

### Cú Pháp

```sql
WITH RECURSIVE cte_name AS (
  -- Base case (anchor member)
  SELECT ... WHERE condition
  UNION ALL
  -- Recursive case (recursive member)
  SELECT ... FROM cte_name WHERE condition
)
SELECT * FROM cte_name;
```

### Ví Dụ 1: Number Series

```sql
-- Tạo series từ 1 đến 10
WITH RECURSIVE numbers AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM numbers WHERE n < 10
)
SELECT * FROM numbers;
```

### Ví Dụ 2: Hierarchical Data

```sql
-- Tạo hierarchy từ 1 đến 5
WITH RECURSIVE hierarchy AS (
  SELECT 1 AS level, 'Level 1' AS name
  UNION ALL
  SELECT level + 1, 'Level ' || (level + 1)
  FROM hierarchy
  WHERE level < 5
)
SELECT * FROM hierarchy;
```

### Ví Dụ 3: Tree Structure

```sql
-- Tạo tree structure (nếu có parent_id column)
WITH RECURSIVE category_tree AS (
  SELECT id, name, parent_id, 0 AS level
  FROM categories
  WHERE parent_id IS NULL
  UNION ALL
  SELECT c.id, c.name, c.parent_id, ct.level + 1
  FROM categories c
  JOIN category_tree ct ON c.parent_id = ct.id
)
SELECT * FROM category_tree;
```

---

## 🎯 CTE Best Practices

### ✅ DO

1. **Sử dụng CTEs cho complex queries** - Dễ đọc hơn
2. **Đặt tên rõ ràng** - Mô tả nội dung CTE
3. **Sử dụng Multiple CTEs** - Chia nhỏ logic
4. **Sử dụng Recursive CTEs** - Cho hierarchical data
5. **Comment CTEs** - Giải thích mục đích

### ❌ DON'T

1. **Lạm dụng CTEs** - Cho simple queries
2. **Nested CTEs quá sâu** - Khó bảo trì
3. **Quên UNION ALL** - Trong recursive CTEs
4. **Không có base case** - Trong recursive CTEs
5. **Tạo infinite loops** - Trong recursive CTEs

---

## 📊 Tóm Tắt CTEs

| Khái Niệm | Mô Tả | Khi Dùng |
|-----------|-------|---------|
| **Simple CTE** | Named temporary result set | Complex queries |
| **Multiple CTEs** | Nhiều CTEs trong một query | Modular logic |
| **Recursive CTE** | CTE gọi chính nó | Hierarchical data |
| **WITH Clause** | Định nghĩa CTEs | Trước SELECT |
| **UNION ALL** | Kết hợp base & recursive | Recursive CTEs |

---

## 🎓 Key Takeaways

1. **CTEs** - Named temporary result sets
2. **WITH Clause** - Định nghĩa CTEs
3. **Simple CTEs** - Một CTE
4. **Multiple CTEs** - Nhiều CTEs
5. **Recursive CTEs** - Hierarchical data
6. **Readability** - Queries dễ đọc hơn
7. **Modularity** - Chia nhỏ logic

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL WITH Clause](https://www.postgresql.org/docs/current/queries-with.html)
- [PostgreSQL Recursive CTEs](https://www.postgresql.org/docs/current/queries-with.html#QUERIES-WITH-RECURSIVE)

---

**Bây giờ bạn đã hiểu CTEs! Hãy chuyển sang phần thực hành. 💪**

