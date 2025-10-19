-- ============================================
-- Project 2: Real-Time Analytics Platform
-- ============================================

-- Task 1: Create Database & Tables
-- ============================================

CREATE DATABASE IF NOT EXISTS analytics_db;
\c analytics_db

-- Create users table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  username VARCHAR(255) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  country VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create sessions table
CREATE TABLE sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  device VARCHAR(50),
  browser VARCHAR(50),
  duration_seconds INT,
  started_at TIMESTAMP,
  ended_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create events table
CREATE TABLE events (
  id SERIAL PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id),
  session_id UUID REFERENCES sessions(id),
  event_type VARCHAR(50) NOT NULL,
  event_name VARCHAR(255),
  tags TEXT[],
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create metrics table
CREATE TABLE metrics (
  id SERIAL PRIMARY KEY,
  metric_date DATE,
  metric_type VARCHAR(100),
  metric_value DECIMAL(12, 2),
  dimensions JSONB DEFAULT '{}',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create dashboards table
CREATE TABLE dashboards (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  config JSONB DEFAULT '{}',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_sessions_user_id ON sessions(user_id);
CREATE INDEX idx_sessions_started_at ON sessions(started_at);
CREATE INDEX idx_events_user_id ON events(user_id);
CREATE INDEX idx_events_session_id ON events(session_id);
CREATE INDEX idx_events_event_type ON events(event_type);
CREATE INDEX idx_events_created_at ON events(created_at);
CREATE INDEX idx_metrics_metric_date ON metrics(metric_date);
CREATE INDEX idx_metrics_metric_type ON metrics(metric_type);

-- Task 2: Insert Sample Data
-- ============================================

-- Insert users
INSERT INTO users (username, email, country) VALUES
('user1', 'user1@example.com', 'USA'),
('user2', 'user2@example.com', 'UK'),
('user3', 'user3@example.com', 'Canada'),
('user4', 'user4@example.com', 'USA'),
('user5', 'user5@example.com', 'Australia');

-- Insert sessions
INSERT INTO sessions (user_id, device, browser, duration_seconds, started_at, ended_at)
SELECT 
  u.id,
  CASE WHEN random() < 0.6 THEN 'mobile' ELSE 'desktop' END,
  CASE WHEN random() < 0.5 THEN 'Chrome' ELSE 'Firefox' END,
  (random() * 3600)::INT,
  CURRENT_TIMESTAMP - INTERVAL '1 day' * (random() * 30),
  CURRENT_TIMESTAMP - INTERVAL '1 day' * (random() * 30) + INTERVAL '1 hour'
FROM users u
CROSS JOIN generate_series(1, 10);

-- Insert events
INSERT INTO events (user_id, session_id, event_type, event_name, tags, metadata)
SELECT 
  u.id,
  s.id,
  CASE WHEN random() < 0.4 THEN 'page_view' WHEN random() < 0.7 THEN 'click' ELSE 'purchase' END,
  'Event ' || (random() * 100)::INT,
  ARRAY['tag1', 'tag2'],
  jsonb_build_object('page', '/home', 'value', (random() * 1000)::INT)
FROM users u
CROSS JOIN sessions s
CROSS JOIN generate_series(1, 5);

-- Insert metrics
INSERT INTO metrics (metric_date, metric_type, metric_value, dimensions)
SELECT 
  CURRENT_DATE - INTERVAL '1 day' * (random() * 30),
  CASE WHEN random() < 0.33 THEN 'DAU' WHEN random() < 0.66 THEN 'Sessions' ELSE 'Events' END,
  random() * 10000,
  jsonb_build_object('country', 'USA', 'device', 'mobile')
FROM generate_series(1, 100);

-- Task 3: Create Functions & Procedures
-- ============================================

-- Function: Get daily active users
CREATE OR REPLACE FUNCTION get_daily_active_users(target_date DATE)
RETURNS TABLE(date DATE, active_users INT) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    target_date,
    COUNT(DISTINCT user_id)::INT
  FROM events
  WHERE DATE(created_at) = target_date;
END;
$$ LANGUAGE plpgsql;

-- Procedure: Calculate session metrics
CREATE OR REPLACE PROCEDURE calculate_session_metrics(session_id UUID, OUT total_events INT, OUT session_duration INT)
AS $$
BEGIN
  SELECT COUNT(*), EXTRACT(EPOCH FROM (MAX(created_at) - MIN(created_at)))::INT
  INTO total_events, session_duration
  FROM events WHERE session_id = $1;
END;
$$ LANGUAGE plpgsql;

-- Function: Get user engagement score
CREATE OR REPLACE FUNCTION get_user_engagement_score(user_id UUID)
RETURNS DECIMAL AS $$
DECLARE
  event_count INT;
  session_count INT;
  score DECIMAL;
BEGIN
  SELECT COUNT(*) INTO event_count FROM events WHERE user_id = $1;
  SELECT COUNT(*) INTO session_count FROM sessions WHERE user_id = $1;
  score := (event_count * 0.6 + session_count * 0.4);
  RETURN score;
END;
$$ LANGUAGE plpgsql;

-- Procedure: Generate daily report
CREATE OR REPLACE PROCEDURE generate_daily_report(report_date DATE)
AS $$
BEGIN
  INSERT INTO metrics (metric_date, metric_type, metric_value, dimensions)
  SELECT 
    report_date,
    'DAU',
    COUNT(DISTINCT user_id),
    jsonb_build_object('type', 'daily_active_users')
  FROM events
  WHERE DATE(created_at) = report_date;
  
  INSERT INTO metrics (metric_date, metric_type, metric_value, dimensions)
  SELECT 
    report_date,
    'Total_Events',
    COUNT(*),
    jsonb_build_object('type', 'total_events')
  FROM events
  WHERE DATE(created_at) = report_date;
END;
$$ LANGUAGE plpgsql;

-- Task 4: Implement Triggers
-- ============================================

-- Trigger function: Update metrics on event insert
CREATE OR REPLACE FUNCTION update_metrics_on_event() RETURNS TRIGGER AS $$
BEGIN
  UPDATE metrics 
  SET metric_value = metric_value + 1
  WHERE metric_date = CURRENT_DATE AND metric_type = 'Total_Events';
  
  IF NOT FOUND THEN
    INSERT INTO metrics (metric_date, metric_type, metric_value)
    VALUES (CURRENT_DATE, 'Total_Events', 1);
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_metrics
AFTER INSERT ON events
FOR EACH ROW EXECUTE FUNCTION update_metrics_on_event();

-- Trigger function: Audit logging
CREATE OR REPLACE FUNCTION audit_events() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO metrics (metric_date, metric_type, metric_value)
  VALUES (CURRENT_DATE, 'Events_Logged', 1);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Task 5: Implement Security
-- ============================================

-- Create roles
CREATE ROLE analyst_role;
CREATE ROLE viewer_role;
CREATE ROLE admin_role WITH CREATEDB CREATEROLE;

-- Grant permissions
GRANT SELECT ON users, sessions, events, metrics TO viewer_role;
GRANT SELECT, INSERT, UPDATE ON events, metrics TO analyst_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO admin_role;

-- Enable RLS on events
ALTER TABLE events ENABLE ROW LEVEL SECURITY;

-- Create RLS policy
CREATE POLICY event_access ON events
FOR SELECT USING (true);

-- Task 6: Setup Monitoring
-- ============================================

-- Create event summary view
CREATE OR REPLACE VIEW v_event_summary AS
SELECT 
  DATE(created_at) AS event_date,
  event_type,
  COUNT(*) AS event_count,
  COUNT(DISTINCT user_id) AS unique_users
FROM events
GROUP BY DATE(created_at), event_type;

-- Create session summary view
CREATE OR REPLACE VIEW v_session_summary AS
SELECT 
  DATE(started_at) AS session_date,
  device,
  COUNT(*) AS session_count,
  AVG(duration_seconds) AS avg_duration,
  MAX(duration_seconds) AS max_duration
FROM sessions
GROUP BY DATE(started_at), device;

-- Create user metrics view
CREATE OR REPLACE VIEW v_user_metrics AS
SELECT 
  u.id,
  u.username,
  COUNT(DISTINCT s.id) AS session_count,
  COUNT(DISTINCT e.id) AS event_count,
  get_user_engagement_score(u.id) AS engagement_score
FROM users u
LEFT JOIN sessions s ON u.id = s.user_id
LEFT JOIN events e ON u.id = e.user_id
GROUP BY u.id, u.username;

-- Task 7: Optimize Performance
-- ============================================

-- Create materialized view for daily metrics
CREATE MATERIALIZED VIEW mv_daily_metrics AS
SELECT 
  DATE(created_at) AS metric_date,
  COUNT(*) AS total_events,
  COUNT(DISTINCT user_id) AS unique_users,
  COUNT(DISTINCT session_id) AS unique_sessions
FROM events
GROUP BY DATE(created_at);

-- Create index on materialized view
CREATE INDEX idx_mv_daily_metrics_date ON mv_daily_metrics(metric_date);

-- Task 8: Backup & Recovery
-- ============================================

-- Backup command (run from shell):
-- pg_dump -U postgres -d analytics_db -Fc > analytics_db_backup.dump

-- Restore command (run from shell):
-- pg_restore -U postgres -d analytics_db analytics_db_backup.dump

-- Verify data
SELECT COUNT(*) AS user_count FROM users;
SELECT COUNT(*) AS session_count FROM sessions;
SELECT COUNT(*) AS event_count FROM events;
SELECT COUNT(*) AS metric_count FROM metrics;

