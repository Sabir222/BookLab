### File: ./migrations/001_db_setup.sql

```sql
-- Migration: Database Setup
-- Version: 000_setup_database
-- Created: 26-07-2025
-- Description: Setup schema migrations table and UUID extension
begin
;

CREATE TABLE IF NOT EXISTS schema_migrations (
  version VARCHAR(255) PRIMARY KEY,
  applied_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

create or replace function update_updated_at_column()
returns trigger
as $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$
language plpgsql
;

INSERT INTO schema_migrations (version) VALUES ('001_db_setup');

commit
;

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

CREATE TABLE IF NOT EXISTS users  (
  user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  username VARCHAR(50) UNIQUE,
  email VARCHAR(255) UNIQUE NOT NULL,
  hashed_password VARCHAR(255) NOT NULL,
  profile_image_url TEXT,
  credits INT DEFAULT 0,
  loyalty_points INT DEFAULT 0,
  is_verified BOOLEAN DEFAULT FALSE,
  role VARCHAR(50) DEFAULT 'user',
  last_login TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_role ON users(role);
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
-- Version: 002_create_publishers_table
-- Created: 25-07-2025
-- Description: Create publishers table with indexes and triggers
begin
;

CREATE TABLE IF NOT EXISTS publishers (
  publisher_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  publisher_name VARCHAR(255) UNIQUE NOT NULL,
  description TEXT,
  founded_year INT,
  country VARCHAR(100),
  website_url TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_publishers_name ON publishers(publisher_name);
CREATE INDEX idx_publishers_country ON publishers(country);
CREATE INDEX idx_publishers_is_active ON publishers(is_active);
CREATE INDEX idx_publishers_created_at ON publishers(created_at);

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
DROP INDEX IF EXISTS idx_publishers_created_at;
DROP INDEX IF EXISTS idx_publishers_is_active;
DROP INDEX IF EXISTS idx_publishers_country;
DROP INDEX IF EXISTS idx_publishers_name;

-- Drop table
DROP TABLE IF EXISTS publishers;

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

CREATE INDEX idx_authors_last_name ON authors(last_name);
CREATE INDEX idx_authors_nationality ON authors(nationality);
CREATE INDEX idx_authors_birth_date ON authors(birth_date);
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
CREATE TABLE IF NOT EXISTS categories (
    category_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    parent_category_id UUID,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

-- Foreign key constraint for self-referencing parent category
    CONSTRAINT fk_parent_category
        FOREIGN KEY (parent_category_id)
        REFERENCES categories(category_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

```

---
