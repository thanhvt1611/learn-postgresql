# 💪 Partitioning & Sharding - Bài Tập

Thực hành sử dụng partitioning để scale databases.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có partitioned tables

---

## 🎯 Bài Tập 1: Create Range Partitioned Table (Dễ)

### Yêu Cầu
Tạo orders_partitioned table với 4 quarterly partitions.

### Gợi Ý
- Sử dụng PARTITION BY RANGE
- Sử dụng created_at column

### Solution
```sql
CREATE TABLE IF NOT EXISTS orders_partitioned (
  id SERIAL,
  user_id INT,
  total_amount DECIMAL,
  created_at DATE
) PARTITION BY RANGE (created_at);

CREATE TABLE orders_2024_q1 PARTITION OF orders_partitioned
  FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');

CREATE TABLE orders_2024_q2 PARTITION OF orders_partitioned
  FOR VALUES FROM ('2024-04-01') TO ('2024-07-01');

CREATE TABLE orders_2024_q3 PARTITION OF orders_partitioned
  FOR VALUES FROM ('2024-07-01') TO ('2024-10-01');

CREATE TABLE orders_2024_q4 PARTITION OF orders_partitioned
  FOR VALUES FROM ('2024-10-01') TO ('2025-01-01');
```

---

## 🎯 Bài Tập 2: Insert Data into Range Partitions (Dễ)

### Yêu Cầu
Thêm 4 orders vào different partitions.

### Gợi Ý
- Sử dụng INSERT
- Sử dụng different dates

### Solution
```sql
INSERT INTO orders_partitioned (user_id, total_amount, created_at)
VALUES 
  (1, 100, '2024-01-15'),
  (2, 200, '2024-05-20'),
  (3, 150, '2024-08-10'),
  (4, 300, '2024-11-05');
```

---

## 🎯 Bài Tập 3: Query Range Partitions (Dễ)

### Yêu Cầu
Query tất cả orders & specific partition.

### Gợi Ý
- Sử dụng SELECT
- Sử dụng FROM

### Solution
```sql
-- Query all partitions
SELECT * FROM orders_partitioned;

-- Query specific partition
SELECT * FROM orders_2024_q1;
```

---

## 🎯 Bài Tập 4: Create List Partitioned Table (Trung Bình)

### Yêu Cầu
Tạo users_partitioned table với 3 regional partitions.

### Gợi Ý
- Sử dụng PARTITION BY LIST
- Sử dụng country column

### Solution
```sql
CREATE TABLE IF NOT EXISTS users_partitioned (
  id SERIAL,
  name VARCHAR(255),
  country VARCHAR(100)
) PARTITION BY LIST (country);

CREATE TABLE users_asia PARTITION OF users_partitioned
  FOR VALUES IN ('Vietnam', 'Thailand', 'Philippines', 'Indonesia');

CREATE TABLE users_europe PARTITION OF users_partitioned
  FOR VALUES IN ('France', 'Germany', 'UK', 'Spain');

CREATE TABLE users_americas PARTITION OF users_partitioned
  FOR VALUES IN ('USA', 'Canada', 'Brazil', 'Mexico');
```

---

## 🎯 Bài Tập 5: Insert Data into List Partitions (Trung Bình)

### Yêu Cầu
Thêm 4 users vào different partitions.

### Gợi Ý
- Sử dụng INSERT
- Sử dụng different countries

### Solution
```sql
INSERT INTO users_partitioned (name, country)
VALUES 
  ('Nguyen Van A', 'Vietnam'),
  ('Jean Dupont', 'France'),
  ('John Smith', 'USA'),
  ('Maria Garcia', 'Mexico');
```

---

## 🎯 Bài Tập 6: Create Hash Partitioned Table (Trung Bình)

### Yêu Cầu
Tạo products_partitioned table với 4 hash partitions.

### Gợi Ý
- Sử dụng PARTITION BY HASH
- Sử dụng id column

### Solution
```sql
CREATE TABLE IF NOT EXISTS products_partitioned (
  id SERIAL,
  name VARCHAR(255),
  price DECIMAL
) PARTITION BY HASH (id);

CREATE TABLE products_p0 PARTITION OF products_partitioned
  FOR VALUES WITH (MODULUS 4, REMAINDER 0);

CREATE TABLE products_p1 PARTITION OF products_partitioned
  FOR VALUES WITH (MODULUS 4, REMAINDER 1);

CREATE TABLE products_p2 PARTITION OF products_partitioned
  FOR VALUES WITH (MODULUS 4, REMAINDER 2);

CREATE TABLE products_p3 PARTITION OF products_partitioned
  FOR VALUES WITH (MODULUS 4, REMAINDER 3);
```

---

## 🎯 Bài Tập 7: Insert Data into Hash Partitions (Trung Bình)

### Yêu Cầu
Thêm 4 products vào hash partitions.

### Gợi Ý
- Sử dụng INSERT
- Sử dụng different IDs

### Solution
```sql
INSERT INTO products_partitioned (name, price)
VALUES 
  ('Laptop', 1200),
  ('Mouse', 50),
  ('Keyboard', 150),
  ('Monitor', 400);
```

---

## 🎯 Bài Tập 8: Enable Constraint Exclusion (Trung Bình)

### Yêu Cầu
Enable constraint exclusion & verify setting.

### Gợi Ý
- Sử dụng SET
- Sử dụng SHOW

### Solution
```sql
SET constraint_exclusion = partition;
SHOW constraint_exclusion;
```

---

## 🎯 Bài Tập 9: Partition Pruning (Nâng Cao)

### Yêu Cầu
Sử dụng EXPLAIN để verify partition pruning.

### Gợi Ý
- Sử dụng EXPLAIN
- Sử dụng WHERE clause

### Solution
```sql
EXPLAIN SELECT * FROM orders_partitioned 
WHERE created_at >= '2024-01-01' AND created_at < '2024-04-01';
```

---

## 🎯 Bài Tập 10: List Partitions (Nâng Cao)

### Yêu Cầu
List tất cả partitions từ pg_tables.

### Gợi Ý
- Sử dụng SELECT
- Sử dụng pg_tables

### Solution
```sql
SELECT 
  schemaname,
  tablename,
  tableowner
FROM pg_tables
WHERE tablename LIKE '%partitioned%' OR tablename LIKE '%_p%' OR tablename LIKE '%_q%'
ORDER BY tablename;
```

---

## 🎯 Bài Tập 11: Calculate Shard ID (Nâng Cao)

### Yêu Cầu
Tính shard ID cho 3 shards.

### Gợi Ý
- Sử dụng modulo operator (%)
- Sử dụng user_id

### Solution
```sql
SELECT 
  id,
  user_id,
  user_id % 3 AS shard_id
FROM orders_partitioned;
```

---

## 🎯 Bài Tập 12: Sharding by Range (Nâng Cao)

### Yêu Cầu
Tính shard ID dựa trên user_id range.

### Gợi Ý
- Sử dụng CASE statement
- Sử dụng user_id ranges

### Solution
```sql
SELECT 
  id,
  user_id,
  CASE 
    WHEN user_id <= 1000 THEN 'shard_1'
    WHEN user_id <= 2000 THEN 'shard_2'
    ELSE 'shard_3'
  END AS shard_id
FROM orders_partitioned;
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-3: Range Partitioning
- [ ] Bài 4-5: List Partitioning
- [ ] Bài 6-7: Hash Partitioning
- [ ] Bài 8-10: Partition Management
- [ ] Bài 11-12: Sharding Strategies

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ Range Partitioning
- ✅ List Partitioning
- ✅ Hash Partitioning
- ✅ Insert data vào partitions
- ✅ Query partitions
- ✅ Constraint exclusion
- ✅ Partition pruning
- ✅ Sharding strategies

---

**Chúc mừng! Bạn đã hoàn thành Module 6 - Partitioning & Sharding! 🎉**

