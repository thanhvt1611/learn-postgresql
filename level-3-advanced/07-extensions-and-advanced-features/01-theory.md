# 📚 Extensions & Advanced Features - Lý Thuyết

Hiểu cách sử dụng PostgreSQL extensions & advanced features.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu PostgreSQL Extensions
- ✅ Biết cách install extensions
- ✅ Sử dụng được popular extensions
- ✅ Hiểu UUID & SERIAL types
- ✅ Sử dụng được Array & Range types
- ✅ Hiểu Advanced features best practices

---

## 🔌 PostgreSQL Extensions

### Định Nghĩa

**Extension** - Add-on packages để extend PostgreSQL functionality.

### Tại Sao Quan Trọng?

1. **Functionality** - Add new features
2. **Performance** - Optimize operations
3. **Compatibility** - Support standards
4. **Flexibility** - Customize database

---

## 📦 Popular Extensions

### pg_stat_statements

```sql
-- Install extension
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- View query statistics
SELECT query, calls, mean_time, max_time
FROM pg_stat_statements
ORDER BY total_time DESC;
```

### uuid-ossp

```sql
-- Install extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Generate UUID
SELECT uuid_generate_v4();

-- Use in table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255)
);
```

### hstore

```sql
-- Install extension
CREATE EXTENSION IF NOT EXISTS hstore;

-- Create hstore column
CREATE TABLE settings (
  id SERIAL PRIMARY KEY,
  config hstore
);

-- Insert hstore data
INSERT INTO settings (config) VALUES ('key1=>value1, key2=>value2');

-- Query hstore
SELECT config->'key1' FROM settings;
```

### ltree

```sql
-- Install extension
CREATE EXTENSION IF NOT EXISTS ltree;

-- Create ltree column
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  path ltree
);

-- Insert hierarchical data
INSERT INTO categories (path) VALUES ('Electronics.Computers.Laptops');

-- Query hierarchical data
SELECT * FROM categories WHERE path <@ 'Electronics.Computers';
```

### pg_trgm

```sql
-- Install extension
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Create trigram index
CREATE INDEX idx_products_name_trgm ON products USING GIN (name gin_trgm_ops);

-- Similarity search
SELECT * FROM products WHERE name % 'laptop';
```

---

## 🔑 UUID Type

### Định Nghĩa

**UUID** - Universally Unique Identifier.

### Ưu Điểm

1. **Globally unique** - No conflicts
2. **Distributed** - Generate anywhere
3. **Privacy** - No sequential IDs

### Ví Dụ

```sql
-- Create table with UUID
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255),
  email VARCHAR(255)
);

-- Insert data
INSERT INTO users (name, email) VALUES ('John', 'john@example.com');

-- Query
SELECT * FROM users WHERE id = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';
```

---

## 📊 Array Type

### Định Nghĩa

**Array** - Collection of values.

### Ví Dụ

```sql
-- Create table with array
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  tags TEXT[]
);

-- Insert array data
INSERT INTO products (name, tags) VALUES ('Laptop', ARRAY['electronics', 'computers']);

-- Query array
SELECT * FROM products WHERE 'electronics' = ANY(tags);

-- Array functions
SELECT array_length(tags, 1) FROM products;
SELECT array_append(tags, 'new_tag') FROM products;
```

---

## 📈 Range Type

### Định Nghĩa

**Range** - Continuous range of values.

### Ví Dụ

```sql
-- Create table with range
CREATE TABLE events (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  date_range daterange
);

-- Insert range data
INSERT INTO events (name, date_range) VALUES ('Conference', '[2024-01-01, 2024-01-05)');

-- Query range
SELECT * FROM events WHERE date_range @> '2024-01-03'::date;

-- Range operators
SELECT * FROM events WHERE date_range && '[2024-01-01, 2024-01-10)'::daterange;
```

---

## 🔍 Full-Text Search Extensions

### Unaccent

```sql
-- Install extension
CREATE EXTENSION IF NOT EXISTS unaccent;

-- Use unaccent
SELECT unaccent('café');  -- Returns 'cafe'
```

### Fuzzy String Matching

```sql
-- Install extension
CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;

-- Use soundex
SELECT soundex('Smith');
SELECT soundex('Smythe');

-- Use levenshtein
SELECT levenshtein('kitten', 'sitting');
```

---

## 📊 Tóm Tắt Extensions

| Extension | Mô Tả | Khi Dùng |
|-----------|-------|---------|
| **pg_stat_statements** | Query stats | Performance |
| **uuid-ossp** | UUID generation | Unique IDs |
| **hstore** | Key-value store | Flexible data |
| **ltree** | Hierarchical data | Trees |
| **pg_trgm** | Trigram search | Fuzzy search |
| **Array** | Collections | Multiple values |
| **Range** | Value ranges | Date ranges |

---

## 🎓 Key Takeaways

1. **Extensions** - Add functionality
2. **UUID** - Globally unique IDs
3. **Array** - Collections
4. **Range** - Value ranges
5. **hstore** - Key-value data
6. **ltree** - Hierarchical data
7. **Best Practices** - Use appropriate types

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL Extensions](https://www.postgresql.org/docs/current/contrib.html)
- [PostgreSQL UUID](https://www.postgresql.org/docs/current/datatype-uuid.html)
- [PostgreSQL Arrays](https://www.postgresql.org/docs/current/arrays.html)
- [PostgreSQL Ranges](https://www.postgresql.org/docs/current/rangetypes.html)

---

**Bây giờ bạn đã hiểu Extensions & Advanced Features! Hãy chuyển sang phần thực hành. 💪**

