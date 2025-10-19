# 📚 Replication & Backup - Lý Thuyết

Hiểu cách sử dụng replication & backup để bảo vệ dữ liệu.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu Replication là gì
- ✅ Biết các loại Replication
- ✅ Hiểu Streaming Replication
- ✅ Biết cách tạo Backups
- ✅ Sử dụng được pg_dump & pg_restore
- ✅ Hiểu Backup & Recovery best practices

---

## 🔄 Replication

### Định Nghĩa

**Replication** là sao chép dữ liệu từ primary server sang replica servers.

### Tại Sao Quan Trọng?

1. **High Availability** - Failover support
2. **Load Balancing** - Distribute reads
3. **Disaster Recovery** - Data protection
4. **Scalability** - Multiple replicas

---

## 📊 Loại Replication

### 1. Streaming Replication

**Định nghĩa:** Real-time replication từ primary sang replica.

**Ưu Điểm:**
- Real-time synchronization
- Low latency
- Automatic failover

**Ví Dụ:**
```sql
-- Primary server config (postgresql.conf)
wal_level = replica
max_wal_senders = 10
wal_keep_size = 1GB

-- Replica server config
primary_conninfo = 'host=primary_server user=replication password=xxx'
```

### 2. Logical Replication

**Định nghĩa:** Replication dựa trên logical changes.

**Ưu Điểm:**
- Selective replication
- Cross-version compatibility
- Flexible filtering

### 3. File-based Replication

**Định nghĩa:** Replication dựa trên WAL files.

**Ưu Điểm:**
- Simple setup
- Asynchronous
- Good for backups

---

## 💾 Backup Types

### 1. Logical Backup

**Định nghĩa:** Backup dữ liệu dưới dạng SQL commands.

**Công Cụ:** pg_dump

**Ưu Điểm:**
- Portable
- Human-readable
- Selective backup

**Ví Dụ:**
```sql
-- Backup database
pg_dump -U postgres -d ecommerce_practice > backup.sql

-- Backup specific table
pg_dump -U postgres -d ecommerce_practice -t products > products.sql
```

### 2. Physical Backup

**Định nghĩa:** Backup toàn bộ data directory.

**Công Cụ:** pg_basebackup

**Ưu Điểm:**
- Fast restore
- Complete backup
- Point-in-time recovery

**Ví Dụ:**
```bash
# Backup database cluster
pg_basebackup -h localhost -U postgres -D /backup/pg_backup -Ft -z -P
```

### 3. Incremental Backup

**Định nghĩa:** Backup chỉ changes từ lần backup trước.

**Ưu Điểm:**
- Efficient storage
- Fast backup
- Reduced bandwidth

---

## 🔧 pg_dump & pg_restore

### pg_dump

```bash
# Backup database
pg_dump -U postgres -d ecommerce_practice > backup.sql

# Backup with compression
pg_dump -U postgres -d ecommerce_practice -Fc > backup.dump

# Backup specific table
pg_dump -U postgres -d ecommerce_practice -t products > products.sql

# Backup with data only
pg_dump -U postgres -d ecommerce_practice -a > data.sql

# Backup with schema only
pg_dump -U postgres -d ecommerce_practice -s > schema.sql
```

### pg_restore

```bash
# Restore database
psql -U postgres -d ecommerce_practice < backup.sql

# Restore from compressed backup
pg_restore -U postgres -d ecommerce_practice backup.dump

# Restore specific table
pg_restore -U postgres -d ecommerce_practice -t products backup.dump
```

---

## 📋 Recovery Strategies

### 1. Point-in-Time Recovery (PITR)

**Định nghĩa:** Restore database đến một thời điểm cụ thể.

**Cách Thực Hiện:**
1. Tạo base backup
2. Archive WAL files
3. Restore base backup
4. Replay WAL files đến thời điểm mong muốn

### 2. Failover

**Định nghĩa:** Switch từ primary sang replica.

**Cách Thực Hiện:**
1. Promote replica thành primary
2. Update connection strings
3. Verify data consistency

### 3. Backup Verification

**Định nghĩa:** Kiểm tra backup có thể restore được.

**Cách Thực Hiện:**
```bash
# Verify backup
pg_dump -U postgres -d ecommerce_practice --verbose > /dev/null

# Test restore
pg_restore -U postgres -d test_db backup.dump --verbose
```

---

## 📊 Tóm Tắt Replication & Backup

| Khái Niệm | Mô Tả | Khi Dùng |
|-----------|-------|---------|
| **Streaming Replication** | Real-time replication | HA |
| **Logical Replication** | Selective replication | Flexible |
| **Logical Backup** | SQL commands | Portable |
| **Physical Backup** | Data directory | Fast |
| **pg_dump** | Backup tool | Logical |
| **pg_restore** | Restore tool | Logical |
| **PITR** | Point-in-time recovery | Disaster |

---

## 🎓 Key Takeaways

1. **Replication** - Sao chép dữ liệu
2. **Streaming Replication** - Real-time
3. **Logical Replication** - Selective
4. **Logical Backup** - SQL commands
5. **Physical Backup** - Data directory
6. **pg_dump & pg_restore** - Backup tools
7. **PITR** - Point-in-time recovery

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL Replication](https://www.postgresql.org/docs/current/warm-standby.html)
- [PostgreSQL Backup & Restore](https://www.postgresql.org/docs/current/backup.html)
- [PostgreSQL pg_dump](https://www.postgresql.org/docs/current/app-pgdump.html)

---

**Bây giờ bạn đã hiểu Replication & Backup! Hãy chuyển sang phần thực hành. 💪**

