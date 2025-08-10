-- Seed data for books 41-50
-- Completing Percy Jackson & the Olympians, adding Twilight Saga

-- Books (Next 10 books - completing Percy Jackson series and adding Twilight Saga)
INSERT INTO books (title, isbn_13, publication_date, published_year, page_count, language, book_format, price_sale, stock_quantity, is_active, publisher_id, primary_category_id) VALUES
-- Completing Percy Jackson & the Olympians (Disney-Hyperion)
('The Sea of Monsters', '9781423103349', '2007-01-01', 2007, 320, 'eng', 'paperback', 8.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Disney-Hyperion'),
  (SELECT category_id FROM categories WHERE category_name = 'Children')),

('The Titan''s Curse', '9781368051484', '2022-01-01', 2022, 368, 'eng', 'paperback', 8.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Disney-Hyperion'),
  (SELECT category_id FROM categories WHERE category_name = 'Children')),

('The Battle of the Labyrinth', '9781368113694', '2024-01-01', 2024, 400, 'eng', 'paperback', 8.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Disney-Hyperion'),
  (SELECT category_id FROM categories WHERE category_name = 'Children')),

('The Last Olympian', '9781368051453', '2022-01-01', 2022, 416, 'eng', 'paperback', 8.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Disney-Hyperion'),
  (SELECT category_id FROM categories WHERE category_name = 'Children')),

-- Twilight Saga (Little, Brown)
('Twilight', '9780316327336', '2022-01-01', 2022, 504, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Little, Brown Books for Young Readers'),
  (SELECT category_id FROM categories WHERE category_name = 'Young Adult')),

('New Moon', '9780316024969', NULL, NULL, 564, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Little, Brown Books for Young Readers'),
  (SELECT category_id FROM categories WHERE category_name = 'Young Adult')),

('Eclipse', '9780316027656', '2009-01-01', 2009, 624, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Little, Brown Young Readers'),
  (SELECT category_id FROM categories WHERE category_name = 'Young Adult')),

('Breaking Dawn', '9780316067928', NULL, NULL, 756, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Little, Brown Books for Young Readers'),
  (SELECT category_id FROM categories WHERE category_name = 'Young Adult')),

-- Additional real books to reach 50
('To Kill a Mockingbird', '9780061947416', NULL, NULL, 376, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'HarperCollins'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('1984', '9780451524935', NULL, NULL, 328, 'eng', 'paperback', 13.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Signet Classic'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction'));

-- Adding new publisher
INSERT INTO publishers (publisher_name, founded_year, country, website_url, is_active) VALUES
('Little, Brown Books for Young Readers', NULL, 'USA', 'https://www.hachettebookgroup.com', true),
('Little, Brown Young Readers', NULL, 'USA', 'https://www.hachettebookgroup.com', true),
('Signet Classic', NULL, 'USA', 'https://www.penguinrandomhouse.com', true);

-- Adding new authors
INSERT INTO authors (first_name, last_name, nationality, birth_date) VALUES
('Stephenie', 'Meyer', 'American', '1973-12-24'),
('Harper', 'Lee', 'American', '1926-04-28'),
('George', 'Orwell', 'British', '1903-06-25');

-- Book Authors
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9781423103349'), (SELECT author_id FROM authors WHERE last_name = 'Riordan'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781368051484'), (SELECT author_id FROM authors WHERE last_name = 'Riordan'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781368113694'), (SELECT author_id FROM authors WHERE last_name = 'Riordan'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781368051453'), (SELECT author_id FROM authors WHERE last_name = 'Riordan'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780316327336'), (SELECT author_id FROM authors WHERE last_name = 'Meyer'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780316024969'), (SELECT author_id FROM authors WHERE last_name = 'Meyer'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780316027656'), (SELECT author_id FROM authors WHERE last_name = 'Meyer'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780316067928'), (SELECT author_id FROM authors WHERE last_name = 'Meyer'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780061947416'), (SELECT author_id FROM authors WHERE last_name = 'Lee'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780451524935'), (SELECT author_id FROM authors WHERE last_name = 'Orwell'), 'author', 1);

-- Book Categories
INSERT INTO book_categories (book_id, category_id) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9781423103349'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9781423103349'), (SELECT category_id FROM categories WHERE category_name = 'Adventure')),
((SELECT book_id FROM books WHERE isbn_13 = '9781368051484'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9781368051484'), (SELECT category_id FROM categories WHERE category_name = 'Adventure')),
((SELECT book_id FROM books WHERE isbn_13 = '9781368113694'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9781368113694'), (SELECT category_id FROM categories WHERE category_name = 'Adventure')),
((SELECT book_id FROM books WHERE isbn_13 = '9781368051453'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9781368051453'), (SELECT category_id FROM categories WHERE category_name = 'Adventure')),
((SELECT book_id FROM books WHERE isbn_13 = '9780316327336'), (SELECT category_id FROM categories WHERE category_name = 'Romance')),
((SELECT book_id FROM books WHERE isbn_13 = '9780316327336'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780316024969'), (SELECT category_id FROM categories WHERE category_name = 'Romance')),
((SELECT book_id FROM books WHERE isbn_13 = '9780316024969'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780316027656'), (SELECT category_id FROM categories WHERE category_name = 'Romance')),
((SELECT book_id FROM books WHERE isbn_13 = '9780316027656'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780316067928'), (SELECT category_id FROM categories WHERE category_name = 'Romance')),
((SELECT book_id FROM books WHERE isbn_13 = '9780316067928'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780061947416'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780451524935'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780451524935'), (SELECT category_id FROM categories WHERE category_name = 'Science Fiction'));

-- Adding new category
INSERT INTO categories (category_name, description, is_active) VALUES
('Romance', 'Romantic literature', true);

-- Book Genres
INSERT INTO book_genres (book_id, genre_id) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9781423103349'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781423103349'), (SELECT genre_id FROM genres WHERE genre_name = 'Adventure Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781368051484'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781368051484'), (SELECT genre_id FROM genres WHERE genre_name = 'Adventure Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781368113694'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781368113694'), (SELECT genre_id FROM genres WHERE genre_name = 'Adventure Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781368051453'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781368051453'), (SELECT genre_id FROM genres WHERE genre_name = 'Adventure Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780316327336'), (SELECT genre_id FROM genres WHERE genre_name = 'Romance Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780316327336'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780316024969'), (SELECT genre_id FROM genres WHERE genre_name = 'Romance Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780316024969'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780316027656'), (SELECT genre_id FROM genres WHERE genre_name = 'Romance Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780316027656'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780316067928'), (SELECT genre_id FROM genres WHERE genre_name = 'Romance Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780316067928'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780061947416'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780451524935'), (SELECT genre_id FROM genres WHERE genre_name = 'Science Fiction Literature'));

-- Adding new genre
INSERT INTO genres (genre_name, description, is_active) VALUES
('Romance Literature', 'Literature focused on romantic relationships', true),
('Fiction Literature', 'General fiction literature', true);

-- Book Series Entries (completing Percy Jackson and adding Twilight)
INSERT INTO book_series_entries (book_id, series_id, volume_number) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9781423103349'), (SELECT series_id FROM book_series WHERE series_name = 'Percy Jackson & the Olympians'), 2),
((SELECT book_id FROM books WHERE isbn_13 = '9781368051484'), (SELECT series_id FROM book_series WHERE series_name = 'Percy Jackson & the Olympians'), 3),
((SELECT book_id FROM books WHERE isbn_13 = '9781368113694'), (SELECT series_id FROM book_series WHERE series_name = 'Percy Jackson & the Olympians'), 4),
((SELECT book_id FROM books WHERE isbn_13 = '9781368051453'), (SELECT series_id FROM book_series WHERE series_name = 'Percy Jackson & the Olympians'), 5);

-- Adding Twilight series
INSERT INTO book_series (series_name, description, total_books, is_completed) VALUES
('Twilight', 'Romance series between a human girl and a vampire boy', 4, true);

-- Book Series Entries for Twilight
INSERT INTO book_series_entries (book_id, series_id, volume_number) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780316327336'), (SELECT series_id FROM book_series WHERE series_name = 'Twilight'), 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780316024969'), (SELECT series_id FROM book_series WHERE series_name = 'Twilight'), 2),
((SELECT book_id FROM books WHERE isbn_13 = '9780316027656'), (SELECT series_id FROM book_series WHERE series_name = 'Twilight'), 3),
((SELECT book_id FROM books WHERE isbn_13 = '9780316067928'), (SELECT series_id FROM book_series WHERE series_name = 'Twilight'), 4);