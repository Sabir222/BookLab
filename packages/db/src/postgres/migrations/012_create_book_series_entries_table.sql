begin
;

CREATE TABLE IF NOT EXISTS book_series_entries (
    book_id UUID NOT NULL,
    series_id UUID NOT NULL,
    volume_number INTEGER,
    volume_title VARCHAR(255),
    
    CONSTRAINT pk_book_series_entries PRIMARY KEY (book_id, series_id),
    CONSTRAINT fk_book_series_entries_book FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    CONSTRAINT fk_book_series_entries_series FOREIGN KEY (series_id) REFERENCES book_series(series_id) ON DELETE CASCADE,
    CONSTRAINT unique_series_volume UNIQUE (series_id, volume_number)
);

INSERT INTO schema_migrations (version) VALUES ('012_create_book_series_entries_table');

commit
;

-- DROP TABLE IF EXISTS book_series_entries;
-- DELETE FROM schema_migrations WHERE version =
-- '012_create_book_series_entries_table';


