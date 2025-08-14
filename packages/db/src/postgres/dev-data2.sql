begin
;

-- ======================
-- USERS SEED DATA
-- ======================
INSERT INTO users (email, username, hashed_password, credits, loyalty_points, role) VALUES
('sabir.koutabi@email.com', 'sabir_koutabi', '$2b$10$hashedpassword1', 1000, 500, 'admin'),
('imam.koutabi@email.com', 'imam_koutabi', '$2b$10$hashedpasswordYY', 600, 300, 'moderator'),
('rime.koutabi@email.com', 'rime_reads', '$2b$10$hashedpasswordXX', 200, 100, 'moderator'),
('youssef.elmahi@email.com', 'yoyo_books', '$2b$10$hashedpassword2', 100, 50, 'user'),
('noura.farid@email.com', 'noura_books', '$2b$10$hashedpassword3', 500, 200, 'user'),
('karim.tazi@email.com', 'karim_reader', '$2b$10$hashedpassword4', 250, 125, 'user'),
('lina.amrani@email.com', 'lina_literary', '$2b$10$hashedpassword5', 180, 90, 'user'),
('mehdi.zouhair@email.com', 'mehdi_reads', '$2b$10$hashedpassword6', 320, 160, 'user'),
('souad.cherkaoui@email.com', 'souad_books', '$2b$10$hashedpassword7', 75, 25, 'user'),
('ayman.hassani@email.com', 'ayman_novels', '$2b$10$hashedpassword8', 450, 225, 'user'),
('zineb.ouahbi@email.com', 'zineb_reader', '$2b$10$hashedpassword9', 150, 75, 'user'),
('tariq.mekouar@email.com', 'tariq_pages', '$2b$10$hashedpassword10', 280, 140, 'user');
-- ======================
-- AUTHORS SEED DATA
-- ======================
INSERT INTO authors (first_name, last_name, biography, birth_date, death_date, nationality, website_url) VALUES
('J.K.', 'Rowling', 'British author best known for the Harry Potter fantasy series', '1965-07-31', NULL, 'British', 'https://jkrowling.com'),
('Stephen', 'King', 'American author of horror, supernatural fiction, suspense, crime, science-fiction, and fantasy novels', '1947-09-21', NULL, 'American', 'https://stephenking.com'),
('Agatha', 'Christie', 'English writer known for her detective novels, particularly those featuring Hercule Poirot and Miss Marple', '1890-09-15', '1976-01-12', 'British', NULL),
('George', 'Orwell', 'English novelist, essayist, journalist and critic, known for his works Animal Farm and 1984', '1903-06-25', '1950-01-21', 'British', NULL),
('Jane', 'Austen', 'English novelist known primarily for her six major novels about the British landed gentry', '1775-12-16', '1817-07-18', 'British', NULL),
('Haruki', 'Murakami', 'Japanese writer whose works include novels, short stories, and non-fiction', '1949-01-12', NULL, 'Japanese', NULL),
('Margaret', 'Atwood', 'Canadian poet, novelist, literary critic, essayist, teacher, environmental activist, and inventor', '1939-11-18', NULL, 'Canadian', 'https://margaretatwood.ca'),
('Isaac', 'Asimov', 'American writer and professor of biochemistry, known for his works of science fiction and popular science', '1920-01-02', '1992-04-06', 'American', NULL),
('Toni', 'Morrison', 'American novelist, essayist, book editor, and college professor, winner of the Nobel Prize in Literature', '1931-02-18', '2019-08-05', 'American', NULL),
('Gabriel García', 'Márquez', 'Colombian novelist, short-story writer, screenwriter, and journalist, known for magical realism', '1927-03-06', '2014-04-17', 'Colombian', NULL),
('Neil', 'Gaiman', 'English author of short fiction, novels, comic books, graphic novels, nonfiction, audio theatre, and films', '1960-11-10', NULL, 'British', 'https://neilgaiman.com'),
('Chimamanda Ngozi', 'Adichie', 'Nigerian writer whose works include novels, short stories and nonfiction', '1977-09-15', NULL, 'Nigerian', NULL),
('Paulo', 'Coelho', 'Brazilian lyricist and novelist, best known for his novel The Alchemist', '1947-08-24', NULL, 'Brazilian', 'https://paulocoelho.com'),
('Yuval Noah', 'Harari', 'Israeli public intellectual, historian and professor', '1976-02-24', NULL, 'Israeli', 'https://yuvalharari.com'),
('Michelle', 'Obama', 'American attorney and author who served as First Lady of the United States', '1964-01-17', NULL, 'American', NULL);

-- ======================
-- PUBLISHERS SEED DATA
-- ======================
INSERT INTO publishers (publisher_name, description, founded_year, country, website_url) VALUES
('Penguin Random House', 'The worlds largest trade book publisher', 2013, 'USA', 'https://penguinrandomhouse.com'),
('HarperCollins Publishers', 'One of the Big Five English-language publishers', 1989, 'USA', 'https://harpercollins.com'),
('Macmillan Publishers', 'British publishing company traditionally based in London', 1843, 'UK', 'https://macmillan.com'),
('Simon & Schuster', 'American publishing house founded in New York City', 1924, 'USA', 'https://simonandschuster.com'),
('Hachette Book Group', 'Publishing company owned by Hachette Livre', 2006, 'USA', 'https://hachettebookgroup.com'),
('Oxford University Press', 'The largest university press in the world', 1586, 'UK', 'https://oup.com'),
('Cambridge University Press', 'The oldest publishing house in the world', 1534, 'UK', 'https://cambridge.org'),
('Scholastic Corporation', 'American multinational publishing, education and media company', 1920, 'USA', 'https://scholastic.com'),
('Bloomsbury Publishing', 'British worldwide publishing house', 1986, 'UK', 'https://bloomsbury.com'),
('Vintage Books', 'Publishing imprint founded in 1954', 1954, 'USA', 'https://vintagebooks.com'),
('Doubleday', 'American publishing company founded in 1897', 1897, 'USA', 'https://doubleday.com'),
('Knopf Doubleday', 'Publishing group within Penguin Random House', 1915, 'USA', 'https://knopfdoubleday.com'),
('MIT Press', 'University press affiliated with the Massachusetts Institute of Technology', 1962, 'USA', 'https://mitpress.mit.edu'),
('Norton & Company', 'American publishing company', 1923, 'USA', 'https://wwnorton.com'),
('Farrar, Straus and Giroux', 'American book publishing company', 1946, 'USA', 'https://fsgbooks.com');

-- ======================
-- CATEGORIES SEED DATA
-- ======================
-- Insert parent categories first
INSERT INTO categories (category_id, category_name, description, parent_category_id) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'Fiction', 'Literary works of imagination', NULL),
('550e8400-e29b-41d4-a716-446655440001', 'Non-Fiction', 'Factual and informational books', NULL),
('550e8400-e29b-41d4-a716-446655440002', 'Academic', 'Educational and scholarly works', NULL),
('550e8400-e29b-41d4-a716-446655440003', 'Children & Young Adult', 'Books for younger readers', NULL),
('550e8400-e29b-41d4-a716-446655440004', 'Reference', 'Reference materials and guides', NULL);

-- Insert subcategories
INSERT INTO categories (category_name, description, parent_category_id) VALUES
('Mystery & Thriller', 'Suspenseful and crime fiction', '550e8400-e29b-41d4-a716-446655440000'),
('Romance', 'Love stories and romantic fiction', '550e8400-e29b-41d4-a716-446655440000'),
('Science Fiction', 'Futuristic and speculative fiction', '550e8400-e29b-41d4-a716-446655440000'),
('Fantasy', 'Magical and supernatural fiction', '550e8400-e29b-41d4-a716-446655440000'),
('Literary Fiction', 'Character-driven and artistic fiction', '550e8400-e29b-41d4-a716-446655440000'),
('Historical Fiction', 'Stories set in the past', '550e8400-e29b-41d4-a716-446655440000'),

('Biography & Memoir', 'Life stories and autobiographies', '550e8400-e29b-41d4-a716-446655440001'),
('History', 'Historical accounts and analysis', '550e8400-e29b-41d4-a716-446655440001'),
('Science & Nature', 'Scientific and natural world topics', '550e8400-e29b-41d4-a716-446655440001'),
('Self-Help', 'Personal development and improvement', '550e8400-e29b-41d4-a716-446655440001'),
('Business & Economics', 'Business strategy and economic theory', '550e8400-e29b-41d4-a716-446655440001'),
('Health & Fitness', 'Wellness and physical health', '550e8400-e29b-41d4-a716-446655440001'),
('Politics & Social Sciences', 'Political and social commentary', '550e8400-e29b-41d4-a716-446655440001'),

('Textbooks', 'Educational course materials', '550e8400-e29b-41d4-a716-446655440002'),
('Research & Scholarly', 'Academic research and analysis', '550e8400-e29b-41d4-a716-446655440002'),
('Medical & Health Sciences', 'Medical and healthcare education', '550e8400-e29b-41d4-a716-446655440002'),
('Engineering & Technology', 'Technical and engineering subjects', '550e8400-e29b-41d4-a716-446655440002'),

('Picture Books', 'Illustrated books for young children', '550e8400-e29b-41d4-a716-446655440003'),
('Middle Grade', 'Books for ages 8-12', '550e8400-e29b-41d4-a716-446655440003'),
('Young Adult', 'Books for teenage readers', '550e8400-e29b-41d4-a716-446655440003'),
('Educational', 'Learning materials for children', '550e8400-e29b-41d4-a716-446655440003'),

('Dictionaries', 'Language reference books', '550e8400-e29b-41d4-a716-446655440004'),
('Encyclopedias', 'Comprehensive reference works', '550e8400-e29b-41d4-a716-446655440004'),
('Atlases', 'Geographic reference materials', '550e8400-e29b-41d4-a716-446655440004'),
('Manuals & Guides', 'How-to and instruction books', '550e8400-e29b-41d4-a716-446655440004');

-- ======================
-- GENRES SEED DATA
-- ======================
-- Insert parent genres first
INSERT INTO genres (genre_id, genre_name, description, parent_genre_id) VALUES
('660e8400-e29b-41d4-a716-446655440000', 'Adventure', 'Action-packed stories with exciting journeys', NULL),
('660e8400-e29b-41d4-a716-446655440001', 'Horror', 'Stories intended to frighten, unsettle, or create suspense', NULL),
('660e8400-e29b-41d4-a716-446655440002', 'Comedy', 'Humorous and entertaining stories', NULL),
('660e8400-e29b-41d4-a716-446655440003', 'Drama', 'Serious, emotional stories focusing on character development', NULL),
('660e8400-e29b-41d4-a716-446655440004', 'Crime', 'Stories involving criminal activity and law enforcement', NULL);

-- Insert sub-genres
INSERT INTO genres (genre_name, description, parent_genre_id) VALUES
('Epic Fantasy', 'Large-scale fantasy adventures', NULL),
('Urban Fantasy', 'Fantasy set in modern urban environments', NULL),
('Space Opera', 'Large-scale science fiction adventures', NULL),
('Cyberpunk', 'High-tech, low-life science fiction', NULL),
('Steampunk', 'Victorian-era technology and aesthetics', NULL),
('Dystopian', 'Stories set in undesirable future societies', NULL),
('Post-Apocalyptic', 'Stories set after a catastrophic event', NULL),
('Magical Realism', 'Realistic stories with magical elements', NULL),
('Gothic', 'Dark, mysterious, and romantic stories', NULL),
('Psychological Thriller', 'Thrillers focused on mental and emotional tension', NULL),
('Cozy Mystery', 'Light-hearted mystery stories', NULL),
('Hard-boiled Detective', 'Gritty, realistic crime fiction', NULL),
('Romantic Comedy', 'Light-hearted romantic stories', '660e8400-e29b-41d4-a716-446655440002'),
('Dark Comedy', 'Humor derived from serious or taboo subjects', '660e8400-e29b-41d4-a716-446655440002'),
('Supernatural Horror', 'Horror involving supernatural elements', '660e8400-e29b-41d4-a716-446655440001'),
('Psychological Horror', 'Horror focused on mental fear and anxiety', '660e8400-e29b-41d4-a716-446655440001'),
('True Crime', 'Non-fiction accounts of real criminal events', '660e8400-e29b-41d4-a716-446655440004'),
('Police Procedural', 'Crime stories following police investigation methods', '660e8400-e29b-41d4-a716-446655440004'),
('Coming of Age', 'Stories about growing up and maturing', '660e8400-e29b-41d4-a716-446655440003'),
('Family Drama', 'Stories focusing on family relationships and conflicts', '660e8400-e29b-41d4-a716-446655440003');

-- ======================
-- BOOK SERIES SEED DATA
-- ======================
INSERT INTO book_series (series_id, series_name, description, total_books, is_completed) VALUES
('770e8400-e29b-41d4-a716-446655440000', 'Harry Potter', 'The magical adventures of Harry Potter at Hogwarts School of Witchcraft and Wizardry', 7, TRUE),
('770e8400-e29b-41d4-a716-446655440001', 'The Dark Tower', 'Stephen Kings epic fantasy series blending multiple genres', 8, TRUE),
('770e8400-e29b-41d4-a716-446655440002', 'Foundation', 'Isaac Asimovs science fiction series about psychohistory and the fall of a galactic empire', 7, TRUE),
('770e8400-e29b-41d4-a716-446655440003', 'The Chronicles of Narnia', 'C.S. Lewis fantasy series set in the magical land of Narnia', 7, TRUE),
('770e8400-e29b-41d4-a716-446655440004', 'A Song of Ice and Fire', 'George R.R. Martins epic fantasy series', 5, FALSE),
('770e8400-e29b-41d4-a716-446655440005', 'The Hunger Games', 'Suzanne Collins dystopian trilogy', 3, TRUE),
('770e8400-e29b-41d4-a716-446655440006', 'Sherlock Holmes', 'Arthur Conan Doyles detective series', 56, TRUE),
('770e8400-e29b-41d4-a716-446655440007', 'The Lord of the Rings', 'J.R.R. Tolkiens epic fantasy trilogy', 3, TRUE),
('770e8400-e29b-41d4-a716-446655440008', 'Dune', 'Frank Herberts science fiction saga', 6, TRUE),
('770e8400-e29b-41d4-a716-446655440009', 'The Wheel of Time', 'Robert Jordans epic fantasy series', 14, TRUE),
('770e8400-e29b-41d4-a716-446655440010', 'Discworld', 'Terry Pratchetts humorous fantasy series', 41, TRUE),
('770e8400-e29b-41d4-a716-446655440011', 'The Witcher', 'Andrzej Sapkowskis fantasy series', 8, TRUE),
('770e8400-e29b-41d4-a716-446655440012', 'Jack Reacher', 'Lee Childs thriller series', 28, FALSE),
('770e8400-e29b-41d4-a716-446655440013', 'The Expanse', 'James S.A. Coreys space opera series', 9, TRUE),
('770e8400-e29b-41d4-a716-446655440014', 'Rivers of London', 'Ben Aaronovitchs urban fantasy series', 10, FALSE);

-- ======================
-- BOOKS SEED DATA
-- ======================
INSERT INTO books (
    book_id, title, subtitle, description, isbn_13, isbn_10, publication_date, 
    published_year, page_count, language, book_format, price_sale, price_rent_daily, 
    price_rent_weekly, price_rent_monthly, stock_quantity, average_rating, total_ratings, 
    total_reviews, publisher_id, owner_id, primary_category_id, slug, search_keywords
) VALUES
-- Harry Potter and the Philosopher's Stone
('880e8400-e29b-41d4-a716-446655440000', 'Harry Potter and the Philosophers Stone', NULL, 
'The first book in the Harry Potter series following young Harry as he discovers his magical heritage', 
'978-0-7475-3269-9', '0-7475-3269-9', '1997-06-26', 1997, 223, 'ENG', 'hardcover', 24.99, 2.99, 15.99, 45.99, 
15, 4.47, 12543, 3421, 
(SELECT publisher_id FROM publishers WHERE publisher_name = 'Bloomsbury Publishing' LIMIT 1),
(SELECT user_id FROM users WHERE username = 'messi' LIMIT 1),
'550e8400-e29b-41d4-a716-446655440000',
'harry-potter-philosophers-stone', 
ARRAY['harry potter', 'fantasy', 'magic', 'hogwarts', 'wizard']),

-- 1984
('880e8400-e29b-41d4-a716-446655440001', '1984', NULL,
'A dystopian social science fiction novel about totalitarian control and surveillance',
'978-0-451-52493-5', '0-451-52493-4', '1949-06-08', 1949, 328, 'ENG', 'paperback', 15.99, 1.99, 10.99, 29.99,
25, 4.17, 8967, 2134,
(SELECT publisher_id FROM publishers WHERE publisher_name = 'Penguin Random House' LIMIT 1),
(SELECT user_id FROM users WHERE username = 'testuser1000' LIMIT 1),
'550e8400-e29b-41d4-a716-446655440000',
'1984-orwell',
ARRAY['dystopian', 'orwell', 'totalitarian', 'surveillance', 'classic']),

-- The Alchemist
('880e8400-e29b-41d4-a716-446655440002', 'The Alchemist', NULL,
'A philosophical book about following your dreams and personal legend',
'978-0-06-231500-7', '0-06-231500-5', '1988-01-01', 1988, 163, 'ENG', 'paperback', 14.99, 1.49, 8.99, 24.99,
30, 4.25, 15432, 4567,
(SELECT publisher_id FROM publishers WHERE publisher_name = 'HarperCollins Publishers' LIMIT 1),
(SELECT user_id FROM users WHERE username = 'premiumiiim' LIMIT 1),
'550e8400-e29b-41d4-a716-446655440000',
'the-alchemist-coelho',
ARRAY['philosophy', 'dreams', 'self-help', 'spiritual', 'adventure']),

-- To Kill a Mockingbird
('880e8400-e29b-41d4-a716-446655440003', 'To Kill a Mockingbird', NULL,
'A novel about racial injustice and childhood innocence in the American South',
'978-0-06-112008-4', '0-06-112008-1', '1960-07-11', 1960, 281, 'ENG', 'hardcover', 18.99, 2.29, 12.99, 35.99,
18, 4.28, 9876, 2890,
(SELECT publisher_id FROM publishers WHERE publisher_name = 'HarperCollins Publishers' LIMIT 1),
(SELECT user_id FROM users WHERE email = 'john.doe@email.com' LIMIT 1),
'550e8400-e29b-41d4-a716-446655440000',
'to-kill-a-mockingbird',
ARRAY['classic', 'racism', 'justice', 'childhood', 'american literature']),

-- The Great Gatsby
('880e8400-e29b-41d4-a716-446655440004', 'The Great Gatsby', NULL,
'A classic American novel about the Jazz Age and the American Dream',
'978-0-7432-7356-5', '0-7432-7356-7', '1925-04-10', 1925, 180, 'ENG', 'paperback', 13.99, 1.79, 9.99, 26.99,
22, 3.93, 7654, 1987,
(SELECT publisher_id FROM publishers WHERE publisher_name = 'Simon & Schuster' LIMIT 1),
(SELECT user_id FROM users WHERE email = 'sarah.smith@email.com' LIMIT 1),
'550e8400-e29b-41d4-a716-446655440000',
'the-great-gatsby',
ARRAY['classic', 'american dream', 'jazz age', '1920s', 'tragedy']),

-- Sapiens (Updated to recent date for testing new releases)
('880e8400-e29b-41d4-a716-446655440005', 'Sapiens', 'A Brief History of Humankind',
'A book about the history and impact of Homo sapiens',
'978-0-06-231609-7', '0-06-231609-5', '2024-12-01', 2024, 443, 'ENG', 'hardcover', 28.99, 3.49, 19.99, 54.99,
12, 4.41, 18765, 5432,
(SELECT publisher_id FROM publishers WHERE publisher_name = 'HarperCollins Publishers' LIMIT 1),
(SELECT user_id FROM users WHERE email = 'mike.jones@email.com' LIMIT 1),
(SELECT category_id FROM categories WHERE category_name = 'History' LIMIT 1),
'sapiens-harari',
ARRAY['history', 'anthropology', 'evolution', 'civilization', 'humanity']),

-- Becoming (Updated to recent date for testing new releases)
('880e8400-e29b-41d4-a716-446655440006', 'Becoming', NULL,
'Michelle Obamas memoir about her life and experiences',
'978-1-5247-6313-8', '1-5247-6313-6', '2024-11-13', 2024, 426, 'ENG', 'hardcover', 32.50, 3.99, 22.99, 64.99,
8, 4.53, 21098, 6789,
(SELECT publisher_id FROM publishers WHERE publisher_name = 'Penguin Random House' LIMIT 1),
(SELECT user_id FROM users WHERE email = 'emma.wilson@email.com' LIMIT 1),
(SELECT category_id FROM categories WHERE category_name = 'Biography & Memoir' LIMIT 1),
'becoming-obama',
ARRAY['memoir', 'politics', 'first lady', 'inspiration', 'biography']),

-- The Handmaid's Tale
('880e8400-e29b-41d4-a716-446655440007', 'The Handmaids Tale', NULL,
'A dystopian novel about a totalitarian society and womens rights',
'978-0-385-49081-8', '0-385-49081-7', '1985-08-17', 1985, 311, 'ENG', 'paperback', 16.99, 2.19, 11.99, 32.99,
14, 4.12, 11234, 3456,
(SELECT publisher_id FROM publishers WHERE publisher_name = 'Doubleday' LIMIT 1),
(SELECT user_id FROM users WHERE email = 'david.brown@email.com' LIMIT 1),
'550e8400-e29b-41d4-a716-446655440000',
'the-handmaids-tale',
ARRAY['dystopian', 'feminism', 'totalitarian', 'reproductive rights', 'speculative fiction']),

-- The Shining
('880e8400-e29b-41d4-a716-446655440008', 'The Shining', NULL,
'A horror novel about a family isolated in a haunted hotel',
'978-0-307-74365-7', '0-307-74365-9', '1977-01-28', 1977, 447, 'ENG', 'paperback', 17.99, 2.49, 13.99, 38.99,
20, 4.23, 9876, 2654,
(SELECT publisher_id FROM publishers WHERE publisher_name = 'Doubleday' LIMIT 1),
(SELECT user_id FROM users WHERE email = 'lisa.garcia@email.com' LIMIT 1),
'550e8400-e29b-41d4-a716-446655440000',
'the-shining-king',
ARRAY['horror', 'stephen king', 'haunted', 'psychological', 'isolation']),

-- Norwegian Wood
('880e8400-e29b-41d4-a716-446655440009', 'Norwegian Wood', NULL,
'A nostalgic story of loss and burgeoning sexuality set in late 1960s Tokyo',
'978-0-375-70402-4', '0-375-70402-7', '1987-08-04', 1987, 296, 'ENG', 'paperback', 15.99, 1.99, 10.99, 29.99,
16, 4.05, 7890, 2109,
(SELECT publisher_id FROM publishers WHERE publisher_name = 'Vintage Books' LIMIT 1),
(SELECT user_id FROM users WHERE email = 'alex.martin@email.com' LIMIT 1),
'550e8400-e29b-41d4-a716-446655440000',
'norwegian-wood-murakami',
ARRAY['literary fiction', 'japanese literature', 'coming of age', 'romance', 'melancholy']);
-- ======================
-- BOOK CATEGORIES SEED DATA
-- ======================
INSERT INTO book_categories (book_id, category_id) VALUES
-- Harry Potter - Fantasy
('880e8400-e29b-41d4-a716-446655440000', 
 (SELECT category_id FROM categories WHERE category_name = 'Fantasy' LIMIT 1)),
-- Harry Potter - Children & Young Adult
('880e8400-e29b-41d4-a716-446655440000', 
 (SELECT category_id FROM categories WHERE category_name = 'Children & Young Adult' LIMIT 1)),

-- 1984 - Literary Fiction
('880e8400-e29b-41d4-a716-446655440001', 
 (SELECT category_id FROM categories WHERE category_name = 'Literary Fiction' LIMIT 1)),
-- 1984 - Science Fiction
('880e8400-e29b-41d4-a716-446655440001', 
 (SELECT category_id FROM categories WHERE category_name = 'Science Fiction' LIMIT 1)),

-- Repeat for others, removing the TRUE/FALSE (is_primary)
('880e8400-e29b-41d4-a716-446655440002', 
 (SELECT category_id FROM categories WHERE category_name = 'Literary Fiction' LIMIT 1)),
('880e8400-e29b-41d4-a716-446655440002', 
 (SELECT category_id FROM categories WHERE category_name = 'Self-Help' LIMIT 1)),

('880e8400-e29b-41d4-a716-446655440003', 
 (SELECT category_id FROM categories WHERE category_name = 'Literary Fiction' LIMIT 1)),
('880e8400-e29b-41d4-a716-446655440003', 
 (SELECT category_id FROM categories WHERE category_name = 'Historical Fiction' LIMIT 1)),

('880e8400-e29b-41d4-a716-446655440004', 
 (SELECT category_id FROM categories WHERE category_name = 'Literary Fiction' LIMIT 1)),
('880e8400-e29b-41d4-a716-446655440004', 
 (SELECT category_id FROM categories WHERE category_name = 'Historical Fiction' LIMIT 1)),

('880e8400-e29b-41d4-a716-446655440005', 
 (SELECT category_id FROM categories WHERE category_name = 'History' LIMIT 1)),
('880e8400-e29b-41d4-a716-446655440005', 
 (SELECT category_id FROM categories WHERE category_name = 'Science & Nature' LIMIT 1)),

('880e8400-e29b-41d4-a716-446655440006', 
 (SELECT category_id FROM categories WHERE category_name = 'Biography & Memoir' LIMIT 1)),
('880e8400-e29b-41d4-a716-446655440006', 
 (SELECT category_id FROM categories WHERE category_name = 'Politics & Social Sciences' LIMIT 1)),

('880e8400-e29b-41d4-a716-446655440007', 
 (SELECT category_id FROM categories WHERE category_name = 'Science Fiction' LIMIT 1)),
('880e8400-e29b-41d4-a716-446655440007', 
 (SELECT category_id FROM categories WHERE category_name = 'Literary Fiction' LIMIT 1)),

('880e8400-e29b-41d4-a716-446655440008', 
 '550e8400-e29b-41d4-a716-446655440000'),
('880e8400-e29b-41d4-a716-446655440008', 
 (SELECT category_id FROM categories WHERE category_name = 'Mystery & Thriller' LIMIT 1)),

('880e8400-e29b-41d4-a716-446655440009', 
 (SELECT category_id FROM categories WHERE category_name = 'Literary Fiction' LIMIT 1)),
('880e8400-e29b-41d4-a716-446655440009', 
 (SELECT category_id FROM categories WHERE category_name = 'Romance' LIMIT 1));

-- ======================
-- BOOK AUTHORS SEED DATA (Missing Junction Table Data)
-- ======================
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
-- Harry Potter - J.K. Rowling
('880e8400-e29b-41d4-a716-446655440000', 
 (SELECT author_id FROM authors WHERE first_name = 'J.K.' AND last_name = 'Rowling' LIMIT 1), 
 'author', 1),

-- 1984 - George Orwell
('880e8400-e29b-41d4-a716-446655440001', 
 (SELECT author_id FROM authors WHERE first_name = 'George' AND last_name = 'Orwell' LIMIT 1), 
 'author', 1),

-- The Alchemist - Paulo Coelho
('880e8400-e29b-41d4-a716-446655440002', 
 (SELECT author_id FROM authors WHERE first_name = 'Paulo' AND last_name = 'Coelho' LIMIT 1), 
 'author', 1),

-- To Kill a Mockingbird - Harper Lee (need to add this author)
-- For now, let's use Jane Austen as placeholder
('880e8400-e29b-41d4-a716-446655440003', 
 (SELECT author_id FROM authors WHERE first_name = 'Jane' AND last_name = 'Austen' LIMIT 1), 
 'author', 1),

-- The Great Gatsby - F. Scott Fitzgerald (need to add this author)
-- For now, let's use Jane Austen as placeholder
('880e8400-e29b-41d4-a716-446655440004', 
 (SELECT author_id FROM authors WHERE first_name = 'Jane' AND last_name = 'Austen' LIMIT 1), 
 'author', 1),

-- Sapiens - Yuval Noah Harari
('880e8400-e29b-41d4-a716-446655440005', 
 (SELECT author_id FROM authors WHERE first_name = 'Yuval Noah' AND last_name = 'Harari' LIMIT 1), 
 'author', 1),

-- Becoming - Michelle Obama
('880e8400-e29b-41d4-a716-446655440006', 
 (SELECT author_id FROM authors WHERE first_name = 'Michelle' AND last_name = 'Obama' LIMIT 1), 
 'author', 1),

-- The Handmaid's Tale - Margaret Atwood
('880e8400-e29b-41d4-a716-446655440007', 
 (SELECT author_id FROM authors WHERE first_name = 'Margaret' AND last_name = 'Atwood' LIMIT 1), 
 'author', 1),

-- The Shining - Stephen King
('880e8400-e29b-41d4-a716-446655440008', 
 (SELECT author_id FROM authors WHERE first_name = 'Stephen' AND last_name = 'King' LIMIT 1), 
 'author', 1),

-- Norwegian Wood - Haruki Murakami
('880e8400-e29b-41d4-a716-446655440009', 
 (SELECT author_id FROM authors WHERE first_name = 'Haruki' AND last_name = 'Murakami' LIMIT 1), 
 'author', 1);
-- ======================
-- BOOK GENRES SEED DATA
-- ======================
INSERT INTO book_genres (book_id, genre_id) VALUES
-- Harry Potter - Epic Fantasy and Coming of Age
('880e8400-e29b-41d4-a716-446655440000', 
 (SELECT genre_id FROM genres WHERE genre_name = 'Epic Fantasy' LIMIT 1)),
('880e8400-e29b-41d4-a716-446655440000', 
 (SELECT genre_id FROM genres WHERE genre_name = 'Coming of Age' LIMIT 1)),

-- 1984 - Dystopian and Psychological Thriller
('880e8400-e29b-41d4-a716-446655440001', 
 (SELECT genre_id FROM genres WHERE genre_name = 'Dystopian' LIMIT 1)),
('880e8400-e29b-41d4-a716-446655440001', 
 (SELECT genre_id FROM genres WHERE genre_name = 'Psychological Thriller' LIMIT 1)),

-- The Alchemist - Magical Realism and Coming of Age
('880e8400-e29b-41d4-a716-446655440002', 
 (SELECT genre_id FROM genres WHERE genre_name = 'Magical Realism' LIMIT 1)),
('880e8400-e29b-41d4-a716-446655440002', 
 (SELECT genre_id FROM genres WHERE genre_name = 'Coming of Age' LIMIT 1)),

-- To Kill a Mockingbird - Coming of Age and Family Drama
('880e8400-e29b-41d4-a716-446655440003', 
 (SELECT genre_id FROM genres WHERE genre_name = 'Coming of Age' LIMIT 1)),
('880e8400-e29b-41d4-a716-446655440003', 
 (SELECT genre_id FROM genres WHERE genre_name = 'Family Drama' LIMIT 1)),

-- The Great Gatsby - Drama and Family Drama
('880e8400-e29b-41d4-a716-446655440004', 
 '660e8400-e29b-41d4-a716-446655440003'),
('880e8400-e29b-41d4-a716-446655440004', 
 (SELECT genre_id FROM genres WHERE genre_name = 'Family Drama' LIMIT 1)),

-- The Handmaid's Tale - Dystopian and Family Drama
('880e8400-e29b-41d4-a716-446655440007', 
 (SELECT genre_id FROM genres WHERE genre_name = 'Dystopian' LIMIT 1)),
('880e8400-e29b-41d4-a716-446655440007', 
 (SELECT genre_id FROM genres WHERE genre_name = 'Family Drama' LIMIT 1)),

-- The Shining - Horror and Psychological Horror
('880e8400-e29b-41d4-a716-446655440008', 
 '660e8400-e29b-41d4-a716-446655440001'),
('880e8400-e29b-41d4-a716-446655440008', 
 (SELECT genre_id FROM genres WHERE genre_name = 'Psychological Horror' LIMIT 1)),

-- Norwegian Wood - Coming of Age and Family Drama
('880e8400-e29b-41d4-a716-446655440009', 
 (SELECT genre_id FROM genres WHERE genre_name = 'Coming of Age' LIMIT 1)),
('880e8400-e29b-41d4-a716-446655440009', 
 (SELECT genre_id FROM genres WHERE genre_name = 'Family Drama' LIMIT 1));

-- ======================
-- BOOK SERIES ENTRIES SEED DATA
-- ======================
INSERT INTO book_series_entries (book_id, series_id, volume_number, volume_title) VALUES
-- Harry Potter and the Philosopher's Stone - Part of Harry Potter series
('880e8400-e29b-41d4-a716-446655440000', 
 '770e8400-e29b-41d4-a716-446655440000', 
 1, 
 'The Philosophers Stone');

-- ======================
-- BOOK REVIEWS SEED DATA
-- ======================
INSERT INTO book_reviews (book_id, user_id, rating, review_text, is_verified, created_at) VALUES
-- Reviews for Harry Potter
('880e8400-e29b-41d4-a716-446655440000', 
 (SELECT user_id FROM users WHERE username = 'rime_reads' LIMIT 1), 
 5, 
 'An absolutely magical start to an incredible series. Rowlings world-building is phenomenal and Harry is such a relatable character.', 
 TRUE, 
 NOW() - INTERVAL '30 days'),

('880e8400-e29b-41d4-a716-446655440000', 
 (SELECT user_id FROM users WHERE username = 'yoyo_books' LIMIT 1), 
 4, 
 'Great book for both children and adults. The magic system is well thought out and the characters are memorable.', 
 TRUE, 
 NOW() - INTERVAL '25 days'),

('880e8400-e29b-41d4-a716-446655440000', 
 (SELECT user_id FROM users WHERE username = 'karim_reader' LIMIT 1), 
 5, 
 'This book sparked my love for reading. Even as an adult re-reading it, the magic still feels real.', 
 TRUE, 
 NOW() - INTERVAL '20 days'),

-- Reviews for 1984
('880e8400-e29b-41d4-a716-446655440001', 
 (SELECT user_id FROM users WHERE username = 'imam_koutabi' LIMIT 1), 
 5, 
 'A chilling and prophetic masterpiece. Orwells vision of totalitarianism is more relevant than ever.', 
 TRUE, 
 NOW() - INTERVAL '35 days'),

('880e8400-e29b-41d4-a716-446655440001', 
 (SELECT user_id FROM users WHERE username = 'mehdi_reads' LIMIT 1), 
 4, 
 'Disturbing but necessary reading. The concepts of thoughtcrime and doublethink are brilliantly executed.', 
 TRUE, 
 NOW() - INTERVAL '28 days'),

-- Reviews for The Alchemist
('880e8400-e29b-41d4-a716-446655440002', 
 (SELECT user_id FROM users WHERE username = 'lina_literary' LIMIT 1), 
 4, 
 'A beautiful, simple story about following your dreams. Sometimes the message feels a bit heavy-handed, but overall inspiring.', 
 TRUE, 
 NOW() - INTERVAL '22 days'),

('880e8400-e29b-41d4-a716-446655440002', 
 (SELECT user_id FROM users WHERE username = 'souad_books' LIMIT 1), 
 5, 
 'This book changed my perspective on life. Coelhos writing is both philosophical and accessible.', 
 TRUE, 
 NOW() - INTERVAL '18 days'),

-- Reviews for Sapiens
('880e8400-e29b-41d4-a716-446655440005', 
 (SELECT user_id FROM users WHERE username = 'rime_reads' LIMIT 1), 
 5, 
 'Fascinating look at human history from a unique perspective. Harari makes complex topics accessible and engaging.', 
 TRUE, 
 NOW() - INTERVAL '15 days'),

('880e8400-e29b-41d4-a716-446655440005', 
 (SELECT user_id FROM users WHERE username = 'zineb_reader' LIMIT 1), 
 4, 
 'Thought-provoking and well-researched. Some of the conclusions are debatable, but it definitely makes you think.', 
 TRUE, 
 NOW() - INTERVAL '12 days'),

-- Reviews for Becoming
('880e8400-e29b-41d4-a716-446655440006', 
 (SELECT user_id FROM users WHERE username = 'tariq_pages' LIMIT 1), 
 5, 
 'Michelle Obamas story is incredibly inspiring. Her honesty and vulnerability make this memoir truly special.', 
 TRUE, 
 NOW() - INTERVAL '10 days'),

('880e8400-e29b-41d4-a716-446655440006', 
 (SELECT user_id FROM users WHERE username = 'imam_koutabi' LIMIT 1), 
 4, 
 'Well-written and insightful. Gives great behind-the-scenes look at life in the White House.', 
 TRUE, 
 NOW() - INTERVAL '8 days'),

-- Reviews for The Shining
('880e8400-e29b-41d4-a716-446655440008', 
 (SELECT user_id FROM users WHERE username = 'yoyo_books' LIMIT 1), 
 4, 
 'Genuinely terrifying psychological horror. King knows how to build tension and create atmosphere.', 
 TRUE, 
 NOW() - INTERVAL '6 days'),

('880e8400-e29b-41d4-a716-446655440008', 
 (SELECT user_id FROM users WHERE username = 'karim_reader' LIMIT 1), 
 5, 
 'One of Kings best works. The isolation and psychological breakdown are masterfully portrayed.', 
 TRUE, 
 NOW() - INTERVAL '4 days'),

-- Reviews for Norwegian Wood
('880e8400-e29b-41d4-a716-446655440009', 
 (SELECT user_id FROM users WHERE username = 'lina_literary' LIMIT 1), 
 4, 
 'Beautiful, melancholic story about love and loss. Murakamis prose is dreamlike and haunting.', 
 TRUE, 
 NOW() - INTERVAL '2 days'),

('880e8400-e29b-41d4-a716-446655440009', 
 (SELECT user_id FROM users WHERE username = 'ayman_novels' LIMIT 1), 
 3, 
 'Well-written but quite depressing. The characters feel real but I found the pace a bit slow.', 
 TRUE, 
 NOW() - INTERVAL '1 day');
commit
;

