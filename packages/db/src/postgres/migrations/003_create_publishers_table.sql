-- Migration: Create Publishers Table
-- Version: 003_create_publishers_table
-- Created: 25-07-2025
-- Description: Create publishers table with indexes and triggers
begin
;

CREATE TABLE IF NOT EXISTS publishers (
    publisher_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    publisher_name VARCHAR(255) NOT NULL,
    description TEXT,
    founded_year INT,
    country VARCHAR(100),
    website_url TEXT,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    
    CONSTRAINT unique_publisher_name UNIQUE (publisher_name),
    CONSTRAINT check_founded_year_valid CHECK (founded_year >= 1000 AND founded_year <= EXTRACT(YEAR FROM NOW())),
    CONSTRAINT check_website_url_format CHECK (website_url IS NULL OR website_url ~* '^https?://.*')
);

DROP INDEX IF EXISTS idx_publishers_name;
CREATE INDEX idx_publishers_name ON publishers(publisher_name);

DROP INDEX IF EXISTS idx_publishers_country;
CREATE INDEX idx_publishers_country ON publishers(country) WHERE country IS NOT NULL;

DROP INDEX IF EXISTS idx_publishers_is_active;
CREATE INDEX idx_publishers_is_active ON publishers(is_active) WHERE is_active = true;

DROP INDEX IF EXISTS idx_publishers_created_at;
CREATE INDEX idx_publishers_created_at ON publishers(created_at);

DROP INDEX IF EXISTS idx_publishers_founded_year;
CREATE INDEX idx_publishers_founded_year ON publishers(founded_year) WHERE founded_year IS NOT NULL;

DROP INDEX IF EXISTS idx_publishers_active_country;
CREATE INDEX idx_publishers_active_country ON publishers(country, is_active) WHERE is_active = true AND country IS NOT NULL;


CREATE TRIGGER update_publishers_updated_at 
    BEFORE UPDATE ON publishers 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

INSERT INTO schema_migrations (version) VALUES ('003_create_publishers_table');

commit
;

-- ROLLBACK (DOWN MIGRATION)
-- Uncomment and run this section to rollback this migration
/*
BEGIN;

-- Drop trigger
DROP TRIGGER IF EXISTS update_publishers_updated_at ON publishers;

-- Drop indexes
DROP INDEX IF EXISTS idx_publishers_active_country;
DROP INDEX IF EXISTS idx_publishers_founded_year;
DROP INDEX IF EXISTS idx_publishers_created_at;
DROP INDEX IF EXISTS idx_publishers_is_active;
DROP INDEX IF EXISTS idx_publishers_country;
DROP INDEX IF EXISTS idx_publishers_name;

-- Drop table
DROP TABLE IF EXISTS publishers CASCADE;

-- Remove from migrations
DELETE FROM schema_migrations WHERE version = '003_create_publishers_table';

COMMIT;
*/


