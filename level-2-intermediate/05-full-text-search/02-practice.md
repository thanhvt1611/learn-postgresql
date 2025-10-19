# 🛠️ Full-Text Search - Thực Hành

Thực hành sử dụng Full-Text Search để tìm kiếm text.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Tạo được tsvector & tsquery
- ✅ Sử dụng được @@ operator
- ✅ Tạo được GIN indexes
- ✅ Sử dụng được text search functions
- ✅ Tối ưu hóa full-text search

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

## 📝 Bước 2: Tạo tsvector & tsquery

### Thực Hành 2.1: Create tsvector

```sql
-- Tạo tsvector từ product name
SELECT 
  id,
  name,
  to_tsvector('english', name) AS search_vector
FROM products
LIMIT 5;
```

### Thực Hành 2.2: Create tsquery

```sql
-- Tạo tsquery
SELECT to_tsquery('english', 'laptop');
SELECT to_tsquery('english', 'laptop & computer');
SELECT to_tsquery('english', 'laptop | mouse');
SELECT to_tsquery('english', 'laptop & !broken');
```

### Thực Hành 2.3: Match with @@

```sql
-- Tìm products có 'laptop'
SELECT 
  id,
  name
FROM products
WHERE to_tsvector('english', name) @@ to_tsquery('laptop');
```

---

## 🏗️ Bước 3: Tạo FTS Columns

### Thực Hành 3.1: Add tsvector Column

```sql
-- Thêm tsvector column
ALTER TABLE products ADD COLUMN IF NOT EXISTS search_vector tsvector;

-- Update tsvector
UPDATE products 
SET search_vector = to_tsvector('english', name || ' ' || COALESCE(description, ''));
```

### Thực Hành 3.2: Verify tsvector

```sql
-- Kiểm tra tsvector
SELECT 
  id,
  name,
  search_vector
FROM products
LIMIT 5;
```

---

## 🔑 Bước 4: Tạo GIN Indexes

### Thực Hành 4.1: Create GIN Index

```sql
-- Tạo GIN index
CREATE INDEX IF NOT EXISTS idx_products_search ON products USING GIN (search_vector);
```

### Thực Hành 4.2: Verify Index

```sql
-- Kiểm tra indexes
\d products
```

---

## 🔎 Bước 5: Full-Text Search Queries

### Thực Hành 5.1: Simple Search

```sql
-- Tìm products có 'laptop'
SELECT 
  id,
  name
FROM products
WHERE search_vector @@ to_tsquery('laptop');
```

### Thực Hành 5.2: OR Search

```sql
-- Tìm products có 'laptop' hoặc 'computer'
SELECT 
  id,
  name
FROM products
WHERE search_vector @@ to_tsquery('laptop | computer');
```

### Thực Hành 5.3: AND Search

```sql
-- Tìm products có 'laptop' và 'computer'
SELECT 
  id,
  name
FROM products
WHERE search_vector @@ to_tsquery('laptop & computer');
```

### Thực Hành 5.4: NOT Search

```sql
-- Tìm products có 'laptop' nhưng không 'broken'
SELECT 
  id,
  name
FROM products
WHERE search_vector @@ to_tsquery('laptop & !broken');
```

---

## 🔧 Bước 6: Text Search Functions

### Thực Hành 6.1: ts_rank()

```sql
-- Ranking results
SELECT 
  id,
  name,
  ts_rank(search_vector, query) AS rank
FROM products,
to_tsquery('laptop') query
WHERE search_vector @@ query
ORDER BY rank DESC;
```

### Thực Hành 6.2: ts_headline()

```sql
-- Highlight matches
SELECT 
  id,
  name,
  ts_headline('english', name, query) AS headline
FROM products,
to_tsquery('laptop') query
WHERE search_vector @@ query;
```

### Thực Hành 6.3: plainto_tsquery()

```sql
-- Convert plain text to tsquery
SELECT 
  id,
  name
FROM products
WHERE search_vector @@ plainto_tsquery('english', 'laptop computer');
```

### Thực Hành 6.4: websearch_to_tsquery()

```sql
-- Convert web search syntax to tsquery
SELECT 
  id,
  name
FROM products
WHERE search_vector @@ websearch_to_tsquery('english', 'laptop -broken');
```

---

## 🔄 Bước 7: Trigger để Auto-Update

### Thực Hành 7.1: Create Trigger Function

```sql
-- Tạo trigger function
CREATE OR REPLACE FUNCTION products_search_update() RETURNS trigger AS $$
BEGIN
  NEW.search_vector := to_tsvector('english', NEW.name || ' ' || COALESCE(NEW.description, ''));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### Thực Hành 7.2: Create Trigger

```sql
-- Tạo trigger
DROP TRIGGER IF EXISTS products_search_trigger ON products;
CREATE TRIGGER products_search_trigger
BEFORE INSERT OR UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION products_search_update();
```

### Thực Hành 7.3: Test Trigger

```sql
-- Insert new product
INSERT INTO products (name, description, category_id, price, stock, sku)
VALUES ('New Laptop', 'High performance laptop', 1, 1500, 10, 'LAPTOP-001');

-- Verify search_vector
SELECT id, name, search_vector FROM products WHERE name = 'New Laptop';
```

---

## ✅ Checklist Thực Hành

- [ ] Tạo tsvector & tsquery
- [ ] Sử dụng @@ operator
- [ ] Thêm tsvector column
- [ ] Tạo GIN index
- [ ] Simple search queries
- [ ] Complex search queries
- [ ] Text search functions
- [ ] Tạo triggers

---

## 💡 Tips

1. **Sử dụng GIN indexes** - Cho performance
2. **Tạo triggers** - Để auto-update tsvector
3. **Sử dụng plainto_tsquery()** - Cho user input
4. **Ranking results** - Với ts_rank()
5. **Highlight matches** - Với ts_headline()

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

