# 💪 PostgreSQL Setup - Bài Tập

Thực hành cài đặt, cấu hình, và quản lý PostgreSQL.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Cài đặt PostgreSQL thành công
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có thể kết nối với psql

---

## 🎯 Bài Tập 1: Kiểm Tra Installation (Dễ)

### Yêu Cầu
Kiểm tra PostgreSQL installation bằng cách:
1. Chạy `psql --version`
2. Chạy `psql -U postgres` để kết nối
3. Chạy `SELECT version();` để xem version chi tiết
4. Chạy `\l` để liệt kê databases

### Gợi Ý
- Mở terminal/command prompt
- Chạy các commands theo thứ tự
- Ghi lại output

### Solution
```bash
# Kiểm tra version
psql --version

# Kết nối đến PostgreSQL
psql -U postgres

# Trong psql prompt:
SELECT version();
\l
\q
```

---

## 🎯 Bài Tập 2: Tạo Database & User (Trung Bình)

### Yêu Cầu
Tạo:
1. Database mới tên "company"
2. User mới tên "company_user" với password "company123"
3. Cấp quyền cho user trên database

### Gợi Ý
- Sử dụng CREATE DATABASE
- Sử dụng CREATE USER
- Sử dụng GRANT

### Solution
```sql
-- Kết nối với postgres user
psql -U postgres

-- Tạo database
CREATE DATABASE company;

-- Tạo user
CREATE USER company_user WITH PASSWORD 'company123';

-- Cấp quyền
GRANT CONNECT ON DATABASE company TO company_user;
GRANT USAGE ON SCHEMA public TO company_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO company_user;

-- Kiểm tra
\l
\du
```

---

## 🎯 Bài Tập 3: Kết Nối Với User Mới (Trung Bình)

### Yêu Cầu
Kết nối đến database "company" bằng user "company_user":
1. Kết nối từ command line
2. Chạy `SELECT current_user;` để xem user hiện tại
3. Chạy `SELECT current_database();` để xem database hiện tại

### Gợi Ý
- Sử dụng `psql -U company_user -d company`
- Nhập password khi được hỏi

### Solution
```bash
# Kết nối với company_user
psql -U company_user -d company

# Trong psql prompt:
SELECT current_user;
SELECT current_database();
\q
```

---

## 🎯 Bài Tập 4: Tạo Tables & Thêm Data (Trung Bình)

### Yêu Cầu
Trong database "company", tạo:
1. Table "employees" (id, name, email, salary)
2. Table "departments" (id, name)
3. Thêm 3 employees & 2 departments

### Gợi Ý
- Sử dụng CREATE TABLE
- Sử dụng INSERT INTO
- Thêm constraints (PK, NOT NULL, UNIQUE)

### Solution
```sql
-- Kết nối
psql -U company_user -d company

-- Tạo tables
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    salary DECIMAL(10, 2),
    department_id INTEGER REFERENCES departments(id)
);

-- Thêm departments
INSERT INTO departments (name) VALUES ('IT'), ('HR');

-- Thêm employees
INSERT INTO employees (name, email, salary, department_id) VALUES
('John Doe', 'john@company.com', 5000, 1),
('Jane Smith', 'jane@company.com', 4500, 2),
('Bob Johnson', 'bob@company.com', 5500, 1);

-- Kiểm tra
SELECT * FROM departments;
SELECT * FROM employees;
```

---

## 🎯 Bài Tập 5: Query Với JOINs (Nâng Cao)

### Yêu Cầu
Viết queries để:
1. Lấy tất cả employees với department name
2. Lấy số lượng employees trong mỗi department
3. Lấy average salary của mỗi department

### Gợi Ý
- Sử dụng JOIN
- Sử dụng COUNT(), AVG()
- Sử dụng GROUP BY

### Solution
```sql
-- Employees với department name
SELECT e.name, e.email, d.name AS department
FROM employees e
JOIN departments d ON e.department_id = d.id;

-- Số lượng employees trong mỗi department
SELECT d.name, COUNT(e.id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
GROUP BY d.id, d.name;

-- Average salary của mỗi department
SELECT d.name, AVG(e.salary) AS avg_salary
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
GROUP BY d.id, d.name;
```

---

## 🎯 Bài Tập 6: Sử Dụng pgAdmin (Trung Bình)

### Yêu Cầu
Sử dụng pgAdmin để:
1. Kết nối đến PostgreSQL server
2. Xem database "company"
3. Xem tables "employees" & "departments"
4. Chạy query để lấy tất cả employees
5. Thêm employee mới

### Gợi Ý
- Mở http://localhost:5050
- Đăng nhập
- Register server
- Sử dụng Query Tool

### Solution
```
1. Mở http://localhost:5050
2. Đăng nhập
3. Nhấp chuột phải "Servers" → "Register" → "Server"
4. Điền: Name=localhost, Host=localhost, Port=5432, Username=postgres
5. Nhấp "Save"
6. Mở "Servers" → "localhost" → "Databases" → "company"
7. Xem "Tables" → "employees" & "departments"
8. Nhấp "Tools" → "Query Tool"
9. Chạy: SELECT * FROM employees;
10. Chạy: INSERT INTO employees (name, email, salary, department_id) VALUES ('Alice Brown', 'alice@company.com', 5200, 1);
```

---

## 🎯 Bài Tập 7: Backup & Restore (Nâng Cao)

### Yêu Cầu
1. Backup database "company" vào file "company_backup.sql"
2. Xóa database "company"
3. Restore database từ backup file

### Gợi Ý
- Sử dụng `pg_dump` để backup
- Sử dụng `psql` để restore
- Chạy từ command line

### Solution
```bash
# Backup database
pg_dump -U postgres company > company_backup.sql

# Kiểm tra file backup
ls -la company_backup.sql

# Xóa database (từ psql)
psql -U postgres
DROP DATABASE company;
\q

# Tạo database mới
psql -U postgres
CREATE DATABASE company;
\q

# Restore database
psql -U postgres company < company_backup.sql

# Kiểm tra
psql -U postgres -d company
SELECT * FROM employees;
```

---

## 🎯 Bài Tập 8: Quản Lý Users & Permissions (Nâng Cao)

### Yêu Cầu
1. Tạo user mới "read_only_user"
2. Cấp quyền chỉ đọc (SELECT) trên database "company"
3. Kiểm tra quyền bằng cách kết nối với user này
4. Thử INSERT (sẽ lỗi)

### Gợi Ý
- Sử dụng CREATE USER
- Sử dụng GRANT SELECT
- Sử dụng psql để kết nối

### Solution
```sql
-- Tạo user
CREATE USER read_only_user WITH PASSWORD 'readonly123';

-- Cấp quyền CONNECT
GRANT CONNECT ON DATABASE company TO read_only_user;

-- Cấp quyền SELECT trên tất cả tables
GRANT USAGE ON SCHEMA public TO read_only_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO read_only_user;

-- Kiểm tra
\du
```

```bash
# Kết nối với read_only_user
psql -U read_only_user -d company

# Chạy SELECT (sẽ thành công)
SELECT * FROM employees;

# Thử INSERT (sẽ lỗi)
INSERT INTO employees (name, email, salary, department_id) VALUES ('Test', 'test@company.com', 5000, 1);

# Output: ERROR: permission denied for table employees
```

---

## 🎯 Bài Tập 9: Xem Configuration (Nâng Cao)

### Yêu Cầu
Xem PostgreSQL configuration:
1. Xem port hiện tại
2. Xem max_connections
3. Xem data_directory
4. Xem tất cả settings

### Gợi Ý
- Sử dụng SHOW command
- Sử dụng psql

### Solution
```sql
-- Kết nối
psql -U postgres

-- Xem port
SHOW port;

-- Xem max_connections
SHOW max_connections;

-- Xem data_directory
SHOW data_directory;

-- Xem tất cả settings
SHOW ALL;
```

---

## 🎯 Bài Tập 10: Troubleshooting (Nâng Cao)

### Yêu Cầu
Giải quyết các vấn đề sau:
1. Không thể kết nối đến PostgreSQL
2. Quên password cho user postgres
3. Port 5432 đã được sử dụng

### Gợi Ý
- Kiểm tra PostgreSQL service
- Kiểm tra firewall
- Kiểm tra port

### Solution
```bash
# Kiểm tra PostgreSQL service
# Windows:
Get-Service postgresql-x64-15

# macOS:
brew services list | grep postgresql

# Linux:
sudo systemctl status postgresql

# Kiểm tra port
# Windows:
netstat -ano | findstr :5432

# macOS/Linux:
lsof -i :5432

# Khởi động PostgreSQL service
# Windows:
net start postgresql-x64-15

# macOS:
brew services start postgresql@15

# Linux:
sudo systemctl start postgresql
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1: Kiểm tra installation
- [ ] Bài 2: Tạo database & user
- [ ] Bài 3: Kết nối với user mới
- [ ] Bài 4: Tạo tables & thêm data
- [ ] Bài 5: Query với JOINs
- [ ] Bài 6: Sử dụng pgAdmin
- [ ] Bài 7: Backup & restore
- [ ] Bài 8: Quản lý users & permissions
- [ ] Bài 9: Xem configuration
- [ ] Bài 10: Troubleshooting

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ Kiểm tra PostgreSQL installation
- ✅ Tạo databases & users
- ✅ Cấp quyền cho users
- ✅ Tạo tables & thêm data
- ✅ Query với JOINs
- ✅ Sử dụng pgAdmin
- ✅ Backup & restore databases
- ✅ Quản lý users & permissions
- ✅ Xem configuration
- ✅ Troubleshooting

---

**Chúc mừng! Bạn đã hoàn thành Module 3 - PostgreSQL Setup! 🎉**

**Bạn đã hoàn thành tất cả Prerequisites modules! Hãy chuyển sang Level 1 - Fundamentals! 🚀**

