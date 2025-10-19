# 📚 Security & Access Control - Lý Thuyết

Hiểu cách bảo vệ database & quản lý access control.

## 🎯 Mục Tiêu Module

Sau khi hoàn thành module này, bạn sẽ:
- ✅ Hiểu Users & Roles
- ✅ Biết cách tạo Users & Roles
- ✅ Hiểu Permissions & Privileges
- ✅ Biết cách grant/revoke permissions
- ✅ Sử dụng được Row-Level Security
- ✅ Hiểu Security best practices

---

## 👤 Users & Roles

### Định Nghĩa

**User** - Database account để kết nối.
**Role** - Collection of permissions.

### Tạo Users

```sql
-- Tạo user
CREATE USER username WITH PASSWORD 'password';

-- Tạo user với options
CREATE USER username WITH PASSWORD 'password' CREATEDB CREATEROLE;
```

### Tạo Roles

```sql
-- Tạo role
CREATE ROLE role_name;

-- Tạo role với permissions
CREATE ROLE admin_role WITH CREATEDB CREATEROLE;
```

---

## 🔐 Permissions & Privileges

### Object Privileges

```sql
-- SELECT
GRANT SELECT ON table_name TO user_name;

-- INSERT
GRANT INSERT ON table_name TO user_name;

-- UPDATE
GRANT UPDATE ON table_name TO user_name;

-- DELETE
GRANT DELETE ON table_name TO user_name;

-- ALL
GRANT ALL ON table_name TO user_name;
```

### Schema Privileges

```sql
-- USAGE
GRANT USAGE ON SCHEMA schema_name TO user_name;

-- CREATE
GRANT CREATE ON SCHEMA schema_name TO user_name;
```

### Database Privileges

```sql
-- CONNECT
GRANT CONNECT ON DATABASE database_name TO user_name;

-- CREATE
GRANT CREATE ON DATABASE database_name TO user_name;
```

---

## 🎯 Grant & Revoke

### GRANT

```sql
-- Grant SELECT to user
GRANT SELECT ON products TO app_user;

-- Grant multiple privileges
GRANT SELECT, INSERT, UPDATE ON products TO app_user;

-- Grant to role
GRANT SELECT ON products TO app_role;

-- Grant role to user
GRANT app_role TO app_user;
```

### REVOKE

```sql
-- Revoke SELECT from user
REVOKE SELECT ON products FROM app_user;

-- Revoke all privileges
REVOKE ALL ON products FROM app_user;

-- Revoke role from user
REVOKE app_role FROM app_user;
```

---

## 🛡️ Row-Level Security (RLS)

### Định Nghĩa

**RLS** - Restrict rows based on user/role.

### Enable RLS

```sql
-- Enable RLS on table
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Create policy
CREATE POLICY product_policy ON products
FOR SELECT
USING (user_id = current_user_id());
```

### Ví Dụ RLS

```sql
-- Enable RLS
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Create policy: users can only see their own orders
CREATE POLICY user_orders_policy ON orders
FOR SELECT
USING (user_id = current_user_id());

-- Create policy: users can only insert their own orders
CREATE POLICY user_insert_orders_policy ON orders
FOR INSERT
WITH CHECK (user_id = current_user_id());
```

---

## 🔑 Password Management

### Change Password

```sql
-- Change user password
ALTER USER username WITH PASSWORD 'new_password';
```

### Password Expiration

```sql
-- Set password expiration
ALTER USER username VALID UNTIL '2025-12-31';

-- Remove expiration
ALTER USER username VALID UNTIL 'infinity';
```

---

## 🔒 Connection Security

### SSL/TLS

```sql
-- Enable SSL in postgresql.conf
ssl = on
ssl_cert_file = 'server.crt'
ssl_key_file = 'server.key'
```

### Host-Based Authentication (pg_hba.conf)

```
# IPv4 local connections
host    all             all             127.0.0.1/32            md5

# IPv6 local connections
host    all             all             ::1/128                 md5

# Remote connections
host    all             all             192.168.1.0/24          md5
```

---

## 📊 Tóm Tắt Security

| Khái Niệm | Mô Tả | Khi Dùng |
|-----------|-------|---------|
| **User** | Database account | Login |
| **Role** | Permission collection | Grouping |
| **GRANT** | Give permissions | Access |
| **REVOKE** | Remove permissions | Restrict |
| **RLS** | Row-level security | Data isolation |
| **SSL/TLS** | Encryption | Secure connection |
| **pg_hba.conf** | Authentication | Connection control |

---

## 🎓 Key Takeaways

1. **Users & Roles** - Account management
2. **Permissions** - Access control
3. **GRANT/REVOKE** - Permission management
4. **RLS** - Row-level security
5. **Password Management** - Secure passwords
6. **SSL/TLS** - Encrypted connections
7. **Best Practices** - Principle of least privilege

---

## 📚 Tài Liệu Tham Khảo

- [PostgreSQL Users & Roles](https://www.postgresql.org/docs/current/user-manag.html)
- [PostgreSQL Privileges](https://www.postgresql.org/docs/current/sql-grant.html)
- [PostgreSQL RLS](https://www.postgresql.org/docs/current/ddl-rowsecurity.html)

---

**Bây giờ bạn đã hiểu Security & Access Control! Hãy chuyển sang phần thực hành. 💪**

