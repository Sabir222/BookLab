INSERT INTO genres (genre_name, description, parent_genre_id, is_active)
VALUES
-- Core base genres
('Adventure', 'Fiction featuring exciting, unusual, or dangerous activities.', NULL, true),
('Comics', 'Narrative art form using sequential images, often combined with text.', NULL, true),
('Dystopian', 'Fiction set in an imagined world where oppressive societal control is maintained through corporate, bureaucratic, technological, or totalitarian control.', NULL, true),
('Epic Fantasy', 'Fantasy characterized by brave heroes, evil villains, and grand quests, often set in vast, detailed fantasy worlds.', NULL, true),
('Historical Fiction', 'Fiction set in the past, often featuring famous historical figures or events.', NULL, true),
('Horror', 'Fiction intended to frighten, unsettle, or create suspense.', NULL, true),
('Humor', 'Fiction intended to be amusing or funny.', NULL, true),
('Magical Realism', 'Fiction where magical elements are a natural part of an otherwise mundane, realistic environment.', NULL, true),
('Manga', 'Japanese comic books and graphic novels.', NULL, true),
('Noir', 'Fiction characterized by cynical, suspicious, and sexually implicit characters; stark, often seedy, urban settings; and an atmosphere of moral ambiguity.', NULL, true),
('Romance', 'Fiction dealing with romantic love, especially in a sentimental or idealized way.', NULL, true),
('Science Fiction', 'Fiction based on futuristic concepts such as advanced science and technology, space exploration, time travel, parallel universes, and extraterrestrial life.', NULL, true),
('Steampunk', 'Fiction inspired by 19th-century industrial steam-powered machinery, often set in an alternative history of the Victorian era.', NULL, true),
('Superhero', 'Fiction featuring characters with superhuman abilities, dedicated to protecting the public.', NULL, true),
('Urban Fantasy', 'Fantasy where magical and supernatural forces battle it out in contemporary, real-world settings.', NULL, true),
('Young Adult', 'Fiction written for readers from 12 to 18 years of age.', NULL, true),
('Zombie Apocalypse', 'Fiction centered around a world overrun by zombies, focusing on survival.', NULL, true);

-- Phase 2: Insert child genres (run this AFTER the above completes)
INSERT INTO genres (genre_name, description, parent_genre_id, is_active)
VALUES
-- Science Fiction sub-genres
('Hard Science Fiction', 'Science fiction based on scientific accuracy and technological detail.', 
    (SELECT genre_id FROM genres WHERE genre_name = 'Science Fiction'), true),
('Space Opera', 'Science fiction featuring adventure stories set mainly or entirely in outer space.', 
    (SELECT genre_id FROM genres WHERE genre_name = 'Science Fiction'), true),

-- Space Opera sub-genre
('Space Western', 'Science fiction that transplants themes and tropes of the American Western to a backdrop of outer space.', 
    (SELECT genre_id FROM genres WHERE genre_name = 'Space Opera'), true),

-- Romance sub-genres  
('Time Travel Romance', 'Romance involving travel through time as a central plot device.', 
    (SELECT genre_id FROM genres WHERE genre_name = 'Romance'), true),

-- Fantasy sub-genres
('Dark Fantasy', 'Fantasy that incorporates horror elements, presenting a darker, more frightening atmosphere.', 
    (SELECT genre_id FROM genres WHERE genre_name = 'Epic Fantasy'), true),

-- Horror sub-genres
('Gothic Fiction', 'Fiction combining romanticism, horror, and death, often set in gloomy or mysterious places.', 
    (SELECT genre_id FROM genres WHERE genre_name = 'Horror'), true),

-- Manga sub-genres
('Shonen', 'Manga genre targeted at adolescent boys, typically featuring action, adventure, and fighting.', 
    (SELECT genre_id FROM genres WHERE genre_name = 'Manga'), true),
('Shojo', 'Manga genre targeted at adolescent girls, often focusing on romance, relationships, and emotions.', 
    (SELECT genre_id FROM genres WHERE genre_name = 'Manga'), true),
('Seinen', 'Manga genre targeted at adult men, covering a wide range of topics with more mature themes.', 
    (SELECT genre_id FROM genres WHERE genre_name = 'Manga'), true),
('Josei', 'Manga genre targeted at adult women, dealing with realistic and slice-of-life themes.', 
    (SELECT genre_id FROM genres WHERE genre_name = 'Manga'), true),

-- Comics sub-genres
('Superhero Comics', 'Comics featuring characters with superhuman abilities.', 
    (SELECT genre_id FROM genres WHERE genre_name = 'Comics'), true),
('Indie Comics', 'Independent comics, often self-published or published by small presses.', 
    (SELECT genre_id FROM genres WHERE genre_name = 'Comics'), true),

-- Young Adult sub-genres
('Coming-of-Age', 'Fiction focusing on the psychological and moral growth of the protagonist from youth to adulthood.', 
    (SELECT genre_id FROM genres WHERE genre_name = 'Young Adult'), true);

-- Optional: Verify the hierarchy
SELECT 
    g1.genre_name as parent_genre,
    g2.genre_name as child_genre,
    g2.description as child_description
FROM genres g1
RIGHT JOIN genres g2 ON g1.genre_id = g2.parent_genre_id
ORDER BY g1.genre_name, g2.genre_name;
