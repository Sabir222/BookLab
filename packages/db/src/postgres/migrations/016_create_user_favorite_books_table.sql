-- Migration: Create User Favorite Books Table
-- Version: 016_create_user_favorite_books_table
-- Created: 10-08-2025
-- Description: Create user_favorite_books table to store users' favorite books

BEGIN;

CREATE TABLE IF NOT EXISTS user_favorite_books (
    user_id UUID NOT NULL,
    book_id UUID NOT NULL,
    added_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    notes TEXT,

    CONSTRAINT pk_user_favorite_books PRIMARY KEY (user_id, book_id),
    CONSTRAINT fk_user_favorite_books_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_user_favorite_books_book FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE
);

-- Indexes for performance
DROP INDEX IF EXISTS idx_user_favorite_books_user_id;
CREATE INDEX idx_user_favorite_books_user_id ON user_favorite_books(user_id);

DROP INDEX IF EXISTS idx_user_favorite_books_book_id;
CREATE INDEX idx_user_favorite_books_book_id ON user_favorite_books(book_id);

DROP INDEX IF EXISTS idx_user_favorite_books_added_at;
CREATE INDEX idx_user_favorite_books_added_at ON user_favorite_books(added_at);

-- Add migration record
INSERT INTO schema_migrations (version) VALUES ('016_create_user_favorite_books_table')
ON CONFLICT (version) DO NOTHING;

COMMIT;

-- ROLLBACK (DOWN MIGRATION)
-- Uncomment and run this section to rollback this migration
/*
BEGIN;

-- Drop indexes
DROP INDEX IF EXISTS idx_user_favorite_books_added_at;
DROP INDEX IF EXISTS idx_user_favorite_books_book_id;
DROP INDEX IF EXISTS idx_user_favorite_books_user_id;

-- Drop table
DROP TABLE IF EXISTS user_favorite_books;

-- Remove from migrations
DELETE FROM schema_migrations WHERE version = '016_create_user_favorite_books_table';

COMMIT;
*/