-- Migration: Create Users Table
-- Version: 001_create_users_table
-- Created: 25-07-2025
-- Description: Create users table with indexes and triggers
begin
;

CREATE TABLE users (
  user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  username VARCHAR(50) UNIQUE,
  email VARCHAR(255) UNIQUE NOT NULL,
  hashed_password VARCHAR(255) NOT NULL,
  profile_image_url TEXT,
  credits INT DEFAULT 0,
  loyalty_points INT DEFAULT 0,
  is_verified BOOLEAN DEFAULT FALSE,
  role VARCHAR(50) DEFAULT 'user',
  last_login TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_created_at ON users(created_at);

CREATE TRIGGER update_users_updated_at 
  BEFORE UPDATE ON users 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

INSERT INTO schema_migrations (version) VALUES ('001_create_users_table');

commit
;

-- ROLLBACK (DOWN MIGRATION)
-- Uncomment and run this section to rollback this migration
/*
BEGIN;

-- Drop trigger
DROP TRIGGER IF EXISTS update_users_updated_at ON users;

-- Drop indexes
DROP INDEX IF EXISTS idx_users_created_at;
DROP INDEX IF EXISTS idx_users_role;
DROP INDEX IF EXISTS idx_users_username;
DROP INDEX IF EXISTS idx_users_email;

-- Drop table
DROP TABLE IF EXISTS users;

-- Remove from migrations (adjust version name as needed)
DELETE FROM schema_migrations WHERE version = '001_create_users_table';

COMMIT;
*/


