# 💪 Extensions & Advanced Features - Bài Tập

Thực hành sử dụng PostgreSQL extensions & advanced features.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có database "ecommerce_practice" với sample data

---

## 🎯 Bài Tập 1: Install pg_stat_statements (Dễ)

### Yêu Cầu
Install pg_stat_statements extension.

### Gợi Ý
- Sử dụng CREATE EXTENSION IF NOT EXISTS

### Solution
```sql
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
```

---

## 🎯 Bài Tập 2: Install uuid-ossp (Dễ)

### Yêu Cầu
Install uuid-ossp extension.

### Gợi Ý
- Sử dụng CREATE EXTENSION IF NOT EXISTS
- Sử dụng quoted name

### Solution
```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

---

## 🎯 Bài Tập 3: Generate UUID (Dễ)

### Yêu Cầu
Generate UUID.

### Gợi Ý
- Sử dụng uuid_generate_v4()

### Solution
```sql
SELECT uuid_generate_v4();
```

---

## 🎯 Bài Tập 4: Create Table with UUID (Trung Bình)

### Yêu Cầu
Create table with UUID primary key.

### Gợi Ý
- Sử dụng CREATE TABLE
- Sử dụng UUID type
- Sử dụng DEFAULT uuid_generate_v4()

### Solution
```sql
CREATE TABLE users_uuid (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255),
  email VARCHAR(255)
);
```

---

## 🎯 Bài Tập 5: Create Table with Array (Trung Bình)

### Yêu Cầu
Create table with array column.

### Gợi Ý
- Sử dụng CREATE TABLE
- Sử dụng TEXT[] type

### Solution
```sql
CREATE TABLE products_array (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  tags TEXT[]
);
```

---

## 🎯 Bài Tập 6: Insert Array Data (Trung Bình)

### Yêu Cầu
Insert array data.

### Gợi Ý
- Sử dụng INSERT
- Sử dụng ARRAY[]

### Solution
```sql
INSERT INTO products_array (name, tags) 
VALUES ('Laptop', ARRAY['electronics', 'computers']);
```

---

## 🎯 Bài Tập 7: Query Array Data (Trung Bình)

### Yêu Cầu
Query array data.

### Gợi Ý
- Sử dụng ANY operator
- Sử dụng WHERE clause

### Solution
```sql
SELECT * FROM products_array WHERE 'electronics' = ANY(tags);
```

---

## 🎯 Bài Tập 8: Create Table with Range (Nâng Cao)

### Yêu Cầu
Create table with range column.

### Gợi Ý
- Sử dụng CREATE TABLE
- Sử dụng daterange type

### Solution
```sql
CREATE TABLE events_range (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  date_range daterange
);
```

---

## 🎯 Bài Tập 9: Insert Range Data (Nâng Cao)

### Yêu Cầu
Insert range data.

### Gợi Ý
- Sử dụng INSERT
- Sử dụng daterange type

### Solution
```sql
INSERT INTO events_range (name, date_range) 
VALUES ('Conference', '[2024-01-01, 2024-01-05)'::daterange);
```

---

## 🎯 Bài Tập 10: Query Range Data (Nâng Cao)

### Yêu Cầu
Query range data.

### Gợi Ý
- Sử dụng @> operator
- Sử dụng WHERE clause

### Solution
```sql
SELECT * FROM events_range WHERE date_range @> '2024-01-03'::date;
```

---

## 🎯 Bài Tập 11: Install hstore (Nâng Cao)

### Yêu Cầu
Install hstore extension.

### Gợi Ý
- Sử dụng CREATE EXTENSION IF NOT EXISTS

### Solution
```sql
CREATE EXTENSION IF NOT EXISTS hstore;
```

---

## 🎯 Bài Tập 12: Use hstore (Nâng Cao)

### Yêu Cầu
Create table with hstore & insert data.

### Gợi Ý
- Sử dụng CREATE TABLE
- Sử dụng hstore type
- Sử dụng INSERT

### Solution
```sql
CREATE TABLE settings_hstore (
  id SERIAL PRIMARY KEY,
  config hstore
);

INSERT INTO settings_hstore (config) 
VALUES ('theme=>dark, language=>en'::hstore);

SELECT config->'theme' FROM settings_hstore;
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-3: Extensions & UUID
- [ ] Bài 4-7: Array Type
- [ ] Bài 8-10: Range Type
- [ ] Bài 11-12: hstore Type

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ Install extensions
- ✅ Generate UUIDs
- ✅ Create UUID tables
- ✅ Use Array type
- ✅ Query arrays
- ✅ Use Range type
- ✅ Query ranges
- ✅ Use hstore type

---

**Chúc mừng! Bạn đã hoàn thành Module 7 - Extensions & Advanced Features! 🎉**

