# 📚 Disaster Recovery & HA - Lý Thuyết

Hiểu cách implement disaster recovery & high availability.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu Backup strategies
- ✅ Biết cách sử dụng pg_dump & pg_restore
- ✅ Hiểu Point-in-Time Recovery (PITR)
- ✅ Biết cách setup Replication
- ✅ Hiểu High Availability
- ✅ Hiểu DR & HA best practices

---

## 💾 Backup Strategies

### Định Nghĩa

**Backup** - Copy of database để recovery.

### Tại Sao Quan Trọng?

1. **Data Protection** - Prevent data loss
2. **Disaster Recovery** - Recover from failures
3. **Compliance** - Meet requirements
4. **Peace of Mind** - Know data is safe

---

## 🔄 Backup Types

### Full Backup

```sql
-- Full backup
pg_dump -U postgres -d ecommerce_practice > backup_full.sql

-- Full backup (custom format)
pg_dump -U postgres -d ecommerce_practice -Fc > backup_full.dump
```

### Incremental Backup

```sql
-- Incremental backup (using WAL)
-- Requires WAL archiving enabled
```

### Schema-Only Backup

```sql
-- Schema-only backup
pg_dump -U postgres -d ecommerce_practice -s > backup_schema.sql
```

### Data-Only Backup

```sql
-- Data-only backup
pg_dump -U postgres -d ecommerce_practice -a > backup_data.sql
```

---

## 🔧 pg_dump & pg_restore

### pg_dump

```sql
-- Simple dump
pg_dump -U postgres -d ecommerce_practice > backup.sql

-- Custom format (compressed)
pg_dump -U postgres -d ecommerce_practice -Fc > backup.dump

-- Parallel dump
pg_dump -U postgres -d ecommerce_practice -Fc -j 4 > backup.dump
```

### pg_restore

```sql
-- Restore from custom format
pg_restore -U postgres -d ecommerce_practice backup.dump

-- Restore specific table
pg_restore -U postgres -d ecommerce_practice -t products backup.dump

-- Restore with verbose output
pg_restore -U postgres -d ecommerce_practice -v backup.dump
```

---

## ⏰ Point-in-Time Recovery (PITR)

### Định Nghĩa

**PITR** - Recover database to specific point in time.

### Requirements

1. **Base backup** - Full backup
2. **WAL files** - Write-ahead logs
3. **recovery.conf** - Recovery configuration

### Ví Dụ

```sql
-- Enable WAL archiving in postgresql.conf
wal_level = replica
archive_mode = on
archive_command = 'cp %p /archive/%f'

-- Create base backup
pg_basebackup -U postgres -D /backup/base -Fp -Pv

-- Recover to specific time
-- Edit recovery.conf with recovery_target_time
```

---

## 🔁 Replication

### Streaming Replication

```sql
-- Primary server configuration
wal_level = replica
max_wal_senders = 10
wal_keep_size = 1GB

-- Create replication user
CREATE USER replication WITH REPLICATION PASSWORD 'password';

-- Standby server configuration
standby_mode = 'on'
primary_conninfo = 'host=primary_server user=replication password=password'
```

### Logical Replication

```sql
-- Create publication
CREATE PUBLICATION pub_all FOR ALL TABLES;

-- Create subscription
CREATE SUBSCRIPTION sub_all CONNECTION 'dbname=ecommerce_practice host=primary_server' PUBLICATION pub_all;
```

---

## 🚀 High Availability (HA)

### Failover

```sql
-- Promote standby to primary
pg_ctl promote -D /var/lib/postgresql/data
```

### Load Balancing

```sql
-- Use connection pooler (pgBouncer)
-- Configure multiple replicas
-- Route read queries to replicas
```

### Monitoring

```sql
-- Monitor replication lag
SELECT slot_name, restart_lsn, confirmed_flush_lsn
FROM pg_replication_slots;

-- Monitor standby status
SELECT client_addr, state, sync_state
FROM pg_stat_replication;
```

---

## 📊 Tóm Tắt DR & HA

| Khái Niệm | Mô Tả | Khi Dùng |
|-----------|-------|---------|
| **Full Backup** | Complete copy | Regular |
| **Incremental** | Changes only | Frequent |
| **Schema-Only** | Structure only | Development |
| **Data-Only** | Data only | Migration |
| **pg_dump** | Logical backup | Portable |
| **pg_restore** | Restore backup | Recovery |
| **PITR** | Point-in-time | Precise recovery |
| **Replication** | Real-time copy | HA |
| **Failover** | Switch to standby | Disaster |

---

## 🎓 Key Takeaways

1. **Backup Strategy** - Regular backups
2. **Backup Types** - Full, incremental, schema, data
3. **pg_dump/pg_restore** - Backup & restore
4. **PITR** - Point-in-time recovery
5. **Replication** - Real-time copy
6. **Failover** - Automatic switch
7. **Best Practices** - Test recovery regularly

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL Backup](https://www.postgresql.org/docs/current/backup.html)
- [PostgreSQL pg_dump](https://www.postgresql.org/docs/current/app-pgdump.html)
- [PostgreSQL Replication](https://www.postgresql.org/docs/current/warm-standby.html)
- [PostgreSQL HA](https://www.postgresql.org/docs/current/high-availability.html)

---

**Bây giờ bạn đã hiểu Disaster Recovery & HA! Hãy chuyển sang phần thực hành. 💪**

