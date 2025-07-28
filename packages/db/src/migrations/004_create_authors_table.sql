begin
;

CREATE TABLE IF NOT EXISTS authors (
  author_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  first_name VARCHAR(255),
  last_name VARCHAR(255) NOT NULL,
  biography TEXT,
  birth_date DATE,
  death_date DATE,
  nationality VARCHAR(100),
  website_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

DROP INDEX IF EXISTS idx_authors_last_name;
CREATE INDEX idx_authors_last_name ON authors(last_name);

DROP INDEX IF EXISTS idx_authors_nationality ;
CREATE INDEX idx_authors_nationality ON authors(nationality);

DROP INDEX IF EXISTS idx_authors_birth_date;
CREATE INDEX idx_authors_birth_date ON authors(birth_date);

DROP INDEX IF EXISTS idx_authors_created_at;
CREATE INDEX idx_authors_created_at ON authors(created_at);

CREATE TRIGGER update_authors_updated_at 
  BEFORE UPDATE ON authors 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

INSERT INTO schema_migrations (version) VALUES ('004_create_authors_table');

commit
;

/*
BEGIN;

DROP TRIGGER IF EXISTS update_authors_updated_at ON authors;

DROP INDEX IF EXISTS idx_authors_created_at;
DROP INDEX IF EXISTS idx_authors_birth_date;
DROP INDEX IF EXISTS idx_authors_nationality;
DROP INDEX IF EXISTS idx_authors_last_name;

DROP TABLE IF EXISTS authors;

DELETE FROM schema_migrations WHERE version = '004_create_authors_table';

COMMIT;
*/


