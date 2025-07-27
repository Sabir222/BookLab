begin
;
CREATE TABLE IF NOT EXISTS genres (
  genre_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  genre_name VARCHAR(255) NOT NULL,
  description TEXT,
  parent_genre_id UUID,
  is_active BOOL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),

  CONSTRAINT fk_parent_genre 
    FOREIGN KEY (parent_genre_id) 
    REFERENCES genres(genre_id)
    ON DELETE SET NULL 
    ON UPDATE CASCADE,

  CONSTRAINT unique_genre_name UNIQUE (genre_name)
);

CREATE INDEX IF NOT EXISTS idx_genres_parent_id 
ON genres(parent_genre_id)
WHERE parent_genre_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_genres_active 
ON genres(is_active)
WHERE is_active = true;

INSERT INTO schema_migrations (version) VALUES ('006_create_genre_table');

commit
;

/*

BEGIN;

DROP INDEX IF EXISTS idx_genres_active;
DROP INDEX IF EXISTS idx_genres_parent_id;

DROP TABLE IF EXISTS genres;

DELETE FROM schema_migrations WHERE version = '006_create_genre_table';
COMMIT;
*/


