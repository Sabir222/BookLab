begin
;
-- TODO: verified is true for dev env , make it false in production
CREATE TABLE book_reviews (
    review_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    book_id UUID NOT NULL,
    user_id UUID NOT NULL,
    rating INTEGER NOT NULL,
    review_text TEXT,
    is_verified BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

    CONSTRAINT fk_book_reviews_book FOREIGN KEY (book_id) REFERENCES books(book_id),
    CONSTRAINT fk_book_reviews_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT chk_book_reviews_rating_range CHECK (rating >= 1 AND rating <= 5),
    CONSTRAINT unique_user_book_review UNIQUE (book_id, user_id)
);

DROP INDEX IF EXISTS idx_book_reviews_book_id;
CREATE INDEX idx_book_reviews_book_id ON book_reviews(book_id);

DROP INDEX IF EXISTS idx_book_reviews_user_id;
CREATE INDEX idx_book_reviews_user_id ON book_reviews(user_id);

DROP INDEX IF EXISTS idx_book_reviews_rating;
CREATE INDEX idx_book_reviews_rating ON book_reviews(rating);

DROP INDEX IF EXISTS idx_book_reviews_created_at;
CREATE INDEX idx_book_reviews_created_at ON book_reviews(created_at);

DROP INDEX IF EXISTS idx_book_reviews_verified;
CREATE INDEX idx_book_reviews_verified ON book_reviews(is_verified);

CREATE TRIGGER update_book_reviews_updated_at
    BEFORE UPDATE ON book_reviews
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

INSERT INTO schema_migrations (version) VALUES ('013_create_book_reviews_table');

commit
;

-- DROP TRIGGER IF EXISTS update_book_reviews_updated_at ON book_reviews;
-- DROP INDEX IF EXISTS idx_book_reviews_verified;
-- DROP INDEX IF EXISTS idx_book_reviews_created_at;
-- DROP INDEX IF EXISTS idx_book_reviews_rating;
-- DROP INDEX IF EXISTS idx_book_reviews_user_id;
-- DROP INDEX IF EXISTS idx_book_reviews_book_id;
-- DROP TABLE IF EXISTS book_reviews;
-- DELETE FROM schema_migrations WHERE version = '013_create_book_reviews_table';


