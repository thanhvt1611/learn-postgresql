# 💪 Database Concepts - Bài Tập

Thực hành thiết kế database schemas và tạo relationships.

## 📋 Chuẩn Bị

Trước khi bắt đầu, hãy chắc chắn bạn đã:
- ✅ Hoàn thành phần thực hành (02-practice.md)
- ✅ Có database "ecommerce" với các tables
- ✅ Có sample data

---

## 🎯 Bài Tập 1: Tạo Table Với Primary Key (Dễ)

### Yêu Cầu
Tạo table "suppliers" với:
- id (SERIAL PRIMARY KEY)
- name (VARCHAR(100) NOT NULL)
- email (VARCHAR(100) UNIQUE)
- phone (VARCHAR(20))

### Gợi Ý
- Sử dụng CREATE TABLE
- Thêm PRIMARY KEY cho id
- Thêm UNIQUE cho email
- Thêm NOT NULL cho name

### Solution
```sql
CREATE TABLE suppliers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20)
);
```

---

## 🎯 Bài Tập 2: Tạo Table Với Foreign Key (Trung Bình)

### Yêu Cầu
Tạo table "reviews" với:
- id (SERIAL PRIMARY KEY)
- product_id (INTEGER REFERENCES products(id))
- user_id (INTEGER REFERENCES users(id))
- rating (INTEGER CHECK (rating >= 1 AND rating <= 5))
- comment (TEXT)

### Gợi Ý
- Sử dụng REFERENCES để tạo Foreign Keys
- Sử dụng CHECK để validate rating

### Solution
```sql
CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES products(id),
    user_id INTEGER NOT NULL REFERENCES users(id),
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT
);
```

---

## 🎯 Bài Tập 3: Thêm Data Với Foreign Keys (Trung Bình)

### Yêu Cầu
Thêm 3 reviews vào table reviews:
- Review 1: product_id=1, user_id=1, rating=5, comment='Great product!'
- Review 2: product_id=2, user_id=2, rating=4, comment='Good quality'
- Review 3: product_id=3, user_id=3, rating=5, comment='Excellent book'

### Gợi Ý
- Sử dụng INSERT INTO
- Chắc chắn product_id và user_id tồn tại

### Solution
```sql
INSERT INTO reviews (product_id, user_id, rating, comment) VALUES
(1, 1, 5, 'Great product!'),
(2, 2, 4, 'Good quality'),
(3, 3, 5, 'Excellent book');

-- Kiểm tra
SELECT * FROM reviews;
```

---

## 🎯 Bài Tập 4: Query Với JOIN (Trung Bình)

### Yêu Cầu
Viết query để lấy tất cả reviews với product name, user name, và rating.

### Gợi Ý
- Sử dụng JOIN để kết hợp reviews, products, users
- Lấy columns: product name, user name, rating, comment

### Solution
```sql
SELECT 
    p.name AS product_name,
    u.name AS user_name,
    r.rating,
    r.comment
FROM reviews r
JOIN products p ON r.product_id = p.id
JOIN users u ON r.user_id = u.id;
```

---

## 🎯 Bài Tập 5: Tạo Many-to-Many Table (Nâng Cao)

### Yêu Cầu
Tạo table "user_addresses" để lưu trữ nhiều addresses cho mỗi user:
- id (SERIAL PRIMARY KEY)
- user_id (INTEGER REFERENCES users(id))
- address_type (VARCHAR(20)) - 'home', 'work', 'other'
- street (VARCHAR(100) NOT NULL)
- city (VARCHAR(50) NOT NULL)
- postal_code (VARCHAR(10))

### Gợi Ý
- Sử dụng REFERENCES để tạo Foreign Key
- Thêm NOT NULL cho required fields

### Solution
```sql
CREATE TABLE user_addresses (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    address_type VARCHAR(20),
    street VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    postal_code VARCHAR(10)
);
```

---

## 🎯 Bài Tập 6: Thêm Data Vào Many-to-Many Table (Trung Bình)

### Yêu Cầu
Thêm addresses cho users:
- User 1: home address (123 Main St, New York, 10001)
- User 1: work address (456 Work Ave, New York, 10002)
- User 2: home address (789 Home St, Boston, 02101)

### Gợi Ý
- Sử dụng INSERT INTO
- Chắc chắn user_id tồn tại

### Solution
```sql
INSERT INTO user_addresses (user_id, address_type, street, city, postal_code) VALUES
(1, 'home', '123 Main St', 'New York', '10001'),
(1, 'work', '456 Work Ave', 'New York', '10002'),
(2, 'home', '789 Home St', 'Boston', '02101');

-- Kiểm tra
SELECT * FROM user_addresses;
```

---

## 🎯 Bài Tập 7: Query Many-to-Many (Nâng Cao)

### Yêu Cầu
Viết query để lấy tất cả addresses của user 1.

### Gợi Ý
- Sử dụng WHERE user_id = 1
- Hoặc sử dụng JOIN với users table

### Solution
```sql
SELECT u.name, ua.address_type, ua.street, ua.city
FROM user_addresses ua
JOIN users u ON ua.user_id = u.id
WHERE ua.user_id = 1;
```

---

## 🎯 Bài Tập 8: Aggregate Query (Nâng Cao)

### Yêu Cầu
Viết query để lấy số lượng orders của mỗi user.

### Gợi Ý
- Sử dụng COUNT()
- Sử dụng GROUP BY user_id
- Sử dụng JOIN để lấy user name

### Solution
```sql
SELECT u.id, u.name, COUNT(o.id) AS order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name
ORDER BY order_count DESC;
```

---

## 🎯 Bài Tập 9: Aggregate Query 2 (Nâng Cao)

### Yêu Cầu
Viết query để lấy tổng số products trong mỗi category.

### Gợi Ý
- Sử dụng COUNT()
- Sử dụng GROUP BY category_id
- Sử dụng JOIN để lấy category name

### Solution
```sql
SELECT c.id, c.name, COUNT(p.id) AS product_count
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
GROUP BY c.id, c.name;
```

---

## 🎯 Bài Tập 10: Aggregate Query 3 (Nâng Cao)

### Yêu Cầu
Viết query để lấy average rating của mỗi product.

### Gợi Ý
- Sử dụng AVG()
- Sử dụng GROUP BY product_id
- Sử dụng JOIN để lấy product name

### Solution
```sql
SELECT p.id, p.name, AVG(r.rating) AS avg_rating, COUNT(r.id) AS review_count
FROM products p
LEFT JOIN reviews r ON p.id = r.product_id
GROUP BY p.id, p.name;
```

---

## 🎯 Bài Tập 11: Constraint Validation (Trung Bình)

### Yêu Cầu
Thử các queries sau và ghi lại lỗi:
1. Thêm review với rating = 10 (ngoài range 1-5)
2. Thêm review với product_id = 999 (không tồn tại)
3. Thêm review với user_id = NULL

### Gợi Ý
- Cố tình tạo lỗi để hiểu constraints
- Ghi lại error messages

### Solution
```sql
-- ❌ Lỗi: rating > 5
INSERT INTO reviews (product_id, user_id, rating, comment) 
VALUES (1, 1, 10, 'Test');

-- ❌ Lỗi: product_id không tồn tại
INSERT INTO reviews (product_id, user_id, rating, comment) 
VALUES (999, 1, 5, 'Test');

-- ❌ Lỗi: user_id NOT NULL
INSERT INTO reviews (product_id, user_id, rating, comment) 
VALUES (1, NULL, 5, 'Test');
```

---

## 🎯 Bài Tập 12: Complex Query (Nâng Cao)

### Yêu Cầu
Viết query để lấy:
- User name
- Số lượng orders
- Tổng tiền đã chi tiêu
- Average order value

### Gợi Ý
- Sử dụng COUNT(), SUM(), AVG()
- Sử dụng GROUP BY user_id
- Sử dụng JOIN

### Solution
```sql
SELECT 
    u.id,
    u.name,
    COUNT(o.id) AS order_count,
    SUM(o.total_amount) AS total_spent,
    AVG(o.total_amount) AS avg_order_value
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name
ORDER BY total_spent DESC;
```

---

## 🎯 Bài Tập 13: Data Integrity (Nâng Cao)

### Yêu Cầu
Viết query để tìm:
1. Orders không có order_items
2. Products không có reviews
3. Categories không có products

### Gợi Ý
- Sử dụng LEFT JOIN
- Sử dụng WHERE ... IS NULL

### Solution
```sql
-- Orders không có order_items
SELECT o.id FROM orders o
LEFT JOIN order_items oi ON o.id = oi.order_id
WHERE oi.id IS NULL;

-- Products không có reviews
SELECT p.id, p.name FROM products p
LEFT JOIN reviews r ON p.id = r.product_id
WHERE r.id IS NULL;

-- Categories không có products
SELECT c.id, c.name FROM categories c
LEFT JOIN products p ON c.id = p.category_id
WHERE p.id IS NULL;
```

---

## 🎯 Bài Tập 14: Schema Design (Nâng Cao)

### Yêu Cầu
Thiết kế schema cho "Blog System" với:
- Users (id, name, email)
- Posts (id, user_id, title, content, created_at)
- Comments (id, post_id, user_id, content, created_at)
- Tags (id, name)
- Post_Tags (post_id, tag_id) - Many-to-Many

### Gợi Ý
- Tạo tất cả tables
- Thêm Primary Keys
- Thêm Foreign Keys
- Thêm Constraints

### Solution
```sql
CREATE TABLE blog_users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE blog_posts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES blog_users(id),
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE blog_comments (
    id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES blog_posts(id),
    user_id INTEGER NOT NULL REFERENCES blog_users(id),
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE blog_tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE blog_post_tags (
    post_id INTEGER NOT NULL REFERENCES blog_posts(id),
    tag_id INTEGER NOT NULL REFERENCES blog_tags(id),
    PRIMARY KEY (post_id, tag_id)
);
```

---

## ✅ Checklist Bài Tập

- [ ] Bài 1-2: Tạo tables với constraints
- [ ] Bài 3-4: Thêm data & query với JOINs
- [ ] Bài 5-7: Many-to-Many relationships
- [ ] Bài 8-10: Aggregate queries
- [ ] Bài 11: Constraint validation
- [ ] Bài 12-13: Complex queries
- [ ] Bài 14: Schema design

---

## 🎓 Tóm Tắt

Bạn đã thực hành:
- ✅ Tạo tables với Primary Keys
- ✅ Tạo Foreign Keys
- ✅ Thêm Constraints (UNIQUE, NOT NULL, CHECK)
- ✅ Query với JOINs
- ✅ Many-to-Many relationships
- ✅ Aggregate functions
- ✅ Data integrity checks
- ✅ Schema design

---

**Chúc mừng! Bạn đã hoàn thành Module 2 - Database Concepts! 🎉**

Hãy chuyển sang Module 3 - PostgreSQL Setup để tiếp tục học!

