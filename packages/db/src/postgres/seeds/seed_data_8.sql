-- Seed data for books 71-80
-- Adding more real books to reach 100

-- Books (Next 10 real books)
INSERT INTO books (title, isbn_13, publication_date, published_year, page_count, language, book_format, price_sale, stock_quantity, is_active, publisher_id, primary_category_id) VALUES
('The Secret Life of Bees', '9780142001745', NULL, NULL, 300, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Penguin Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('Eat, Pray, Love', '9780143038390', NULL, NULL, 334, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Penguin Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Non-Fiction')),

('The Time Traveler''s Wife', '9780156029414', NULL, NULL, 518, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Mariner Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Lovely Bones', '9780316016316', NULL, NULL, 328, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Little, Brown and Company'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('Big Little Lies', '9780399587355', NULL, NULL, 464, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'G.P. Putnam''s Sons'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Night Circus', '9780307744432', NULL, NULL, 512, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Doubleday'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('Where the Crawdads Sing', '9780735219090', NULL, NULL, 384, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'G.P. Putnam''s Sons'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Seven Husbands of Evelyn Hugo', '9781501161933', NULL, NULL, 400, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Atria Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('Educated', '9780399590547', NULL, NULL, 334, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Random House'),
  (SELECT category_id FROM categories WHERE category_name = 'Non-Fiction')),

('Becoming', '9781524763138', NULL, NULL, 448, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Crown Publishing Group'),
  (SELECT category_id FROM categories WHERE category_name = 'Non-Fiction'));

-- Adding new publishers
INSERT INTO publishers (publisher_name, founded_year, country, website_url, is_active) VALUES
('Penguin Books', 1935, 'UK', 'https://www.penguinrandomhouse.com', true),
('Doubleday', 1897, 'USA', 'https://www.penguinrandomhouse.com', true),
('Atria Books', 2002, 'USA', 'https://www.simonandschuster.com', true),
('Random House', 1927, 'USA', 'https://www.penguinrandomhouse.com', true);

-- Adding new authors
INSERT INTO authors (first_name, last_name, nationality, birth_date) VALUES
('Sue', 'Monk Kidd', 'American', '1948-08-12'),
('Elizabeth', 'Gilbert', 'American', '1969-07-18'),
('Audrey', 'Niffenegger', 'American', '1963-06-13'),
('Alice', 'Sebold', 'American', '1963-09-06'),
('Liane', 'Moriarty', 'Australian', '1966-11-10'),
('Erin', 'Morgenstern', 'American', '1978-03-18'),
('Delia', 'Owens', 'American', '1949-12-04'),
('Taylor', 'Jenkins Reid', 'American', '1983-09-28'),
('Tara', 'Westover', 'American', '1986-09-27'),
('Michelle', 'Obama', 'American', '1964-01-17');

-- Book Authors
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780142001745'), (SELECT author_id FROM authors WHERE last_name = 'Kidd'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780399587355'), (SELECT author_id FROM authors WHERE last_name = 'Moriarty'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780307744432'), (SELECT author_id FROM authors WHERE last_name = 'Morgenstern'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780735219090'), (SELECT author_id FROM authors WHERE last_name = 'Owens'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781501161933'), (SELECT author_id FROM authors WHERE last_name = 'Reid'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780399590547'), (SELECT author_id FROM authors WHERE last_name = 'Westover'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781524763138'), (SELECT author_id FROM authors WHERE last_name = 'Obama'), 'author', 1);

-- Updating existing authors
UPDATE authors SET death_date = '2020-01-21' WHERE last_name = 'Coelho';

-- Book Authors (for books already in the database that need to be linked)
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780143038390'), (SELECT author_id FROM authors WHERE last_name = 'Gilbert'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780156029414'), (SELECT author_id FROM authors WHERE last_name = 'Niffenegger'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780316016316'), (SELECT author_id FROM authors WHERE last_name = 'Sebold'), 'author', 1);

-- Book Categories
INSERT INTO book_categories (book_id, category_id) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780142001745'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780142001745'), (SELECT category_id FROM categories WHERE category_name = 'Historical Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780143038390'), (SELECT category_id FROM categories WHERE category_name = 'Non-Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780143038390'), (SELECT category_id FROM categories WHERE category_name = 'Memoir')),
((SELECT book_id FROM books WHERE isbn_13 = '9780156029414'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780156029414'), (SELECT category_id FROM categories WHERE category_name = 'Romance')),
((SELECT book_id FROM books WHERE isbn_13 = '9780156029414'), (SELECT category_id FROM categories WHERE category_name = 'Science Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780316016316'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780399587355'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780307744432'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780307744432'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780735219090'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780735219090'), (SELECT category_id FROM categories WHERE category_name = 'Mystery')),
((SELECT book_id FROM books WHERE isbn_13 = '9781501161933'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781501161933'), (SELECT category_id FROM categories WHERE category_name = 'Historical Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780399590547'), (SELECT category_id FROM categories WHERE category_name = 'Non-Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780399590547'), (SELECT category_id FROM categories WHERE category_name = 'Memoir')),
((SELECT book_id FROM books WHERE isbn_13 = '9781524763138'), (SELECT category_id FROM categories WHERE category_name = 'Non-Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781524763138'), (SELECT category_id FROM categories WHERE category_name = 'Memoir'));

-- Adding new category
INSERT INTO categories (category_name, description, is_active) VALUES
('Memoir', 'Autobiographical literature', true),
('Mystery', 'Mystery literature', true);

-- Book Genres
INSERT INTO book_genres (book_id, genre_id) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780142001745'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780143038390'), (SELECT genre_id FROM genres WHERE genre_name = 'Non-Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780156029414'), (SELECT genre_id FROM genres WHERE genre_name = 'Romance Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780156029414'), (SELECT genre_id FROM genres WHERE genre_name = 'Science Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780316016316'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780399587355'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780307744432'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780735219090'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781501161933'), (SELECT genre_id FROM genres WHERE genre_name = 'Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780399590547'), (SELECT genre_id FROM genres WHERE genre_name = 'Non-Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781524763138'), (SELECT genre_id FROM genres WHERE genre_name = 'Non-Fiction Literature'));

-- Adding new genre
INSERT INTO genres (genre_name, description, is_active) VALUES
('Non-Fiction Literature', 'Literature based on facts and real events', true);