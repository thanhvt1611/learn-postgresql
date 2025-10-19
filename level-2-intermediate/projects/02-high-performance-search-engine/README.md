# 🔍 Project 2: High-Performance Search Engine

Xây dựng một high-performance search engine sử dụng Full-Text Search, Indexes, và Advanced Joins.

## 🎯 Mục Tiêu Project

Sau khi hoàn thành project này, bạn sẽ:
- ✅ Sử dụng được Full-Text Search
- ✅ Tạo được GIN indexes
- ✅ Sử dụng được Advanced Joins
- ✅ Tối ưu hóa search queries
- ✅ Implement ranking & relevance

---

## 📋 Project Requirements

### Database Schema

```sql
-- Tables
documents (id, title, content, category, author_id, created_at)
authors (id, name, email, created_at)
tags (id, name)
document_tags (document_id, tag_id)
search_logs (id, query, results_count, created_at)
```

### Features

1. **Full-Text Search**
   - Search by title & content
   - Search with operators (AND, OR, NOT)
   - Ranking by relevance
   - Highlight matches

2. **Advanced Filtering**
   - Filter by category
   - Filter by author
   - Filter by tags
   - Filter by date range

3. **Search Analytics**
   - Track search queries
   - Popular searches
   - Search trends
   - Search performance

4. **Performance Optimization**
   - GIN indexes for FTS
   - Partial indexes
   - Query optimization
   - Caching strategies

---

## 🔧 Tasks

### Task 1: Create Database & Tables
- [ ] Create search_engine database
- [ ] Create all tables with constraints
- [ ] Create indexes for performance

### Task 2: Create Full-Text Search
- [ ] Add tsvector columns
- [ ] Create GIN indexes
- [ ] Create search functions
- [ ] Implement ranking

### Task 3: Create Advanced Queries
- [ ] Multi-field search
- [ ] Filtered search
- [ ] Combined search
- [ ] Faceted search

### Task 4: Create Search Analytics
- [ ] Track search queries
- [ ] Calculate popular searches
- [ ] Analyze search trends
- [ ] Monitor performance

### Task 5: Create Search Views
- [ ] Search results view
- [ ] Popular searches view
- [ ] Search analytics view
- [ ] Performance metrics view

### Task 6: Create Stored Procedures
- [ ] Search procedure
- [ ] Log search procedure
- [ ] Analytics procedure
- [ ] Optimization procedure

### Task 7: Performance Testing
- [ ] Test search performance
- [ ] Analyze query plans
- [ ] Optimize slow queries
- [ ] Benchmark results

---

## 📊 Sample Data

```sql
-- Sample authors
INSERT INTO authors (name, email) VALUES
  ('John Doe', 'john@example.com'),
  ('Jane Smith', 'jane@example.com'),
  ('Bob Johnson', 'bob@example.com');

-- Sample documents
INSERT INTO documents (title, content, category, author_id) VALUES
  ('PostgreSQL Basics', 'Learn PostgreSQL fundamentals...', 'Database', 1),
  ('Advanced SQL', 'Master advanced SQL techniques...', 'Database', 2),
  ('Web Development', 'Build web applications...', 'Web', 3);

-- Sample tags
INSERT INTO tags (name) VALUES
  ('database'),
  ('sql'),
  ('postgresql'),
  ('web'),
  ('development');
```

---

## 🎓 Learning Outcomes

Bạn sẽ học được:
- ✅ Full-Text Search implementation
- ✅ GIN indexes for performance
- ✅ Advanced filtering techniques
- ✅ Search ranking & relevance
- ✅ Search analytics
- ✅ Performance optimization

---

## 📚 Resources

- [PostgreSQL Full-Text Search](https://www.postgresql.org/docs/current/textsearch.html)
- [PostgreSQL Indexes](https://www.postgresql.org/docs/current/indexes.html)
- [PostgreSQL Query Performance](https://www.postgresql.org/docs/current/performance-tips.html)

---

## ✅ Completion Checklist

- [ ] Database & tables created
- [ ] Full-text search working
- [ ] Advanced queries working
- [ ] Search analytics working
- [ ] Views created
- [ ] Stored procedures created
- [ ] Performance optimized
- [ ] All tasks completed

---

**Hãy bắt đầu với solution.sql để xem implementation! 🚀**

