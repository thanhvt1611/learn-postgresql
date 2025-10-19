# 💪 Disaster Recovery & HA - Bài Tập

Thực hành implement disaster recovery & high availability.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có database "ecommerce_practice" với sample data

---

## 🎯 Bài Tập 1: Create Full Backup (Dễ)

### Yêu Cầu
Create full backup in SQL format.

### Gợi Ý
- Sử dụng pg_dump
- Sử dụng -U postgres
- Sử dụng -d database_name

### Solution
```bash
pg_dump -U postgres -d ecommerce_practice > backup_full.sql
```

---

## 🎯 Bài Tập 2: Create Custom Format Backup (Dễ)

### Yêu Cầu
Create backup in custom format (compressed).

### Gợi Ý
- Sử dụng pg_dump
- Sử dụng -Fc flag

### Solution
```bash
pg_dump -U postgres -d ecommerce_practice -Fc > backup_full.dump
```

---

## 🎯 Bài Tập 3: Create Parallel Backup (Dễ)

### Yêu Cầu
Create parallel backup.

### Gợi Ý
- Sử dụng pg_dump
- Sử dụng -j flag

### Solution
```bash
pg_dump -U postgres -d ecommerce_practice -Fc -j 4 > backup_parallel.dump
```

---

## 🎯 Bài Tập 4: Create Schema-Only Backup (Trung Bình)

### Yêu Cầu
Create schema-only backup.

### Gợi Ý
- Sử dụng pg_dump
- Sử dụng -s flag

### Solution
```bash
pg_dump -U postgres -d ecommerce_practice -s > backup_schema.sql
```

---

## 🎯 Bài Tập 5: Create Data-Only Backup (Trung Bình)

### Yêu Cầu
Create data-only backup.

### Gợi Ý
- Sử dụng pg_dump
- Sử dụng -a flag

### Solution
```bash
pg_dump -U postgres -d ecommerce_practice -a > backup_data.sql
```

---

## 🎯 Bài Tập 6: Backup Specific Table (Trung Bình)

### Yêu Cầu
Backup specific table.

### Gợi Ý
- Sử dụng pg_dump
- Sử dụng -t flag

### Solution
```bash
pg_dump -U postgres -d ecommerce_practice -t products > backup_products.sql
```

---

## 🎯 Bài Tập 7: Restore from SQL Dump (Trung Bình)

### Yêu Cầu
Restore database from SQL dump.

### Gợi Ý
- Tạo test database
- Sử dụng psql
- Sử dụng < redirect

### Solution
```bash
psql -U postgres -c "CREATE DATABASE ecommerce_restore;"
psql -U postgres -d ecommerce_restore < backup_full.sql
```

---

## 🎯 Bài Tập 8: Restore from Custom Format (Nâng Cao)

### Yêu Cầu
Restore database from custom format backup.

### Gợi Ý
- Sử dụng pg_restore
- Sử dụng -d flag

### Solution
```bash
pg_restore -U postgres -d ecommerce_restore backup_full.dump
```

---

## 🎯 Bài Tập 9: Restore Specific Table (Nâng Cao)

### Yêu Cầu
Restore specific table from backup.

### Gợi Ý
- Sử dụng pg_restore
- Sử dụng -t flag

### Solution
```bash
pg_restore -U postgres -d ecommerce_restore -t products backup_full.dump
```

---

## 🎯 Bài Tập 10: Create Replication User (Nâng Cao)

### Yêu Cầu
Create replication user.

### Gợi Ý
- Sử dụng CREATE USER
- Sử dụng WITH REPLICATION

### Solution
```sql
CREATE USER replication WITH REPLICATION PASSWORD 'replication_password';
```

---

## 🎯 Bài Tập 11: Enable WAL Archiving (Nâng Cao)

### Yêu Cầu
Enable WAL archiving in postgresql.conf.

### Gợi Ý
- Set wal_level = replica
- Set archive_mode = on
- Set archive_command

### Solution
```sql
-- In postgresql.conf
wal_level = replica
archive_mode = on
archive_command = 'cp %p /archive/%f'

-- Reload
SELECT pg_reload_conf();
```

---

## 🎯 Bài Tập 12: Monitor Replication (Nâng Cao)

### Yêu Cầu
Monitor replication status.

### Gợi Ý
- Sử dụng pg_stat_replication
- Sử dụng SELECT

### Solution
```sql
SELECT client_addr, state, sync_state, write_lag, flush_lag, replay_lag
FROM pg_stat_replication;
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-3: Full Backups
- [ ] Bài 4-6: Selective Backups
- [ ] Bài 7-9: Restore Operations
- [ ] Bài 10-12: Replication & HA

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ Full backups
- ✅ Custom format backups
- ✅ Parallel backups
- ✅ Schema-only backups
- ✅ Data-only backups
- ✅ Table-specific backups
- ✅ Restore operations
- ✅ Replication setup

---

**Chúc mừng! Bạn đã hoàn thành Module 8 - Disaster Recovery & HA! 🎉**

