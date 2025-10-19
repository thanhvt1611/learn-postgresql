# 🛠️ Triggers & Event Handling - Thực Hành

Thực hành tạo & sử dụng triggers để tự động hóa database events.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Tạo được BEFORE & AFTER triggers
- ✅ Tạo được ROW & STATEMENT triggers
- ✅ Sử dụng được trigger functions
- ✅ Implement audit logging
- ✅ Enforce business rules

---

## 📋 Bước 1: Chuẩn Bị Database

### Bước 1.1: Kết Nối Database

```sql
-- Kết nối
psql -U postgres -d ecommerce_practice

-- Tạo audit_logs table
CREATE TABLE IF NOT EXISTS audit_logs (
  id SERIAL PRIMARY KEY,
  table_name VARCHAR(100),
  action VARCHAR(50),
  old_data JSONB,
  new_data JSONB,
  changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 🔔 Bước 2: BEFORE Triggers

### Thực Hành 2.1: Validate Price

```sql
-- Trigger function
CREATE OR REPLACE FUNCTION validate_product_price() RETURNS TRIGGER AS $$
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

-- Test trigger
INSERT INTO products (name, price) VALUES ('Test', -100);  -- Will raise exception
```

### Thực Hành 2.2: Update Timestamp

```sql
-- Trigger function
CREATE OR REPLACE FUNCTION update_product_timestamp() RETURNS TRIGGER AS $$
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

-- Test trigger
UPDATE products SET name = 'Updated' WHERE id = 1;
SELECT updated_at FROM products WHERE id = 1;
```

---

## 📝 Bước 3: AFTER Triggers

### Thực Hành 3.1: Audit Logging

```sql
-- Trigger function
CREATE OR REPLACE FUNCTION log_product_insert() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_logs (table_name, action, new_data, changed_at)
  VALUES ('products', 'INSERT', row_to_json(NEW), CURRENT_TIMESTAMP);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
CREATE TRIGGER after_insert_product
AFTER INSERT ON products
FOR EACH ROW
EXECUTE FUNCTION log_product_insert();

-- Test trigger
INSERT INTO products (name, price) VALUES ('New Product', 500);
SELECT * FROM audit_logs WHERE table_name = 'products';
```

### Thực Hành 3.2: Log Updates

```sql
-- Trigger function
CREATE OR REPLACE FUNCTION log_product_update() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_logs (table_name, action, old_data, new_data, changed_at)
  VALUES ('products', 'UPDATE', row_to_json(OLD), row_to_json(NEW), CURRENT_TIMESTAMP);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
CREATE TRIGGER after_update_product
AFTER UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION log_product_update();

-- Test trigger
UPDATE products SET price = 600 WHERE id = 1;
SELECT * FROM audit_logs WHERE action = 'UPDATE';
```

---

## 🔄 Bước 4: Conditional Triggers

### Thực Hành 4.1: Log Price Changes Only

```sql
-- Trigger function
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

-- Create trigger
CREATE TRIGGER on_product_price_change
AFTER UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION log_price_change();

-- Test trigger
UPDATE products SET price = 700 WHERE id = 1;
SELECT * FROM audit_logs WHERE action = 'PRICE_CHANGED';
```

---

## 📊 Bước 5: Maintain Counters

### Thực Hành 5.1: Update Product Count

```sql
-- Add product_count column to categories
ALTER TABLE categories ADD COLUMN IF NOT EXISTS product_count INT DEFAULT 0;

-- Trigger function
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

-- Create triggers
CREATE TRIGGER after_insert_product_count
AFTER INSERT ON products
FOR EACH ROW
EXECUTE FUNCTION update_category_product_count();

CREATE TRIGGER after_delete_product_count
AFTER DELETE ON products
FOR EACH ROW
EXECUTE FUNCTION update_category_product_count();

-- Test triggers
SELECT product_count FROM categories WHERE id = 1;
```

---

## 🎯 Bước 6: Enforce Business Rules

### Thực Hành 6.1: Check Order Total

```sql
-- Trigger function
CREATE OR REPLACE FUNCTION check_order_total() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.total_amount < 0 THEN
    RAISE EXCEPTION 'Order total cannot be negative';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
CREATE TRIGGER before_insert_order
BEFORE INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION check_order_total();

-- Test trigger
INSERT INTO orders (user_id, total_amount) VALUES (1, -100);  -- Will raise exception
```

---

## 🔧 Bước 7: Trigger Management

### Thực Hành 7.1: List Triggers

```sql
-- List all triggers
SELECT trigger_name, event_manipulation, event_object_table
FROM information_schema.triggers
WHERE trigger_schema = 'public';
```

### Thực Hành 7.2: Disable/Enable Triggers

```sql
-- Disable trigger
ALTER TABLE products DISABLE TRIGGER before_insert_product;

-- Enable trigger
ALTER TABLE products ENABLE TRIGGER before_insert_product;

-- Disable all triggers
ALTER TABLE products DISABLE TRIGGER ALL;

-- Enable all triggers
ALTER TABLE products ENABLE TRIGGER ALL;
```

### Thực Hành 7.3: Drop Triggers

```sql
-- Drop trigger
DROP TRIGGER before_insert_product ON products;

-- Drop trigger function
DROP FUNCTION validate_product_price();
```

---

## ✅ Checklist Thực Hành

- [ ] Tạo BEFORE triggers
- [ ] Tạo AFTER triggers
- [ ] Implement audit logging
- [ ] Conditional triggers
- [ ] Maintain counters
- [ ] Enforce business rules
- [ ] Trigger management
- [ ] Test all triggers

---

## 💡 Tips

1. **Keep triggers simple** - Dễ maintain
2. **Use meaningful names** - Rõ ràng
3. **Document triggers** - Giải thích logic
4. **Test thoroughly** - Verify behavior
5. **Monitor performance** - Triggers có overhead

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

