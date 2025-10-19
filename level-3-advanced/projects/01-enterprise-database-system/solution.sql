-- ============================================
-- Project 1: Enterprise Database System
-- ============================================

-- Task 1: Create Database & Tables
-- ============================================

CREATE DATABASE IF NOT EXISTS enterprise_db;
\c enterprise_db

-- Create companies table
CREATE TABLE companies (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  industry VARCHAR(100),
  founded_year INT,
  headquarters VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create departments table
CREATE TABLE departments (
  id SERIAL PRIMARY KEY,
  company_id INT NOT NULL REFERENCES companies(id),
  name VARCHAR(255) NOT NULL,
  budget DECIMAL(12, 2),
  employee_count INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create employees table
CREATE TABLE employees (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id INT NOT NULL REFERENCES companies(id),
  department_id INT NOT NULL REFERENCES departments(id),
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE,
  position VARCHAR(100),
  salary DECIMAL(10, 2),
  skills TEXT[],
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create projects table
CREATE TABLE projects (
  id SERIAL PRIMARY KEY,
  company_id INT NOT NULL REFERENCES companies(id),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  status VARCHAR(50) DEFAULT 'Planning',
  budget DECIMAL(12, 2),
  start_date DATE,
  end_date DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create audit_logs table
CREATE TABLE audit_logs (
  id SERIAL PRIMARY KEY,
  table_name VARCHAR(100),
  action VARCHAR(50),
  old_data JSONB,
  new_data JSONB,
  changed_by VARCHAR(255),
  changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_departments_company_id ON departments(company_id);
CREATE INDEX idx_employees_company_id ON employees(company_id);
CREATE INDEX idx_employees_department_id ON employees(department_id);
CREATE INDEX idx_employees_email ON employees(email);
CREATE INDEX idx_projects_company_id ON projects(company_id);
CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_audit_logs_table ON audit_logs(table_name);

-- Task 2: Insert Sample Data
-- ============================================

-- Insert companies
INSERT INTO companies (name, industry, founded_year, headquarters) VALUES
('Acme Corp', 'Technology', 2010, 'San Francisco'),
('Global Industries', 'Manufacturing', 1995, 'New York'),
('Tech Innovations', 'Software', 2018, 'Seattle');

-- Insert departments
INSERT INTO departments (company_id, name, budget) VALUES
(1, 'Engineering', 500000),
(1, 'Sales', 300000),
(2, 'Operations', 400000),
(3, 'R&D', 600000);

-- Insert employees
INSERT INTO employees (company_id, department_id, name, email, position, salary, skills, metadata) VALUES
(1, 1, 'John Smith', 'john@acme.com', 'Senior Engineer', 120000, ARRAY['PostgreSQL', 'Python', 'AWS'], '{"level": "senior"}'),
(1, 1, 'Jane Doe', 'jane@acme.com', 'Engineer', 90000, ARRAY['PostgreSQL', 'Java'], '{"level": "mid"}'),
(1, 2, 'Bob Johnson', 'bob@acme.com', 'Sales Manager', 100000, ARRAY['Sales', 'CRM'], '{"level": "manager"}'),
(2, 3, 'Alice Brown', 'alice@global.com', 'Operations Lead', 95000, ARRAY['Operations', 'Logistics'], '{"level": "lead"}'),
(3, 4, 'Charlie Wilson', 'charlie@tech.com', 'Research Scientist', 110000, ARRAY['ML', 'Python', 'TensorFlow'], '{"level": "senior"}');

-- Insert projects
INSERT INTO projects (company_id, name, description, status, budget, start_date, end_date) VALUES
(1, 'Cloud Migration', 'Migrate to cloud infrastructure', 'In Progress', 250000, '2024-01-01', '2024-06-30'),
(1, 'Mobile App', 'Develop mobile application', 'Planning', 150000, '2024-03-01', '2024-12-31'),
(2, 'Factory Automation', 'Automate manufacturing process', 'In Progress', 500000, '2024-02-01', '2024-08-31'),
(3, 'AI Platform', 'Build AI platform', 'Planning', 300000, '2024-04-01', '2025-03-31');

-- Task 3: Create Functions & Procedures
-- ============================================

-- Function: Calculate employee salary with bonus
CREATE OR REPLACE FUNCTION calculate_total_compensation(emp_id UUID, bonus_percent DECIMAL DEFAULT 0)
RETURNS DECIMAL AS $$
DECLARE
  base_salary DECIMAL;
  total_comp DECIMAL;
BEGIN
  SELECT salary INTO base_salary FROM employees WHERE id = emp_id;
  total_comp := base_salary * (1 + bonus_percent / 100);
  RETURN total_comp;
END;
$$ LANGUAGE plpgsql;

-- Procedure: Get department statistics
CREATE OR REPLACE PROCEDURE get_department_stats(dept_id INT, OUT emp_count INT, OUT avg_salary DECIMAL, OUT total_salary DECIMAL)
AS $$
BEGIN
  SELECT COUNT(*), AVG(salary), SUM(salary)
  INTO emp_count, avg_salary, total_salary
  FROM employees WHERE department_id = dept_id;
END;
$$ LANGUAGE plpgsql;

-- Function: Get project status report
CREATE OR REPLACE FUNCTION get_project_report(proj_id INT)
RETURNS TABLE(project_name VARCHAR, status VARCHAR, budget DECIMAL, days_remaining INT) AS $$
BEGIN
  RETURN QUERY
  SELECT name, status, budget, (end_date - CURRENT_DATE)::INT
  FROM projects WHERE id = proj_id;
END;
$$ LANGUAGE plpgsql;

-- Task 4: Implement Triggers
-- ============================================

-- Trigger function: Audit logging
CREATE OR REPLACE FUNCTION audit_log_trigger() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_logs (table_name, action, old_data, new_data, changed_at)
  VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), row_to_json(NEW), CURRENT_TIMESTAMP);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create audit triggers
CREATE TRIGGER audit_employees
AFTER INSERT OR UPDATE OR DELETE ON employees
FOR EACH ROW EXECUTE FUNCTION audit_log_trigger();

CREATE TRIGGER audit_projects
AFTER INSERT OR UPDATE OR DELETE ON projects
FOR EACH ROW EXECUTE FUNCTION audit_log_trigger();

-- Trigger function: Update timestamp
CREATE OR REPLACE FUNCTION update_timestamp() RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at := CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create timestamp triggers
CREATE TRIGGER update_employees_timestamp
BEFORE UPDATE ON employees
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_projects_timestamp
BEFORE UPDATE ON projects
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- Task 5: Implement Security
-- ============================================

-- Create roles
CREATE ROLE admin_role WITH CREATEDB CREATEROLE;
CREATE ROLE manager_role;
CREATE ROLE employee_role;

-- Grant permissions
GRANT ALL ON ALL TABLES IN SCHEMA public TO admin_role;
GRANT SELECT, INSERT, UPDATE ON employees, projects TO manager_role;
GRANT SELECT ON employees, projects TO employee_role;

-- Enable RLS on employees
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;

-- Create RLS policy
CREATE POLICY employee_access ON employees
FOR SELECT USING (true);

-- Task 6: Setup Monitoring
-- ============================================

-- Create monitoring view
CREATE OR REPLACE VIEW v_employee_summary AS
SELECT 
  c.name AS company,
  d.name AS department,
  COUNT(e.id) AS employee_count,
  AVG(e.salary) AS avg_salary,
  MAX(e.salary) AS max_salary,
  MIN(e.salary) AS min_salary
FROM companies c
LEFT JOIN departments d ON c.id = d.company_id
LEFT JOIN employees e ON d.id = e.department_id
GROUP BY c.id, c.name, d.id, d.name;

-- Create project summary view
CREATE OR REPLACE VIEW v_project_summary AS
SELECT 
  c.name AS company,
  p.name AS project,
  p.status,
  p.budget,
  (p.end_date - CURRENT_DATE) AS days_remaining
FROM companies c
LEFT JOIN projects p ON c.id = p.company_id
ORDER BY p.end_date;

-- Task 7: Implement Concurrency
-- ============================================

-- Example: Transaction with lock ordering
-- BEGIN;
-- UPDATE employees SET salary = salary * 1.1 WHERE id = '...';
-- UPDATE projects SET budget = budget * 1.05 WHERE id = 1;
-- COMMIT;

-- Task 8: Backup & Recovery
-- ============================================

-- Backup command (run from shell):
-- pg_dump -U postgres -d enterprise_db -Fc > enterprise_db_backup.dump

-- Restore command (run from shell):
-- pg_restore -U postgres -d enterprise_db enterprise_db_backup.dump

-- Verify data
SELECT COUNT(*) AS company_count FROM companies;
SELECT COUNT(*) AS employee_count FROM employees;
SELECT COUNT(*) AS project_count FROM projects;
SELECT COUNT(*) AS audit_count FROM audit_logs;

