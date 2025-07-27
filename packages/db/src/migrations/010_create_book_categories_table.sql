begin
;

CREATE TABLE book_categories (
    book_id UUID NOT NULL,
    category_id UUID NOT NULL,

    CONSTRAINT pk_book_categories PRIMARY KEY (book_id, category_id),
    CONSTRAINT fk_book_categories_book FOREIGN KEY (book_id) REFERENCES books(book_id),
    CONSTRAINT fk_book_categories_category FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

DROP INDEX IF EXISTS idx_book_categories_category_id;
CREATE INDEX idx_book_categories_category_id ON book_categories(category_id);

INSERT INTO schema_migrations (version) VALUES ('010_create_book_categories_table.sql');

commit
;

-- DROP INDEX IF EXISTS idx_book_categories_category_id;
-- DROP TABLE IF EXISTS book_categories;
-- DELETE FROM schema_migrations WHERE version = '010_create_book_categories_table.sql';


