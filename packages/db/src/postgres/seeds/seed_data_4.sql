-- Seed data for books 31-40
-- Completing the Dune series, adding The Hitchhiker's Guide to the Galaxy, Percy Jackson & the Olympians

-- Books (Next 10 books - completing Dune series and adding new series)
INSERT INTO books (title, isbn_13, publication_date, published_year, page_count, language, book_format, price_sale, stock_quantity, is_active, publisher_id, primary_category_id) VALUES
-- Completing Dune Series (Ace Books)
('Children of Dune', '9780593201749', '2020-01-01', 2020, 480, 'eng', 'paperback', 17.00, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Ace Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('God Emperor of Dune', '9780593201756', '2020-01-01', 2020, 464, 'eng', 'paperback', 17.00, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Ace Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('Heretics of Dune', '9780593201763', '2020-01-01', 2020, 512, 'eng', 'paperback', 17.00, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Ace Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('Chapterhouse: Dune', '9780593201770', '2020-01-01', 2020, 464, 'eng', 'paperback', 17.00, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Ace Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

-- The Hitchhiker's Guide to the Galaxy (Del Rey)
('The Hitchhiker''s Guide to the Galaxy', '9780345391803', '1995-01-01', 1995, 215, 'eng', 'paperback', 8.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Del Rey'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Restaurant at the End of the Universe', '9780345391810', '1995-01-01', 1995, 256, 'eng', 'paperback', 8.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Del Rey'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('Life, the Universe and Everything', '9780345391827', '1995-01-01', 1995, 256, 'eng', 'paperback', 8.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Del Rey'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('So Long, and Thanks for All the Fish', '9780345391834', '1999-01-01', 1999, 256, 'eng', 'paperback', 8.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Del Rey'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('Mostly Harmless', '9780345418777', '2000-01-01', 2000, 288, 'eng', 'paperback', 8.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Del Rey'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

-- Percy Jackson & the Olympians (Disney-Hyperion)
('The Lightning Thief', '9781368051477', '2022-01-01', 2022, 416, 'eng', 'paperback', 8.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Disney-Hyperion'),
  (SELECT category_id FROM categories WHERE category_name = 'Children'));

-- Adding new publisher
INSERT INTO publishers (publisher_name, founded_year, country, website_url, is_active) VALUES
('Del Rey', 1970, 'USA', 'https://www.penguinrandomhouse.com/imprints/del-rey', true),
('Disney-Hyperion', NULL, 'USA', 'https://hyperionbooks.com', true);

-- Adding new author
INSERT INTO authors (first_name, last_name, nationality, birth_date) VALUES
('Douglas', 'Adams', 'British', '1952-03-11'),
('Rick', 'Riordan', 'American', '1964-06-05');

-- Book Authors
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780593201749'), (SELECT author_id FROM authors WHERE last_name = 'Herbert'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780593201756'), (SELECT author_id FROM authors WHERE last_name = 'Herbert'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780593201763'), (SELECT author_id FROM authors WHERE last_name = 'Herbert'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780593201770'), (SELECT author_id FROM authors WHERE last_name = 'Herbert'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391803'), (SELECT author_id FROM authors WHERE last_name = 'Adams'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391810'), (SELECT author_id FROM authors WHERE last_name = 'Adams'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391827'), (SELECT author_id FROM authors WHERE last_name = 'Adams'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391834'), (SELECT author_id FROM authors WHERE last_name = 'Adams'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780345418777'), (SELECT author_id FROM authors WHERE last_name = 'Adams'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781368051477'), (SELECT author_id FROM authors WHERE last_name = 'Riordan'), 'author', 1);

-- Book Categories
INSERT INTO book_categories (book_id, category_id) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780593201749'), (SELECT category_id FROM categories WHERE category_name = 'Science Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780593201749'), (SELECT category_id FROM categories WHERE category_name = 'Adventure')),
((SELECT book_id FROM books WHERE isbn_13 = '9780593201756'), (SELECT category_id FROM categories WHERE category_name = 'Science Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780593201756'), (SELECT category_id FROM categories WHERE category_name = 'Adventure')),
((SELECT book_id FROM books WHERE isbn_13 = '9780593201763'), (SELECT category_id FROM categories WHERE category_name = 'Science Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780593201763'), (SELECT category_id FROM categories WHERE category_name = 'Adventure')),
((SELECT book_id FROM books WHERE isbn_13 = '9780593201770'), (SELECT category_id FROM categories WHERE category_name = 'Science Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780593201770'), (SELECT category_id FROM categories WHERE category_name = 'Adventure')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391803'), (SELECT category_id FROM categories WHERE category_name = 'Science Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391803'), (SELECT category_id FROM categories WHERE category_name = 'Humor')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391810'), (SELECT category_id FROM categories WHERE category_name = 'Science Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391810'), (SELECT category_id FROM categories WHERE category_name = 'Humor')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391827'), (SELECT category_id FROM categories WHERE category_name = 'Science Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391827'), (SELECT category_id FROM categories WHERE category_name = 'Humor')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391834'), (SELECT category_id FROM categories WHERE category_name = 'Science Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391834'), (SELECT category_id FROM categories WHERE category_name = 'Humor')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345418777'), (SELECT category_id FROM categories WHERE category_name = 'Science Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345418777'), (SELECT category_id FROM categories WHERE category_name = 'Humor')),
((SELECT book_id FROM books WHERE isbn_13 = '9781368051477'), (SELECT category_id FROM categories WHERE category_name = 'Children')),
((SELECT book_id FROM books WHERE isbn_13 = '9781368051477'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy'));

-- Adding new category
INSERT INTO categories (category_name, description, is_active) VALUES
('Humor', 'Books with comedic elements', true);

-- Book Genres
INSERT INTO book_genres (book_id, genre_id) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780593201749'), (SELECT genre_id FROM genres WHERE genre_name = 'Science Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780593201756'), (SELECT genre_id FROM genres WHERE genre_name = 'Science Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780593201763'), (SELECT genre_id FROM genres WHERE genre_name = 'Science Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780593201770'), (SELECT genre_id FROM genres WHERE genre_name = 'Science Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391803'), (SELECT genre_id FROM genres WHERE genre_name = 'Science Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391803'), (SELECT genre_id FROM genres WHERE genre_name = 'Adventure Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391810'), (SELECT genre_id FROM genres WHERE genre_name = 'Science Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391810'), (SELECT genre_id FROM genres WHERE genre_name = 'Adventure Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391827'), (SELECT genre_id FROM genres WHERE genre_name = 'Science Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391827'), (SELECT genre_id FROM genres WHERE genre_name = 'Adventure Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391834'), (SELECT genre_id FROM genres WHERE genre_name = 'Science Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391834'), (SELECT genre_id FROM genres WHERE genre_name = 'Adventure Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345418777'), (SELECT genre_id FROM genres WHERE genre_name = 'Science Fiction Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345418777'), (SELECT genre_id FROM genres WHERE genre_name = 'Adventure Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781368051477'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781368051477'), (SELECT genre_id FROM genres WHERE genre_name = 'Adventure Fiction'));

-- Book Series Entries (completing Dune series and adding new series)
INSERT INTO book_series_entries (book_id, series_id, volume_number) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780593201749'), (SELECT series_id FROM book_series WHERE series_name = 'Dune'), 3),
((SELECT book_id FROM books WHERE isbn_13 = '9780593201756'), (SELECT series_id FROM book_series WHERE series_name = 'Dune'), 4),
((SELECT book_id FROM books WHERE isbn_13 = '9780593201763'), (SELECT series_id FROM book_series WHERE series_name = 'Dune'), 5),
((SELECT book_id FROM books WHERE isbn_13 = '9780593201770'), (SELECT series_id FROM book_series WHERE series_name = 'Dune'), 6);

-- Adding The Hitchhiker's Guide to the Galaxy series
INSERT INTO book_series (series_name, description, total_books, is_completed) VALUES
('The Hitchhiker''s Guide to the Galaxy', 'Comedy science fiction series', 5, true);

-- Adding Percy Jackson & the Olympians series
INSERT INTO book_series (series_name, description, total_books, is_completed) VALUES
('Percy Jackson & the Olympians', 'Fantasy series based on Greek mythology', 5, true);

-- Book Series Entries for new series
INSERT INTO book_series_entries (book_id, series_id, volume_number) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780345391803'), (SELECT series_id FROM book_series WHERE series_name = 'The Hitchhiker''s Guide to the Galaxy'), 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391810'), (SELECT series_id FROM book_series WHERE series_name = 'The Hitchhiker''s Guide to the Galaxy'), 2),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391827'), (SELECT series_id FROM book_series WHERE series_name = 'The Hitchhiker''s Guide to the Galaxy'), 3),
((SELECT book_id FROM books WHERE isbn_13 = '9780345391834'), (SELECT series_id FROM book_series WHERE series_name = 'The Hitchhiker''s Guide to the Galaxy'), 4),
((SELECT book_id FROM books WHERE isbn_13 = '9780345418777'), (SELECT series_id FROM book_series WHERE series_name = 'The Hitchhiker''s Guide to the Galaxy'), 5),
((SELECT book_id FROM books WHERE isbn_13 = '9781368051477'), (SELECT series_id FROM book_series WHERE series_name = 'Percy Jackson & the Olympians'), 1);