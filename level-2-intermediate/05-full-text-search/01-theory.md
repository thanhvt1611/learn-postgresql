# 📚 Full-Text Search - Lý Thuyết

Hiểu cách sử dụng Full-Text Search để tìm kiếm text hiệu quả.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu Full-Text Search là gì
- ✅ Biết cách tạo tsvector & tsquery
- ✅ Sử dụng được @@ operator
- ✅ Biết cách tạo GIN indexes
- ✅ Sử dụng được text search functions
- ✅ Hiểu Full-Text Search best practices

---

## 🔍 Full-Text Search (FTS)

### Định Nghĩa

**Full-Text Search** là kỹ thuật tìm kiếm text trong documents.

### Tại Sao Quan Trọng?

1. **Performance** - Nhanh hơn LIKE
2. **Relevance** - Ranking results
3. **Flexibility** - Multiple operators
4. **Scalability** - Hỗ trợ large datasets

### Ví Dụ

```sql
-- Simple full-text search
SELECT * FROM products
WHERE to_tsvector(name) @@ to_tsquery('laptop');
```

---

## 📝 tsvector & tsquery

### tsvector

**Định nghĩa:** Tokenized & normalized text.

```sql
-- Tạo tsvector
SELECT to_tsvector('english', 'The quick brown fox');
-- Output: 'brown':3 'fox':4 'quick':2

-- Tsvector từ column
SELECT to_tsvector(name) FROM products;
```

### tsquery

**Định nghĩa:** Search query.

```sql
-- Tạo tsquery
SELECT to_tsquery('english', 'laptop & computer');
-- Output: 'laptop' & 'computer'

-- Tsquery operators
-- & (AND), | (OR), ! (NOT), <-> (FOLLOWED BY)
```

---

## 🔎 @@ Operator

### Định Nghĩa

**@@** kiểm tra tsvector có match tsquery không.

### Cú Pháp

```sql
tsvector @@ tsquery
```

### Ví Dụ

```sql
-- Tìm products có 'laptop'
SELECT * FROM products
WHERE to_tsvector(name) @@ to_tsquery('laptop');

-- Tìm products có 'laptop' hoặc 'computer'
SELECT * FROM products
WHERE to_tsvector(name) @@ to_tsquery('laptop | computer');

-- Tìm products có 'laptop' nhưng không 'broken'
SELECT * FROM products
WHERE to_tsvector(name) @@ to_tsquery('laptop & !broken');
```

---

## 🏗️ Tạo FTS Columns

### Ví Dụ 1: Add tsvector Column

```sql
-- Thêm tsvector column
ALTER TABLE products ADD COLUMN search_vector tsvector;

-- Update tsvector
UPDATE products SET search_vector = to_tsvector('english', name || ' ' || COALESCE(description, ''));
```

### Ví Dụ 2: Trigger để Auto-Update

```sql
-- Tạo trigger function
CREATE FUNCTION products_search_update() RETURNS trigger AS $$
BEGIN
  NEW.search_vector := to_tsvector('english', NEW.name || ' ' || COALESCE(NEW.description, ''));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Tạo trigger
CREATE TRIGGER products_search_trigger
BEFORE INSERT OR UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION products_search_update();
```

---

## 🔑 GIN Indexes

### Định Nghĩa

**GIN Index** (Generalized Inverted Index) tối ưu cho full-text search.

### Tạo Index

```sql
-- Tạo GIN index
CREATE INDEX idx_products_search ON products USING GIN (search_vector);
```

### Ưu Điểm

1. **Fast searches** - Nhanh hơn sequential scan
2. **Large datasets** - Scalable
3. **Multiple terms** - Hỗ trợ complex queries

---

## 🔧 Text Search Functions

### ts_rank()

```sql
-- Ranking results
SELECT 
  name,
  ts_rank(search_vector, query) AS rank
FROM products,
to_tsquery('laptop') query
WHERE search_vector @@ query
ORDER BY rank DESC;
```

### ts_headline()

```sql
-- Highlight matches
SELECT 
  name,
  ts_headline('english', name, query)
FROM products,
to_tsquery('laptop') query
WHERE search_vector @@ query;
```

### plainto_tsquery()

```sql
-- Convert plain text to tsquery
SELECT plainto_tsquery('english', 'laptop computer');
-- Output: 'laptop' & 'computer'
```

### websearch_to_tsquery()

```sql
-- Convert web search syntax to tsquery
SELECT websearch_to_tsquery('english', 'laptop -broken');
-- Output: 'laptop' & !'broken'
```

---

## 📊 Tóm Tắt Full-Text Search

| Khái Niệm | Mô Tả | Khi Dùng |
|-----------|-------|---------|
| **tsvector** | Tokenized text | Store |
| **tsquery** | Search query | Query |
| **@@** | Match operator | Filter |
| **GIN Index** | Inverted index | Performance |
| **ts_rank()** | Ranking | Sort |
| **ts_headline()** | Highlight | Display |
| **plainto_tsquery()** | Plain text to query | Convert |

---

## 🎓 Key Takeaways

1. **Full-Text Search** - Tìm kiếm text hiệu quả
2. **tsvector** - Tokenized text
3. **tsquery** - Search query
4. **@@** - Match operator
5. **GIN Indexes** - Performance
6. **ts_rank()** - Ranking
7. **ts_headline()** - Highlight

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL Full-Text Search](https://www.postgresql.org/docs/current/textsearch.html)
- [PostgreSQL Text Search Functions](https://www.postgresql.org/docs/current/functions-textsearch.html)

---

**Bây giờ bạn đã hiểu Full-Text Search! Hãy chuyển sang phần thực hành. 💪**

