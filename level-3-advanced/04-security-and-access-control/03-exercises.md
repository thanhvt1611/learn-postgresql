# 💪 Security & Access Control - Bài Tập

Thực hành bảo vệ database & quản lý access control.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có database "ecommerce_practice" với sample data

---

## 🎯 Bài Tập 1: Create User (Dễ)

### Yêu Cầu
Tạo user mới với password.

### Gợi Ý
- Sử dụng CREATE USER
- Sử dụng WITH PASSWORD

### Solution
```sql
CREATE USER app_user WITH PASSWORD 'app_password';
```

---

## 🎯 Bài Tập 2: Create Role (Dễ)

### Yêu Cầu
Tạo role mới.

### Gợi Ý
- Sử dụng CREATE ROLE
- Sử dụng meaningful name

### Solution
```sql
CREATE ROLE app_role;
```

---

## 🎯 Bài Tập 3: Assign Role to User (Dễ)

### Yêu Cầu
Assign role to user.

### Gợi Ý
- Sử dụng GRANT role TO user

### Solution
```sql
GRANT app_role TO app_user;
```

---

## 🎯 Bài Tập 4: Grant SELECT (Trung Bình)

### Yêu Cầu
Grant SELECT permission on products table.

### Gợi Ý
- Sử dụng GRANT SELECT
- Sử dụng ON table_name

### Solution
```sql
GRANT SELECT ON products TO app_user;
```

---

## 🎯 Bài Tập 5: Grant Multiple Privileges (Trung Bình)

### Yêu Cầu
Grant SELECT, INSERT, UPDATE on products.

### Gợi Ý
- Sử dụng GRANT multiple privileges
- Sử dụng comma-separated list

### Solution
```sql
GRANT SELECT, INSERT, UPDATE ON products TO app_user;
```

---

## 🎯 Bài Tập 6: Grant All Privileges (Trung Bình)

### Yêu Cầu
Grant all privileges on products to admin user.

### Gợi Ý
- Sử dụng GRANT ALL
- Sử dụng ON table_name

### Solution
```sql
GRANT ALL ON products TO admin_user;
```

---

## 🎯 Bài Tập 7: Revoke Privileges (Trung Bình)

### Yêu Cầu
Revoke SELECT permission from user.

### Gợi Ý
- Sử dụng REVOKE SELECT
- Sử dụng FROM user_name

### Solution
```sql
REVOKE SELECT ON products FROM app_user;
```

---

## 🎯 Bài Tập 8: Enable RLS (Nâng Cao)

### Yêu Cầu
Enable Row-Level Security on orders table.

### Gợi Ý
- Sử dụng ALTER TABLE
- Sử dụng ENABLE ROW LEVEL SECURITY

### Solution
```sql
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
```

---

## 🎯 Bài Tập 9: Create RLS Policy (Nâng Cao)

### Yêu Cầu
Create RLS policy để users chỉ thấy orders của họ.

### Gợi Ý
- Sử dụng CREATE POLICY
- Sử dụng USING clause
- Sử dụng current_user_id()

### Solution
```sql
CREATE POLICY user_orders_policy ON orders
FOR SELECT
USING (user_id = current_user_id());
```

---

## 🎯 Bài Tập 10: RLS with INSERT (Nâng Cao)

### Yêu Cầu
Create RLS policy để users chỉ insert orders của họ.

### Gợi Ý
- Sử dụng CREATE POLICY
- Sử dụng FOR INSERT
- Sử dụng WITH CHECK

### Solution
```sql
CREATE POLICY user_insert_orders_policy ON orders
FOR INSERT
WITH CHECK (user_id = current_user_id());
```

---

## 🎯 Bài Tập 11: Change Password (Nâng Cao)

### Yêu Cầu
Change user password.

### Gợi Ý
- Sử dụng ALTER USER
- Sử dụng WITH PASSWORD

### Solution
```sql
ALTER USER app_user WITH PASSWORD 'new_password';
```

---

## 🎯 Bài Tập 12: Password Expiration (Nâng Cao)

### Yêu Cầu
Set password expiration date.

### Gợi Ý
- Sử dụng ALTER USER
- Sử dụng VALID UNTIL

### Solution
```sql
ALTER USER app_user VALID UNTIL '2025-12-31';
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-3: Users & Roles
- [ ] Bài 4-7: Permissions
- [ ] Bài 8-10: RLS
- [ ] Bài 11-12: Password Management

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ Create Users & Roles
- ✅ Assign Roles
- ✅ Grant Permissions
- ✅ Revoke Permissions
- ✅ Enable RLS
- ✅ Create RLS Policies
- ✅ Password Management
- ✅ Security best practices

---

**Chúc mừng! Bạn đã hoàn thành Module 4 - Security & Access Control! 🎉**

