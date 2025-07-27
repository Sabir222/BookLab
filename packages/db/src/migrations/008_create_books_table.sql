begin
;

CREATE TABLE books (
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

    CONSTRAINT fk_books_publisher FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id),
    CONSTRAINT fk_books_owner FOREIGN KEY (owner_id) REFERENCES users(user_id),
    CONSTRAINT fk_books_category FOREIGN KEY (primary_category_id) REFERENCES categories(category_id),
    CONSTRAINT fk_books_created_by FOREIGN KEY (created_by) REFERENCES users(user_id),
    CONSTRAINT fk_books_modified_by FOREIGN KEY (last_modified_by) REFERENCES users(user_id),
    CONSTRAINT fk_books_deleted_by FOREIGN KEY (deleted_by) REFERENCES users(user_id),
    
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

INSERT INTO schema_migrations (version) VALUES ('008_create_books_table.sql');

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


