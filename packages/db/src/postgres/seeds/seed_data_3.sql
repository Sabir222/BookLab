-- Seed data for books 21-30
-- Continuing with series from the list: A Song of Ice and Fire, The Hunger Games, Dune Series

-- Books (Next 10 books from A Song of Ice and Fire, The Hunger Games, and Dune Series)
INSERT INTO books (title, isbn_13, publication_date, published_year, page_count, language, book_format, price_sale, stock_quantity, is_active, publisher_id, primary_category_id) VALUES
-- A Song of Ice and Fire (Bantam / Random House Worlds)
('A Game of Thrones', '9780553381689', '2002-05-21', 2002, 704, 'eng', 'paperback', 9.99, 100, true, 
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Random House Worlds (Bantam)'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('A Clash of Kings', '9780345535412', NULL, NULL, 768, 'eng', 'paperback', 9.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Bantam'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('A Storm of Swords', '9780553381702', NULL, NULL, 992, 'eng', 'paperback', 11.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Bantam'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('A Feast for Crows', '9780553582031', '2007-01-01', 2007, 784, 'eng', 'paperback', 9.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Random House Worlds (Bantam)'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('A Dance with Dragons', '9780553385953', NULL, NULL, 1040, 'eng', 'paperback', 11.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Bantam'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

-- The Hunger Games (Scholastic)
('The Hunger Games', '9780439023528', NULL, NULL, 374, 'eng', 'paperback', 12.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Scholastic'),
  (SELECT category_id FROM categories WHERE category_name = 'Young Adult')),

('Catching Fire', '9780545586177', NULL, NULL, 391, 'eng', 'paperback', 12.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Scholastic'),
  (SELECT category_id FROM categories WHERE category_name = 'Young Adult')),

('Mockingjay', '9780545663267', '2015-01-01', 2015, 390, 'eng', 'paperback', 12.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Scholastic'),
  (SELECT category_id FROM categories WHERE category_name = 'Young Adult')),

-- Dune Series (Ace Books)
('Dune', '9780593640333', '2023-01-01', 2023, 688, 'eng', 'paperback', 18.00, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Ace Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('Dune Messiah', '9780593201732', '2020-01-01', 2020, 336, 'eng', 'paperback', 17.00, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Ace Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction'));

-- Adding new publishers
INSERT INTO publishers (publisher_name, founded_year, country, website_url, is_active) VALUES
('Bantam', 1970, 'USA', 'https://www.penguinrandomhouse.com/imprints/bantam', true),
('Random House Worlds (Bantam)', NULL, 'USA', 'https://www.penguinrandomhouse.com', true),
('Ace Books', 1952, 'USA', 'https://www.penguinrandomhouse.com/imprints/ace', true);

-- Adding new authors
INSERT INTO authors (first_name, last_name, nationality, birth_date) VALUES
('George', 'Martin', 'American', '1948-09-20'),
('Suzanne', 'Collins', 'American', '1962-08-10'),
('Frank', 'Herbert', 'American', '1920-10-08');

-- Book Authors
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780553381689'), (SELECT author_id FROM authors WHERE last_name = 'Martin'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780345535412'), (SELECT author_id FROM authors WHERE last_name = 'Martin'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780553381702'), (SELECT author_id FROM authors WHERE last_name = 'Martin'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780553582031'), (SELECT author_id FROM authors WHERE last_name = 'Martin'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780553385953'), (SELECT author_id FROM authors WHERE last_name = 'Martin'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780439023528'), (SELECT author_id FROM authors WHERE last_name = 'Collins'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780545586177'), (SELECT author_id FROM authors WHERE last_name = 'Collins'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780545663267'), (SELECT author_id FROM authors WHERE last_name = 'Collins'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780593640333'), (SELECT author_id FROM authors WHERE last_name = 'Herbert'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780593201732'), (SELECT author_id FROM authors WHERE last_name = 'Herbert'), 'author', 1);

-- Book Categories
INSERT INTO book_categories (book_id, category_id) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780553381689'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780553381689'), (SELECT category_id FROM categories WHERE category_name = 'Adventure')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345535412'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345535412'), (SELECT category_id FROM categories WHERE category_name = 'Adventure')),
((SELECT book_id FROM books WHERE isbn_13 = '9780553381702'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780553381702'), (SELECT category_id FROM categories WHERE category_name = 'Adventure')),
((SELECT book_id FROM books WHERE isbn_13 = '9780553582031'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780553582031'), (SELECT category_id FROM categories WHERE category_name = 'Adventure')),
((SELECT book_id FROM books WHERE isbn_13 = '9780553385953'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780553385953'), (SELECT category_id FROM categories WHERE category_name = 'Adventure')),
((SELECT book_id FROM books WHERE isbn_13 = '9780439023528'), (SELECT category_id FROM categories WHERE category_name = 'Young Adult')),
((SELECT book_id FROM books WHERE isbn_13 = '9780439023528'), (SELECT category_id FROM categories WHERE category_name = 'Adventure')),
((SELECT book_id FROM books WHERE isbn_13 = '9780545586177'), (SELECT category_id FROM categories WHERE category_name = 'Young Adult')),
((SELECT book_id FROM books WHERE isbn_13 = '9780545586177'), (SELECT category_id FROM categories WHERE category_name = 'Adventure')),
((SELECT book_id FROM books WHERE isbn_13 = '9780545663267'), (SELECT category_id FROM categories WHERE category_name = 'Young Adult')),
((SELECT book_id FROM books WHERE isbn_13 = '9780545663267'), (SELECT category_id FROM categories WHERE category_name = 'Adventure')),
((SELECT book_id FROM books WHERE isbn_13 = '9780593640333'), (SELECT category_id FROM categories WHERE category_name = 'Science Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780593640333'), (SELECT category_id FROM categories WHERE category_name = 'Adventure')),
((SELECT book_id FROM books WHERE isbn_13 = '9780593201732'), (SELECT category_id FROM categories WHERE category_name = 'Science Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780593201732'), (SELECT category_id FROM categories WHERE category_name = 'Adventure'));

-- Adding new categories
INSERT INTO categories (category_name, description, is_active) VALUES
('Science Fiction', 'Science fiction literature', true);

-- Book Genres
INSERT INTO book_genres (book_id, genre_id) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780553381689'), (SELECT genre_id FROM genres WHERE genre_name = 'High Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780345535412'), (SELECT genre_id FROM genres WHERE genre_name = 'High Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780553381702'), (SELECT genre_id FROM genres WHERE genre_name = 'High Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780553582031'), (SELECT genre_id FROM genres WHERE genre_name = 'High Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780553385953'), (SELECT genre_id FROM genres WHERE genre_name = 'High Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780439023528'), (SELECT genre_id FROM genres WHERE genre_name = 'Adventure Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780545586177'), (SELECT genre_id FROM genres WHERE genre_name = 'Adventure Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780545663267'), (SELECT genre_id FROM genres WHERE genre_name = 'Adventure Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780593640333'), (SELECT genre_id FROM genres WHERE genre_name = 'Science Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9780593201732'), (SELECT genre_id FROM genres WHERE genre_name = 'Science Fiction'));

-- Adding new genres
INSERT INTO genres (genre_name, description, is_active) VALUES
('Science Fiction Literature', 'Literature based on imagined future scientific discoveries', true);

-- Adding A Song of Ice and Fire series
INSERT INTO book_series (series_name, description, total_books, is_completed) VALUES
('A Song of Ice and Fire', 'Epic fantasy series about the struggle for power in Westeros', 7, false);

-- Adding The Hunger Games series
INSERT INTO book_series (series_name, description, total_books, is_completed) VALUES
('The Hunger Games', 'Dystopian young adult series set in a post-apocalyptic world', 3, true);

-- Adding Dune series
INSERT INTO book_series (series_name, description, total_books, is_completed) VALUES
('Dune', 'Science fiction series set in a distant future amidst a feudal interstellar society', 6, true);

-- Book Series Entries
INSERT INTO book_series_entries (book_id, series_id, volume_number) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780553381689'), (SELECT series_id FROM book_series WHERE series_name = 'A Song of Ice and Fire'), 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780345535412'), (SELECT series_id FROM book_series WHERE series_name = 'A Song of Ice and Fire'), 2),
((SELECT book_id FROM books WHERE isbn_13 = '9780553381702'), (SELECT series_id FROM book_series WHERE series_name = 'A Song of Ice and Fire'), 3),
((SELECT book_id FROM books WHERE isbn_13 = '9780553582031'), (SELECT series_id FROM book_series WHERE series_name = 'A Song of Ice and Fire'), 4),
((SELECT book_id FROM books WHERE isbn_13 = '9780553385953'), (SELECT series_id FROM book_series WHERE series_name = 'A Song of Ice and Fire'), 5),
((SELECT book_id FROM books WHERE isbn_13 = '9780439023528'), (SELECT series_id FROM book_series WHERE series_name = 'The Hunger Games'), 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780545586177'), (SELECT series_id FROM book_series WHERE series_name = 'The Hunger Games'), 2),
((SELECT book_id FROM books WHERE isbn_13 = '9780545663267'), (SELECT series_id FROM book_series WHERE series_name = 'The Hunger Games'), 3),
((SELECT book_id FROM books WHERE isbn_13 = '9780593640333'), (SELECT series_id FROM book_series WHERE series_name = 'Dune'), 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780593201732'), (SELECT series_id FROM book_series WHERE series_name = 'Dune'), 2);