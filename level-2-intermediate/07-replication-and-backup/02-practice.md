# 🛠️ Replication & Backup - Thực Hành

Thực hành sử dụng backup & restore để bảo vệ dữ liệu.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Tạo được logical backups
- ✅ Sử dụng được pg_dump
- ✅ Sử dụng được pg_restore
- ✅ Restore databases
- ✅ Verify backups

---

## 📋 Bước 1: Chuẩn Bị

### Bước 1.1: Tạo Backup Directory

```bash
# Windows
mkdir C:\backups

# Linux/Mac
mkdir -p ~/backups
cd ~/backups
```

---

## 💾 Bước 2: Logical Backups

### Thực Hành 2.1: Backup Entire Database

```bash
# Backup entire database (SQL format)
pg_dump -U postgres -d ecommerce_practice > ecommerce_backup.sql

# Verify backup file
ls -lh ecommerce_backup.sql
```

### Thực Hành 2.2: Backup with Compression

```bash
# Backup with compression (custom format)
pg_dump -U postgres -d ecommerce_practice -Fc > ecommerce_backup.dump

# Verify backup file
ls -lh ecommerce_backup.dump
```

### Thực Hành 2.3: Backup Specific Table

```bash
# Backup specific table
pg_dump -U postgres -d ecommerce_practice -t products > products_backup.sql

# Backup multiple tables
pg_dump -U postgres -d ecommerce_practice -t products -t orders > products_orders_backup.sql
```

### Thực Hành 2.4: Backup Schema Only

```bash
# Backup schema only (no data)
pg_dump -U postgres -d ecommerce_practice -s > schema_only.sql

# Backup data only (no schema)
pg_dump -U postgres -d ecommerce_practice -a > data_only.sql
```

---

## 🔄 Bước 3: Restore Backups

### Thực Hành 3.1: Create Test Database

```sql
-- Kết nối PostgreSQL
psql -U postgres

-- Tạo test database
CREATE DATABASE ecommerce_test;

-- Thoát
\q
```

### Thực Hành 3.2: Restore from SQL Backup

```bash
# Restore from SQL backup
psql -U postgres -d ecommerce_test < ecommerce_backup.sql

# Verify restore
psql -U postgres -d ecommerce_test -c "SELECT COUNT(*) FROM products;"
```

### Thực Hành 3.3: Restore from Compressed Backup

```bash
# Restore from compressed backup
pg_restore -U postgres -d ecommerce_test ecommerce_backup.dump

# Verify restore
psql -U postgres -d ecommerce_test -c "SELECT COUNT(*) FROM orders;"
```

### Thực Hành 3.4: Restore Specific Table

```bash
# Restore specific table
pg_restore -U postgres -d ecommerce_test -t products products_backup.sql

# Verify restore
psql -U postgres -d ecommerce_test -c "SELECT COUNT(*) FROM products;"
```

---

## ✅ Bước 4: Verify Backups

### Thực Hành 4.1: Verify Backup File

```bash
# Verify backup file integrity
pg_dump -U postgres -d ecommerce_practice --verbose > /dev/null

# Check backup size
ls -lh ecommerce_backup.sql
```

### Thực Hành 4.2: Compare Databases

```sql
-- Kết nối original database
psql -U postgres -d ecommerce_practice

-- Count records
SELECT 'products' AS table_name, COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'users', COUNT(*) FROM users;

-- Kết nối test database
psql -U postgres -d ecommerce_test

-- Count records (should match)
SELECT 'products' AS table_name, COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'users', COUNT(*) FROM users;
```

---

## 📊 Bước 5: Backup Strategies

### Thực Hành 5.1: Full Backup Script

```bash
#!/bin/bash
# backup_full.sh

BACKUP_DIR="/backups"
DB_NAME="ecommerce_practice"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_full_${TIMESTAMP}.dump"

# Create backup
pg_dump -U postgres -d $DB_NAME -Fc > $BACKUP_FILE

# Compress backup
gzip $BACKUP_FILE

echo "Backup completed: ${BACKUP_FILE}.gz"
```

### Thực Hành 5.2: Incremental Backup Strategy

```bash
#!/bin/bash
# backup_incremental.sh

BACKUP_DIR="/backups"
DB_NAME="ecommerce_practice"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Full backup (weekly)
if [ $(date +%w) -eq 0 ]; then
  pg_dump -U postgres -d $DB_NAME -Fc > $BACKUP_DIR/${DB_NAME}_full_${TIMESTAMP}.dump
else
  # Incremental backup (daily)
  pg_dump -U postgres -d $DB_NAME -a > $BACKUP_DIR/${DB_NAME}_incremental_${TIMESTAMP}.sql
fi
```

---

## 🔐 Bước 6: Backup Best Practices

### Thực Hành 6.1: Backup with Verbose Output

```bash
# Backup with verbose output
pg_dump -U postgres -d ecommerce_practice -v > ecommerce_verbose.sql 2>&1

# Check output
tail -20 ecommerce_verbose.sql
```

### Thực Hành 6.2: Backup with Parallel Jobs

```bash
# Backup with parallel jobs (faster)
pg_dump -U postgres -d ecommerce_practice -j 4 -Fd -f backup_dir/

# Verify parallel backup
ls -la backup_dir/
```

---

## ✅ Checklist Thực Hành

- [ ] Tạo backup directory
- [ ] Backup entire database
- [ ] Backup with compression
- [ ] Backup specific tables
- [ ] Backup schema & data separately
- [ ] Create test database
- [ ] Restore from SQL backup
- [ ] Restore from compressed backup
- [ ] Verify backups
- [ ] Compare databases

---

## 💡 Tips

1. **Backup regularly** - Daily hoặc weekly
2. **Test restores** - Verify backups work
3. **Store offsite** - Protect against disasters
4. **Use compression** - Save storage space
5. **Document procedures** - For recovery

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

