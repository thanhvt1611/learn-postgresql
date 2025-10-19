# 📚 Concurrency & Locking - Lý Thuyết

Hiểu cách quản lý concurrency & locking trong PostgreSQL.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu Transactions
- ✅ Biết các Isolation Levels
- ✅ Hiểu Locking mechanisms
- ✅ Biết cách detect & resolve deadlocks
- ✅ Sử dụng được MVCC
- ✅ Hiểu Concurrency best practices

---

## 🔄 Transactions

### Định Nghĩa

**Transaction** - Sequence of SQL statements executed as single unit.

### ACID Properties

**Atomicity** - All or nothing
**Consistency** - Valid state
**Isolation** - Independent
**Durability** - Persistent

### Cú Pháp

```sql
BEGIN;
  -- SQL statements
COMMIT;

-- Or rollback
BEGIN;
  -- SQL statements
ROLLBACK;
```

---

## 🔒 Isolation Levels

### READ UNCOMMITTED

```sql
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
```

**Định Nghĩa:** Lowest isolation level.
**Issues:** Dirty reads, non-repeatable reads, phantom reads.

### READ COMMITTED

```sql
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
```

**Định Nghĩa:** Default level.
**Issues:** Non-repeatable reads, phantom reads.

### REPEATABLE READ

```sql
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
```

**Định Nghĩa:** Snapshot isolation.
**Issues:** Phantom reads.

### SERIALIZABLE

```sql
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

**Định Nghĩa:** Highest isolation level.
**Issues:** None (slowest).

---

## 🔐 Locking Mechanisms

### Row-Level Locks

**FOR UPDATE** - Exclusive lock
```sql
SELECT * FROM products WHERE id = 1 FOR UPDATE;
```

**FOR SHARE** - Shared lock
```sql
SELECT * FROM products WHERE id = 1 FOR SHARE;
```

### Table-Level Locks

**ACCESS SHARE** - SELECT
**ROW SHARE** - SELECT FOR SHARE
**ROW EXCLUSIVE** - SELECT FOR UPDATE, INSERT, UPDATE, DELETE
**SHARE** - LOCK TABLE
**EXCLUSIVE** - LOCK TABLE

### Deadlocks

**Định Nghĩa:** Two transactions waiting for each other.

```sql
-- Transaction 1
BEGIN;
UPDATE products SET price = 100 WHERE id = 1;
UPDATE products SET price = 200 WHERE id = 2;
COMMIT;

-- Transaction 2 (at same time)
BEGIN;
UPDATE products SET price = 300 WHERE id = 2;
UPDATE products SET price = 400 WHERE id = 1;
COMMIT;
```

---

## 🔄 MVCC (Multi-Version Concurrency Control)

### Định Nghĩa

**MVCC** - Multiple versions of data for concurrent access.

### Ưu Điểm

1. **Readers don't block writers**
2. **Writers don't block readers**
3. **Better concurrency**

### Ví Dụ

```sql
-- Transaction 1
BEGIN;
SELECT * FROM products WHERE id = 1;  -- Sees version A

-- Transaction 2 (at same time)
BEGIN;
UPDATE products SET price = 100 WHERE id = 1;
COMMIT;  -- Creates version B

-- Transaction 1
SELECT * FROM products WHERE id = 1;  -- Still sees version A
COMMIT;
```

---

## 🛡️ Preventing Deadlocks

### 1. Lock Ordering

```sql
-- Always lock in same order
BEGIN;
UPDATE products SET price = 100 WHERE id = 1;
UPDATE products SET price = 200 WHERE id = 2;
COMMIT;
```

### 2. Minimize Lock Duration

```sql
-- Keep transactions short
BEGIN;
UPDATE products SET price = 100 WHERE id = 1;
COMMIT;
```

### 3. Use Appropriate Isolation Level

```sql
-- Use READ COMMITTED for most cases
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
```

### 4. Handle Deadlock Errors

```sql
-- Retry on deadlock
BEGIN;
  UPDATE products SET price = 100 WHERE id = 1;
EXCEPTION WHEN serialization_failure THEN
  -- Retry
END;
```

---

## 📊 Tóm Tắt Concurrency

| Khái Niệm | Mô Tả | Khi Dùng |
|-----------|-------|---------|
| **Transaction** | SQL unit | Consistency |
| **ACID** | Properties | Reliability |
| **READ UNCOMMITTED** | Lowest isolation | Rare |
| **READ COMMITTED** | Default | Most cases |
| **REPEATABLE READ** | Snapshot | Consistency |
| **SERIALIZABLE** | Highest isolation | Critical |
| **MVCC** | Multiple versions | Concurrency |
| **Deadlock** | Circular wait | Avoid |

---

## 🎓 Key Takeaways

1. **Transactions** - ACID properties
2. **Isolation Levels** - READ UNCOMMITTED to SERIALIZABLE
3. **Locking** - Row & table locks
4. **MVCC** - Multiple versions
5. **Deadlocks** - Detect & prevent
6. **Lock Ordering** - Consistent order
7. **Best Practices** - Keep transactions short

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL Transactions](https://www.postgresql.org/docs/current/tutorial-transactions.html)
- [PostgreSQL Isolation Levels](https://www.postgresql.org/docs/current/transaction-iso.html)
- [PostgreSQL Locking](https://www.postgresql.org/docs/current/explicit-locking.html)

---

**Bây giờ bạn đã hiểu Concurrency & Locking! Hãy chuyển sang phần thực hành. 💪**

