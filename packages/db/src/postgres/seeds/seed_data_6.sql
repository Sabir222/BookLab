-- Seed data for books 51-60
-- Adding more real books to reach 100

-- Books (Next 10 real books)
INSERT INTO books (title, isbn_13, publication_date, published_year, page_count, language, book_format, price_sale, stock_quantity, is_active, publisher_id, primary_category_id) VALUES
('The Great Gatsby', '9780743273565', NULL, NULL, 180, 'eng', 'paperback', 12.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Scribner'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Catcher in the Rye', '9780316769488', NULL, NULL, 277, 'eng', 'paperback', 13.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Little, Brown and Company'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('Lord of the Flies', '9780571338148', NULL, NULL, 224, 'eng', 'paperback', 12.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Faber & Faber'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('Animal Farm', '9780451526342', NULL, NULL, 140, 'eng', 'paperback', 11.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Signet Classic'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('Brave New World', '9780060850524', NULL, NULL, 268, 'eng', 'paperback', 13.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Harper Perennial'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Hobbit', '9780547928227', '2012-09-25', 2012, 366, 'eng', 'hardcover', 19.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Mariner Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('Fahrenheit 451', '9781451673319', NULL, NULL, 249, 'eng', 'paperback', 12.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Simon & Schuster'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('Jane Eyre', '9780141439731', NULL, NULL, 592, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Penguin Classics'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('Wuthering Heights', '9780141439557', NULL, NULL, 416, 'eng', 'paperback', 13.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Penguin Classics'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Alchemist', '9780062315007', NULL, NULL, 208, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'HarperOne'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction'));

-- Adding new publishers
INSERT INTO publishers (publisher_name, founded_year, country, website_url, is_active) VALUES
('Scribner', 1846, 'USA', 'https://www.simonandschuster.com', true),
('Little, Brown and Company', 1837, 'USA', 'https://www.hachettebookgroup.com', true),
('Faber & Faber', 1929, 'UK', 'https://faber.co.uk', true),
('Harper Perennial', NULL, 'USA', 'https://www.harpercollins.com', true),
('Simon & Schuster', 1924, 'USA', 'https://www.simonandschuster.com', true),
('Penguin Classics', NULL, 'USA', 'https://www.penguinrandomhouse.com', true),
('HarperOne', NULL, 'USA', 'https://www.harpercollins.com', true);

-- Adding new authors
INSERT INTO authors (first_name, last_name, nationality, birth_date, death_date) VALUES
('F. Scott', 'Fitzgerald', 'American', '1896-09-24', '1940-12-21'),
('J.D.', 'Salinger', 'American', '1919-01-01', '2010-01-27'),
('William', 'Golding', 'British', '1911-09-19', '1993-06-12'),
('Charlotte', 'Brontë', 'British', '1816-04-21', '1855-03-31'),
('Emily', 'Brontë', 'British', '1818-07-30', '1848-12-19'),
('Paulo', 'Coelho', 'Brazilian', '1947-08-24', NULL);

-- Updating existing authors with death dates
UPDATE authors SET death_date = '1950-01-23' WHERE last_name = 'Orwell';
UPDATE authors SET death_date = '1960-02-19' WHERE last_name = 'Lee';

-- Book Authors
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780743273565'), (SELECT author_id FROM authors WHERE last_name = 'Fitzgerald'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780316769488'), (SELECT author_id FROM authors WHERE last_name = 'Salinger'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780571338148'), (SELECT author_id FROM authors WHERE last_name = 'Golding'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780451526342'), (SELECT author_id FROM authors WHERE last_name = 'Orwell'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780060850524'), (SELECT author_id FROM authors WHERE last_name = 'Huxley'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781451673319'), (SELECT author_id FROM authors WHERE last_name = 'Bradbury'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780141439731'), (SELECT author_id FROM authors WHERE last_name = 'Brontë' AND first_name = 'Charlotte'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780141439557'), (SELECT author_id FROM authors WHERE last_name = 'Brontë' AND first_name = 'Emily'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780062315007'), (SELECT author_id FROM authors WHERE last_name = 'Coelho'), 'author', 1);

-- Adding missing authors
INSERT INTO authors (first_name, last_name, nationality, birth_date, death_date) VALUES
('Aldous', 'Huxley', 'British', '1894-07-26', '1963-11-22'),
('Ray', 'Bradbury', 'American', '1920-08-22', '2012-06-05');

-- Book Categories
INSERT INTO book_categories (book_id, category_id) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780743273565'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780743273565'), (SELECT category_id FROM categories WHERE category_name = 'Classic Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780316769488'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780316769488'), (SELECT category_id FROM categories WHERE category_name = 'Classic Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780571338148'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780571338148'), (SELECT category_id FROM categories WHERE category_name = 'Classic Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780451526342'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780451526342'), (SELECT category_id FROM categories WHERE category_name = 'Classic Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780060850524'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780060850524'), (SELECT category_id FROM categories WHERE category_name = 'Classic Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781451673319'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781451673319'), (SELECT category_id FROM categories WHERE category_name = 'Classic Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780141439731'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780141439731'), (SELECT category_id FROM categories WHERE category_name = 'Classic Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780141439557'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780141439557'), (SELECT category_id FROM categories WHERE category_name = 'Classic Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780062315007'), (SELECT category_id FROM categories WHERE category_name = 'Fiction'));

-- Adding new category
INSERT INTO categories (category_name, description, is_active) VALUES
('Classic Literature', 'Classic works of literature', true);

-- Book Genres
INSERT INTO book_genres (book_id, genre_id) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780743273565'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780316769488'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780571338148'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780451526342'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780060850524'), (SELECT genre_id FROM genres WHERE genre_name = 'Science Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781451673319'), (SELECT genre_id FROM genres WHERE genre_name = 'Science Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780141439731'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780141439557'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780062315007'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature'));