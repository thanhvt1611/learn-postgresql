# 🚀 Hướng Dẫn Bắt Đầu - Getting Started

Hướng dẫn chi tiết để setup môi trường PostgreSQL và bắt đầu học.

## 📋 Yêu Cầu Tiên Quyết

- **Máy tính:** Windows, macOS, hoặc Linux
- **RAM:** Tối thiểu 4GB (8GB khuyến nghị)
- **Ổ cứng:** 10GB trống
- **Kỹ năng:** Cơ bản về command line

## 🔧 Cài Đặt PostgreSQL

### **Windows**

#### Bước 1: Tải PostgreSQL
1. Truy cập [postgresql.org/download](https://www.postgresql.org/download/windows/)
2. Tải PostgreSQL 15+ (latest stable version)
3. Chọn installer phiên bản 64-bit

#### Bước 2: Chạy Installer
1. Mở file `.exe` vừa tải
2. Chọn installation directory (mặc định: `C:\Program Files\PostgreSQL\15`)
3. Chọn components:
   - ✅ PostgreSQL Server
   - ✅ pgAdmin 4
   - ✅ Stack Builder
   - ✅ Command Line Tools

#### Bước 3: Setup Database Cluster
1. Chọn data directory (mặc định: `C:\Program Files\PostgreSQL\15\data`)
2. Đặt password cho user `postgres` (ghi nhớ password này!)
3. Chọn port (mặc định: 5432)
4. Chọn locale (English, United States)

#### Bước 4: Hoàn Thành
1. Chọn "Launch Stack Builder" (optional)
2. Kết thúc installation

### **macOS**

#### Bước 1: Sử Dụng Homebrew (Khuyến Nghị)
```bash
# Cài đặt Homebrew nếu chưa có
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Cài đặt PostgreSQL
brew install postgresql@15

# Khởi động PostgreSQL
brew services start postgresql@15
```

#### Bước 2: Hoặc Tải Installer
1. Truy cập [postgresql.org/download/macosx](https://www.postgresql.org/download/macosx/)
2. Tải PostgreSQL 15+ installer
3. Chạy installer và làm theo hướng dẫn

### **Linux (Ubuntu/Debian)**

```bash
# Cập nhật package manager
sudo apt update

# Cài đặt PostgreSQL
sudo apt install postgresql postgresql-contrib

# Khởi động PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Kiểm tra status
sudo systemctl status postgresql
```

### **Linux (CentOS/RHEL)**

```bash
# Cài đặt PostgreSQL
sudo yum install postgresql-server postgresql-contrib

# Khởi tạo database cluster
sudo /usr/pgsql-15/bin/postgresql-15-setup initdb

# Khởi động PostgreSQL
sudo systemctl start postgresql-15
sudo systemctl enable postgresql-15
```

## ✅ Kiểm Tra Installation

### Bước 1: Mở Terminal/Command Prompt

**Windows:**
```cmd
# Mở Command Prompt hoặc PowerShell
psql --version
```

**macOS/Linux:**
```bash
psql --version
```

### Bước 2: Kết Nối PostgreSQL

```bash
# Kết nối với default database
psql -U postgres

# Nếu được hỏi password, nhập password đã đặt lúc installation
```

### Bước 3: Kiểm Tra Kết Nối

```sql
-- Trong psql prompt, chạy:
SELECT version();

-- Output sẽ hiển thị phiên bản PostgreSQL
-- Ví dụ: PostgreSQL 15.2 on x86_64-pc-linux-gnu, ...
```

### Bước 4: Thoát psql

```sql
\q
```

## 🛠️ Cài Đặt GUI Tools

### **pgAdmin 4** (Đã cài sẵn)

pgAdmin 4 thường được cài sẵn khi cài PostgreSQL.

#### Truy Cập pgAdmin
1. Mở trình duyệt
2. Truy cập `http://localhost:5050`
3. Đăng nhập (email & password được tạo lúc installation)
4. Kết nối đến PostgreSQL server

#### Tạo Connection
1. Nhấp chuột phải vào "Servers"
2. Chọn "Register" → "Server"
3. Điền thông tin:
   - **Name:** localhost
   - **Host name/address:** localhost
   - **Port:** 5432
   - **Username:** postgres
   - **Password:** (password đã đặt)
4. Nhấp "Save"

### **DBeaver** (Khuyến Nghị)

DBeaver là tool mạnh mẽ hơn pgAdmin.

#### Cài Đặt
1. Truy cập [dbeaver.io](https://dbeaver.io/download/)
2. Tải DBeaver Community Edition
3. Cài đặt theo hướng dẫn

#### Tạo Connection
1. Mở DBeaver
2. Chọn "Database" → "New Database Connection"
3. Chọn "PostgreSQL"
4. Điền thông tin:
   - **Server Host:** localhost
   - **Port:** 5432
   - **Database:** postgres
   - **Username:** postgres
   - **Password:** (password đã đặt)
5. Nhấp "Test Connection"
6. Nhấp "Finish"

## 🐳 Cài Đặt Với Docker (Optional)

Nếu bạn muốn sử dụng Docker:

### Bước 1: Cài Đặt Docker
- Truy cập [docker.com](https://www.docker.com/products/docker-desktop)
- Tải Docker Desktop
- Cài đặt theo hướng dẫn

### Bước 2: Tạo Docker Compose File

Tạo file `docker-compose.yml`:

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15
    container_name: learn-postgresql
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: learning
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - postgres_network

  pgadmin:
    image: dpage/pgadmin4:latest
    container_name: pgadmin
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@example.com
      PGADMIN_DEFAULT_PASSWORD: admin
    ports:
      - "5050:80"
    networks:
      - postgres_network

volumes:
  postgres_data:

networks:
  postgres_network:
    driver: bridge
```

### Bước 3: Chạy Docker Compose

```bash
# Trong thư mục chứa docker-compose.yml
docker-compose up -d

# Kiểm tra containers
docker-compose ps

# Xem logs
docker-compose logs -f postgres
```

### Bước 4: Kết Nối

```bash
# Kết nối vào PostgreSQL container
docker exec -it learn-postgresql psql -U postgres

# Hoặc sử dụng pgAdmin tại http://localhost:5050
```

## 📚 Tạo First Database

### Bước 1: Kết Nối PostgreSQL

```bash
psql -U postgres
```

### Bước 2: Tạo Database

```sql
CREATE DATABASE learning;
```

### Bước 3: Kết Nối Vào Database

```sql
\c learning
```

### Bước 4: Tạo Table Đầu Tiên

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Bước 5: Insert Data

```sql
INSERT INTO users (name, email) VALUES
('John Doe', 'john@example.com'),
('Jane Smith', 'jane@example.com');
```

### Bước 6: Query Data

```sql
SELECT * FROM users;
```

## 📝 Cấu Hình psql

### Tạo `.psqlrc` File

Tạo file `.psqlrc` trong home directory để cấu hình psql:

**Windows:** `C:\Users\YourUsername\.psqlrc`
**macOS/Linux:** `~/.psqlrc`

```
-- Hiển thị query time
\timing

-- Hiển thị NULL values rõ ràng
\pset null '[NULL]'

-- Đặt prompt
\set PROMPT1 '%n@%m:%> %x '

-- Bật expanded display cho kết quả lớn
\x auto
```

## 🔐 Cấu Hình Kết Nối

### Tạo `.pgpass` File (Optional)

Để tránh nhập password mỗi lần:

**Windows:** `C:\Users\YourUsername\AppData\postgresql\pgpass.conf`
**macOS/Linux:** `~/.pgpass`

```
localhost:5432:*:postgres:your_password
```

**Quan trọng:** Trên macOS/Linux, đặt permissions:
```bash
chmod 600 ~/.pgpass
```

## 🎯 Bước Tiếp Theo

1. ✅ Kiểm tra PostgreSQL hoạt động
2. ✅ Cài đặt GUI tool (pgAdmin hoặc DBeaver)
3. ✅ Tạo first database
4. ✅ Bắt đầu với Prerequisites modules

## 🆘 Troubleshooting

### Lỗi: "psql: command not found"
- **Nguyên nhân:** PostgreSQL chưa được thêm vào PATH
- **Giải pháp:** 
  - Windows: Thêm `C:\Program Files\PostgreSQL\15\bin` vào PATH
  - macOS: Chạy `brew install postgresql@15`
  - Linux: Cài đặt lại PostgreSQL

### Lỗi: "FATAL: Ident authentication failed"
- **Nguyên nhân:** Cấu hình authentication
- **Giải pháp:** Sử dụng `psql -U postgres` hoặc cấu hình `pg_hba.conf`

### Lỗi: "Port 5432 already in use"
- **Nguyên nhân:** PostgreSQL đã chạy hoặc port bị chiếm
- **Giải pháp:** 
  - Kiểm tra: `lsof -i :5432` (macOS/Linux)
  - Hoặc sử dụng port khác: `psql -p 5433`

### Lỗi: "Connection refused"
- **Nguyên nhân:** PostgreSQL service không chạy
- **Giải pháp:**
  - Windows: Khởi động PostgreSQL service
  - macOS: `brew services start postgresql@15`
  - Linux: `sudo systemctl start postgresql`

## 📞 Hỗ Trợ Thêm

- Xem `resources/tools-setup/` cho hướng dẫn chi tiết
- Xem `resources/troubleshooting/common-errors.md` cho lỗi thường gặp
- Xem `resources/links.md` cho tài nguyên bổ sung

---

**Chúc mừng! Bạn đã setup PostgreSQL thành công! 🎉**

Bây giờ bạn sẵn sàng bắt đầu học. Hãy đi tới `prerequisites/01-sql-fundamentals/` để bắt đầu!

