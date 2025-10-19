# 📚 JSON & JSONB - Lý Thuyết

Hiểu cách lưu trữ & truy vấn JSON data trong PostgreSQL.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu JSON vs JSONB
- ✅ Biết cách lưu trữ JSON data
- ✅ Biết cách truy vấn JSON data
- ✅ Sử dụng được JSON operators
- ✅ Sử dụng được JSON functions
- ✅ Hiểu JSON best practices

---

## 📋 JSON vs JSONB

### JSON

**Định nghĩa:** Text-based JSON format.

**Ưu điểm:**
- Giữ nguyên thứ tự keys
- Giữ nguyên whitespace

**Nhược điểm:**
- Chậm hơn JSONB
- Không có index support

### JSONB

**Định nghĩa:** Binary JSON format.

**Ưu điểm:**
- Nhanh hơn JSON
- Hỗ trợ indexes
- Loại bỏ duplicates

**Nhược điểm:**
- Mất thứ tự keys
- Mất whitespace

### Khi Dùng

```
JSON: Khi cần giữ nguyên format
JSONB: Khi cần performance & queries
```

---

## 💾 Lưu Trữ JSON Data

### Ví Dụ 1: Simple JSON

```sql
-- Lưu trữ JSON object
INSERT INTO products (name, metadata)
VALUES ('Laptop', '{"brand": "Dell", "color": "black"}');

-- Lưu trữ JSON array
INSERT INTO products (name, tags)
VALUES ('Mouse', '["wireless", "ergonomic"]');
```

### Ví Dụ 2: Nested JSON

```sql
-- Lưu trữ nested JSON
INSERT INTO orders (user_id, details)
VALUES (1, '{
  "items": [
    {"product_id": 1, "quantity": 2},
    {"product_id": 2, "quantity": 1}
  ],
  "shipping": {
    "address": "123 Main St",
    "city": "New York"
  }
}');
```

---

## 🔍 JSON Operators

### -> (Get JSON Object Field)

```sql
-- Lấy value từ JSON object
SELECT metadata->'brand' FROM products;
-- Output: "Dell"
```

### ->> (Get JSON Object Field as Text)

```sql
-- Lấy value từ JSON object as text
SELECT metadata->>'brand' FROM products;
-- Output: Dell (không có quotes)
```

### -> (Get JSON Array Element)

```sql
-- Lấy element từ JSON array
SELECT tags->0 FROM products;
-- Output: "wireless"
```

### #> (Get JSON by Path)

```sql
-- Lấy value bằng path
SELECT details#>'{items,0,product_id}' FROM orders;
```

### @> (Contains)

```sql
-- Kiểm tra JSON contains
SELECT * FROM products WHERE metadata @> '{"brand": "Dell"}';
```

### <@ (Contained By)

```sql
-- Kiểm tra JSON contained by
SELECT * FROM products WHERE '{"brand": "Dell"}' <@ metadata;
```

---

## 🔧 JSON Functions

### json_extract_path()

```sql
-- Lấy value bằng path
SELECT json_extract_path(metadata, 'brand') FROM products;
```

### json_object_keys()

```sql
-- Lấy tất cả keys
SELECT json_object_keys(metadata) FROM products;
```

### json_array_length()

```sql
-- Lấy độ dài array
SELECT json_array_length(tags) FROM products;
```

### jsonb_each()

```sql
-- Lặp qua mỗi key-value pair
SELECT key, value FROM jsonb_each(metadata) FROM products;
```

### jsonb_array_elements()

```sql
-- Lặp qua mỗi element trong array
SELECT jsonb_array_elements(tags) FROM products;
```

### to_jsonb()

```sql
-- Convert row to JSONB
SELECT to_jsonb(row(name, price)) FROM products;
```

### jsonb_build_object()

```sql
-- Tạo JSONB object
SELECT jsonb_build_object('name', name, 'price', price) FROM products;
```

### jsonb_build_array()

```sql
-- Tạo JSONB array
SELECT jsonb_build_array(name, price) FROM products;
```

---

## 🔍 Querying JSON Data

### Ví Dụ 1: Extract Values

```sql
-- Lấy brand từ metadata
SELECT 
  name,
  metadata->>'brand' AS brand,
  metadata->>'color' AS color
FROM products;
```

### Ví Dụ 2: Filter by JSON

```sql
-- Tìm products có brand = 'Dell'
SELECT * FROM products
WHERE metadata->>'brand' = 'Dell';
```

### Ví Dụ 3: JSON Contains

```sql
-- Tìm products có tag 'wireless'
SELECT * FROM products
WHERE tags @> '"wireless"';
```

### Ví Dụ 4: Unnest JSON Array

```sql
-- Unnest tags array
SELECT 
  name,
  jsonb_array_elements(tags) AS tag
FROM products;
```

---

## 📊 Tóm Tắt JSON & JSONB

| Khái Niệm | Mô Tả | Khi Dùng |
|-----------|-------|---------|
| **JSON** | Text-based JSON | Giữ format |
| **JSONB** | Binary JSON | Performance |
| **->** | Get JSON field | Extract value |
| **->>** | Get JSON field as text | Extract text |
| **@>** | Contains | Filter |
| **<@** | Contained by | Filter |
| **jsonb_each()** | Iterate key-value | Loop |
| **jsonb_array_elements()** | Iterate array | Loop |

---

## 🎓 Key Takeaways

1. **JSON vs JSONB** - JSONB cho performance
2. **Operators** - ->, ->>, @>, <@
3. **Functions** - json_extract_path, jsonb_each, etc.
4. **Querying** - Extract, filter, unnest
5. **Indexing** - GIN indexes cho JSONB
6. **Best Practices** - Sử dụng JSONB, tạo indexes

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL JSON Types](https://www.postgresql.org/docs/current/datatype-json.html)
- [PostgreSQL JSON Functions](https://www.postgresql.org/docs/current/functions-json.html)

---

**Bây giờ bạn đã hiểu JSON & JSONB! Hãy chuyển sang phần thực hành. 💪**

