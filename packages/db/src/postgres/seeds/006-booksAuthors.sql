-- Book Authors Seed Data
-- Populates the book_authors junction table with relationships between books and
-- authors
begin
;

-- Sarah J. Maas books (Throne of Glass, A Court series, Crescent City)
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('bf42b2ff-49f8-4ee4-9170-c54e0c427c08', 'adf12604-1aa7-43c4-b389-4141c4fb3d74', 'author', 1), -- Throne of Glass
('94578ec4-205d-4644-aa91-7647bc2d9900', 'adf12604-1aa7-43c4-b389-4141c4fb3d74', 'author', 1), -- A Court of Thorns and Roses
('3b67e257-fcbb-4de4-8149-5ce9960f77b9', 'adf12604-1aa7-43c4-b389-4141c4fb3d74', 'author', 1), -- A Court of Mist and Fury
('b93913d0-c4af-46ca-a602-a31b06c816ec', 'adf12604-1aa7-43c4-b389-4141c4fb3d74', 'author', 1), -- A Court of Wings and Ruin
('6ad0bc0d-310a-4cfb-bc16-5d6106f5d530', 'adf12604-1aa7-43c4-b389-4141c4fb3d74', 'author', 1), -- A Court of Silver Flames
('c3a219ff-bce7-4c1f-a075-bac2b1d3c1bd', 'adf12604-1aa7-43c4-b389-4141c4fb3d74', 'author', 1), -- Heir of Fire
('c2aa178c-b58b-4b7d-a093-af38aeea0a67', 'adf12604-1aa7-43c4-b389-4141c4fb3d74', 'author', 1), -- Heir of Fire: Collector's Edition
('222edd9c-bbe5-4f22-b380-e3c23e92a970', 'adf12604-1aa7-43c4-b389-4141c4fb3d74', 'author', 1), -- Crown of Midnight
('747d5df7-daf5-47ea-9ebe-e707e21d7fd8', 'adf12604-1aa7-43c4-b389-4141c4fb3d74', 'author', 1), -- Queen of Shadows
('ee722a96-7146-40b7-acec-349d304ab002', 'adf12604-1aa7-43c4-b389-4141c4fb3d74', 'author', 1), -- Empire of Storms
('d2c936f3-18c9-416d-a11b-bae4199cb449', 'adf12604-1aa7-43c4-b389-4141c4fb3d74', 'author', 1), -- Tower of Dawn
('b7bdb37a-2202-4c17-a0c8-dcf47f0ae88a', 'adf12604-1aa7-43c4-b389-4141c4fb3d74', 'author', 1), -- Kingdom of Ash
('fef9641f-1ed0-48c7-9d84-72a0e5618bef', 'adf12604-1aa7-43c4-b389-4141c4fb3d74', 'author', 1), -- House of Earth and Blood
('e9cb7006-e285-4530-9643-0a0a959305a0', 'adf12604-1aa7-43c4-b389-4141c4fb3d74', 'author', 1), -- House of Sky and Breath
('67c27067-9f20-4770-991a-29426cc34ec3', 'adf12604-1aa7-43c4-b389-4141c4fb3d74', 'author', 1), -- Crescent City: House of Sky and Breath

-- Leigh Bardugo books (Six of Crows, Shadow and Bone series, King of Scars)
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('221e8d86-6295-4e54-826a-530f2db1c035', '7db2366f-2a00-4a4c-9719-e675b0a5a3ab', 'author', 1), -- Six of Crows
('49640ebf-be54-4bf8-98c7-139c8fc728c3', '7db2366f-2a00-4a4c-9719-e675b0a5a3ab', 'author', 1), -- Crooked Kingdom
('d6aeba5f-5d8a-4b67-a1df-f38f28b38d41', '7db2366f-2a00-4a4c-9719-e675b0a5a3ab', 'author', 1), -- Shadow and Bone
('af5fa9fa-03c7-4640-8c1a-3172f22ba55f', '7db2366f-2a00-4a4c-9719-e675b0a5a3ab', 'author', 1), -- Siege and Storm
('1a14d2ed-b677-42eb-bc3e-6a78ddb1f7a8', '7db2366f-2a00-4a4c-9719-e675b0a5a3ab', 'author', 1), -- Ruin and Rising
('71a1edd8-e536-4415-9daf-1ec428ee9b73', '7db2366f-2a00-4a4c-9719-e675b0a5a3ab', 'author', 1), -- King of Scars
('8c1b857f-852f-4bb9-bcca-3761a46d8a78', '7db2366f-2a00-4a4c-9719-e675b0a5a3ab', 'author', 1), -- Rule of Wolves

-- Rebecca Yarros books (Fourth Wing series)
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('16c51354-2fda-48fe-85f7-0ae0e1ac75ec', 'b8cd8769-84b8-44b5-b1a7-6a0a1a0191e1', 'author', 1), -- Fourth Wing
('562d34dc-09e9-4aab-859f-5a486394ff9f', 'b8cd8769-84b8-44b5-b1a7-6a0a1a0191e1', 'author', 1), -- Iron Flame

-- Cassandra Clare books (The Mortal Instruments, Infernal Devices, The Dark Artifices)
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('a91c59b3-eb49-462f-b6a3-3a8dcc723ec5', 'a60f3b09-32da-4e7e-8874-88284f0d5bce', 'author', 1), -- City of Bones
('76999973-8825-4e01-9101-70714a9486e5', 'a60f3b09-32da-4e7e-8874-88284f0d5bce', 'author', 1), -- City of Ashes
('cfdf78b2-c54b-4f90-98c6-684321fbe3a1', 'a60f3b09-32da-4e7e-8874-88284f0d5bce', 'author', 1), -- City of Glass
('f58abff5-0d08-412c-96bf-244e15f8aee6', 'a60f3b09-32da-4e7e-8874-88284f0d5bce', 'author', 1), -- City of Fallen Angels
('9c14aa8a-70ea-4be8-a8ac-e1ee8ed4f755', 'a60f3b09-32da-4e7e-8874-88284f0d5bce', 'author', 1), -- City of Lost Souls
('d84bc7b3-d136-4c66-a9a3-276c53978196', 'a60f3b09-32da-4e7e-8874-88284f0d5bce', 'author', 1), -- City of Heavenly Fire
('d9a43bea-6187-46e9-93dd-aac0175a1708', 'a60f3b09-32da-4e7e-8874-88284f0d5bce', 'author', 1), -- Clockwork Angel
('8dadf3d7-623a-4b37-abad-5cbdfb76890f', 'a60f3b09-32da-4e7e-8874-88284f0d5bce', 'author', 1), -- Clockwork Princess
('ffc16873-1f35-45d9-a6f2-93ae90d2b387', 'a60f3b09-32da-4e7e-8874-88284f0d5bce', 'author', 1), -- Lady Midnight
('370bb1f1-7eda-4828-93e5-88cace76098d', 'a60f3b09-32da-4e7e-8874-88284f0d5bce', 'author', 1), -- Lord of Shadows
('ae02e3da-e96e-4f34-8c45-33fe6327412c', 'a60f3b09-32da-4e7e-8874-88284f0d5bce', 'author', 1), -- Queen of Air and Darkness
('33c71273-b4ee-45fc-ae72-79048c9792b2', 'a60f3b09-32da-4e7e-8874-88284f0d5bce', 'author', 1), -- Chain of Gold
('8d014e8c-c611-4440-9fd1-155064e07a27', 'a60f3b09-32da-4e7e-8874-88284f0d5bce', 'author', 1), -- Chain of Iron

-- Suzanne Collins books (The Hunger Games trilogy)
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('d669ef37-51a5-42ba-89c1-a3d8db0f300a', '818e653a-36fa-4a32-98e1-23980d95005f', 'author', 1), -- The Hunger Games
('d7b46e40-8242-4f70-8996-6ba5d29bb64a', '818e653a-36fa-4a32-98e1-23980d95005f', 'author', 1), -- Catching Fire
('fcf19eb6-74e4-482b-862a-f3c20f0a57a2', '818e653a-36fa-4a32-98e1-23980d95005f', 'author', 1), -- Mockingjay
('c54e0224-118c-43c2-857e-22e74330e174', '818e653a-36fa-4a32-98e1-23980d95005f', 'author', 1), -- The Ballad of Songbirds and Snakes

-- Veronica Roth books (Divergent series)
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('3f197abc-a693-49d5-b0bb-406edd54c693', 'd522af42-4c69-4ff1-9127-c35e97912f41', 'author', 1), -- Insurgent
('c64f7799-493f-4135-abd0-e12310577760', 'd522af42-4c69-4ff1-9127-c35e97912f41', 'author', 1), -- Allegiant
('086a303e-3247-4a0b-8994-54ff7e666480', 'd522af42-4c69-4ff1-9127-c35e97912f41', 'author', 1), -- Four: A Divergent Collection

-- Victoria Aveyard books (Red Queen series)
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('1b8c2b12-c017-4804-8df8-9b5e45c3f87f', '7a4fa824-da78-4736-acda-b792aa2e64a6', 'author', 1), -- Red Queen
('79972b3e-04c5-43df-a4d0-2046ef79d6be', '7a4fa824-da78-4736-acda-b792aa2e64a6', 'author', 1), -- Glass Sword
('908ccf06-f3a9-4ee3-89b8-c1bfab8a07db', '7a4fa824-da78-4736-acda-b792aa2e64a6', 'author', 1), -- King's Cage
('d1e5b180-2da0-463f-9bfa-8170b15bcfe3', '7a4fa824-da78-4736-acda-b792aa2e64a6', 'author', 1), -- War Storm

-- Tahereh Mafi books (Shatter Me series)
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('d8e0d3f2-d01a-4d53-80f8-7d97e61c8eba', '2ec75b29-9589-44c2-b5e8-ee19df6a6e63', 'author', 1), -- Shatter Me
('9bfa6939-ff65-4a89-b02b-cab365544ec4', '2ec75b29-9589-44c2-b5e8-ee19df6a6e63', 'author', 1), -- Defy Me
('c3722913-0cd4-4cfb-9544-15c9b70d1f8c', '2ec75b29-9589-44c2-b5e8-ee19df6a6e63', 'author', 1), -- Ignite Me
('3e48080f-456f-4dd4-8ed3-996c4c5d1db9', '2ec75b29-9589-44c2-b5e8-ee19df6a6e63', 'author', 1), -- Restore Me
('ba70c5e9-a793-4384-992c-047ea44b45c6', '2ec75b29-9589-44c2-b5e8-ee19df6a6e63', 'author', 1), -- Imagine Me

-- V.E. Schwab books (Shades of Magic series, Monsters of Verity series)
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('a30177e0-30cd-4d73-8c78-0db194465e33', '88d9f223-6fc6-4fbc-a60f-bb721a8f8f3d', 'author', 1), -- A Gathering of Shadows
('c8950321-9395-44ce-828c-78a732f91b37', '88d9f223-6fc6-4fbc-a60f-bb721a8f8f3d', 'author', 1), -- A Conjuring of Light
('31e6de7e-1e85-4565-87f1-140d98670c23', '88d9f223-6fc6-4fbc-a60f-bb721a8f8f3d', 'author', 1), -- This Savage Song
('ecec3822-2abb-4fe8-8a35-8f75cb5b5d00', '88d9f223-6fc6-4fbc-a60f-bb721a8f8f3d', 'author', 1), -- Our Dark Duet
('9fc934b4-373c-4e47-8e87-6bfac305f403', '88d9f223-6fc6-4fbc-a60f-bb721a8f8f3d', 'author', 1), -- Vengeful

-- Stephanie Garber books (Caraval series)
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('d3ea78cd-2f26-4667-8a48-35a045d4e58d', '104c502e-83e0-4239-83d3-7b7657ec394d', 'author', 1), -- Caraval
('ecb5cef2-e4e8-4393-b167-d677b47f3546', '104c502e-83e0-4239-83d3-7b7657ec394d', 'author', 1), -- Legendary
('65856882-88f7-4c34-983a-a66466cbbb4e', '104c502e-83e0-4239-83d3-7b7657ec394d', 'author', 1), -- Finale
('8dd1495b-7b0a-41d1-97f6-77f99adbedd9', '104c502e-83e0-4239-83d3-7b7657ec394d', 'author', 1), -- Once Upon a Broken Heart

-- R.F. Kuang books (The Poppy War trilogy)
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('921783dc-7146-457f-b481-e0a921d0c584', 'd3f177b7-21d9-46d0-b329-d3d25dd92f93', 'author', 1), -- The Poppy War
('333b9948-8b96-4be6-ac07-a03e5db15c92', 'd3f177b7-21d9-46d0-b329-d3d25dd92f93', 'author', 1), -- The Dragon Republic
('6e013b45-a52d-46c5-b45f-542274582583', 'd3f177b7-21d9-46d0-b329-d3d25dd92f93', 'author', 1), -- The Burning God
('490214ac-1b2d-4e5b-97cd-e27514faed75', 'd3f177b7-21d9-46d0-b329-d3d25dd92f93', 'author', 1), -- Babel
('b865cf43-8be2-42cd-9678-11d561cb94a4', 'd3f177b7-21d9-46d0-b329-d3d25dd92f93', 'author', 1), -- Yellowface

-- Tomi Adeyemi books (Children of Blood and Bone series)
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('ffeba2da-9089-4354-9d48-a8a1bca080c2', '56361d56-c343-42b0-90fa-611fcc9668bd', 'author', 1), -- Children of Blood and Bone
('23c78129-82ff-48fd-8dd1-3772f1afff51', '56361d56-c343-42b0-90fa-611fcc9668bd', 'author', 1), -- Children of Virtue and Vengeance

-- Jay Kristoff books (Nevernight Chronicle, Aurora Cycle with Amie Kaufman)
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('ccecba4e-19f2-4977-a7f5-a64ba54c2de8', '1e6f6699-e138-4a81-948a-00489cfbe8f2', 'author', 1), -- Nevernight
('22e73320-3645-47b6-a9b5-0be5be8f05ad', '1e6f6699-e138-4a81-948a-00489cfbe8f2', 'author', 1), -- Godsgrave
('7d447336-8fd1-4881-a2d9-d63b6c24d1ae', '1e6f6699-e138-4a81-948a-00489cfbe8f2', 'author', 1), -- Darkdawn

-- Aurora Cycle books (Amie Kaufman & Jay Kristoff collaboration)
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('1ff0995a-4cd4-4ff4-bfbd-7bae9e760726', '58703afb-c6fb-4aae-a7d4-7c35e50fd3a4', 'author', 1), -- Aurora Rising
('1ff0995a-4cd4-4ff4-bfbd-7bae9e760726', '1e6f6699-e138-4a81-948a-00489cfbe8f2', 'co-author', 2), -- Aurora Rising
('ec828ace-a3e6-4625-9a16-31f19d1b57e2', '58703afb-c6fb-4aae-a7d4-7c35e50fd3a4', 'author', 1), -- Aurora Burning
('ec828ace-a3e6-4625-9a16-31f19d1b57e2', '1e6f6699-e138-4a81-948a-00489cfbe8f2', 'co-author', 2), -- Aurora Burning
('198517e6-4fd4-4b5b-aec7-ac135b050bd7', '58703afb-c6fb-4aae-a7d4-7c35e50fd3a4', 'author', 1), -- Aurora's End
('198517e6-4fd4-4b5b-aec7-ac135b050bd7', '1e6f6699-e138-4a81-948a-00489cfbe8f2', 'co-author', 2), -- Aurora's End

-- Illuminae Files
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('58c809f0-4d05-4d6a-9255-f00c357a84eb', '58703afb-c6fb-4aae-a7d4-7c35e50fd3a4', 'author', 1), -- Illuminae
('58c809f0-4d05-4d6a-9255-f00c357a84eb', '1e6f6699-e138-4a81-948a-00489cfbe8f2', 'co-author', 2), -- Illuminae
('caca1abb-0677-4801-9586-f8732d8937df', '58703afb-c6fb-4aae-a7d4-7c35e50fd3a4', 'author', 1), -- Obsidio
('caca1abb-0677-4801-9586-f8732d8937df', '1e6f6699-e138-4a81-948a-00489cfbe8f2', 'co-author', 2), -- Obsidio

-- Colleen Hoover books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('af1155b0-ca5a-4a8a-9091-e6fc4312b3cb', 'b90d80c8-87a3-41d9-90a8-2a3695739733', 'author', 1), -- It Ends with Us
('a3fe79d2-2a75-40be-945f-259ae87e26f3', 'b90d80c8-87a3-41d9-90a8-2a3695739733', 'author', 1), -- It Starts with Us
('72aac672-fcb5-4f75-8c9f-35b54c08b431', 'b90d80c8-87a3-41d9-90a8-2a3695739733', 'author', 1), -- Reminders of Him
('31c6baac-7966-4ff0-b0dd-912889ef431f', 'b90d80c8-87a3-41d9-90a8-2a3695739733', 'author', 1), -- Verity

-- Emily Henry books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('da9871b3-97d4-4bca-9f21-be4755a67c78', '8426813b-7470-4530-ab3e-fc9306e1a711', 'author', 1), -- Book Lovers
('81e40d49-4bf3-46d7-a16e-0d27f04aeeed', '8426813b-7470-4530-ab3e-fc9306e1a711', 'author', 1), -- Happy Place

-- Taylor Jenkins Reid books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('d251529b-44c7-4628-ae32-1b54f4efcc03', '703625f1-efa5-4f4a-9642-5ebd89e13442', 'author', 1), -- Malibu Rising
('edf616f5-cdc1-4074-b31c-adad5922351a', '703625f1-efa5-4f4a-9642-5ebd89e13442', 'author', 1), -- Carrie Soto Is Back

-- Andy Weir books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('e1979d34-ff10-4f48-9ecc-c4d8fe3dc1d7', '0ec7f124-a7d4-4c2d-b41f-920acbc263fe', 'author', 1), -- Project Hail Mary

-- TJ Klune books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('9a6b9e7c-7cac-4c32-b420-c71b3dfbdcfb', '381df5a4-a6ed-4285-893f-3eed718280f9', 'author', 1), -- The House in the Cerulean Sea
('d9d7198c-9c55-46db-9cd0-d24b7efecf88', '381df5a4-a6ed-4285-893f-3eed718280f9', 'author', 1), -- Under the Whispering Door

-- Matt Haig books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('775ee6ae-7471-4efa-a431-321fe0d8bb1f', '1d877364-e0b9-4af2-a45e-36c62714e291', 'author', 1), -- The Midnight Library

-- Gabrielle Zevin books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('0009d0a3-d932-417c-8e05-560e54b6505a', '95039e59-600c-4a43-95f0-f2c3391b0c5d', 'author', 1), -- Tomorrow, and Tomorrow, and Tomorrow
('b490dbfa-1183-476d-8cff-23239c89ee4b', '95039e59-600c-4a43-95f0-f2c3391b0c5d', 'author', 1), -- Tomorrow, and Tomorrow, and Tomorrow: Collector's Edition

-- Madeline Miller books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('061cc62d-4530-42d2-855d-365359e7b206', 'b3e27f3b-cd52-4178-8816-3e120f69cd90', 'author', 1), -- The Song of Achilles
('6d1dd482-cd9d-456b-8de0-1b032e9e0df6', 'b3e27f3b-cd52-4178-8816-3e120f69cd90', 'author', 1), -- Circe

-- Bonnie Garmus books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('6d1dd482-cd9d-456b-8de0-1b032e9e0df6', 'ec637566-1ec0-4fc7-b2d4-a469d3687987', 'author', 1), -- Lessons in Chemistry

-- Delia Owens books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('d3c81bd4-bd29-4236-a0d9-08b45ffacb78', '34045ca8-33ac-443b-ae1d-7507f6d1ba26', 'author', 1), -- Where the Crawdads Sing

-- Barbara Kingsolver books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('0c046c96-9c1b-44cd-bf7a-ea9d1f87fea6', 'c94e9837-abfc-4f67-b1e7-df795a5995bd', 'author', 1), -- Demon Copperhead

-- Anthony Doerr books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('978985ec-1759-46ee-bb14-531c9bfcc3c7', '09417e8e-59bc-48e3-ac02-eaf1d84ed526', 'author', 1), -- All the Light We Cannot See

-- Abraham Verghese books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('4f82177e-15ce-4c56-9fbf-796d7ea2804c', '45db176a-655e-4a4f-8ba0-abe2c51086ff', 'author', 1), -- The Covenant of Water

-- Kazuo Ishiguro books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('f3545f5d-3fc7-4be1-91e4-4d2b86150cbe', 'ca39a5ae-48bb-4fe4-b194-1a19f998f137', 'author', 1), -- Klara and the Sun
('cb7028c5-583d-4505-870c-8918923e3468', 'ca39a5ae-48bb-4fe4-b194-1a19f998f137', 'author', 1), -- Never Let Me Go

-- Sally Rooney books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('7302da6b-0859-48c8-a743-8ffc73bd6ed5', 'ea23ab18-c3b4-403d-973a-2c3d55977d0d', 'author', 1), -- Normal People

-- Elena Ferrante books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('8285b0f2-c2f1-4ff3-a74e-030e4cb47ffa', '35618255-9cbb-4de6-aab1-108c22f13788', 'author', 1), -- My Brilliant Friend

-- Margaret Atwood books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('290f8912-5cf8-4771-a6f3-ec9da866d3e7', '021985f1-e62e-4f89-a402-208e7d58ca6e', 'author', 1), -- The Testaments

-- Gillian Flynn books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('913767b4-f2bc-4711-a058-23a1dc92d6a3', '83ff1522-7e7e-4e24-8aaa-a19bcc05da3f', 'author', 1), -- Gone Girl

-- Donna Tartt books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('05cb7ddc-fbd5-4899-a854-dbf06ee86046', '433ae7ba-d698-43d5-9e09-b9f39f9a9101', 'author', 1), -- The Goldfinch

-- George Saunders books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('eb9910da-1c69-4ef0-8e0e-5840ca04a380', '49a16f2d-5a37-4201-b147-efd208485a17', 'author', 1), -- Lincoln in the Bardo

-- Cormac McCarthy books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('1a28b1f2-7ec2-4664-82d3-3c69acd79969', 'c3fec48c-f89c-4aaa-8054-ac8963ead3ea', 'author', 1), -- The Road

-- Colson Whitehead books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('ce398622-71f1-46f4-afcc-53ae0361f631', 'f6c5c7c0-a5c4-4a5f-9c62-f0e246192d08', 'author', 1), -- The Underground Railroad

-- Ian McEwan books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('530800c6-b78d-4c1d-9367-7a1732ede5dc', '77393eef-2212-4730-8bd2-d727a91c1c79', 'author', 1), -- Lessons

-- Hilary Mantel books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('f37905f0-a109-4420-ab95-96e97a7d31b2', '42071998-4576-4406-9503-a40792c0898b', 'author', 1), -- Wolf Hall

-- Richard Powers books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('56be8083-b5b0-4618-8d39-524ca8def7da', '452dcc27-dc03-43ed-a784-22af4eb9c966', 'author', 1), -- The Overstory

-- Emily St. John Mandel books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('ac2c6867-0a1e-4e01-8016-b09183e01db9', 'e8584e69-3f27-4e34-ae25-fbdcafa9c066', 'author', 1), -- Sea of Tranquility

-- Erin Morgenstern books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('fd1fe11b-e778-4802-aa00-416ac51e5f33', 'c8d84b91-912a-49c9-a071-4482ca2749cd', 'author', 1), -- The Night Circus
('78529251-fc7e-40c4-b94f-1fe2fc676f4b', 'c8d84b91-912a-49c9-a071-4482ca2749cd', 'author', 1), -- The Invisible Life of Addie LaRue

-- Jeannette Walls books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('bb23edc9-91fb-41b1-9c1a-cffaeb05d01e', '322ef68b-bb33-4e87-88b8-edc5cdd275cb', 'author', 1), -- The Glass Castle

-- Isabel Wilkerson books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('cf36f9f8-4b5f-4fd7-b9d1-d123775314be', '170e6d89-baee-4329-92af-85cacabe0a4d', 'author', 1), -- Trust

-- Chimamanda Ngozi Adichie books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('3c2de1cd-3496-4c54-af75-df4d7b1941f2', '54b02540-5335-4e47-90ec-aca222c4101f', 'author', 1), -- Americanah

-- Claire Keegan books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('513fec1f-be49-4ef8-b19e-2202056073a0', '01c222e9-30b4-452b-8a3b-93f767adc435', 'author', 1), -- Small Things Like These

-- Eleanor Catton books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('38b4f1ff-9177-437d-a124-c8514bfd1adf', '26d03d34-5818-4505-844b-051539c02846', 'author', 1), -- Birnam Wood

-- Prince Harry books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('0b32f06d-5edf-4077-8d6e-ff38e207961a', '3676c074-ed82-4f21-9d33-0f2cba18bcaf', 'author', 1), -- Spare

-- Samantha Shannon books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('a74cdf3d-a11b-4f17-a7c5-0b3923aa4bba', '87a56a01-1d3a-47b8-8924-733ed98d07ed', 'author', 1), -- The Priory of the Orange Tree
('3647650f-080a-4e5e-9f10-d73c87df3a46', '87a56a01-1d3a-47b8-8924-733ed98d07ed', 'author', 1), -- A Day of Fallen Night

-- Olivie Blake books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('c648e155-66b6-48dd-8374-9a8b5832df45', '5fb74407-00e4-4460-bcde-bc80b5b1c901', 'author', 1), -- The Atlas Six
('fdc843e7-3df6-417b-8bb6-ca1c80b401db', '5fb74407-00e4-4460-bcde-bc80b5b1c901', 'author', 1), -- The Atlas Six: Illustrated Edition

-- Chelsea Abdullah books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('4310d0ed-3d59-4085-b4f1-0e7ffb31874f', '07d3bd37-5dfb-49aa-b1b6-275bc496228c', 'author', 1), -- The Stardust Thief

-- Renée Ahdieh books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('af9d51dd-fe4e-479e-af77-854242f1ffff', '05b65e68-a4cd-4332-8559-bd62a902834c', 'author', 1), -- The Wrath and the Dawn
('8b2a2fa1-f832-429b-a4d8-27db06cc0fdc', '05b65e68-a4cd-4332-8559-bd62a902834c', 'author', 1), -- The Rose and the Dagger

-- Shelby Mahurin books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('665fe5b6-a36b-4104-883f-4400203a8976', '7062834b-04c6-4d68-8249-79fa4e55d09e', 'author', 1), -- Serpent & Dove

-- Tricia Levenseller books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('f42ea33a-0edc-4697-b154-7cee4faf6919', '80d422a6-b863-4352-a50c-03038ec1b111', 'author', 1), -- The Shadows Between Us

-- Carissa Broadbent books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('96166a20-0c85-469a-961d-8e876f98d00b', 'e788155c-1c5e-461a-9d43-149e4f34dc3b', 'author', 1), -- The Serpent and the Wings of Night
('ed315038-fb94-4c41-9759-667b65c7c540', 'e788155c-1c5e-461a-9d43-149e4f34dc3b', 'author', 1), -- The Ashes and the Star-Cursed King

-- Shelley Parker-Chan books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('fc7b50ee-89c4-4622-8ac4-4e9fceaa97c8', '57cc026e-7d24-4a02-9202-8c42a267a6d8', 'author', 1), -- She Who Became the Sun
('da42a843-33f4-4018-96e7-8982ed95baa0', '57cc026e-7d24-4a02-9202-8c42a267a6d8', 'author', 1), -- He Who Drowned the World

-- Xiran Jay Zhao books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('f8c2f2a4-231e-4099-8ac2-5745326eadbd', 'fa5f8166-a07f-4703-9515-5f3e8d750856', 'author', 1), -- Iron Widow

-- C.L. Polk books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('f21d8987-d8bf-489e-a068-6369266d3fd0', '6b3522e3-f2bc-4adb-a07f-ff5d39187124', 'author', 1), -- The Warmth of Paperback Suns

-- Sue Lynn Tan books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('08f2c938-7a33-48ea-a611-698f26df1195', '38f6b0c8-db74-46ad-84b8-6ffe1ee0cfb3', 'author', 1), -- The Songbird and the Heart of Stone

-- Scarlett St. Clair books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('a48ccd0f-c3ff-4d5f-a6fe-c10848719ce5', '93e6eba5-46ac-4450-add9-919d14dfca1c', 'author', 1), -- Lightlark
('11c7b598-b577-4e5f-b988-3347839d9a96', '93e6eba5-46ac-4450-add9-919d14dfca1c', 'author', 1), -- Nightbane

-- Tracy Deonn books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('48e6f77d-903d-4b6d-827e-55628c4c03ab', '92d9dd76-2e2a-4116-958f-65d1dc183903', 'author', 1), -- Legendborn
('ac2c31ef-9d50-441a-aa08-cb387199c7ff', '92d9dd76-2e2a-4116-958f-65d1dc183903', 'author', 1), -- Bloodmarked

-- Jenn Lyons books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('7ca6c205-ed24-4aee-a4a1-701d5926e58b', '8043c0fc-0a6e-4a1d-87be-1871c7c6d686', 'author', 1), -- Realm Breaker
('9bed5434-3be9-4a64-b32f-b749ca0cae6a', '8043c0fc-0a6e-4a1d-87be-1871c7c6d686', 'author', 1), -- Blade Breaker
('2d312578-9dbd-450f-a62a-67729f8e74db', '8043c0fc-0a6e-4a1d-87be-1871c7c6d686', 'author', 1), -- Fate Breaker

-- Katee Robert books
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('a77d1c9f-dd91-4a7f-ba0a-d157c1f90f0f', '9706204e-87d1-4ecb-8007-8703fa4a9a80', 'author', 1), -- Before We Were Strangers

-- Jay Ryan books (Empire of the Vampire)
INSERT INTO book_authors (book_id, author_id, role, order_index) VALUES
('6472804e-f258-4431-842d-6f6e2d5fef32', '1e6f6699-e138-4a81-948a-00489cfbe8f2', 'author', 1);  -- Empire of the Vampire

commit
;

