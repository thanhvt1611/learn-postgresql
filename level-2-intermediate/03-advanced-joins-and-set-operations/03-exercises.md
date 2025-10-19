# 💪 Advanced Joins & Set Operations - Bài Tập

Thực hành sử dụng advanced joins & set operations.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có database "ecommerce_practice" với sample data

---

## 🎯 Bài Tập 1: Self Join - Find Duplicates (Dễ)

### Yêu Cầu
Tìm products có cùng name.

### Gợi Ý
- Sử dụng Self Join
- Sử dụng id < để tránh duplicates

### Solution
```sql
SELECT 
  p1.id,
  p1.name,
  p2.id,
  p2.name
FROM products p1
JOIN products p2 ON p1.name = p2.name AND p1.id < p2.id;
```

---

## 🎯 Bài Tập 2: Self Join - Find Same Price (Trung Bình)

### Yêu Cầu
Tìm products có cùng price.

### Gợi Ý
- Sử dụng Self Join
- Sử dụng price = price

### Solution
```sql
SELECT 
  p1.id,
  p1.name,
  p1.price,
  p2.id,
  p2.name,
  p2.price
FROM products p1
JOIN products p2 ON p1.price = p2.price AND p1.id < p2.id;
```

---

## 🎯 Bài Tập 3: Self Join - Find Same City (Trung Bình)

### Yêu Cầu
Tìm users ở cùng city.

### Gợi Ý
- Sử dụng Self Join
- Sử dụng city = city

### Solution
```sql
SELECT 
  u1.id,
  u1.name,
  u1.city,
  u2.id,
  u2.name,
  u2.city
FROM users u1
JOIN users u2 ON u1.city = u2.city AND u1.id < u2.id
WHERE u1.city IS NOT NULL;
```

---

## 🎯 Bài Tập 4: Cross Join - Generate Combinations (Trung Bình)

### Yêu Cầu
Tạo tất cả combinations của categories & users.

### Gợi Ý
- Sử dụng CROSS JOIN
- Sử dụng LIMIT để giới hạn results

### Solution
```sql
SELECT 
  c.id AS category_id,
  c.name AS category,
  u.id AS user_id,
  u.name AS user
FROM categories c
CROSS JOIN users u
LIMIT 20;
```

---

## 🎯 Bài Tập 5: Cross Join - Generate Date Range (Trung Bình)

### Yêu Cầu
Tạo tất cả combinations của dates (7 ngày) & products.

### Gợi Ý
- Sử dụng CROSS JOIN
- Sử dụng generate_series

### Solution
```sql
SELECT 
  d.date,
  p.id,
  p.name
FROM (
  SELECT CURRENT_DATE + i AS date
  FROM generate_series(0, 7) AS i
) d
CROSS JOIN products p
ORDER BY d.date, p.id;
```

---

## 🎯 Bài Tập 6: UNION - Combine Results (Dễ)

### Yêu Cầu
Kết hợp users có age > 25 & users ở New York, loại bỏ duplicates.

### Gợi Ý
- Sử dụng UNION
- Sử dụng WHERE clauses

### Solution
```sql
SELECT name, email FROM users WHERE age > 25
UNION
SELECT name, email FROM users WHERE city = 'New York';
```

---

## 🎯 Bài Tập 7: UNION ALL - Keep Duplicates (Dễ)

### Yêu Cầu
Kết hợp users có age > 25 & users ở New York, giữ duplicates.

### Gợi Ý
- Sử dụng UNION ALL
- Sử dụng WHERE clauses

### Solution
```sql
SELECT name, email FROM users WHERE age > 25
UNION ALL
SELECT name, email FROM users WHERE city = 'New York';
```

---

## 🎯 Bài Tập 8: UNION with ORDER BY (Trung Bình)

### Yêu Cầu
Kết hợp users & categories, thêm type column, sắp xếp theo name.

### Gợi Ý
- Sử dụng UNION
- Sử dụng ORDER BY

### Solution
```sql
SELECT name, 'user' AS type FROM users
UNION
SELECT name, 'category' AS type FROM categories
ORDER BY name;
```

---

## 🎯 Bài Tập 9: INTERSECT - Find Common Data (Nâng Cao)

### Yêu Cầu
Tìm products được order bởi user 1 & user 2.

### Gợi Ý
- Sử dụng INTERSECT
- Sử dụng Subqueries

### Solution
```sql
SELECT DISTINCT product_id FROM order_items
WHERE order_id IN (SELECT id FROM orders WHERE user_id = 1)
INTERSECT
SELECT DISTINCT product_id FROM order_items
WHERE order_id IN (SELECT id FROM orders WHERE user_id = 2);
```

---

## 🎯 Bài Tập 10: EXCEPT - Find Differences (Nâng Cao)

### Yêu Cầu
Tìm products không được order.

### Gợi Ý
- Sử dụng EXCEPT
- Sử dụng DISTINCT

### Solution
```sql
SELECT id FROM products
EXCEPT
SELECT DISTINCT product_id FROM order_items;
```

---

## 🎯 Bài Tập 11: EXCEPT - Find Inactive Users (Nâng Cao)

### Yêu Cầu
Tìm users không có orders.

### Gợi Ý
- Sử dụng EXCEPT
- Sử dụng DISTINCT

### Solution
```sql
SELECT id FROM users
EXCEPT
SELECT DISTINCT user_id FROM orders;
```

---

## 🎯 Bài Tập 12: Complex Set Operations (Nâng Cao)

### Yêu Cầu
Kết hợp 3 queries (users, categories, products) với type column.

### Gợi Ý
- Sử dụng Multiple UNIONs
- Sử dụng ORDER BY

### Solution
```sql
SELECT name, 'user' AS type FROM users
UNION
SELECT name, 'category' AS type FROM categories
UNION
SELECT name, 'product' AS type FROM products
ORDER BY type, name;
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-3: Self Joins
- [ ] Bài 4-5: Cross Joins
- [ ] Bài 6-8: UNION & UNION ALL
- [ ] Bài 9-11: INTERSECT & EXCEPT
- [ ] Bài 12: Complex Set Operations

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ Self Joins
- ✅ Cross Joins
- ✅ UNION & UNION ALL
- ✅ INTERSECT
- ✅ EXCEPT
- ✅ Complex Set Operations

---

**Chúc mừng! Bạn đã hoàn thành Module 3 - Advanced Joins & Set Operations! 🎉**

