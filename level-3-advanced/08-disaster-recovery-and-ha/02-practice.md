# 🛠️ Disaster Recovery & HA - Thực Hành

Thực hành implement disaster recovery & high availability.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Tạo được backups
- ✅ Restore từ backups
- ✅ Implement PITR
- ✅ Setup replication
- ✅ Understand failover

---

## 📋 Bước 1: Chuẩn Bị Database

### Bước 1.1: Kết Nối Database

```sql
-- Kết nối
psql -U postgres -d ecommerce_practice

-- Kiểm tra database
\l
```

---

## 💾 Bước 2: Full Backup

### Thực Hành 2.1: Simple SQL Dump

```bash
-- Create backup directory
mkdir -p ~/backups

-- Full backup (SQL format)
pg_dump -U postgres -d ecommerce_practice > ~/backups/backup_full.sql

-- Verify backup
ls -lh ~/backups/backup_full.sql
```

### Thực Hành 2.2: Custom Format Backup

```bash
-- Full backup (custom format - compressed)
pg_dump -U postgres -d ecommerce_practice -Fc > ~/backups/backup_full.dump

-- Verify backup
ls -lh ~/backups/backup_full.dump
```

### Thực Hành 2.3: Parallel Backup

```bash
-- Parallel backup (faster)
pg_dump -U postgres -d ecommerce_practice -Fc -j 4 > ~/backups/backup_parallel.dump

-- Verify backup
ls -lh ~/backups/backup_parallel.dump
```

---

## 📊 Bước 3: Selective Backups

### Thực Hành 3.1: Schema-Only Backup

```bash
-- Schema-only backup
pg_dump -U postgres -d ecommerce_practice -s > ~/backups/backup_schema.sql

-- Verify
head -20 ~/backups/backup_schema.sql
```

### Thực Hành 3.2: Data-Only Backup

```bash
-- Data-only backup
pg_dump -U postgres -d ecommerce_practice -a > ~/backups/backup_data.sql

-- Verify
head -20 ~/backups/backup_data.sql
```

### Thực Hành 3.3: Specific Table Backup

```bash
-- Backup specific table
pg_dump -U postgres -d ecommerce_practice -t products > ~/backups/backup_products.sql

-- Verify
head -20 ~/backups/backup_products.sql
```

---

## 🔄 Bước 4: Restore from Backup

### Thực Hành 4.1: Restore SQL Dump

```bash
-- Create test database
psql -U postgres -c "CREATE DATABASE ecommerce_test;"

-- Restore from SQL dump
psql -U postgres -d ecommerce_test < ~/backups/backup_full.sql

-- Verify
psql -U postgres -d ecommerce_test -c "SELECT COUNT(*) FROM products;"
```

### Thực Hành 4.2: Restore Custom Format

```bash
-- Restore from custom format
pg_restore -U postgres -d ecommerce_test ~/backups/backup_full.dump

-- Verify
psql -U postgres -d ecommerce_test -c "SELECT COUNT(*) FROM products;"
```

### Thực Hành 4.3: Restore Specific Table

```bash
-- Restore specific table
pg_restore -U postgres -d ecommerce_test -t products ~/backups/backup_full.dump

-- Verify
psql -U postgres -d ecommerce_test -c "SELECT COUNT(*) FROM products;"
```

---

## ⏰ Bước 5: Point-in-Time Recovery

### Thực Hành 5.1: Enable WAL Archiving

```sql
-- In postgresql.conf
wal_level = replica
archive_mode = on
archive_command = 'cp %p /archive/%f'
archive_timeout = 300

-- Reload configuration
SELECT pg_reload_conf();
```

### Thực Hành 5.2: Create Base Backup

```bash
-- Create base backup
pg_basebackup -U postgres -D ~/backups/base_backup -Fp -Pv

-- Verify
ls -la ~/backups/base_backup/
```

---

## 🔁 Bước 6: Replication Setup

### Thực Hành 6.1: Create Replication User

```sql
-- Create replication user
CREATE USER replication WITH REPLICATION PASSWORD 'replication_password';

-- Verify
SELECT * FROM pg_user WHERE usename = 'replication';
```

### Thực Hành 6.2: Configure Primary

```sql
-- In postgresql.conf
wal_level = replica
max_wal_senders = 10
wal_keep_size = 1GB

-- Reload configuration
SELECT pg_reload_conf();
```

### Thực Hành 6.3: Monitor Replication

```sql
-- View replication slots
SELECT slot_name, restart_lsn, confirmed_flush_lsn
FROM pg_replication_slots;

-- View standby status
SELECT client_addr, state, sync_state
FROM pg_stat_replication;
```

---

## 🚀 Bước 7: Failover & Recovery

### Thực Hành 7.1: Check Replication Status

```sql
-- Check primary status
SELECT pg_current_wal_lsn();

-- Check standby lag
SELECT now() - pg_postmaster_start_time() AS uptime;
```

### Thực Hành 7.2: Promote Standby

```bash
-- Promote standby to primary (on standby server)
pg_ctl promote -D /var/lib/postgresql/data

-- Verify
psql -U postgres -c "SELECT pg_is_in_recovery();"
```

---

## ✅ Checklist Thực Hành

- [ ] Create full backups
- [ ] Create selective backups
- [ ] Restore from backups
- [ ] Enable WAL archiving
- [ ] Create base backups
- [ ] Setup replication
- [ ] Monitor replication
- [ ] Test failover

---

## 💡 Tips

1. **Regular backups** - Daily or more
2. **Test recovery** - Verify backups work
3. **Monitor replication** - Check lag
4. **Document procedures** - For emergencies
5. **Automate backups** - Use cron jobs

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

