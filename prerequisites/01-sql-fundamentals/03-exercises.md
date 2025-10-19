# 💪 SQL Fundamentals - Bài Tập

Thực hành viết SQL queries để giải quyết các bài toán thực tế.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có database "learning" với tables users và orders
- ✅ Có sample data trong tables

---

## 🎯 Bài Tập 1: SELECT Cơ Bản (Dễ)

### Yêu Cầu
Viết query để lấy tất cả thông tin của tất cả users.

### Gợi Ý
- Sử dụng SELECT *
- Sử dụng FROM users

### Solution
```sql
SELECT * FROM users;
```

---

## 🎯 Bài Tập 2: SELECT Columns Cụ Thể (Dễ)

### Yêu Cầu
Viết query để lấy chỉ name và email của tất cả users.

### Gợi Ý
- Chỉ lấy 2 columns: name, email
- Không lấy id, age, created_at

### Solution
```sql
SELECT name, email FROM users;
```

---

## 🎯 Bài Tập 3: WHERE Cơ Bản (Dễ)

### Yêu Cầu
Viết query để lấy thông tin của user có id = 3.

### Gợi Ý
- Sử dụng WHERE id = 3
- Kiểm tra kết quả có 1 row

### Solution
```sql
SELECT * FROM users WHERE id = 3;
```

---

## 🎯 Bài Tập 4: WHERE Với Số (Trung Bình)

### Yêu Cầu
Viết query để lấy tất cả users có age > 28.

### Gợi Ý
- Sử dụng WHERE age > 28
- Kết quả sẽ có nhiều rows

### Solution
```sql
SELECT * FROM users WHERE age > 28;
```

---

## 🎯 Bài Tập 5: WHERE Với Text (Trung Bình)

### Yêu Cầu
Viết query để lấy tất cả users có email chứa 'example.com'.

### Gợi Ý
- Sử dụng LIKE '%example.com%'
- Hoặc LIKE '%example%'

### Solution
```sql
SELECT * FROM users WHERE email LIKE '%example.com%';
```

---

## 🎯 Bài Tập 6: ORDER BY (Trung Bình)

### Yêu Cầu
Viết query để lấy tất cả users, sắp xếp theo age từ cao xuống thấp.

### Gợi Ý
- Sử dụng ORDER BY age DESC
- DESC = Descending (giảm dần)

### Solution
```sql
SELECT * FROM users ORDER BY age DESC;
```

---

## 🎯 Bài Tập 7: LIMIT (Trung Bình)

### Yêu Cầu
Viết query để lấy 3 orders đầu tiên.

### Gợi Ý
- Sử dụng LIMIT 3
- Kết quả sẽ có 3 rows

### Solution
```sql
SELECT * FROM orders LIMIT 3;
```

---

## 🎯 Bài Tập 8: ORDER BY + LIMIT (Trung Bình)

### Yêu Cầu
Viết query để lấy 3 orders có total_amount cao nhất.

### Gợi Ý
- Sử dụng ORDER BY total_amount DESC
- Sử dụng LIMIT 3
- Kết hợp cả hai

### Solution
```sql
SELECT * FROM orders 
ORDER BY total_amount DESC 
LIMIT 3;
```

---

## 🎯 Bài Tập 9: WHERE + AND (Nâng Cao)

### Yêu Cầu
Viết query để lấy tất cả users có age > 25 AND age < 35.

### Gợi Ý
- Sử dụng WHERE age > 25 AND age < 35
- Hoặc WHERE age BETWEEN 25 AND 35

### Solution
```sql
SELECT * FROM users WHERE age > 25 AND age < 35;

-- Hoặc
SELECT * FROM users WHERE age BETWEEN 26 AND 34;
```

---

## 🎯 Bài Tập 10: WHERE + OR (Nâng Cao)

### Yêu Cầu
Viết query để lấy tất cả orders của user 1 hoặc user 2.

### Gợi Ý
- Sử dụng WHERE user_id = 1 OR user_id = 2
- Hoặc WHERE user_id IN (1, 2)

### Solution
```sql
SELECT * FROM orders WHERE user_id = 1 OR user_id = 2;

-- Hoặc
SELECT * FROM orders WHERE user_id IN (1, 2);
```

---

## 🎯 Bài Tập 11: INSERT (Trung Bình)

### Yêu Cầu
Thêm một user mới với name = 'Grace Lee', email = 'grace@example.com', age = 27.

### Gợi Ý
- Sử dụng INSERT INTO users
- Chỉ định columns: name, email, age
- Sau đó SELECT để kiểm tra

### Solution
```sql
INSERT INTO users (name, email, age) 
VALUES ('Grace Lee', 'grace@example.com', 27);

-- Kiểm tra
SELECT * FROM users WHERE name = 'Grace Lee';
```

---

## 🎯 Bài Tập 12: UPDATE (Trung Bình)

### Yêu Cầu
Cập nhật age của user có id = 1 thành 29.

### Gợi Ý
- Sử dụng UPDATE users
- Sử dụng SET age = 29
- Sử dụng WHERE id = 1
- Sau đó SELECT để kiểm tra

### Solution
```sql
UPDATE users SET age = 29 WHERE id = 1;

-- Kiểm tra
SELECT * FROM users WHERE id = 1;
```

---

## 🎯 Bài Tập 13: DELETE (Trung Bình)

### Yêu Cầu
Xóa order có id = 5.

### Gợi Ý
- Sử dụng DELETE FROM orders
- Sử dụng WHERE id = 5
- Sau đó SELECT để kiểm tra

### Solution
```sql
DELETE FROM orders WHERE id = 5;

-- Kiểm tra
SELECT * FROM orders WHERE id = 5;
-- Kết quả sẽ trống (0 rows)
```

---

## 🎯 Bài Tập 14: Query Phức Tạp 1 (Nâng Cao)

### Yêu Cầu
Viết query để lấy tất cả orders của users có age > 30, sắp xếp theo total_amount giảm dần.

### Gợi Ý
- Cần kết hợp users và orders
- Sử dụng WHERE để filter age > 30
- Sử dụng ORDER BY total_amount DESC
- Có thể sử dụng JOIN (sẽ học sau) hoặc WHERE với điều kiện

### Solution
```sql
-- Cách 1: Sử dụng WHERE với điều kiện
SELECT o.* FROM orders o, users u 
WHERE o.user_id = u.id AND u.age > 30 
ORDER BY o.total_amount DESC;

-- Cách 2: Sử dụng JOIN (sẽ học sau)
SELECT o.* FROM orders o 
INNER JOIN users u ON o.user_id = u.id 
WHERE u.age > 30 
ORDER BY o.total_amount DESC;
```

---

## 🎯 Bài Tập 15: Query Phức Tạp 2 (Nâng Cao)

### Yêu Cầu
Viết query để lấy 5 users có age cao nhất, chỉ lấy name và age.

### Gợi Ý
- Sử dụng ORDER BY age DESC
- Sử dụng LIMIT 5
- Chỉ lấy columns name, age

### Solution
```sql
SELECT name, age FROM users 
ORDER BY age DESC 
LIMIT 5;
```

---

## 🎯 Bài Tập 16: Alias (Trung Bình)

### Yêu Cầu
Viết query để lấy name và email của users, nhưng đặt tên khác:
- name → "Tên Người Dùng"
- email → "Email Địa Chỉ"

### Gợi Ý
- Sử dụng AS để đặt alias
- Sử dụng dấu ngoặc kép cho tên có khoảng trắng

### Solution
```sql
SELECT name AS "Tên Người Dùng", email AS "Email Địa Chỉ" 
FROM users;
```

---

## 🎯 Bài Tập 17: LIKE Pattern (Trung Bình)

### Yêu Cầu
Viết query để lấy tất cả users có name bắt đầu bằng 'J'.

### Gợi Ý
- Sử dụng LIKE 'J%'
- % = bất kỳ ký tự nào

### Solution
```sql
SELECT * FROM users WHERE name LIKE 'J%';
```

---

## 🎯 Bài Tập 18: COUNT (Nâng Cao)

### Yêu Cầu
Viết query để đếm tổng số users.

### Gợi Ý
- Sử dụng COUNT(*)
- Hoặc COUNT(id)

### Solution
```sql
SELECT COUNT(*) FROM users;

-- Hoặc với alias
SELECT COUNT(*) AS "Tổng Users" FROM users;
```

---

## 🎯 Bài Tập 19: SUM (Nâng Cao)

### Yêu Cầu
Viết query để tính tổng total_amount của tất cả orders.

### Gợi Ý
- Sử dụng SUM(total_amount)

### Solution
```sql
SELECT SUM(total_amount) AS "Tổng Tiền" FROM orders;
```

---

## 🎯 Bài Tập 20: AVG (Nâng Cao)

### Yêu Cầu
Viết query để tính trung bình age của tất cả users.

### Gợi Ý
- Sử dụng AVG(age)

### Solution
```sql
SELECT AVG(age) AS "Trung Bình Tuổi" FROM users;
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-3: SELECT cơ bản
- [ ] Bài 4-7: WHERE, ORDER BY, LIMIT
- [ ] Bài 8-10: Kết hợp WHERE, AND, OR
- [ ] Bài 11-13: INSERT, UPDATE, DELETE
- [ ] Bài 14-15: Query phức tạp
- [ ] Bài 16-20: Alias, LIKE, COUNT, SUM, AVG

---

## 💡 Tips

1. **Chạy từng query một** - Không cần chạy tất cả cùng lúc
2. **Kiểm tra kết quả** - Xem output có đúng không
3. **Thử thay đổi** - Thay đổi WHERE, ORDER BY để hiểu sâu hơn
4. **Ghi chú** - Ghi lại những queries quan trọng

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ SELECT (tất cả columns, columns cụ thể, alias)
- ✅ WHERE (so sánh, LIKE, AND, OR)
- ✅ ORDER BY (ASC, DESC)
- ✅ LIMIT (basic, OFFSET)
- ✅ INSERT (thêm dữ liệu)
- ✅ UPDATE (cập nhật dữ liệu)
- ✅ DELETE (xóa dữ liệu)
- ✅ Aggregate functions (COUNT, SUM, AVG)

---

**Chúc mừng! Bạn đã hoàn thành Module 1 - SQL Fundamentals! 🎉**

Hãy chuyển sang Module 2 - Database Concepts để tiếp tục học!

