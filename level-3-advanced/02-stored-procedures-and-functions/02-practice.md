# 🛠️ Stored Procedures & Functions - Thực Hành

Thực hành tạo & sử dụng stored procedures & functions.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Tạo được Functions
- ✅ Tạo được Procedures
- ✅ Sử dụng được PL/pgSQL
- ✅ Implement error handling
- ✅ Tạo được reusable code

---

## 📋 Bước 1: Chuẩn Bị Database

### Bước 1.1: Kết Nối Database

```sql
-- Kết nối
psql -U postgres -d ecommerce_practice

-- Kiểm tra tables
\dt
```

---

## 🔧 Bước 2: Tạo Scalar Functions

### Thực Hành 2.1: Simple Function

```sql
-- Tạo function để tính user order count
CREATE OR REPLACE FUNCTION get_user_order_count(user_id INT) 
RETURNS INT AS $$
BEGIN
  RETURN (SELECT COUNT(*) FROM orders WHERE user_id = $1);
END;
$$ LANGUAGE plpgsql;

-- Sử dụng function
SELECT get_user_order_count(1);
```

### Thực Hành 2.2: Function with Calculation

```sql
-- Tạo function để tính user total spent
CREATE OR REPLACE FUNCTION get_user_total_spent(user_id INT) 
RETURNS DECIMAL AS $$
BEGIN
  RETURN (SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE user_id = $1);
END;
$$ LANGUAGE plpgsql;

-- Sử dụng function
SELECT get_user_total_spent(1);
```

### Thực Hành 2.3: Function with Multiple Parameters

```sql
-- Tạo function để tính discount
CREATE OR REPLACE FUNCTION calculate_discount(amount DECIMAL, discount_percent DECIMAL) 
RETURNS DECIMAL AS $$
BEGIN
  RETURN amount * (1 - discount_percent / 100);
END;
$$ LANGUAGE plpgsql;

-- Sử dụng function
SELECT calculate_discount(100, 10);
```

---

## 📊 Bước 3: Tạo Table Functions

### Thực Hành 3.1: Table Function

```sql
-- Tạo function để lấy user orders
CREATE OR REPLACE FUNCTION get_user_orders(user_id INT) 
RETURNS TABLE(order_id INT, total_amount DECIMAL, created_at TIMESTAMP) AS $$
BEGIN
  RETURN QUERY SELECT id, total_amount, created_at FROM orders WHERE user_id = $1;
END;
$$ LANGUAGE plpgsql;

-- Sử dụng function
SELECT * FROM get_user_orders(1);
```

### Thực Hành 3.2: Table Function with Filter

```sql
-- Tạo function để lấy recent orders
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

-- Sử dụng function
SELECT * FROM get_recent_orders(30);
```

---

## 🔄 Bước 4: Tạo Procedures

### Thực Hành 4.1: Simple Procedure

```sql
-- Tạo procedure để insert product
CREATE OR REPLACE PROCEDURE insert_product(name VARCHAR, price DECIMAL) AS $$
BEGIN
  INSERT INTO products (name, price) VALUES (name, price);
  COMMIT;
END;
$$ LANGUAGE plpgsql;

-- Sử dụng procedure
CALL insert_product('New Product', 500);
```

### Thực Hành 4.2: Procedure with Output Parameters

```sql
-- Tạo procedure để lấy user stats
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

-- Sử dụng procedure
CALL get_user_stats(1, order_count, total_spent);
SELECT order_count, total_spent;
```

### Thực Hành 4.3: Procedure with Logic

```sql
-- Tạo procedure để update order status
CREATE OR REPLACE PROCEDURE update_order_status(order_id INT, new_status VARCHAR) AS $$
BEGIN
  UPDATE orders SET status = new_status WHERE id = order_id;
  COMMIT;
END;
$$ LANGUAGE plpgsql;

-- Sử dụng procedure
CALL update_order_status(1, 'shipped');
```

---

## 🛡️ Bước 5: Error Handling

### Thực Hành 5.1: RAISE Exception

```sql
-- Tạo function dengan error handling
CREATE OR REPLACE FUNCTION validate_price(price DECIMAL) 
RETURNS VOID AS $$
BEGIN
  IF price < 0 THEN
    RAISE EXCEPTION 'Price cannot be negative';
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Test function
SELECT validate_price(100);
SELECT validate_price(-50);  -- Will raise exception
```

### Thực Hành 5.2: Exception Handling

```sql
-- Tạo function dengan exception handling
CREATE OR REPLACE FUNCTION safe_divide(a INT, b INT) 
RETURNS DECIMAL AS $$
BEGIN
  RETURN a::DECIMAL / b;
EXCEPTION WHEN division_by_zero THEN
  RAISE EXCEPTION 'Cannot divide by zero';
END;
$$ LANGUAGE plpgsql;

-- Test function
SELECT safe_divide(10, 2);
SELECT safe_divide(10, 0);  -- Will raise exception
```

---

## 🔀 Bước 6: Control Flow

### Thực Hành 6.1: IF Statement

```sql
-- Tạo function dengan IF statement
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

-- Test function
SELECT get_user_segment(1500);
SELECT get_user_segment(600);
```

### Thực Hành 6.2: LOOP

```sql
-- Tạo function với LOOP
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

-- Test function
SELECT * FROM generate_numbers(5);
```

---

## 📈 Bước 7: Advanced Functions

### Thực Hành 7.1: Function with Aggregation

```sql
-- Tạo function để lấy product statistics
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

-- Test function
SELECT * FROM get_product_stats(1);
```

---

## ✅ Checklist Thực Hành

- [ ] Tạo Scalar Functions
- [ ] Tạo Table Functions
- [ ] Tạo Procedures
- [ ] Implement error handling
- [ ] Sử dụng IF statements
- [ ] Sử dụng LOOP
- [ ] Advanced functions
- [ ] Test all functions

---

## 💡 Tips

1. **Sử dụng OR REPLACE** - Để update functions
2. **Validate inputs** - Trước khi process
3. **Handle errors** - Với RAISE & EXCEPTION
4. **Use meaningful names** - Cho functions & procedures
5. **Document code** - Với comments

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

