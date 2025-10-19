# 📚 Triggers & Event Handling - Lý Thuyết

Hiểu cách sử dụng triggers để tự động hóa database events.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu Triggers là gì
- ✅ Biết các loại Triggers
- ✅ Tạo được BEFORE & AFTER triggers
- ✅ Tạo được Row & Statement triggers
- ✅ Sử dụng được trigger functions
- ✅ Hiểu Triggers best practices

---

## 🔔 Triggers

### Định Nghĩa

**Trigger** là database object tự động thực thi khi có event (INSERT, UPDATE, DELETE).

### Tại Sao Quan Trọng?

1. **Automation** - Tự động hóa tasks
2. **Data Integrity** - Đảm bảo data consistency
3. **Audit Logging** - Track changes
4. **Business Logic** - Enforce rules

---

## 📊 Loại Triggers

### BEFORE vs AFTER

**BEFORE Trigger:**
- Thực thi trước event
- Có thể modify data
- Có thể prevent event

**AFTER Trigger:**
- Thực thi sau event
- Không thể modify data
- Có thể log changes

### ROW vs STATEMENT

**ROW Trigger:**
- Thực thi cho mỗi row
- Có thể access OLD & NEW

**STATEMENT Trigger:**
- Thực thi một lần cho statement
- Không có OLD & NEW

---

## 🔧 Tạo Triggers

### Cú Pháp

```sql
CREATE TRIGGER trigger_name
BEFORE/AFTER INSERT/UPDATE/DELETE ON table_name
FOR EACH ROW/STATEMENT
EXECUTE FUNCTION trigger_function();
```

### Ví Dụ 1: BEFORE INSERT

```sql
-- Trigger function
CREATE FUNCTION validate_product_price() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.price < 0 THEN
    RAISE EXCEPTION 'Price cannot be negative';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
CREATE TRIGGER before_insert_product
BEFORE INSERT ON products
FOR EACH ROW
EXECUTE FUNCTION validate_product_price();
```

### Ví Dụ 2: AFTER INSERT

```sql
-- Trigger function
CREATE FUNCTION log_product_insert() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_logs (action, details)
  VALUES ('product_inserted', jsonb_build_object('id', NEW.id, 'name', NEW.name));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
CREATE TRIGGER after_insert_product
AFTER INSERT ON products
FOR EACH ROW
EXECUTE FUNCTION log_product_insert();
```

### Ví Dụ 3: BEFORE UPDATE

```sql
-- Trigger function
CREATE FUNCTION update_product_timestamp() RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at := CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
CREATE TRIGGER before_update_product
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION update_product_timestamp();
```

---

## 📝 Trigger Functions

### OLD & NEW

```sql
CREATE FUNCTION log_product_update() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_logs (action, details)
  VALUES ('product_updated', jsonb_build_object(
    'id', NEW.id,
    'old_price', OLD.price,
    'new_price', NEW.price
  ));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### Conditional Triggers

```sql
CREATE FUNCTION log_price_change() RETURNS TRIGGER AS $$
BEGIN
  IF OLD.price != NEW.price THEN
    INSERT INTO audit_logs (action, details)
    VALUES ('price_changed', jsonb_build_object(
      'product_id', NEW.id,
      'old_price', OLD.price,
      'new_price', NEW.price
    ));
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

---

## 🔄 Trigger Use Cases

### 1. Audit Logging

```sql
CREATE FUNCTION audit_log_trigger() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_logs (table_name, action, old_data, new_data, changed_at)
  VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), row_to_json(NEW), CURRENT_TIMESTAMP);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### 2. Update Timestamps

```sql
CREATE FUNCTION update_timestamp() RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at := CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### 3. Maintain Counters

```sql
CREATE FUNCTION update_product_count() RETURNS TRIGGER AS $$
BEGIN
  UPDATE categories SET product_count = product_count + 1
  WHERE id = NEW.category_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### 4. Enforce Business Rules

```sql
CREATE FUNCTION check_order_total() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.total_amount < 0 THEN
    RAISE EXCEPTION 'Order total cannot be negative';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

---

## 🎯 Trigger Variables

### TG_OP

```sql
IF TG_OP = 'INSERT' THEN
  -- Handle insert
ELSIF TG_OP = 'UPDATE' THEN
  -- Handle update
ELSIF TG_OP = 'DELETE' THEN
  -- Handle delete
END IF;
```

### TG_TABLE_NAME

```sql
INSERT INTO audit_logs (table_name, action)
VALUES (TG_TABLE_NAME, TG_OP);
```

---

## 📊 Tóm Tắt Triggers

| Khái Niệm | Mô Tả | Khi Dùng |
|-----------|-------|---------|
| **BEFORE Trigger** | Trước event | Validation |
| **AFTER Trigger** | Sau event | Logging |
| **ROW Trigger** | Mỗi row | Data changes |
| **STATEMENT Trigger** | Một lần | Aggregations |
| **Trigger Function** | Function logic | Trigger logic |
| **OLD & NEW** | Row data | Comparisons |
| **TG_OP** | Operation type | Conditional |

---

## 🎓 Key Takeaways

1. **Triggers** - Tự động hóa events
2. **BEFORE/AFTER** - Timing
3. **ROW/STATEMENT** - Scope
4. **Trigger Functions** - Logic
5. **OLD & NEW** - Data access
6. **Audit Logging** - Track changes
7. **Best Practices** - Keep simple

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL Triggers](https://www.postgresql.org/docs/current/sql-createtrigger.html)
- [PostgreSQL Trigger Functions](https://www.postgresql.org/docs/current/plpgsql-trigger.html)

---

**Bây giờ bạn đã hiểu Triggers! Hãy chuyển sang phần thực hành. 💪**

