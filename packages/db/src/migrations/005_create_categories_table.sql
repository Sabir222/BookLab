begin
;

CREATE TABLE IF NOT EXISTS categories (
    category_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    parent_category_id UUID,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    
    CONSTRAINT fk_parent_category 
        FOREIGN KEY (parent_category_id) 
        REFERENCES categories(category_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_categories_parent_id 
ON categories(parent_category_id) 
WHERE parent_category_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_categories_active 
ON categories(is_active) 
WHERE is_active = true;

commit
;
-- ROLLBACK (DOWN MIGRATION)
/*
BEGIN;

DROP INDEX IF EXISTS idx_categories_active;
DROP INDEX IF EXISTS idx_categories_parent_id;

DROP TABLE IF EXISTS categories;

DELETE FROM schema_migrations WHERE version = '005_create_categories_table';

COMMIT;
*/


