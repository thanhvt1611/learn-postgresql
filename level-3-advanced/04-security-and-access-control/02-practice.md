# 🛠️ Security & Access Control - Thực Hành

Thực hành bảo vệ database & quản lý access control.

## 🎯 Mục Tiêu

Sau khi hoàn thành phần thực hành này, bạn sẽ:
- ✅ Tạo được Users & Roles
- ✅ Grant/Revoke permissions
- ✅ Implement Row-Level Security
- ✅ Manage password security
- ✅ Understand connection security

---

## 📋 Bước 1: Chuẩn Bị Database

### Bước 1.1: Kết Nối Database

```sql
-- Kết nối với superuser
psql -U postgres -d ecommerce_practice
```

---

## 👤 Bước 2: Tạo Users & Roles

### Thực Hành 2.1: Tạo Users

```sql
-- Tạo app user
CREATE USER app_user WITH PASSWORD 'app_password';

-- Tạo read-only user
CREATE USER readonly_user WITH PASSWORD 'readonly_password';

-- Tạo admin user
CREATE USER admin_user WITH PASSWORD 'admin_password' CREATEDB CREATEROLE;

-- List users
\du
```

### Thực Hành 2.2: Tạo Roles

```sql
-- Tạo app role
CREATE ROLE app_role;

-- Tạo readonly role
CREATE ROLE readonly_role;

-- Tạo admin role
CREATE ROLE admin_role WITH CREATEDB CREATEROLE;

-- List roles
\du
```

### Thực Hành 2.3: Assign Roles to Users

```sql
-- Assign app_role to app_user
GRANT app_role TO app_user;

-- Assign readonly_role to readonly_user
GRANT readonly_role TO readonly_user;

-- Assign admin_role to admin_user
GRANT admin_role TO admin_user;
```

---

## 🔐 Bước 3: Grant Permissions

### Thực Hành 3.1: Grant SELECT

```sql
-- Grant SELECT on products to app_user
GRANT SELECT ON products TO app_user;

-- Grant SELECT on all tables to readonly_user
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly_user;
```

### Thực Hành 3.2: Grant Multiple Privileges

```sql
-- Grant SELECT, INSERT, UPDATE on products to app_user
GRANT SELECT, INSERT, UPDATE ON products TO app_user;

-- Grant all privileges on products to admin_user
GRANT ALL ON products TO admin_user;
```

### Thực Hành 3.3: Grant Schema Privileges

```sql
-- Grant USAGE on schema to app_user
GRANT USAGE ON SCHEMA public TO app_user;

-- Grant CREATE on schema to admin_user
GRANT CREATE ON SCHEMA public TO admin_user;
```

---

## 🔄 Bước 4: Revoke Permissions

### Thực Hành 4.1: Revoke Privileges

```sql
-- Revoke SELECT from app_user
REVOKE SELECT ON products FROM app_user;

-- Revoke all privileges from app_user
REVOKE ALL ON products FROM app_user;
```

### Thực Hành 4.2: Revoke Roles

```sql
-- Revoke app_role from app_user
REVOKE app_role FROM app_user;
```

---

## 🛡️ Bước 5: Row-Level Security

### Thực Hành 5.1: Enable RLS

```sql
-- Enable RLS on orders table
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Create policy: users can only see their own orders
CREATE POLICY user_orders_policy ON orders
FOR SELECT
USING (user_id = current_user_id());
```

### Thực Hành 5.2: RLS with INSERT

```sql
-- Create policy: users can only insert their own orders
CREATE POLICY user_insert_orders_policy ON orders
FOR INSERT
WITH CHECK (user_id = current_user_id());
```

### Thực Hành 5.3: RLS with UPDATE

```sql
-- Create policy: users can only update their own orders
CREATE POLICY user_update_orders_policy ON orders
FOR UPDATE
USING (user_id = current_user_id())
WITH CHECK (user_id = current_user_id());
```

---

## 🔑 Bước 6: Password Management

### Thực Hành 6.1: Change Password

```sql
-- Change app_user password
ALTER USER app_user WITH PASSWORD 'new_password';
```

### Thực Hành 6.2: Password Expiration

```sql
-- Set password expiration
ALTER USER app_user VALID UNTIL '2025-12-31';

-- Remove expiration
ALTER USER app_user VALID UNTIL 'infinity';
```

### Thực Hành 6.3: View User Info

```sql
-- View user information
SELECT usename, usesuper, usecreatedb, valuntil
FROM pg_user
WHERE usename = 'app_user';
```

---

## 🔒 Bước 7: Connection Security

### Thực Hành 7.1: View pg_hba.conf

```sql
-- View current authentication settings
SHOW hba_file;

-- View authentication methods
SELECT * FROM pg_hba_file_rules;
```

### Thực Hành 7.2: Test User Connection

```sql
-- Test connection as app_user
psql -U app_user -d ecommerce_practice

-- Test connection as readonly_user
psql -U readonly_user -d ecommerce_practice
```

---

## ✅ Checklist Thực Hành

- [ ] Tạo Users & Roles
- [ ] Assign Roles to Users
- [ ] Grant Permissions
- [ ] Revoke Permissions
- [ ] Enable RLS
- [ ] Create RLS Policies
- [ ] Manage Passwords
- [ ] Test Connections

---

## 💡 Tips

1. **Principle of Least Privilege** - Chỉ grant cần thiết
2. **Use Roles** - Để group permissions
3. **Enable RLS** - Cho sensitive data
4. **Strong Passwords** - Bảo vệ accounts
5. **Monitor Access** - Audit logs

---

**Chúc mừng! Bạn đã hoàn thành phần thực hành. Hãy chuyển sang bài tập! 🎉**

