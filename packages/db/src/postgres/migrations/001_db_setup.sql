-- Migration: Database Setup
-- Version: 001_db_setup
-- Created: 26-07-2025
-- Description: Setup schema migrations table, extensions, functions, and enum types

BEGIN;

CREATE TABLE IF NOT EXISTS schema_migrations (
  version VARCHAR(255) PRIMARY KEY,
  applied_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DO $$ BEGIN
    CREATE TYPE book_format AS ENUM ('hardcover', 'paperback', 'ebook', 'audiobook', 'magazine', 'journal');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE user_role AS ENUM ('admin','user', 'moderator');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;


INSERT INTO schema_migrations (version) VALUES ('001_db_setup')
ON CONFLICT (version) DO NOTHING;

COMMIT;
