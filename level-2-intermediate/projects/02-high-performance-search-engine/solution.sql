-- ============================================
-- Project 2: High-Performance Search Engine
-- ============================================

-- Task 1: Create Database & Tables
-- ============================================

CREATE DATABASE IF NOT EXISTS search_engine;
\c search_engine

-- Authors table
CREATE TABLE IF NOT EXISTS authors (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Documents table
CREATE TABLE IF NOT EXISTS documents (
  id SERIAL PRIMARY KEY,
  title VARCHAR(500) NOT NULL,
  content TEXT NOT NULL,
  category VARCHAR(100),
  author_id INT NOT NULL REFERENCES authors(id),
  search_vector tsvector,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tags table
CREATE TABLE IF NOT EXISTS tags (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL
);

-- Document tags junction table
CREATE TABLE IF NOT EXISTS document_tags (
  document_id INT NOT NULL REFERENCES documents(id),
  tag_id INT NOT NULL REFERENCES tags(id),
  PRIMARY KEY (document_id, tag_id)
);

-- Search logs table
CREATE TABLE IF NOT EXISTS search_logs (
  id SERIAL PRIMARY KEY,
  query VARCHAR(500) NOT NULL,
  results_count INT,
  execution_time DECIMAL(10, 3),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_documents_author_id ON documents(author_id);
CREATE INDEX idx_documents_category ON documents(category);
CREATE INDEX idx_documents_created_at ON documents(created_at);
CREATE INDEX idx_documents_search ON documents USING GIN (search_vector);
CREATE INDEX idx_document_tags_tag_id ON document_tags(tag_id);
CREATE INDEX idx_search_logs_created_at ON search_logs(created_at);

-- Task 2: Insert Sample Data
-- ============================================

INSERT INTO authors (name, email) VALUES
  ('John Doe', 'john@example.com'),
  ('Jane Smith', 'jane@example.com'),
  ('Bob Johnson', 'bob@example.com'),
  ('Alice Williams', 'alice@example.com'),
  ('Charlie Brown', 'charlie@example.com');

INSERT INTO documents (title, content, category, author_id) VALUES
  ('PostgreSQL Basics', 'Learn PostgreSQL fundamentals including tables, queries, and indexes. PostgreSQL is a powerful open-source database.', 'Database', 1),
  ('Advanced SQL Techniques', 'Master advanced SQL including window functions, CTEs, and complex joins. SQL is essential for data analysis.', 'Database', 2),
  ('Web Development with PostgreSQL', 'Build web applications using PostgreSQL as backend. Learn how to design efficient databases for web apps.', 'Web', 3),
  ('Full-Text Search in PostgreSQL', 'Implement full-text search using tsvector and tsquery. Optimize search performance with indexes.', 'Database', 1),
  ('JSON Data in PostgreSQL', 'Store and query JSON data efficiently. Learn JSONB for better performance and flexibility.', 'Database', 4),
  ('Database Performance Tuning', 'Optimize database performance through indexing, query optimization, and monitoring.', 'Database', 2),
  ('Web API Design', 'Design RESTful APIs for web applications. Learn best practices for API development.', 'Web', 5),
  ('Data Analysis with SQL', 'Analyze data using SQL aggregations, window functions, and statistical functions.', 'Analytics', 3);

INSERT INTO tags (name) VALUES
  ('database'),
  ('sql'),
  ('postgresql'),
  ('web'),
  ('development'),
  ('performance'),
  ('json'),
  ('search'),
  ('api'),
  ('analytics');

INSERT INTO document_tags (document_id, tag_id) VALUES
  (1, 1), (1, 2), (1, 3),
  (2, 1), (2, 2), (2, 3),
  (3, 1), (3, 4), (3, 5),
  (4, 1), (4, 2), (4, 3), (4, 8),
  (5, 1), (5, 3), (5, 7),
  (6, 1), (6, 6),
  (7, 4), (7, 9),
  (8, 1), (8, 2), (8, 10);

-- Task 3: Create Full-Text Search
-- ============================================

-- Update search vectors
UPDATE documents 
SET search_vector = to_tsvector('english', title || ' ' || content);

-- Create trigger to auto-update search_vector
CREATE OR REPLACE FUNCTION documents_search_update() RETURNS trigger AS $$
BEGIN
  NEW.search_vector := to_tsvector('english', NEW.title || ' ' || NEW.content);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER documents_search_trigger
BEFORE INSERT OR UPDATE ON documents
FOR EACH ROW
EXECUTE FUNCTION documents_search_update();

-- Task 4: Full-Text Search Queries
-- ============================================

-- Simple search with ranking
SELECT 
  id,
  title,
  category,
  ts_rank(search_vector, query) AS rank,
  ts_headline('english', title, query) AS headline
FROM documents,
to_tsquery('english', 'postgresql') query
WHERE search_vector @@ query
ORDER BY rank DESC;

-- Multi-field search with filters
SELECT 
  d.id,
  d.title,
  d.category,
  a.name AS author,
  ts_rank(d.search_vector, query) AS rank
FROM documents d
JOIN authors a ON d.author_id = a.id,
to_tsquery('english', 'database & sql') query
WHERE d.search_vector @@ query
  AND d.category = 'Database'
ORDER BY rank DESC;

-- Search with tags
SELECT 
  d.id,
  d.title,
  d.category,
  STRING_AGG(t.name, ', ') AS tags,
  ts_rank(d.search_vector, query) AS rank
FROM documents d
LEFT JOIN document_tags dt ON d.id = dt.document_id
LEFT JOIN tags t ON dt.tag_id = t.id,
to_tsquery('english', 'postgresql') query
WHERE d.search_vector @@ query
GROUP BY d.id, d.title, d.category, d.search_vector, query
ORDER BY rank DESC;

-- Task 5: Advanced Search Queries
-- ============================================

-- Faceted search
SELECT 
  category,
  COUNT(*) AS document_count,
  COUNT(CASE WHEN search_vector @@ to_tsquery('postgresql') THEN 1 END) AS matching_count
FROM documents
GROUP BY category
ORDER BY document_count DESC;

-- Search with pagination
SELECT 
  id,
  title,
  category,
  ts_rank(search_vector, query) AS rank
FROM documents,
to_tsquery('english', 'database') query
WHERE search_vector @@ query
ORDER BY rank DESC
LIMIT 10 OFFSET 0;

-- Task 6: Search Analytics
-- ============================================

-- Log search query
INSERT INTO search_logs (query, results_count, execution_time)
SELECT 
  'postgresql',
  COUNT(*),
  0.123
FROM documents
WHERE search_vector @@ to_tsquery('postgresql');

-- Popular searches
SELECT 
  query,
  COUNT(*) AS search_count,
  AVG(results_count) AS avg_results
FROM search_logs
WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY query
ORDER BY search_count DESC
LIMIT 10;

-- Search trends
SELECT 
  DATE(created_at) AS search_date,
  COUNT(*) AS total_searches,
  AVG(results_count) AS avg_results
FROM search_logs
WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY DATE(created_at)
ORDER BY search_date DESC;

-- Task 7: Create Views
-- ============================================

-- Search results view
CREATE OR REPLACE VIEW v_search_results AS
SELECT 
  d.id,
  d.title,
  d.content,
  d.category,
  a.name AS author,
  STRING_AGG(t.name, ', ') AS tags,
  d.created_at
FROM documents d
JOIN authors a ON d.author_id = a.id
LEFT JOIN document_tags dt ON d.id = dt.document_id
LEFT JOIN tags t ON dt.tag_id = t.id
GROUP BY d.id, d.title, d.content, d.category, a.name, d.created_at;

-- Popular searches view
CREATE OR REPLACE VIEW v_popular_searches AS
SELECT 
  query,
  COUNT(*) AS search_count,
  AVG(results_count) AS avg_results,
  MAX(created_at) AS last_searched
FROM search_logs
WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY query
ORDER BY search_count DESC;

-- Search analytics view
CREATE OR REPLACE VIEW v_search_analytics AS
SELECT 
  DATE(created_at) AS search_date,
  COUNT(*) AS total_searches,
  COUNT(DISTINCT query) AS unique_queries,
  AVG(results_count) AS avg_results,
  MIN(execution_time) AS min_time,
  MAX(execution_time) AS max_time,
  AVG(execution_time) AS avg_time
FROM search_logs
GROUP BY DATE(created_at)
ORDER BY search_date DESC;

-- Task 8: Verify Results
-- ============================================

-- Check documents
SELECT COUNT(*) AS total_documents FROM documents;

-- Check search vectors
SELECT COUNT(*) AS documents_with_search_vector FROM documents WHERE search_vector IS NOT NULL;

-- Check search logs
SELECT COUNT(*) AS total_searches FROM search_logs;

-- Check popular searches
SELECT * FROM v_popular_searches LIMIT 5;

-- Check search analytics
SELECT * FROM v_search_analytics LIMIT 7;

-- ============================================
-- Project 2 Complete!
-- ============================================

