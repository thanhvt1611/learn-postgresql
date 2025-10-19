# 💪 Full-Text Search - Bài Tập

Thực hành sử dụng Full-Text Search để tìm kiếm text.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có tsvector column trong products table

---

## 🎯 Bài Tập 1: Create tsvector (Dễ)

### Yêu Cầu
Tạo tsvector từ product name.

### Gợi Ý
- Sử dụng to_tsvector()
- Sử dụng 'english' language

### Solution
```sql
SELECT 
  id,
  name,
  to_tsvector('english', name) AS search_vector
FROM products
LIMIT 5;
```

---

## 🎯 Bài Tập 2: Create tsquery (Dễ)

### Yêu Cầu
Tạo tsquery cho các search terms.

### Gợi Ý
- Sử dụng to_tsquery()
- Sử dụng 'english' language

### Solution
```sql
SELECT to_tsquery('english', 'laptop');
SELECT to_tsquery('english', 'laptop & computer');
SELECT to_tsquery('english', 'laptop | mouse');
```

---

## 🎯 Bài Tập 3: Simple Search (Dễ)

### Yêu Cầu
Tìm products có 'laptop'.

### Gợi Ý
- Sử dụng @@ operator
- Sử dụng to_tsvector() & to_tsquery()

### Solution
```sql
SELECT 
  id,
  name
FROM products
WHERE to_tsvector('english', name) @@ to_tsquery('laptop');
```

---

## 🎯 Bài Tập 4: OR Search (Trung Bình)

### Yêu Cầu
Tìm products có 'laptop' hoặc 'computer'.

### Gợi Ý
- Sử dụng | operator
- Sử dụng to_tsquery()

### Solution
```sql
SELECT 
  id,
  name
FROM products
WHERE to_tsvector('english', name) @@ to_tsquery('laptop | computer');
```

---

## 🎯 Bài Tập 5: AND Search (Trung Bình)

### Yêu Cầu
Tìm products có 'laptop' và 'computer'.

### Gợi Ý
- Sử dụng & operator
- Sử dụng to_tsquery()

### Solution
```sql
SELECT 
  id,
  name
FROM products
WHERE to_tsvector('english', name) @@ to_tsquery('laptop & computer');
```

---

## 🎯 Bài Tập 6: NOT Search (Trung Bình)

### Yêu Cầu
Tìm products có 'laptop' nhưng không 'broken'.

### Gợi Ý
- Sử dụng & ! operators
- Sử dụng to_tsquery()

### Solution
```sql
SELECT 
  id,
  name
FROM products
WHERE to_tsvector('english', name) @@ to_tsquery('laptop & !broken');
```

---

## 🎯 Bài Tập 7: Add tsvector Column (Trung Bình)

### Yêu Cầu
Thêm search_vector column & update tsvector.

### Gợi Ý
- Sử dụng ALTER TABLE
- Sử dụng UPDATE

### Solution
```sql
ALTER TABLE products ADD COLUMN IF NOT EXISTS search_vector tsvector;

UPDATE products 
SET search_vector = to_tsvector('english', name || ' ' || COALESCE(description, ''));
```

---

## 🎯 Bài Tập 8: Create GIN Index (Trung Bình)

### Yêu Cầu
Tạo GIN index cho search_vector.

### Gợi Ý
- Sử dụng CREATE INDEX
- Sử dụng USING GIN

### Solution
```sql
CREATE INDEX IF NOT EXISTS idx_products_search ON products USING GIN (search_vector);
```

---

## 🎯 Bài Tập 9: ts_rank() (Nâng Cao)

### Yêu Cầu
Ranking products theo relevance.

### Gợi Ý
- Sử dụng ts_rank()
- Sử dụng ORDER BY rank DESC

### Solution
```sql
SELECT 
  id,
  name,
  ts_rank(search_vector, query) AS rank
FROM products,
to_tsquery('laptop') query
WHERE search_vector @@ query
ORDER BY rank DESC;
```

---

## 🎯 Bài Tập 10: ts_headline() (Nâng Cao)

### Yêu Cầu
Highlight matches trong product name.

### Gợi Ý
- Sử dụng ts_headline()
- Sử dụng 'english' language

### Solution
```sql
SELECT 
  id,
  name,
  ts_headline('english', name, query) AS headline
FROM products,
to_tsquery('laptop') query
WHERE search_vector @@ query;
```

---

## 🎯 Bài Tập 11: plainto_tsquery() (Nâng Cao)

### Yêu Cầu
Tìm products sử dụng plainto_tsquery().

### Gợi Ý
- Sử dụng plainto_tsquery()
- Sử dụng 'english' language

### Solution
```sql
SELECT 
  id,
  name
FROM products
WHERE search_vector @@ plainto_tsquery('english', 'laptop computer');
```

---

## 🎯 Bài Tập 12: websearch_to_tsquery() (Nâng Cao)

### Yêu Cầu
Tìm products sử dụng web search syntax.

### Gợi Ý
- Sử dụng websearch_to_tsquery()
- Sử dụng 'english' language

### Solution
```sql
SELECT 
  id,
  name
FROM products
WHERE search_vector @@ websearch_to_tsquery('english', 'laptop -broken');
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-3: Create tsvector & tsquery
- [ ] Bài 4-6: Search operators
- [ ] Bài 7-8: Columns & Indexes
- [ ] Bài 9-12: Text search functions

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ Create tsvector & tsquery
- ✅ Simple & complex searches
- ✅ Search operators (|, &, !)
- ✅ Add tsvector columns
- ✅ Create GIN indexes
- ✅ ts_rank() & ts_headline()
- ✅ plainto_tsquery() & websearch_to_tsquery()

---

**Chúc mừng! Bạn đã hoàn thành Module 5 - Full-Text Search! 🎉**

