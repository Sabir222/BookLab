-- Seed data for books 1-10
-- Harry Potter series (Scholastic)

-- Publishers
INSERT INTO publishers (publisher_name, founded_year, country, website_url, is_active) VALUES
('Scholastic', 1920, 'USA', 'https://www.scholastic.com', true),
('Mariner Books', 2002, 'USA', 'https://www.hmhco.com', true),
('HarperCollins', 1987, 'USA', 'https://www.harpercollins.com', true);

-- Authors
INSERT INTO authors (first_name, last_name, nationality, birth_date) VALUES
('Joanne', 'Rowling', 'British', '1965-07-31'),
('John', 'Tolkien', 'British', '1892-01-03');

-- Categories
INSERT INTO categories (category_name, description, is_active) VALUES
('Fiction', 'Fictional literature', true),
('Fantasy', 'Fantasy literature', true),
('Children', 'Books for children', true),
('Young Adult', 'Books for young adults', true);

-- Genres
INSERT INTO genres (genre_name, description, is_active) VALUES
('Fantasy Literature', 'Literature with magical elements', true),
('Adventure Fiction', 'Fiction with exciting adventures', true),
('Coming-of-Age', 'Stories about growing up', true);

-- Book Series
INSERT INTO book_series (series_name, description, total_books, is_completed) VALUES
('Harry Potter', 'The adventures of a young wizard', 7, true),
('The Lord of the Rings', 'Epic fantasy series', 3, true);

-- Books (First 10 from Harry Potter series)
INSERT INTO books (title, isbn_13, publication_date, published_year, page_count, language, book_format, price_sale, stock_quantity, is_active, publisher_id, primary_category_id) VALUES
('Harry Potter and the Sorcerer''s Stone', '9781338878929', '2023-01-01', 2023, 309, 'eng', 'paperback', 12.99, 100, true, 
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Scholastic'),
  (SELECT category_id FROM categories WHERE category_name = 'Children')),

('Harry Potter and the Chamber of Secrets', '9781338878936', '2023-01-01', 2023, 341, 'eng', 'paperback', 12.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Scholastic'),
  (SELECT category_id FROM categories WHERE category_name = 'Children')),

('Harry Potter and the Prisoner of Azkaban', '9781338878943', '2023-01-01', 2023, 435, 'eng', 'paperback', 12.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Scholastic'),
  (SELECT category_id FROM categories WHERE category_name = 'Children')),

('Harry Potter and the Goblet of Fire', '9781338878950', '2023-01-01', 2023, 734, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Scholastic'),
  (SELECT category_id FROM categories WHERE category_name = 'Young Adult')),

('Harry Potter and the Order of the Phoenix', '9781338878967', '2023-01-01', 2023, 870, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Scholastic'),
  (SELECT category_id FROM categories WHERE category_name = 'Young Adult')),

('Harry Potter and the Half-Blood Prince', '9781338878974', '2023-01-01', 2023, 652, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Scholastic'),
  (SELECT category_id FROM categories WHERE category_name = 'Young Adult')),

('Harry Potter and the Deathly Hallows', '9781338878981', '2023-01-01', 2023, 759, 'eng', 'paperback', 14.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Scholastic'),
  (SELECT category_id FROM categories WHERE category_name = 'Young Adult'));

-- Book Authors
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9781338878929'), (SELECT author_id FROM authors WHERE last_name = 'Rowling'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878936'), (SELECT author_id FROM authors WHERE last_name = 'Rowling'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878943'), (SELECT author_id FROM authors WHERE last_name = 'Rowling'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878950'), (SELECT author_id FROM authors WHERE last_name = 'Rowling'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878967'), (SELECT author_id FROM authors WHERE last_name = 'Rowling'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878974'), (SELECT author_id FROM authors WHERE last_name = 'Rowling'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878981'), (SELECT author_id FROM authors WHERE last_name = 'Rowling'), 'author', 1);

-- Book Categories
INSERT INTO book_categories (book_id, category_id) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9781338878929'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878929'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878936'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878936'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878943'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878943'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878950'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878950'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878967'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878967'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878974'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878974'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878981'), (SELECT category_id FROM categories WHERE category_name = 'Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878981'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy'));

-- Book Genres
INSERT INTO book_genres (book_id, genre_id) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9781338878929'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878929'), (SELECT genre_id FROM genres WHERE genre_name = 'Adventure Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878936'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878936'), (SELECT genre_id FROM genres WHERE genre_name = 'Adventure Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878943'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878943'), (SELECT genre_id FROM genres WHERE genre_name = 'Adventure Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878950'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878950'), (SELECT genre_id FROM genres WHERE genre_name = 'Adventure Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878967'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878967'), (SELECT genre_id FROM genres WHERE genre_name = 'Adventure Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878974'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878974'), (SELECT genre_id FROM genres WHERE genre_name = 'Adventure Fiction')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878981'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878981'), (SELECT genre_id FROM genres WHERE genre_name = 'Adventure Fiction'));

-- Book Series Entries
INSERT INTO book_series_entries (book_id, series_id, volume_number) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9781338878929'), (SELECT series_id FROM book_series WHERE series_name = 'Harry Potter'), 1),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878936'), (SELECT series_id FROM book_series WHERE series_name = 'Harry Potter'), 2),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878943'), (SELECT series_id FROM book_series WHERE series_name = 'Harry Potter'), 3),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878950'), (SELECT series_id FROM book_series WHERE series_name = 'Harry Potter'), 4),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878967'), (SELECT series_id FROM book_series WHERE series_name = 'Harry Potter'), 5),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878974'), (SELECT series_id FROM book_series WHERE series_name = 'Harry Potter'), 6),
((SELECT book_id FROM books WHERE isbn_13 = '9781338878981'), (SELECT series_id FROM book_series WHERE series_name = 'Harry Potter'), 7);