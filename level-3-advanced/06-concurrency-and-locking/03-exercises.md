# 💪 Concurrency & Locking - Bài Tập

Thực hành quản lý concurrency & locking.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có database "ecommerce_practice" với sample data

---

## 🎯 Bài Tập 1: Simple Transaction (Dễ)

### Yêu Cầu
Tạo simple transaction với INSERT & COMMIT.

### Gợi Ý
- Sử dụng BEGIN
- Sử dụng INSERT
- Sử dụng COMMIT

### Solution
```sql
BEGIN;
INSERT INTO products (name, price) VALUES ('Product 1', 100);
COMMIT;
```

---

## 🎯 Bài Tập 2: Rollback Transaction (Dễ)

### Yêu Cầu
Tạo transaction & rollback.

### Gợi Ý
- Sử dụng BEGIN
- Sử dụng INSERT
- Sử dụng ROLLBACK

### Solution
```sql
BEGIN;
INSERT INTO products (name, price) VALUES ('Product 2', 200);
ROLLBACK;
```

---

## 🎯 Bài Tập 3: Savepoints (Dễ)

### Yêu Cầu
Sử dụng savepoints trong transaction.

### Gợi Ý
- Sử dụng BEGIN
- Sử dụng SAVEPOINT
- Sử dụng ROLLBACK TO

### Solution
```sql
BEGIN;
INSERT INTO products (name, price) VALUES ('Product 3', 300);
SAVEPOINT sp1;
INSERT INTO products (name, price) VALUES ('Product 4', 400);
ROLLBACK TO sp1;
COMMIT;
```

---

## 🎯 Bài Tập 4: READ COMMITTED (Trung Bình)

### Yêu Cầu
Set isolation level to READ COMMITTED.

### Gợi Ý
- Sử dụng SET TRANSACTION ISOLATION LEVEL
- Sử dụng READ COMMITTED

### Solution
```sql
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN;
SELECT * FROM products WHERE id = 1;
COMMIT;
```

---

## 🎯 Bài Tập 5: REPEATABLE READ (Trung Bình)

### Yêu Cầu
Set isolation level to REPEATABLE READ.

### Gợi Ý
- Sử dụng SET TRANSACTION ISOLATION LEVEL
- Sử dụng REPEATABLE READ

### Solution
```sql
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN;
SELECT * FROM products WHERE id = 1;
COMMIT;
```

---

## 🎯 Bài Tập 6: SERIALIZABLE (Trung Bình)

### Yêu Cầu
Set isolation level to SERIALIZABLE.

### Gợi Ý
- Sử dụng SET TRANSACTION ISOLATION LEVEL
- Sử dụng SERIALIZABLE

### Solution
```sql
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN;
SELECT * FROM products WHERE id = 1;
COMMIT;
```

---

## 🎯 Bài Tập 7: SELECT FOR UPDATE (Trung Bình)

### Yêu Cầu
Sử dụng SELECT FOR UPDATE để lock row.

### Gợi Ý
- Sử dụng BEGIN
- Sử dụng SELECT FOR UPDATE
- Sử dụng COMMIT

### Solution
```sql
BEGIN;
SELECT * FROM products WHERE id = 1 FOR UPDATE;
UPDATE products SET price = 150 WHERE id = 1;
COMMIT;
```

---

## 🎯 Bài Tập 8: SELECT FOR SHARE (Trung Bình)

### Yêu Cầu
Sử dụng SELECT FOR SHARE để shared lock.

### Gợi Ý
- Sử dụng BEGIN
- Sử dụng SELECT FOR SHARE
- Sử dụng COMMIT

### Solution
```sql
BEGIN;
SELECT * FROM products WHERE id = 1 FOR SHARE;
SELECT * FROM products WHERE id = 1;
COMMIT;
```

---

## 🎯 Bài Tập 9: Multiple Updates (Nâng Cao)

### Yêu Cầu
Update multiple rows dalam transaction.

### Gợi Ý
- Sử dụng BEGIN
- Sử dụng multiple UPDATE statements
- Sử dụng COMMIT

### Solution
```sql
BEGIN;
UPDATE products SET price = 100 WHERE id = 1;
UPDATE products SET price = 200 WHERE id = 2;
UPDATE products SET price = 300 WHERE id = 3;
COMMIT;
```

---

## 🎯 Bài Tập 10: Lock Ordering (Nâng Cao)

### Yêu Cầu
Implement lock ordering để prevent deadlocks.

### Gợi Ý
- Sử dụng BEGIN
- Update rows in consistent order
- Sử dụng COMMIT

### Solution
```sql
BEGIN;
UPDATE products SET price = 100 WHERE id = 1;
UPDATE products SET price = 200 WHERE id = 2;
UPDATE products SET price = 300 WHERE id = 3;
COMMIT;
```

---

## 🎯 Bài Tập 11: View Active Transactions (Nâng Cao)

### Yêu Cầu
View active transactions.

### Gợi Ý
- Sử dụng SELECT FROM pg_stat_activity
- Filter by state != 'idle'

### Solution
```sql
SELECT pid, usename, state, query
FROM pg_stat_activity
WHERE state != 'idle';
```

---

## 🎯 Bài Tập 12: View Locks (Nâng Cao)

### Yêu Cầu
View locks.

### Gợi Ý
- Sử dụng SELECT FROM pg_locks
- Join with pg_stat_activity

### Solution
```sql
SELECT l.pid, l.mode, l.granted, a.usename, a.query
FROM pg_locks l
JOIN pg_stat_activity a ON l.pid = a.pid
WHERE NOT l.granted;
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-3: Basic Transactions
- [ ] Bài 4-6: Isolation Levels
- [ ] Bài 7-8: Row-Level Locking
- [ ] Bài 9-12: Advanced Concurrency

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ Basic transactions
- ✅ Rollback & savepoints
- ✅ Isolation levels
- ✅ Row-level locking
- ✅ Multiple updates
- ✅ Lock ordering
- ✅ Transaction monitoring
- ✅ Lock monitoring

---

**Chúc mừng! Bạn đã hoàn thành Module 6 - Concurrency & Locking! 🎉**

