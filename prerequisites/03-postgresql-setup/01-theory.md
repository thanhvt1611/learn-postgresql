# 📚 PostgreSQL Setup - Lý Thuyết

Hiểu PostgreSQL architecture, installation, và cách kết nối đến database.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu PostgreSQL là gì và tại sao nó quan trọng
- ✅ Biết cách cài đặt PostgreSQL trên các OS khác nhau
- ✅ Hiểu PostgreSQL architecture (server, client, connections)
- ✅ Biết cách sử dụng psql command-line tool
- ✅ Biết cách sử dụng pgAdmin GUI tool
- ✅ Hiểu cách kết nối đến PostgreSQL database

---

## 🐘 PostgreSQL Là Gì?

### Định Nghĩa

**PostgreSQL** (hay Postgres) là:
- ✅ **Open-source** - Miễn phí, mã nguồn mở
- ✅ **Relational Database** - Lưu trữ dữ liệu trong tables
- ✅ **ACID Compliant** - Đảm bảo data integrity
- ✅ **Powerful** - Hỗ trợ advanced features (JSON, Full-text search, etc.)
- ✅ **Scalable** - Có thể xử lý dữ liệu lớn
- ✅ **Cross-platform** - Chạy trên Windows, macOS, Linux

### Tại Sao PostgreSQL Quan Trọng?

1. **Phổ biến** - Được sử dụng bởi nhiều công ty lớn
2. **Mạnh mẽ** - Hỗ trợ advanced SQL features
3. **Đáng tin cậy** - ACID compliance, data integrity
4. **Linh hoạt** - Hỗ trợ nhiều data types & extensions
5. **Miễn phí** - Không cần license

### PostgreSQL vs Competitors

| Feature | PostgreSQL | MySQL | SQL Server |
|---------|-----------|-------|-----------|
| **Open Source** | ✅ | ✅ | ❌ |
| **ACID** | ✅ | ⚠️ | ✅ |
| **Advanced SQL** | ✅ | ⚠️ | ✅ |
| **JSON Support** | ✅ | ✅ | ✅ |
| **Cost** | Free | Free | Paid |

---

## 🏗️ PostgreSQL Architecture

### Client-Server Model

```
┌─────────────────────────────────────────────────────────┐
│                    PostgreSQL Server                     │
│  ┌──────────────────────────────────────────────────┐   │
│  │         PostgreSQL Database Cluster              │   │
│  │  ┌────────────────────────────────────────────┐  │   │
│  │  │  Database 1 (learning)                     │  │   │
│  │  │  ├── Schema (public)                       │  │   │
│  │  │  │   ├── Table (users)                     │  │   │
│  │  │  │   └── Table (orders)                    │  │   │
│  │  │  └── Schema (archive)                      │  │   │
│  │  │                                            │  │   │
│  │  │  Database 2 (production)                   │  │   │
│  │  │  ├── Schema (public)                       │  │   │
│  │  │  └── ...                                   │  │   │
│  │  └────────────────────────────────────────────┘  │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
         ↑                    ↑                    ↑
    Client 1             Client 2             Client 3
   (psql)              (pgAdmin)            (Application)
```

### Các Thành Phần Chính

| Thành Phần | Mô Tả |
|-----------|-------|
| **PostgreSQL Server** | Process chính quản lý database |
| **Database Cluster** | Tập hợp các databases |
| **Database** | Tập hợp các schemas & tables |
| **Schema** | Tập hợp các tables & objects |
| **Table** | Tập hợp các rows & columns |
| **Client** | Ứng dụng kết nối đến server |

---

## 🔌 Connection & Authentication

### Connection Parameters

Để kết nối đến PostgreSQL, cần các thông tin:

| Parameter | Mô Tả | Ví Dụ |
|-----------|-------|-------|
| **Host** | Địa chỉ server | localhost, 192.168.1.1 |
| **Port** | Cổng kết nối | 5432 (mặc định) |
| **Database** | Tên database | learning, postgres |
| **User** | Tên user | postgres, app_user |
| **Password** | Mật khẩu | (được đặt lúc installation) |

### Connection String

```
postgresql://user:password@host:port/database

Ví dụ:
postgresql://postgres:mypassword@localhost:5432/learning
```

### Authentication Methods

| Method | Mô Tả | Bảo Mật |
|--------|-------|---------|
| **Trust** | Không cần password | ❌ Thấp |
| **Password** | Cần password | ⚠️ Trung bình |
| **MD5** | Password được hash | ✅ Tốt |
| **SCRAM-SHA-256** | Password được hash mạnh | ✅ Rất tốt |

---

## 🛠️ Installation Overview

### Windows Installation

**Bước chính:**
1. Tải PostgreSQL installer từ postgresql.org
2. Chạy installer
3. Chọn components (Server, pgAdmin, CLI tools)
4. Đặt password cho user "postgres"
5. Chọn port (mặc định: 5432)
6. Hoàn thành installation

**Kết quả:**
- PostgreSQL Server chạy như Windows Service
- pgAdmin 4 được cài sẵn
- psql CLI tool có sẵn

### macOS Installation

**Bước chính (sử dụng Homebrew):**
1. Cài đặt Homebrew
2. Chạy: `brew install postgresql@15`
3. Khởi động: `brew services start postgresql@15`
4. Kết nối: `psql postgres`

**Hoặc sử dụng Installer:**
1. Tải PostgreSQL installer từ postgresql.org
2. Chạy installer
3. Làm theo hướng dẫn

### Linux Installation

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
```

**CentOS/RHEL:**
```bash
sudo yum install postgresql-server postgresql-contrib
sudo /usr/pgsql-15/bin/postgresql-15-setup initdb
sudo systemctl start postgresql-15
```

---

## 💻 psql - Command Line Tool

### Định Nghĩa

**psql** là command-line interface để kết nối & tương tác với PostgreSQL.

### Cú Pháp Cơ Bản

```bash
psql -U username -d database -h host -p port
```

### Ví Dụ

```bash
# Kết nối đến default database
psql -U postgres

# Kết nối đến database cụ thể
psql -U postgres -d learning

# Kết nối đến server khác
psql -U postgres -h 192.168.1.1 -p 5432 -d learning
```

### psql Commands

| Command | Mô Tả |
|---------|-------|
| `\l` | Liệt kê tất cả databases |
| `\c database_name` | Kết nối đến database |
| `\dt` | Liệt kê tất cả tables |
| `\d table_name` | Xem chi tiết table |
| `\du` | Liệt kê tất cả users/roles |
| `\dn` | Liệt kê tất cả schemas |
| `\df` | Liệt kê tất cả functions |
| `\q` | Thoát psql |
| `\h` | Hiển thị help |
| `\?` | Hiển thị psql commands |

### Ví Dụ psql Commands

```sql
-- Liệt kê databases
\l

-- Kết nối đến database learning
\c learning

-- Liệt kê tables
\dt

-- Xem chi tiết table users
\d users

-- Liệt kê users
\du

-- Thoát
\q
```

---

## 🖥️ pgAdmin - GUI Tool

### Định Nghĩa

**pgAdmin** là web-based GUI tool để quản lý PostgreSQL databases.

### Truy Cập pgAdmin

```
URL: http://localhost:5050
```

### Các Tính Năng Chính

| Tính Năng | Mô Tả |
|-----------|-------|
| **Server Management** | Quản lý PostgreSQL servers |
| **Database Management** | Tạo, xóa, sửa databases |
| **Table Management** | Tạo, xóa, sửa tables |
| **Query Tool** | Viết & chạy SQL queries |
| **Data Viewer** | Xem & edit dữ liệu |
| **Backup/Restore** | Backup & restore databases |
| **Monitoring** | Theo dõi server activity |

### Workflow Cơ Bản

```
1. Mở pgAdmin (http://localhost:5050)
2. Đăng nhập
3. Kết nối đến PostgreSQL server
4. Chọn database
5. Chọn table
6. Xem/edit dữ liệu hoặc viết queries
```

---

## 🐳 Docker Setup (Optional)

### Định Nghĩa

**Docker** cho phép chạy PostgreSQL trong container (isolated environment).

### Ưu Điểm

1. **Dễ setup** - Không cần cài đặt phức tạp
2. **Isolated** - Không ảnh hưởng đến hệ thống
3. **Portable** - Chạy trên bất kỳ máy nào
4. **Easy cleanup** - Xóa container là xong

### Docker Compose Example

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: learning
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  pgadmin:
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@example.com
      PGADMIN_DEFAULT_PASSWORD: admin
    ports:
      - "5050:80"

volumes:
  postgres_data:
```

### Chạy Docker Compose

```bash
docker-compose up -d
```

---

## 🔐 Security Basics

### Best Practices

1. **Đặt password mạnh** - Tối thiểu 12 ký tự
2. **Sử dụng SSL/TLS** - Mã hóa connections
3. **Giới hạn quyền truy cập** - Sử dụng roles & permissions
4. **Backup thường xuyên** - Tránh mất dữ liệu
5. **Update thường xuyên** - Patch security vulnerabilities

### Default User

PostgreSQL tạo user "postgres" (superuser) lúc installation.

```sql
-- Đổi password cho postgres user
ALTER USER postgres WITH PASSWORD 'new_password';

-- Tạo user mới với quyền hạn
CREATE USER app_user WITH PASSWORD 'app_password';
GRANT CONNECT ON DATABASE learning TO app_user;
```

---

## 📊 Tóm Tắt PostgreSQL Setup

| Khái Niệm | Mô Tả |
|-----------|-------|
| **PostgreSQL** | Open-source relational database |
| **Architecture** | Client-Server model |
| **Connection** | Host, Port, Database, User, Password |
| **psql** | Command-line tool |
| **pgAdmin** | Web-based GUI tool |
| **Docker** | Container-based setup |
| **Security** | Passwords, SSL, Roles, Permissions |

---

## 🎓 Key Takeaways

1. **PostgreSQL** - Powerful, open-source database
2. **Architecture** - Client-Server model
3. **Installation** - Khác nhau trên Windows, macOS, Linux
4. **psql** - Command-line tool để kết nối
5. **pgAdmin** - GUI tool để quản lý
6. **Docker** - Alternative setup method
7. **Security** - Quan trọng từ lúc installation

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL Official Documentation](https://www.postgresql.org/docs/current/)
- [PostgreSQL Installation Guide](https://www.postgresql.org/docs/current/installation.html)
- [pgAdmin Documentation](https://www.pgadmin.org/docs/)
- [PostgreSQL Security](https://www.postgresql.org/docs/current/sql-syntax.html)

---

**Bây giờ bạn đã hiểu PostgreSQL setup! Hãy chuyển sang phần thực hành. 💪**

