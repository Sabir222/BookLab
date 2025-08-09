CREATE INDEX  idx_books_title_gin_trgm 

ON books USING gin (title gin_trgm_ops);

CREATE INDEX  idx_books_subtitle_gin_trgm 
ON books USING gin (subtitle gin_trgm_ops);

CREATE INDEX  idx_books_title_subtitle_gin_trgm 
ON books USING gin ((COALESCE(title, '') || ' ' || COALESCE(subtitle, '')) gin_trgm_ops);

CREATE INDEX  idx_books_isbn_combined_gin_trgm 
ON books USING gin ((COALESCE(isbn_13, '') || ' ' || COALESCE(isbn_10, '')) gin_trgm_ops);

-- Author fuzzy search indexes
CREATE INDEX idx_authors_full_name_gin_trgm 
ON authors USING gin ((COALESCE(first_name, '') || ' ' || COALESCE(last_name, '')) gin_trgm_ops);

CREATE INDEX idx_authors_first_name_gin_trgm 
ON authors USING gin (first_name gin_trgm_ops);

CREATE INDEX idx_authors_last_name_gin_trgm 
ON authors USING gin (last_name gin_trgm_ops);

-- Category fuzzy search indexes  
CREATE INDEX idx_categories_name_gin_trgm 
ON categories USING gin (category_name gin_trgm_ops);

INSERT INTO schema_migrations (version) VALUES ('014_add_fuzzy_search_indexes');

