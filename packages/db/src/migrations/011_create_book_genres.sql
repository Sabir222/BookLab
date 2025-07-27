begin
;

CREATE TABLE book_genres (
    book_id UUID NOT NULL,
    genre_id UUID NOT NULL,

    CONSTRAINT pk_book_genres PRIMARY KEY (book_id, genre_id),
    CONSTRAINT fk_book_genres_book FOREIGN KEY (book_id) REFERENCES books(book_id),
    CONSTRAINT fk_book_genres_genre FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

DROP INDEX IF EXISTS idx_book_genres_genre_id;
CREATE INDEX idx_book_genres_genre_id ON book_genres(genre_id);

INSERT INTO schema_migrations (version) VALUES ('011_create_book_genres.sql');

commit
;

-- DROP INDEX IF EXISTS idx_book_genres_genre_id;
-- DROP TABLE IF EXISTS book_genres;
-- DELETE FROM schema_migrations WHERE version = '011_create_book_genres_table.sql';


