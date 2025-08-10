-- Migration: Create User Wishlist Table
-- Version: 015_create_user_wishlist_table
-- Created: 10-08-2025
-- Description: Create user_wishlist table to store users' wishlist books
begin
;

CREATE TABLE IF NOT EXISTS user_wishlist (
    user_id UUID NOT NULL,
    book_id UUID NOT NULL,
    added_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    notes TEXT,

    CONSTRAINT pk_user_wishlist PRIMARY KEY (user_id, book_id),
    CONSTRAINT fk_user_wishlist_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_user_wishlist_book FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE
);

DROP INDEX IF EXISTS idx_user_wishlist_user_id;
CREATE INDEX idx_user_wishlist_user_id ON user_wishlist(user_id);

DROP INDEX IF EXISTS idx_user_wishlist_book_id;
CREATE INDEX idx_user_wishlist_book_id ON user_wishlist(book_id);

DROP INDEX IF EXISTS idx_user_wishlist_added_at;
CREATE INDEX idx_user_wishlist_added_at ON user_wishlist(added_at);

INSERT INTO schema_migrations (version) VALUES ('015_create_user_wishlist_table')
ON CONFLICT (version) DO NOTHING;

commit
;

-- ROLLBACK (DOWN MIGRATION)
-- Uncomment and run this section to rollback this migration
/*
BEGIN;

-- Drop indexes
DROP INDEX IF EXISTS idx_user_wishlist_added_at;
DROP INDEX IF EXISTS idx_user_wishlist_book_id;
DROP INDEX IF EXISTS idx_user_wishlist_user_id;

-- Drop table
DROP TABLE IF EXISTS user_wishlist;

-- Remove from migrations
DELETE FROM schema_migrations WHERE version = '015_create_user_wishlist_table';

COMMIT;
*/



