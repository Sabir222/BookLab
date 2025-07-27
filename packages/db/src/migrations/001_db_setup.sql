-- Migration: Database Setup
-- Version: 000_setup_database
-- Created: 26-07-2025
-- Description: Setup schema migrations table and UUID extension
begin
;

CREATE TABLE IF NOT EXISTS schema_migrations (
  version VARCHAR(255) PRIMARY KEY,
  applied_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

create or replace function update_updated_at_column()
returns trigger
as $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$
language plpgsql
;

INSERT INTO schema_migrations (version) VALUES ('001_db_setup');

commit
;

