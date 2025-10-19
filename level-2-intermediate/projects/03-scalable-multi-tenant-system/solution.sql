-- ============================================
-- Project 3: Scalable Multi-Tenant System
-- ============================================

-- Task 1: Create Database & Tables
-- ============================================

CREATE DATABASE IF NOT EXISTS multi_tenant;
\c multi_tenant

-- Tenants table
CREATE TABLE IF NOT EXISTS tenants (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  plan VARCHAR(50) DEFAULT 'basic',
  config JSONB DEFAULT '{}',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Users table (partitioned by tenant_id)
CREATE TABLE IF NOT EXISTS users (
  id SERIAL,
  tenant_id INT NOT NULL REFERENCES tenants(id),
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  role VARCHAR(50) DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id, tenant_id)
) PARTITION BY HASH (tenant_id);

-- Projects table (partitioned by tenant_id)
CREATE TABLE IF NOT EXISTS projects (
  id SERIAL,
  tenant_id INT NOT NULL REFERENCES tenants(id),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  config JSONB DEFAULT '{}',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id, tenant_id)
) PARTITION BY HASH (tenant_id);

-- Tasks table (partitioned by tenant_id)
CREATE TABLE IF NOT EXISTS tasks (
  id SERIAL,
  tenant_id INT NOT NULL REFERENCES tenants(id),
  project_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  status VARCHAR(50) DEFAULT 'pending',
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id, tenant_id)
) PARTITION BY HASH (tenant_id);

-- Audit logs table (partitioned by tenant_id)
CREATE TABLE IF NOT EXISTS audit_logs (
  id SERIAL,
  tenant_id INT NOT NULL REFERENCES tenants(id),
  action VARCHAR(100) NOT NULL,
  details JSONB DEFAULT '{}',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id, tenant_id)
) PARTITION BY HASH (tenant_id);

-- Task 2: Create Partitions
-- ============================================

-- Create partitions for users (4 partitions)
CREATE TABLE users_p0 PARTITION OF users FOR VALUES WITH (MODULUS 4, REMAINDER 0);
CREATE TABLE users_p1 PARTITION OF users FOR VALUES WITH (MODULUS 4, REMAINDER 1);
CREATE TABLE users_p2 PARTITION OF users FOR VALUES WITH (MODULUS 4, REMAINDER 2);
CREATE TABLE users_p3 PARTITION OF users FOR VALUES WITH (MODULUS 4, REMAINDER 3);

-- Create partitions for projects (4 partitions)
CREATE TABLE projects_p0 PARTITION OF projects FOR VALUES WITH (MODULUS 4, REMAINDER 0);
CREATE TABLE projects_p1 PARTITION OF projects FOR VALUES WITH (MODULUS 4, REMAINDER 1);
CREATE TABLE projects_p2 PARTITION OF projects FOR VALUES WITH (MODULUS 4, REMAINDER 2);
CREATE TABLE projects_p3 PARTITION OF projects FOR VALUES WITH (MODULUS 4, REMAINDER 3);

-- Create partitions for tasks (4 partitions)
CREATE TABLE tasks_p0 PARTITION OF tasks FOR VALUES WITH (MODULUS 4, REMAINDER 0);
CREATE TABLE tasks_p1 PARTITION OF tasks FOR VALUES WITH (MODULUS 4, REMAINDER 1);
CREATE TABLE tasks_p2 PARTITION OF tasks FOR VALUES WITH (MODULUS 4, REMAINDER 2);
CREATE TABLE tasks_p3 PARTITION OF tasks FOR VALUES WITH (MODULUS 4, REMAINDER 3);

-- Create partitions for audit_logs (4 partitions)
CREATE TABLE audit_logs_p0 PARTITION OF audit_logs FOR VALUES WITH (MODULUS 4, REMAINDER 0);
CREATE TABLE audit_logs_p1 PARTITION OF audit_logs FOR VALUES WITH (MODULUS 4, REMAINDER 1);
CREATE TABLE audit_logs_p2 PARTITION OF audit_logs FOR VALUES WITH (MODULUS 4, REMAINDER 2);
CREATE TABLE audit_logs_p3 PARTITION OF audit_logs FOR VALUES WITH (MODULUS 4, REMAINDER 3);

-- Create indexes
CREATE INDEX idx_users_tenant_id ON users(tenant_id);
CREATE INDEX idx_projects_tenant_id ON projects(tenant_id);
CREATE INDEX idx_tasks_tenant_id ON tasks(tenant_id);
CREATE INDEX idx_audit_logs_tenant_id ON audit_logs(tenant_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);

-- Task 3: Insert Sample Data
-- ============================================

INSERT INTO tenants (name, plan, config) VALUES
  ('Acme Corp', 'premium', '{"max_users": 100, "max_projects": 50, "storage_gb": 1000}'),
  ('Tech Startup', 'standard', '{"max_users": 20, "max_projects": 10, "storage_gb": 100}'),
  ('Small Business', 'basic', '{"max_users": 5, "max_projects": 3, "storage_gb": 10}'),
  ('Enterprise Inc', 'premium', '{"max_users": 500, "max_projects": 200, "storage_gb": 5000}'),
  ('Freelancer', 'basic', '{"max_users": 1, "max_projects": 5, "storage_gb": 5}');

INSERT INTO users (tenant_id, name, email, role) VALUES
  (1, 'John Doe', 'john@acme.com', 'admin'),
  (1, 'Jane Smith', 'jane@acme.com', 'user'),
  (1, 'Bob Johnson', 'bob@acme.com', 'user'),
  (2, 'Alice Brown', 'alice@startup.com', 'admin'),
  (2, 'Charlie Wilson', 'charlie@startup.com', 'user'),
  (3, 'Diana Prince', 'diana@small.com', 'admin'),
  (4, 'Eve Davis', 'eve@enterprise.com', 'admin'),
  (5, 'Frank Miller', 'frank@freelancer.com', 'admin');

INSERT INTO projects (tenant_id, name, description, config) VALUES
  (1, 'Project Alpha', 'Main enterprise project', '{"budget": 50000, "team_size": 10, "deadline": "2024-12-31"}'),
  (1, 'Project Beta', 'Secondary project', '{"budget": 30000, "team_size": 5, "deadline": "2024-11-30"}'),
  (2, 'Startup MVP', 'MVP development', '{"budget": 10000, "team_size": 3, "deadline": "2024-09-30"}'),
  (3, 'Small Project', 'Local business project', '{"budget": 5000, "team_size": 1, "deadline": "2024-10-31"}'),
  (4, 'Enterprise Platform', 'Large scale platform', '{"budget": 200000, "team_size": 50, "deadline": "2025-06-30"}'),
  (5, 'Freelance Work', 'Client project', '{"budget": 2000, "team_size": 1, "deadline": "2024-09-15"}');

INSERT INTO tasks (tenant_id, project_id, title, status, metadata) VALUES
  (1, 1, 'Design database schema', 'completed', '{"assigned_to": "John Doe", "priority": "high"}'),
  (1, 1, 'Implement API', 'in_progress', '{"assigned_to": "Jane Smith", "priority": "high"}'),
  (1, 2, 'Create UI mockups', 'pending', '{"assigned_to": "Bob Johnson", "priority": "medium"}'),
  (2, 3, 'Setup development environment', 'completed', '{"assigned_to": "Alice Brown", "priority": "high"}'),
  (2, 3, 'Build authentication', 'in_progress', '{"assigned_to": "Charlie Wilson", "priority": "high"}'),
  (3, 4, 'Create website', 'in_progress', '{"assigned_to": "Diana Prince", "priority": "high"}'),
  (4, 5, 'Architecture design', 'completed', '{"assigned_to": "Eve Davis", "priority": "high"}'),
  (5, 6, 'Client requirements', 'completed', '{"assigned_to": "Frank Miller", "priority": "high"}');

-- Task 4: Create Audit Logging
-- ============================================

INSERT INTO audit_logs (tenant_id, action, details) VALUES
  (1, 'user_created', '{"user_id": 1, "email": "john@acme.com"}'),
  (1, 'project_created', '{"project_id": 1, "name": "Project Alpha"}'),
  (2, 'user_created', '{"user_id": 4, "email": "alice@startup.com"}'),
  (3, 'project_created', '{"project_id": 4, "name": "Small Project"}'),
  (4, 'user_created', '{"user_id": 7, "email": "eve@enterprise.com"}');

-- Task 5: Create Tenant-Specific Queries
-- ============================================

-- Get tenant overview
SELECT 
  t.id,
  t.name,
  t.plan,
  COUNT(DISTINCT u.id) AS user_count,
  COUNT(DISTINCT p.id) AS project_count,
  COUNT(DISTINCT ta.id) AS task_count
FROM tenants t
LEFT JOIN users u ON t.id = u.tenant_id
LEFT JOIN projects p ON t.id = p.tenant_id
LEFT JOIN tasks ta ON t.id = ta.tenant_id
GROUP BY t.id, t.name, t.plan
ORDER BY t.id;

-- Get tenant usage
SELECT 
  t.id,
  t.name,
  t.plan,
  t.config->>'max_users' AS max_users,
  COUNT(DISTINCT u.id) AS current_users,
  ROUND(100.0 * COUNT(DISTINCT u.id) / (t.config->>'max_users')::INT, 2) AS user_usage_percent
FROM tenants t
LEFT JOIN users u ON t.id = u.tenant_id
GROUP BY t.id, t.name, t.plan, t.config
ORDER BY user_usage_percent DESC NULLS LAST;

-- Get tenant project statistics
SELECT 
  t.id,
  t.name,
  COUNT(p.id) AS total_projects,
  COUNT(CASE WHEN ta.status = 'completed' THEN 1 END) AS completed_tasks,
  COUNT(CASE WHEN ta.status = 'in_progress' THEN 1 END) AS in_progress_tasks,
  COUNT(CASE WHEN ta.status = 'pending' THEN 1 END) AS pending_tasks
FROM tenants t
LEFT JOIN projects p ON t.id = p.tenant_id
LEFT JOIN tasks ta ON t.id = ta.tenant_id
GROUP BY t.id, t.name
ORDER BY t.id;

-- Task 6: Create Views
-- ============================================

-- Tenant overview view
CREATE OR REPLACE VIEW v_tenant_overview AS
SELECT 
  t.id,
  t.name,
  t.plan,
  COUNT(DISTINCT u.id) AS user_count,
  COUNT(DISTINCT p.id) AS project_count,
  COUNT(DISTINCT ta.id) AS task_count,
  MAX(al.created_at) AS last_activity
FROM tenants t
LEFT JOIN users u ON t.id = u.tenant_id
LEFT JOIN projects p ON t.id = p.tenant_id
LEFT JOIN tasks ta ON t.id = ta.tenant_id
LEFT JOIN audit_logs al ON t.id = al.tenant_id
GROUP BY t.id, t.name, t.plan;

-- Tenant analytics view
CREATE OR REPLACE VIEW v_tenant_analytics AS
SELECT 
  t.id,
  t.name,
  t.plan,
  COUNT(DISTINCT u.id) AS user_count,
  COUNT(DISTINCT p.id) AS project_count,
  COUNT(DISTINCT ta.id) AS task_count,
  COUNT(CASE WHEN ta.status = 'completed' THEN 1 END) AS completed_tasks,
  COUNT(CASE WHEN ta.status = 'in_progress' THEN 1 END) AS in_progress_tasks,
  COUNT(al.id) AS audit_log_count
FROM tenants t
LEFT JOIN users u ON t.id = u.tenant_id
LEFT JOIN projects p ON t.id = p.tenant_id
LEFT JOIN tasks ta ON t.id = ta.tenant_id
LEFT JOIN audit_logs al ON t.id = al.tenant_id
GROUP BY t.id, t.name, t.plan;

-- Task 7: Verify Results
-- ============================================

-- Check tenant overview
SELECT * FROM v_tenant_overview ORDER BY id;

-- Check tenant analytics
SELECT * FROM v_tenant_analytics ORDER BY id;

-- Check partition distribution
SELECT 
  'users' AS table_name,
  COUNT(*) AS row_count
FROM users
UNION ALL
SELECT 'projects', COUNT(*) FROM projects
UNION ALL
SELECT 'tasks', COUNT(*) FROM tasks
UNION ALL
SELECT 'audit_logs', COUNT(*) FROM audit_logs;

-- Check tenant isolation (sample query for tenant 1)
SELECT 
  u.name,
  COUNT(p.id) AS project_count,
  COUNT(ta.id) AS task_count
FROM users u
LEFT JOIN projects p ON u.tenant_id = p.tenant_id
LEFT JOIN tasks ta ON u.tenant_id = ta.tenant_id
WHERE u.tenant_id = 1
GROUP BY u.id, u.name;

-- ============================================
-- Project 3 Complete!
-- ============================================

