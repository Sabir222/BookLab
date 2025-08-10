# BookLab Database Structure

## Overview
This document describes the database schema for the BookLab application. The schema includes tables for managing users, books, authors, publishers, categories, genres, book series, and reviews.

## Tables

### 1. Users
Stores user information for the application.

```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    avatar_url TEXT,
    bio TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**Indexes:**
- Unique index on `username`
- Unique index on `email`

### 2. Publishers
Stores information about book publishers.

```sql
CREATE TABLE publishers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    website_url TEXT,
    logo_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**Indexes:**
- Unique index on `name`

### 3. Authors
Stores information about book authors.

```sql
CREATE TABLE authors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    biography TEXT,
    birth_date DATE,
    death_date DATE,
    nationality VARCHAR(100),
    website_url TEXT,
    photo_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**Indexes:**
- Index on `first_name`
- Index on `last_name`

### 4. Categories
Stores book categories (e.g., Fiction, Non-Fiction).

```sql
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**Indexes:**
- Unique index on `name`

### 5. Genres
Stores book genres (e.g., Mystery, Romance, Science Fiction).

```sql
CREATE TABLE genres (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**Indexes:**
- Unique index on `name`

### 6. Book Series
Stores information about book series.

```sql
CREATE TABLE book_series (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**Indexes:**
- Index on `name`

### 7. Books
Stores information about books.

```sql
CREATE TABLE books (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    subtitle VARCHAR(255),
    isbn_10 VARCHAR(10),
    isbn_13 VARCHAR(13),
    description TEXT,
    cover_image_url TEXT,
    page_count INTEGER,
    publication_date DATE,
    edition VARCHAR(50),
    language VARCHAR(50) DEFAULT 'English',
    publisher_id UUID REFERENCES publishers(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**Indexes:**
- Index on `title`
- Index on `isbn_10`
- Index on `isbn_13`
- Index on `publisher_id`

### 8. Book Authors
Junction table for the many-to-many relationship between books and authors.

```sql
CREATE TABLE book_authors (
    book_id UUID REFERENCES books(id) ON DELETE CASCADE,
    author_id UUID REFERENCES authors(id) ON DELETE CASCADE,
    author_order INTEGER DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (book_id, author_id)
);
```

### 9. Book Categories
Junction table for the many-to-many relationship between books and categories.

```sql
CREATE TABLE book_categories (
    book_id UUID REFERENCES books(id) ON DELETE CASCADE,
    category_id UUID REFERENCES categories(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (book_id, category_id)
);
```

### 10. Book Genres
Junction table for the many-to-many relationship between books and genres.

```sql
CREATE TABLE book_genres (
    book_id UUID REFERENCES books(id) ON DELETE CASCADE,
    genre_id UUID REFERENCES genres(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (book_id, genre_id)
);
```

### 11. Book Series Entries
Junction table for the many-to-many relationship between books and book series, including the order of books in a series.

```sql
CREATE TABLE book_series_entries (
    book_id UUID REFERENCES books(id) ON DELETE CASCADE,
    series_id UUID REFERENCES book_series(id) ON DELETE CASCADE,
    book_order INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (book_id, series_id)
);
```

### 12. Book Reviews
Stores user reviews for books.

```sql
CREATE TABLE book_reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    book_id UUID REFERENCES books(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_title VARCHAR(255),
    review_text TEXT,
    is_spoiler BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(book_id, user_id)
);
```

**Indexes:**
- Index on `book_id`
- Index on `user_id`
- Unique constraint on `book_id` and `user_id` (one review per user per book)

## Relationships

### Direct Relationships
1. **Books → Publishers**: Many-to-One
   - Each book has one publisher (optional)
   - Each publisher can have many books

### Junction (Many-to-Many) Relationships
1. **Books ↔ Authors**: Many-to-Many
   - Books can have multiple authors
   - Authors can write multiple books
   - Maintained through `book_authors` table with author order

2. **Books ↔ Categories**: Many-to-Many
   - Books can belong to multiple categories
   - Categories can contain multiple books
   - Maintained through `book_categories` table

3. **Books ↔ Genres**: Many-to-Many
   - Books can belong to multiple genres
   - Genres can contain multiple books
   - Maintained through `book_genres` table

4. **Books ↔ Book Series**: Many-to-Many
   - Books can belong to multiple series
   - Series can contain multiple books
   - Maintained through `book_series_entries` table with book order

5. **Books ↔ Users (Reviews)**: Many-to-Many with additional data
   - Users can review multiple books
   - Books can have multiple reviews
   - Each user can only review a book once
   - Maintained through `book_reviews` table with rating and review text

## Indexes for Search
Additional indexes were added for fuzzy search capabilities on books:
- Index on `title` with trigram operations for fuzzy matching
- Index on `isbn_13` with trigram operations for fuzzy matching
- Index on `description` with trigram operations for fuzzy matching

## Notes
- All primary keys are UUIDs generated by the database
- Timestamps are stored with time zone information
- Soft deletes are not implemented; cascading deletes are used for related data
- The schema supports complex relationships between books and metadata entities