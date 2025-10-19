# 💪 JSON & JSONB - Bài Tập

Thực hành lưu trữ & truy vấn JSON data.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có tables với JSON columns

---

## 🎯 Bài Tập 1: Insert Simple JSON (Dễ)

### Yêu Cầu
Thêm 3 products với metadata & tags JSON.

### Gợi Ý
- Sử dụng INSERT
- Sử dụng JSON objects & arrays

### Solution
```sql
INSERT INTO products_json (name, metadata, tags)
VALUES 
  ('Laptop', '{"brand": "Dell", "color": "black", "warranty": 2}', '["electronics", "computers"]'),
  ('Mouse', '{"brand": "Logitech", "color": "white", "warranty": 1}', '["electronics", "accessories"]'),
  ('Keyboard', '{"brand": "Corsair", "color": "black", "warranty": 3}', '["electronics", "accessories"]');
```

---

## 🎯 Bài Tập 2: Extract Values with -> (Dễ)

### Yêu Cầu
Lấy brand & color từ metadata (as JSON).

### Gợi Ý
- Sử dụng -> operator
- Sử dụng SELECT

### Solution
```sql
SELECT 
  name,
  metadata->'brand' AS brand,
  metadata->'color' AS color
FROM products_json;
```

---

## 🎯 Bài Tập 3: Extract Values with ->> (Dễ)

### Yêu Cầu
Lấy brand, color & warranty từ metadata (as text).

### Gợi Ý
- Sử dụng ->> operator
- Sử dụng SELECT

### Solution
```sql
SELECT 
  name,
  metadata->>'brand' AS brand,
  metadata->>'color' AS color,
  metadata->>'warranty' AS warranty
FROM products_json;
```

---

## 🎯 Bài Tập 4: Filter by JSON (@>) (Trung Bình)

### Yêu Cầu
Tìm products có brand = 'Dell'.

### Gợi Ý
- Sử dụng @> operator
- Sử dụng WHERE clause

### Solution
```sql
SELECT * FROM products_json
WHERE metadata @> '{"brand": "Dell"}';
```

---

## 🎯 Bài Tập 5: Filter by JSON Array (Trung Bình)

### Yêu Cầu
Tìm products có tag 'electronics'.

### Gợi Ý
- Sử dụng @> operator
- Sử dụng JSON string

### Solution
```sql
SELECT * FROM products_json
WHERE tags @> '"electronics"';
```

---

## 🎯 Bài Tập 6: jsonb_each() (Trung Bình)

### Yêu Cầu
Lặp qua mỗi key-value pair trong metadata.

### Gợi Ý
- Sử dụng jsonb_each()
- Sử dụng FROM clause

### Solution
```sql
SELECT 
  name,
  key,
  value
FROM products_json,
jsonb_each(metadata)
ORDER BY name;
```

---

## 🎯 Bài Tập 7: jsonb_array_elements() (Trung Bình)

### Yêu Cầu
Lặp qua mỗi tag trong tags array.

### Gợi Ý
- Sử dụng jsonb_array_elements()
- Sử dụng FROM clause

### Solution
```sql
SELECT 
  name,
  jsonb_array_elements(tags) AS tag
FROM products_json
ORDER BY name;
```

---

## 🎯 Bài Tập 8: json_array_length() (Trung Bình)

### Yêu Cầu
Tính số lượng tags cho mỗi product.

### Gợi Ý
- Sử dụng json_array_length()
- Sử dụng SELECT

### Solution
```sql
SELECT 
  name,
  json_array_length(tags) AS tag_count
FROM products_json;
```

---

## 🎯 Bài Tập 9: Extract Nested JSON (Nâng Cao)

### Yêu Cầu
Lấy total & city từ orders_json.

### Gợi Ý
- Sử dụng ->> operator
- Sử dụng nested path

### Solution
```sql
SELECT 
  id,
  user_id,
  details->>'total' AS total,
  details->'shipping'->>'city' AS city
FROM orders_json;
```

---

## 🎯 Bài Tập 10: Unnest Order Items (Nâng Cao)

### Yêu Cầu
Unnest order items & extract product_id, quantity, price.

### Gợi Ý
- Sử dụng jsonb_array_elements()
- Sử dụng ->> operator

### Solution
```sql
SELECT 
  o.id AS order_id,
  o.user_id,
  item->>'product_id' AS product_id,
  item->>'quantity' AS quantity,
  item->>'price' AS price
FROM orders_json o,
jsonb_array_elements(o.details->'items') AS item;
```

---

## 🎯 Bài Tập 11: jsonb_build_object() (Nâng Cao)

### Yêu Cầu
Tạo JSONB object với name & brand.

### Gợi Ý
- Sử dụng jsonb_build_object()
- Sử dụng SELECT

### Solution
```sql
SELECT 
  name,
  jsonb_build_object('name', name, 'brand', metadata->>'brand') AS product_info
FROM products_json;
```

---

## 🎯 Bài Tập 12: Complex JSON Query (Nâng Cao)

### Yêu Cầu
Tính total items & total amount per order.

### Gợi Ý
- Sử dụng jsonb_array_length()
- Sử dụng ->> operator
- Sử dụng SELECT

### Solution
```sql
SELECT 
  id,
  user_id,
  details->>'total' AS total_amount,
  jsonb_array_length(details->'items') AS item_count
FROM orders_json;
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-3: Insert & Extract JSON
- [ ] Bài 4-5: Filter by JSON
- [ ] Bài 6-8: JSON Functions
- [ ] Bài 9-12: Complex JSON Queries

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ Insert JSON data
- ✅ Extract values với -> & ->>
- ✅ Filter với @> & <@
- ✅ jsonb_each() & jsonb_array_elements()
- ✅ json_array_length()
- ✅ jsonb_build_object()
- ✅ Complex JSON queries

---

**Chúc mừng! Bạn đã hoàn thành Module 4 - JSON & JSONB! 🎉**

