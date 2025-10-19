# 🛠️ Partitioning & Sharding - Thực Hành

Thực hành sử dụng partitioning để scale databases.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Tạo được Range Partitioned tables
- ✅ Tạo được List Partitioned tables
- ✅ Tạo được Hash Partitioned tables
- ✅ Sử dụng được Partition Pruning
- ✅ Hiểu Sharding strategies

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

## 🔀 Bước 2: Range Partitioning

### Thực Hành 2.1: Create Range Partitioned Table

```sql
-- Tạo partitioned table
CREATE TABLE IF NOT EXISTS orders_partitioned (
  id SERIAL,
  user_id INT,
  total_amount DECIMAL,
  created_at DATE
) PARTITION BY RANGE (created_at);

-- Tạo partitions cho 2024
CREATE TABLE orders_2024_q1 PARTITION OF orders_partitioned
  FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');

CREATE TABLE orders_2024_q2 PARTITION OF orders_partitioned
  FOR VALUES FROM ('2024-04-01') TO ('2024-07-01');

CREATE TABLE orders_2024_q3 PARTITION OF orders_partitioned
  FOR VALUES FROM ('2024-07-01') TO ('2024-10-01');

CREATE TABLE orders_2024_q4 PARTITION OF orders_partitioned
  FOR VALUES FROM ('2024-10-01') TO ('2025-01-01');
```

### Thực Hành 2.2: Insert Data

```sql
-- Insert sample data
INSERT INTO orders_partitioned (user_id, total_amount, created_at)
VALUES 
  (1, 100, '2024-01-15'),
  (2, 200, '2024-05-20'),
  (3, 150, '2024-08-10'),
  (4, 300, '2024-11-05');
```

### Thực Hành 2.3: Query Partitioned Table

```sql
-- Query all partitions
SELECT * FROM orders_partitioned;

-- Query specific partition
SELECT * FROM orders_2024_q1;
```

---

## 📋 Bước 3: List Partitioning

### Thực Hành 3.1: Create List Partitioned Table

```sql
-- Tạo partitioned table
CREATE TABLE IF NOT EXISTS users_partitioned (
  id SERIAL,
  name VARCHAR(255),
  country VARCHAR(100)
) PARTITION BY LIST (country);

-- Tạo partitions
CREATE TABLE users_asia PARTITION OF users_partitioned
  FOR VALUES IN ('Vietnam', 'Thailand', 'Philippines', 'Indonesia');

CREATE TABLE users_europe PARTITION OF users_partitioned
  FOR VALUES IN ('France', 'Germany', 'UK', 'Spain');

CREATE TABLE users_americas PARTITION OF users_partitioned
  FOR VALUES IN ('USA', 'Canada', 'Brazil', 'Mexico');
```

### Thực Hành 3.2: Insert Data

```sql
-- Insert sample data
INSERT INTO users_partitioned (name, country)
VALUES 
  ('Nguyen Van A', 'Vietnam'),
  ('Jean Dupont', 'France'),
  ('John Smith', 'USA'),
  ('Maria Garcia', 'Mexico');
```

### Thực Hành 3.3: Query Partitioned Table

```sql
-- Query all partitions
SELECT * FROM users_partitioned;

-- Query specific partition
SELECT * FROM users_asia;
```

---

## #️⃣ Bước 4: Hash Partitioning

### Thực Hành 4.1: Create Hash Partitioned Table

```sql
-- Tạo partitioned table
CREATE TABLE IF NOT EXISTS products_partitioned (
  id SERIAL,
  name VARCHAR(255),
  price DECIMAL
) PARTITION BY HASH (id);

-- Tạo 4 partitions
CREATE TABLE products_p0 PARTITION OF products_partitioned
  FOR VALUES WITH (MODULUS 4, REMAINDER 0);

CREATE TABLE products_p1 PARTITION OF products_partitioned
  FOR VALUES WITH (MODULUS 4, REMAINDER 1);

CREATE TABLE products_p2 PARTITION OF products_partitioned
  FOR VALUES WITH (MODULUS 4, REMAINDER 2);

CREATE TABLE products_p3 PARTITION OF products_partitioned
  FOR VALUES WITH (MODULUS 4, REMAINDER 3);
```

### Thực Hành 4.2: Insert Data

```sql
-- Insert sample data
INSERT INTO products_partitioned (name, price)
VALUES 
  ('Laptop', 1200),
  ('Mouse', 50),
  ('Keyboard', 150),
  ('Monitor', 400);
```

### Thực Hành 4.3: Query Partitioned Table

```sql
-- Query all partitions
SELECT * FROM products_partitioned;

-- Query specific partition
SELECT * FROM products_p0;
```

---

## 🔍 Bước 5: Partition Pruning

### Thực Hành 5.1: Enable Constraint Exclusion

```sql
-- Enable constraint exclusion
SET constraint_exclusion = partition;

-- Verify setting
SHOW constraint_exclusion;
```

### Thực Hành 5.2: Query with Partition Pruning

```sql
-- Query specific partition (pruning)
EXPLAIN SELECT * FROM orders_partitioned 
WHERE created_at >= '2024-01-01' AND created_at < '2024-04-01';

-- Query multiple partitions
EXPLAIN SELECT * FROM orders_partitioned 
WHERE created_at >= '2024-01-01' AND created_at < '2024-07-01';
```

---

## 📊 Bước 6: Verify Partitions

### Thực Hành 6.1: List Partitions

```sql
-- List all partitions
SELECT 
  schemaname,
  tablename,
  tableowner
FROM pg_tables
WHERE tablename LIKE '%partitioned%' OR tablename LIKE '%_p%' OR tablename LIKE '%_q%'
ORDER BY tablename;
```

### Thực Hành 6.2: Check Partition Info

```sql
-- Check partition info
SELECT 
  schemaname,
  tablename
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;
```

---

## 🌍 Bước 7: Sharding Strategy

### Thực Hành 7.1: Calculate Shard ID

```sql
-- Calculate shard ID (3 shards)
SELECT 
  id,
  user_id,
  user_id % 3 AS shard_id
FROM orders_partitioned;
```

### Thực Hành 7.2: Sharding by Range

```sql
-- Sharding by user_id range
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

## ✅ Checklist Thực Hành

- [ ] Tạo Range Partitioned table
- [ ] Tạo List Partitioned table
- [ ] Tạo Hash Partitioned table
- [ ] Insert data vào partitions
- [ ] Query partitions
- [ ] Enable constraint exclusion
- [ ] Verify partition pruning
- [ ] Understand sharding strategies

---

## 💡 Tips

1. **Chọn partition key cẩn thận** - Ảnh hưởng performance
2. **Sử dụng Range** - Cho time-based data
3. **Sử dụng List** - Cho categorical data
4. **Sử dụng Hash** - Cho even distribution
5. **Enable constraint_exclusion** - Cho partition pruning

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

