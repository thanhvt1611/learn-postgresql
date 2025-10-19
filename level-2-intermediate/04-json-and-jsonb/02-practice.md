# 🛠️ JSON & JSONB - Thực Hành

Thực hành lưu trữ & truy vấn JSON data.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Lưu trữ được JSON data
- ✅ Truy vấn được JSON data
- ✅ Sử dụng được JSON operators
- ✅ Sử dụng được JSON functions
- ✅ Tạo được indexes cho JSON

---

## 📋 Bước 1: Chuẩn Bị Database

### Bước 1.1: Tạo Table với JSON Columns

```sql
-- Kết nối
psql -U postgres -d ecommerce_practice

-- Tạo table với JSON columns
CREATE TABLE IF NOT EXISTS products_json (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  metadata JSONB,
  tags JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tạo table với nested JSON
CREATE TABLE IF NOT EXISTS orders_json (
  id SERIAL PRIMARY KEY,
  user_id INT,
  details JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 💾 Bước 2: Lưu Trữ JSON Data

### Thực Hành 2.1: Insert Simple JSON

```sql
-- Lưu trữ JSON object
INSERT INTO products_json (name, metadata, tags)
VALUES 
  ('Laptop', '{"brand": "Dell", "color": "black", "warranty": 2}', '["electronics", "computers"]'),
  ('Mouse', '{"brand": "Logitech", "color": "white", "warranty": 1}', '["electronics", "accessories"]'),
  ('Keyboard', '{"brand": "Corsair", "color": "black", "warranty": 3}', '["electronics", "accessories"]');
```

### Thực Hành 2.2: Insert Nested JSON

```sql
-- Lưu trữ nested JSON
INSERT INTO orders_json (user_id, details)
VALUES 
  (1, '{
    "items": [
      {"product_id": 1, "quantity": 2, "price": 1200},
      {"product_id": 2, "quantity": 1, "price": 50}
    ],
    "shipping": {
      "address": "123 Main St",
      "city": "New York",
      "zip": "10001"
    },
    "total": 2450
  }'),
  (2, '{
    "items": [
      {"product_id": 3, "quantity": 1, "price": 150}
    ],
    "shipping": {
      "address": "456 Oak Ave",
      "city": "Los Angeles",
      "zip": "90001"
    },
    "total": 150
  }');
```

---

## 🔍 Bước 3: Truy Vấn JSON Data

### Thực Hành 3.1: Extract Values with ->

```sql
-- Lấy brand từ metadata
SELECT 
  name,
  metadata->'brand' AS brand,
  metadata->'color' AS color
FROM products_json;
```

### Thực Hành 3.2: Extract Values with ->>

```sql
-- Lấy brand as text
SELECT 
  name,
  metadata->>'brand' AS brand,
  metadata->>'color' AS color,
  metadata->>'warranty' AS warranty
FROM products_json;
```

### Thực Hành 3.3: Extract Nested Values

```sql
-- Lấy nested values
SELECT 
  id,
  details->>'total' AS total,
  details->'shipping'->>'city' AS city,
  details->'shipping'->>'address' AS address
FROM orders_json;
```

---

## 🔧 Bước 4: JSON Operators

### Thực Hành 4.1: Contains (@>)

```sql
-- Tìm products có brand = 'Dell'
SELECT * FROM products_json
WHERE metadata @> '{"brand": "Dell"}';
```

### Thực Hành 4.2: Contains Array

```sql
-- Tìm products có tag 'electronics'
SELECT * FROM products_json
WHERE tags @> '"electronics"';
```

### Thực Hành 4.3: Contained By (<@)

```sql
-- Kiểm tra JSON contained by
SELECT * FROM products_json
WHERE '{"brand": "Dell"}' <@ metadata;
```

---

## 🔄 Bước 5: JSON Functions

### Thực Hành 5.1: jsonb_each()

```sql
-- Lặp qua mỗi key-value pair
SELECT 
  name,
  key,
  value
FROM products_json,
jsonb_each(metadata)
ORDER BY name;
```

### Thực Hành 5.2: jsonb_array_elements()

```sql
-- Lặp qua mỗi element trong array
SELECT 
  name,
  jsonb_array_elements(tags) AS tag
FROM products_json
ORDER BY name;
```

### Thực Hành 5.3: json_array_length()

```sql
-- Lấy độ dài array
SELECT 
  name,
  json_array_length(tags) AS tag_count
FROM products_json;
```

### Thực Hành 5.4: jsonb_build_object()

```sql
-- Tạo JSONB object
SELECT 
  name,
  jsonb_build_object('name', name, 'brand', metadata->>'brand') AS product_info
FROM products_json;
```

---

## 📊 Bước 6: Complex JSON Queries

### Thực Hành 6.1: Unnest Items

```sql
-- Unnest order items
SELECT 
  o.id AS order_id,
  o.user_id,
  jsonb_array_elements(o.details->'items') AS item
FROM orders_json o;
```

### Thực Hành 6.2: Extract Item Details

```sql
-- Extract item details
SELECT 
  o.id AS order_id,
  item->>'product_id' AS product_id,
  item->>'quantity' AS quantity,
  item->>'price' AS price
FROM orders_json o,
jsonb_array_elements(o.details->'items') AS item;
```

### Thực Hành 6.3: Aggregate JSON Data

```sql
-- Tính total items per order
SELECT 
  id,
  user_id,
  details->>'total' AS total,
  jsonb_array_length(details->'items') AS item_count
FROM orders_json;
```

---

## 🔑 Bước 7: JSON Indexes

### Thực Hành 7.1: Create GIN Index

```sql
-- Tạo GIN index cho JSONB
CREATE INDEX idx_products_metadata ON products_json USING GIN (metadata);
CREATE INDEX idx_products_tags ON products_json USING GIN (tags);
CREATE INDEX idx_orders_details ON orders_json USING GIN (details);
```

### Thực Hành 7.2: Verify Indexes

```sql
-- Kiểm tra indexes
\d products_json
\d orders_json
```

---

## ✅ Checklist Thực Hành

- [ ] Tạo tables với JSON columns
- [ ] Insert JSON data
- [ ] Extract values với -> & ->>
- [ ] Sử dụng JSON operators
- [ ] Sử dụng JSON functions
- [ ] Complex JSON queries
- [ ] Tạo JSON indexes

---

## 💡 Tips

1. **Sử dụng JSONB** - Cho performance
2. **Tạo indexes** - Cho queries nhanh
3. **Validate JSON** - Trước khi insert
4. **Unnest arrays** - Để truy vấn elements
5. **Use operators** - @>, <@, ->, ->>

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

