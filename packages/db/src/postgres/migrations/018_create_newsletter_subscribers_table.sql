begin
;

CREATE TABLE IF NOT EXISTS newsletter_subscribers (
    subscriber_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) NOT NULL,
    is_subscribed BOOLEAN NOT NULL DEFAULT TRUE,
    subscribed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    unsubscribed_at TIMESTAMP WITH TIME ZONE NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    CONSTRAINT unique_newsletter_email UNIQUE (email),
    CONSTRAINT chk_newsletter_email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

DROP INDEX IF EXISTS idx_newsletter_subscribers_email;
CREATE INDEX idx_newsletter_subscribers_email ON newsletter_subscribers(email);

DROP INDEX IF EXISTS idx_newsletter_subscribers_subscribed;
CREATE INDEX idx_newsletter_subscribers_subscribed ON newsletter_subscribers(is_subscribed);

DROP INDEX IF EXISTS idx_newsletter_subscribers_subscribed_at;
CREATE INDEX idx_newsletter_subscribers_subscribed_at ON newsletter_subscribers(subscribed_at);

CREATE TRIGGER update_newsletter_subscribers_updated_at 
  BEFORE UPDATE ON newsletter_subscribers 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

INSERT INTO schema_migrations (version) VALUES ('018_create_newsletter_subscribers_table')
ON CONFLICT (version) DO NOTHING;

commit
;

-- ROLLBACK (DOWN MIGRATION)
-- Uncomment and run this section to rollback this migration
/*
BEGIN;

-- Drop trigger
DROP TRIGGER IF EXISTS update_newsletter_subscribers_updated_at ON newsletter_subscribers;

-- Drop indexes
DROP INDEX IF EXISTS idx_newsletter_subscribers_subscribed_at;
DROP INDEX IF EXISTS idx_newsletter_subscribers_subscribed;
DROP INDEX IF EXISTS idx_newsletter_subscribers_email;

-- Drop table
DROP TABLE IF EXISTS newsletter_subscribers;

-- Remove from migrations
DELETE FROM schema_migrations WHERE version = '018_create_newsletter_subscribers_table';

COMMIT;
*/