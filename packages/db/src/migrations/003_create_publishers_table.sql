-- Migration: Create Publishers Table
-- Version: 002_create_publishers_table
-- Created: 25-07-2025
-- Description: Create publishers table with indexes and triggers
begin
;

CREATE TABLE publishers (
  publisher_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  publisher_name VARCHAR(255) UNIQUE NOT NULL,
  description TEXT,
  founded_year INT,
  country VARCHAR(100),
  website_url TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_publishers_name ON publishers(publisher_name);
CREATE INDEX idx_publishers_country ON publishers(country);
CREATE INDEX idx_publishers_is_active ON publishers(is_active);
CREATE INDEX idx_publishers_created_at ON publishers(created_at);

CREATE TRIGGER update_publishers_updated_at 
  BEFORE UPDATE ON publishers 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

INSERT INTO schema_migrations (version) VALUES ('002_create_publishers_table');

commit
;

-- ROLLBACK (DOWN MIGRATION)
-- Uncomment and run this section to rollback this migration
/*
BEGIN;

-- Drop trigger
DROP TRIGGER IF EXISTS update_publishers_updated_at ON publishers;

-- Drop indexes
DROP INDEX IF EXISTS idx_publishers_created_at;
DROP INDEX IF EXISTS idx_publishers_is_active;
DROP INDEX IF EXISTS idx_publishers_country;
DROP INDEX IF EXISTS idx_publishers_name;

-- Drop table
DROP TABLE IF EXISTS publishers;

-- Remove from migrations
DELETE FROM schema_migrations WHERE version = '002_create_publishers_table';

COMMIT;
*/


