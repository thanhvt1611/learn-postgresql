# 🛠️ Transactions & ACID - Thực Hành

Thực hành sử dụng transactions & hiểu ACID properties.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Sử dụng được BEGIN, COMMIT, ROLLBACK
- ✅ Hiểu được ACID properties
- ✅ Sử dụng được SAVEPOINT
- ✅ Hiểu Isolation Levels
- ✅ Xử lý được lỗi trong transactions

---

## 📋 Bước 1: Chuẩn Bị Database

### Bước 1.1: Tạo Bảng Test

```sql
-- Kết nối
psql -U postgres -d ecommerce_practice

-- Tạo bảng accounts để test
CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    balance DECIMAL(10, 2)
);

-- Thêm dữ liệu
INSERT INTO accounts (name, balance) VALUES ('Alice', 1000);
INSERT INTO accounts (name, balance) VALUES ('Bob', 500);

-- Kiểm tra
SELECT * FROM accounts;
```

---

## 💳 Bước 2: Thực Hành BEGIN & COMMIT

### Thực Hành 2.1: Simple Transaction

```sql
-- Bắt đầu transaction
BEGIN;

-- Thêm user mới
INSERT INTO users (name, email, age) VALUES ('Test User', 'test@example.com', 25);

-- Kiểm tra (chỉ trong transaction)
SELECT * FROM users WHERE email = 'test@example.com';

-- Xác nhận transaction
COMMIT;

-- Kiểm tra (sau commit)
SELECT * FROM users WHERE email = 'test@example.com';
```

### Thực Hành 2.2: Multiple Statements

```sql
BEGIN;
  INSERT INTO accounts (name, balance) VALUES ('Charlie', 2000);
  INSERT INTO accounts (name, balance) VALUES ('Diana', 1500);
  UPDATE accounts SET balance = balance + 100 WHERE name = 'Alice';
COMMIT;

-- Kiểm tra
SELECT * FROM accounts;
```

---

## 🔄 Bước 3: Thực Hành ROLLBACK

### Thực Hành 3.1: Rollback Toàn Bộ

```sql
-- Kiểm tra balance trước
SELECT * FROM accounts WHERE name = 'Alice';

BEGIN;
  UPDATE accounts SET balance = balance - 500 WHERE name = 'Alice';
  UPDATE accounts SET balance = balance + 500 WHERE name = 'Bob';
  
  -- Kiểm tra trong transaction
  SELECT * FROM accounts;
  
  -- Hủy transaction
  ROLLBACK;

-- Kiểm tra sau rollback (balance không thay đổi)
SELECT * FROM accounts WHERE name = 'Alice';
```

### Thực Hành 3.2: Rollback Khi Có Lỗi

```sql
BEGIN;
  INSERT INTO users (name, email, age) VALUES ('User1', 'user1@example.com', 25);
  -- Lỗi: email đã tồn tại
  INSERT INTO users (name, email, age) VALUES ('User2', 'user1@example.com', 30);
ROLLBACK;

-- Kiểm tra (cả 2 INSERT bị hủy)
SELECT * FROM users WHERE email = 'user1@example.com';
```

---

## 💾 Bước 4: Thực Hành SAVEPOINT

### Thực Hành 4.1: Savepoint Cơ Bản

```sql
BEGIN;
  INSERT INTO accounts (name, balance) VALUES ('Eve', 3000);
  SAVEPOINT sp1;
  
  INSERT INTO accounts (name, balance) VALUES ('Frank', 2500);
  SAVEPOINT sp2;
  
  INSERT INTO accounts (name, balance) VALUES ('Grace', 2000);
  
  -- Quay lại sp2 (Grace không được insert)
  ROLLBACK TO sp2;
  
COMMIT;

-- Kiểm tra (Eve & Frank được insert, Grace không)
SELECT * FROM accounts WHERE name IN ('Eve', 'Frank', 'Grace');
```

### Thực Hành 4.2: Multiple Savepoints

```sql
BEGIN;
  UPDATE accounts SET balance = 1000 WHERE name = 'Alice';
  SAVEPOINT sp1;
  
  UPDATE accounts SET balance = 500 WHERE name = 'Bob';
  SAVEPOINT sp2;
  
  UPDATE accounts SET balance = 2000 WHERE name = 'Charlie';
  
  -- Quay lại sp1 (Bob & Charlie không thay đổi)
  ROLLBACK TO sp1;
  
  UPDATE accounts SET balance = 600 WHERE name = 'Bob';
  
COMMIT;

-- Kiểm tra
SELECT * FROM accounts;
```

---

## 🔐 Bước 5: Thực Hành Isolation Levels

### Thực Hành 5.1: READ COMMITTED (Mặc Định)

```sql
-- Terminal 1
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT balance FROM accounts WHERE name = 'Alice';

-- Terminal 2
BEGIN;
UPDATE accounts SET balance = 2000 WHERE name = 'Alice';
COMMIT;

-- Terminal 1
SELECT balance FROM accounts WHERE name = 'Alice';  -- 2000 (thay đổi)
COMMIT;
```

### Thực Hành 5.2: REPEATABLE READ

```sql
-- Terminal 1
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT balance FROM accounts WHERE name = 'Alice';  -- 2000

-- Terminal 2
BEGIN;
UPDATE accounts SET balance = 3000 WHERE name = 'Alice';
COMMIT;

-- Terminal 1
SELECT balance FROM accounts WHERE name = 'Alice';  -- 2000 (không thay đổi)
COMMIT;
```

### Thực Hành 5.3: SERIALIZABLE

```sql
-- Terminal 1
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT COUNT(*) FROM accounts;

-- Terminal 2
BEGIN;
INSERT INTO accounts (name, balance) VALUES ('Henry', 1000);
COMMIT;

-- Terminal 1
SELECT COUNT(*) FROM accounts;  -- Không thay đổi
COMMIT;
```

---

## 💳 Bước 6: Thực Hành Transfer Money

### Thực Hành 6.1: Transfer Với Transaction

```sql
-- Kiểm tra balance trước
SELECT * FROM accounts WHERE name IN ('Alice', 'Bob');

BEGIN;
  -- Trừ từ Alice
  UPDATE accounts SET balance = balance - 100 WHERE name = 'Alice';
  
  -- Thêm vào Bob
  UPDATE accounts SET balance = balance + 100 WHERE name = 'Bob';
  
  -- Kiểm tra
  SELECT * FROM accounts WHERE name IN ('Alice', 'Bob');
  
COMMIT;

-- Kiểm tra sau commit
SELECT * FROM accounts WHERE name IN ('Alice', 'Bob');
```

### Thực Hành 6.2: Transfer Với Error Handling

```sql
BEGIN;
  UPDATE accounts SET balance = balance - 500 WHERE name = 'Alice';
  
  -- Kiểm tra balance (nếu < 0, rollback)
  IF (SELECT balance FROM accounts WHERE name = 'Alice') < 0 THEN
    ROLLBACK;
  ELSE
    UPDATE accounts SET balance = balance + 500 WHERE name = 'Bob';
    COMMIT;
  END IF;
```

---

## 🔒 Bước 7: Thực Hành Locks

### Thực Hành 7.1: Row-Level Lock

```sql
-- Terminal 1
BEGIN;
SELECT * FROM accounts WHERE name = 'Alice' FOR UPDATE;
-- Khóa row này

-- Terminal 2
BEGIN;
UPDATE accounts SET balance = 2000 WHERE name = 'Alice';
-- Chờ lock từ Terminal 1

-- Terminal 1
COMMIT;
-- Terminal 2 tiếp tục
```

### Thực Hành 7.2: Deadlock Detection

```sql
-- Terminal 1
BEGIN;
UPDATE accounts SET balance = 1000 WHERE name = 'Alice';
-- Chờ lock trên Bob
UPDATE accounts SET balance = 1000 WHERE name = 'Bob';

-- Terminal 2
BEGIN;
UPDATE accounts SET balance = 1000 WHERE name = 'Bob';
-- Chờ lock trên Alice
UPDATE accounts SET balance = 1000 WHERE name = 'Alice';

-- PostgreSQL sẽ detect deadlock & rollback một transaction
```

---

## ✅ Checklist Thực Hành

- [ ] Tạo bảng test
- [ ] Thực hành BEGIN & COMMIT
- [ ] Thực hành ROLLBACK
- [ ] Thực hành SAVEPOINT
- [ ] Thực hành Isolation Levels
- [ ] Thực hành Transfer Money
- [ ] Thực hành Locks
- [ ] Thực hành Deadlock Detection

---

## 💡 Tips

1. **Luôn sử dụng transactions** - Đảm bảo tính toàn vẹn dữ liệu
2. **Giữ transactions ngắn** - Giảm lock time
3. **Sử dụng SAVEPOINT** - Cho phép partial rollback
4. **Chọn Isolation Level** - Tùy theo yêu cầu
5. **Xử lý deadlocks** - Retry logic

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

