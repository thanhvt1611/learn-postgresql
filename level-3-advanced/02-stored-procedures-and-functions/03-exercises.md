# 💪 Stored Procedures & Functions - Bài Tập

Thực hành tạo & sử dụng stored procedures & functions.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có database "ecommerce_practice" với sample data

---

## 🎯 Bài Tập 1: Simple Scalar Function (Dễ)

### Yêu Cầu
Tạo function để tính user order count.

### Gợi Ý
- Sử dụng CREATE FUNCTION
- Sử dụng SELECT COUNT(*)

### Solution
```sql
CREATE OR REPLACE FUNCTION get_user_order_count(user_id INT) 
RETURNS INT AS $$
BEGIN
  RETURN (SELECT COUNT(*) FROM orders WHERE user_id = $1);
END;
$$ LANGUAGE plpgsql;

SELECT get_user_order_count(1);
```

---

## 🎯 Bài Tập 2: Function with Calculation (Dễ)

### Yêu Cầu
Tạo function để tính user total spent.

### Gợi Ý
- Sử dụng CREATE FUNCTION
- Sử dụng SUM()

### Solution
```sql
CREATE OR REPLACE FUNCTION get_user_total_spent(user_id INT) 
RETURNS DECIMAL AS $$
BEGIN
  RETURN (SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE user_id = $1);
END;
$$ LANGUAGE plpgsql;

SELECT get_user_total_spent(1);
```

---

## 🎯 Bài Tập 3: Function with Multiple Parameters (Dễ)

### Yêu Cầu
Tạo function để tính discount.

### Gợi Ý
- Sử dụng CREATE FUNCTION
- Sử dụng multiple parameters

### Solution
```sql
CREATE OR REPLACE FUNCTION calculate_discount(amount DECIMAL, discount_percent DECIMAL) 
RETURNS DECIMAL AS $$
BEGIN
  RETURN amount * (1 - discount_percent / 100);
END;
$$ LANGUAGE plpgsql;

SELECT calculate_discount(100, 10);
```

---

## 🎯 Bài Tập 4: Table Function (Trung Bình)

### Yêu Cầu
Tạo function để lấy user orders.

### Gợi Ý
- Sử dụng CREATE FUNCTION
- Sử dụng RETURNS TABLE

### Solution
```sql
CREATE OR REPLACE FUNCTION get_user_orders(user_id INT) 
RETURNS TABLE(order_id INT, total_amount DECIMAL, created_at TIMESTAMP) AS $$
BEGIN
  RETURN QUERY SELECT id, total_amount, created_at FROM orders WHERE user_id = $1;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_user_orders(1);
```

---

## 🎯 Bài Tập 5: Table Function with Filter (Trung Bình)

### Yêu Cầu
Tạo function để lấy recent orders.

### Gợi Ý
- Sử dụng CREATE FUNCTION
- Sử dụng INTERVAL

### Solution
```sql
CREATE OR REPLACE FUNCTION get_recent_orders(days INT) 
RETURNS TABLE(order_id INT, user_id INT, total_amount DECIMAL, created_at TIMESTAMP) AS $$
BEGIN
  RETURN QUERY 
  SELECT id, user_id, total_amount, created_at 
  FROM orders 
  WHERE created_at >= CURRENT_DATE - (days || ' days')::INTERVAL
  ORDER BY created_at DESC;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_recent_orders(30);
```

---

## 🎯 Bài Tập 6: Simple Procedure (Trung Bình)

### Yêu Cầu
Tạo procedure để insert product.

### Gợi Ý
- Sử dụng CREATE PROCEDURE
- Sử dụng INSERT

### Solution
```sql
CREATE OR REPLACE PROCEDURE insert_product(name VARCHAR, price DECIMAL) AS $$
BEGIN
  INSERT INTO products (name, price) VALUES (name, price);
  COMMIT;
END;
$$ LANGUAGE plpgsql;

CALL insert_product('New Product', 500);
```

---

## 🎯 Bài Tập 7: Procedure with Output Parameters (Trung Bình)

### Yêu Cầu
Tạo procedure để lấy user stats.

### Gợi Ý
- Sử dụng CREATE PROCEDURE
- Sử dụng OUT parameters

### Solution
```sql
CREATE OR REPLACE PROCEDURE get_user_stats(
  user_id INT, 
  OUT order_count INT, 
  OUT total_spent DECIMAL
) AS $$
BEGIN
  SELECT COUNT(*), COALESCE(SUM(total_amount), 0) 
  INTO order_count, total_spent
  FROM orders WHERE user_id = $1;
END;
$$ LANGUAGE plpgsql;

CALL get_user_stats(1, order_count, total_spent);
```

---

## 🎯 Bài Tập 8: Error Handling (Nâng Cao)

### Yêu Cầu
Tạo function với error handling.

### Gợi Ý
- Sử dụng RAISE EXCEPTION
- Sử dụng IF statement

### Solution
```sql
CREATE OR REPLACE FUNCTION validate_price(price DECIMAL) 
RETURNS VOID AS $$
BEGIN
  IF price < 0 THEN
    RAISE EXCEPTION 'Price cannot be negative';
  END IF;
END;
$$ LANGUAGE plpgsql;

SELECT validate_price(100);
```

---

## 🎯 Bài Tập 9: Exception Handling (Nâng Cao)

### Yêu Cầu
Tạo function với exception handling.

### Gợi Ý
- Sử dụng EXCEPTION WHEN
- Sử dụng RAISE EXCEPTION

### Solution
```sql
CREATE OR REPLACE FUNCTION safe_divide(a INT, b INT) 
RETURNS DECIMAL AS $$
BEGIN
  RETURN a::DECIMAL / b;
EXCEPTION WHEN division_by_zero THEN
  RAISE EXCEPTION 'Cannot divide by zero';
END;
$$ LANGUAGE plpgsql;

SELECT safe_divide(10, 2);
```

---

## 🎯 Bài Tập 10: IF Statement (Nâng Cao)

### Yêu Cầu
Tạo function để classify user segment.

### Gợi Ý
- Sử dụng IF ELSIF ELSE
- Sử dụng RETURN

### Solution
```sql
CREATE OR REPLACE FUNCTION get_user_segment(total_spent DECIMAL) 
RETURNS VARCHAR AS $$
BEGIN
  IF total_spent > 1000 THEN
    RETURN 'VIP';
  ELSIF total_spent > 500 THEN
    RETURN 'Premium';
  ELSIF total_spent > 100 THEN
    RETURN 'Regular';
  ELSE
    RETURN 'New';
  END IF;
END;
$$ LANGUAGE plpgsql;

SELECT get_user_segment(1500);
```

---

## 🎯 Bài Tập 11: LOOP (Nâng Cao)

### Yêu Cầu
Tạo function để generate numbers.

### Gợi Ý
- Sử dụng LOOP
- Sử dụng EXIT WHEN

### Solution
```sql
CREATE OR REPLACE FUNCTION generate_numbers(n INT) 
RETURNS TABLE(number INT) AS $$
DECLARE
  i INT := 1;
BEGIN
  LOOP
    RETURN NEXT i;
    i := i + 1;
    EXIT WHEN i > n;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM generate_numbers(5);
```

---

## 🎯 Bài Tập 12: Advanced Function (Nâng Cao)

### Yêu Cầu
Tạo function để lấy product statistics.

### Gợi Ý
- Sử dụng CREATE FUNCTION
- Sử dụng RETURNS TABLE
- Sử dụng aggregations

### Solution
```sql
CREATE OR REPLACE FUNCTION get_product_stats(product_id INT) 
RETURNS TABLE(
  product_name VARCHAR,
  total_sold INT,
  total_revenue DECIMAL,
  avg_price DECIMAL
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.name,
    COALESCE(SUM(oi.quantity), 0)::INT,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0),
    COALESCE(AVG(oi.unit_price), 0)
  FROM products p
  LEFT JOIN order_items oi ON p.id = oi.product_id
  WHERE p.id = $1
  GROUP BY p.id, p.name;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_product_stats(1);
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-3: Scalar Functions
- [ ] Bài 4-5: Table Functions
- [ ] Bài 6-7: Procedures
- [ ] Bài 8-9: Error Handling
- [ ] Bài 10-12: Advanced Functions

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ Scalar Functions
- ✅ Table Functions
- ✅ Procedures
- ✅ Output parameters
- ✅ Error handling
- ✅ IF statements
- ✅ LOOP
- ✅ Advanced functions

---

**Chúc mừng! Bạn đã hoàn thành Module 2 - Stored Procedures & Functions! 🎉**

