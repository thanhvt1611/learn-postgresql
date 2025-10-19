# 📚 Partitioning & Sharding - Lý Thuyết

Hiểu cách sử dụng partitioning & sharding để scale databases.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu Partitioning là gì
- ✅ Biết các loại Partitioning
- ✅ Sử dụng được Range Partitioning
- ✅ Sử dụng được List Partitioning
- ✅ Sử dụng được Hash Partitioning
- ✅ Hiểu Sharding & best practices

---

## 📊 Partitioning

### Định Nghĩa

**Partitioning** là chia một table lớn thành nhiều smaller tables (partitions).

### Tại Sao Quan Trọng?

1. **Performance** - Queries nhanh hơn
2. **Maintenance** - Dễ bảo trì
3. **Scalability** - Hỗ trợ large datasets
4. **Archiving** - Dễ xóa old data

---

## 🔀 Range Partitioning

### Định Nghĩa

**Range Partitioning** chia data dựa trên range values.

### Ví Dụ

```sql
-- Tạo partitioned table
CREATE TABLE orders (
  id SERIAL,
  user_id INT,
  total_amount DECIMAL,
  created_at DATE
) PARTITION BY RANGE (created_at);

-- Tạo partitions
CREATE TABLE orders_2023_q1 PARTITION OF orders
  FOR VALUES FROM ('2023-01-01') TO ('2023-04-01');

CREATE TABLE orders_2023_q2 PARTITION OF orders
  FOR VALUES FROM ('2023-04-01') TO ('2023-07-01');

CREATE TABLE orders_2023_q3 PARTITION OF orders
  FOR VALUES FROM ('2023-07-01') TO ('2023-10-01');

CREATE TABLE orders_2023_q4 PARTITION OF orders
  FOR VALUES FROM ('2023-10-01') TO ('2024-01-01');
```

### Ưu Điểm

1. **Time-based** - Dễ archiving
2. **Sequential** - Dễ maintenance
3. **Clear boundaries** - Rõ ràng

---

## 📋 List Partitioning

### Định Nghĩa

**List Partitioning** chia data dựa trên list values.

### Ví Dụ

```sql
-- Tạo partitioned table
CREATE TABLE users (
  id SERIAL,
  name VARCHAR(255),
  country VARCHAR(100)
) PARTITION BY LIST (country);

-- Tạo partitions
CREATE TABLE users_asia PARTITION OF users
  FOR VALUES IN ('Vietnam', 'Thailand', 'Philippines');

CREATE TABLE users_europe PARTITION OF users
  FOR VALUES IN ('France', 'Germany', 'UK');

CREATE TABLE users_americas PARTITION OF users
  FOR VALUES IN ('USA', 'Canada', 'Brazil');
```

### Ưu Điểm

1. **Categorical** - Dễ phân loại
2. **Flexible** - Có thể thêm values
3. **Clear logic** - Rõ ràng

---

## #️⃣ Hash Partitioning

### Định Nghĩa

**Hash Partitioning** chia data dựa trên hash function.

### Ví Dụ

```sql
-- Tạo partitioned table
CREATE TABLE products (
  id SERIAL,
  name VARCHAR(255),
  price DECIMAL
) PARTITION BY HASH (id);

-- Tạo partitions
CREATE TABLE products_p0 PARTITION OF products
  FOR VALUES WITH (MODULUS 4, REMAINDER 0);

CREATE TABLE products_p1 PARTITION OF products
  FOR VALUES WITH (MODULUS 4, REMAINDER 1);

CREATE TABLE products_p2 PARTITION OF products
  FOR VALUES WITH (MODULUS 4, REMAINDER 2);

CREATE TABLE products_p3 PARTITION OF products
  FOR VALUES WITH (MODULUS 4, REMAINDER 3);
```

### Ưu Điểm

1. **Even distribution** - Phân phối đều
2. **Automatic** - Tự động phân phối
3. **Scalable** - Dễ thêm partitions

---

## 🌍 Sharding

### Định Nghĩa

**Sharding** là chia data giữa nhiều databases/servers.

### Loại Sharding

1. **Range Sharding** - Dựa trên range
2. **Directory Sharding** - Dựa trên lookup table
3. **Hash Sharding** - Dựa trên hash function
4. **Geographic Sharding** - Dựa trên location

### Ví Dụ

```sql
-- Shard 1 (user_id 1-1000)
-- Shard 2 (user_id 1001-2000)
-- Shard 3 (user_id 2001-3000)

-- Tính shard ID
SELECT user_id % 3 AS shard_id FROM orders;
```

### Ưu Điểm

1. **Horizontal scaling** - Thêm servers
2. **High availability** - Redundancy
3. **Performance** - Distributed queries

### Nhược Điểm

1. **Complexity** - Phức tạp
2. **Joins** - Khó cross-shard joins
3. **Rebalancing** - Khó rebalance

---

## 📊 Tóm Tắt Partitioning & Sharding

| Khái Niệm | Mô Tả | Khi Dùng |
|-----------|-------|---------|
| **Range Partitioning** | Chia dựa trên range | Time-based data |
| **List Partitioning** | Chia dựa trên list | Categorical data |
| **Hash Partitioning** | Chia dựa trên hash | Even distribution |
| **Sharding** | Chia giữa servers | Large scale |
| **Partition Pruning** | Skip partitions | Performance |
| **Constraint Exclusion** | Exclude partitions | Optimization |

---

## 🎓 Key Takeaways

1. **Partitioning** - Chia table thành partitions
2. **Range Partitioning** - Dựa trên range
3. **List Partitioning** - Dựa trên list
4. **Hash Partitioning** - Dựa trên hash
5. **Sharding** - Chia giữa servers
6. **Partition Pruning** - Tối ưu queries
7. **Best Practices** - Chọn partition key cẩn thận

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL Partitioning](https://www.postgresql.org/docs/current/ddl-partitioning.html)
- [PostgreSQL Constraint Exclusion](https://www.postgresql.org/docs/current/ddl-partitioning.html#DDL-PARTITIONING-CONSTRAINT-EXCLUSION)

---

**Bây giờ bạn đã hiểu Partitioning & Sharding! Hãy chuyển sang phần thực hành. 💪**

