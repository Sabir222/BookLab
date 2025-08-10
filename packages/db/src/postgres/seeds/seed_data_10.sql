-- Seed data for books 91-100
-- Final batch of real books to reach 100

-- Books (Final 10 real books)
INSERT INTO books (title, isbn_13, publication_date, published_year, page_count, language, book_format, price_sale, stock_quantity, is_active, publisher_id, primary_category_id) VALUES
('The Thursday Murder Club', '9780525576730', NULL, NULL, 416, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Penguin Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Midnight Guest', '9781250813894', NULL, NULL, 320, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Minotaur Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Atlas Six', '9781250842290', NULL, NULL, 432, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Tor Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Seven Moons of Maali Almeida', '9780593555555', NULL, NULL, 400, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Random House'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Paris Library', '9781982134725', NULL, NULL, 400, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Scribner'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Last Thing He Told Me', '9781501171345', NULL, NULL, 320, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Simon & Schuster'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Push', '9781982160977', NULL, NULL, 336, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Celadon Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Four Winds', '9781250178602', NULL, NULL, 464, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'St. Martin''s Press'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Midnight Library', '9780525559474', NULL, NULL, 288, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Viking'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('Klara and the Sun', '9780525658186', NULL, NULL, 320, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Knopf'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction'));

-- Adding new publishers
INSERT INTO publishers (publisher_name, founded_year, country, website_url, is_active) VALUES
('Minotaur Books', NULL, 'USA', 'https://us.macmillan.com', true),
('Tor Books', 1986, 'USA', 'https://us.macmillan.com', true);

-- Adding new authors
INSERT INTO authors (first_name, last_name, nationality, birth_date) VALUES
('Richard', 'Osman', 'British', '1970-08-28'),
('Adele', 'Parkes', 'American', '1975-02-14'),
('Olivie', 'Blake', 'British', '1990-06-20'),
('Shehan', 'Karunatilaka', 'Sri Lankan', '1971-07-23'),
('Janet', 'Skeslien Charles', 'American', '1970-03-15'),
('Laura', 'Dave', 'American', '1974-08-27'),
('Ashley', 'Audrain', 'Canadian', '1984-11-20');

-- Updating existing authors
UPDATE authors SET first_name = 'Olivie', last_name = 'Blake' WHERE last_name = 'Moreno-Garcia' AND first_name = 'Silvia';

-- Book Authors
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780525576730'), (SELECT author_id FROM authors WHERE last_name = 'Osman'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781250813894'), (SELECT author_id FROM authors WHERE last_name = 'Parkes'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781250842290'), (SELECT author_id FROM authors WHERE last_name = 'Blake'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780593555555'), (SELECT author_id FROM authors WHERE last_name = 'Karunatilaka'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781982134725'), (SELECT author_id FROM authors WHERE last_name = 'Skeslien Charles'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781501171345'), (SELECT author_id FROM authors WHERE last_name = 'Dave'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781982160977'), (SELECT author_id FROM authors WHERE last_name = 'Audrain'), 'author', 1);

-- Correcting duplicate entries by updating existing books
UPDATE books SET title = 'The Midnight Guest' WHERE isbn_13 = '9781250813894';
UPDATE books SET title = 'The Atlas Six' WHERE isbn_13 = '9781250842290';
UPDATE books SET title = 'The Seven Moons of Maali Almeida' WHERE isbn_13 = '9780593555555';
UPDATE books SET title = 'The Paris Library' WHERE isbn_13 = '9781982134725';
UPDATE books SET title = 'The Last Thing He Told Me' WHERE isbn_13 = '9781501171345';
UPDATE books SET title = 'The Push' WHERE isbn_13 = '9781982160977';

-- Book Categories
INSERT INTO book_categories (book_id, category_id) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780525576730'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780525576730'), (SELECT category_id FROM categories WHERE category_name = 'Mystery')),
((SELECT book_id FROM books WHERE isbn_13 = '9781250813894'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781250813894'), (SELECT category_id FROM categories WHERE category_name = 'Mystery')),
((SELECT book_id FROM books WHERE isbn_13 = '9781250842290'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781250842290'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780593555555'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780593555555'), (SELECT category_id FROM categories WHERE category_name = 'Historical Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781982134725'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781982134725'), (SELECT category_id FROM categories WHERE category_name = 'Historical Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781501171345'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781501171345'), (SELECT category_id FROM categories WHERE category_name = 'Mystery')),
((SELECT book_id FROM books WHERE isbn_13 = '9781982160977'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781982160977'), (SELECT category_id FROM categories WHERE category_name = 'Psychological Fiction'));

-- Adding new category
INSERT INTO categories (category_name, description, is_active) VALUES
('Psychological Fiction', 'Fiction that emphasizes internal characterization and motives', true);

-- Book Genres
INSERT INTO book_genres (book_id, genre_id) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780525576730'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781250813894'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781250842290'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780593555555'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781982134725'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781501171345'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781982160977'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature'));