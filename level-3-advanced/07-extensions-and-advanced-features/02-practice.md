# 🛠️ Extensions & Advanced Features - Thực Hành

Thực hành sử dụng PostgreSQL extensions & advanced features.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Install & use extensions
- ✅ Sử dụng được UUID type
- ✅ Sử dụng được Array type
- ✅ Sử dụng được Range type
- ✅ Implement advanced features

---

## 📋 Bước 1: Chuẩn Bị Database

### Bước 1.1: Kết Nối Database

```sql
-- Kết nối
psql -U postgres -d ecommerce_practice

-- List extensions
\dx
```

---

## 🔌 Bước 2: Install Extensions

### Thực Hành 2.1: Install pg_stat_statements

```sql
-- Install extension
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- Verify installation
\dx pg_stat_statements
```

### Thực Hành 2.2: Install uuid-ossp

```sql
-- Install extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Generate UUID
SELECT uuid_generate_v4();

-- Verify installation
\dx uuid-ossp
```

### Thực Hành 2.3: Install hstore

```sql
-- Install extension
CREATE EXTENSION IF NOT EXISTS hstore;

-- Verify installation
\dx hstore
```

---

## 🔑 Bước 3: UUID Type

### Thực Hành 3.1: Create Table with UUID

```sql
-- Create table with UUID
CREATE TABLE users_uuid (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255),
  email VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Thực Hành 3.2: Insert UUID Data

```sql
-- Insert data
INSERT INTO users_uuid (name, email) VALUES ('John Doe', 'john@example.com');
INSERT INTO users_uuid (name, email) VALUES ('Jane Smith', 'jane@example.com');

-- Query
SELECT * FROM users_uuid;
```

### Thực Hành 3.3: Query by UUID

```sql
-- Get specific UUID
SELECT id FROM users_uuid WHERE name = 'John Doe';

-- Query by UUID
SELECT * FROM users_uuid WHERE id = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';
```

---

## 📊 Bước 4: Array Type

### Thực Hành 4.1: Create Table with Array

```sql
-- Create table with array
CREATE TABLE products_array (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  tags TEXT[],
  prices DECIMAL[]
);
```

### Thực Hành 4.2: Insert Array Data

```sql
-- Insert array data
INSERT INTO products_array (name, tags, prices) 
VALUES ('Laptop', ARRAY['electronics', 'computers', 'portable'], ARRAY[999.99, 1099.99, 1199.99]);

INSERT INTO products_array (name, tags, prices) 
VALUES ('Mouse', ARRAY['electronics', 'accessories'], ARRAY[29.99, 39.99]);

-- Query
SELECT * FROM products_array;
```

### Thực Hành 4.3: Query Array Data

```sql
-- Query array contains
SELECT * FROM products_array WHERE 'electronics' = ANY(tags);

-- Query array length
SELECT name, array_length(tags, 1) AS tag_count FROM products_array;

-- Array functions
SELECT name, array_append(tags, 'new_tag') FROM products_array;
SELECT name, array_remove(tags, 'electronics') FROM products_array;
```

---

## 📈 Bước 5: Range Type

### Thực Hành 5.1: Create Table with Range

```sql
-- Create table with range
CREATE TABLE events_range (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  date_range daterange,
  time_range tsrange
);
```

### Thực Hành 5.2: Insert Range Data

```sql
-- Insert range data
INSERT INTO events_range (name, date_range, time_range) 
VALUES ('Conference', '[2024-01-01, 2024-01-05)'::daterange, '[2024-01-01 09:00:00, 2024-01-05 17:00:00)'::tsrange);

INSERT INTO events_range (name, date_range, time_range) 
VALUES ('Workshop', '[2024-02-01, 2024-02-03)'::daterange, '[2024-02-01 10:00:00, 2024-02-03 16:00:00)'::tsrange);

-- Query
SELECT * FROM events_range;
```

### Thực Hành 5.3: Query Range Data

```sql
-- Query range contains
SELECT * FROM events_range WHERE date_range @> '2024-01-03'::date;

-- Query range overlaps
SELECT * FROM events_range WHERE date_range && '[2024-01-01, 2024-01-10)'::daterange;

-- Range functions
SELECT name, lower(date_range), upper(date_range) FROM events_range;
```

---

## 🔍 Bước 6: hstore Type

### Thực Hành 6.1: Create Table with hstore

```sql
-- Create table with hstore
CREATE TABLE settings_hstore (
  id SERIAL PRIMARY KEY,
  user_id INT,
  config hstore
);
```

### Thực Hành 6.2: Insert hstore Data

```sql
-- Insert hstore data
INSERT INTO settings_hstore (user_id, config) 
VALUES (1, 'theme=>dark, language=>en, notifications=>true'::hstore);

INSERT INTO settings_hstore (user_id, config) 
VALUES (2, 'theme=>light, language=>vi, notifications=>false'::hstore);

-- Query
SELECT * FROM settings_hstore;
```

### Thực Hành 6.3: Query hstore Data

```sql
-- Query hstore key
SELECT config->'theme' FROM settings_hstore;

-- Query hstore contains
SELECT * FROM settings_hstore WHERE config->'theme' = 'dark';

-- hstore functions
SELECT akeys(config) FROM settings_hstore;
SELECT avals(config) FROM settings_hstore;
```

---

## 📝 Bước 7: Advanced Features

### Thực Hành 7.1: Install pg_trgm

```sql
-- Install extension
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Create trigram index
CREATE INDEX idx_products_name_trgm ON products USING GIN (name gin_trgm_ops);

-- Similarity search
SELECT * FROM products WHERE name % 'laptop';
```

### Thực Hành 7.2: List All Extensions

```sql
-- List all available extensions
SELECT * FROM pg_available_extensions;

-- List installed extensions
\dx
```

---

## ✅ Checklist Thực Hành

- [ ] Install extensions
- [ ] Use UUID type
- [ ] Use Array type
- [ ] Use Range type
- [ ] Use hstore type
- [ ] Query advanced types
- [ ] Create indexes
- [ ] Test all features

---

## 💡 Tips

1. **Choose right type** - For your data
2. **Use indexes** - For performance
3. **Understand operators** - For queries
4. **Test thoroughly** - Before production
5. **Document usage** - For maintenance

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

