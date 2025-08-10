-- Seed data for books 11-20
-- Lord of the Rings & The Hobbit (Mariner Books)
-- The Chronicles of Narnia (HarperCollins)

-- Books (Next 10 books from The Lord of the Rings & The Hobbit series and The Chronicles of Narnia)
INSERT INTO books (title, isbn_13, publication_date, published_year, page_count, language, book_format, price_sale, stock_quantity, is_active, publisher_id, primary_category_id) VALUES
-- The Lord of the Rings & The Hobbit
('The Hobbit', '9780547928227', '2012-09-25', 2012, 366, 'eng', 'paperback', 14.99, 100, true, 
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Mariner Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Fellowship of the Ring', '9780547928210', '2012-09-25', 2012, 432, 'eng', 'paperback', 15.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Mariner Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Two Towers', '9780547928203', '2012-09-25', 2012, 400, 'eng', 'paperback', 15.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Mariner Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

('The Return of the King', '9780547928197', '2012-09-25', 2012, 464, 'eng', 'paperback', 15.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'Mariner Books'),
  (SELECT category_id FROM categories WHERE category_name = 'Fiction')),

-- The Chronicles of Narnia
('The Magician''s Nephew', '9780064405058', '2025-01-01', 2025, 208, 'eng', 'paperback', 7.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'HarperCollins'),
  (SELECT category_id FROM categories WHERE category_name = 'Children')),

('The Lion, the Witch and the Wardrobe', '9780064471046', '2025-01-01', 2025, 186, 'eng', 'paperback', 7.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'HarperCollins'),
  (SELECT category_id FROM categories WHERE category_name = 'Children')),

('The Horse and His Boy', '9780064405010', '2025-01-01', 2025, 192, 'eng', 'paperback', 7.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'HarperCollins'),
  (SELECT category_id FROM categories WHERE category_name = 'Children')),

('Prince Caspian', '9780064405003', '2025-01-01', 2025, 208, 'eng', 'paperback', 7.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'HarperCollins'),
  (SELECT category_id FROM categories WHERE category_name = 'Children')),

('The Voyage of the Dawn Treader', '9780064405027', '2025-01-01', 2025, 224, 'eng', 'paperback', 7.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'HarperCollins'),
  (SELECT category_id FROM categories WHERE category_name = 'Children')),

('The Silver Chair', '9780064405041', '2025-01-01', 2025, 240, 'eng', 'paperback', 7.99, 100, true,
  (SELECT publisher_id FROM publishers WHERE publisher_name = 'HarperCollins'),
  (SELECT category_id FROM categories WHERE category_name = 'Children'));

-- Book Authors (linking existing Tolkien author to these books)
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780547928227'), (SELECT author_id FROM authors WHERE last_name = 'Tolkien'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780547928210'), (SELECT author_id FROM authors WHERE last_name = 'Tolkien'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780547928203'), (SELECT author_id FROM authors WHERE last_name = 'Tolkien'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780547928197'), (SELECT author_id FROM authors WHERE last_name = 'Tolkien'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405058'), (SELECT author_id FROM authors WHERE last_name = 'Tolkien'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780064471046'), (SELECT author_id FROM authors WHERE last_name = 'Tolkien'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405010'), (SELECT author_id FROM authors WHERE last_name = 'Tolkien'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405003'), (SELECT author_id FROM authors WHERE last_name = 'Tolkien'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405027'), (SELECT author_id FROM authors WHERE last_name = 'Tolkien'), 'author', 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405041'), (SELECT author_id FROM authors WHERE last_name = 'Tolkien'), 'author', 1);

-- Additional Categories
INSERT INTO categories (category_name, description, is_active) VALUES
('Adventure', 'Adventure stories', true);

-- Book Categories
INSERT INTO book_categories (book_id, category_id) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780547928227'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780547928227'), (SELECT category_id FROM categories WHERE category_name = 'Adventure')),
((SELECT book_id FROM books WHERE isbn_13 = '9780547928210'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780547928210'), (SELECT category_id FROM categories WHERE category_name = 'Adventure')),
((SELECT book_id FROM books WHERE isbn_13 = '9780547928203'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780547928203'), (SELECT category_id FROM categories WHERE category_name = 'Adventure')),
((SELECT book_id FROM books WHERE isbn_13 = '9780547928197'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780547928197'), (SELECT category_id FROM categories WHERE category_name = 'Adventure')),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405058'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405058'), (SELECT category_id FROM categories WHERE category_name = 'Children')),
((SELECT book_id FROM books WHERE isbn_13 = '9780064471046'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780064471046'), (SELECT category_id FROM categories WHERE category_name = 'Children')),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405010'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405010'), (SELECT category_id FROM categories WHERE category_name = 'Children')),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405003'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405003'), (SELECT category_id FROM categories WHERE category_name = 'Children')),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405027'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405027'), (SELECT category_id FROM categories WHERE category_name = 'Children')),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405041'), (SELECT category_id FROM categories WHERE category_name = 'Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405041'), (SELECT category_id FROM categories WHERE category_name = 'Children'));

-- Additional Genres
INSERT INTO genres (genre_name, description, is_active) VALUES
('High Fantasy', 'Fantasy set in an alternative world', true);

-- Book Genres
INSERT INTO book_genres (book_id, genre_id) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780547928227'), (SELECT genre_id FROM genres WHERE genre_name = 'High Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780547928210'), (SELECT genre_id FROM genres WHERE genre_name = 'High Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780547928203'), (SELECT genre_id FROM genres WHERE genre_name = 'High Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780547928197'), (SELECT genre_id FROM genres WHERE genre_name = 'High Fantasy')),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405058'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780064471046'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405010'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405003'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405027'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature')),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405041'), (SELECT genre_id FROM genres WHERE genre_name = 'Fantasy Literature'));

-- Book Series Entries (adding entries for LOTR and Narnia series)
INSERT INTO book_series_entries (book_id, series_id, volume_number) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780547928227'), (SELECT series_id FROM book_series WHERE series_name = 'The Lord of the Rings'), 0), -- Hobbit is a prequel
((SELECT book_id FROM books WHERE isbn_13 = '9780547928210'), (SELECT series_id FROM book_series WHERE series_name = 'The Lord of the Rings'), 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780547928203'), (SELECT series_id FROM book_series WHERE series_name = 'The Lord of the Rings'), 2),
((SELECT book_id FROM books WHERE isbn_13 = '9780547928197'), (SELECT series_id FROM book_series WHERE series_name = 'The Lord of the Rings'), 3);

-- Adding The Chronicles of Narnia series
INSERT INTO book_series (series_name, description, total_books, is_completed) VALUES
('The Chronicles of Narnia', 'Journeys to the world of Narnia', 7, true);

-- Adding series entries for Narnia books
INSERT INTO book_series_entries (book_id, series_id, volume_number) VALUES
((SELECT book_id FROM books WHERE isbn_13 = '9780064405058'), (SELECT series_id FROM book_series WHERE series_name = 'The Chronicles of Narnia'), 1),
((SELECT book_id FROM books WHERE isbn_13 = '9780064471046'), (SELECT series_id FROM book_series WHERE series_name = 'The Chronicles of Narnia'), 2),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405010'), (SELECT series_id FROM book_series WHERE series_name = 'The Chronicles of Narnia'), 3),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405003'), (SELECT series_id FROM book_series WHERE series_name = 'The Chronicles of Narnia'), 4),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405027'), (SELECT series_id FROM book_series WHERE series_name = 'The Chronicles of Narnia'), 5),
((SELECT book_id FROM books WHERE isbn_13 = '9780064405041'), (SELECT series_id FROM book_series WHERE series_name = 'The Chronicles of Narnia'), 6);