# 🛠️ Concurrency & Locking - Thực Hành

Thực hành quản lý concurrency & locking.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Sử dụng được Transactions
- ✅ Hiểu Isolation Levels
- ✅ Sử dụng được Locking
- ✅ Detect & resolve deadlocks
- ✅ Understand MVCC

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

## 🔄 Bước 2: Basic Transactions

### Thực Hành 2.1: Simple Transaction

```sql
-- Start transaction
BEGIN;

-- Insert data
INSERT INTO products (name, price) VALUES ('Product 1', 100);

-- Commit
COMMIT;

-- Verify
SELECT * FROM products WHERE name = 'Product 1';
```

### Thực Hành 2.2: Rollback Transaction

```sql
-- Start transaction
BEGIN;

-- Insert data
INSERT INTO products (name, price) VALUES ('Product 2', 200);

-- Rollback
ROLLBACK;

-- Verify (should not exist)
SELECT * FROM products WHERE name = 'Product 2';
```

### Thực Hành 2.3: Savepoints

```sql
-- Start transaction
BEGIN;

-- Insert first product
INSERT INTO products (name, price) VALUES ('Product 3', 300);

-- Create savepoint
SAVEPOINT sp1;

-- Insert second product
INSERT INTO products (name, price) VALUES ('Product 4', 400);

-- Rollback to savepoint
ROLLBACK TO sp1;

-- Commit
COMMIT;

-- Verify (only Product 3 exists)
SELECT * FROM products WHERE name IN ('Product 3', 'Product 4');
```

---

## 🔒 Bước 3: Isolation Levels

### Thực Hành 3.1: READ COMMITTED

```sql
-- Set isolation level
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Start transaction
BEGIN;

-- Read data
SELECT * FROM products WHERE id = 1;

-- Commit
COMMIT;
```

### Thực Hành 3.2: REPEATABLE READ

```sql
-- Set isolation level
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Start transaction
BEGIN;

-- Read data
SELECT * FROM products WHERE id = 1;

-- Commit
COMMIT;
```

### Thực Hành 3.3: SERIALIZABLE

```sql
-- Set isolation level
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Start transaction
BEGIN;

-- Read data
SELECT * FROM products WHERE id = 1;

-- Commit
COMMIT;
```

---

## 🔐 Bước 4: Row-Level Locking

### Thực Hành 4.1: SELECT FOR UPDATE

```sql
-- Terminal 1
BEGIN;
SELECT * FROM products WHERE id = 1 FOR UPDATE;

-- Terminal 2 (will wait)
BEGIN;
SELECT * FROM products WHERE id = 1 FOR UPDATE;

-- Terminal 1
COMMIT;

-- Terminal 2 (now proceeds)
COMMIT;
```

### Thực Hành 4.2: SELECT FOR SHARE

```sql
-- Terminal 1
BEGIN;
SELECT * FROM products WHERE id = 1 FOR SHARE;

-- Terminal 2 (can also read)
BEGIN;
SELECT * FROM products WHERE id = 1 FOR SHARE;

-- Terminal 1
COMMIT;

-- Terminal 2
COMMIT;
```

---

## 🔄 Bước 5: MVCC Behavior

### Thực Hành 5.1: Concurrent Reads & Writes

```sql
-- Terminal 1
BEGIN;
SELECT * FROM products WHERE id = 1;  -- Sees version A

-- Terminal 2
BEGIN;
UPDATE products SET price = 999 WHERE id = 1;
COMMIT;  -- Creates version B

-- Terminal 1
SELECT * FROM products WHERE id = 1;  -- Still sees version A
COMMIT;
```

---

## ⚠️ Bước 6: Deadlock Detection

### Thực Hành 6.1: Create Deadlock

```sql
-- Terminal 1
BEGIN;
UPDATE products SET price = 100 WHERE id = 1;
-- Wait for Terminal 2 to update id = 2

-- Terminal 2
BEGIN;
UPDATE products SET price = 200 WHERE id = 2;
-- Wait for Terminal 1 to update id = 2

-- Terminal 1
UPDATE products SET price = 300 WHERE id = 2;
-- DEADLOCK DETECTED!

-- Terminal 2
UPDATE products SET price = 400 WHERE id = 1;
-- One transaction will be rolled back
```

### Thực Hành 6.2: Prevent Deadlock with Lock Ordering

```sql
-- Terminal 1
BEGIN;
UPDATE products SET price = 100 WHERE id = 1;
UPDATE products SET price = 300 WHERE id = 2;
COMMIT;

-- Terminal 2
BEGIN;
UPDATE products SET price = 200 WHERE id = 1;
UPDATE products SET price = 400 WHERE id = 2;
COMMIT;
```

---

## 🛡️ Bước 7: Transaction Management

### Thực Hành 7.1: View Active Transactions

```sql
-- View active transactions
SELECT pid, usename, state, query
FROM pg_stat_activity
WHERE state != 'idle';
```

### Thực Hành 7.2: View Locks

```sql
-- View locks
SELECT l.pid, l.mode, l.granted, a.usename, a.query
FROM pg_locks l
JOIN pg_stat_activity a ON l.pid = a.pid
WHERE NOT l.granted;
```

### Thực Hành 7.3: Cancel Transaction

```sql
-- Cancel long-running transaction
SELECT pg_cancel_backend(pid)
FROM pg_stat_activity
WHERE query_start < CURRENT_TIMESTAMP - INTERVAL '5 minutes';
```

---

## ✅ Checklist Thực Hành

- [ ] Basic transactions
- [ ] Rollback & savepoints
- [ ] Isolation levels
- [ ] Row-level locking
- [ ] MVCC behavior
- [ ] Deadlock detection
- [ ] Lock ordering
- [ ] Transaction management

---

## 💡 Tips

1. **Keep transactions short** - Minimize lock duration
2. **Use appropriate isolation level** - Balance consistency & performance
3. **Lock in order** - Prevent deadlocks
4. **Handle errors** - Retry on deadlock
5. **Monitor locks** - Detect issues early

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

