# 💪 Triggers & Event Handling - Bài Tập

Thực hành tạo & sử dụng triggers để tự động hóa database events.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có database "ecommerce_practice" với sample data

---

## 🎯 Bài Tập 1: Simple BEFORE Trigger (Dễ)

### Yêu Cầu
Tạo BEFORE INSERT trigger để validate product price.

### Gợi Ý
- Sử dụng CREATE FUNCTION
- Sử dụng CREATE TRIGGER
- Kiểm tra price < 0

### Solution
```sql
CREATE OR REPLACE FUNCTION validate_product_price() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.price < 0 THEN
    RAISE EXCEPTION 'Price cannot be negative';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_product
BEFORE INSERT ON products
FOR EACH ROW
EXECUTE FUNCTION validate_product_price();
```

---

## 🎯 Bài Tập 2: Update Timestamp (Dễ)

### Yêu Cầu
Tạo BEFORE UPDATE trigger để auto-update timestamp.

### Gợi Ý
- Sử dụng CREATE FUNCTION
- Sử dụng CURRENT_TIMESTAMP
- Sử dụng CREATE TRIGGER

### Solution
```sql
CREATE OR REPLACE FUNCTION update_product_timestamp() RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at := CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_update_product
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION update_product_timestamp();
```

---

## 🎯 Bài Tập 3: Simple AFTER Trigger (Dễ)

### Yêu Cầu
Tạo AFTER INSERT trigger để log product inserts.

### Gợi Ý
- Sử dụng CREATE FUNCTION
- Sử dụng INSERT INTO audit_logs
- Sử dụng row_to_json()

### Solution
```sql
CREATE OR REPLACE FUNCTION log_product_insert() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_logs (table_name, action, new_data)
  VALUES ('products', 'INSERT', row_to_json(NEW));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_insert_product
AFTER INSERT ON products
FOR EACH ROW
EXECUTE FUNCTION log_product_insert();
```

---

## 🎯 Bài Tập 4: Log Updates (Trung Bình)

### Yêu Cầu
Tạo AFTER UPDATE trigger để log product updates.

### Gợi Ý
- Sử dụng CREATE FUNCTION
- Sử dụng OLD & NEW
- Sử dụng row_to_json()

### Solution
```sql
CREATE OR REPLACE FUNCTION log_product_update() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_logs (table_name, action, old_data, new_data)
  VALUES ('products', 'UPDATE', row_to_json(OLD), row_to_json(NEW));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_update_product
AFTER UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION log_product_update();
```

---

## 🎯 Bài Tập 5: Conditional Trigger (Trung Bình)

### Yêu Cầu
Tạo trigger để log chỉ khi price thay đổi.

### Gợi Ý
- Sử dụng IF OLD.price != NEW.price
- Sử dụng jsonb_build_object()
- Sử dụng CREATE TRIGGER

### Solution
```sql
CREATE OR REPLACE FUNCTION log_price_change() RETURNS TRIGGER AS $$
BEGIN
  IF OLD.price != NEW.price THEN
    INSERT INTO audit_logs (table_name, action, old_data, new_data)
    VALUES ('products', 'PRICE_CHANGED',
      jsonb_build_object('id', OLD.id, 'price', OLD.price),
      jsonb_build_object('id', NEW.id, 'price', NEW.price));
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_product_price_change
AFTER UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION log_price_change();
```

---

## 🎯 Bài Tập 6: Maintain Counter (Trung Bình)

### Yêu Cầu
Tạo trigger để maintain product count per category.

### Gợi Ý
- Sử dụng TG_OP
- Sử dụng UPDATE categories
- Sử dụng CREATE TRIGGER

### Solution
```sql
CREATE OR REPLACE FUNCTION update_category_product_count() RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE categories SET product_count = product_count + 1
    WHERE id = NEW.category_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE categories SET product_count = product_count - 1
    WHERE id = OLD.category_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_insert_product_count
AFTER INSERT ON products
FOR EACH ROW
EXECUTE FUNCTION update_category_product_count();
```

---

## 🎯 Bài Tập 7: Enforce Business Rule (Trung Bình)

### Yêu Cầu
Tạo trigger để validate order total.

### Gợi Ý
- Sử dụng IF NEW.total_amount < 0
- Sử dụng RAISE EXCEPTION
- Sử dụng CREATE TRIGGER

### Solution
```sql
CREATE OR REPLACE FUNCTION check_order_total() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.total_amount < 0 THEN
    RAISE EXCEPTION 'Order total cannot be negative';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_order
BEFORE INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION check_order_total();
```

---

## 🎯 Bài Tập 8: Multiple Conditions (Nâng Cao)

### Yêu Cầu
Tạo trigger để log changes với multiple conditions.

### Gợi Ý
- Sử dụng IF ELSIF
- Sử dụng TG_OP
- Sử dụng jsonb_build_object()

### Solution
```sql
CREATE OR REPLACE FUNCTION log_product_changes() RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO audit_logs (table_name, action, new_data)
    VALUES ('products', 'INSERT', row_to_json(NEW));
  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO audit_logs (table_name, action, old_data, new_data)
    VALUES ('products', 'UPDATE', row_to_json(OLD), row_to_json(NEW));
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO audit_logs (table_name, action, old_data)
    VALUES ('products', 'DELETE', row_to_json(OLD));
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

---

## 🎯 Bài Tập 9: Trigger with Calculations (Nâng Cao)

### Yêu Cầu
Tạo trigger để auto-calculate order item total.

### Gợi Ý
- Sử dụng NEW.quantity * NEW.unit_price
- Sử dụng BEFORE INSERT
- Sử dụng CREATE TRIGGER

### Solution
```sql
CREATE OR REPLACE FUNCTION calculate_order_item_total() RETURNS TRIGGER AS $$
BEGIN
  NEW.total_price := NEW.quantity * NEW.unit_price;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_order_item
BEFORE INSERT ON order_items
FOR EACH ROW
EXECUTE FUNCTION calculate_order_item_total();
```

---

## 🎯 Bài Tập 10: Cascade Updates (Nâng Cao)

### Yêu Cầu
Tạo trigger để update order total khi order items berubah.

### Gợi Ý
- Sử dụng UPDATE orders
- Sử dụng SUM(quantity * unit_price)
- Sử dụng AFTER INSERT/UPDATE/DELETE

### Solution
```sql
CREATE OR REPLACE FUNCTION update_order_total() RETURNS TRIGGER AS $$
BEGIN
  UPDATE orders SET total_amount = (
    SELECT COALESCE(SUM(quantity * unit_price), 0)
    FROM order_items
    WHERE order_id = COALESCE(NEW.order_id, OLD.order_id)
  )
  WHERE id = COALESCE(NEW.order_id, OLD.order_id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_order_item_change
AFTER INSERT OR UPDATE OR DELETE ON order_items
FOR EACH ROW
EXECUTE FUNCTION update_order_total();
```

---

## 🎯 Bài Tập 11: Audit Trail (Nâng Cao)

### Yêu Cầu
Tạo comprehensive audit trigger cho users table.

### Gợi Ý
- Sử dụng TG_TABLE_NAME
- Sử dụng TG_OP
- Sử dụng row_to_json()

### Solution
```sql
CREATE OR REPLACE FUNCTION audit_log_trigger() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_logs (table_name, action, old_data, new_data, changed_at)
  VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), row_to_json(NEW), CURRENT_TIMESTAMP);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER audit_users
AFTER INSERT OR UPDATE OR DELETE ON users
FOR EACH ROW
EXECUTE FUNCTION audit_log_trigger();
```

---

## 🎯 Bài Tập 12: Complex Business Logic (Nâng Cao)

### Yêu Cầu
Tạo trigger để validate & log order creation.

### Gợi Ý
- Sử dụng multiple conditions
- Sử dụng RAISE EXCEPTION
- Sử dụng INSERT INTO audit_logs

### Solution
```sql
CREATE OR REPLACE FUNCTION validate_and_log_order() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.total_amount <= 0 THEN
    RAISE EXCEPTION 'Order total must be positive';
  END IF;
  
  IF NEW.user_id IS NULL THEN
    RAISE EXCEPTION 'User ID is required';
  END IF;
  
  INSERT INTO audit_logs (table_name, action, new_data)
  VALUES ('orders', 'INSERT', row_to_json(NEW));
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_order_validate
BEFORE INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION validate_and_log_order();
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-3: Simple Triggers
- [ ] Bài 4-6: Conditional & Counter Triggers
- [ ] Bài 7-9: Business Rules & Calculations
- [ ] Bài 10-12: Advanced Triggers

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ BEFORE & AFTER triggers
- ✅ Audit logging
- ✅ Conditional triggers
- ✅ Counter maintenance
- ✅ Business rule enforcement
- ✅ Cascade updates
- ✅ Complex logic

---

**Chúc mừng! Bạn đã hoàn thành Module 3 - Triggers & Event Handling! 🎉**

