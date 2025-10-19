# 📚 Stored Procedures & Functions - Lý Thuyết

Hiểu cách tạo & sử dụng stored procedures & functions.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu Functions là gì
- ✅ Hiểu Stored Procedures là gì
- ✅ Biết cách tạo Functions
- ✅ Biết cách tạo Stored Procedures
- ✅ Sử dụng được PL/pgSQL
- ✅ Hiểu Functions & Procedures best practices

---

## 🔧 Functions vs Procedures

### Functions

**Định nghĩa:** Reusable code blocks trả về value.

**Ưu Điểm:**
- Trả về value
- Có thể sử dụng trong SELECT
- Composable

**Ví Dụ:**
```sql
CREATE FUNCTION get_user_order_count(user_id INT) RETURNS INT AS $$
BEGIN
  RETURN (SELECT COUNT(*) FROM orders WHERE user_id = $1);
END;
$$ LANGUAGE plpgsql;

SELECT get_user_order_count(1);
```

### Procedures

**Định nghĩa:** Reusable code blocks thực thi actions.

**Ưu Điểm:**
- Thực thi complex logic
- Có thể modify data
- Có thể return multiple values

**Ví Dụ:**
```sql
CREATE PROCEDURE create_order(user_id INT, total_amount DECIMAL) AS $$
BEGIN
  INSERT INTO orders (user_id, total_amount) VALUES (user_id, total_amount);
  COMMIT;
END;
$$ LANGUAGE plpgsql;

CALL create_order(1, 100);
```

---

## 📝 PL/pgSQL Basics

### Cú Pháp

```sql
CREATE FUNCTION function_name(param1 TYPE, param2 TYPE) 
RETURNS return_type AS $$
DECLARE
  -- Variable declarations
  variable_name TYPE;
BEGIN
  -- Function logic
  RETURN value;
END;
$$ LANGUAGE plpgsql;
```

### Variables

```sql
DECLARE
  user_id INT;
  user_name VARCHAR(255);
  total_amount DECIMAL;
BEGIN
  -- Use variables
  user_id := 1;
  user_name := 'John Doe';
END;
```

### Control Flow

```sql
-- IF statement
IF condition THEN
  -- Do something
ELSIF condition THEN
  -- Do something else
ELSE
  -- Default
END IF;

-- LOOP
LOOP
  -- Do something
  EXIT WHEN condition;
END LOOP;

-- FOR loop
FOR i IN 1..10 LOOP
  -- Do something
END LOOP;
```

---

## 🔄 Function Types

### Scalar Functions

**Định nghĩa:** Trả về single value.

```sql
CREATE FUNCTION get_product_price(product_id INT) RETURNS DECIMAL AS $$
BEGIN
  RETURN (SELECT price FROM products WHERE id = product_id);
END;
$$ LANGUAGE plpgsql;
```

### Table Functions

**Định nghĩa:** Trả về table/rows.

```sql
CREATE FUNCTION get_user_orders(user_id INT) 
RETURNS TABLE(order_id INT, total_amount DECIMAL) AS $$
BEGIN
  RETURN QUERY SELECT id, total_amount FROM orders WHERE user_id = $1;
END;
$$ LANGUAGE plpgsql;
```

### Aggregate Functions

**Định nghĩa:** Aggregate multiple rows.

```sql
CREATE AGGREGATE sum_custom(INT) (
  SFUNC = int4pl,
  STYPE = INT
);
```

---

## 🎯 Stored Procedures

### Basic Procedure

```sql
CREATE PROCEDURE insert_product(name VARCHAR, price DECIMAL) AS $$
BEGIN
  INSERT INTO products (name, price) VALUES (name, price);
  COMMIT;
END;
$$ LANGUAGE plpgsql;

CALL insert_product('Laptop', 1200);
```

### Procedure with Output Parameters

```sql
CREATE PROCEDURE get_user_stats(user_id INT, OUT order_count INT, OUT total_spent DECIMAL) AS $$
BEGIN
  SELECT COUNT(*), SUM(total_amount) INTO order_count, total_spent
  FROM orders WHERE user_id = $1;
END;
$$ LANGUAGE plpgsql;

CALL get_user_stats(1, order_count, total_spent);
```

### Procedure with Transactions

```sql
CREATE PROCEDURE transfer_money(from_user INT, to_user INT, amount DECIMAL) AS $$
BEGIN
  BEGIN
    UPDATE users SET balance = balance - amount WHERE id = from_user;
    UPDATE users SET balance = balance + amount WHERE id = to_user;
    COMMIT;
  EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    RAISE EXCEPTION 'Transfer failed';
  END;
END;
$$ LANGUAGE plpgsql;
```

---

## 🛡️ Error Handling

### RAISE

```sql
CREATE FUNCTION validate_price(price DECIMAL) RETURNS VOID AS $$
BEGIN
  IF price < 0 THEN
    RAISE EXCEPTION 'Price cannot be negative';
  END IF;
END;
$$ LANGUAGE plpgsql;
```

### Exception Handling

```sql
CREATE FUNCTION safe_divide(a INT, b INT) RETURNS DECIMAL AS $$
BEGIN
  RETURN a::DECIMAL / b;
EXCEPTION WHEN division_by_zero THEN
  RAISE EXCEPTION 'Cannot divide by zero';
END;
$$ LANGUAGE plpgsql;
```

---

## 📊 Tóm Tắt Functions & Procedures

| Khái Niệm | Mô Tả | Khi Dùng |
|-----------|-------|---------|
| **Function** | Trả về value | Calculations |
| **Procedure** | Thực thi actions | Data modification |
| **Scalar Function** | Single value | Simple returns |
| **Table Function** | Multiple rows | Complex returns |
| **PL/pgSQL** | Procedural language | Logic |
| **Variables** | Data storage | Temporary data |
| **Control Flow** | IF, LOOP, FOR | Logic |
| **Error Handling** | RAISE, EXCEPTION | Error management |

---

## 🎓 Key Takeaways

1. **Functions** - Trả về values
2. **Procedures** - Thực thi actions
3. **PL/pgSQL** - Procedural language
4. **Variables** - Data storage
5. **Control Flow** - IF, LOOP, FOR
6. **Error Handling** - RAISE, EXCEPTION
7. **Best Practices** - Reusable, maintainable

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL Functions](https://www.postgresql.org/docs/current/sql-createfunction.html)
- [PostgreSQL Procedures](https://www.postgresql.org/docs/current/sql-createprocedure.html)
- [PostgreSQL PL/pgSQL](https://www.postgresql.org/docs/current/plpgsql.html)

---

**Bây giờ bạn đã hiểu Functions & Procedures! Hãy chuyển sang phần thực hành. 💪**

