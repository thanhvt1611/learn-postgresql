# 💪 Transactions & ACID - Bài Tập

Thực hành sử dụng transactions & hiểu ACID properties.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có database "ecommerce_practice" với bảng accounts

---

## 🎯 Bài Tập 1: BEGIN & COMMIT (Dễ)

### Yêu Cầu
Viết transaction để:
1. Thêm 3 users mới
2. Commit transaction
3. Kiểm tra dữ liệu

### Gợi Ý
- Sử dụng BEGIN & COMMIT
- Sử dụng INSERT

### Solution
```sql
BEGIN;
  INSERT INTO users (name, email, age) VALUES ('User1', 'user1@example.com', 25);
  INSERT INTO users (name, email, age) VALUES ('User2', 'user2@example.com', 30);
  INSERT INTO users (name, email, age) VALUES ('User3', 'user3@example.com', 28);
COMMIT;

-- Kiểm tra
SELECT * FROM users WHERE email LIKE 'user%@example.com';
```

---

## 🎯 Bài Tập 2: ROLLBACK (Dễ)

### Yêu Cầu
Viết transaction để:
1. Thêm 2 users
2. Rollback transaction
3. Kiểm tra dữ liệu (không có users mới)

### Gợi Ý
- Sử dụng BEGIN & ROLLBACK
- Kiểm tra trước & sau

### Solution
```sql
-- Kiểm tra trước
SELECT COUNT(*) FROM users;

BEGIN;
  INSERT INTO users (name, email, age) VALUES ('RollbackUser1', 'rollback1@example.com', 25);
  INSERT INTO users (name, email, age) VALUES ('RollbackUser2', 'rollback2@example.com', 30);
ROLLBACK;

-- Kiểm tra sau (không có users mới)
SELECT COUNT(*) FROM users;
SELECT * FROM users WHERE email LIKE 'rollback%@example.com';
```

---

## 🎯 Bài Tập 3: SAVEPOINT (Trung Bình)

### Yêu Cầu
Viết transaction với SAVEPOINT:
1. Thêm User1
2. Tạo SAVEPOINT sp1
3. Thêm User2
4. Tạo SAVEPOINT sp2
5. Thêm User3
6. Rollback TO sp2
7. Commit

### Gợi Ý
- Sử dụng SAVEPOINT
- Sử dụng ROLLBACK TO

### Solution
```sql
BEGIN;
  INSERT INTO users (name, email, age) VALUES ('SP_User1', 'sp_user1@example.com', 25);
  SAVEPOINT sp1;
  
  INSERT INTO users (name, email, age) VALUES ('SP_User2', 'sp_user2@example.com', 30);
  SAVEPOINT sp2;
  
  INSERT INTO users (name, email, age) VALUES ('SP_User3', 'sp_user3@example.com', 28);
  
  ROLLBACK TO sp2;
COMMIT;

-- Kiểm tra (User1 & User2 được insert, User3 không)
SELECT * FROM users WHERE email LIKE 'sp_user%@example.com';
```

---

## 🎯 Bài Tập 4: Transfer Money (Trung Bình)

### Yêu Cầu
Viết transaction để transfer $100 từ Alice sang Bob:
1. Trừ $100 từ Alice
2. Thêm $100 vào Bob
3. Commit

### Gợi Ý
- Sử dụng UPDATE
- Kiểm tra balance trước & sau

### Solution
```sql
-- Kiểm tra trước
SELECT * FROM accounts WHERE name IN ('Alice', 'Bob');

BEGIN;
  UPDATE accounts SET balance = balance - 100 WHERE name = 'Alice';
  UPDATE accounts SET balance = balance + 100 WHERE name = 'Bob';
COMMIT;

-- Kiểm tra sau
SELECT * FROM accounts WHERE name IN ('Alice', 'Bob');
```

---

## 🎯 Bài Tập 5: Transfer Với Rollback (Trung Bình)

### Yêu Cầu
Viết transaction để transfer $1000 từ Alice sang Bob:
1. Trừ $1000 từ Alice
2. Kiểm tra balance (nếu < 0, rollback)
3. Nếu OK, thêm $1000 vào Bob & commit

### Gợi Ý
- Sử dụng BEGIN & ROLLBACK
- Kiểm tra balance

### Solution
```sql
-- Kiểm tra balance Alice
SELECT balance FROM accounts WHERE name = 'Alice';

BEGIN;
  UPDATE accounts SET balance = balance - 1000 WHERE name = 'Alice';
  
  -- Kiểm tra balance
  SELECT balance FROM accounts WHERE name = 'Alice';
  
  -- Nếu balance < 0, rollback
  -- Nếu OK, thêm vào Bob
  UPDATE accounts SET balance = balance + 1000 WHERE name = 'Bob';
COMMIT;

-- Kiểm tra
SELECT * FROM accounts WHERE name IN ('Alice', 'Bob');
```

---

## 🎯 Bài Tập 6: Multiple Transfers (Nâng Cao)

### Yêu Cầu
Viết transaction để:
1. Transfer $100 từ Alice → Bob
2. Transfer $50 từ Bob → Charlie
3. Transfer $75 từ Charlie → Alice
4. Commit

### Gợi Ý
- Sử dụng Multiple UPDATEs
- Kiểm tra balance trước & sau

### Solution
```sql
-- Kiểm tra trước
SELECT * FROM accounts WHERE name IN ('Alice', 'Bob', 'Charlie');

BEGIN;
  UPDATE accounts SET balance = balance - 100 WHERE name = 'Alice';
  UPDATE accounts SET balance = balance + 100 WHERE name = 'Bob';
  
  UPDATE accounts SET balance = balance - 50 WHERE name = 'Bob';
  UPDATE accounts SET balance = balance + 50 WHERE name = 'Charlie';
  
  UPDATE accounts SET balance = balance - 75 WHERE name = 'Charlie';
  UPDATE accounts SET balance = balance + 75 WHERE name = 'Alice';
COMMIT;

-- Kiểm tra sau
SELECT * FROM accounts WHERE name IN ('Alice', 'Bob', 'Charlie');
```

---

## 🎯 Bài Tập 7: Isolation Levels (Nâng Cao)

### Yêu Cầu
Thực hành 3 Isolation Levels:
1. READ COMMITTED
2. REPEATABLE READ
3. SERIALIZABLE

### Gợi Ý
- Sử dụng 2 terminals
- Sử dụng SET TRANSACTION ISOLATION LEVEL

### Solution
```sql
-- Terminal 1: READ COMMITTED
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT balance FROM accounts WHERE name = 'Alice';

-- Terminal 2: UPDATE
BEGIN;
UPDATE accounts SET balance = 5000 WHERE name = 'Alice';
COMMIT;

-- Terminal 1: SELECT lại
SELECT balance FROM accounts WHERE name = 'Alice';  -- 5000 (thay đổi)
COMMIT;
```

---

## 🎯 Bài Tập 8: Atomicity (Nâng Cao)

### Yêu Cầu
Chứng minh Atomicity:
1. Tạo transaction với 3 UPDATEs
2. Lỗi ở UPDATE thứ 2
3. Kiểm tra (tất cả 3 UPDATEs bị rollback)

### Gợi Ý
- Sử dụng BEGIN & ROLLBACK
- Tạo lỗi intentionally

### Solution
```sql
-- Kiểm tra trước
SELECT * FROM accounts;

BEGIN;
  UPDATE accounts SET balance = 1000 WHERE name = 'Alice';
  -- Lỗi: column không tồn tại
  UPDATE accounts SET invalid_column = 500 WHERE name = 'Bob';
  UPDATE accounts SET balance = 2000 WHERE name = 'Charlie';
ROLLBACK;

-- Kiểm tra (tất cả 3 UPDATEs bị rollback)
SELECT * FROM accounts;
```

---

## 🎯 Bài Tập 9: Consistency (Nâng Cao)

### Yêu Cầu
Chứng minh Consistency:
1. Tạo constraint: balance >= 0
2. Cố gắng transfer quá nhiều
3. Kiểm tra (transaction rollback)

### Gợi Ý
- Sử dụng CHECK constraint
- Sử dụng BEGIN & ROLLBACK

### Solution
```sql
-- Tạo constraint
ALTER TABLE accounts ADD CONSTRAINT check_balance CHECK (balance >= 0);

-- Kiểm tra balance Alice
SELECT balance FROM accounts WHERE name = 'Alice';

BEGIN;
  UPDATE accounts SET balance = balance - 10000 WHERE name = 'Alice';
COMMIT;
-- Lỗi: violates check constraint

-- Kiểm tra (balance không thay đổi)
SELECT balance FROM accounts WHERE name = 'Alice';
```

---

## 🎯 Bài Tập 10: Durability (Nâng Cao)

### Yêu Cầu
Chứng minh Durability:
1. Tạo transaction & commit
2. Kiểm tra dữ liệu
3. Dữ liệu vẫn tồn tại (ngay cả khi crash)

### Gợi Ý
- Sử dụng BEGIN & COMMIT
- Dữ liệu lưu trữ vĩnh viễn

### Solution
```sql
BEGIN;
  INSERT INTO accounts (name, balance) VALUES ('Durable', 9999);
COMMIT;

-- Kiểm tra
SELECT * FROM accounts WHERE name = 'Durable';
-- Dữ liệu vẫn tồn tại ngay cả khi hệ thống crash
```

---

## 🎯 Bài Tập 11: Nested Transactions (Nâng Cao)

### Yêu Cầu
Sử dụng nested transactions với SAVEPOINT:
1. Thêm 3 accounts
2. Tạo SAVEPOINT sau mỗi account
3. Rollback một số savepoints

### Gợi Ý
- Sử dụng Multiple SAVEPOINTs
- Sử dụng ROLLBACK TO

### Solution
```sql
BEGIN;
  INSERT INTO accounts (name, balance) VALUES ('Nested1', 1000);
  SAVEPOINT sp1;
  
  INSERT INTO accounts (name, balance) VALUES ('Nested2', 2000);
  SAVEPOINT sp2;
  
  INSERT INTO accounts (name, balance) VALUES ('Nested3', 3000);
  SAVEPOINT sp3;
  
  ROLLBACK TO sp2;
COMMIT;

-- Kiểm tra (Nested1 & Nested2 được insert, Nested3 không)
SELECT * FROM accounts WHERE name LIKE 'Nested%';
```

---

## 🎯 Bài Tập 12: Complex Transaction (Nâng Cao)

### Yêu Cầu
Viết complex transaction:
1. Tạo order mới
2. Thêm order items
3. Cập nhật product stock
4. Cập nhật user balance
5. Commit hoặc rollback

### Gợi Ý
- Sử dụng Multiple UPDATEs & INSERTs
- Sử dụng SAVEPOINT

### Solution
```sql
BEGIN;
  -- Tạo order
  INSERT INTO orders (user_id, total_amount, status) 
  VALUES (1, 99.99, 'pending');
  
  -- Thêm order item
  INSERT INTO order_items (order_id, product_id, quantity, unit_price)
  VALUES (LASTVAL(), 1, 1, 99.99);
  
  -- Cập nhật stock
  UPDATE products SET stock = stock - 1 WHERE id = 1;
  
COMMIT;

-- Kiểm tra
SELECT * FROM orders WHERE user_id = 1;
SELECT * FROM order_items WHERE order_id = LASTVAL();
SELECT stock FROM products WHERE id = 1;
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-2: BEGIN, COMMIT, ROLLBACK
- [ ] Bài 3: SAVEPOINT
- [ ] Bài 4-6: Transfer Money
- [ ] Bài 7: Isolation Levels
- [ ] Bài 8-10: ACID Properties
- [ ] Bài 11-12: Complex Transactions

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ BEGIN, COMMIT, ROLLBACK
- ✅ SAVEPOINT
- ✅ Transfer Money
- ✅ Isolation Levels
- ✅ ACID Properties
- ✅ Complex Transactions

---

**Chúc mừng! Bạn đã hoàn thành Module 5 - Transactions & ACID! 🎉**

