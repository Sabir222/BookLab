-- Seed data for books 81-90
-- Adding more real books to reach 100

-- Books (Next 10 real books)
INSERT INTO books (title, isbn_13, publication_date, published_year, page_count, language, book_format, price_sale, stock_quantity, is_active, publisher_id, primary_category_id) VALUES
('The Silent Patient', '9781250301697', NULL, NULL, 336, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Celadon Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Institute', '9781982110567', NULL, NULL, 576, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Scribner'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Midnight Library', '9780525559474', NULL, NULL, 288, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Viking'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('Klara and the Sun', '9780525658186', NULL, NULL, 320, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Knopf'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('Project Hail Mary', '9780593135202', NULL, NULL, 496, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Doubleday'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Four Winds', '9781250178602', NULL, NULL, 464, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'St. Martin''s Press'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Vanishing Half', '9780399588177', NULL, NULL, 352, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Riverhead Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('Hamnet', '9780385546049', NULL, NULL, 304, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Doubleday'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Invisible Bridge', '9781501135514', NULL, NULL, 464, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Scribner'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('Mexican Gothic', '9780525622057', NULL, NULL, 320, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Del Rey'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction'));

-- Adding new publishers
INSERT INTO publishers (publisher_name, founded_year, country, website_url, is_active) VALUES
('Celadon Books', NULL, 'USA', 'https://celadonbooks.com', true),
('Viking', 1925, 'USA', 'https://www.penguinrandomhouse.com', true),
('Knopf', 1915, 'USA', 'https://www.penguinrandomhouse.com', true);

-- Adding new authors
INSERT INTO authors (first_name, last_name, nationality, birth_date) VALUES
('Alex', 'Michaelides', 'British-Cypriot', '1980-07-18'),
('Stephen', 'King', 'American', '1947-09-21'),
('Matt', 'Haig', 'British', '1975-07-03'),
('Kazuo', 'Ishiguro', 'British', '1954-11-08'),
('Andy', 'Weir', 'American', '1972-06-16'),
('Kristin', 'Hannah', 'American', '1960-09-25'),
('Brit', 'Bennett', 'American', '1986-07-26'),
('Maggie', 'O''Hara', 'American', '1972-03-07'),
('Julie', 'Ortolon', 'American', '1968-09-15'),
('Silvia', 'Moreno-Garcia', 'Mexican-Canadian', '1973-08-07');

-- Updating author names for accuracy
UPDATE authors SET first_name = 'Maggie', last_name = 'O''Farrell' WHERE last_name = 'Owens' AND first_name = 'Delia';
UPDATE authors SET first_name = 'Julie', last_name = 'Ortolon' WHERE last_name = 'Stockett' AND first_name = 'Kathryn';

-- Book Authors
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9781250301697'), (SELECT author_id FROM authors WHERE last_name = 'Michaelides'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781982110567'), (SELECT author_id FROM authors WHERE last_name = 'King'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780525559474'), (SELECT author_id FROM authors WHERE last_name = 'Haig'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780525658186'), (SELECT author_id FROM authors WHERE last_name = 'Ishiguro'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780593135202'), (SELECT author_id FROM authors WHERE last_name = 'Weir'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781250178602'), (SELECT author_id FROM authors WHERE last_name = 'Hannah'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780399588177'), (SELECT author_id FROM authors WHERE last_name = 'Bennett'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780385546049'), (SELECT author_id FROM authors WHERE last_name = 'O''Hara'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781501135514'), (SELECT author_id FROM authors WHERE last_name = 'Ortolon'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780525622057'), (SELECT author_id FROM authors WHERE last_name = 'Moreno-Garcia'), 'author', 1);

-- Correcting author names
UPDATE authors SET first_name = 'Maggie', last_name = 'O''Farrell' WHERE last_name = 'O''Hara';
UPDATE authors SET first_name = 'Julie', last_name = 'Ortolon' WHERE last_name = 'Ortolon';

-- Correcting a book title
UPDATE books SET title = 'The Invisible Bridge' WHERE isbn_13 = '9781501135514';

-- Book Categories
INSERT INTO book_categories (book_id, category_id) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9781250301697'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781250301697'), (SELECT category_id FROM categories WHERE category_name = 'Thriller')),
((SELECT book_id FROM books WHERE isbn_13 = '9781982110567'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781982110567'), (SELECT category_id FROM categories WHERE category_name = 'Horror')),
((SELECT book_id FROM books WHERE isbn_13 = '9780525559474'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780525559474'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780525658186'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780525658186'), (SELECT category_id FROM categories WHERE category_name = 'Science Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780593135202'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780593135202'), (SELECT category_id FROM categories WHERE category_name = 'Science Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781250178602'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781250178602'), (SELECT category_id FROM categories WHERE category_name = 'Historical Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780399588177'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780399588177'), (SELECT category_id FROM categories WHERE category_name = 'Contemporary Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780385546049'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780385546049'), (SELECT category_id FROM categories WHERE category_name = 'Historical Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781501135514'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781501135514'), (SELECT category_id FROM categories WHERE category_name = 'Historical Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780525622057'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780525622057'), (SELECT category_id FROM categories WHERE category_name = 'Horror'));

-- Adding new category
INSERT INTO categories (category_name, description, is_active) VALUES
('Horror', 'Horror literature', true);

-- Book Genres
INSERT INTO book_genres (book_id, genre_id) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9781250301697'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781982110567'), (SELECT genre_id FROM genres WHERE genre_name = 'Horror Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780525559474'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780525658186'), (SELECT genre_id FROM genres WHERE genre_name = 'Science Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780593135202'), (SELECT genre_id FROM genres WHERE genre_name = 'Science Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781250178602'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780399588177'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780385546049'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781501135514'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780525622057'), (SELECT genre_id FROM genres WHERE genre_name = 'Horror Literature'));

-- Adding new genre
INSERT INTO genres (genre_name, description, is_active) VALUES
('Horror Literature', 'Literature designed to frighten and disturb', true);