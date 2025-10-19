# 📚 Window Functions - Lý Thuyết

Hiểu cách sử dụng Window Functions để phân tích dữ liệu nâng cao.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu Window Functions là gì
- ✅ Biết các loại Window Functions
- ✅ Sử dụng được OVER, PARTITION BY, ORDER BY
- ✅ Sử dụng được Ranking Functions
- ✅ Sử dụng được Aggregate Window Functions
- ✅ Sử dụng được Frame Clauses

---

## 🪟 Window Functions - Hàm Cửa Sổ

### Định Nghĩa

**Window Function** là một hàm được áp dụng trên một tập hợp rows (window) liên quan đến row hiện tại.

### Tại Sao Quan Trọng?

1. **Phân tích dữ liệu** - So sánh với các rows khác
2. **Ranking** - Xếp hạng rows
3. **Running totals** - Tính tổng tích lũy
4. **Lag/Lead** - So sánh với rows trước/sau

### Ví Dụ

```sql
-- Tính tổng doanh thu & running total
SELECT 
  order_date,
  total_amount,
  SUM(total_amount) OVER (ORDER BY order_date) AS running_total
FROM orders;
```

---

## 🔧 Cú Pháp Cơ Bản

### OVER Clause

```sql
function_name() OVER (
  [PARTITION BY column1, column2, ...]
  [ORDER BY column1 [ASC|DESC], ...]
  [frame_clause]
)
```

### Ví Dụ

```sql
-- Ranking users theo total_amount
SELECT 
  user_id,
  total_amount,
  ROW_NUMBER() OVER (ORDER BY total_amount DESC) AS rank
FROM orders;

-- Ranking per category
SELECT 
  category_id,
  product_id,
  price,
  ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS rank
FROM products;
```

---

## 🏆 Ranking Functions

### 1. ROW_NUMBER()

**Định nghĩa:** Gán số thứ tự duy nhất cho mỗi row.

```sql
SELECT 
  name,
  salary,
  ROW_NUMBER() OVER (ORDER BY salary DESC) AS rank
FROM employees;
```

**Output:**
```
 name  | salary | rank
-------+--------+------
 Alice |  5000  |  1
 Bob   |  4500  |  2
 Carol |  4500  |  3
 Dave  |  4000  |  4
```

### 2. RANK()

**Định nghĩa:** Gán rank, rows có giá trị bằng nhau có rank bằng nhau.

```sql
SELECT 
  name,
  salary,
  RANK() OVER (ORDER BY salary DESC) AS rank
FROM employees;
```

**Output:**
```
 name  | salary | rank
-------+--------+------
 Alice |  5000  |  1
 Bob   |  4500  |  2
 Carol |  4500  |  2
 Dave  |  4000  |  4
```

### 3. DENSE_RANK()

**Định nghĩa:** Gán rank liên tục, không có gap.

```sql
SELECT 
  name,
  salary,
  DENSE_RANK() OVER (ORDER BY salary DESC) AS rank
FROM employees;
```

**Output:**
```
 name  | salary | rank
-------+--------+------
 Alice |  5000  |  1
 Bob   |  4500  |  2
 Carol |  4500  |  2
 Dave  |  4000  |  3
```

### 4. NTILE()

**Định nghĩa:** Chia rows thành N buckets.

```sql
SELECT 
  name,
  salary,
  NTILE(4) OVER (ORDER BY salary DESC) AS quartile
FROM employees;
```

---

## 📊 Aggregate Window Functions

### SUM() OVER

```sql
-- Running total
SELECT 
  order_date,
  total_amount,
  SUM(total_amount) OVER (ORDER BY order_date) AS running_total
FROM orders;
```

### AVG() OVER

```sql
-- Average per category
SELECT 
  product_id,
  price,
  category_id,
  AVG(price) OVER (PARTITION BY category_id) AS category_avg
FROM products;
```

### COUNT() OVER

```sql
-- Count orders per user
SELECT 
  user_id,
  order_id,
  COUNT(*) OVER (PARTITION BY user_id) AS user_order_count
FROM orders;
```

### MIN() / MAX() OVER

```sql
-- Min & max price per category
SELECT 
  product_id,
  price,
  category_id,
  MIN(price) OVER (PARTITION BY category_id) AS min_price,
  MAX(price) OVER (PARTITION BY category_id) AS max_price
FROM products;
```

---

## ⬅️➡️ Lag & Lead Functions

### LAG()

**Định nghĩa:** Lấy giá trị từ row trước đó.

```sql
SELECT 
  order_date,
  total_amount,
  LAG(total_amount) OVER (ORDER BY order_date) AS prev_amount,
  total_amount - LAG(total_amount) OVER (ORDER BY order_date) AS difference
FROM orders;
```

### LEAD()

**Định nghĩa:** Lấy giá trị từ row tiếp theo.

```sql
SELECT 
  order_date,
  total_amount,
  LEAD(total_amount) OVER (ORDER BY order_date) AS next_amount
FROM orders;
```

---

## 📍 FIRST_VALUE & LAST_VALUE

### FIRST_VALUE()

```sql
SELECT 
  user_id,
  order_date,
  total_amount,
  FIRST_VALUE(total_amount) OVER (PARTITION BY user_id ORDER BY order_date) AS first_order
FROM orders;
```

### LAST_VALUE()

```sql
SELECT 
  user_id,
  order_date,
  total_amount,
  LAST_VALUE(total_amount) OVER (
    PARTITION BY user_id 
    ORDER BY order_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS last_order
FROM orders;
```

---

## 📐 Frame Clauses

### ROWS BETWEEN

```sql
-- 3-row moving average
SELECT 
  order_date,
  total_amount,
  AVG(total_amount) OVER (
    ORDER BY order_date
    ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
  ) AS moving_avg
FROM orders;
```

### RANGE BETWEEN

```sql
-- Sum within date range
SELECT 
  order_date,
  total_amount,
  SUM(total_amount) OVER (
    ORDER BY order_date
    RANGE BETWEEN INTERVAL '7 days' PRECEDING AND CURRENT ROW
  ) AS weekly_total
FROM orders;
```

---

## 📊 Tóm Tắt Window Functions

| Hàm | Mô Tả | Ví Dụ |
|-----|-------|-------|
| **ROW_NUMBER()** | Số thứ tự duy nhất | Ranking |
| **RANK()** | Rank với gaps | Ranking |
| **DENSE_RANK()** | Rank liên tục | Ranking |
| **NTILE()** | Chia thành N buckets | Quartiles |
| **SUM() OVER** | Tổng trong window | Running total |
| **AVG() OVER** | Trung bình trong window | Category average |
| **LAG()** | Row trước đó | Comparison |
| **LEAD()** | Row tiếp theo | Comparison |
| **FIRST_VALUE()** | Giá trị đầu tiên | First order |
| **LAST_VALUE()** | Giá trị cuối cùng | Last order |

---

## 🎓 Key Takeaways

1. **Window Functions** - Phân tích dữ liệu nâng cao
2. **OVER Clause** - Định nghĩa window
3. **PARTITION BY** - Chia thành groups
4. **ORDER BY** - Sắp xếp trong window
5. **Ranking Functions** - ROW_NUMBER, RANK, DENSE_RANK
6. **Aggregate Functions** - SUM, AVG, COUNT, MIN, MAX
7. **Lag/Lead** - So sánh với rows khác
8. **Frame Clauses** - ROWS BETWEEN, RANGE BETWEEN

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL Window Functions](https://www.postgresql.org/docs/current/functions-window.html)
- [PostgreSQL OVER Clause](https://www.postgresql.org/docs/current/sql-expressions.html#SYNTAX-WINDOW-FUNCTIONS)

---

**Bây giờ bạn đã hiểu Window Functions! Hãy chuyển sang phần thực hành. 💪**

