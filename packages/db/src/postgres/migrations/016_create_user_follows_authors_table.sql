begin
;

CREATE TABLE IF NOT EXISTS user_follows_authors (
    user_id UUID NOT NULL,
    author_id UUID NOT NULL,
    followed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    notifications_enabled BOOLEAN DEFAULT TRUE,

    CONSTRAINT pk_user_follows_authors PRIMARY KEY (user_id, author_id),
    CONSTRAINT fk_user_follows_authors_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_user_follows_authors_author FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE
);

DROP INDEX IF EXISTS idx_user_follows_authors_user_id;
CREATE INDEX idx_user_follows_authors_user_id ON user_follows_authors(user_id);

DROP INDEX IF EXISTS idx_user_follows_authors_author_id;
CREATE INDEX idx_user_follows_authors_author_id ON user_follows_authors(author_id);

DROP INDEX IF EXISTS idx_user_follows_authors_followed_at;
CREATE INDEX idx_user_follows_authors_followed_at ON user_follows_authors(followed_at);

DROP INDEX IF EXISTS idx_user_follows_authors_notifications;
CREATE INDEX idx_user_follows_authors_notifications ON user_follows_authors(author_id, notifications_enabled) 
WHERE notifications_enabled = TRUE;

INSERT INTO schema_migrations (version) VALUES ('017_create_user_follows_authors_table')
ON CONFLICT (version) DO NOTHING;

commit
;

-- ROLLBACK (DOWN MIGRATION)
-- Uncomment and run this section to rollback this migration
/*
BEGIN;

-- Drop indexes
DROP INDEX IF EXISTS idx_user_follows_authors_notifications;
DROP INDEX IF EXISTS idx_user_follows_authors_followed_at;
DROP INDEX IF EXISTS idx_user_follows_authors_author_id;
DROP INDEX IF EXISTS idx_user_follows_authors_user_id;

-- Drop table
DROP TABLE IF EXISTS user_follows_authors;

-- Remove from migrations
DELETE FROM schema_migrations WHERE version = '017_create_user_follows_authors_table';

COMMIT;
*/


