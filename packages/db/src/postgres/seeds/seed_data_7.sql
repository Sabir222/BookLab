-- Seed data for books 61-70
-- Adding more real books to reach 100

-- Books (Next 10 real books)
INSERT INTO books (title, isbn_13, publication_date, published_year, page_count, language, book_format, price_sale, stock_quantity, is_active, publisher_id, primary_category_id) VALUES
('The Kite Runner', '9781594631931', NULL, NULL, 371, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Riverhead Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('A Thousand Splendid Suns', '9781594631948', NULL, NULL, 400, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Riverhead Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Book Thief', '9780375842207', NULL, NULL, 552, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Alfred A. Knopf'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('Life of Pi', '9780156027328', NULL, NULL, 319, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Mariner Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Curious Incident of the Dog in the Night-Time', '9781400032716', NULL, NULL, 240, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Vintage'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Fault in Our Stars', '9780525478812', NULL, NULL, 313, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Dutton Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Young Adult')),

('Gone Girl', '9780307588364', NULL, NULL, 419, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Crown Publishing Group'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Girl with the Dragon Tattoo', '9780307949486', NULL, NULL, 465, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Vintage Crime/Black Lizard'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Help', '9780399156085', NULL, NULL, 454, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'G.P. Putnam''s Sons'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('Water for Elephants', '9780765329720', NULL, NULL, 335, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'St. Martin''s Press'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction'));

-- Adding new publishers
INSERT INTO publishers (publisher_name, founded_year, country, website_url, is_active) VALUES
('Riverhead Books', 1994, 'USA', 'https://www.penguinrandomhouse.com', true),
('Alfred A. Knopf', 1915, 'USA', 'https://www.penguinrandomhouse.com', true),
('Vintage', 1954, 'USA', 'https://www.penguinrandomhouse.com', true),
('Dutton Books', 1852, 'USA', 'https://www.penguinrandomhouse.com', true),
('Crown Publishing Group', 1933, 'USA', 'https://www.penguinrandomhouse.com', true),
('G.P. Putnam''s Sons', 1839, 'USA', 'https://www.penguinrandomhouse.com', true),
('St. Martin''s Press', 1952, 'USA', 'https://www.penguinrandomhouse.com', true),
('Vintage Crime/Black Lizard', NULL, 'USA', 'https://www.penguinrandomhouse.com', true);

-- Adding new authors
INSERT INTO authors (first_name, last_name, nationality, birth_date) VALUES
('Khaled', 'Hosseini', 'Afghan-American', '1965-03-04'),
('Markus', 'Zusak', 'Australian', '1975-06-23'),
('Yann', 'Martel', 'Spanish-Canadian', '1963-06-25'),
('Mark', 'Haddon', 'British', '1962-09-26'),
('John', 'Green', 'American', '1977-08-24'),
('Gillian', 'Flynn', 'American', '1971-02-23'),
('Stieg', 'Larsson', 'Swedish', '1954-08-15'),
('Kathryn', 'Stockett', 'American', '1969-03-21'),
('Sara', 'Gruen', 'American', '1969-06-25');

-- Book Authors
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9781594631931'), (SELECT author_id FROM authors WHERE last_name = 'Hosseini'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781594631948'), (SELECT author_id FROM authors WHERE last_name = 'Hosseini'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780375842207'), (SELECT author_id FROM authors WHERE last_name = 'Zusak'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780156027328'), (SELECT author_id FROM authors WHERE last_name = 'Martel'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781400032716'), (SELECT author_id FROM authors WHERE last_name = 'Haddon'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780525478812'), (SELECT author_id FROM authors WHERE last_name = 'Green'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780307588364'), (SELECT author_id FROM authors WHERE last_name = 'Flynn'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780307949486'), (SELECT author_id FROM authors WHERE last_name = 'Larsson'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780399156085'), (SELECT author_id FROM authors WHERE last_name = 'Stockett'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780765329720'), (SELECT author_id FROM authors WHERE last_name = 'Gruen'), 'author', 1);

-- Book Categories
INSERT INTO book_categories (book_id, category_id) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9781594631931'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781594631931'), (SELECT category_id FROM categories WHERE category_name = 'Contemporary Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781594631948'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781594631948'), (SELECT category_id FROM categories WHERE category_name = 'Contemporary Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780375842207'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780375842207'), (SELECT category_id FROM categories WHERE category_name = 'Historical Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780156027328'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780156027328'), (SELECT category_id FROM categories WHERE category_name = 'Adventure')),
((SELECT book_id FROM books WHERE isbn_13 = '9781400032716'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780525478812'), (SELECT category_id FROM categories WHERE category_name = 'Young Adult')),
((SELECT book_id FROM books WHERE isbn_13 = '9780525478812'), (SELECT category_id FROM categories WHERE category_name = 'Romance')),
((SELECT book_id FROM books WHERE isbn_13 = '9780307588364'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780307588364'), (SELECT category_id FROM categories WHERE category_name = 'Thriller')),
((SELECT book_id FROM books WHERE isbn_13 = '9780307949486'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780307949486'), (SELECT category_id FROM categories WHERE category_name = 'Thriller')),
((SELECT book_id FROM books WHERE isbn_13 = '9780399156085'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780399156085'), (SELECT category_id FROM categories WHERE category_name = 'Historical Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780765329720'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780765329720'), (SELECT category_id FROM categories WHERE category_name = 'Historical Fiction'));

-- Adding new categories
INSERT INTO categories (category_name, description, is_active) VALUES
('Contemporary Fiction', 'Modern fiction literature', true),
('Historical Fiction', 'Fiction set in the past', true),
('Thriller', 'Thriller literature', true);

-- Book Genres
INSERT INTO book_genres (book_id, genre_id) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9781594631931'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781594631948'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780375842207'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780156027328'), (SELECT genre_id FROM genres WHERE genre_name = 'Adventure Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781400032716'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780525478812'), (SELECT genre_id FROM genres WHERE genre_name = 'Romance Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780307588364'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780307949486'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780399156085'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780765329720'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature'));