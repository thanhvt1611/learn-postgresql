# 🗺️ Lộ Trình Học PostgreSQL - Chi Tiết 15-20 Tuần

Lộ trình chi tiết từng tuần để hoàn thành khóa học PostgreSQL từ cơ bản đến nâng cao.

## 📊 Tổng Quan Lộ Trình

```
PREREQUISITES (Tuần 1-2)
    ↓
LEVEL 1: FUNDAMENTALS (Tuần 3-6)
    ↓
LEVEL 2: INTERMEDIATE (Tuần 7-11)
    ↓
LEVEL 3: ADVANCED (Tuần 12-17)
    ↓
CAPSTONE PROJECT (Tuần 18-20)
```

---

## 📅 CHI TIẾT TỪNG TUẦN

### **TUẦN 1-2: PREREQUISITES**

#### Tuần 1: SQL Fundamentals & Database Concepts

| Ngày | Nội Dung | Thời Gian | Checkpoint |
|-----|---------|----------|-----------|
| T2-T3 | `prerequisites/01-sql-fundamentals/01-theory.md` | 2 giờ | Hiểu SELECT, INSERT, UPDATE, DELETE |
| T4-T5 | `prerequisites/01-sql-fundamentals/02-practice.md` | 2 giờ | Thực hành basic queries |
| T6-T7 | `prerequisites/01-sql-fundamentals/03-exercises.md` | 3 giờ | Hoàn thành 8-10 bài tập |
| T1 | `prerequisites/02-database-concepts/01-theory.md` | 2 giờ | Hiểu Tables, Schemas, Keys |

#### Tuần 2: PostgreSQL Setup & Installation

| Ngày | Nội Dung | Thời Gian | Checkpoint |
|-----|---------|----------|-----------|
| T2-T3 | `prerequisites/02-database-concepts/02-practice.md` | 2 giờ | Thực hành database concepts |
| T4-T5 | `prerequisites/02-database-concepts/03-exercises.md` | 3 giờ | Hoàn thành exercises |
| T6-T7 | `prerequisites/03-postgresql-setup/01-theory.md` | 2 giờ | Hiểu PostgreSQL architecture |
| T1 | `prerequisites/03-postgresql-setup/02-practice.md` + `03-exercises.md` | 3 giờ | Setup PostgreSQL, psql, pgAdmin |

**Checkpoint Tuần 2:** ✅ Có thể kết nối PostgreSQL, tạo database, viết basic queries

---

### **TUẦN 3-6: LEVEL 1 - FUNDAMENTALS**

#### Tuần 3: Joins & Subqueries + Aggregate Functions

| Ngày | Nội Dung | Thời Gian | Checkpoint |
|-----|---------|----------|-----------|
| T2-T3 | `level-1-fundamentals/01-joins-and-subqueries/01-theory.md` | 2 giờ | Hiểu INNER, LEFT, RIGHT, FULL OUTER JOIN |
| T4-T5 | `level-1-fundamentals/01-joins-and-subqueries/02-practice.md` | 2 giờ | Thực hành joins & subqueries |
| T6-T7 | `level-1-fundamentals/01-joins-and-subqueries/03-exercises.md` | 2 giờ | Hoàn thành exercises |
| T1 | `level-1-fundamentals/02-aggregate-functions-and-group-by/01-theory.md` | 2 giờ | Hiểu COUNT, SUM, AVG, GROUP BY, HAVING |

#### Tuần 4: Aggregate Functions + Indexes & Performance

| Ngày | Nội Dung | Thời Gian | Checkpoint |
|-----|---------|----------|-----------|
| T2-T3 | `level-1-fundamentals/02-aggregate-functions-and-group-by/02-practice.md` | 2 giờ | Thực hành aggregate functions |
| T4-T5 | `level-1-fundamentals/02-aggregate-functions-and-group-by/03-exercises.md` | 2 giờ | Hoàn thành exercises |
| T6-T7 | `level-1-fundamentals/03-indexes-and-performance/01-theory.md` | 2 giờ | Hiểu CREATE INDEX, B-tree, EXPLAIN |
| T1 | `level-1-fundamentals/03-indexes-and-performance/02-practice.md` | 2 giờ | Tạo indexes & đo performance |

#### Tuần 5: Views & Stored Procedures + Transactions & ACID

| Ngày | Nội Dung | Thời Gian | Checkpoint |
|-----|---------|----------|-----------|
| T2-T3 | `level-1-fundamentals/04-views-and-stored-procedures/01-theory.md` | 2 giờ | Hiểu CREATE VIEW, CREATE FUNCTION |
| T4-T5 | `level-1-fundamentals/04-views-and-stored-procedures/02-practice.md` | 2 giờ | Tạo views & procedures |
| T6-T7 | `level-1-fundamentals/05-transactions-and-acid/01-theory.md` | 2 giờ | Hiểu ACID, BEGIN, COMMIT, ROLLBACK |
| T1 | `level-1-fundamentals/05-transactions-and-acid/02-practice.md` | 2 giờ | Thực hành transactions |

#### Tuần 6: Data Manipulation & Optimization + Projects

| Ngày | Nội Dung | Thời Gian | Checkpoint |
|-----|---------|----------|-----------|
| T2-T3 | `level-1-fundamentals/06-data-manipulation-and-optimization/01-theory.md` | 2 giờ | Hiểu INSERT, UPDATE, DELETE, UPSERT |
| T4-T5 | `level-1-fundamentals/06-data-manipulation-and-optimization/02-practice.md` | 2 giờ | Thực hành data manipulation |
| T6-T7 | `level-1-fundamentals/projects/01-ecommerce-database-design/` | 4 giờ | Hoàn thành E-Commerce Database project |
| T1 | Review & Consolidation | 2 giờ | Ôn tập Level 1 |

**Checkpoint Tuần 6:** ✅ Hoàn thành Level 1, có thể xây dựng database cơ bản

---

### **TUẦN 7-11: LEVEL 2 - INTERMEDIATE**

#### Tuần 7: Window Functions + Common Table Expressions

| Ngày | Nội Dung | Thời Gian | Checkpoint |
|-----|---------|----------|-----------|
| T2-T3 | `level-2-intermediate/01-window-functions/01-theory.md` | 2 giờ | Hiểu ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD |
| T4-T5 | `level-2-intermediate/01-window-functions/02-practice.md` | 2 giờ | Thực hành window functions |
| T6-T7 | `level-2-intermediate/02-common-table-expressions/01-theory.md` | 2 giờ | Hiểu WITH clause, Recursive CTEs |
| T1 | `level-2-intermediate/02-common-table-expressions/02-practice.md` | 2 giờ | Thực hành CTEs |

#### Tuần 8: Advanced Joins & Set Operations + JSON & JSONB

| Ngày | Nội Dung | Thời Gian | Checkpoint |
|-----|---------|----------|-----------|
| T2-T3 | `level-2-intermediate/03-advanced-joins-and-set-operations/01-theory.md` | 2 giờ | Hiểu UNION, INTERSECT, EXCEPT |
| T4-T5 | `level-2-intermediate/03-advanced-joins-and-set-operations/02-practice.md` | 2 giờ | Thực hành advanced joins |
| T6-T7 | `level-2-intermediate/04-json-and-jsonb/01-theory.md` | 2 giờ | Hiểu JSON, JSONB, operators |
| T1 | `level-2-intermediate/04-json-and-jsonb/02-practice.md` | 2 giờ | Làm việc với JSON data |

#### Tuần 9: Full-Text Search + Partitioning & Sharding

| Ngày | Nội Dung | Thời Gian | Checkpoint |
|-----|---------|----------|-----------|
| T2-T3 | `level-2-intermediate/05-full-text-search/01-theory.md` | 2 giờ | Hiểu tsvector, to_tsquery, GIN indexes |
| T4-T5 | `level-2-intermediate/05-full-text-search/02-practice.md` | 2 giờ | Implement full-text search |
| T6-T7 | `level-2-intermediate/06-partitioning-and-sharding/01-theory.md` | 2 giờ | Hiểu Table Partitioning |
| T1 | `level-2-intermediate/06-partitioning-and-sharding/02-practice.md` | 2 giờ | Thực hành partitioning |

#### Tuần 10: Replication & Backup + Projects

| Ngày | Nội Dung | Thời Gian | Checkpoint |
|-----|---------|----------|-----------|
| T2-T3 | `level-2-intermediate/07-replication-and-backup/01-theory.md` | 2 giờ | Hiểu pg_dump, pg_restore, Replication |
| T4-T5 | `level-2-intermediate/07-replication-and-backup/02-practice.md` | 2 giờ | Thực hành backup & restore |
| T6-T7 | `level-2-intermediate/projects/01-advanced-analytics-platform/` | 4 giờ | Hoàn thành Analytics Platform |
| T1 | Review & Consolidation | 2 giờ | Ôn tập Level 2 |

#### Tuần 11: Projects + Review

| Ngày | Nội Dung | Thời Gian | Checkpoint |
|-----|---------|----------|-----------|
| T2-T5 | `level-2-intermediate/projects/02-high-performance-search-engine/` + `03-scalable-multi-tenant-system/` | 8 giờ | Hoàn thành 2 projects |
| T6-T7 | Review & Consolidation | 3 giờ | Ôn tập Level 2 |

**Checkpoint Tuần 11:** ✅ Hoàn thành Level 2, có thể xây dựng database phức tạp

---

### **TUẦN 12-17: LEVEL 3 - ADVANCED**

#### Tuần 12: Query Optimization & EXPLAIN + Stored Procedures & Functions

| Ngày | Nội Dung | Thời Gian | Checkpoint |
|-----|---------|----------|-----------|
| T2-T3 | `level-3-advanced/01-query-optimization-and-explain/01-theory.md` | 2 giờ | Hiểu EXPLAIN, EXPLAIN ANALYZE, Query Plans |
| T4-T5 | `level-3-advanced/01-query-optimization-and-explain/02-practice.md` | 2 giờ | Phân tích & optimize queries |
| T6-T7 | `level-3-advanced/02-stored-procedures-and-functions/01-theory.md` | 2 giờ | Hiểu PL/pgSQL, CREATE FUNCTION, CREATE PROCEDURE |
| T1 | `level-3-advanced/02-stored-procedures-and-functions/02-practice.md` | 2 giờ | Viết stored procedures & functions |

#### Tuần 13: Triggers & Event Handling + Security & Access Control

| Ngày | Nội Dung | Thời Gian | Checkpoint |
|-----|---------|----------|-----------|
| T2-T3 | `level-3-advanced/03-triggers-and-event-handling/01-theory.md` | 2 giờ | Hiểu CREATE TRIGGER, BEFORE/AFTER, ROW/STATEMENT |
| T4-T5 | `level-3-advanced/03-triggers-and-event-handling/02-practice.md` | 2 giờ | Tạo triggers & automation |
| T6-T7 | `level-3-advanced/04-security-and-access-control/01-theory.md` | 2 giờ | Hiểu Roles, Permissions, RLS |
| T1 | `level-3-advanced/04-security-and-access-control/02-practice.md` | 2 giờ | Implement security & access control |

#### Tuần 14: Monitoring & Logging + Concurrency & Locking

| Ngày | Nội Dung | Thời Gian | Checkpoint |
|-----|---------|----------|-----------|
| T2-T3 | `level-3-advanced/05-monitoring-and-logging/01-theory.md` | 2 giờ | Hiểu pg_stat_statements, Monitoring |
| T4-T5 | `level-3-advanced/05-monitoring-and-logging/02-practice.md` | 2 giờ | Setup monitoring & logging |
| T6-T7 | `level-3-advanced/06-concurrency-and-locking/01-theory.md` | 2 giờ | Hiểu Transactions, Isolation Levels, Locks |
| T1 | `level-3-advanced/06-concurrency-and-locking/02-practice.md` | 2 giờ | Thực hành concurrency & locking |

#### Tuần 15: Extensions & Advanced Features + Disaster Recovery & HA

| Ngày | Nội Dung | Thời Gian | Checkpoint |
|-----|---------|----------|-----------|
| T2-T3 | `level-3-advanced/07-extensions-and-advanced-features/01-theory.md` | 2 giờ | Hiểu Extensions, UUID, Array, JSONB |
| T4-T5 | `level-3-advanced/07-extensions-and-advanced-features/02-practice.md` | 2 giờ | Sử dụng extensions & advanced features |
| T6-T7 | `level-3-advanced/08-disaster-recovery-and-ha/01-theory.md` | 2 giờ | Hiểu Backup, Recovery, Replication, HA |
| T1 | `level-3-advanced/08-disaster-recovery-and-ha/02-practice.md` | 2 giờ | Setup disaster recovery & HA |

#### Tuần 16-17: Projects + Review

| Ngày | Nội Dung | Thời Gian | Checkpoint |
|-----|---------|----------|-----------|
| T2-T5 (Tuần 16) | `level-3-advanced/projects/01-enterprise-database-system/` | 4 giờ | Hoàn thành Enterprise Database System |
| T6-T7 (Tuần 16) | `level-3-advanced/projects/02-real-time-analytics-platform/` | 4 giờ | Hoàn thành Real-Time Analytics Platform |
| T2-T5 (Tuần 17) | `level-3-advanced/projects/03-multi-tenant-saas-application/` | 4 giờ | Hoàn thành Multi-Tenant SaaS Application |
| T6-T7 (Tuần 17) | Review & Consolidation | 3 giờ | Ôn tập Level 3 |

**Checkpoint Tuần 17:** ✅ Hoàn thành Level 3, có thể xây dựng enterprise systems

---

### **TUẦN 18-20: CAPSTONE PROJECT - Global E-Commerce Platform**

#### Tuần 18: Requirements & Schema Design

| Ngày | Nội Dung | Thời Gian | Checkpoint |
|-----|---------|----------|-----------|
| T2-T3 | `capstone-project/README.md` | 2 giờ | Hiểu project requirements |
| T4-T5 | `capstone-project/solution.sql` (Task 1-2) | 3 giờ | Thiết kế schema & load data |
| T6-T7 | `capstone-project/IMPLEMENTATION_GUIDE.md` (Phase 1-2) | 3 giờ | Setup database & verify |
| T1 | Review schema design | 2 giờ | Validate design |

#### Tuần 19: Implementation & Optimization

| Ngày | Nội Dung | Thời Gian | Checkpoint |
|-----|---------|----------|-----------|
| T2-T3 | `capstone-project/solution.sql` (Task 3-5) | 3 giờ | Functions, Triggers, Security |
| T4-T5 | `capstone-project/solution.sql` (Task 6-8) | 3 giờ | Performance, Monitoring, Concurrency |
| T6-T7 | `capstone-project/IMPLEMENTATION_GUIDE.md` (Phase 3-6) | 3 giờ | Testing & Optimization |
| T1 | Testing & Validation | 2 giờ | Verify all features |

#### Tuần 20: Disaster Recovery & Final Review

| Ngày | Nội Dung | Thời Gian | Checkpoint |
|-----|---------|----------|-----------|
| T2-T3 | `capstone-project/solution.sql` (Task 9-10) | 3 giờ | Disaster Recovery & HA |
| T4-T5 | `capstone-project/TROUBLESHOOTING_GUIDE.md` | 3 giờ | Review troubleshooting guide |
| T6-T7 | Final Review & Presentation | 3 giờ | Review & celebrate! 🎉 |

**Checkpoint Tuần 20:** ✅ Hoàn thành Capstone Project, sẵn sàng cho production!

---

## 📊 Tóm Tắt Lộ Trình

| Giai Đoạn | Tuần | Modules | Projects | Tổng Giờ | Nội Dung |
|-----------|-----|---------|----------|----------|---------|
| Prerequisites | 1-2 | 3 | 0 | 30 | SQL Fundamentals, Database Concepts, PostgreSQL Setup |
| Level 1 | 3-6 | 6 | 3 | 60 | Joins, Aggregations, Indexes, Views, Transactions, Data Manipulation |
| Level 2 | 7-11 | 7 | 3 | 80 | Window Functions, CTEs, Advanced Joins, JSON, Full-Text Search, Partitioning, Replication |
| Level 3 | 12-17 | 8 | 3 | 100 | Query Optimization, Procedures, Triggers, Security, Monitoring, Concurrency, Extensions, DR/HA |
| Capstone | 18-20 | - | 1 | 50 | Global E-Commerce Platform (All Advanced Features) |
| **Tổng Cộng** | **20** | **24** | **10** | **320** | **Comprehensive PostgreSQL Mastery** |

---

## 🎯 Milestones & Checkpoints

- ✅ **Tuần 2:** Hoàn thành Prerequisites
- ✅ **Tuần 6:** Hoàn thành Level 1
- ✅ **Tuần 11:** Hoàn thành Level 2
- ✅ **Tuần 17:** Hoàn thành Level 3
- ✅ **Tuần 20:** Hoàn thành Capstone Project

---

## 💡 Tips Để Thành Công

1. **Đừng bỏ qua Prerequisites** - Nền tảng rất quan trọng
2. **Code theo từng bước** - Không copy-paste
3. **Làm tất cả exercises** - Thực hành là chìa khóa
4. **Hoàn thành projects** - Áp dụng kiến thức thực tế
5. **Ôn tập thường xuyên** - Consolidate learning
6. **Tham khảo best practices** - Học cách làm đúng
7. **Đừng vội vàng** - Chất lượng hơn tốc độ

---

**Chúc bạn hoàn thành lộ trình thành công! 🚀**

