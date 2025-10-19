# 📚 Transactions & ACID - Lý Thuyết

Hiểu cách quản lý transactions & đảm bảo tính toàn vẹn dữ liệu.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu Transactions là gì
- ✅ Hiểu ACID properties
- ✅ Biết cách sử dụng BEGIN, COMMIT, ROLLBACK
- ✅ Hiểu Isolation Levels
- ✅ Biết cách xử lý lỗi trong transactions
- ✅ Hiểu Deadlocks & cách tránh

---

## 💳 Transactions - Giao Dịch

### Định Nghĩa

**Transaction** là một tập hợp SQL statements được thực thi như một đơn vị duy nhất (all or nothing).

### Tại Sao Transactions Quan Trọng?

1. **Tính toàn vẹn dữ liệu** - Đảm bảo dữ liệu nhất quán
2. **Atomicity** - Tất cả hoặc không gì cả
3. **Consistency** - Dữ liệu luôn hợp lệ
4. **Isolation** - Transactions độc lập
5. **Durability** - Dữ liệu lưu trữ vĩnh viễn

### Ví Dụ: Transfer Money

```
❌ Không có Transaction:
1. Trừ $100 từ Account A ✅
2. Hệ thống crash ❌
3. Thêm $100 vào Account B ❌
→ Mất $100!

✅ Có Transaction:
BEGIN
  1. Trừ $100 từ Account A
  2. Thêm $100 vào Account B
COMMIT
→ Tất cả hoặc không gì cả
```

---

## 🔄 ACID Properties

### A - Atomicity (Tính Nguyên Tử)

**Định nghĩa:** Transaction là một đơn vị không chia cắt (all or nothing).

**Ví dụ:**
```sql
BEGIN;
  UPDATE accounts SET balance = balance - 100 WHERE id = 1;
  UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;
-- Cả 2 UPDATE thành công hoặc cả 2 thất bại
```

### C - Consistency (Tính Nhất Quán)

**Định nghĩa:** Database chuyển từ trạng thái hợp lệ này sang trạng thái hợp lệ khác.

**Ví dụ:**
```sql
-- Constraint: balance >= 0
BEGIN;
  UPDATE accounts SET balance = balance - 1000 WHERE id = 1;
  -- Nếu balance < 1000, transaction rollback
COMMIT;
```

### I - Isolation (Tính Cô Lập)

**Định nghĩa:** Transactions không ảnh hưởng lẫn nhau.

**Ví dụ:**
```
Transaction 1:
  BEGIN;
  SELECT balance FROM accounts WHERE id = 1;  -- $1000
  
Transaction 2:
  BEGIN;
  UPDATE accounts SET balance = 500 WHERE id = 1;
  COMMIT;
  
Transaction 1:
  SELECT balance FROM accounts WHERE id = 1;  -- $1000 (isolated)
  COMMIT;
```

### D - Durability (Tính Bền Vững)

**Định nghĩa:** Dữ liệu được commit sẽ lưu trữ vĩnh viễn.

**Ví dụ:**
```sql
BEGIN;
  INSERT INTO orders VALUES (...);
COMMIT;
-- Dữ liệu được lưu trữ vĩnh viễn, ngay cả khi hệ thống crash
```

---

## 🔧 Transaction Control Statements

### BEGIN - Bắt Đầu Transaction

```sql
BEGIN;
-- Hoặc
START TRANSACTION;
```

### COMMIT - Xác Nhận Transaction

```sql
COMMIT;
-- Hoặc
END;
```

### ROLLBACK - Hủy Transaction

```sql
ROLLBACK;
-- Hoặc quay lại savepoint
ROLLBACK TO savepoint_name;
```

### SAVEPOINT - Điểm Lưu

```sql
SAVEPOINT savepoint_name;
-- Sau đó có thể ROLLBACK TO savepoint_name
```

---

## 📊 Ví Dụ Transactions

### Ví Dụ 1: Simple Transaction

```sql
BEGIN;
  INSERT INTO users (name, email) VALUES ('John', 'john@example.com');
  INSERT INTO users (name, email) VALUES ('Jane', 'jane@example.com');
COMMIT;
-- Cả 2 INSERT thành công
```

### Ví Dụ 2: Transaction Với ROLLBACK

```sql
BEGIN;
  INSERT INTO users (name, email) VALUES ('Bob', 'bob@example.com');
  -- Lỗi: email đã tồn tại
  INSERT INTO users (name, email) VALUES ('Alice', 'bob@example.com');
ROLLBACK;
-- Cả 2 INSERT bị hủy
```

### Ví Dụ 3: Transaction Với SAVEPOINT

```sql
BEGIN;
  INSERT INTO users (name, email) VALUES ('John', 'john@example.com');
  SAVEPOINT sp1;
  
  INSERT INTO users (name, email) VALUES ('Jane', 'jane@example.com');
  -- Lỗi
  ROLLBACK TO sp1;
  
  INSERT INTO users (name, email) VALUES ('Bob', 'bob@example.com');
COMMIT;
-- John & Bob được insert, Jane không
```

---

## 🔐 Isolation Levels

### 4 Isolation Levels

| Level | Dirty Read | Non-Repeatable Read | Phantom Read |
|-------|-----------|-------------------|--------------|
| **READ UNCOMMITTED** | ✅ | ✅ | ✅ |
| **READ COMMITTED** | ❌ | ✅ | ✅ |
| **REPEATABLE READ** | ❌ | ❌ | ✅ |
| **SERIALIZABLE** | ❌ | ❌ | ❌ |

### Cú Pháp

```sql
SET TRANSACTION ISOLATION LEVEL level_name;
```

### Ví Dụ

```sql
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
  SELECT * FROM accounts WHERE id = 1;
COMMIT;
```

---

## ⚠️ Concurrency Issues

### 1. Dirty Read

**Định nghĩa:** Đọc dữ liệu chưa được commit.

```
Transaction 1:
  BEGIN;
  UPDATE balance SET amount = 500 WHERE id = 1;
  
Transaction 2:
  SELECT amount FROM balance WHERE id = 1;  -- 500 (dirty read)
  
Transaction 1:
  ROLLBACK;  -- Dữ liệu quay lại 1000
```

### 2. Non-Repeatable Read

**Định nghĩa:** Đọc cùng dữ liệu 2 lần, kết quả khác nhau.

```
Transaction 1:
  SELECT amount FROM balance WHERE id = 1;  -- 1000
  
Transaction 2:
  UPDATE balance SET amount = 500 WHERE id = 1;
  COMMIT;
  
Transaction 1:
  SELECT amount FROM balance WHERE id = 1;  -- 500 (khác!)
```

### 3. Phantom Read

**Định nghĩa:** Số lượng rows thay đổi giữa 2 lần SELECT.

```
Transaction 1:
  SELECT COUNT(*) FROM users;  -- 10
  
Transaction 2:
  INSERT INTO users VALUES (...);
  COMMIT;
  
Transaction 1:
  SELECT COUNT(*) FROM users;  -- 11 (phantom!)
```

---

## 🔒 Deadlocks

### Định Nghĩa

**Deadlock** xảy ra khi 2 transactions chờ lẫn nhau.

### Ví Dụ

```
Transaction 1:
  BEGIN;
  UPDATE accounts SET balance = 500 WHERE id = 1;
  -- Chờ lock trên id = 2
  UPDATE accounts SET balance = 500 WHERE id = 2;
  
Transaction 2:
  BEGIN;
  UPDATE accounts SET balance = 500 WHERE id = 2;
  -- Chờ lock trên id = 1
  UPDATE accounts SET balance = 500 WHERE id = 1;
  
→ DEADLOCK!
```

### Cách Tránh Deadlocks

1. **Thứ tự consistent** - Luôn update theo thứ tự (id 1 → 2)
2. **Timeout** - Đặt timeout cho transactions
3. **Retry logic** - Thử lại nếu deadlock

---

## 📊 Tóm Tắt Transactions & ACID

| Khái Niệm | Mô Tả |
|-----------|-------|
| **Transaction** | Tập hợp SQL statements (all or nothing) |
| **Atomicity** | Tất cả hoặc không gì cả |
| **Consistency** | Dữ liệu luôn hợp lệ |
| **Isolation** | Transactions độc lập |
| **Durability** | Dữ liệu lưu trữ vĩnh viễn |
| **BEGIN** | Bắt đầu transaction |
| **COMMIT** | Xác nhận transaction |
| **ROLLBACK** | Hủy transaction |
| **SAVEPOINT** | Điểm lưu trong transaction |
| **Isolation Level** | Mức độ cô lập |
| **Deadlock** | 2 transactions chờ lẫn nhau |

---

## 🎓 Key Takeaways

1. **Transactions** - All or nothing
2. **ACID** - Atomicity, Consistency, Isolation, Durability
3. **BEGIN/COMMIT/ROLLBACK** - Kiểm soát transactions
4. **SAVEPOINT** - Điểm lưu trong transaction
5. **Isolation Levels** - Mức độ cô lập
6. **Deadlocks** - Tránh bằng thứ tự consistent

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL Transactions](https://www.postgresql.org/docs/current/tutorial-transactions.html)
- [PostgreSQL ACID](https://www.postgresql.org/docs/current/acid.html)
- [PostgreSQL Isolation Levels](https://www.postgresql.org/docs/current/transaction-iso.html)

---

**Bây giờ bạn đã hiểu Transactions & ACID! Hãy chuyển sang phần thực hành. 💪**

