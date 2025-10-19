# 💪 Replication & Backup - Bài Tập

Thực hành sử dụng backup & restore để bảo vệ dữ liệu.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có backup files

---

## 🎯 Bài Tập 1: Backup Entire Database (Dễ)

### Yêu Cầu
Backup toàn bộ ecommerce_practice database.

### Gợi Ý
- Sử dụng pg_dump
- Sử dụng -U postgres -d ecommerce_practice

### Solution
```bash
pg_dump -U postgres -d ecommerce_practice > ecommerce_backup.sql
```

---

## 🎯 Bài Tập 2: Backup with Compression (Dễ)

### Yêu Cầu
Backup database với compression.

### Gợi Ý
- Sử dụng pg_dump
- Sử dụng -Fc option

### Solution
```bash
pg_dump -U postgres -d ecommerce_practice -Fc > ecommerce_backup.dump
```

---

## 🎯 Bài Tập 3: Backup Specific Table (Dễ)

### Yêu Cầu
Backup chỉ products table.

### Gợi Ý
- Sử dụng pg_dump
- Sử dụng -t products

### Solution
```bash
pg_dump -U postgres -d ecommerce_practice -t products > products_backup.sql
```

---

## 🎯 Bài Tập 4: Backup Multiple Tables (Trung Bình)

### Yêu Cầu
Backup products & orders tables.

### Gợi Ý
- Sử dụng pg_dump
- Sử dụng -t option twice

### Solution
```bash
pg_dump -U postgres -d ecommerce_practice -t products -t orders > products_orders_backup.sql
```

---

## 🎯 Bài Tập 5: Backup Schema Only (Trung Bình)

### Yêu Cầu
Backup chỉ schema (không có data).

### Gợi Ý
- Sử dụng pg_dump
- Sử dụng -s option

### Solution
```bash
pg_dump -U postgres -d ecommerce_practice -s > schema_only.sql
```

---

## 🎯 Bài Tập 6: Backup Data Only (Trung Bình)

### Yêu Cầu
Backup chỉ data (không có schema).

### Gợi Ý
- Sử dụng pg_dump
- Sử dụng -a option

### Solution
```bash
pg_dump -U postgres -d ecommerce_practice -a > data_only.sql
```

---

## 🎯 Bài Tập 7: Create Test Database (Trung Bình)

### Yêu Cầu
Tạo test database để restore.

### Gợi Ý
- Sử dụng psql
- Sử dụng CREATE DATABASE

### Solution
```sql
psql -U postgres -c "CREATE DATABASE ecommerce_test;"
```

---

## 🎯 Bài Tập 8: Restore from SQL Backup (Trung Bình)

### Yêu Cầu
Restore database từ SQL backup.

### Gợi Ý
- Sử dụng psql
- Sử dụng < redirect

### Solution
```bash
psql -U postgres -d ecommerce_test < ecommerce_backup.sql
```

---

## 🎯 Bài Tập 9: Restore from Compressed Backup (Nâng Cao)

### Yêu Cầu
Restore database từ compressed backup.

### Gợi Ý
- Sử dụng pg_restore
- Sử dụng -d option

### Solution
```bash
pg_restore -U postgres -d ecommerce_test ecommerce_backup.dump
```

---

## 🎯 Bài Tập 10: Restore Specific Table (Nâng Cao)

### Yêu Cầu
Restore chỉ products table.

### Gợi Ý
- Sử dụng pg_restore
- Sử dụng -t products

### Solution
```bash
pg_restore -U postgres -d ecommerce_test -t products products_backup.sql
```

---

## 🎯 Bài Tập 11: Verify Backup (Nâng Cao)

### Yêu Cầu
Verify backup file integrity.

### Gợi Ý
- Sử dụng pg_dump
- Sử dụng --verbose

### Solution
```bash
pg_dump -U postgres -d ecommerce_practice --verbose > /dev/null
```

---

## 🎯 Bài Tập 12: Compare Databases (Nâng Cao)

### Yêu Cầu
So sánh record count giữa original & restored databases.

### Gợi Ý
- Sử dụng psql
- Sử dụng COUNT(*)

### Solution
```sql
-- Original database
psql -U postgres -d ecommerce_practice -c "SELECT 'products' AS table_name, COUNT(*) FROM products UNION ALL SELECT 'orders', COUNT(*) FROM orders UNION ALL SELECT 'users', COUNT(*) FROM users;"

-- Restored database
psql -U postgres -d ecommerce_test -c "SELECT 'products' AS table_name, COUNT(*) FROM products UNION ALL SELECT 'orders', COUNT(*) FROM orders UNION ALL SELECT 'users', COUNT(*) FROM users;"
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-2: Backup entire database
- [ ] Bài 3-6: Backup specific tables & schemas
- [ ] Bài 7-10: Restore backups
- [ ] Bài 11-12: Verify & compare

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ Backup entire database
- ✅ Backup with compression
- ✅ Backup specific tables
- ✅ Backup schema & data separately
- ✅ Create test database
- ✅ Restore from SQL backup
- ✅ Restore from compressed backup
- ✅ Restore specific tables
- ✅ Verify backups
- ✅ Compare databases

---

**Chúc mừng! Bạn đã hoàn thành Module 7 - Replication & Backup! 🎉**

