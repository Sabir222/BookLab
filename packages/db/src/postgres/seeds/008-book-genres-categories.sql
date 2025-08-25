BEGIN;

-- A Conjuring of Light
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'c8950321-9395-44ce-828c-78a732f91b37';
INSERT INTO book_categories (book_id, category_id) VALUES ('c8950321-9395-44ce-828c-78a732f91b37','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('c8950321-9395-44ce-828c-78a732f91b37','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('c8950321-9395-44ce-828c-78a732f91b37','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- A Court of Mist and Fury
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = '3b67e257-fcbb-4de4-8149-5ce9960f77b9';
INSERT INTO book_categories (book_id, category_id) VALUES ('3b67e257-fcbb-4de4-8149-5ce9960f77b9','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('3b67e257-fcbb-4de4-8149-5ce9960f77b9','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('3b67e257-fcbb-4de4-8149-5ce9960f77b9','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('3b67e257-fcbb-4de4-8149-5ce9960f77b9','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('3b67e257-fcbb-4de4-8149-5ce9960f77b9','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('3b67e257-fcbb-4de4-8149-5ce9960f77b9','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- A Court of Silver Flames
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = '6ad0bc0d-310a-4cfb-bc16-5d6106f5d530';
INSERT INTO book_categories (book_id, category_id) VALUES ('6ad0bc0d-310a-4cfb-bc16-5d6106f5d530','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('6ad0bc0d-310a-4cfb-bc16-5d6106f5d530','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('6ad0bc0d-310a-4cfb-bc16-5d6106f5d530','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('6ad0bc0d-310a-4cfb-bc16-5d6106f5d530','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('6ad0bc0d-310a-4cfb-bc16-5d6106f5d530','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('6ad0bc0d-310a-4cfb-bc16-5d6106f5d530','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- A Court of Thorns and Roses
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = '94578ec4-205d-4644-aa91-7647bc2d9900';
INSERT INTO book_categories (book_id, category_id) VALUES ('94578ec4-205d-4644-aa91-7647bc2d9900','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('94578ec4-205d-4644-aa91-7647bc2d9900','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('94578ec4-205d-4644-aa91-7647bc2d9900','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('94578ec4-205d-4644-aa91-7647bc2d9900','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('94578ec4-205d-4644-aa91-7647bc2d9900','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('94578ec4-205d-4644-aa91-7647bc2d9900','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- House of Sky and Breath
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'e9cb7006-e285-4530-9643-0a0a959305a0';
INSERT INTO book_categories (book_id, category_id) VALUES ('e9cb7006-e285-4530-9643-0a0a959305a0','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('e9cb7006-e285-4530-9643-0a0a959305a0','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('e9cb7006-e285-4530-9643-0a0a959305a0','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Ignite Me
UPDATE books SET primary_category_id = '6a151e20-73d9-45e0-94bf-be7a0f73f4cf' WHERE book_id = 'c3722913-0cd4-4cfb-9544-15c9b70d1f8c';
INSERT INTO book_categories (book_id, category_id) VALUES ('c3722913-0cd4-4cfb-9544-15c9b70d1f8c','6a151e20-73d9-45e0-94bf-be7a0f73f4cf') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('c3722913-0cd4-4cfb-9544-15c9b70d1f8c','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('c3722913-0cd4-4cfb-9544-15c9b70d1f8c','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('c3722913-0cd4-4cfb-9544-15c9b70d1f8c','e88a4263-f077-4766-bcdf-1b7c585d211b') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('c3722913-0cd4-4cfb-9544-15c9b70d1f8c','a0482b48-0021-4379-9f87-f33fdea112d5') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('c3722913-0cd4-4cfb-9544-15c9b70d1f8c','a7010a6c-d6e8-4003-887f-f6298c65c147') ON CONFLICT DO NOTHING;

-- Illuminae
UPDATE books SET primary_category_id = '17739b35-27cb-41af-bb8d-d996f3519ee7' WHERE book_id = '58c809f0-4d05-4d6a-9255-f00c357a84eb';
INSERT INTO book_categories (book_id, category_id) VALUES ('58c809f0-4d05-4d6a-9255-f00c357a84eb','17739b35-27cb-41af-bb8d-d996f3519ee7') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('58c809f0-4d05-4d6a-9255-f00c357a84eb','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('58c809f0-4d05-4d6a-9255-f00c357a84eb','68e2ff8f-6716-4de9-99cf-990050bc8f92') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('58c809f0-4d05-4d6a-9255-f00c357a84eb','266310e8-0287-41e8-b5b0-fd0e237d438f') ON CONFLICT DO NOTHING;

-- Imagine Me
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'ba70c5e9-a793-4384-992c-047ea44b45c6';
INSERT INTO book_categories (book_id, category_id) VALUES ('ba70c5e9-a793-4384-992c-047ea44b45c6','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('ba70c5e9-a793-4384-992c-047ea44b45c6','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('ba70c5e9-a793-4384-992c-047ea44b45c6','17739b35-27cb-41af-bb8d-d996f3519ee7') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ba70c5e9-a793-4384-992c-047ea44b45c6','bf3da532-c2f1-412f-9ec1-00bef471b602') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ba70c5e9-a793-4384-992c-047ea44b45c6','266310e8-0287-41e8-b5b0-fd0e237d438f') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ba70c5e9-a793-4384-992c-047ea44b45c6','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Insurgent
UPDATE books SET primary_category_id = '17739b35-27cb-41af-bb8d-d996f3519ee7' WHERE book_id = '3f197abc-a693-49d5-b0bb-406edd54c693';
INSERT INTO book_categories (book_id, category_id) VALUES ('3f197abc-a693-49d5-b0bb-406edd54c693','17739b35-27cb-41af-bb8d-d996f3519ee7') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('3f197abc-a693-49d5-b0bb-406edd54c693','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('3f197abc-a693-49d5-b0bb-406edd54c693','bf3da532-c2f1-412f-9ec1-00bef471b602') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('3f197abc-a693-49d5-b0bb-406edd54c693','266310e8-0287-41e8-b5b0-fd0e237d438f') ON CONFLICT DO NOTHING;

-- A Court of Wings and Ruin
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = 'b93913d0-c4af-46ca-a602-a31b06c816ec';
INSERT INTO book_categories (book_id, category_id) VALUES ('b93913d0-c4af-46ca-a602-a31b06c816ec','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('b93913d0-c4af-46ca-a602-a31b06c816ec','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('b93913d0-c4af-46ca-a602-a31b06c816ec','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('b93913d0-c4af-46ca-a602-a31b06c816ec','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('b93913d0-c4af-46ca-a602-a31b06c816ec','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('b93913d0-c4af-46ca-a602-a31b06c816ec','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- A Day of Fallen Night
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '3647650f-080a-4e5e-9f10-d73c87df3a46';
INSERT INTO book_categories (book_id, category_id) VALUES ('3647650f-080a-4e5e-9f10-d73c87df3a46','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('3647650f-080a-4e5e-9f10-d73c87df3a46','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('3647650f-080a-4e5e-9f10-d73c87df3a46','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- A Gathering of Shadows
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = 'a30177e0-30cd-4d73-8c78-0db194465e33';
INSERT INTO book_categories (book_id, category_id) VALUES ('a30177e0-30cd-4d73-8c78-0db194465e33','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('a30177e0-30cd-4d73-8c78-0db194465e33','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('a30177e0-30cd-4d73-8c78-0db194465e33','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('a30177e0-30cd-4d73-8c78-0db194465e33','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('a30177e0-30cd-4d73-8c78-0db194465e33','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('a30177e0-30cd-4d73-8c78-0db194465e33','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- All the Light We Cannot See
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '978985ec-1759-46ee-bb14-531c9bfcc3c7';
INSERT INTO book_categories (book_id, category_id) VALUES ('978985ec-1759-46ee-bb14-531c9bfcc3c7','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('978985ec-1759-46ee-bb14-531c9bfcc3c7','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('978985ec-1759-46ee-bb14-531c9bfcc3c7','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Allegiant
UPDATE books SET primary_category_id = '17739b35-27cb-41af-bb8d-d996f3519ee7' WHERE book_id = 'c64f7799-493f-4135-abd0-e12310577760';
INSERT INTO book_categories (book_id, category_id) VALUES ('c64f7799-493f-4135-abd0-e12310577760','17739b35-27cb-41af-bb8d-d996f3519ee7') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('c64f7799-493f-4135-abd0-e12310577760','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('c64f7799-493f-4135-abd0-e12310577760','bf3da532-c2f1-412f-9ec1-00bef471b602') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('c64f7799-493f-4135-abd0-e12310577760','266310e8-0287-41e8-b5b0-fd0e237d438f') ON CONFLICT DO NOTHING;

-- Americanah
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '3c2de1cd-3496-4c54-af75-df4d7b1941f2';
INSERT INTO book_categories (book_id, category_id) VALUES ('3c2de1cd-3496-4c54-af75-df4d7b1941f2','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('3c2de1cd-3496-4c54-af75-df4d7b1941f2','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('3c2de1cd-3496-4c54-af75-df4d7b1941f2','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Aurora Burning
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'ec828ace-a3e6-4625-9a16-31f19d1b57e2';
INSERT INTO book_categories (book_id, category_id) VALUES ('ec828ace-a3e6-4625-9a16-31f19d1b57e2','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('ec828ace-a3e6-4625-9a16-31f19d1b57e2','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ec828ace-a3e6-4625-9a16-31f19d1b57e2','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Aurora Rising
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '1ff0995a-4cd4-4ff4-bfbd-7bae9e760726';
INSERT INTO book_categories (book_id, category_id) VALUES ('1ff0995a-4cd4-4ff4-bfbd-7bae9e760726','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('1ff0995a-4cd4-4ff4-bfbd-7bae9e760726','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('1ff0995a-4cd4-4ff4-bfbd-7bae9e760726','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Aurora’s End
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '198517e6-4fd4-4b5b-aec7-ac135b050bd7';
INSERT INTO book_categories (book_id, category_id) VALUES ('198517e6-4fd4-4b5b-aec7-ac135b050bd7','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('198517e6-4fd4-4b5b-aec7-ac135b050bd7','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('198517e6-4fd4-4b5b-aec7-ac135b050bd7','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Babel
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '490214ac-1b2d-4e5b-97cd-e27514faed75';
INSERT INTO book_categories (book_id, category_id) VALUES ('490214ac-1b2d-4e5b-97cd-e27514faed75','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('490214ac-1b2d-4e5b-97cd-e27514faed75','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('490214ac-1b2d-4e5b-97cd-e27514faed75','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Before We Were Strangers
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'a77d1c9f-dd91-4a7f-ba0a-d157c1f90f0f';
INSERT INTO book_categories (book_id, category_id) VALUES ('a77d1c9f-dd91-4a7f-ba0a-d157c1f90f0f','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('a77d1c9f-dd91-4a7f-ba0a-d157c1f90f0f','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('a77d1c9f-dd91-4a7f-ba0a-d157c1f90f0f','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Birnam Wood
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '38b4f1ff-9177-437d-a124-c8514bfd1adf';
INSERT INTO book_categories (book_id, category_id) VALUES ('38b4f1ff-9177-437d-a124-c8514bfd1adf','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('38b4f1ff-9177-437d-a124-c8514bfd1adf','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('38b4f1ff-9177-437d-a124-c8514bfd1adf','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Blade Breaker
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = '9bed5434-3be9-4a64-b32f-b749ca0cae6a';
INSERT INTO book_categories (book_id, category_id) VALUES ('9bed5434-3be9-4a64-b32f-b749ca0cae6a','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('9bed5434-3be9-4a64-b32f-b749ca0cae6a','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('9bed5434-3be9-4a64-b32f-b749ca0cae6a','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('9bed5434-3be9-4a64-b32f-b749ca0cae6a','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('9bed5434-3be9-4a64-b32f-b749ca0cae6a','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('9bed5434-3be9-4a64-b32f-b749ca0cae6a','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Bloodmarked
UPDATE books SET primary_category_id = '6a151e20-73d9-45e0-94bf-be7a0f73f4cf' WHERE book_id = 'ac2c31ef-9d50-441a-aa08-cb387199c7ff';
INSERT INTO book_categories (book_id, category_id) VALUES ('ac2c31ef-9d50-441a-aa08-cb387199c7ff','6a151e20-73d9-45e0-94bf-be7a0f73f4cf') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('ac2c31ef-9d50-441a-aa08-cb387199c7ff','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('ac2c31ef-9d50-441a-aa08-cb387199c7ff','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ac2c31ef-9d50-441a-aa08-cb387199c7ff','e88a4263-f077-4766-bcdf-1b7c585d211b') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ac2c31ef-9d50-441a-aa08-cb387199c7ff','a0482b48-0021-4379-9f87-f33fdea112d5') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ac2c31ef-9d50-441a-aa08-cb387199c7ff','a7010a6c-d6e8-4003-887f-f6298c65c147') ON CONFLICT DO NOTHING;

-- Book Lovers
UPDATE books SET primary_category_id = '84484d09-8b66-4ea7-9edc-106fd13ffd73' WHERE book_id = 'da9871b3-97d4-4bca-9f21-be4755a67c78';
INSERT INTO book_categories (book_id, category_id) VALUES ('da9871b3-97d4-4bca-9f21-be4755a67c78','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('da9871b3-97d4-4bca-9f21-be4755a67c78','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('da9871b3-97d4-4bca-9f21-be4755a67c78','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('da9871b3-97d4-4bca-9f21-be4755a67c78','e2e54289-a55d-401a-a341-77e5b08023e0') ON CONFLICT DO NOTHING;

-- Caraval
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'd3ea78cd-2f26-4667-8a48-35a045d4e58d';
INSERT INTO book_categories (book_id, category_id) VALUES ('d3ea78cd-2f26-4667-8a48-35a045d4e58d','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('d3ea78cd-2f26-4667-8a48-35a045d4e58d','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d3ea78cd-2f26-4667-8a48-35a045d4e58d','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Carrie Soto Is Back
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'edf616f5-cdc1-4074-b31c-adad5922351a';
INSERT INTO book_categories (book_id, category_id) VALUES ('edf616f5-cdc1-4074-b31c-adad5922351a','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('edf616f5-cdc1-4074-b31c-adad5922351a','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('edf616f5-cdc1-4074-b31c-adad5922351a','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Catching Fire
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = 'd7b46e40-8242-4f70-8996-6ba5d29bb64a';
INSERT INTO book_categories (book_id, category_id) VALUES ('d7b46e40-8242-4f70-8996-6ba5d29bb64a','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('d7b46e40-8242-4f70-8996-6ba5d29bb64a','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('d7b46e40-8242-4f70-8996-6ba5d29bb64a','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d7b46e40-8242-4f70-8996-6ba5d29bb64a','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d7b46e40-8242-4f70-8996-6ba5d29bb64a','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d7b46e40-8242-4f70-8996-6ba5d29bb64a','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Chain of Gold
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '33c71273-b4ee-45fc-ae72-79048c9792b2';
INSERT INTO book_categories (book_id, category_id) VALUES ('33c71273-b4ee-45fc-ae72-79048c9792b2','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('33c71273-b4ee-45fc-ae72-79048c9792b2','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('33c71273-b4ee-45fc-ae72-79048c9792b2','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Chain of Iron
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '8d014e8c-c611-4440-9fd1-155064e07a27';
INSERT INTO book_categories (book_id, category_id) VALUES ('8d014e8c-c611-4440-9fd1-155064e07a27','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('8d014e8c-c611-4440-9fd1-155064e07a27','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('8d014e8c-c611-4440-9fd1-155064e07a27','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Children of Blood and Bone
UPDATE books SET primary_category_id = '6a151e20-73d9-45e0-94bf-be7a0f73f4cf' WHERE book_id = 'ffeba2da-9089-4354-9d48-a8a1bca080c2';
INSERT INTO book_categories (book_id, category_id) VALUES ('ffeba2da-9089-4354-9d48-a8a1bca080c2','6a151e20-73d9-45e0-94bf-be7a0f73f4cf') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('ffeba2da-9089-4354-9d48-a8a1bca080c2','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('ffeba2da-9089-4354-9d48-a8a1bca080c2','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ffeba2da-9089-4354-9d48-a8a1bca080c2','e88a4263-f077-4766-bcdf-1b7c585d211b') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ffeba2da-9089-4354-9d48-a8a1bca080c2','a0482b48-0021-4379-9f87-f33fdea112d5') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ffeba2da-9089-4354-9d48-a8a1bca080c2','a7010a6c-d6e8-4003-887f-f6298c65c147') ON CONFLICT DO NOTHING;

-- Children of Virtue and Vengeance
UPDATE books SET primary_category_id = '7714415f-2a2c-4c93-b573-c8636f2c43f1' WHERE book_id = '23c78129-82ff-48fd-8dd1-3772f1afff51';
INSERT INTO book_categories (book_id, category_id) VALUES ('23c78129-82ff-48fd-8dd1-3772f1afff51','7714415f-2a2c-4c93-b573-c8636f2c43f1') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('23c78129-82ff-48fd-8dd1-3772f1afff51','7d26a24b-ae3b-49bb-9548-1018a5c2fee3') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('23c78129-82ff-48fd-8dd1-3772f1afff51','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('23c78129-82ff-48fd-8dd1-3772f1afff51','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('23c78129-82ff-48fd-8dd1-3772f1afff51','805dcfc3-1e6a-438a-99dc-ba561122d404') ON CONFLICT DO NOTHING;

-- Circe
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '6d8c126a-6f52-4063-b46a-e00964dbd1e7';
INSERT INTO book_categories (book_id, category_id) VALUES ('6d8c126a-6f52-4063-b46a-e00964dbd1e7','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('6d8c126a-6f52-4063-b46a-e00964dbd1e7','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('6d8c126a-6f52-4063-b46a-e00964dbd1e7','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- City of Ashes
UPDATE books SET primary_category_id = '17739b35-27cb-41af-bb8d-d996f3519ee7' WHERE book_id = '76999973-8825-4e01-9101-70714a9486e5';
INSERT INTO book_categories (book_id, category_id) VALUES ('76999973-8825-4e01-9101-70714a9486e5','17739b35-27cb-41af-bb8d-d996f3519ee7') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('76999973-8825-4e01-9101-70714a9486e5','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('76999973-8825-4e01-9101-70714a9486e5','bf3da532-c2f1-412f-9ec1-00bef471b602') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('76999973-8825-4e01-9101-70714a9486e5','266310e8-0287-41e8-b5b0-fd0e237d438f') ON CONFLICT DO NOTHING;

-- City of Bones
UPDATE books SET primary_category_id = '6a151e20-73d9-45e0-94bf-be7a0f73f4cf' WHERE book_id = 'a91c59b3-eb49-462f-b6a3-3a8dcc723ec5';
INSERT INTO book_categories (book_id, category_id) VALUES ('a91c59b3-eb49-462f-b6a3-3a8dcc723ec5','6a151e20-73d9-45e0-94bf-be7a0f73f4cf') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('a91c59b3-eb49-462f-b6a3-3a8dcc723ec5','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('a91c59b3-eb49-462f-b6a3-3a8dcc723ec5','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('a91c59b3-eb49-462f-b6a3-3a8dcc723ec5','e88a4263-f077-4766-bcdf-1b7c585d211b') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('a91c59b3-eb49-462f-b6a3-3a8dcc723ec5','a0482b48-0021-4379-9f87-f33fdea112d5') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('a91c59b3-eb49-462f-b6a3-3a8dcc723ec5','a7010a6c-d6e8-4003-887f-f6298c65c147') ON CONFLICT DO NOTHING;

-- City of Fallen Angels
UPDATE books SET primary_category_id = '6a151e20-73d9-45e0-94bf-be7a0f73f4cf' WHERE book_id = 'f58abff5-0d08-412c-96bf-244e15f8aee6';
INSERT INTO book_categories (book_id, category_id) VALUES ('f58abff5-0d08-412c-96bf-244e15f8aee6','6a151e20-73d9-45e0-94bf-be7a0f73f4cf') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('f58abff5-0d08-412c-96bf-244e15f8aee6','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('f58abff5-0d08-412c-96bf-244e15f8aee6','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('f58abff5-0d08-412c-96bf-244e15f8aee6','e88a4263-f077-4766-bcdf-1b7c585d211b') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('f58abff5-0d08-412c-96bf-244e15f8aee6','a0482b48-0021-4379-9f87-f33fdea112d5') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('f58abff5-0d08-412c-96bf-244e15f8aee6','a7010a6c-d6e8-4003-887f-f6298c65c147') ON CONFLICT DO NOTHING;

-- City of Glass
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = 'cfdf78b2-c54b-4f90-98c6-684321fbe3a1';
INSERT INTO book_categories (book_id, category_id) VALUES ('cfdf78b2-c54b-4f90-98c6-684321fbe3a1','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('cfdf78b2-c54b-4f90-98c6-684321fbe3a1','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('cfdf78b2-c54b-4f90-98c6-684321fbe3a1','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('cfdf78b2-c54b-4f90-98c6-684321fbe3a1','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('cfdf78b2-c54b-4f90-98c6-684321fbe3a1','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('cfdf78b2-c54b-4f90-98c6-684321fbe3a1','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- City of Heavenly Fire
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = 'd84bc7b3-d136-4c66-a9a3-276c53978196';
INSERT INTO book_categories (book_id, category_id) VALUES ('d84bc7b3-d136-4c66-a9a3-276c53978196','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('d84bc7b3-d136-4c66-a9a3-276c53978196','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('d84bc7b3-d136-4c66-a9a3-276c53978196','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d84bc7b3-d136-4c66-a9a3-276c53978196','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d84bc7b3-d136-4c66-a9a3-276c53978196','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d84bc7b3-d136-4c66-a9a3-276c53978196','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- City of Lost Souls
UPDATE books SET primary_category_id = '6a151e20-73d9-45e0-94bf-be7a0f73f4cf' WHERE book_id = '9c14aa8a-70ea-4be8-a8ac-e1ee8ed4f755';
INSERT INTO book_categories (book_id, category_id) VALUES ('9c14aa8a-70ea-4be8-a8ac-e1ee8ed4f755','6a151e20-73d9-45e0-94bf-be7a0f73f4cf') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('9c14aa8a-70ea-4be8-a8ac-e1ee8ed4f755','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('9c14aa8a-70ea-4be8-a8ac-e1ee8ed4f755','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('9c14aa8a-70ea-4be8-a8ac-e1ee8ed4f755','e88a4263-f077-4766-bcdf-1b7c585d211b') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('9c14aa8a-70ea-4be8-a8ac-e1ee8ed4f755','a0482b48-0021-4379-9f87-f33fdea112d5') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('9c14aa8a-70ea-4be8-a8ac-e1ee8ed4f755','a7010a6c-d6e8-4003-887f-f6298c65c147') ON CONFLICT DO NOTHING;

-- Clockwork Angel
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'd9a43bea-6187-46e9-93dd-aac0175a1708';
INSERT INTO book_categories (book_id, category_id) VALUES ('d9a43bea-6187-46e9-93dd-aac0175a1708','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('d9a43bea-6187-46e9-93dd-aac0175a1708','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d9a43bea-6187-46e9-93dd-aac0175a1708','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Clockwork Princess
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = '8dadf3d7-623a-4b37-abad-5cbdfb76890f';
INSERT INTO book_categories (book_id, category_id) VALUES ('8dadf3d7-623a-4b37-abad-5cbdfb76890f','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('8dadf3d7-623a-4b37-abad-5cbdfb76890f','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('8dadf3d7-623a-4b37-abad-5cbdfb76890f','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('8dadf3d7-623a-4b37-abad-5cbdfb76890f','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('8dadf3d7-623a-4b37-abad-5cbdfb76890f','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('8dadf3d7-623a-4b37-abad-5cbdfb76890f','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Crescent City: House of Sky and Breath
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = '67c27067-9f20-4770-991a-29426cc34ec3';
INSERT INTO book_categories (book_id, category_id) VALUES ('67c27067-9f20-4770-991a-29426cc34ec3','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('67c27067-9f20-4770-991a-29426cc34ec3','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('67c27067-9f20-4770-991a-29426cc34ec3','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('67c27067-9f20-4770-991a-29426cc34ec3','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('67c27067-9f20-4770-991a-29426cc34ec3','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('67c27067-9f20-4770-991a-29426cc34ec3','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Crooked Kingdom
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = '49640ebf-be54-4bf8-98c7-139c8fc728c3';
INSERT INTO book_categories (book_id, category_id) VALUES ('49640ebf-be54-4bf8-98c7-139c8fc728c3','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('49640ebf-be54-4bf8-98c7-139c8fc728c3','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('49640ebf-be54-4bf8-98c7-139c8fc728c3','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('49640ebf-be54-4bf8-98c7-139c8fc728c3','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('49640ebf-be54-4bf8-98c7-139c8fc728c3','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('49640ebf-be54-4bf8-98c7-139c8fc728c3','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Crown of Midnight
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '222edd9c-bbe5-4f22-b380-e3c23e92a970';
INSERT INTO book_categories (book_id, category_id) VALUES ('222edd9c-bbe5-4f22-b380-e3c23e92a970','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('222edd9c-bbe5-4f22-b380-e3c23e92a970','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('222edd9c-bbe5-4f22-b380-e3c23e92a970','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Darkdawn
UPDATE books SET primary_category_id = '6a151e20-73d9-45e0-94bf-be7a0f73f4cf' WHERE book_id = '7d447336-8fd1-4881-a2d9-d63b6c24d1ae';
INSERT INTO book_categories (book_id, category_id) VALUES ('7d447336-8fd1-4881-a2d9-d63b6c24d1ae','6a151e20-73d9-45e0-94bf-be7a0f73f4cf') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('7d447336-8fd1-4881-a2d9-d63b6c24d1ae','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('7d447336-8fd1-4881-a2d9-d63b6c24d1ae','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('7d447336-8fd1-4881-a2d9-d63b6c24d1ae','e88a4263-f077-4766-bcdf-1b7c585d211b') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('7d447336-8fd1-4881-a2d9-d63b6c24d1ae','a0482b48-0021-4379-9f87-f33fdea112d5') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('7d447336-8fd1-4881-a2d9-d63b6c24d1ae','a7010a6c-d6e8-4003-887f-f6298c65c147') ON CONFLICT DO NOTHING;

-- Defy Me
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '9bfa6939-ff65-4a89-b02b-cab365544ec4';
INSERT INTO book_categories (book_id, category_id) VALUES ('9bfa6939-ff65-4a89-b02b-cab365544ec4','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('9bfa6939-ff65-4a89-b02b-cab365544ec4','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('9bfa6939-ff65-4a89-b02b-cab365544ec4','17739b35-27cb-41af-bb8d-d996f3519ee7') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('9bfa6939-ff65-4a89-b02b-cab365544ec4','bf3da532-c2f1-412f-9ec1-00bef471b602') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('9bfa6939-ff65-4a89-b02b-cab365544ec4','266310e8-0287-41e8-b5b0-fd0e237d438f') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('9bfa6939-ff65-4a89-b02b-cab365544ec4','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Demon Copperhead
UPDATE books SET primary_category_id = '6a151e20-73d9-45e0-94bf-be7a0f73f4cf' WHERE book_id = '0c046c96-9c1b-44cd-bf7a-ea9d1f87fea6';
INSERT INTO book_categories (book_id, category_id) VALUES ('0c046c96-9c1b-44cd-bf7a-ea9d1f87fea6','6a151e20-73d9-45e0-94bf-be7a0f73f4cf') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('0c046c96-9c1b-44cd-bf7a-ea9d1f87fea6','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('0c046c96-9c1b-44cd-bf7a-ea9d1f87fea6','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('0c046c96-9c1b-44cd-bf7a-ea9d1f87fea6','e88a4263-f077-4766-bcdf-1b7c585d211b') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('0c046c96-9c1b-44cd-bf7a-ea9d1f87fea6','a0482b48-0021-4379-9f87-f33fdea112d5') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('0c046c96-9c1b-44cd-bf7a-ea9d1f87fea6','a7010a6c-d6e8-4003-887f-f6298c65c147') ON CONFLICT DO NOTHING;

-- Empire of Storms
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = 'ee722a96-7146-40b7-acec-349d304ab002';
INSERT INTO book_categories (book_id, category_id) VALUES ('ee722a96-7146-40b7-acec-349d304ab002','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('ee722a96-7146-40b7-acec-349d304ab002','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('ee722a96-7146-40b7-acec-349d304ab002','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ee722a96-7146-40b7-acec-349d304ab002','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ee722a96-7146-40b7-acec-349d304ab002','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ee722a96-7146-40b7-acec-349d304ab002','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Empire of the Vampire
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = '6472804e-f258-4431-842d-6f6e2d5fef32';
INSERT INTO book_categories (book_id, category_id) VALUES ('6472804e-f258-4431-842d-6f6e2d5fef32','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('6472804e-f258-4431-842d-6f6e2d5fef32','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('6472804e-f258-4431-842d-6f6e2d5fef32','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('6472804e-f258-4431-842d-6f6e2d5fef32','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('6472804e-f258-4431-842d-6f6e2d5fef32','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('6472804e-f258-4431-842d-6f6e2d5fef32','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Fate Breaker
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '2d312578-9dbd-450f-a62a-67729f8e74db';
INSERT INTO book_categories (book_id, category_id) VALUES ('2d312578-9dbd-450f-a62a-67729f8e74db','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('2d312578-9dbd-450f-a62a-67729f8e74db','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('2d312578-9dbd-450f-a62a-67729f8e74db','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Finale
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '65856882-88f7-4c34-983a-a66466cbbb4e';
INSERT INTO book_categories (book_id, category_id) VALUES ('65856882-88f7-4c34-983a-a66466cbbb4e','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('65856882-88f7-4c34-983a-a66466cbbb4e','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('65856882-88f7-4c34-983a-a66466cbbb4e','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Four: A Divergent Collection
UPDATE books SET primary_category_id = '17739b35-27cb-41af-bb8d-d996f3519ee7' WHERE book_id = '086a303e-3247-4a0b-8994-54ff7e666480';
INSERT INTO book_categories (book_id, category_id) VALUES ('086a303e-3247-4a0b-8994-54ff7e666480','17739b35-27cb-41af-bb8d-d996f3519ee7') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('086a303e-3247-4a0b-8994-54ff7e666480','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('086a303e-3247-4a0b-8994-54ff7e666480','bf3da532-c2f1-412f-9ec1-00bef471b602') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('086a303e-3247-4a0b-8994-54ff7e666480','266310e8-0287-41e8-b5b0-fd0e237d438f') ON CONFLICT DO NOTHING;

-- Fourth Wing
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '16c51354-2fda-48fe-85f7-0ae0e1ac75ec';
INSERT INTO book_categories (book_id, category_id) VALUES ('16c51354-2fda-48fe-85f7-0ae0e1ac75ec','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('16c51354-2fda-48fe-85f7-0ae0e1ac75ec','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('16c51354-2fda-48fe-85f7-0ae0e1ac75ec','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Glass Sword
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = '79972b3e-04c5-43df-a4d0-2046ef79d6be';
INSERT INTO book_categories (book_id, category_id) VALUES ('79972b3e-04c5-43df-a4d0-2046ef79d6be','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('79972b3e-04c5-43df-a4d0-2046ef79d6be','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('79972b3e-04c5-43df-a4d0-2046ef79d6be','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('79972b3e-04c5-43df-a4d0-2046ef79d6be','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('79972b3e-04c5-43df-a4d0-2046ef79d6be','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('79972b3e-04c5-43df-a4d0-2046ef79d6be','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Godsgrave
UPDATE books SET primary_category_id = '6a151e20-73d9-45e0-94bf-be7a0f73f4cf' WHERE book_id = '22e73320-3645-47b6-a9b5-0be5be8f05ad';
INSERT INTO book_categories (book_id, category_id) VALUES ('22e73320-3645-47b6-a9b5-0be5be8f05ad','6a151e20-73d9-45e0-94bf-be7a0f73f4cf') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('22e73320-3645-47b6-a9b5-0be5be8f05ad','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('22e73320-3645-47b6-a9b5-0be5be8f05ad','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('22e73320-3645-47b6-a9b5-0be5be8f05ad','e88a4263-f077-4766-bcdf-1b7c585d211b') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('22e73320-3645-47b6-a9b5-0be5be8f05ad','a0482b48-0021-4379-9f87-f33fdea112d5') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('22e73320-3645-47b6-a9b5-0be5be8f05ad','a7010a6c-d6e8-4003-887f-f6298c65c147') ON CONFLICT DO NOTHING;

-- Gone Girl
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '913767b4-f2bc-4711-a058-23a1dc92d6a3';
INSERT INTO book_categories (book_id, category_id) VALUES ('913767b4-f2bc-4711-a058-23a1dc92d6a3','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('913767b4-f2bc-4711-a058-23a1dc92d6a3','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('913767b4-f2bc-4711-a058-23a1dc92d6a3','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Happy Place
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '81e40d49-4bf3-46d7-a16e-0d27f04aeeed';
INSERT INTO book_categories (book_id, category_id) VALUES ('81e40d49-4bf3-46d7-a16e-0d27f04aeeed','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('81e40d49-4bf3-46d7-a16e-0d27f04aeeed','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('81e40d49-4bf3-46d7-a16e-0d27f04aeeed','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- He Who Drowned the World
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'da42a843-33f4-4018-96e7-8982ed95baa0';
INSERT INTO book_categories (book_id, category_id) VALUES ('da42a843-33f4-4018-96e7-8982ed95baa0','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('da42a843-33f4-4018-96e7-8982ed95baa0','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('da42a843-33f4-4018-96e7-8982ed95baa0','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Heir of Fire
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = 'c3a219ff-bce7-4c1f-a075-bac2b1d3c1bd';
INSERT INTO book_categories (book_id, category_id) VALUES ('c3a219ff-bce7-4c1f-a075-bac2b1d3c1bd','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('c3a219ff-bce7-4c1f-a075-bac2b1d3c1bd','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('c3a219ff-bce7-4c1f-a075-bac2b1d3c1bd','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('c3a219ff-bce7-4c1f-a075-bac2b1d3c1bd','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('c3a219ff-bce7-4c1f-a075-bac2b1d3c1bd','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('c3a219ff-bce7-4c1f-a075-bac2b1d3c1bd','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Heir of Fire: Collector’s Edition
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = 'c2aa178c-b58b-4b7d-a093-af38aeea0a67';
INSERT INTO book_categories (book_id, category_id) VALUES ('c2aa178c-b58b-4b7d-a093-af38aeea0a67','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('c2aa178c-b58b-4b7d-a093-af38aeea0a67','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('c2aa178c-b58b-4b7d-a093-af38aeea0a67','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('c2aa178c-b58b-4b7d-a093-af38aeea0a67','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('c2aa178c-b58b-4b7d-a093-af38aeea0a67','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('c2aa178c-b58b-4b7d-a093-af38aeea0a67','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- House of Earth and Blood
UPDATE books SET primary_category_id = '6a151e20-73d9-45e0-94bf-be7a0f73f4cf' WHERE book_id = 'fef9641f-1ed0-48c7-9d84-72a0e5618bef';
INSERT INTO book_categories (book_id, category_id) VALUES ('fef9641f-1ed0-48c7-9d84-72a0e5618bef','6a151e20-73d9-45e0-94bf-be7a0f73f4cf') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('fef9641f-1ed0-48c7-9d84-72a0e5618bef','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('fef9641f-1ed0-48c7-9d84-72a0e5618bef','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('fef9641f-1ed0-48c7-9d84-72a0e5618bef','e88a4263-f077-4766-bcdf-1b7c585d211b') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('fef9641f-1ed0-48c7-9d84-72a0e5618bef','a0482b48-0021-4379-9f87-f33fdea112d5') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('fef9641f-1ed0-48c7-9d84-72a0e5618bef','a7010a6c-d6e8-4003-887f-f6298c65c147') ON CONFLICT DO NOTHING;

-- Iron Flame
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '562d34dc-09e9-4aab-859f-5a486394ff9f';
INSERT INTO book_categories (book_id, category_id) VALUES ('562d34dc-09e9-4aab-859f-5a486394ff9f','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('562d34dc-09e9-4aab-859f-5a486394ff9f','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('562d34dc-09e9-4aab-859f-5a486394ff9f','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Iron Widow
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'f8c2f2a4-231e-4099-8ac2-5745326eadbd';
INSERT INTO book_categories (book_id, category_id) VALUES ('f8c2f2a4-231e-4099-8ac2-5745326eadbd','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('f8c2f2a4-231e-4099-8ac2-5745326eadbd','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('f8c2f2a4-231e-4099-8ac2-5745326eadbd','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- It Ends with Us
UPDATE books SET primary_category_id = '6a151e20-73d9-45e0-94bf-be7a0f73f4cf' WHERE book_id = 'af1155b0-ca5a-4a8a-9091-e6fc4312b3cb';
INSERT INTO book_categories (book_id, category_id) VALUES ('af1155b0-ca5a-4a8a-9091-e6fc4312b3cb','6a151e20-73d9-45e0-94bf-be7a0f73f4cf') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('af1155b0-ca5a-4a8a-9091-e6fc4312b3cb','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('af1155b0-ca5a-4a8a-9091-e6fc4312b3cb','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('af1155b0-ca5a-4a8a-9091-e6fc4312b3cb','e88a4263-f077-4766-bcdf-1b7c585d211b') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('af1155b0-ca5a-4a8a-9091-e6fc4312b3cb','a0482b48-0021-4379-9f87-f33fdea112d5') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('af1155b0-ca5a-4a8a-9091-e6fc4312b3cb','a7010a6c-d6e8-4003-887f-f6298c65c147') ON CONFLICT DO NOTHING;

-- It Starts with Us
UPDATE books SET primary_category_id = '17739b35-27cb-41af-bb8d-d996f3519ee7' WHERE book_id = 'a3fe79d2-2a75-40be-945f-259ae87e26f3';
INSERT INTO book_categories (book_id, category_id) VALUES ('a3fe79d2-2a75-40be-945f-259ae87e26f3','17739b35-27cb-41af-bb8d-d996f3519ee7') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('a3fe79d2-2a75-40be-945f-259ae87e26f3','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('a3fe79d2-2a75-40be-945f-259ae87e26f3','fa7e1059-7a33-4976-8bbd-2e6189548642') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('a3fe79d2-2a75-40be-945f-259ae87e26f3','68e2ff8f-6716-4de9-99cf-990050bc8f92') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('a3fe79d2-2a75-40be-945f-259ae87e26f3','24b6f710-3aef-4366-946b-e96c4ab9cee2') ON CONFLICT DO NOTHING;

-- King of Scars
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = '71a1edd8-e536-4415-9daf-1ec428ee9b73';
INSERT INTO book_categories (book_id, category_id) VALUES ('71a1edd8-e536-4415-9daf-1ec428ee9b73','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('71a1edd8-e536-4415-9daf-1ec428ee9b73','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('71a1edd8-e536-4415-9daf-1ec428ee9b73','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('71a1edd8-e536-4415-9daf-1ec428ee9b73','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('71a1edd8-e536-4415-9daf-1ec428ee9b73','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('71a1edd8-e536-4415-9daf-1ec428ee9b73','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- King’s Cage
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = '908ccf06-f3a9-4ee3-89b8-c1bfab8a07db';
INSERT INTO book_categories (book_id, category_id) VALUES ('908ccf06-f3a9-4ee3-89b8-c1bfab8a07db','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('908ccf06-f3a9-4ee3-89b8-c1bfab8a07db','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('908ccf06-f3a9-4ee3-89b8-c1bfab8a07db','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('908ccf06-f3a9-4ee3-89b8-c1bfab8a07db','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('908ccf06-f3a9-4ee3-89b8-c1bfab8a07db','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('908ccf06-f3a9-4ee3-89b8-c1bfab8a07db','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Kingdom of Ash
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = 'b7bdb37a-2202-4c17-a0c8-dcf47f0ae88a';
INSERT INTO book_categories (book_id, category_id) VALUES ('b7bdb37a-2202-4c17-a0c8-dcf47f0ae88a','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('b7bdb37a-2202-4c17-a0c8-dcf47f0ae88a','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('b7bdb37a-2202-4c17-a0c8-dcf47f0ae88a','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('b7bdb37a-2202-4c17-a0c8-dcf47f0ae88a','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('b7bdb37a-2202-4c17-a0c8-dcf47f0ae88a','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('b7bdb37a-2202-4c17-a0c8-dcf47f0ae88a','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Klara and the Sun
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'f3545f5d-3fc7-4be1-91e4-4d2b86150cbe';
INSERT INTO book_categories (book_id, category_id) VALUES ('f3545f5d-3fc7-4be1-91e4-4d2b86150cbe','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('f3545f5d-3fc7-4be1-91e4-4d2b86150cbe','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('f3545f5d-3fc7-4be1-91e4-4d2b86150cbe','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Lady Midnight
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'ffc16873-1f35-45d9-a6f2-93ae90d2b387';
INSERT INTO book_categories (book_id, category_id) VALUES ('ffc16873-1f35-45d9-a6f2-93ae90d2b387','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('ffc16873-1f35-45d9-a6f2-93ae90d2b387','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ffc16873-1f35-45d9-a6f2-93ae90d2b387','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Legendary
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'ecb5cef2-e4e8-4393-b167-d677b47f3546';
INSERT INTO book_categories (book_id, category_id) VALUES ('ecb5cef2-e4e8-4393-b167-d677b47f3546','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('ecb5cef2-e4e8-4393-b167-d677b47f3546','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ecb5cef2-e4e8-4393-b167-d677b47f3546','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Legendborn
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '48e6f77d-903d-4b6d-827e-55628c4c03ab';
INSERT INTO book_categories (book_id, category_id) VALUES ('48e6f77d-903d-4b6d-827e-55628c4c03ab','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('48e6f77d-903d-4b6d-827e-55628c4c03ab','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('48e6f77d-903d-4b6d-827e-55628c4c03ab','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Lessons
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '530800c6-b78d-4c1d-9367-7a1732ede5dc';
INSERT INTO book_categories (book_id, category_id) VALUES ('530800c6-b78d-4c1d-9367-7a1732ede5dc','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('530800c6-b78d-4c1d-9367-7a1732ede5dc','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('530800c6-b78d-4c1d-9367-7a1732ede5dc','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Lessons in Chemistry
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = '6d1dd482-cd9d-456b-8de0-1b032e9e0df6';
INSERT INTO book_categories (book_id, category_id) VALUES ('6d1dd482-cd9d-456b-8de0-1b032e9e0df6','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('6d1dd482-cd9d-456b-8de0-1b032e9e0df6','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('6d1dd482-cd9d-456b-8de0-1b032e9e0df6','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('6d1dd482-cd9d-456b-8de0-1b032e9e0df6','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('6d1dd482-cd9d-456b-8de0-1b032e9e0df6','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('6d1dd482-cd9d-456b-8de0-1b032e9e0df6','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Lightlark
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'a48ccd0f-c3ff-4d5f-a6fe-c10848719ce5';
INSERT INTO book_categories (book_id, category_id) VALUES ('a48ccd0f-c3ff-4d5f-a6fe-c10848719ce5','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('a48ccd0f-c3ff-4d5f-a6fe-c10848719ce5','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('a48ccd0f-c3ff-4d5f-a6fe-c10848719ce5','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Lincoln in the Bardo
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'eb9910da-1c69-4ef0-8e0e-5840ca04a380';
INSERT INTO book_categories (book_id, category_id) VALUES ('eb9910da-1c69-4ef0-8e0e-5840ca04a380','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('eb9910da-1c69-4ef0-8e0e-5840ca04a380','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('eb9910da-1c69-4ef0-8e0e-5840ca04a380','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Lord of Shadows
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = '370bb1f1-7eda-4828-93e5-88cace76098d';
INSERT INTO book_categories (book_id, category_id) VALUES ('370bb1f1-7eda-4828-93e5-88cace76098d','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('370bb1f1-7eda-4828-93e5-88cace76098d','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('370bb1f1-7eda-4828-93e5-88cace76098d','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('370bb1f1-7eda-4828-93e5-88cace76098d','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('370bb1f1-7eda-4828-93e5-88cace76098d','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('370bb1f1-7eda-4828-93e5-88cace76098d','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Malibu Rising
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'd251529b-44c7-4628-ae32-1b54f4efcc03';
INSERT INTO book_categories (book_id, category_id) VALUES ('d251529b-44c7-4628-ae32-1b54f4efcc03','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('d251529b-44c7-4628-ae32-1b54f4efcc03','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d251529b-44c7-4628-ae32-1b54f4efcc03','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Mockingjay
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = 'fcf19eb6-74e4-482b-862a-f3c20f0a57a2';
INSERT INTO book_categories (book_id, category_id) VALUES ('fcf19eb6-74e4-482b-862a-f3c20f0a57a2','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('fcf19eb6-74e4-482b-862a-f3c20f0a57a2','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('fcf19eb6-74e4-482b-862a-f3c20f0a57a2','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('fcf19eb6-74e4-482b-862a-f3c20f0a57a2','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('fcf19eb6-74e4-482b-862a-f3c20f0a57a2','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('fcf19eb6-74e4-482b-862a-f3c20f0a57a2','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- My Brilliant Friend
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '8285b0f2-c2f1-4ff3-a74e-030e4cb47ffa';
INSERT INTO book_categories (book_id, category_id) VALUES ('8285b0f2-c2f1-4ff3-a74e-030e4cb47ffa','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('8285b0f2-c2f1-4ff3-a74e-030e4cb47ffa','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('8285b0f2-c2f1-4ff3-a74e-030e4cb47ffa','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Never Let Me Go
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'cb7028c5-583d-4505-870c-8918923e3468';
INSERT INTO book_categories (book_id, category_id) VALUES ('cb7028c5-583d-4505-870c-8918923e3468','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('cb7028c5-583d-4505-870c-8918923e3468','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('cb7028c5-583d-4505-870c-8918923e3468','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Nevernight
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'ccecba4e-19f2-4977-a7f5-a64ba54c2de8';
INSERT INTO book_categories (book_id, category_id) VALUES ('ccecba4e-19f2-4977-a7f5-a64ba54c2de8','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('ccecba4e-19f2-4977-a7f5-a64ba54c2de8','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ccecba4e-19f2-4977-a7f5-a64ba54c2de8','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Nightbane
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '11c7b598-b577-4e5f-b988-3347839d9a96';
INSERT INTO book_categories (book_id, category_id) VALUES ('11c7b598-b577-4e5f-b988-3347839d9a96','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('11c7b598-b577-4e5f-b988-3347839d9a96','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('11c7b598-b577-4e5f-b988-3347839d9a96','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Normal People
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '7302da6b-0859-48c8-a743-8ffc73bd6ed5';
INSERT INTO book_categories (book_id, category_id) VALUES ('7302da6b-0859-48c8-a743-8ffc73bd6ed5','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('7302da6b-0859-48c8-a743-8ffc73bd6ed5','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('7302da6b-0859-48c8-a743-8ffc73bd6ed5','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Obsidio
UPDATE books SET primary_category_id = '17739b35-27cb-41af-bb8d-d996f3519ee7' WHERE book_id = 'caca1abb-0677-4801-9586-f8732d8937df';
INSERT INTO book_categories (book_id, category_id) VALUES ('caca1abb-0677-4801-9586-f8732d8937df','17739b35-27cb-41af-bb8d-d996f3519ee7') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('caca1abb-0677-4801-9586-f8732d8937df','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('caca1abb-0677-4801-9586-f8732d8937df','68e2ff8f-6716-4de9-99cf-990050bc8f92') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('caca1abb-0677-4801-9586-f8732d8937df','266310e8-0287-41e8-b5b0-fd0e237d438f') ON CONFLICT DO NOTHING;

-- Once Upon a Broken Heart
UPDATE books SET primary_category_id = '84484d09-8b66-4ea7-9edc-106fd13ffd73' WHERE book_id = '8dd1495b-7b0a-41d1-97f6-77f99adbedd9';
INSERT INTO book_categories (book_id, category_id) VALUES ('8dd1495b-7b0a-41d1-97f6-77f99adbedd9','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('8dd1495b-7b0a-41d1-97f6-77f99adbedd9','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('8dd1495b-7b0a-41d1-97f6-77f99adbedd9','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('8dd1495b-7b0a-41d1-97f6-77f99adbedd9','e2e54289-a55d-401a-a341-77e5b08023e0') ON CONFLICT DO NOTHING;

-- Our Dark Duet
UPDATE books SET primary_category_id = '6a151e20-73d9-45e0-94bf-be7a0f73f4cf' WHERE book_id = 'ecec3822-2abb-4fe8-8a35-8f75cb5b5d00';
INSERT INTO book_categories (book_id, category_id) VALUES ('ecec3822-2abb-4fe8-8a35-8f75cb5b5d00','6a151e20-73d9-45e0-94bf-be7a0f73f4cf') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('ecec3822-2abb-4fe8-8a35-8f75cb5b5d00','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('ecec3822-2abb-4fe8-8a35-8f75cb5b5d00','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ecec3822-2abb-4fe8-8a35-8f75cb5b5d00','e88a4263-f077-4766-bcdf-1b7c585d211b') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ecec3822-2abb-4fe8-8a35-8f75cb5b5d00','a0482b48-0021-4379-9f87-f33fdea112d5') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ecec3822-2abb-4fe8-8a35-8f75cb5b5d00','a7010a6c-d6e8-4003-887f-f6298c65c147') ON CONFLICT DO NOTHING;

-- Project Hail Mary
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'e1979d34-ff10-4f48-9ecc-c4d8fe3dc1d7';
INSERT INTO book_categories (book_id, category_id) VALUES ('e1979d34-ff10-4f48-9ecc-c4d8fe3dc1d7','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('e1979d34-ff10-4f48-9ecc-c4d8fe3dc1d7','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('e1979d34-ff10-4f48-9ecc-c4d8fe3dc1d7','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Queen of Air and Darkness
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = 'ae02e3da-e96e-4f34-8c45-33fe6327412c';
INSERT INTO book_categories (book_id, category_id) VALUES ('ae02e3da-e96e-4f34-8c45-33fe6327412c','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('ae02e3da-e96e-4f34-8c45-33fe6327412c','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('ae02e3da-e96e-4f34-8c45-33fe6327412c','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ae02e3da-e96e-4f34-8c45-33fe6327412c','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ae02e3da-e96e-4f34-8c45-33fe6327412c','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ae02e3da-e96e-4f34-8c45-33fe6327412c','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Queen of Shadows
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = '747d5df7-daf5-47ea-9ebe-e707e21d7fd8';
INSERT INTO book_categories (book_id, category_id) VALUES ('747d5df7-daf5-47ea-9ebe-e707e21d7fd8','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('747d5df7-daf5-47ea-9ebe-e707e21d7fd8','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('747d5df7-daf5-47ea-9ebe-e707e21d7fd8','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('747d5df7-daf5-47ea-9ebe-e707e21d7fd8','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('747d5df7-daf5-47ea-9ebe-e707e21d7fd8','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('747d5df7-daf5-47ea-9ebe-e707e21d7fd8','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Realm Breaker
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '7ca6c205-ed24-4aee-a4a1-701d5926e58b';
INSERT INTO book_categories (book_id, category_id) VALUES ('7ca6c205-ed24-4aee-a4a1-701d5926e58b','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('7ca6c205-ed24-4aee-a4a1-701d5926e58b','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('7ca6c205-ed24-4aee-a4a1-701d5926e58b','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Red Queen
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = '1b8c2b12-c017-4804-8df8-9b5e45c3f87f';
INSERT INTO book_categories (book_id, category_id) VALUES ('1b8c2b12-c017-4804-8df8-9b5e45c3f87f','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('1b8c2b12-c017-4804-8df8-9b5e45c3f87f','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('1b8c2b12-c017-4804-8df8-9b5e45c3f87f','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('1b8c2b12-c017-4804-8df8-9b5e45c3f87f','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('1b8c2b12-c017-4804-8df8-9b5e45c3f87f','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('1b8c2b12-c017-4804-8df8-9b5e45c3f87f','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Reminders of Him
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '72aac672-fcb5-4f75-8c9f-35b54c08b431';
INSERT INTO book_categories (book_id, category_id) VALUES ('72aac672-fcb5-4f75-8c9f-35b54c08b431','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('72aac672-fcb5-4f75-8c9f-35b54c08b431','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('72aac672-fcb5-4f75-8c9f-35b54c08b431','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Restore Me
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '3e48080f-456f-4dd4-8ed3-996c4c5d1db9';
INSERT INTO book_categories (book_id, category_id) VALUES ('3e48080f-456f-4dd4-8ed3-996c4c5d1db9','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('3e48080f-456f-4dd4-8ed3-996c4c5d1db9','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('3e48080f-456f-4dd4-8ed3-996c4c5d1db9','17739b35-27cb-41af-bb8d-d996f3519ee7') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('3e48080f-456f-4dd4-8ed3-996c4c5d1db9','bf3da532-c2f1-412f-9ec1-00bef471b602') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('3e48080f-456f-4dd4-8ed3-996c4c5d1db9','266310e8-0287-41e8-b5b0-fd0e237d438f') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('3e48080f-456f-4dd4-8ed3-996c4c5d1db9','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Ruin and Rising
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = '1a14d2ed-b677-42eb-bc3e-6a78ddb1f7a8';
INSERT INTO book_categories (book_id, category_id) VALUES ('1a14d2ed-b677-42eb-bc3e-6a78ddb1f7a8','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('1a14d2ed-b677-42eb-bc3e-6a78ddb1f7a8','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('1a14d2ed-b677-42eb-bc3e-6a78ddb1f7a8','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('1a14d2ed-b677-42eb-bc3e-6a78ddb1f7a8','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('1a14d2ed-b677-42eb-bc3e-6a78ddb1f7a8','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('1a14d2ed-b677-42eb-bc3e-6a78ddb1f7a8','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Rule of Wolves
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '8c1b857f-852f-4bb9-bcca-3761a46d8a78';
INSERT INTO book_categories (book_id, category_id) VALUES ('8c1b857f-852f-4bb9-bcca-3761a46d8a78','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('8c1b857f-852f-4bb9-bcca-3761a46d8a78','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('8c1b857f-852f-4bb9-bcca-3761a46d8a78','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Sea of Tranquility
UPDATE books SET primary_category_id = '6a151e20-73d9-45e0-94bf-be7a0f73f4cf' WHERE book_id = 'ac2c6867-0a1e-4e01-8016-b09183e01db9';
INSERT INTO book_categories (book_id, category_id) VALUES ('ac2c6867-0a1e-4e01-8016-b09183e01db9','6a151e20-73d9-45e0-94bf-be7a0f73f4cf') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('ac2c6867-0a1e-4e01-8016-b09183e01db9','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('ac2c6867-0a1e-4e01-8016-b09183e01db9','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ac2c6867-0a1e-4e01-8016-b09183e01db9','e88a4263-f077-4766-bcdf-1b7c585d211b') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ac2c6867-0a1e-4e01-8016-b09183e01db9','a0482b48-0021-4379-9f87-f33fdea112d5') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ac2c6867-0a1e-4e01-8016-b09183e01db9','a7010a6c-d6e8-4003-887f-f6298c65c147') ON CONFLICT DO NOTHING;

-- Serpent & Dove
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '665fe5b6-a36b-4104-883f-4400203a8976';
INSERT INTO book_categories (book_id, category_id) VALUES ('665fe5b6-a36b-4104-883f-4400203a8976','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('665fe5b6-a36b-4104-883f-4400203a8976','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('665fe5b6-a36b-4104-883f-4400203a8976','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Shadow and Bone
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = 'd6aeba5f-5d8a-4b67-a1df-f38f28b38d41';
INSERT INTO book_categories (book_id, category_id) VALUES ('d6aeba5f-5d8a-4b67-a1df-f38f28b38d41','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('d6aeba5f-5d8a-4b67-a1df-f38f28b38d41','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('d6aeba5f-5d8a-4b67-a1df-f38f28b38d41','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d6aeba5f-5d8a-4b67-a1df-f38f28b38d41','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d6aeba5f-5d8a-4b67-a1df-f38f28b38d41','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d6aeba5f-5d8a-4b67-a1df-f38f28b38d41','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Shatter Me
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'd8e0d3f2-d01a-4d53-80f8-7d97e61c8eba';
INSERT INTO book_categories (book_id, category_id) VALUES ('d8e0d3f2-d01a-4d53-80f8-7d97e61c8eba','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('d8e0d3f2-d01a-4d53-80f8-7d97e61c8eba','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('d8e0d3f2-d01a-4d53-80f8-7d97e61c8eba','17739b35-27cb-41af-bb8d-d996f3519ee7') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d8e0d3f2-d01a-4d53-80f8-7d97e61c8eba','bf3da532-c2f1-412f-9ec1-00bef471b602') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d8e0d3f2-d01a-4d53-80f8-7d97e61c8eba','266310e8-0287-41e8-b5b0-fd0e237d438f') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d8e0d3f2-d01a-4d53-80f8-7d97e61c8eba','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- She Who Became the Sun
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'fc7b50ee-89c4-4622-8ac4-4e9fceaa97c8';
INSERT INTO book_categories (book_id, category_id) VALUES ('fc7b50ee-89c4-4622-8ac4-4e9fceaa97c8','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('fc7b50ee-89c4-4622-8ac4-4e9fceaa97c8','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('fc7b50ee-89c4-4622-8ac4-4e9fceaa97c8','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Siege and Storm
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = 'af5fa9fa-03c7-4640-8c1a-3172f22ba55f';
INSERT INTO book_categories (book_id, category_id) VALUES ('af5fa9fa-03c7-4640-8c1a-3172f22ba55f','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('af5fa9fa-03c7-4640-8c1a-3172f22ba55f','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('af5fa9fa-03c7-4640-8c1a-3172f22ba55f','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('af5fa9fa-03c7-4640-8c1a-3172f22ba55f','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('af5fa9fa-03c7-4640-8c1a-3172f22ba55f','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('af5fa9fa-03c7-4640-8c1a-3172f22ba55f','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Six of Crows
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '221e8d86-6295-4e54-826a-530f2db1c035';
INSERT INTO book_categories (book_id, category_id) VALUES ('221e8d86-6295-4e54-826a-530f2db1c035','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('221e8d86-6295-4e54-826a-530f2db1c035','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('221e8d86-6295-4e54-826a-530f2db1c035','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Small Things Like These
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '513fec1f-be49-4ef8-b19e-2202056073a0';
INSERT INTO book_categories (book_id, category_id) VALUES ('513fec1f-be49-4ef8-b19e-2202056073a0','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('513fec1f-be49-4ef8-b19e-2202056073a0','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('513fec1f-be49-4ef8-b19e-2202056073a0','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Spare
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '0b32f06d-5edf-4077-8d6e-ff38e207961a';
INSERT INTO book_categories (book_id, category_id) VALUES ('0b32f06d-5edf-4077-8d6e-ff38e207961a','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('0b32f06d-5edf-4077-8d6e-ff38e207961a','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('0b32f06d-5edf-4077-8d6e-ff38e207961a','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- The Ashes and the Star-Cursed King
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = 'ed315038-fb94-4c41-9759-667b65c7c540';
INSERT INTO book_categories (book_id, category_id) VALUES ('ed315038-fb94-4c41-9759-667b65c7c540','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('ed315038-fb94-4c41-9759-667b65c7c540','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('ed315038-fb94-4c41-9759-667b65c7c540','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ed315038-fb94-4c41-9759-667b65c7c540','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ed315038-fb94-4c41-9759-667b65c7c540','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ed315038-fb94-4c41-9759-667b65c7c540','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- The Atlas Six
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'c648e155-66b6-48dd-8374-9a8b5832df45';
INSERT INTO book_categories (book_id, category_id) VALUES ('c648e155-66b6-48dd-8374-9a8b5832df45','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('c648e155-66b6-48dd-8374-9a8b5832df45','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('c648e155-66b6-48dd-8374-9a8b5832df45','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- The Atlas Six: Illustrated Edition
UPDATE books SET primary_category_id = '6a151e20-73d9-45e0-94bf-be7a0f73f4cf' WHERE book_id = 'fdc843e7-3df6-417b-8bb6-ca1c80b401db';
INSERT INTO book_categories (book_id, category_id) VALUES ('fdc843e7-3df6-417b-8bb6-ca1c80b401db','6a151e20-73d9-45e0-94bf-be7a0f73f4cf') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('fdc843e7-3df6-417b-8bb6-ca1c80b401db','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('fdc843e7-3df6-417b-8bb6-ca1c80b401db','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('fdc843e7-3df6-417b-8bb6-ca1c80b401db','e88a4263-f077-4766-bcdf-1b7c585d211b') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('fdc843e7-3df6-417b-8bb6-ca1c80b401db','a0482b48-0021-4379-9f87-f33fdea112d5') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('fdc843e7-3df6-417b-8bb6-ca1c80b401db','a7010a6c-d6e8-4003-887f-f6298c65c147') ON CONFLICT DO NOTHING;

-- The Ballad of Songbirds and Snakes
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'c54e0224-118c-43c2-857e-22e74330e174';
INSERT INTO book_categories (book_id, category_id) VALUES ('c54e0224-118c-43c2-857e-22e74330e174','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('c54e0224-118c-43c2-857e-22e74330e174','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('c54e0224-118c-43c2-857e-22e74330e174','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- The Burning God
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '6e013b45-a52d-46c5-b45f-542274582583';
INSERT INTO book_categories (book_id, category_id) VALUES ('6e013b45-a52d-46c5-b45f-542274582583','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('6e013b45-a52d-46c5-b45f-542274582583','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('6e013b45-a52d-46c5-b45f-542274582583','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- The Covenant of Water
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '4f82177e-15ce-4c56-9fbf-796d7ea2804c';
INSERT INTO book_categories (book_id, category_id) VALUES ('4f82177e-15ce-4c56-9fbf-796d7ea2804c','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('4f82177e-15ce-4c56-9fbf-796d7ea2804c','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('4f82177e-15ce-4c56-9fbf-796d7ea2804c','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- The Dragon Republic
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = '333b9948-8b96-4be6-ac07-a03e5db15c92';
INSERT INTO book_categories (book_id, category_id) VALUES ('333b9948-8b96-4be6-ac07-a03e5db15c92','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('333b9948-8b96-4be6-ac07-a03e5db15c92','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('333b9948-8b96-4be6-ac07-a03e5db15c92','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('333b9948-8b96-4be6-ac07-a03e5db15c92','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('333b9948-8b96-4be6-ac07-a03e5db15c92','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('333b9948-8b96-4be6-ac07-a03e5db15c92','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- The Glass Castle
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = 'bb23edc9-91fb-41b1-9c1a-cffaeb05d01e';
INSERT INTO book_categories (book_id, category_id) VALUES ('bb23edc9-91fb-41b1-9c1a-cffaeb05d01e','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('bb23edc9-91fb-41b1-9c1a-cffaeb05d01e','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('bb23edc9-91fb-41b1-9c1a-cffaeb05d01e','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('bb23edc9-91fb-41b1-9c1a-cffaeb05d01e','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('bb23edc9-91fb-41b1-9c1a-cffaeb05d01e','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('bb23edc9-91fb-41b1-9c1a-cffaeb05d01e','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- The Goldfinch
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '05cb7ddc-fbd5-4899-a854-dbf06ee86046';
INSERT INTO book_categories (book_id, category_id) VALUES ('05cb7ddc-fbd5-4899-a854-dbf06ee86046','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('05cb7ddc-fbd5-4899-a854-dbf06ee86046','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('05cb7ddc-fbd5-4899-a854-dbf06ee86046','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- The House in the Cerulean Sea
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '9a6b9e7c-7cac-4c32-b420-c71b3dfbdcfb';
INSERT INTO book_categories (book_id, category_id) VALUES ('9a6b9e7c-7cac-4c32-b420-c71b3dfbdcfb','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('9a6b9e7c-7cac-4c32-b420-c71b3dfbdcfb','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('9a6b9e7c-7cac-4c32-b420-c71b3dfbdcfb','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- The Hunger Games
UPDATE books SET primary_category_id = '17739b35-27cb-41af-bb8d-d996f3519ee7' WHERE book_id = 'd669ef37-51a5-42ba-89c1-a3d8db0f300a';
INSERT INTO book_categories (book_id, category_id) VALUES ('d669ef37-51a5-42ba-89c1-a3d8db0f300a','17739b35-27cb-41af-bb8d-d996f3519ee7') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('d669ef37-51a5-42ba-89c1-a3d8db0f300a','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d669ef37-51a5-42ba-89c1-a3d8db0f300a','bf3da532-c2f1-412f-9ec1-00bef471b602') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d669ef37-51a5-42ba-89c1-a3d8db0f300a','266310e8-0287-41e8-b5b0-fd0e237d438f') ON CONFLICT DO NOTHING;

-- The Invisible Life of Addie LaRue
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '78529251-fc7e-40c4-b94f-1fe2fc676f4b';
INSERT INTO book_categories (book_id, category_id) VALUES ('78529251-fc7e-40c4-b94f-1fe2fc676f4b','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('78529251-fc7e-40c4-b94f-1fe2fc676f4b','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('78529251-fc7e-40c4-b94f-1fe2fc676f4b','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- The Midnight Library
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '775ee6ae-7471-4efa-a431-321fe0d8bb1f';
INSERT INTO book_categories (book_id, category_id) VALUES ('775ee6ae-7471-4efa-a431-321fe0d8bb1f','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('775ee6ae-7471-4efa-a431-321fe0d8bb1f','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('775ee6ae-7471-4efa-a431-321fe0d8bb1f','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- The Night Circus
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'fd1fe11b-e778-4802-aa00-416ac51e5f33';
INSERT INTO book_categories (book_id, category_id) VALUES ('fd1fe11b-e778-4802-aa00-416ac51e5f33','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('fd1fe11b-e778-4802-aa00-416ac51e5f33','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('fd1fe11b-e778-4802-aa00-416ac51e5f33','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- The Overstory
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '56be8083-b5b0-4618-8d39-524ca8def7da';
INSERT INTO book_categories (book_id, category_id) VALUES ('56be8083-b5b0-4618-8d39-524ca8def7da','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('56be8083-b5b0-4618-8d39-524ca8def7da','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('56be8083-b5b0-4618-8d39-524ca8def7da','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- The Poppy War
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '921783dc-7146-457f-b481-e0a921d0c584';
INSERT INTO book_categories (book_id, category_id) VALUES ('921783dc-7146-457f-b481-e0a921d0c584','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('921783dc-7146-457f-b481-e0a921d0c584','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('921783dc-7146-457f-b481-e0a921d0c584','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- The Priory of the Orange Tree
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'a74cdf3d-a11b-4f17-a7c5-0b3923aa4bba';
INSERT INTO book_categories (book_id, category_id) VALUES ('a74cdf3d-a11b-4f17-a7c5-0b3923aa4bba','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('a74cdf3d-a11b-4f17-a7c5-0b3923aa4bba','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('a74cdf3d-a11b-4f17-a7c5-0b3923aa4bba','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- The Road
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '1a28b1f2-7ec2-4664-82d3-3c69acd79969';
INSERT INTO book_categories (book_id, category_id) VALUES ('1a28b1f2-7ec2-4664-82d3-3c69acd79969','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('1a28b1f2-7ec2-4664-82d3-3c69acd79969','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('1a28b1f2-7ec2-4664-82d3-3c69acd79969','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- The Rose and the Dagger
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '8b2a2fa1-f832-429b-a4d8-27db06cc0fdc';
INSERT INTO book_categories (book_id, category_id) VALUES ('8b2a2fa1-f832-429b-a4d8-27db06cc0fdc','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('8b2a2fa1-f832-429b-a4d8-27db06cc0fdc','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('8b2a2fa1-f832-429b-a4d8-27db06cc0fdc','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- The Serpent and the Wings of Night
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '96166a20-0c85-469a-961d-8e876f98d00b';
INSERT INTO book_categories (book_id, category_id) VALUES ('96166a20-0c85-469a-961d-8e876f98d00b','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('96166a20-0c85-469a-961d-8e876f98d00b','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('96166a20-0c85-469a-961d-8e876f98d00b','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- The Shadows Between Us
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = 'f42ea33a-0edc-4697-b154-7cee4faf6919';
INSERT INTO book_categories (book_id, category_id) VALUES ('f42ea33a-0edc-4697-b154-7cee4faf6919','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('f42ea33a-0edc-4697-b154-7cee4faf6919','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('f42ea33a-0edc-4697-b154-7cee4faf6919','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('f42ea33a-0edc-4697-b154-7cee4faf6919','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('f42ea33a-0edc-4697-b154-7cee4faf6919','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('f42ea33a-0edc-4697-b154-7cee4faf6919','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- The Song of Achilles
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '061cc62d-4530-42d2-855d-365359e7b206';
INSERT INTO book_categories (book_id, category_id) VALUES ('061cc62d-4530-42d2-855d-365359e7b206','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('061cc62d-4530-42d2-855d-365359e7b206','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('061cc62d-4530-42d2-855d-365359e7b206','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- The Songbird and the Heart of Stone
UPDATE books SET primary_category_id = '84484d09-8b66-4ea7-9edc-106fd13ffd73' WHERE book_id = '08f2c938-7a33-48ea-a611-698f26df1195';
INSERT INTO book_categories (book_id, category_id) VALUES ('08f2c938-7a33-48ea-a611-698f26df1195','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('08f2c938-7a33-48ea-a611-698f26df1195','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('08f2c938-7a33-48ea-a611-698f26df1195','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('08f2c938-7a33-48ea-a611-698f26df1195','e2e54289-a55d-401a-a341-77e5b08023e0') ON CONFLICT DO NOTHING;

-- The Stardust Thief
UPDATE books SET primary_category_id = '17739b35-27cb-41af-bb8d-d996f3519ee7' WHERE book_id = '4310d0ed-3d59-4085-b4f1-0e7ffb31874f';
INSERT INTO book_categories (book_id, category_id) VALUES ('4310d0ed-3d59-4085-b4f1-0e7ffb31874f','17739b35-27cb-41af-bb8d-d996f3519ee7') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('4310d0ed-3d59-4085-b4f1-0e7ffb31874f','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('4310d0ed-3d59-4085-b4f1-0e7ffb31874f','fa7e1059-7a33-4976-8bbd-2e6189548642') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('4310d0ed-3d59-4085-b4f1-0e7ffb31874f','68e2ff8f-6716-4de9-99cf-990050bc8f92') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('4310d0ed-3d59-4085-b4f1-0e7ffb31874f','24b6f710-3aef-4366-946b-e96c4ab9cee2') ON CONFLICT DO NOTHING;

-- The Testaments
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '290f8912-5cf8-4771-a6f3-ec9da866d3e7';
INSERT INTO book_categories (book_id, category_id) VALUES ('290f8912-5cf8-4771-a6f3-ec9da866d3e7','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('290f8912-5cf8-4771-a6f3-ec9da866d3e7','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('290f8912-5cf8-4771-a6f3-ec9da866d3e7','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- The Underground Railroad
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'ce398622-71f1-46f4-afcc-53ae0361f631';
INSERT INTO book_categories (book_id, category_id) VALUES ('ce398622-71f1-46f4-afcc-53ae0361f631','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('ce398622-71f1-46f4-afcc-53ae0361f631','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('ce398622-71f1-46f4-afcc-53ae0361f631','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- The Warmth of paperback Suns
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'f21d8987-d8bf-489e-a068-6369266d3fd0';
INSERT INTO book_categories (book_id, category_id) VALUES ('f21d8987-d8bf-489e-a068-6369266d3fd0','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('f21d8987-d8bf-489e-a068-6369266d3fd0','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('f21d8987-d8bf-489e-a068-6369266d3fd0','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- The Wrath and the Dawn
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'af9d51dd-fe4e-479e-af77-854242f1ffff';
INSERT INTO book_categories (book_id, category_id) VALUES ('af9d51dd-fe4e-479e-af77-854242f1ffff','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('af9d51dd-fe4e-479e-af77-854242f1ffff','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('af9d51dd-fe4e-479e-af77-854242f1ffff','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- This Savage Song
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '31e6de7e-1e85-4565-87f1-140d98670c23';
INSERT INTO book_categories (book_id, category_id) VALUES ('31e6de7e-1e85-4565-87f1-140d98670c23','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('31e6de7e-1e85-4565-87f1-140d98670c23','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('31e6de7e-1e85-4565-87f1-140d98670c23','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Throne of Glass
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = 'bf42b2ff-49f8-4ee4-9170-c54e0c427c08';
INSERT INTO book_categories (book_id, category_id) VALUES ('bf42b2ff-49f8-4ee4-9170-c54e0c427c08','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('bf42b2ff-49f8-4ee4-9170-c54e0c427c08','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('bf42b2ff-49f8-4ee4-9170-c54e0c427c08','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('bf42b2ff-49f8-4ee4-9170-c54e0c427c08','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('bf42b2ff-49f8-4ee4-9170-c54e0c427c08','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('bf42b2ff-49f8-4ee4-9170-c54e0c427c08','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Tomorrow, and Tomorrow, and Tomorrow
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '0009d0a3-d932-417c-8e05-560e54b6505a';
INSERT INTO book_categories (book_id, category_id) VALUES ('0009d0a3-d932-417c-8e05-560e54b6505a','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('0009d0a3-d932-417c-8e05-560e54b6505a','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('0009d0a3-d932-417c-8e05-560e54b6505a','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Tomorrow, and Tomorrow, and Tomorrow: Collector’s Edition
UPDATE books SET primary_category_id = '6a151e20-73d9-45e0-94bf-be7a0f73f4cf' WHERE book_id = 'b490dbfa-1183-476d-8cff-23239c89ee4b';
INSERT INTO book_categories (book_id, category_id) VALUES ('b490dbfa-1183-476d-8cff-23239c89ee4b','6a151e20-73d9-45e0-94bf-be7a0f73f4cf') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('b490dbfa-1183-476d-8cff-23239c89ee4b','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('b490dbfa-1183-476d-8cff-23239c89ee4b','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('b490dbfa-1183-476d-8cff-23239c89ee4b','e88a4263-f077-4766-bcdf-1b7c585d211b') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('b490dbfa-1183-476d-8cff-23239c89ee4b','a0482b48-0021-4379-9f87-f33fdea112d5') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('b490dbfa-1183-476d-8cff-23239c89ee4b','a7010a6c-d6e8-4003-887f-f6298c65c147') ON CONFLICT DO NOTHING;

-- Tower of Dawn
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'd2c936f3-18c9-416d-a11b-bae4199cb449';
INSERT INTO book_categories (book_id, category_id) VALUES ('d2c936f3-18c9-416d-a11b-bae4199cb449','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('d2c936f3-18c9-416d-a11b-bae4199cb449','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d2c936f3-18c9-416d-a11b-bae4199cb449','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Trust
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'cf36f9f8-4b5f-4fd7-b9d1-d123775314be';
INSERT INTO book_categories (book_id, category_id) VALUES ('cf36f9f8-4b5f-4fd7-b9d1-d123775314be','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('cf36f9f8-4b5f-4fd7-b9d1-d123775314be','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('cf36f9f8-4b5f-4fd7-b9d1-d123775314be','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Under the Whispering Door
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'd9d7198c-9c55-46db-9cd0-d24b7efecf88';
INSERT INTO book_categories (book_id, category_id) VALUES ('d9d7198c-9c55-46db-9cd0-d24b7efecf88','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('d9d7198c-9c55-46db-9cd0-d24b7efecf88','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d9d7198c-9c55-46db-9cd0-d24b7efecf88','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Vengeful
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = '9fc934b4-373c-4e47-8e87-6bfac305f403';
INSERT INTO book_categories (book_id, category_id) VALUES ('9fc934b4-373c-4e47-8e87-6bfac305f403','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('9fc934b4-373c-4e47-8e87-6bfac305f403','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('9fc934b4-373c-4e47-8e87-6bfac305f403','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Verity
UPDATE books SET primary_category_id = '6a151e20-73d9-45e0-94bf-be7a0f73f4cf' WHERE book_id = '31c6baac-7966-4ff0-b0dd-912889ef431f';
INSERT INTO book_categories (book_id, category_id) VALUES ('31c6baac-7966-4ff0-b0dd-912889ef431f','6a151e20-73d9-45e0-94bf-be7a0f73f4cf') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('31c6baac-7966-4ff0-b0dd-912889ef431f','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('31c6baac-7966-4ff0-b0dd-912889ef431f','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('31c6baac-7966-4ff0-b0dd-912889ef431f','e88a4263-f077-4766-bcdf-1b7c585d211b') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('31c6baac-7966-4ff0-b0dd-912889ef431f','a0482b48-0021-4379-9f87-f33fdea112d5') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('31c6baac-7966-4ff0-b0dd-912889ef431f','a7010a6c-d6e8-4003-887f-f6298c65c147') ON CONFLICT DO NOTHING;

-- War Storm
UPDATE books SET primary_category_id = '43f85820-0294-49e4-953c-ea119f2eb8f9' WHERE book_id = 'd1e5b180-2da0-463f-9bfa-8170b15bcfe3';
INSERT INTO book_categories (book_id, category_id) VALUES ('d1e5b180-2da0-463f-9bfa-8170b15bcfe3','43f85820-0294-49e4-953c-ea119f2eb8f9') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('d1e5b180-2da0-463f-9bfa-8170b15bcfe3','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('d1e5b180-2da0-463f-9bfa-8170b15bcfe3','7c78a105-695c-4a82-b99a-b4d0fdcb1915') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d1e5b180-2da0-463f-9bfa-8170b15bcfe3','5c1074cd-d714-4d26-9612-e3b7cd658012') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d1e5b180-2da0-463f-9bfa-8170b15bcfe3','d9f01075-d55c-4023-ba92-8dc49a70f976') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d1e5b180-2da0-463f-9bfa-8170b15bcfe3','9ae1fac3-0fd2-475e-bdfb-a916296450f1') ON CONFLICT DO NOTHING;

-- Where the Crawdads Sing
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'd3c81bd4-bd29-4236-a0d9-08b45ffacb78';
INSERT INTO book_categories (book_id, category_id) VALUES ('d3c81bd4-bd29-4236-a0d9-08b45ffacb78','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('d3c81bd4-bd29-4236-a0d9-08b45ffacb78','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('d3c81bd4-bd29-4236-a0d9-08b45ffacb78','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Wolf Hall
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'f37905f0-a109-4420-ab95-96e97a7d31b2';
INSERT INTO book_categories (book_id, category_id) VALUES ('f37905f0-a109-4420-ab95-96e97a7d31b2','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('f37905f0-a109-4420-ab95-96e97a7d31b2','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('f37905f0-a109-4420-ab95-96e97a7d31b2','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

-- Yellowface
UPDATE books SET primary_category_id = '9afa3511-0ba6-4c66-b2f2-169c6815d139' WHERE book_id = 'b865cf43-8be2-42cd-9678-11d561cb94a4';
INSERT INTO book_categories (book_id, category_id) VALUES ('b865cf43-8be2-42cd-9678-11d561cb94a4','9afa3511-0ba6-4c66-b2f2-169c6815d139') ON CONFLICT DO NOTHING;
INSERT INTO book_categories (book_id, category_id) VALUES ('b865cf43-8be2-42cd-9678-11d561cb94a4','84484d09-8b66-4ea7-9edc-106fd13ffd73') ON CONFLICT DO NOTHING;
INSERT INTO book_genres (book_id, genre_id) VALUES ('b865cf43-8be2-42cd-9678-11d561cb94a4','f250adc5-8454-4ed3-81ff-dbde4c78bd1f') ON CONFLICT DO NOTHING;

COMMIT;