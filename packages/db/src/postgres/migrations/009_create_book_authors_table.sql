begin
;

CREATE TABLE IF NOT EXISTS  book_authors (
    book_id UUID NOT NULL,
    author_id UUID NOT NULL,
    role VARCHAR(50) DEFAULT 'author',
    order_index INTEGER DEFAULT 1,

    CONSTRAINT pk_book_authors PRIMARY KEY (book_id, author_id),
    CONSTRAINT fk_book_authors_book FOREIGN KEY (book_id) REFERENCES books(book_id),
    CONSTRAINT fk_book_authors_author FOREIGN KEY (author_id) REFERENCES authors(author_id),
    CONSTRAINT chk_book_authors_order_positive CHECK (order_index > 0)
);

DROP INDEX IF EXISTS idx_book_authors_author_id;
CREATE INDEX idx_book_authors_author_id ON book_authors(author_id);

INSERT INTO schema_migrations (version) VALUES ('009_create_book_authors_table');

commit
;

-- DROP INDEX IF EXISTS idx_book_authors_author_id;
-- DROP TABLE IF EXISTS book_authors;
-- DELETE FROM schema_migrations WHERE version = '009_create_book_authors_table';


