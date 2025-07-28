begin
;

CREATE TABLE IF NOT EXISTS book_series (
  series_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  series_name VARCHAR(255),
  description TEXT,
  total_books INT,
  is_completed BOOL DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

DROP INDEX IF EXISTS idx_series_name;
CREATE INDEX idx_series_name ON book_series(series_name);  -- Added missing semicolon

CREATE INDEX IF NOT EXISTS idx_is_completed
ON book_series(is_completed)
WHERE is_completed = true;

CREATE TRIGGER update_book_series_updated_at 
  BEFORE UPDATE ON book_series 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

INSERT INTO schema_migrations (version) VALUES ('007_create_book_series_table');

commit
;

/*
BEGIN;
DROP TRIGGER IF EXISTS update_book_series_updated_at ON book_series;
DROP INDEX IF EXISTS idx_series_name;
DROP INDEX IF EXISTS idx_is_completed;
DROP TABLE IF EXISTS book_series;
DELETE FROM schema_migrations WHERE version = '007_create_book_series_table';
COMMIT;
*/


