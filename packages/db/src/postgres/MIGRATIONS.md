

### File: ./migrations/001_db_setup.sql

```sql
-- Migration: Database Setup
-- Version: 001_db_setup
-- Created: 26-07-2025
-- Description: Setup schema migrations table, extensions, functions, and enum types

BEGIN;

CREATE TABLE IF NOT EXISTS schema_migrations (
  version VARCHAR(255) PRIMARY KEY,
  applied_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DO $$ BEGIN
    CREATE TYPE book_format AS ENUM ('hardcover', 'paperback', 'ebook', 'audiobook', 'magazine', 'journal');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE user_role AS ENUM ('admin','user', 'moderator');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;


INSERT INTO schema_migrations (version) VALUES ('001_db_setup')
ON CONFLICT (version) DO NOTHING;

COMMIT;
```

---


### File: ./migrations/002_create_users_table.sql

```sql
-- Migration: Create Users Table
-- Version: 001_create_users_table
-- Created: 25-07-2025
-- Description: Create users table with indexes and triggers
begin
;

CREATE TABLE IF NOT EXISTS users (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(50),
    email VARCHAR(255) NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    profile_image_url TEXT,
    credits INT NOT NULL DEFAULT 0,
    loyalty_points INT NOT NULL DEFAULT 0,
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    role user_role NOT NULL DEFAULT 'user',
    last_login TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),

    CONSTRAINT unique_username UNIQUE (username),
    CONSTRAINT unique_email UNIQUE (email),
    CONSTRAINT check_credits_non_negative CHECK (credits >= 0),
    CONSTRAINT check_loyalty_points_non_negative CHECK (loyalty_points >= 0)
);

DROP INDEX IF EXISTS idx_users_email;
CREATE INDEX idx_users_email ON users(email);

DROP INDEX IF EXISTS idx_users_username;
CREATE INDEX idx_users_username ON users(username);

DROP INDEX IF EXISTS idx_users_role;
CREATE INDEX idx_users_role ON users(role);

DROP INDEX IF EXISTS idx_users_created_at;
CREATE INDEX idx_users_created_at ON users(created_at);

CREATE TRIGGER update_users_updated_at 
  BEFORE UPDATE ON users 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

INSERT INTO schema_migrations (version) VALUES ('002_create_users_table');

commit
;

-- ROLLBACK (DOWN MIGRATION)
-- Uncomment and run this section to rollback this migration
/*
BEGIN;

-- Drop trigger
DROP TRIGGER IF EXISTS update_users_updated_at ON users;

-- Drop indexes
DROP INDEX IF EXISTS idx_users_created_at;
DROP INDEX IF EXISTS idx_users_role;
DROP INDEX IF EXISTS idx_users_username;
DROP INDEX IF EXISTS idx_users_email;

-- Drop table
DROP TABLE IF EXISTS users;

-- Remove from migrations (adjust version name as needed)
DELETE FROM schema_migrations WHERE version = '002_create_users_table';

COMMIT;
*/


```

---


### File: ./migrations/003_create_publishers_table.sql

```sql
-- Migration: Create Publishers Table
-- Version: 003_create_publishers_table
-- Created: 25-07-2025
-- Description: Create publishers table with indexes and triggers
begin
;

CREATE TABLE IF NOT EXISTS publishers (
    publisher_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    publisher_name VARCHAR(255) NOT NULL,
    description TEXT,
    founded_year INT,
    country VARCHAR(100),
    website_url TEXT,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    
    CONSTRAINT unique_publisher_name UNIQUE (publisher_name),
    CONSTRAINT check_founded_year_valid CHECK (founded_year >= 1000 AND founded_year <= EXTRACT(YEAR FROM NOW())),
    CONSTRAINT check_website_url_format CHECK (website_url IS NULL OR website_url ~* '^https?://.*')
);

DROP INDEX IF EXISTS idx_publishers_name;
CREATE INDEX idx_publishers_name ON publishers(publisher_name);

DROP INDEX IF EXISTS idx_publishers_country;
CREATE INDEX idx_publishers_country ON publishers(country) WHERE country IS NOT NULL;

DROP INDEX IF EXISTS idx_publishers_is_active;
CREATE INDEX idx_publishers_is_active ON publishers(is_active) WHERE is_active = true;

DROP INDEX IF EXISTS idx_publishers_created_at;
CREATE INDEX idx_publishers_created_at ON publishers(created_at);

DROP INDEX IF EXISTS idx_publishers_founded_year;
CREATE INDEX idx_publishers_founded_year ON publishers(founded_year) WHERE founded_year IS NOT NULL;

DROP INDEX IF EXISTS idx_publishers_active_country;
CREATE INDEX idx_publishers_active_country ON publishers(country, is_active) WHERE is_active = true AND country IS NOT NULL;


CREATE TRIGGER update_publishers_updated_at 
    BEFORE UPDATE ON publishers 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

INSERT INTO schema_migrations (version) VALUES ('003_create_publishers_table');

commit
;

-- ROLLBACK (DOWN MIGRATION)
-- Uncomment and run this section to rollback this migration
/*
BEGIN;

-- Drop trigger
DROP TRIGGER IF EXISTS update_publishers_updated_at ON publishers;

-- Drop indexes
DROP INDEX IF EXISTS idx_publishers_active_country;
DROP INDEX IF EXISTS idx_publishers_founded_year;
DROP INDEX IF EXISTS idx_publishers_created_at;
DROP INDEX IF EXISTS idx_publishers_is_active;
DROP INDEX IF EXISTS idx_publishers_country;
DROP INDEX IF EXISTS idx_publishers_name;

-- Drop table
DROP TABLE IF EXISTS publishers CASCADE;

-- Remove from migrations
DELETE FROM schema_migrations WHERE version = '003_create_publishers_table';

COMMIT;
*/


```

---


### File: ./migrations/004_create_authors_table.sql

```sql
begin
;

CREATE TABLE IF NOT EXISTS authors (
  author_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  first_name VARCHAR(255),
  last_name VARCHAR(255) NOT NULL,
  biography TEXT,
  birth_date DATE,
  death_date DATE,
  nationality VARCHAR(100),
  website_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

DROP INDEX IF EXISTS idx_authors_last_name;
CREATE INDEX idx_authors_last_name ON authors(last_name);

DROP INDEX IF EXISTS idx_authors_nationality ;
CREATE INDEX idx_authors_nationality ON authors(nationality);

DROP INDEX IF EXISTS idx_authors_birth_date;
CREATE INDEX idx_authors_birth_date ON authors(birth_date);

DROP INDEX IF EXISTS idx_authors_created_at;
CREATE INDEX idx_authors_created_at ON authors(created_at);

CREATE TRIGGER update_authors_updated_at 
  BEFORE UPDATE ON authors 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

INSERT INTO schema_migrations (version) VALUES ('004_create_authors_table');

commit
;

/*
BEGIN;

DROP TRIGGER IF EXISTS update_authors_updated_at ON authors;

DROP INDEX IF EXISTS idx_authors_created_at;
DROP INDEX IF EXISTS idx_authors_birth_date;
DROP INDEX IF EXISTS idx_authors_nationality;
DROP INDEX IF EXISTS idx_authors_last_name;

DROP TABLE IF EXISTS authors;

DELETE FROM schema_migrations WHERE version = '004_create_authors_table';

COMMIT;
*/


```

---


### File: ./migrations/005_create_categories_table.sql

```sql
begin
;

CREATE TABLE IF NOT EXISTS categories (
    category_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    parent_category_id UUID,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    
    CONSTRAINT fk_parent_category 
        FOREIGN KEY (parent_category_id) 
        REFERENCES categories(category_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_categories_parent_id 
ON categories(parent_category_id) 
WHERE parent_category_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_categories_active 
ON categories(is_active) 
WHERE is_active = true;

CREATE TRIGGER update_categories_updated_at 
  BEFORE UPDATE ON categories 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

INSERT INTO schema_migrations (version) VALUES ('005_create_categories_table');

commit
;
-- ROLLBACK (DOWN MIGRATION)
/*
BEGIN;

DROP INDEX IF EXISTS idx_categories_active;
DROP INDEX IF EXISTS idx_categories_parent_id;

DROP TABLE IF EXISTS categories;

DELETE FROM schema_migrations WHERE version = '005_create_categories_table';

COMMIT;
*/


```

---


### File: ./migrations/006_create_genre_table.sql

```sql
begin
;
CREATE TABLE IF NOT EXISTS genres (
  genre_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  genre_name VARCHAR(255) NOT NULL,
  description TEXT,
  parent_genre_id UUID,
  is_active BOOL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),

  CONSTRAINT fk_parent_genre 
    FOREIGN KEY (parent_genre_id) 
    REFERENCES genres(genre_id)
    ON DELETE SET NULL 
    ON UPDATE CASCADE,

  CONSTRAINT unique_genre_name UNIQUE (genre_name)
);

CREATE INDEX IF NOT EXISTS idx_genres_parent_id 
ON genres(parent_genre_id)
WHERE parent_genre_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_genres_active 
ON genres(is_active)
WHERE is_active = true;

CREATE TRIGGER update_genres_updated_at 
  BEFORE UPDATE ON genres 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

INSERT INTO schema_migrations (version) VALUES ('006_create_genre_table');

commit
;

/*

BEGIN;

DROP INDEX IF EXISTS idx_genres_active;
DROP INDEX IF EXISTS idx_genres_parent_id;

DROP TABLE IF EXISTS genres;

DELETE FROM schema_migrations WHERE version = '006_create_genre_table';
COMMIT;
*/


```

---


### File: ./migrations/007_create_book_series_table.sql

```sql
begin
;

CREATE TABLE IF NOT EXISTS book_series (
  series_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  series_name VARCHAR(255),
  description TEXT,
  total_books INT,
  is_completed BOOL DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

DROP INDEX IF EXISTS idx_series_name;
CREATE INDEX idx_series_name ON book_series(series_name);  -- Added missing semicolon

CREATE INDEX IF NOT EXISTS idx_is_completed
ON book_series(is_completed)
WHERE is_completed = true;

CREATE TRIGGER update_book_series_updated_at 
  BEFORE UPDATE ON book_series 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

INSERT INTO schema_migrations (version) VALUES ('007_create_book_series_table');

commit
;

/*
BEGIN;
DROP TRIGGER IF EXISTS update_book_series_updated_at ON book_series;
DROP INDEX IF EXISTS idx_series_name;
DROP INDEX IF EXISTS idx_is_completed;
DROP TABLE IF EXISTS book_series;
DELETE FROM schema_migrations WHERE version = '007_create_book_series_table';
COMMIT;
*/


```

---


### File: ./migrations/008_create_books_table.sql

```sql
begin
;

CREATE TABLE IF NOT EXISTS  books (
    book_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(500) NOT NULL,
    subtitle VARCHAR(500),
    description TEXT,
    isbn_13 VARCHAR(17),
    isbn_10 VARCHAR(13),
    publication_date DATE,
    published_year INTEGER,
    page_count INTEGER,
    language CHAR(3),
    cover_image_url TEXT,
    cover_image_small_url TEXT,
    cover_image_medium_url TEXT,
    cover_image_large_url TEXT,
    edition VARCHAR(50),
    book_format book_format,
    book_condition VARCHAR(20) DEFAULT 'new',
    dimensions VARCHAR(50),
    weight_grams INTEGER,
    for_sale BOOLEAN DEFAULT true,
    for_rent BOOLEAN DEFAULT false,
    price_sale NUMERIC(10,2) NOT NULL,
    price_rent_daily NUMERIC(8,2),
    price_rent_weekly NUMERIC(8,2),
    price_rent_monthly NUMERIC(8,2),
    stock_quantity INTEGER DEFAULT 0,
    reserved_quantity INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    average_rating NUMERIC(3,2),
    total_ratings INTEGER DEFAULT 0,
    total_reviews INTEGER DEFAULT 0,
    publisher_id UUID,
    owner_id UUID,
    primary_category_id UUID,
    slug VARCHAR(255),
    search_keywords TEXT[],
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    created_by UUID,
    last_modified_by UUID,
    deleted_at TIMESTAMP NULL,
    deleted_by UUID,

    CONSTRAINT fk_books_publisher FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id) ON DELETE SET NULL,
    CONSTRAINT fk_books_owner FOREIGN KEY (owner_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_books_category FOREIGN KEY (primary_category_id) REFERENCES categories(category_id),
    CONSTRAINT fk_books_created_by FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_books_modified_by FOREIGN KEY (last_modified_by) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_books_deleted_by FOREIGN KEY (deleted_by) REFERENCES users(user_id) ON DELETE CASCADE,
    
    CONSTRAINT chk_books_rating_range CHECK (average_rating >= 0 AND average_rating <= 5),
    CONSTRAINT chk_books_positive_quantities CHECK (
        stock_quantity >= 0 AND 
        reserved_quantity >= 0 AND 
        total_ratings >= 0 AND 
        total_reviews >= 0
    ),
    CONSTRAINT chk_books_isbn_format CHECK (
        (isbn_13 IS NULL OR LENGTH(isbn_13) IN (13, 17)) AND
        (isbn_10 IS NULL OR LENGTH(isbn_10) IN (10, 13))
    ),
    CONSTRAINT chk_books_rental_pricing CHECK (
        (for_rent = false) OR 
        (for_rent = true AND (price_rent_daily IS NOT NULL OR price_rent_weekly IS NOT NULL OR price_rent_monthly IS NOT NULL))
    ),
    
    CONSTRAINT unique_isbn_10 UNIQUE (isbn_10),
    CONSTRAINT unique_isbn_13 UNIQUE (isbn_13),
    CONSTRAINT unique_slug UNIQUE (slug)
);

DROP INDEX IF EXISTS idx_books_title;
CREATE INDEX idx_books_title ON books(title);

DROP INDEX IF EXISTS idx_books_publisher_id;
CREATE INDEX idx_books_publisher_id ON books(publisher_id);

DROP INDEX IF EXISTS idx_books_primary_category_id;
CREATE INDEX idx_books_primary_category_id ON books(primary_category_id);

DROP INDEX IF EXISTS idx_books_owner_id;
CREATE INDEX idx_books_owner_id ON books(owner_id);

DROP INDEX IF EXISTS idx_books_for_sale_active;
CREATE INDEX idx_books_for_sale_active ON books(for_sale, is_active);

DROP INDEX IF EXISTS idx_books_for_rent_active;
CREATE INDEX idx_books_for_rent_active ON books(for_rent, is_active);

DROP INDEX IF EXISTS idx_books_publication_date;
CREATE INDEX idx_books_publication_date ON books(publication_date);

DROP INDEX IF EXISTS idx_books_average_rating;
CREATE INDEX idx_books_average_rating ON books(average_rating);

DROP INDEX IF EXISTS idx_books_deleted_at;
CREATE INDEX idx_books_deleted_at ON books(deleted_at);

DROP INDEX IF EXISTS idx_books_search_keywords;
CREATE INDEX idx_books_search_keywords ON books USING gin(search_keywords);

CREATE TRIGGER update_books_updated_at
    BEFORE UPDATE ON books
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

INSERT INTO schema_migrations (version) VALUES ('008_create_books_table');

commit
;

-- DROP TRIGGER IF EXISTS update_books_updated_at ON books;
-- DROP INDEX IF EXISTS idx_books_search_keywords;
-- DROP INDEX IF EXISTS idx_books_deleted_at;
-- DROP INDEX IF EXISTS idx_books_average_rating;
-- DROP INDEX IF EXISTS idx_books_publication_date;
-- DROP INDEX IF EXISTS idx_books_for_rent_active;
-- DROP INDEX IF EXISTS idx_books_for_sale_active;
-- DROP INDEX IF EXISTS idx_books_owner_id;
-- DROP INDEX IF EXISTS idx_books_primary_category_id;
-- DROP INDEX IF EXISTS idx_books_publisher_id;
-- DROP INDEX IF EXISTS idx_books_title;
-- DROP TABLE IF EXISTS books;


```

---


### File: ./migrations/009_create_book_authors_table.sql

```sql
begin
;

CREATE TABLE IF NOT EXISTS  book_authors (
    book_id UUID NOT NULL,
    author_id UUID NOT NULL,
    role VARCHAR(50) DEFAULT 'author',
    order_index INTEGER DEFAULT 1,

    CONSTRAINT pk_book_authors PRIMARY KEY (book_id, author_id),
    CONSTRAINT fk_book_authors_book FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    CONSTRAINT fk_book_authors_author FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE,
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


```

---


### File: ./migrations/010_create_book_categories_table.sql

```sql
begin
;

CREATE TABLE IF NOT EXISTS book_categories (
    book_id UUID NOT NULL,
    category_id UUID NOT NULL,

    CONSTRAINT pk_book_categories PRIMARY KEY (book_id, category_id),
    CONSTRAINT fk_book_categories_book FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    CONSTRAINT fk_book_categories_category FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE
);

DROP INDEX IF EXISTS idx_book_categories_category_id;
CREATE INDEX idx_book_categories_category_id ON book_categories(category_id);

INSERT INTO schema_migrations (version) VALUES ('010_create_book_categories_table');

commit
;

-- DROP INDEX IF EXISTS idx_book_categories_category_id;
-- DROP TABLE IF EXISTS book_categories;
-- DELETE FROM schema_migrations WHERE version = '010_create_book_categories_table';


```

---


### File: ./migrations/011_create_book_genres_table.sql

```sql
begin
;

CREATE TABLE IF NOT EXISTS book_genres (
    book_id UUID NOT NULL,
    genre_id UUID NOT NULL,

    CONSTRAINT pk_book_genres PRIMARY KEY (book_id, genre_id),
    CONSTRAINT fk_book_genres_book FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    CONSTRAINT fk_book_genres_genre FOREIGN KEY (genre_id) REFERENCES genres(genre_id) ON DELETE CASCADE
);

DROP INDEX IF EXISTS idx_book_genres_genre_id;
CREATE INDEX idx_book_genres_genre_id ON book_genres(genre_id);

INSERT INTO schema_migrations (version) VALUES ('011_create_book_genres_table');

commit
;

-- DROP INDEX IF EXISTS idx_book_genres_genre_id;
-- DROP TABLE IF EXISTS book_genres;
-- DELETE FROM schema_migrations WHERE version = '011_create_book_genres_table';


```

---


### File: ./migrations/012_create_book_series_entries_table.sql

```sql
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


```

---


### File: ./migrations/013_create_book_reviews_table.sql

```sql
begin
;
-- TODO: verified is true for dev env , make it false in production
CREATE TABLE IF NOT EXISTS book_reviews (
    review_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    book_id UUID NOT NULL,
    user_id UUID NOT NULL,
    rating INTEGER NOT NULL,
    review_text TEXT,
    is_verified BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

    CONSTRAINT fk_book_reviews_book FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    CONSTRAINT fk_book_reviews_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
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

/*
begin
;
DROP TRIGGER IF EXISTS update_book_reviews_updated_at ON book_reviews;
DROP INDEX IF EXISTS idx_book_reviews_verified;
DROP INDEX IF EXISTS idx_book_reviews_created_at;
DROP INDEX IF EXISTS idx_book_reviews_rating;
DROP INDEX IF EXISTS idx_book_reviews_user_id;
DROP INDEX IF EXISTS idx_book_reviews_book_id;
DROP TABLE IF EXISTS book_reviews;
delete from schema_migrations
where version = '013_create_book_reviews_table'
;
INSERT INTO schema_migrations (version) VALUES ('014_delete_book_reviews_table');
;
commit
;
*/


```

---


### File: ./migrations/014_add_fuzzy_search_indexes_books.sql

```sql
-- Migration: Add Fuzzy Search Indexes
-- Version: 014_add_fuzzy_search_indexes
-- Created: 10-08-2025
-- Description: Add fuzzy search indexes for books, authors, and categories
begin
;

DROP INDEX IF EXISTS idx_books_title_gin_trgm;
DROP INDEX IF EXISTS idx_books_subtitle_gin_trgm;
DROP INDEX IF EXISTS idx_books_title_subtitle_gin_trgm;
DROP INDEX IF EXISTS idx_books_isbn_combined_gin_trgm;
DROP INDEX IF EXISTS idx_authors_full_name_gin_trgm;
DROP INDEX IF EXISTS idx_authors_first_name_gin_trgm;
DROP INDEX IF EXISTS idx_authors_last_name_gin_trgm;
DROP INDEX IF EXISTS idx_categories_name_gin_trgm;

CREATE INDEX idx_books_title_gin_trgm 
ON books USING gin (title gin_trgm_ops);

CREATE INDEX idx_books_subtitle_gin_trgm 
ON books USING gin (subtitle gin_trgm_ops);

CREATE INDEX idx_books_title_subtitle_gin_trgm 
ON books USING gin ((COALESCE(title, '') || ' ' || COALESCE(subtitle, '')) gin_trgm_ops);

CREATE INDEX idx_books_isbn_combined_gin_trgm 
ON books USING gin ((COALESCE(isbn_13, '') || ' ' || COALESCE(isbn_10, '')) gin_trgm_ops);

CREATE INDEX idx_authors_full_name_gin_trgm 
ON authors USING gin ((COALESCE(first_name, '') || ' ' || COALESCE(last_name, '')) gin_trgm_ops);

CREATE INDEX idx_authors_first_name_gin_trgm 
ON authors USING gin (first_name gin_trgm_ops);

CREATE INDEX idx_authors_last_name_gin_trgm 
ON authors USING gin (last_name gin_trgm_ops);

CREATE INDEX idx_categories_name_gin_trgm 
ON categories USING gin (category_name gin_trgm_ops);

INSERT INTO schema_migrations (version) VALUES ('014_add_fuzzy_search_indexes')
ON CONFLICT (version) DO NOTHING;

commit
;

-- ROLLBACK (DOWN MIGRATION)
-- Uncomment and run this section to rollback this migration
/*
BEGIN;

-- Drop indexes
DROP INDEX IF EXISTS idx_books_title_gin_trgm;
DROP INDEX IF EXISTS idx_books_subtitle_gin_trgm;
DROP INDEX IF EXISTS idx_books_title_subtitle_gin_trgm;
DROP INDEX IF EXISTS idx_books_isbn_combined_gin_trgm;
DROP INDEX IF EXISTS idx_authors_full_name_gin_trgm;
DROP INDEX IF EXISTS idx_authors_first_name_gin_trgm;
DROP INDEX IF EXISTS idx_authors_last_name_gin_trgm;
DROP INDEX IF EXISTS idx_categories_name_gin_trgm;

-- Remove from migrations
DELETE FROM schema_migrations WHERE version = '014_add_fuzzy_search_indexes';

COMMIT;
*/



```

---


### File: ./migrations/015_create_user_wishlist_table.sql

```sql
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



```

---


### File: ./migrations/016_create_user_follows_authors_table.sql

```sql
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


```

---


### File: ./migrations/017_create_newsletter_subscribers_table.sql

```sql
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
*/```

---
