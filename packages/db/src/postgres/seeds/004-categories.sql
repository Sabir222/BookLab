INSERT INTO categories (category_name, description, parent_category_id, is_active)
VALUES
-- Top-level categories
('Fiction', 'Narrative literary works rooted in imagination.', NULL, true),
('Non-Fiction', 'Books based on factual information and real events.', NULL, true),
('Science Fiction', 'Fiction dealing with futuristic concepts and advanced technology.', NULL, true),
('Fantasy', 'Fiction involving magical or supernatural forces and beings.', NULL, true),
('Mystery', 'Fiction focused on solving a crime or uncovering secrets.', NULL, true),
('Romance', 'Fiction centered on love and romantic relationships.', NULL, true),
('Biography', 'A detailed description of a person''s life.', NULL, true),
('History', 'The study of past events.', NULL, true),
('Science', 'Systematic study of the structure and behavior of the physical and natural world.', NULL, true),
('Self-Help', 'Books intended to instruct readers on solving personal problems.', NULL, true),
('Comics', 'Narrative art form using sequential images, often combined with text.', NULL, true),
('Kids', 'Books specifically targeted at children, typically aged 0-12.', NULL, true);

-- Phase 2: Insert child categories (run this AFTER the above completes)
INSERT INTO categories (category_name, description, parent_category_id, is_active)
VALUES
-- Subcategories under Fiction
('Literary Fiction', 'Fiction prioritizing aesthetic value, character development, and thematic depth.', 
    (SELECT category_id FROM categories WHERE category_name = 'Fiction'), true),
('Thriller', 'Fiction designed to keep readers on the edge of their seats.', 
    (SELECT category_id FROM categories WHERE category_name = 'Fiction'), true),
('Horror', 'Fiction intended to scare, unsettle, or horrify the audience.', 
    (SELECT category_id FROM categories WHERE category_name = 'Fiction'), true),

-- Subcategories under Non-Fiction
('Memoir', 'A historical account or biography written from personal knowledge.', 
    (SELECT category_id FROM categories WHERE category_name = 'Non-Fiction'), true),
('Essays', 'A piece of writing on a particular subject, often short and informal.', 
    (SELECT category_id FROM categories WHERE category_name = 'Non-Fiction'), true),
('Travel', 'Books describing experiences, observations, and information about different places.', 
    (SELECT category_id FROM categories WHERE category_name = 'Non-Fiction'), true),

-- Subcategories under Science Fiction
('Space Opera', 'Science fiction emphasizing space warfare, melodramatic adventure, and interplanetary conflicts.', 
    (SELECT category_id FROM categories WHERE category_name = 'Science Fiction'), true),
('Cyberpunk', 'Science fiction characterized by advanced technology and a breakdown or radical change in the social order.', 
    (SELECT category_id FROM categories WHERE category_name = 'Science Fiction'), true),

-- Subcategories under Fantasy
('High Fantasy', 'Fantasy set in an alternative, fictional ("secondary") world.', 
    (SELECT category_id FROM categories WHERE category_name = 'Fantasy'), true),
('Urban Fantasy', 'Fantasy where magical and supernatural forces battle it out in contemporary, real-world settings.', 
    (SELECT category_id FROM categories WHERE category_name = 'Fantasy'), true),

-- Subcategories under Romance
('Paranormal Romance', 'Romance with fantasy or science fiction elements combined with romantic elements.', 
    (SELECT category_id FROM categories WHERE category_name = 'Romance'), true),

-- Subcategories under Comics
('Manga', 'Japanese comic books and graphic novels, typically read from right to left.', 
    (SELECT category_id FROM categories WHERE category_name = 'Comics'), true),

-- Subcategories under Kids
('Picture Books', 'Books intended for young children, typically featuring illustrations on every page.', 
    (SELECT category_id FROM categories WHERE category_name = 'Kids'), true),
('Early Readers', 'Books designed for children who are beginning to read independently.', 
    (SELECT category_id FROM categories WHERE category_name = 'Kids'), true);

-- Optional: Verify the hierarchy
select
    coalesce(p.category_name, 'TOP-LEVEL') as parent_category,
    c.category_name as category,
    c.description
from categories c
left join categories p on c.parent_category_id = p.category_id
order by p.category_name nulls first, c.category_name
;


