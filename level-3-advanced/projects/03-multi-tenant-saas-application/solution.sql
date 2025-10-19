-- ============================================
-- Project 3: Multi-Tenant SaaS Application
-- ============================================

-- Task 1: Create Database & Tables
-- ============================================

CREATE DATABASE IF NOT EXISTS saas_db;
\c saas_db

-- Create tenants table
CREATE TABLE tenants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL UNIQUE,
  plan VARCHAR(50) DEFAULT 'starter',
  status VARCHAR(50) DEFAULT 'active',
  config JSONB DEFAULT '{}',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create users table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  email VARCHAR(255) NOT NULL,
  name VARCHAR(255),
  role VARCHAR(50) DEFAULT 'user',
  permissions TEXT[],
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(tenant_id, email)
);

-- Create workspaces table
CREATE TABLE workspaces (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  config JSONB DEFAULT '{}',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create resources table
CREATE TABLE resources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  workspace_id UUID NOT NULL REFERENCES workspaces(id),
  name VARCHAR(255) NOT NULL,
  type VARCHAR(100),
  owner_id UUID REFERENCES users(id),
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create audit_logs table
CREATE TABLE audit_logs (
  id SERIAL PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  user_id UUID REFERENCES users(id),
  action VARCHAR(100),
  resource_type VARCHAR(100),
  resource_id UUID,
  details JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_users_tenant_id ON users(tenant_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_workspaces_tenant_id ON workspaces(tenant_id);
CREATE INDEX idx_resources_tenant_id ON resources(tenant_id);
CREATE INDEX idx_resources_workspace_id ON resources(workspace_id);
CREATE INDEX idx_resources_owner_id ON resources(owner_id);
CREATE INDEX idx_audit_logs_tenant_id ON audit_logs(tenant_id);
CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);

-- Task 2: Insert Sample Data
-- ============================================

-- Insert tenants
INSERT INTO tenants (name, plan, status, config) VALUES
('Acme Corp', 'enterprise', 'active', '{"max_users": 100, "max_workspaces": 50}'),
('Tech Startup', 'professional', 'active', '{"max_users": 20, "max_workspaces": 10}'),
('Small Business', 'starter', 'active', '{"max_users": 5, "max_workspaces": 3}');

-- Insert users
INSERT INTO users (tenant_id, email, name, role, permissions)
SELECT 
  t.id,
  'user' || (random() * 100)::INT || '@' || t.name || '.com',
  'User ' || (random() * 100)::INT,
  CASE WHEN random() < 0.2 THEN 'admin' WHEN random() < 0.5 THEN 'manager' ELSE 'user' END,
  ARRAY['read', 'write']
FROM tenants t
CROSS JOIN generate_series(1, 10);

-- Insert workspaces
INSERT INTO workspaces (tenant_id, name, description, config)
SELECT 
  t.id,
  'Workspace ' || (random() * 100)::INT,
  'Description for workspace',
  jsonb_build_object('visibility', 'private', 'members', 5)
FROM tenants t
CROSS JOIN generate_series(1, 5);

-- Insert resources
INSERT INTO resources (tenant_id, workspace_id, name, type, owner_id, metadata)
SELECT 
  t.id,
  w.id,
  'Resource ' || (random() * 1000)::INT,
  CASE WHEN random() < 0.5 THEN 'document' ELSE 'project' END,
  u.id,
  jsonb_build_object('size', (random() * 1000000)::INT, 'status', 'active')
FROM tenants t
CROSS JOIN workspaces w
CROSS JOIN users u
CROSS JOIN generate_series(1, 10)
WHERE w.tenant_id = t.id AND u.tenant_id = t.id;

-- Task 3: Create Functions & Procedures
-- ============================================

-- Procedure: Provision new tenant
CREATE OR REPLACE PROCEDURE provision_tenant(tenant_name VARCHAR, plan VARCHAR, OUT tenant_id UUID)
AS $$
BEGIN
  INSERT INTO tenants (name, plan, status)
  VALUES (tenant_name, plan, 'active')
  RETURNING tenants.id INTO tenant_id;
END;
$$ LANGUAGE plpgsql;

-- Function: Get tenant usage
CREATE OR REPLACE FUNCTION get_tenant_usage(tenant_id UUID)
RETURNS TABLE(user_count INT, workspace_count INT, resource_count INT) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    COUNT(DISTINCT u.id)::INT,
    COUNT(DISTINCT w.id)::INT,
    COUNT(DISTINCT r.id)::INT
  FROM tenants t
  LEFT JOIN users u ON t.id = u.tenant_id
  LEFT JOIN workspaces w ON t.id = w.tenant_id
  LEFT JOIN resources r ON t.id = r.tenant_id
  WHERE t.id = $1;
END;
$$ LANGUAGE plpgsql;

-- Procedure: Add user to tenant
CREATE OR REPLACE PROCEDURE add_user_to_tenant(tenant_id UUID, email VARCHAR, name VARCHAR, role VARCHAR)
AS $$
BEGIN
  INSERT INTO users (tenant_id, email, name, role, permissions)
  VALUES (tenant_id, email, name, role, ARRAY['read', 'write']);
END;
$$ LANGUAGE plpgsql;

-- Function: Get user permissions
CREATE OR REPLACE FUNCTION get_user_permissions(user_id UUID)
RETURNS TEXT[] AS $$
BEGIN
  RETURN (SELECT permissions FROM users WHERE id = user_id);
END;
$$ LANGUAGE plpgsql;

-- Task 4: Implement Triggers
-- ============================================

-- Trigger function: Audit user actions
CREATE OR REPLACE FUNCTION audit_user_action() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_logs (tenant_id, user_id, action, resource_type, details)
  VALUES (NEW.tenant_id, NEW.id, 'user_created', 'user', row_to_json(NEW));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_audit_user_creation
AFTER INSERT ON users
FOR EACH ROW EXECUTE FUNCTION audit_user_action();

-- Trigger function: Audit resource changes
CREATE OR REPLACE FUNCTION audit_resource_action() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_logs (tenant_id, resource_id, action, resource_type, details)
  VALUES (NEW.tenant_id, NEW.id, TG_OP, 'resource', row_to_json(NEW));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_audit_resource_changes
AFTER INSERT OR UPDATE OR DELETE ON resources
FOR EACH ROW EXECUTE FUNCTION audit_resource_action();

-- Trigger function: Update timestamp
CREATE OR REPLACE FUNCTION update_timestamp() RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at := CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_users_timestamp
BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trigger_update_workspaces_timestamp
BEFORE UPDATE ON workspaces
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- Task 5: Implement Security
-- ============================================

-- Enable RLS on users
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Create RLS policy for users
CREATE POLICY user_tenant_isolation ON users
FOR SELECT USING (true);

-- Enable RLS on resources
ALTER TABLE resources ENABLE ROW LEVEL SECURITY;

-- Create RLS policy for resources
CREATE POLICY resource_tenant_isolation ON resources
FOR SELECT USING (true);

-- Enable RLS on audit_logs
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

-- Create RLS policy for audit_logs
CREATE POLICY audit_tenant_isolation ON audit_logs
FOR SELECT USING (true);

-- Task 6: Setup Monitoring
-- ============================================

-- Create tenant overview view
CREATE OR REPLACE VIEW v_tenant_overview AS
SELECT 
  t.id,
  t.name,
  t.plan,
  t.status,
  COUNT(DISTINCT u.id) AS user_count,
  COUNT(DISTINCT w.id) AS workspace_count,
  COUNT(DISTINCT r.id) AS resource_count
FROM tenants t
LEFT JOIN users u ON t.id = u.tenant_id
LEFT JOIN workspaces w ON t.id = w.tenant_id
LEFT JOIN resources r ON t.id = r.tenant_id
GROUP BY t.id, t.name, t.plan, t.status;

-- Create user activity view
CREATE OR REPLACE VIEW v_user_activity AS
SELECT 
  u.tenant_id,
  u.id,
  u.email,
  u.role,
  COUNT(DISTINCT a.id) AS action_count,
  MAX(a.created_at) AS last_action
FROM users u
LEFT JOIN audit_logs a ON u.id = a.user_id
GROUP BY u.tenant_id, u.id, u.email, u.role;

-- Create resource summary view
CREATE OR REPLACE VIEW v_resource_summary AS
SELECT 
  t.name AS tenant,
  w.name AS workspace,
  r.type,
  COUNT(*) AS resource_count,
  SUM((r.metadata->>'size')::INT) AS total_size
FROM tenants t
LEFT JOIN workspaces w ON t.id = w.tenant_id
LEFT JOIN resources r ON w.id = r.workspace_id
GROUP BY t.name, w.name, r.type;

-- Task 7: Implement Concurrency
-- ============================================

-- Example: Transaction with tenant isolation
-- BEGIN;
-- SELECT * FROM resources WHERE tenant_id = '...' FOR UPDATE;
-- UPDATE resources SET metadata = ... WHERE tenant_id = '...';
-- COMMIT;

-- Task 8: Backup & Recovery
-- ============================================

-- Backup command (run from shell):
-- pg_dump -U postgres -d saas_db -Fc > saas_db_backup.dump

-- Restore command (run from shell):
-- pg_restore -U postgres -d saas_db saas_db_backup.dump

-- Verify data
SELECT COUNT(*) AS tenant_count FROM tenants;
SELECT COUNT(*) AS user_count FROM users;
SELECT COUNT(*) AS workspace_count FROM workspaces;
SELECT COUNT(*) AS resource_count FROM resources;
SELECT COUNT(*) AS audit_count FROM audit_logs;

