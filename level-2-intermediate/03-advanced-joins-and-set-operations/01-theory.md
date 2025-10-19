# 📚 Advanced Joins & Set Operations - Lý Thuyết

Hiểu cách sử dụng advanced joins & set operations để kết hợp dữ liệu.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu Self Joins
- ✅ Hiểu Cross Joins
- ✅ Biết cách sử dụng UNION, UNION ALL
- ✅ Biết cách sử dụng INTERSECT
- ✅ Biết cách sử dụng EXCEPT
- ✅ Hiểu Set Operations best practices

---

## 🔗 Self Joins

### Định Nghĩa

**Self Join** là khi một table được join với chính nó.

### Tại Sao Quan Trọng?

1. **Hierarchical data** - Tìm parent/child relationships
2. **Comparisons** - So sánh rows trong cùng table
3. **Duplicates** - Tìm duplicate records

### Ví Dụ 1: Find Employees with Same Salary

```sql
-- Tìm employees có cùng salary
SELECT 
  e1.name AS employee1,
  e2.name AS employee2,
  e1.salary
FROM employees e1
JOIN employees e2 ON e1.salary = e2.salary AND e1.id < e2.id;
```

### Ví Dụ 2: Manager-Employee Relationship

```sql
-- Tìm manager của mỗi employee
SELECT 
  e.name AS employee,
  m.name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;
```

### Ví Dụ 3: Find Duplicate Products

```sql
-- Tìm products có cùng name
SELECT 
  p1.id,
  p1.name,
  p2.id,
  p2.name
FROM products p1
JOIN products p2 ON p1.name = p2.name AND p1.id < p2.id;
```

---

## ✖️ Cross Joins

### Định Nghĩa

**Cross Join** tạo Cartesian product - mỗi row từ table 1 kết hợp với mỗi row từ table 2.

### Cú Pháp

```sql
SELECT * FROM table1 CROSS JOIN table2;
-- Hoặc
SELECT * FROM table1, table2;
```

### Ví Dụ 1: Generate All Combinations

```sql
-- Tạo tất cả combinations của colors & sizes
SELECT 
  c.color,
  s.size
FROM colors c
CROSS JOIN sizes s;
```

### Ví Dụ 2: Generate Date Range

```sql
-- Tạo tất cả combinations của dates & products
SELECT 
  d.date,
  p.id,
  p.name
FROM (
  SELECT CURRENT_DATE + i AS date
  FROM generate_series(0, 30) AS i
) d
CROSS JOIN products p;
```

---

## 🔀 UNION & UNION ALL

### Định Nghĩa

**UNION** kết hợp kết quả từ 2 queries, loại bỏ duplicates.
**UNION ALL** kết hợp kết quả từ 2 queries, giữ duplicates.

### Cú Pháp

```sql
SELECT ... FROM table1
UNION
SELECT ... FROM table2;
```

### Ví Dụ 1: UNION - Remove Duplicates

```sql
-- Kết hợp users từ 2 tables, loại bỏ duplicates
SELECT name, email FROM users_table1
UNION
SELECT name, email FROM users_table2;
```

### Ví Dụ 2: UNION ALL - Keep Duplicates

```sql
-- Kết hợp users từ 2 tables, giữ duplicates
SELECT name, email FROM users_table1
UNION ALL
SELECT name, email FROM users_table2;
```

### Ví Dụ 3: UNION with ORDER BY

```sql
-- Kết hợp & sắp xếp
SELECT name, 'customer' AS type FROM customers
UNION
SELECT name, 'supplier' AS type FROM suppliers
ORDER BY name;
```

---

## ∩ INTERSECT

### Định Nghĩa

**INTERSECT** trả về rows xuất hiện trong cả 2 queries.

### Cú Pháp

```sql
SELECT ... FROM table1
INTERSECT
SELECT ... FROM table2;
```

### Ví Dụ 1: Find Common Users

```sql
-- Tìm users xuất hiện trong cả 2 tables
SELECT name, email FROM users_table1
INTERSECT
SELECT name, email FROM users_table2;
```

### Ví Dụ 2: Find Products Ordered by Multiple Users

```sql
-- Tìm products được order bởi user 1 & user 2
SELECT product_id FROM orders WHERE user_id = 1
INTERSECT
SELECT product_id FROM orders WHERE user_id = 2;
```

---

## − EXCEPT

### Định Nghĩa

**EXCEPT** trả về rows từ query 1 nhưng không có trong query 2.

### Cú Pháp

```sql
SELECT ... FROM table1
EXCEPT
SELECT ... FROM table2;
```

### Ví Dụ 1: Find Users Only in Table 1

```sql
-- Tìm users chỉ có trong table1
SELECT name, email FROM users_table1
EXCEPT
SELECT name, email FROM users_table2;
```

### Ví Dụ 2: Find Products Not Ordered

```sql
-- Tìm products không được order
SELECT id FROM products
EXCEPT
SELECT DISTINCT product_id FROM order_items;
```

### Ví Dụ 3: Find Inactive Users

```sql
-- Tìm users không có orders
SELECT id FROM users
EXCEPT
SELECT DISTINCT user_id FROM orders;
```

---

## 📊 Tóm Tắt Advanced Joins & Set Operations

| Khái Niệm | Mô Tả | Khi Dùng |
|-----------|-------|---------|
| **Self Join** | Join table với chính nó | Hierarchical data |
| **Cross Join** | Cartesian product | Generate combinations |
| **UNION** | Kết hợp, loại bỏ duplicates | Combine results |
| **UNION ALL** | Kết hợp, giữ duplicates | Combine results |
| **INTERSECT** | Rows trong cả 2 queries | Find common data |
| **EXCEPT** | Rows trong query 1 nhưng không trong query 2 | Find differences |

---

## 🎓 Key Takeaways

1. **Self Joins** - Join table với chính nó
2. **Cross Joins** - Cartesian product
3. **UNION** - Kết hợp, loại bỏ duplicates
4. **UNION ALL** - Kết hợp, giữ duplicates
5. **INTERSECT** - Rows trong cả 2 queries
6. **EXCEPT** - Rows trong query 1 nhưng không trong query 2
7. **Set Operations** - Phải có cùng số columns & data types

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL Joins](https://www.postgresql.org/docs/current/queries-table-expressions.html#QUERIES-JOIN)
- [PostgreSQL Set Operations](https://www.postgresql.org/docs/current/queries-union.html)

---

**Bây giờ bạn đã hiểu Advanced Joins & Set Operations! Hãy chuyển sang phần thực hành. 💪**

