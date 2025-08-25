--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9 (Debian 16.9-1.pgdg120+1)
-- Dumped by pg_dump version 16.9

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: book_format; Type: TYPE; Schema: public; Owner: sabir
--

CREATE TYPE public.book_format AS ENUM (
    'hardcover',
    'paperback',
    'ebook',
    'audiobook',
    'magazine',
    'journal'
);


ALTER TYPE public.book_format OWNER TO sabir;

--
-- Name: user_role; Type: TYPE; Schema: public; Owner: sabir
--

CREATE TYPE public.user_role AS ENUM (
    'admin',
    'user',
    'moderator'
);


ALTER TYPE public.user_role OWNER TO sabir;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: sabir
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO sabir;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: authors; Type: TABLE; Schema: public; Owner: sabir
--

CREATE TABLE public.authors (
    author_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    first_name character varying(255),
    last_name character varying(255) NOT NULL,
    biography text,
    birth_date date,
    death_date date,
    nationality character varying(100),
    website_url text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.authors OWNER TO sabir;

--
-- Name: book_authors; Type: TABLE; Schema: public; Owner: sabir
--

CREATE TABLE public.book_authors (
    book_id uuid NOT NULL,
    author_id uuid NOT NULL,
    role character varying(50) DEFAULT 'author'::character varying,
    order_index integer DEFAULT 1,
    CONSTRAINT chk_book_authors_order_positive CHECK ((order_index > 0))
);


ALTER TABLE public.book_authors OWNER TO sabir;

--
-- Name: book_categories; Type: TABLE; Schema: public; Owner: sabir
--

CREATE TABLE public.book_categories (
    book_id uuid NOT NULL,
    category_id uuid NOT NULL
);


ALTER TABLE public.book_categories OWNER TO sabir;

--
-- Name: book_genres; Type: TABLE; Schema: public; Owner: sabir
--

CREATE TABLE public.book_genres (
    book_id uuid NOT NULL,
    genre_id uuid NOT NULL
);


ALTER TABLE public.book_genres OWNER TO sabir;

--
-- Name: book_reviews; Type: TABLE; Schema: public; Owner: sabir
--

CREATE TABLE public.book_reviews (
    review_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    book_id uuid NOT NULL,
    user_id uuid NOT NULL,
    rating integer NOT NULL,
    review_text text,
    is_verified boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT chk_book_reviews_rating_range CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.book_reviews OWNER TO sabir;

--
-- Name: book_series; Type: TABLE; Schema: public; Owner: sabir
--

CREATE TABLE public.book_series (
    series_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    series_name character varying(255),
    description text,
    total_books integer,
    is_completed boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.book_series OWNER TO sabir;

--
-- Name: book_series_entries; Type: TABLE; Schema: public; Owner: sabir
--

CREATE TABLE public.book_series_entries (
    book_id uuid NOT NULL,
    series_id uuid NOT NULL,
    volume_number integer,
    volume_title character varying(255)
);


ALTER TABLE public.book_series_entries OWNER TO sabir;

--
-- Name: books; Type: TABLE; Schema: public; Owner: sabir
--

CREATE TABLE public.books (
    book_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    title character varying(500) NOT NULL,
    subtitle character varying(500),
    description text,
    isbn_13 character varying(17),
    isbn_10 character varying(13),
    publication_date date,
    published_year integer,
    page_count integer,
    language character(3),
    cover_image_url text,
    cover_image_small_url text,
    cover_image_medium_url text,
    cover_image_large_url text,
    edition character varying(50),
    book_format public.book_format,
    book_condition character varying(20) DEFAULT 'new'::character varying,
    dimensions character varying(50),
    weight_grams integer,
    for_sale boolean DEFAULT true,
    for_rent boolean DEFAULT false,
    price_sale numeric(10,2) NOT NULL,
    price_rent_daily numeric(8,2),
    price_rent_weekly numeric(8,2),
    price_rent_monthly numeric(8,2),
    stock_quantity integer DEFAULT 0,
    reserved_quantity integer DEFAULT 0,
    is_active boolean DEFAULT true,
    average_rating numeric(3,2),
    total_ratings integer DEFAULT 0,
    total_reviews integer DEFAULT 0,
    publisher_id uuid,
    owner_id uuid,
    primary_category_id uuid,
    slug character varying(255),
    search_keywords text[],
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    created_by uuid,
    last_modified_by uuid,
    deleted_at timestamp without time zone,
    deleted_by uuid,
    CONSTRAINT chk_books_isbn_format CHECK ((((isbn_13 IS NULL) OR (length((isbn_13)::text) = ANY (ARRAY[13, 17]))) AND ((isbn_10 IS NULL) OR (length((isbn_10)::text) = ANY (ARRAY[10, 13]))))),
    CONSTRAINT chk_books_positive_quantities CHECK (((stock_quantity >= 0) AND (reserved_quantity >= 0) AND (total_ratings >= 0) AND (total_reviews >= 0))),
    CONSTRAINT chk_books_rating_range CHECK (((average_rating >= (0)::numeric) AND (average_rating <= (5)::numeric))),
    CONSTRAINT chk_books_rental_pricing CHECK (((for_rent = false) OR ((for_rent = true) AND ((price_rent_daily IS NOT NULL) OR (price_rent_weekly IS NOT NULL) OR (price_rent_monthly IS NOT NULL)))))
);


ALTER TABLE public.books OWNER TO sabir;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: sabir
--

CREATE TABLE public.categories (
    category_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    category_name character varying(255) NOT NULL,
    description text,
    parent_category_id uuid,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.categories OWNER TO sabir;

--
-- Name: genres; Type: TABLE; Schema: public; Owner: sabir
--

CREATE TABLE public.genres (
    genre_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    genre_name character varying(255) NOT NULL,
    description text,
    parent_genre_id uuid,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.genres OWNER TO sabir;

--
-- Name: newsletter_subscribers; Type: TABLE; Schema: public; Owner: sabir
--

CREATE TABLE public.newsletter_subscribers (
    subscriber_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    email character varying(255) NOT NULL,
    is_subscribed boolean DEFAULT true NOT NULL,
    subscribed_at timestamp with time zone DEFAULT now(),
    unsubscribed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_newsletter_email_format CHECK (((email)::text ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text))
);


ALTER TABLE public.newsletter_subscribers OWNER TO sabir;

--
-- Name: publishers; Type: TABLE; Schema: public; Owner: sabir
--

CREATE TABLE public.publishers (
    publisher_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    publisher_name character varying(255) NOT NULL,
    description text,
    founded_year integer,
    country character varying(100),
    website_url text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT check_founded_year_valid CHECK (((founded_year >= 1000) AND ((founded_year)::numeric <= EXTRACT(year FROM now())))),
    CONSTRAINT check_website_url_format CHECK (((website_url IS NULL) OR (website_url ~* '^https?://.*'::text)))
);


ALTER TABLE public.publishers OWNER TO sabir;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: sabir
--

CREATE TABLE public.schema_migrations (
    version character varying(255) NOT NULL,
    applied_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.schema_migrations OWNER TO sabir;

--
-- Name: user_follows_authors; Type: TABLE; Schema: public; Owner: sabir
--

CREATE TABLE public.user_follows_authors (
    user_id uuid NOT NULL,
    author_id uuid NOT NULL,
    followed_at timestamp with time zone DEFAULT now(),
    notifications_enabled boolean DEFAULT true
);


ALTER TABLE public.user_follows_authors OWNER TO sabir;

--
-- Name: user_wishlist; Type: TABLE; Schema: public; Owner: sabir
--

CREATE TABLE public.user_wishlist (
    user_id uuid NOT NULL,
    book_id uuid NOT NULL,
    added_at timestamp with time zone DEFAULT now(),
    notes text
);


ALTER TABLE public.user_wishlist OWNER TO sabir;

--
-- Name: users; Type: TABLE; Schema: public; Owner: sabir
--

CREATE TABLE public.users (
    user_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    username character varying(50),
    email character varying(255) NOT NULL,
    hashed_password character varying(255) NOT NULL,
    profile_image_url text,
    credits integer DEFAULT 0 NOT NULL,
    loyalty_points integer DEFAULT 0 NOT NULL,
    is_verified boolean DEFAULT false NOT NULL,
    role public.user_role DEFAULT 'user'::public.user_role NOT NULL,
    last_login timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT check_credits_non_negative CHECK ((credits >= 0)),
    CONSTRAINT check_loyalty_points_non_negative CHECK ((loyalty_points >= 0))
);


ALTER TABLE public.users OWNER TO sabir;

--
-- Data for Name: authors; Type: TABLE DATA; Schema: public; Owner: sabir
--

COPY public.authors (author_id, first_name, last_name, biography, birth_date, death_date, nationality, website_url, created_at, updated_at) FROM stdin;
45db176a-655e-4a4f-8ba0-abe2c51086ff	Abraham	Verghese	Ethiopian-American physician and author of *Cutting for Stone* and *The Covenant of Water*.	1955-01-01	\N	Ethiopian-American	https://www.abrahamverghese.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
e3bd9bfe-15b5-4561-97ea-2f33c2aea5e6	Alex	Aster	Colombian-American YA author best known for the Lightlark fantasy series.	1990-01-01	\N	American	https://www.alexaster.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
0ec7f124-a7d4-4c2d-b41f-920acbc263fe	Andy	Weir	American author of *The Martian*, a bestselling sci-fi novel.	1972-01-01	\N	American	https://www.andyweir.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
09417e8e-59bc-48e3-ac02-eaf1d84ed526	Anthony	Doerr	American novelist, author of *All the Light We Cannot See*, winner of the Pulitzer Prize.	1973-01-01	\N	American	https://www.anthonydoerr.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
c94e9837-abfc-4f67-b1e7-df795a5995bd	Barbara	Kingsolver	American novelist known for *The Poisonwood Bible* and environmental activism.	1955-01-01	\N	American	https://www.barbarakingsolver.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
ec637566-1ec0-4fc7-b2d4-a469d3687987	Bonnie	Garmus	American author of *Lessons in Chemistry*, blending wit and feminist themes.	1957-01-01	\N	American	https://www.bonniegarmus.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
6b3522e3-f2bc-4adb-a07f-ff5d39187124	C.L.	Polk	Canadian author of queer historical fantasy, including *Witchmark*.	1970-01-01	\N	Canadian	https://www.clpolk.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
e788155c-1c5e-461a-9d43-149e4f34dc3b	Carissa	Broadbent	Canadian-born, U.S.-based fantasy author of *A Night of Blacker Darkness*.	1985-01-01	\N	American	https://www.carissabroadbent.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
a60f3b09-32da-4e7e-8874-88284f0d5bce	Cassandra	Clare	American author of *The Mortal Instruments* urban fantasy series.	1973-01-01	\N	American	https://www.cassandraclare.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
07d3bd37-5dfb-49aa-b1b6-275bc496228c	Chelsea	Abdullah	American-Kuwaiti author of The Stardust Thief, inspired by Arabic folklore.	1989-01-01	\N	American-Kuwaiti	https://www.chelseaabdullah.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
54b02540-5335-4e47-90ec-aca222c4101f	Chimamanda	Ngozi Adichie	Nigerian novelist and essayist, author of *Americanah* and *Half of a Yellow Sun*.	1977-01-01	\N	Nigerian	https://www.chimamanda.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
01c222e9-30b4-452b-8a3b-93f767adc435	Claire	Keegan	Irish short story writer and novelist celebrated for *Foster* and *Small Things Like These*.	1968-01-01	\N	Irish	https://www.clairekeegan.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
b90d80c8-87a3-41d9-90a8-2a3695739733	Colleen	Hoover	American bestselling author of romance and YA novels, including *It Ends With Us*.	1979-01-01	\N	American	https://www.colleenhoover.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
f6c5c7c0-a5c4-4a5f-9c62-f0e246192d08	Colson	Whitehead	American Pulitzer Prize–winning novelist of *The Underground Railroad* and *The Nickel Boys*.	1969-01-01	\N	American	https://www.colsonwhitehead.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
c3fec48c-f89c-4aaa-8054-ac8963ead3ea	Cormac	McCarthy	American author of *The Road* and *No Country for Old Men*, known for his sparse prose.	1933-01-01	\N	American	https://www.cormacmccarthy.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
c3f00a9f-e263-4d49-abc6-a906a9789351	David	Mitchell	British novelist known for *Cloud Atlas* with interlinked narratives.	1969-01-01	\N	British	https://www.davidmitchell.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
34045ca8-33ac-443b-ae1d-7507f6d1ba26	Delia	Owens	American author of the bestselling novel *Where the Crawdads Sing*.	1949-01-01	\N	American	https://www.deliaowens.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
433ae7ba-d698-43d5-9e09-b9f39f9a9101	Donna	Tartt	American novelist, author of *The Goldfinch*, winner of the Pulitzer Prize.	1963-01-01	\N	American	https://www.donnatartt.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
26d03d34-5818-4505-844b-051539c02846	Eleanor	Catton	New Zealand novelist who won the Booker Prize for *The Luminaries*.	1985-01-01	\N	New Zealander	https://www.eleanorcatton.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
35618255-9cbb-4de6-aab1-108c22f13788	Elena	Ferrante	Italian pseudonymous author of the Neapolitan Novels, known for *My Brilliant Friend*.	1943-01-01	\N	Italian	https://www.elenaferrante.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
7e06547b-7695-4709-af95-638dc68f9d24	Emily	A. Duncan	American fantasy author of *Legacy of the Mercenary King*.	1989-01-01	\N	American	https://www.emilyaduncan.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
8426813b-7470-4530-ab3e-fc9306e1a711	Emily	Henry	American romance author of *Beach Read* and *People We Meet on Vacation.*	1989-01-01	\N	American	https://www.emilyhenry.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
e8584e69-3f27-4e34-ae25-fbdcafa9c066	Emily	St. John Mandel	Canadian novelist best known for *Station Eleven*, exploring connection amid collapse.	1979-01-01	\N	Canadian	https://www.emilystjohnmandel.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
c8d84b91-912a-49c9-a071-4482ca2749cd	Erin	Morgenstern	American author of *The Night Circus*, a gothic fantasy novel.	1978-01-01	\N	American	https://www.erinmorgenstern.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
95039e59-600c-4a43-95f0-f2c3391b0c5d	Gabrielle	Zevin	American author of *The Storied Life of A. J. Fikry* blending literary whimsy.	1977-01-01	\N	American	https://www.gabriellezevin.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
49a16f2d-5a37-4201-b147-efd208485a17	George	Saunders	American short-story writer and novelist, winner of the Booker Prize for *Lincoln in the Bardo*.	1958-01-01	\N	American	https://www.georgesaunders.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
83ff1522-7e7e-4e24-8aaa-a19bcc05da3f	Gillian	Flynn	American author of *Gone Girl*, known for dark psychological thrillers.	1971-01-01	\N	American	https://www.gillianflynn.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
3d5f9183-0d9c-43e6-b9a1-beb22be96a6f	Hernan	Diaz	Argentine-American novelist of *Trust* and *In the Distance*.	1973-01-01	\N	Argentine-American	https://www.hernandiaz.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
42071998-4576-4406-9503-a40792c0898b	Hilary	Mantel	British historical novelist, twice Booker Prize winner for the Wolf Hall trilogy.	1952-01-01	\N	British	https://www.hilarymantel.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
77393eef-2212-4730-8bd2-d727a91c1c79	Ian	McEwan	British author of *Atonement* and *Enduring Love*, exploring human psychology.	1948-01-01	\N	British	https://www.ianmcewan.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
170e6d89-baee-4329-92af-85cacabe0a4d	Isabel	Wilkerson	American journalist and historian, author of *The Warmth of Other Suns*.	1961-01-01	\N	American	https://www.isabelwilkerson.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
1e6f6699-e138-4a81-948a-00489cfbe8f2	Jay	Kristoff	Australian author of YA fantasy such as *The Illuminae Files* and *Empire of the Vampire*.	1973-01-01	\N	Australian	https://www.jaykristoff.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
322ef68b-bb33-4e87-88b8-edc5cdd275cb	Jeannette	Walls	American journalist and memoirist, author of *The Glass Castle*.	1960-01-01	\N	American	https://www.jeannettewalls.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
8043c0fc-0a6e-4a1d-87be-1871c7c6d686	Jenn	Lyons	American fantasy author of the *A Chorus of Dragons* series.	1970-01-01	\N	American	https://www.jennlyons.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
9706204e-87d1-4ecb-8007-8703fa4a9a80	Katee	Robert	American romance author known for paranormal and fantasy tropes.	1985-01-01	\N	American	https://www.kateerobert.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
ca39a5ae-48bb-4fe4-b194-1a19f998f137	Kazuo	Ishiguro	British author and Nobel laureate, known for *The Remains of the Day*.	1954-01-01	\N	British	https://www.kazuoishiguro.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
7db2366f-2a00-4a4c-9719-e675b0a5a3ab	Leigh	Bardugo	American fantasy author of the Grishaverse series (e.g., *Shadow and Bone*).	1975-01-01	\N	American	https://www.leighbardugo.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
b3e27f3b-cd52-4178-8816-3e120f69cd90	Madeline	Miller	American classicist and author of *Circe* and *The Song of Achilles*.	1978-01-01	\N	American	https://www.madelinemiller.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
021985f1-e62e-4f89-a402-208e7d58ca6e	Margaret	Atwood	Canadian author of *The Handmaid’s Tale*, blending speculative fiction and feminism.	1939-01-01	\N	Canadian	https://www.margaretatwood.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
1d877364-e0b9-4af2-a45e-36c62714e291	Matt	Haig	British author whose *The Midnight Library* explores life choices and regret.	1975-01-01	\N	British	https://www.matthaig.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
5fb74407-00e4-4460-bcde-bc80b5b1c901	Olivie	Blake	American author of dark academia fantasy, including *The Atlas Six*.	1990-01-01	\N	American	https://www.olivieblake.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
3676c074-ed82-4f21-9d33-0f2cba18bcaf	Prince	Harry	British royal and author of memoir *Spare*.	1984-01-01	\N	British	https://www.princeharry.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
d3f177b7-21d9-46d0-b329-d3d25dd92f93	R.F.	Kuang	American speculative author of *The Poppy War* trilogy.	1996-01-01	\N	American	https://www.rfkuang.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
b8cd8769-84b8-44b5-b1a7-6a0a1a0191e1	Rebecca	Yarros	American romance and fantasy author, known for her emotionally charged stories.	1980-01-01	\N	American	https://www.rebeccayarros.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
05b65e68-a4cd-4332-8559-bd62a902834c	Renée	Ahdieh	American author of *The Wrath & the Dawn*, blending Middle Eastern folklore and romance.	1983-01-01	\N	American	https://www.reneeahdieh.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
c6295d16-ce46-4e7e-99ff-64cc37253838	Renée	Carlino	American author of contemporary romance and women’s fiction.	1978-01-01	\N	American	https://www.reneecarlino.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
452dcc27-dc03-43ed-a784-22af4eb9c966	Richard	Powers	American novelist known for *The Overstory*, exploring ecology and humanity.	1957-01-01	\N	American	https://www.richardpowers.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
ea23ab18-c3b4-403d-973a-2c3d55977d0d	Sally	Rooney	Irish author of *Normal People*, exploring modern relationships and class.	1991-01-01	\N	Irish	https://www.sallyrooney.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
87a56a01-1d3a-47b8-8924-733ed98d07ed	Samantha	Shannon	British author of *The Bone Season* and *The Priory of the Orange Tree* fantasies.	1991-01-01	\N	British	https://www.samanthashannon.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
adf12604-1aa7-43c4-b389-4141c4fb3d74	Sarah	J. Maas	American fantasy author of *Throne of Glass* and *A Court of Thorns and Roses*.	1986-01-01	\N	American	https://www.sarahjmaas.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
93e6eba5-46ac-4450-add9-919d14dfca1c	Scarlett	St. Clair	American fantasy author known for the *Queen of Grimm* series.	1988-01-01	\N	American	https://www.scarlettstclair.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
7062834b-04c6-4d68-8249-79fa4e55d09e	Shelby	Mahurin	American YA fantasy author of *Serpent & Dove*.	1994-01-01	\N	American	https://www.shelbymahurin.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
57cc026e-7d24-4a02-9202-8c42a267a6d8	Shelley	Parker-Chan	Australian author of *She Who Became the Sun*, a reimagined historical epic.	1980-01-01	\N	Australian	https://www.shelleyparkerchan.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
104c502e-83e0-4239-83d3-7b7657ec394d	Stephanie	Garber	American author of the Caraval series blending magic and romance.	1985-01-01	\N	American	https://www.stephaniegarber.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
38f6b0c8-db74-46ad-84b8-6ffe1ee0cfb3	Sue	Lynn Tan	Malaysian author of contemporary fantasy celebrating Southeast Asian heritage.	1980-01-01	\N	Malaysian	https://www.suelynntan.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
94ee5313-e9f1-4fd9-9bd8-71b7aa6fb651	Sunyi	Dean	British fantasy author of *The Book Eaters*, mixing magical realism and gothic horror.	1985-01-01	\N	British	https://www.sunyidean.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
818e653a-36fa-4a32-98e1-23980d95005f	Suzanne	Collins	American author of *The Hunger Games* trilogy.	1962-01-01	\N	American	https://www.suzannecollinsbooks.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
381df5a4-a6ed-4285-893f-3eed718280f9	TJ	Klune	American author of LGBTQ+ speculative fiction, including *The House in the Cerulean Sea*.	1982-01-01	\N	American	https://www.tjklune.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
2ec75b29-9589-44c2-b5e8-ee19df6a6e63	Tahereh	Mafi	American author of YA dystopian fiction like *Shatter Me*.	1988-01-01	\N	American	https://www.taherehbooks.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
703625f1-efa5-4f4a-9642-5ebd89e13442	Taylor	Jenkins Reid	American novelist behind *Daisy Jones & The Six* and *The Seven Husbands of Evelyn Hugo*.	1983-01-01	\N	American	https://www.taylorjenkinsreid.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
56361d56-c343-42b0-90fa-611fcc9668bd	Tomi	Adeyemi	Nigerian-American YA author of *Children of Blood and Bone*.	1993-01-01	\N	Nigerian-American	https://www.tomibooks.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
92d9dd76-2e2a-4116-958f-65d1dc183903	Tracy	Deonn	American author of *Legendborn*, a YA magical realism novel rooted in Black Arthurian lore.	1980-01-01	\N	American	https://www.tracydeonn.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
80d422a6-b863-4352-a50c-03038ec1b111	Tricia	Levenseller	American YA fantasy author known for *Daughter of the Siren Queen*.	1990-01-01	\N	American	https://www.tricialevenseller.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
88d9f223-6fc6-4fbc-a60f-bb721a8f8f3d	V.E.	Schwab	American fantasy author of *Vicious* and *The Invisible Life of Addie LaRue*.	1987-01-01	\N	American	https://www.veschwab.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
d522af42-4c69-4ff1-9127-c35e97912f41	Veronica	Roth	American author of the *Divergent* trilogy.	1988-01-01	\N	American	https://www.veronicarothbooks.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
7a4fa824-da78-4736-acda-b792aa2e64a6	Victoria	Aveyard	American YA author of *Red Queen*, blending fantasy and dystopia.	1990-01-01	\N	American	https://www.victoriaaveyard.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
fa5f8166-a07f-4703-9515-5f3e8d750856	Xiran	Jay Zhao	Canadian author of *Iron Widow*, reimagining ancient Chinese history with sci-fi elements.	1990-01-01	\N	Canadian	https://www.xiranjayzhao.com	2025-08-13 20:35:19.072893+00	2025-08-13 20:35:19.072893+00
58703afb-c6fb-4aae-a7d4-7c35e50fd3a4	Amie	Kaufman	Amie Kaufman is an Australian co-author of science-fiction and fantasy with Jay Kristoff.	1985-01-01	\N	Australian	https://www.amiekaufmanjaykristoff.com	2025-08-13 20:35:19.072893+00	2025-08-22 23:10:50.218589+00
\.


--
-- Data for Name: book_authors; Type: TABLE DATA; Schema: public; Owner: sabir
--

COPY public.book_authors (book_id, author_id, role, order_index) FROM stdin;
bf42b2ff-49f8-4ee4-9170-c54e0c427c08	adf12604-1aa7-43c4-b389-4141c4fb3d74	author	1
94578ec4-205d-4644-aa91-7647bc2d9900	adf12604-1aa7-43c4-b389-4141c4fb3d74	author	1
3b67e257-fcbb-4de4-8149-5ce9960f77b9	adf12604-1aa7-43c4-b389-4141c4fb3d74	author	1
b93913d0-c4af-46ca-a602-a31b06c816ec	adf12604-1aa7-43c4-b389-4141c4fb3d74	author	1
6ad0bc0d-310a-4cfb-bc16-5d6106f5d530	adf12604-1aa7-43c4-b389-4141c4fb3d74	author	1
c3a219ff-bce7-4c1f-a075-bac2b1d3c1bd	adf12604-1aa7-43c4-b389-4141c4fb3d74	author	1
c2aa178c-b58b-4b7d-a093-af38aeea0a67	adf12604-1aa7-43c4-b389-4141c4fb3d74	author	1
222edd9c-bbe5-4f22-b380-e3c23e92a970	adf12604-1aa7-43c4-b389-4141c4fb3d74	author	1
747d5df7-daf5-47ea-9ebe-e707e21d7fd8	adf12604-1aa7-43c4-b389-4141c4fb3d74	author	1
ee722a96-7146-40b7-acec-349d304ab002	adf12604-1aa7-43c4-b389-4141c4fb3d74	author	1
d2c936f3-18c9-416d-a11b-bae4199cb449	adf12604-1aa7-43c4-b389-4141c4fb3d74	author	1
b7bdb37a-2202-4c17-a0c8-dcf47f0ae88a	adf12604-1aa7-43c4-b389-4141c4fb3d74	author	1
fef9641f-1ed0-48c7-9d84-72a0e5618bef	adf12604-1aa7-43c4-b389-4141c4fb3d74	author	1
e9cb7006-e285-4530-9643-0a0a959305a0	adf12604-1aa7-43c4-b389-4141c4fb3d74	author	1
67c27067-9f20-4770-991a-29426cc34ec3	adf12604-1aa7-43c4-b389-4141c4fb3d74	author	1
221e8d86-6295-4e54-826a-530f2db1c035	7db2366f-2a00-4a4c-9719-e675b0a5a3ab	author	1
49640ebf-be54-4bf8-98c7-139c8fc728c3	7db2366f-2a00-4a4c-9719-e675b0a5a3ab	author	1
d6aeba5f-5d8a-4b67-a1df-f38f28b38d41	7db2366f-2a00-4a4c-9719-e675b0a5a3ab	author	1
af5fa9fa-03c7-4640-8c1a-3172f22ba55f	7db2366f-2a00-4a4c-9719-e675b0a5a3ab	author	1
1a14d2ed-b677-42eb-bc3e-6a78ddb1f7a8	7db2366f-2a00-4a4c-9719-e675b0a5a3ab	author	1
71a1edd8-e536-4415-9daf-1ec428ee9b73	7db2366f-2a00-4a4c-9719-e675b0a5a3ab	author	1
8c1b857f-852f-4bb9-bcca-3761a46d8a78	7db2366f-2a00-4a4c-9719-e675b0a5a3ab	author	1
16c51354-2fda-48fe-85f7-0ae0e1ac75ec	b8cd8769-84b8-44b5-b1a7-6a0a1a0191e1	author	1
562d34dc-09e9-4aab-859f-5a486394ff9f	b8cd8769-84b8-44b5-b1a7-6a0a1a0191e1	author	1
a91c59b3-eb49-462f-b6a3-3a8dcc723ec5	a60f3b09-32da-4e7e-8874-88284f0d5bce	author	1
76999973-8825-4e01-9101-70714a9486e5	a60f3b09-32da-4e7e-8874-88284f0d5bce	author	1
cfdf78b2-c54b-4f90-98c6-684321fbe3a1	a60f3b09-32da-4e7e-8874-88284f0d5bce	author	1
f58abff5-0d08-412c-96bf-244e15f8aee6	a60f3b09-32da-4e7e-8874-88284f0d5bce	author	1
9c14aa8a-70ea-4be8-a8ac-e1ee8ed4f755	a60f3b09-32da-4e7e-8874-88284f0d5bce	author	1
d84bc7b3-d136-4c66-a9a3-276c53978196	a60f3b09-32da-4e7e-8874-88284f0d5bce	author	1
d9a43bea-6187-46e9-93dd-aac0175a1708	a60f3b09-32da-4e7e-8874-88284f0d5bce	author	1
8dadf3d7-623a-4b37-abad-5cbdfb76890f	a60f3b09-32da-4e7e-8874-88284f0d5bce	author	1
ffc16873-1f35-45d9-a6f2-93ae90d2b387	a60f3b09-32da-4e7e-8874-88284f0d5bce	author	1
370bb1f1-7eda-4828-93e5-88cace76098d	a60f3b09-32da-4e7e-8874-88284f0d5bce	author	1
ae02e3da-e96e-4f34-8c45-33fe6327412c	a60f3b09-32da-4e7e-8874-88284f0d5bce	author	1
33c71273-b4ee-45fc-ae72-79048c9792b2	a60f3b09-32da-4e7e-8874-88284f0d5bce	author	1
8d014e8c-c611-4440-9fd1-155064e07a27	a60f3b09-32da-4e7e-8874-88284f0d5bce	author	1
d669ef37-51a5-42ba-89c1-a3d8db0f300a	818e653a-36fa-4a32-98e1-23980d95005f	author	1
d7b46e40-8242-4f70-8996-6ba5d29bb64a	818e653a-36fa-4a32-98e1-23980d95005f	author	1
fcf19eb6-74e4-482b-862a-f3c20f0a57a2	818e653a-36fa-4a32-98e1-23980d95005f	author	1
c54e0224-118c-43c2-857e-22e74330e174	818e653a-36fa-4a32-98e1-23980d95005f	author	1
3f197abc-a693-49d5-b0bb-406edd54c693	d522af42-4c69-4ff1-9127-c35e97912f41	author	1
c64f7799-493f-4135-abd0-e12310577760	d522af42-4c69-4ff1-9127-c35e97912f41	author	1
086a303e-3247-4a0b-8994-54ff7e666480	d522af42-4c69-4ff1-9127-c35e97912f41	author	1
1b8c2b12-c017-4804-8df8-9b5e45c3f87f	7a4fa824-da78-4736-acda-b792aa2e64a6	author	1
79972b3e-04c5-43df-a4d0-2046ef79d6be	7a4fa824-da78-4736-acda-b792aa2e64a6	author	1
908ccf06-f3a9-4ee3-89b8-c1bfab8a07db	7a4fa824-da78-4736-acda-b792aa2e64a6	author	1
d1e5b180-2da0-463f-9bfa-8170b15bcfe3	7a4fa824-da78-4736-acda-b792aa2e64a6	author	1
d8e0d3f2-d01a-4d53-80f8-7d97e61c8eba	2ec75b29-9589-44c2-b5e8-ee19df6a6e63	author	1
9bfa6939-ff65-4a89-b02b-cab365544ec4	2ec75b29-9589-44c2-b5e8-ee19df6a6e63	author	1
c3722913-0cd4-4cfb-9544-15c9b70d1f8c	2ec75b29-9589-44c2-b5e8-ee19df6a6e63	author	1
3e48080f-456f-4dd4-8ed3-996c4c5d1db9	2ec75b29-9589-44c2-b5e8-ee19df6a6e63	author	1
ba70c5e9-a793-4384-992c-047ea44b45c6	2ec75b29-9589-44c2-b5e8-ee19df6a6e63	author	1
a30177e0-30cd-4d73-8c78-0db194465e33	88d9f223-6fc6-4fbc-a60f-bb721a8f8f3d	author	1
c8950321-9395-44ce-828c-78a732f91b37	88d9f223-6fc6-4fbc-a60f-bb721a8f8f3d	author	1
31e6de7e-1e85-4565-87f1-140d98670c23	88d9f223-6fc6-4fbc-a60f-bb721a8f8f3d	author	1
ecec3822-2abb-4fe8-8a35-8f75cb5b5d00	88d9f223-6fc6-4fbc-a60f-bb721a8f8f3d	author	1
9fc934b4-373c-4e47-8e87-6bfac305f403	88d9f223-6fc6-4fbc-a60f-bb721a8f8f3d	author	1
d3ea78cd-2f26-4667-8a48-35a045d4e58d	104c502e-83e0-4239-83d3-7b7657ec394d	author	1
ecb5cef2-e4e8-4393-b167-d677b47f3546	104c502e-83e0-4239-83d3-7b7657ec394d	author	1
65856882-88f7-4c34-983a-a66466cbbb4e	104c502e-83e0-4239-83d3-7b7657ec394d	author	1
8dd1495b-7b0a-41d1-97f6-77f99adbedd9	104c502e-83e0-4239-83d3-7b7657ec394d	author	1
921783dc-7146-457f-b481-e0a921d0c584	d3f177b7-21d9-46d0-b329-d3d25dd92f93	author	1
333b9948-8b96-4be6-ac07-a03e5db15c92	d3f177b7-21d9-46d0-b329-d3d25dd92f93	author	1
6e013b45-a52d-46c5-b45f-542274582583	d3f177b7-21d9-46d0-b329-d3d25dd92f93	author	1
490214ac-1b2d-4e5b-97cd-e27514faed75	d3f177b7-21d9-46d0-b329-d3d25dd92f93	author	1
b865cf43-8be2-42cd-9678-11d561cb94a4	d3f177b7-21d9-46d0-b329-d3d25dd92f93	author	1
ffeba2da-9089-4354-9d48-a8a1bca080c2	56361d56-c343-42b0-90fa-611fcc9668bd	author	1
23c78129-82ff-48fd-8dd1-3772f1afff51	56361d56-c343-42b0-90fa-611fcc9668bd	author	1
ccecba4e-19f2-4977-a7f5-a64ba54c2de8	1e6f6699-e138-4a81-948a-00489cfbe8f2	author	1
22e73320-3645-47b6-a9b5-0be5be8f05ad	1e6f6699-e138-4a81-948a-00489cfbe8f2	author	1
7d447336-8fd1-4881-a2d9-d63b6c24d1ae	1e6f6699-e138-4a81-948a-00489cfbe8f2	author	1
1ff0995a-4cd4-4ff4-bfbd-7bae9e760726	58703afb-c6fb-4aae-a7d4-7c35e50fd3a4	author	1
1ff0995a-4cd4-4ff4-bfbd-7bae9e760726	1e6f6699-e138-4a81-948a-00489cfbe8f2	co-author	2
ec828ace-a3e6-4625-9a16-31f19d1b57e2	58703afb-c6fb-4aae-a7d4-7c35e50fd3a4	author	1
ec828ace-a3e6-4625-9a16-31f19d1b57e2	1e6f6699-e138-4a81-948a-00489cfbe8f2	co-author	2
198517e6-4fd4-4b5b-aec7-ac135b050bd7	58703afb-c6fb-4aae-a7d4-7c35e50fd3a4	author	1
198517e6-4fd4-4b5b-aec7-ac135b050bd7	1e6f6699-e138-4a81-948a-00489cfbe8f2	co-author	2
58c809f0-4d05-4d6a-9255-f00c357a84eb	58703afb-c6fb-4aae-a7d4-7c35e50fd3a4	author	1
58c809f0-4d05-4d6a-9255-f00c357a84eb	1e6f6699-e138-4a81-948a-00489cfbe8f2	co-author	2
caca1abb-0677-4801-9586-f8732d8937df	58703afb-c6fb-4aae-a7d4-7c35e50fd3a4	author	1
caca1abb-0677-4801-9586-f8732d8937df	1e6f6699-e138-4a81-948a-00489cfbe8f2	co-author	2
af1155b0-ca5a-4a8a-9091-e6fc4312b3cb	b90d80c8-87a3-41d9-90a8-2a3695739733	author	1
a3fe79d2-2a75-40be-945f-259ae87e26f3	b90d80c8-87a3-41d9-90a8-2a3695739733	author	1
72aac672-fcb5-4f75-8c9f-35b54c08b431	b90d80c8-87a3-41d9-90a8-2a3695739733	author	1
31c6baac-7966-4ff0-b0dd-912889ef431f	b90d80c8-87a3-41d9-90a8-2a3695739733	author	1
da9871b3-97d4-4bca-9f21-be4755a67c78	8426813b-7470-4530-ab3e-fc9306e1a711	author	1
81e40d49-4bf3-46d7-a16e-0d27f04aeeed	8426813b-7470-4530-ab3e-fc9306e1a711	author	1
d251529b-44c7-4628-ae32-1b54f4efcc03	703625f1-efa5-4f4a-9642-5ebd89e13442	author	1
edf616f5-cdc1-4074-b31c-adad5922351a	703625f1-efa5-4f4a-9642-5ebd89e13442	author	1
e1979d34-ff10-4f48-9ecc-c4d8fe3dc1d7	0ec7f124-a7d4-4c2d-b41f-920acbc263fe	author	1
9a6b9e7c-7cac-4c32-b420-c71b3dfbdcfb	381df5a4-a6ed-4285-893f-3eed718280f9	author	1
d9d7198c-9c55-46db-9cd0-d24b7efecf88	381df5a4-a6ed-4285-893f-3eed718280f9	author	1
775ee6ae-7471-4efa-a431-321fe0d8bb1f	1d877364-e0b9-4af2-a45e-36c62714e291	author	1
0009d0a3-d932-417c-8e05-560e54b6505a	95039e59-600c-4a43-95f0-f2c3391b0c5d	author	1
b490dbfa-1183-476d-8cff-23239c89ee4b	95039e59-600c-4a43-95f0-f2c3391b0c5d	author	1
061cc62d-4530-42d2-855d-365359e7b206	b3e27f3b-cd52-4178-8816-3e120f69cd90	author	1
6d1dd482-cd9d-456b-8de0-1b032e9e0df6	b3e27f3b-cd52-4178-8816-3e120f69cd90	author	1
6d1dd482-cd9d-456b-8de0-1b032e9e0df6	ec637566-1ec0-4fc7-b2d4-a469d3687987	author	1
d3c81bd4-bd29-4236-a0d9-08b45ffacb78	34045ca8-33ac-443b-ae1d-7507f6d1ba26	author	1
0c046c96-9c1b-44cd-bf7a-ea9d1f87fea6	c94e9837-abfc-4f67-b1e7-df795a5995bd	author	1
978985ec-1759-46ee-bb14-531c9bfcc3c7	09417e8e-59bc-48e3-ac02-eaf1d84ed526	author	1
4f82177e-15ce-4c56-9fbf-796d7ea2804c	45db176a-655e-4a4f-8ba0-abe2c51086ff	author	1
f3545f5d-3fc7-4be1-91e4-4d2b86150cbe	ca39a5ae-48bb-4fe4-b194-1a19f998f137	author	1
cb7028c5-583d-4505-870c-8918923e3468	ca39a5ae-48bb-4fe4-b194-1a19f998f137	author	1
7302da6b-0859-48c8-a743-8ffc73bd6ed5	ea23ab18-c3b4-403d-973a-2c3d55977d0d	author	1
8285b0f2-c2f1-4ff3-a74e-030e4cb47ffa	35618255-9cbb-4de6-aab1-108c22f13788	author	1
290f8912-5cf8-4771-a6f3-ec9da866d3e7	021985f1-e62e-4f89-a402-208e7d58ca6e	author	1
913767b4-f2bc-4711-a058-23a1dc92d6a3	83ff1522-7e7e-4e24-8aaa-a19bcc05da3f	author	1
05cb7ddc-fbd5-4899-a854-dbf06ee86046	433ae7ba-d698-43d5-9e09-b9f39f9a9101	author	1
eb9910da-1c69-4ef0-8e0e-5840ca04a380	49a16f2d-5a37-4201-b147-efd208485a17	author	1
1a28b1f2-7ec2-4664-82d3-3c69acd79969	c3fec48c-f89c-4aaa-8054-ac8963ead3ea	author	1
ce398622-71f1-46f4-afcc-53ae0361f631	f6c5c7c0-a5c4-4a5f-9c62-f0e246192d08	author	1
530800c6-b78d-4c1d-9367-7a1732ede5dc	77393eef-2212-4730-8bd2-d727a91c1c79	author	1
f37905f0-a109-4420-ab95-96e97a7d31b2	42071998-4576-4406-9503-a40792c0898b	author	1
56be8083-b5b0-4618-8d39-524ca8def7da	452dcc27-dc03-43ed-a784-22af4eb9c966	author	1
ac2c6867-0a1e-4e01-8016-b09183e01db9	e8584e69-3f27-4e34-ae25-fbdcafa9c066	author	1
fd1fe11b-e778-4802-aa00-416ac51e5f33	c8d84b91-912a-49c9-a071-4482ca2749cd	author	1
78529251-fc7e-40c4-b94f-1fe2fc676f4b	c8d84b91-912a-49c9-a071-4482ca2749cd	author	1
bb23edc9-91fb-41b1-9c1a-cffaeb05d01e	322ef68b-bb33-4e87-88b8-edc5cdd275cb	author	1
cf36f9f8-4b5f-4fd7-b9d1-d123775314be	170e6d89-baee-4329-92af-85cacabe0a4d	author	1
3c2de1cd-3496-4c54-af75-df4d7b1941f2	54b02540-5335-4e47-90ec-aca222c4101f	author	1
513fec1f-be49-4ef8-b19e-2202056073a0	01c222e9-30b4-452b-8a3b-93f767adc435	author	1
38b4f1ff-9177-437d-a124-c8514bfd1adf	26d03d34-5818-4505-844b-051539c02846	author	1
0b32f06d-5edf-4077-8d6e-ff38e207961a	3676c074-ed82-4f21-9d33-0f2cba18bcaf	author	1
a74cdf3d-a11b-4f17-a7c5-0b3923aa4bba	87a56a01-1d3a-47b8-8924-733ed98d07ed	author	1
3647650f-080a-4e5e-9f10-d73c87df3a46	87a56a01-1d3a-47b8-8924-733ed98d07ed	author	1
c648e155-66b6-48dd-8374-9a8b5832df45	5fb74407-00e4-4460-bcde-bc80b5b1c901	author	1
fdc843e7-3df6-417b-8bb6-ca1c80b401db	5fb74407-00e4-4460-bcde-bc80b5b1c901	author	1
4310d0ed-3d59-4085-b4f1-0e7ffb31874f	07d3bd37-5dfb-49aa-b1b6-275bc496228c	author	1
af9d51dd-fe4e-479e-af77-854242f1ffff	05b65e68-a4cd-4332-8559-bd62a902834c	author	1
8b2a2fa1-f832-429b-a4d8-27db06cc0fdc	05b65e68-a4cd-4332-8559-bd62a902834c	author	1
665fe5b6-a36b-4104-883f-4400203a8976	7062834b-04c6-4d68-8249-79fa4e55d09e	author	1
f42ea33a-0edc-4697-b154-7cee4faf6919	80d422a6-b863-4352-a50c-03038ec1b111	author	1
96166a20-0c85-469a-961d-8e876f98d00b	e788155c-1c5e-461a-9d43-149e4f34dc3b	author	1
ed315038-fb94-4c41-9759-667b65c7c540	e788155c-1c5e-461a-9d43-149e4f34dc3b	author	1
fc7b50ee-89c4-4622-8ac4-4e9fceaa97c8	57cc026e-7d24-4a02-9202-8c42a267a6d8	author	1
da42a843-33f4-4018-96e7-8982ed95baa0	57cc026e-7d24-4a02-9202-8c42a267a6d8	author	1
f8c2f2a4-231e-4099-8ac2-5745326eadbd	fa5f8166-a07f-4703-9515-5f3e8d750856	author	1
f21d8987-d8bf-489e-a068-6369266d3fd0	6b3522e3-f2bc-4adb-a07f-ff5d39187124	author	1
08f2c938-7a33-48ea-a611-698f26df1195	38f6b0c8-db74-46ad-84b8-6ffe1ee0cfb3	author	1
a48ccd0f-c3ff-4d5f-a6fe-c10848719ce5	93e6eba5-46ac-4450-add9-919d14dfca1c	author	1
11c7b598-b577-4e5f-b988-3347839d9a96	93e6eba5-46ac-4450-add9-919d14dfca1c	author	1
48e6f77d-903d-4b6d-827e-55628c4c03ab	92d9dd76-2e2a-4116-958f-65d1dc183903	author	1
ac2c31ef-9d50-441a-aa08-cb387199c7ff	92d9dd76-2e2a-4116-958f-65d1dc183903	author	1
7ca6c205-ed24-4aee-a4a1-701d5926e58b	8043c0fc-0a6e-4a1d-87be-1871c7c6d686	author	1
9bed5434-3be9-4a64-b32f-b749ca0cae6a	8043c0fc-0a6e-4a1d-87be-1871c7c6d686	author	1
2d312578-9dbd-450f-a62a-67729f8e74db	8043c0fc-0a6e-4a1d-87be-1871c7c6d686	author	1
a77d1c9f-dd91-4a7f-ba0a-d157c1f90f0f	9706204e-87d1-4ecb-8007-8703fa4a9a80	author	1
6472804e-f258-4431-842d-6f6e2d5fef32	1e6f6699-e138-4a81-948a-00489cfbe8f2	author	1
\.


--
-- Data for Name: book_categories; Type: TABLE DATA; Schema: public; Owner: sabir
--

COPY public.book_categories (book_id, category_id) FROM stdin;
c8950321-9395-44ce-828c-78a732f91b37	9afa3511-0ba6-4c66-b2f2-169c6815d139
c8950321-9395-44ce-828c-78a732f91b37	84484d09-8b66-4ea7-9edc-106fd13ffd73
3b67e257-fcbb-4de4-8149-5ce9960f77b9	43f85820-0294-49e4-953c-ea119f2eb8f9
3b67e257-fcbb-4de4-8149-5ce9960f77b9	84484d09-8b66-4ea7-9edc-106fd13ffd73
3b67e257-fcbb-4de4-8149-5ce9960f77b9	7c78a105-695c-4a82-b99a-b4d0fdcb1915
6ad0bc0d-310a-4cfb-bc16-5d6106f5d530	43f85820-0294-49e4-953c-ea119f2eb8f9
6ad0bc0d-310a-4cfb-bc16-5d6106f5d530	84484d09-8b66-4ea7-9edc-106fd13ffd73
6ad0bc0d-310a-4cfb-bc16-5d6106f5d530	7c78a105-695c-4a82-b99a-b4d0fdcb1915
94578ec4-205d-4644-aa91-7647bc2d9900	43f85820-0294-49e4-953c-ea119f2eb8f9
94578ec4-205d-4644-aa91-7647bc2d9900	84484d09-8b66-4ea7-9edc-106fd13ffd73
94578ec4-205d-4644-aa91-7647bc2d9900	7c78a105-695c-4a82-b99a-b4d0fdcb1915
e9cb7006-e285-4530-9643-0a0a959305a0	9afa3511-0ba6-4c66-b2f2-169c6815d139
e9cb7006-e285-4530-9643-0a0a959305a0	84484d09-8b66-4ea7-9edc-106fd13ffd73
c3722913-0cd4-4cfb-9544-15c9b70d1f8c	6a151e20-73d9-45e0-94bf-be7a0f73f4cf
c3722913-0cd4-4cfb-9544-15c9b70d1f8c	9afa3511-0ba6-4c66-b2f2-169c6815d139
c3722913-0cd4-4cfb-9544-15c9b70d1f8c	43f85820-0294-49e4-953c-ea119f2eb8f9
58c809f0-4d05-4d6a-9255-f00c357a84eb	17739b35-27cb-41af-bb8d-d996f3519ee7
58c809f0-4d05-4d6a-9255-f00c357a84eb	9afa3511-0ba6-4c66-b2f2-169c6815d139
ba70c5e9-a793-4384-992c-047ea44b45c6	9afa3511-0ba6-4c66-b2f2-169c6815d139
ba70c5e9-a793-4384-992c-047ea44b45c6	84484d09-8b66-4ea7-9edc-106fd13ffd73
ba70c5e9-a793-4384-992c-047ea44b45c6	17739b35-27cb-41af-bb8d-d996f3519ee7
3f197abc-a693-49d5-b0bb-406edd54c693	17739b35-27cb-41af-bb8d-d996f3519ee7
3f197abc-a693-49d5-b0bb-406edd54c693	9afa3511-0ba6-4c66-b2f2-169c6815d139
b93913d0-c4af-46ca-a602-a31b06c816ec	43f85820-0294-49e4-953c-ea119f2eb8f9
b93913d0-c4af-46ca-a602-a31b06c816ec	84484d09-8b66-4ea7-9edc-106fd13ffd73
b93913d0-c4af-46ca-a602-a31b06c816ec	7c78a105-695c-4a82-b99a-b4d0fdcb1915
3647650f-080a-4e5e-9f10-d73c87df3a46	9afa3511-0ba6-4c66-b2f2-169c6815d139
3647650f-080a-4e5e-9f10-d73c87df3a46	84484d09-8b66-4ea7-9edc-106fd13ffd73
a30177e0-30cd-4d73-8c78-0db194465e33	43f85820-0294-49e4-953c-ea119f2eb8f9
a30177e0-30cd-4d73-8c78-0db194465e33	84484d09-8b66-4ea7-9edc-106fd13ffd73
a30177e0-30cd-4d73-8c78-0db194465e33	7c78a105-695c-4a82-b99a-b4d0fdcb1915
978985ec-1759-46ee-bb14-531c9bfcc3c7	9afa3511-0ba6-4c66-b2f2-169c6815d139
978985ec-1759-46ee-bb14-531c9bfcc3c7	84484d09-8b66-4ea7-9edc-106fd13ffd73
c64f7799-493f-4135-abd0-e12310577760	17739b35-27cb-41af-bb8d-d996f3519ee7
c64f7799-493f-4135-abd0-e12310577760	9afa3511-0ba6-4c66-b2f2-169c6815d139
3c2de1cd-3496-4c54-af75-df4d7b1941f2	9afa3511-0ba6-4c66-b2f2-169c6815d139
3c2de1cd-3496-4c54-af75-df4d7b1941f2	84484d09-8b66-4ea7-9edc-106fd13ffd73
ec828ace-a3e6-4625-9a16-31f19d1b57e2	9afa3511-0ba6-4c66-b2f2-169c6815d139
ec828ace-a3e6-4625-9a16-31f19d1b57e2	84484d09-8b66-4ea7-9edc-106fd13ffd73
1ff0995a-4cd4-4ff4-bfbd-7bae9e760726	9afa3511-0ba6-4c66-b2f2-169c6815d139
1ff0995a-4cd4-4ff4-bfbd-7bae9e760726	84484d09-8b66-4ea7-9edc-106fd13ffd73
198517e6-4fd4-4b5b-aec7-ac135b050bd7	9afa3511-0ba6-4c66-b2f2-169c6815d139
198517e6-4fd4-4b5b-aec7-ac135b050bd7	84484d09-8b66-4ea7-9edc-106fd13ffd73
490214ac-1b2d-4e5b-97cd-e27514faed75	9afa3511-0ba6-4c66-b2f2-169c6815d139
490214ac-1b2d-4e5b-97cd-e27514faed75	84484d09-8b66-4ea7-9edc-106fd13ffd73
a77d1c9f-dd91-4a7f-ba0a-d157c1f90f0f	9afa3511-0ba6-4c66-b2f2-169c6815d139
a77d1c9f-dd91-4a7f-ba0a-d157c1f90f0f	84484d09-8b66-4ea7-9edc-106fd13ffd73
38b4f1ff-9177-437d-a124-c8514bfd1adf	9afa3511-0ba6-4c66-b2f2-169c6815d139
38b4f1ff-9177-437d-a124-c8514bfd1adf	84484d09-8b66-4ea7-9edc-106fd13ffd73
9bed5434-3be9-4a64-b32f-b749ca0cae6a	43f85820-0294-49e4-953c-ea119f2eb8f9
9bed5434-3be9-4a64-b32f-b749ca0cae6a	84484d09-8b66-4ea7-9edc-106fd13ffd73
9bed5434-3be9-4a64-b32f-b749ca0cae6a	7c78a105-695c-4a82-b99a-b4d0fdcb1915
ac2c31ef-9d50-441a-aa08-cb387199c7ff	6a151e20-73d9-45e0-94bf-be7a0f73f4cf
ac2c31ef-9d50-441a-aa08-cb387199c7ff	9afa3511-0ba6-4c66-b2f2-169c6815d139
ac2c31ef-9d50-441a-aa08-cb387199c7ff	43f85820-0294-49e4-953c-ea119f2eb8f9
da9871b3-97d4-4bca-9f21-be4755a67c78	84484d09-8b66-4ea7-9edc-106fd13ffd73
da9871b3-97d4-4bca-9f21-be4755a67c78	9afa3511-0ba6-4c66-b2f2-169c6815d139
d3ea78cd-2f26-4667-8a48-35a045d4e58d	9afa3511-0ba6-4c66-b2f2-169c6815d139
d3ea78cd-2f26-4667-8a48-35a045d4e58d	84484d09-8b66-4ea7-9edc-106fd13ffd73
edf616f5-cdc1-4074-b31c-adad5922351a	9afa3511-0ba6-4c66-b2f2-169c6815d139
edf616f5-cdc1-4074-b31c-adad5922351a	84484d09-8b66-4ea7-9edc-106fd13ffd73
d7b46e40-8242-4f70-8996-6ba5d29bb64a	43f85820-0294-49e4-953c-ea119f2eb8f9
d7b46e40-8242-4f70-8996-6ba5d29bb64a	84484d09-8b66-4ea7-9edc-106fd13ffd73
d7b46e40-8242-4f70-8996-6ba5d29bb64a	7c78a105-695c-4a82-b99a-b4d0fdcb1915
33c71273-b4ee-45fc-ae72-79048c9792b2	9afa3511-0ba6-4c66-b2f2-169c6815d139
33c71273-b4ee-45fc-ae72-79048c9792b2	84484d09-8b66-4ea7-9edc-106fd13ffd73
8d014e8c-c611-4440-9fd1-155064e07a27	9afa3511-0ba6-4c66-b2f2-169c6815d139
8d014e8c-c611-4440-9fd1-155064e07a27	84484d09-8b66-4ea7-9edc-106fd13ffd73
ffeba2da-9089-4354-9d48-a8a1bca080c2	6a151e20-73d9-45e0-94bf-be7a0f73f4cf
ffeba2da-9089-4354-9d48-a8a1bca080c2	9afa3511-0ba6-4c66-b2f2-169c6815d139
ffeba2da-9089-4354-9d48-a8a1bca080c2	43f85820-0294-49e4-953c-ea119f2eb8f9
23c78129-82ff-48fd-8dd1-3772f1afff51	7714415f-2a2c-4c93-b573-c8636f2c43f1
23c78129-82ff-48fd-8dd1-3772f1afff51	7d26a24b-ae3b-49bb-9548-1018a5c2fee3
23c78129-82ff-48fd-8dd1-3772f1afff51	9afa3511-0ba6-4c66-b2f2-169c6815d139
6d8c126a-6f52-4063-b46a-e00964dbd1e7	9afa3511-0ba6-4c66-b2f2-169c6815d139
6d8c126a-6f52-4063-b46a-e00964dbd1e7	84484d09-8b66-4ea7-9edc-106fd13ffd73
76999973-8825-4e01-9101-70714a9486e5	17739b35-27cb-41af-bb8d-d996f3519ee7
76999973-8825-4e01-9101-70714a9486e5	9afa3511-0ba6-4c66-b2f2-169c6815d139
a91c59b3-eb49-462f-b6a3-3a8dcc723ec5	6a151e20-73d9-45e0-94bf-be7a0f73f4cf
a91c59b3-eb49-462f-b6a3-3a8dcc723ec5	9afa3511-0ba6-4c66-b2f2-169c6815d139
a91c59b3-eb49-462f-b6a3-3a8dcc723ec5	43f85820-0294-49e4-953c-ea119f2eb8f9
f58abff5-0d08-412c-96bf-244e15f8aee6	6a151e20-73d9-45e0-94bf-be7a0f73f4cf
f58abff5-0d08-412c-96bf-244e15f8aee6	9afa3511-0ba6-4c66-b2f2-169c6815d139
f58abff5-0d08-412c-96bf-244e15f8aee6	43f85820-0294-49e4-953c-ea119f2eb8f9
cfdf78b2-c54b-4f90-98c6-684321fbe3a1	43f85820-0294-49e4-953c-ea119f2eb8f9
cfdf78b2-c54b-4f90-98c6-684321fbe3a1	84484d09-8b66-4ea7-9edc-106fd13ffd73
cfdf78b2-c54b-4f90-98c6-684321fbe3a1	7c78a105-695c-4a82-b99a-b4d0fdcb1915
d84bc7b3-d136-4c66-a9a3-276c53978196	43f85820-0294-49e4-953c-ea119f2eb8f9
d84bc7b3-d136-4c66-a9a3-276c53978196	84484d09-8b66-4ea7-9edc-106fd13ffd73
d84bc7b3-d136-4c66-a9a3-276c53978196	7c78a105-695c-4a82-b99a-b4d0fdcb1915
9c14aa8a-70ea-4be8-a8ac-e1ee8ed4f755	6a151e20-73d9-45e0-94bf-be7a0f73f4cf
9c14aa8a-70ea-4be8-a8ac-e1ee8ed4f755	9afa3511-0ba6-4c66-b2f2-169c6815d139
9c14aa8a-70ea-4be8-a8ac-e1ee8ed4f755	43f85820-0294-49e4-953c-ea119f2eb8f9
d9a43bea-6187-46e9-93dd-aac0175a1708	9afa3511-0ba6-4c66-b2f2-169c6815d139
d9a43bea-6187-46e9-93dd-aac0175a1708	84484d09-8b66-4ea7-9edc-106fd13ffd73
8dadf3d7-623a-4b37-abad-5cbdfb76890f	43f85820-0294-49e4-953c-ea119f2eb8f9
8dadf3d7-623a-4b37-abad-5cbdfb76890f	84484d09-8b66-4ea7-9edc-106fd13ffd73
8dadf3d7-623a-4b37-abad-5cbdfb76890f	7c78a105-695c-4a82-b99a-b4d0fdcb1915
67c27067-9f20-4770-991a-29426cc34ec3	43f85820-0294-49e4-953c-ea119f2eb8f9
67c27067-9f20-4770-991a-29426cc34ec3	84484d09-8b66-4ea7-9edc-106fd13ffd73
67c27067-9f20-4770-991a-29426cc34ec3	7c78a105-695c-4a82-b99a-b4d0fdcb1915
49640ebf-be54-4bf8-98c7-139c8fc728c3	43f85820-0294-49e4-953c-ea119f2eb8f9
49640ebf-be54-4bf8-98c7-139c8fc728c3	84484d09-8b66-4ea7-9edc-106fd13ffd73
49640ebf-be54-4bf8-98c7-139c8fc728c3	7c78a105-695c-4a82-b99a-b4d0fdcb1915
222edd9c-bbe5-4f22-b380-e3c23e92a970	9afa3511-0ba6-4c66-b2f2-169c6815d139
222edd9c-bbe5-4f22-b380-e3c23e92a970	84484d09-8b66-4ea7-9edc-106fd13ffd73
7d447336-8fd1-4881-a2d9-d63b6c24d1ae	6a151e20-73d9-45e0-94bf-be7a0f73f4cf
7d447336-8fd1-4881-a2d9-d63b6c24d1ae	9afa3511-0ba6-4c66-b2f2-169c6815d139
7d447336-8fd1-4881-a2d9-d63b6c24d1ae	43f85820-0294-49e4-953c-ea119f2eb8f9
9bfa6939-ff65-4a89-b02b-cab365544ec4	9afa3511-0ba6-4c66-b2f2-169c6815d139
9bfa6939-ff65-4a89-b02b-cab365544ec4	84484d09-8b66-4ea7-9edc-106fd13ffd73
9bfa6939-ff65-4a89-b02b-cab365544ec4	17739b35-27cb-41af-bb8d-d996f3519ee7
0c046c96-9c1b-44cd-bf7a-ea9d1f87fea6	6a151e20-73d9-45e0-94bf-be7a0f73f4cf
0c046c96-9c1b-44cd-bf7a-ea9d1f87fea6	9afa3511-0ba6-4c66-b2f2-169c6815d139
0c046c96-9c1b-44cd-bf7a-ea9d1f87fea6	43f85820-0294-49e4-953c-ea119f2eb8f9
ee722a96-7146-40b7-acec-349d304ab002	43f85820-0294-49e4-953c-ea119f2eb8f9
ee722a96-7146-40b7-acec-349d304ab002	84484d09-8b66-4ea7-9edc-106fd13ffd73
ee722a96-7146-40b7-acec-349d304ab002	7c78a105-695c-4a82-b99a-b4d0fdcb1915
6472804e-f258-4431-842d-6f6e2d5fef32	43f85820-0294-49e4-953c-ea119f2eb8f9
6472804e-f258-4431-842d-6f6e2d5fef32	84484d09-8b66-4ea7-9edc-106fd13ffd73
6472804e-f258-4431-842d-6f6e2d5fef32	7c78a105-695c-4a82-b99a-b4d0fdcb1915
2d312578-9dbd-450f-a62a-67729f8e74db	9afa3511-0ba6-4c66-b2f2-169c6815d139
2d312578-9dbd-450f-a62a-67729f8e74db	84484d09-8b66-4ea7-9edc-106fd13ffd73
65856882-88f7-4c34-983a-a66466cbbb4e	9afa3511-0ba6-4c66-b2f2-169c6815d139
65856882-88f7-4c34-983a-a66466cbbb4e	84484d09-8b66-4ea7-9edc-106fd13ffd73
086a303e-3247-4a0b-8994-54ff7e666480	17739b35-27cb-41af-bb8d-d996f3519ee7
086a303e-3247-4a0b-8994-54ff7e666480	9afa3511-0ba6-4c66-b2f2-169c6815d139
16c51354-2fda-48fe-85f7-0ae0e1ac75ec	9afa3511-0ba6-4c66-b2f2-169c6815d139
16c51354-2fda-48fe-85f7-0ae0e1ac75ec	84484d09-8b66-4ea7-9edc-106fd13ffd73
79972b3e-04c5-43df-a4d0-2046ef79d6be	43f85820-0294-49e4-953c-ea119f2eb8f9
79972b3e-04c5-43df-a4d0-2046ef79d6be	84484d09-8b66-4ea7-9edc-106fd13ffd73
79972b3e-04c5-43df-a4d0-2046ef79d6be	7c78a105-695c-4a82-b99a-b4d0fdcb1915
22e73320-3645-47b6-a9b5-0be5be8f05ad	6a151e20-73d9-45e0-94bf-be7a0f73f4cf
22e73320-3645-47b6-a9b5-0be5be8f05ad	9afa3511-0ba6-4c66-b2f2-169c6815d139
22e73320-3645-47b6-a9b5-0be5be8f05ad	43f85820-0294-49e4-953c-ea119f2eb8f9
913767b4-f2bc-4711-a058-23a1dc92d6a3	9afa3511-0ba6-4c66-b2f2-169c6815d139
913767b4-f2bc-4711-a058-23a1dc92d6a3	84484d09-8b66-4ea7-9edc-106fd13ffd73
81e40d49-4bf3-46d7-a16e-0d27f04aeeed	9afa3511-0ba6-4c66-b2f2-169c6815d139
81e40d49-4bf3-46d7-a16e-0d27f04aeeed	84484d09-8b66-4ea7-9edc-106fd13ffd73
da42a843-33f4-4018-96e7-8982ed95baa0	9afa3511-0ba6-4c66-b2f2-169c6815d139
da42a843-33f4-4018-96e7-8982ed95baa0	84484d09-8b66-4ea7-9edc-106fd13ffd73
c3a219ff-bce7-4c1f-a075-bac2b1d3c1bd	43f85820-0294-49e4-953c-ea119f2eb8f9
c3a219ff-bce7-4c1f-a075-bac2b1d3c1bd	84484d09-8b66-4ea7-9edc-106fd13ffd73
c3a219ff-bce7-4c1f-a075-bac2b1d3c1bd	7c78a105-695c-4a82-b99a-b4d0fdcb1915
c2aa178c-b58b-4b7d-a093-af38aeea0a67	43f85820-0294-49e4-953c-ea119f2eb8f9
c2aa178c-b58b-4b7d-a093-af38aeea0a67	84484d09-8b66-4ea7-9edc-106fd13ffd73
c2aa178c-b58b-4b7d-a093-af38aeea0a67	7c78a105-695c-4a82-b99a-b4d0fdcb1915
fef9641f-1ed0-48c7-9d84-72a0e5618bef	6a151e20-73d9-45e0-94bf-be7a0f73f4cf
fef9641f-1ed0-48c7-9d84-72a0e5618bef	9afa3511-0ba6-4c66-b2f2-169c6815d139
fef9641f-1ed0-48c7-9d84-72a0e5618bef	43f85820-0294-49e4-953c-ea119f2eb8f9
562d34dc-09e9-4aab-859f-5a486394ff9f	9afa3511-0ba6-4c66-b2f2-169c6815d139
562d34dc-09e9-4aab-859f-5a486394ff9f	84484d09-8b66-4ea7-9edc-106fd13ffd73
f8c2f2a4-231e-4099-8ac2-5745326eadbd	9afa3511-0ba6-4c66-b2f2-169c6815d139
f8c2f2a4-231e-4099-8ac2-5745326eadbd	84484d09-8b66-4ea7-9edc-106fd13ffd73
af1155b0-ca5a-4a8a-9091-e6fc4312b3cb	6a151e20-73d9-45e0-94bf-be7a0f73f4cf
af1155b0-ca5a-4a8a-9091-e6fc4312b3cb	9afa3511-0ba6-4c66-b2f2-169c6815d139
af1155b0-ca5a-4a8a-9091-e6fc4312b3cb	43f85820-0294-49e4-953c-ea119f2eb8f9
a3fe79d2-2a75-40be-945f-259ae87e26f3	17739b35-27cb-41af-bb8d-d996f3519ee7
a3fe79d2-2a75-40be-945f-259ae87e26f3	9afa3511-0ba6-4c66-b2f2-169c6815d139
a3fe79d2-2a75-40be-945f-259ae87e26f3	fa7e1059-7a33-4976-8bbd-2e6189548642
71a1edd8-e536-4415-9daf-1ec428ee9b73	43f85820-0294-49e4-953c-ea119f2eb8f9
71a1edd8-e536-4415-9daf-1ec428ee9b73	84484d09-8b66-4ea7-9edc-106fd13ffd73
71a1edd8-e536-4415-9daf-1ec428ee9b73	7c78a105-695c-4a82-b99a-b4d0fdcb1915
908ccf06-f3a9-4ee3-89b8-c1bfab8a07db	43f85820-0294-49e4-953c-ea119f2eb8f9
908ccf06-f3a9-4ee3-89b8-c1bfab8a07db	84484d09-8b66-4ea7-9edc-106fd13ffd73
908ccf06-f3a9-4ee3-89b8-c1bfab8a07db	7c78a105-695c-4a82-b99a-b4d0fdcb1915
b7bdb37a-2202-4c17-a0c8-dcf47f0ae88a	43f85820-0294-49e4-953c-ea119f2eb8f9
b7bdb37a-2202-4c17-a0c8-dcf47f0ae88a	84484d09-8b66-4ea7-9edc-106fd13ffd73
b7bdb37a-2202-4c17-a0c8-dcf47f0ae88a	7c78a105-695c-4a82-b99a-b4d0fdcb1915
f3545f5d-3fc7-4be1-91e4-4d2b86150cbe	9afa3511-0ba6-4c66-b2f2-169c6815d139
f3545f5d-3fc7-4be1-91e4-4d2b86150cbe	84484d09-8b66-4ea7-9edc-106fd13ffd73
ffc16873-1f35-45d9-a6f2-93ae90d2b387	9afa3511-0ba6-4c66-b2f2-169c6815d139
ffc16873-1f35-45d9-a6f2-93ae90d2b387	84484d09-8b66-4ea7-9edc-106fd13ffd73
ecb5cef2-e4e8-4393-b167-d677b47f3546	9afa3511-0ba6-4c66-b2f2-169c6815d139
ecb5cef2-e4e8-4393-b167-d677b47f3546	84484d09-8b66-4ea7-9edc-106fd13ffd73
48e6f77d-903d-4b6d-827e-55628c4c03ab	9afa3511-0ba6-4c66-b2f2-169c6815d139
48e6f77d-903d-4b6d-827e-55628c4c03ab	84484d09-8b66-4ea7-9edc-106fd13ffd73
530800c6-b78d-4c1d-9367-7a1732ede5dc	9afa3511-0ba6-4c66-b2f2-169c6815d139
530800c6-b78d-4c1d-9367-7a1732ede5dc	84484d09-8b66-4ea7-9edc-106fd13ffd73
6d1dd482-cd9d-456b-8de0-1b032e9e0df6	43f85820-0294-49e4-953c-ea119f2eb8f9
6d1dd482-cd9d-456b-8de0-1b032e9e0df6	84484d09-8b66-4ea7-9edc-106fd13ffd73
6d1dd482-cd9d-456b-8de0-1b032e9e0df6	7c78a105-695c-4a82-b99a-b4d0fdcb1915
a48ccd0f-c3ff-4d5f-a6fe-c10848719ce5	9afa3511-0ba6-4c66-b2f2-169c6815d139
a48ccd0f-c3ff-4d5f-a6fe-c10848719ce5	84484d09-8b66-4ea7-9edc-106fd13ffd73
eb9910da-1c69-4ef0-8e0e-5840ca04a380	9afa3511-0ba6-4c66-b2f2-169c6815d139
eb9910da-1c69-4ef0-8e0e-5840ca04a380	84484d09-8b66-4ea7-9edc-106fd13ffd73
370bb1f1-7eda-4828-93e5-88cace76098d	43f85820-0294-49e4-953c-ea119f2eb8f9
370bb1f1-7eda-4828-93e5-88cace76098d	84484d09-8b66-4ea7-9edc-106fd13ffd73
370bb1f1-7eda-4828-93e5-88cace76098d	7c78a105-695c-4a82-b99a-b4d0fdcb1915
d251529b-44c7-4628-ae32-1b54f4efcc03	9afa3511-0ba6-4c66-b2f2-169c6815d139
d251529b-44c7-4628-ae32-1b54f4efcc03	84484d09-8b66-4ea7-9edc-106fd13ffd73
fcf19eb6-74e4-482b-862a-f3c20f0a57a2	43f85820-0294-49e4-953c-ea119f2eb8f9
fcf19eb6-74e4-482b-862a-f3c20f0a57a2	84484d09-8b66-4ea7-9edc-106fd13ffd73
fcf19eb6-74e4-482b-862a-f3c20f0a57a2	7c78a105-695c-4a82-b99a-b4d0fdcb1915
8285b0f2-c2f1-4ff3-a74e-030e4cb47ffa	9afa3511-0ba6-4c66-b2f2-169c6815d139
8285b0f2-c2f1-4ff3-a74e-030e4cb47ffa	84484d09-8b66-4ea7-9edc-106fd13ffd73
cb7028c5-583d-4505-870c-8918923e3468	9afa3511-0ba6-4c66-b2f2-169c6815d139
cb7028c5-583d-4505-870c-8918923e3468	84484d09-8b66-4ea7-9edc-106fd13ffd73
ccecba4e-19f2-4977-a7f5-a64ba54c2de8	9afa3511-0ba6-4c66-b2f2-169c6815d139
ccecba4e-19f2-4977-a7f5-a64ba54c2de8	84484d09-8b66-4ea7-9edc-106fd13ffd73
11c7b598-b577-4e5f-b988-3347839d9a96	9afa3511-0ba6-4c66-b2f2-169c6815d139
11c7b598-b577-4e5f-b988-3347839d9a96	84484d09-8b66-4ea7-9edc-106fd13ffd73
7302da6b-0859-48c8-a743-8ffc73bd6ed5	9afa3511-0ba6-4c66-b2f2-169c6815d139
7302da6b-0859-48c8-a743-8ffc73bd6ed5	84484d09-8b66-4ea7-9edc-106fd13ffd73
caca1abb-0677-4801-9586-f8732d8937df	17739b35-27cb-41af-bb8d-d996f3519ee7
caca1abb-0677-4801-9586-f8732d8937df	9afa3511-0ba6-4c66-b2f2-169c6815d139
8dd1495b-7b0a-41d1-97f6-77f99adbedd9	84484d09-8b66-4ea7-9edc-106fd13ffd73
8dd1495b-7b0a-41d1-97f6-77f99adbedd9	9afa3511-0ba6-4c66-b2f2-169c6815d139
ecec3822-2abb-4fe8-8a35-8f75cb5b5d00	6a151e20-73d9-45e0-94bf-be7a0f73f4cf
ecec3822-2abb-4fe8-8a35-8f75cb5b5d00	9afa3511-0ba6-4c66-b2f2-169c6815d139
ecec3822-2abb-4fe8-8a35-8f75cb5b5d00	43f85820-0294-49e4-953c-ea119f2eb8f9
e1979d34-ff10-4f48-9ecc-c4d8fe3dc1d7	9afa3511-0ba6-4c66-b2f2-169c6815d139
e1979d34-ff10-4f48-9ecc-c4d8fe3dc1d7	84484d09-8b66-4ea7-9edc-106fd13ffd73
ae02e3da-e96e-4f34-8c45-33fe6327412c	43f85820-0294-49e4-953c-ea119f2eb8f9
ae02e3da-e96e-4f34-8c45-33fe6327412c	84484d09-8b66-4ea7-9edc-106fd13ffd73
ae02e3da-e96e-4f34-8c45-33fe6327412c	7c78a105-695c-4a82-b99a-b4d0fdcb1915
747d5df7-daf5-47ea-9ebe-e707e21d7fd8	43f85820-0294-49e4-953c-ea119f2eb8f9
747d5df7-daf5-47ea-9ebe-e707e21d7fd8	84484d09-8b66-4ea7-9edc-106fd13ffd73
747d5df7-daf5-47ea-9ebe-e707e21d7fd8	7c78a105-695c-4a82-b99a-b4d0fdcb1915
7ca6c205-ed24-4aee-a4a1-701d5926e58b	9afa3511-0ba6-4c66-b2f2-169c6815d139
7ca6c205-ed24-4aee-a4a1-701d5926e58b	84484d09-8b66-4ea7-9edc-106fd13ffd73
1b8c2b12-c017-4804-8df8-9b5e45c3f87f	43f85820-0294-49e4-953c-ea119f2eb8f9
1b8c2b12-c017-4804-8df8-9b5e45c3f87f	84484d09-8b66-4ea7-9edc-106fd13ffd73
1b8c2b12-c017-4804-8df8-9b5e45c3f87f	7c78a105-695c-4a82-b99a-b4d0fdcb1915
72aac672-fcb5-4f75-8c9f-35b54c08b431	9afa3511-0ba6-4c66-b2f2-169c6815d139
72aac672-fcb5-4f75-8c9f-35b54c08b431	84484d09-8b66-4ea7-9edc-106fd13ffd73
3e48080f-456f-4dd4-8ed3-996c4c5d1db9	9afa3511-0ba6-4c66-b2f2-169c6815d139
3e48080f-456f-4dd4-8ed3-996c4c5d1db9	84484d09-8b66-4ea7-9edc-106fd13ffd73
3e48080f-456f-4dd4-8ed3-996c4c5d1db9	17739b35-27cb-41af-bb8d-d996f3519ee7
1a14d2ed-b677-42eb-bc3e-6a78ddb1f7a8	43f85820-0294-49e4-953c-ea119f2eb8f9
1a14d2ed-b677-42eb-bc3e-6a78ddb1f7a8	84484d09-8b66-4ea7-9edc-106fd13ffd73
1a14d2ed-b677-42eb-bc3e-6a78ddb1f7a8	7c78a105-695c-4a82-b99a-b4d0fdcb1915
8c1b857f-852f-4bb9-bcca-3761a46d8a78	9afa3511-0ba6-4c66-b2f2-169c6815d139
8c1b857f-852f-4bb9-bcca-3761a46d8a78	84484d09-8b66-4ea7-9edc-106fd13ffd73
ac2c6867-0a1e-4e01-8016-b09183e01db9	6a151e20-73d9-45e0-94bf-be7a0f73f4cf
ac2c6867-0a1e-4e01-8016-b09183e01db9	9afa3511-0ba6-4c66-b2f2-169c6815d139
ac2c6867-0a1e-4e01-8016-b09183e01db9	43f85820-0294-49e4-953c-ea119f2eb8f9
665fe5b6-a36b-4104-883f-4400203a8976	9afa3511-0ba6-4c66-b2f2-169c6815d139
665fe5b6-a36b-4104-883f-4400203a8976	84484d09-8b66-4ea7-9edc-106fd13ffd73
d6aeba5f-5d8a-4b67-a1df-f38f28b38d41	43f85820-0294-49e4-953c-ea119f2eb8f9
d6aeba5f-5d8a-4b67-a1df-f38f28b38d41	84484d09-8b66-4ea7-9edc-106fd13ffd73
d6aeba5f-5d8a-4b67-a1df-f38f28b38d41	7c78a105-695c-4a82-b99a-b4d0fdcb1915
d8e0d3f2-d01a-4d53-80f8-7d97e61c8eba	9afa3511-0ba6-4c66-b2f2-169c6815d139
d8e0d3f2-d01a-4d53-80f8-7d97e61c8eba	84484d09-8b66-4ea7-9edc-106fd13ffd73
d8e0d3f2-d01a-4d53-80f8-7d97e61c8eba	17739b35-27cb-41af-bb8d-d996f3519ee7
fc7b50ee-89c4-4622-8ac4-4e9fceaa97c8	9afa3511-0ba6-4c66-b2f2-169c6815d139
fc7b50ee-89c4-4622-8ac4-4e9fceaa97c8	84484d09-8b66-4ea7-9edc-106fd13ffd73
af5fa9fa-03c7-4640-8c1a-3172f22ba55f	43f85820-0294-49e4-953c-ea119f2eb8f9
af5fa9fa-03c7-4640-8c1a-3172f22ba55f	84484d09-8b66-4ea7-9edc-106fd13ffd73
af5fa9fa-03c7-4640-8c1a-3172f22ba55f	7c78a105-695c-4a82-b99a-b4d0fdcb1915
221e8d86-6295-4e54-826a-530f2db1c035	9afa3511-0ba6-4c66-b2f2-169c6815d139
221e8d86-6295-4e54-826a-530f2db1c035	84484d09-8b66-4ea7-9edc-106fd13ffd73
513fec1f-be49-4ef8-b19e-2202056073a0	9afa3511-0ba6-4c66-b2f2-169c6815d139
513fec1f-be49-4ef8-b19e-2202056073a0	84484d09-8b66-4ea7-9edc-106fd13ffd73
0b32f06d-5edf-4077-8d6e-ff38e207961a	9afa3511-0ba6-4c66-b2f2-169c6815d139
0b32f06d-5edf-4077-8d6e-ff38e207961a	84484d09-8b66-4ea7-9edc-106fd13ffd73
ed315038-fb94-4c41-9759-667b65c7c540	43f85820-0294-49e4-953c-ea119f2eb8f9
ed315038-fb94-4c41-9759-667b65c7c540	84484d09-8b66-4ea7-9edc-106fd13ffd73
ed315038-fb94-4c41-9759-667b65c7c540	7c78a105-695c-4a82-b99a-b4d0fdcb1915
c648e155-66b6-48dd-8374-9a8b5832df45	9afa3511-0ba6-4c66-b2f2-169c6815d139
c648e155-66b6-48dd-8374-9a8b5832df45	84484d09-8b66-4ea7-9edc-106fd13ffd73
fdc843e7-3df6-417b-8bb6-ca1c80b401db	6a151e20-73d9-45e0-94bf-be7a0f73f4cf
fdc843e7-3df6-417b-8bb6-ca1c80b401db	9afa3511-0ba6-4c66-b2f2-169c6815d139
fdc843e7-3df6-417b-8bb6-ca1c80b401db	43f85820-0294-49e4-953c-ea119f2eb8f9
c54e0224-118c-43c2-857e-22e74330e174	9afa3511-0ba6-4c66-b2f2-169c6815d139
c54e0224-118c-43c2-857e-22e74330e174	84484d09-8b66-4ea7-9edc-106fd13ffd73
6e013b45-a52d-46c5-b45f-542274582583	9afa3511-0ba6-4c66-b2f2-169c6815d139
6e013b45-a52d-46c5-b45f-542274582583	84484d09-8b66-4ea7-9edc-106fd13ffd73
4f82177e-15ce-4c56-9fbf-796d7ea2804c	9afa3511-0ba6-4c66-b2f2-169c6815d139
4f82177e-15ce-4c56-9fbf-796d7ea2804c	84484d09-8b66-4ea7-9edc-106fd13ffd73
333b9948-8b96-4be6-ac07-a03e5db15c92	43f85820-0294-49e4-953c-ea119f2eb8f9
333b9948-8b96-4be6-ac07-a03e5db15c92	84484d09-8b66-4ea7-9edc-106fd13ffd73
333b9948-8b96-4be6-ac07-a03e5db15c92	7c78a105-695c-4a82-b99a-b4d0fdcb1915
bb23edc9-91fb-41b1-9c1a-cffaeb05d01e	43f85820-0294-49e4-953c-ea119f2eb8f9
bb23edc9-91fb-41b1-9c1a-cffaeb05d01e	84484d09-8b66-4ea7-9edc-106fd13ffd73
bb23edc9-91fb-41b1-9c1a-cffaeb05d01e	7c78a105-695c-4a82-b99a-b4d0fdcb1915
05cb7ddc-fbd5-4899-a854-dbf06ee86046	9afa3511-0ba6-4c66-b2f2-169c6815d139
05cb7ddc-fbd5-4899-a854-dbf06ee86046	84484d09-8b66-4ea7-9edc-106fd13ffd73
9a6b9e7c-7cac-4c32-b420-c71b3dfbdcfb	9afa3511-0ba6-4c66-b2f2-169c6815d139
9a6b9e7c-7cac-4c32-b420-c71b3dfbdcfb	84484d09-8b66-4ea7-9edc-106fd13ffd73
d669ef37-51a5-42ba-89c1-a3d8db0f300a	17739b35-27cb-41af-bb8d-d996f3519ee7
d669ef37-51a5-42ba-89c1-a3d8db0f300a	9afa3511-0ba6-4c66-b2f2-169c6815d139
78529251-fc7e-40c4-b94f-1fe2fc676f4b	9afa3511-0ba6-4c66-b2f2-169c6815d139
78529251-fc7e-40c4-b94f-1fe2fc676f4b	84484d09-8b66-4ea7-9edc-106fd13ffd73
775ee6ae-7471-4efa-a431-321fe0d8bb1f	9afa3511-0ba6-4c66-b2f2-169c6815d139
775ee6ae-7471-4efa-a431-321fe0d8bb1f	84484d09-8b66-4ea7-9edc-106fd13ffd73
fd1fe11b-e778-4802-aa00-416ac51e5f33	9afa3511-0ba6-4c66-b2f2-169c6815d139
fd1fe11b-e778-4802-aa00-416ac51e5f33	84484d09-8b66-4ea7-9edc-106fd13ffd73
56be8083-b5b0-4618-8d39-524ca8def7da	9afa3511-0ba6-4c66-b2f2-169c6815d139
56be8083-b5b0-4618-8d39-524ca8def7da	84484d09-8b66-4ea7-9edc-106fd13ffd73
921783dc-7146-457f-b481-e0a921d0c584	9afa3511-0ba6-4c66-b2f2-169c6815d139
921783dc-7146-457f-b481-e0a921d0c584	84484d09-8b66-4ea7-9edc-106fd13ffd73
a74cdf3d-a11b-4f17-a7c5-0b3923aa4bba	9afa3511-0ba6-4c66-b2f2-169c6815d139
a74cdf3d-a11b-4f17-a7c5-0b3923aa4bba	84484d09-8b66-4ea7-9edc-106fd13ffd73
1a28b1f2-7ec2-4664-82d3-3c69acd79969	9afa3511-0ba6-4c66-b2f2-169c6815d139
1a28b1f2-7ec2-4664-82d3-3c69acd79969	84484d09-8b66-4ea7-9edc-106fd13ffd73
8b2a2fa1-f832-429b-a4d8-27db06cc0fdc	9afa3511-0ba6-4c66-b2f2-169c6815d139
8b2a2fa1-f832-429b-a4d8-27db06cc0fdc	84484d09-8b66-4ea7-9edc-106fd13ffd73
96166a20-0c85-469a-961d-8e876f98d00b	9afa3511-0ba6-4c66-b2f2-169c6815d139
96166a20-0c85-469a-961d-8e876f98d00b	84484d09-8b66-4ea7-9edc-106fd13ffd73
f42ea33a-0edc-4697-b154-7cee4faf6919	43f85820-0294-49e4-953c-ea119f2eb8f9
f42ea33a-0edc-4697-b154-7cee4faf6919	84484d09-8b66-4ea7-9edc-106fd13ffd73
f42ea33a-0edc-4697-b154-7cee4faf6919	7c78a105-695c-4a82-b99a-b4d0fdcb1915
061cc62d-4530-42d2-855d-365359e7b206	9afa3511-0ba6-4c66-b2f2-169c6815d139
061cc62d-4530-42d2-855d-365359e7b206	84484d09-8b66-4ea7-9edc-106fd13ffd73
08f2c938-7a33-48ea-a611-698f26df1195	84484d09-8b66-4ea7-9edc-106fd13ffd73
08f2c938-7a33-48ea-a611-698f26df1195	9afa3511-0ba6-4c66-b2f2-169c6815d139
4310d0ed-3d59-4085-b4f1-0e7ffb31874f	17739b35-27cb-41af-bb8d-d996f3519ee7
4310d0ed-3d59-4085-b4f1-0e7ffb31874f	9afa3511-0ba6-4c66-b2f2-169c6815d139
4310d0ed-3d59-4085-b4f1-0e7ffb31874f	fa7e1059-7a33-4976-8bbd-2e6189548642
290f8912-5cf8-4771-a6f3-ec9da866d3e7	9afa3511-0ba6-4c66-b2f2-169c6815d139
290f8912-5cf8-4771-a6f3-ec9da866d3e7	84484d09-8b66-4ea7-9edc-106fd13ffd73
ce398622-71f1-46f4-afcc-53ae0361f631	9afa3511-0ba6-4c66-b2f2-169c6815d139
ce398622-71f1-46f4-afcc-53ae0361f631	84484d09-8b66-4ea7-9edc-106fd13ffd73
f21d8987-d8bf-489e-a068-6369266d3fd0	9afa3511-0ba6-4c66-b2f2-169c6815d139
f21d8987-d8bf-489e-a068-6369266d3fd0	84484d09-8b66-4ea7-9edc-106fd13ffd73
af9d51dd-fe4e-479e-af77-854242f1ffff	9afa3511-0ba6-4c66-b2f2-169c6815d139
af9d51dd-fe4e-479e-af77-854242f1ffff	84484d09-8b66-4ea7-9edc-106fd13ffd73
31e6de7e-1e85-4565-87f1-140d98670c23	9afa3511-0ba6-4c66-b2f2-169c6815d139
31e6de7e-1e85-4565-87f1-140d98670c23	84484d09-8b66-4ea7-9edc-106fd13ffd73
bf42b2ff-49f8-4ee4-9170-c54e0c427c08	43f85820-0294-49e4-953c-ea119f2eb8f9
bf42b2ff-49f8-4ee4-9170-c54e0c427c08	84484d09-8b66-4ea7-9edc-106fd13ffd73
bf42b2ff-49f8-4ee4-9170-c54e0c427c08	7c78a105-695c-4a82-b99a-b4d0fdcb1915
0009d0a3-d932-417c-8e05-560e54b6505a	9afa3511-0ba6-4c66-b2f2-169c6815d139
0009d0a3-d932-417c-8e05-560e54b6505a	84484d09-8b66-4ea7-9edc-106fd13ffd73
b490dbfa-1183-476d-8cff-23239c89ee4b	6a151e20-73d9-45e0-94bf-be7a0f73f4cf
b490dbfa-1183-476d-8cff-23239c89ee4b	9afa3511-0ba6-4c66-b2f2-169c6815d139
b490dbfa-1183-476d-8cff-23239c89ee4b	43f85820-0294-49e4-953c-ea119f2eb8f9
d2c936f3-18c9-416d-a11b-bae4199cb449	9afa3511-0ba6-4c66-b2f2-169c6815d139
d2c936f3-18c9-416d-a11b-bae4199cb449	84484d09-8b66-4ea7-9edc-106fd13ffd73
cf36f9f8-4b5f-4fd7-b9d1-d123775314be	9afa3511-0ba6-4c66-b2f2-169c6815d139
cf36f9f8-4b5f-4fd7-b9d1-d123775314be	84484d09-8b66-4ea7-9edc-106fd13ffd73
d9d7198c-9c55-46db-9cd0-d24b7efecf88	9afa3511-0ba6-4c66-b2f2-169c6815d139
d9d7198c-9c55-46db-9cd0-d24b7efecf88	84484d09-8b66-4ea7-9edc-106fd13ffd73
9fc934b4-373c-4e47-8e87-6bfac305f403	9afa3511-0ba6-4c66-b2f2-169c6815d139
9fc934b4-373c-4e47-8e87-6bfac305f403	84484d09-8b66-4ea7-9edc-106fd13ffd73
31c6baac-7966-4ff0-b0dd-912889ef431f	6a151e20-73d9-45e0-94bf-be7a0f73f4cf
31c6baac-7966-4ff0-b0dd-912889ef431f	9afa3511-0ba6-4c66-b2f2-169c6815d139
31c6baac-7966-4ff0-b0dd-912889ef431f	43f85820-0294-49e4-953c-ea119f2eb8f9
d1e5b180-2da0-463f-9bfa-8170b15bcfe3	43f85820-0294-49e4-953c-ea119f2eb8f9
d1e5b180-2da0-463f-9bfa-8170b15bcfe3	84484d09-8b66-4ea7-9edc-106fd13ffd73
d1e5b180-2da0-463f-9bfa-8170b15bcfe3	7c78a105-695c-4a82-b99a-b4d0fdcb1915
d3c81bd4-bd29-4236-a0d9-08b45ffacb78	9afa3511-0ba6-4c66-b2f2-169c6815d139
d3c81bd4-bd29-4236-a0d9-08b45ffacb78	84484d09-8b66-4ea7-9edc-106fd13ffd73
f37905f0-a109-4420-ab95-96e97a7d31b2	9afa3511-0ba6-4c66-b2f2-169c6815d139
f37905f0-a109-4420-ab95-96e97a7d31b2	84484d09-8b66-4ea7-9edc-106fd13ffd73
b865cf43-8be2-42cd-9678-11d561cb94a4	9afa3511-0ba6-4c66-b2f2-169c6815d139
b865cf43-8be2-42cd-9678-11d561cb94a4	84484d09-8b66-4ea7-9edc-106fd13ffd73
\.


--
-- Data for Name: book_genres; Type: TABLE DATA; Schema: public; Owner: sabir
--

COPY public.book_genres (book_id, genre_id) FROM stdin;
c8950321-9395-44ce-828c-78a732f91b37	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
3b67e257-fcbb-4de4-8149-5ce9960f77b9	5c1074cd-d714-4d26-9612-e3b7cd658012
3b67e257-fcbb-4de4-8149-5ce9960f77b9	d9f01075-d55c-4023-ba92-8dc49a70f976
3b67e257-fcbb-4de4-8149-5ce9960f77b9	9ae1fac3-0fd2-475e-bdfb-a916296450f1
6ad0bc0d-310a-4cfb-bc16-5d6106f5d530	5c1074cd-d714-4d26-9612-e3b7cd658012
6ad0bc0d-310a-4cfb-bc16-5d6106f5d530	d9f01075-d55c-4023-ba92-8dc49a70f976
6ad0bc0d-310a-4cfb-bc16-5d6106f5d530	9ae1fac3-0fd2-475e-bdfb-a916296450f1
94578ec4-205d-4644-aa91-7647bc2d9900	5c1074cd-d714-4d26-9612-e3b7cd658012
94578ec4-205d-4644-aa91-7647bc2d9900	d9f01075-d55c-4023-ba92-8dc49a70f976
94578ec4-205d-4644-aa91-7647bc2d9900	9ae1fac3-0fd2-475e-bdfb-a916296450f1
e9cb7006-e285-4530-9643-0a0a959305a0	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
c3722913-0cd4-4cfb-9544-15c9b70d1f8c	e88a4263-f077-4766-bcdf-1b7c585d211b
c3722913-0cd4-4cfb-9544-15c9b70d1f8c	a0482b48-0021-4379-9f87-f33fdea112d5
c3722913-0cd4-4cfb-9544-15c9b70d1f8c	a7010a6c-d6e8-4003-887f-f6298c65c147
58c809f0-4d05-4d6a-9255-f00c357a84eb	68e2ff8f-6716-4de9-99cf-990050bc8f92
58c809f0-4d05-4d6a-9255-f00c357a84eb	266310e8-0287-41e8-b5b0-fd0e237d438f
ba70c5e9-a793-4384-992c-047ea44b45c6	bf3da532-c2f1-412f-9ec1-00bef471b602
ba70c5e9-a793-4384-992c-047ea44b45c6	266310e8-0287-41e8-b5b0-fd0e237d438f
ba70c5e9-a793-4384-992c-047ea44b45c6	9ae1fac3-0fd2-475e-bdfb-a916296450f1
3f197abc-a693-49d5-b0bb-406edd54c693	bf3da532-c2f1-412f-9ec1-00bef471b602
3f197abc-a693-49d5-b0bb-406edd54c693	266310e8-0287-41e8-b5b0-fd0e237d438f
b93913d0-c4af-46ca-a602-a31b06c816ec	5c1074cd-d714-4d26-9612-e3b7cd658012
b93913d0-c4af-46ca-a602-a31b06c816ec	d9f01075-d55c-4023-ba92-8dc49a70f976
b93913d0-c4af-46ca-a602-a31b06c816ec	9ae1fac3-0fd2-475e-bdfb-a916296450f1
3647650f-080a-4e5e-9f10-d73c87df3a46	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
a30177e0-30cd-4d73-8c78-0db194465e33	5c1074cd-d714-4d26-9612-e3b7cd658012
a30177e0-30cd-4d73-8c78-0db194465e33	d9f01075-d55c-4023-ba92-8dc49a70f976
a30177e0-30cd-4d73-8c78-0db194465e33	9ae1fac3-0fd2-475e-bdfb-a916296450f1
978985ec-1759-46ee-bb14-531c9bfcc3c7	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
c64f7799-493f-4135-abd0-e12310577760	bf3da532-c2f1-412f-9ec1-00bef471b602
c64f7799-493f-4135-abd0-e12310577760	266310e8-0287-41e8-b5b0-fd0e237d438f
3c2de1cd-3496-4c54-af75-df4d7b1941f2	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
ec828ace-a3e6-4625-9a16-31f19d1b57e2	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
1ff0995a-4cd4-4ff4-bfbd-7bae9e760726	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
198517e6-4fd4-4b5b-aec7-ac135b050bd7	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
490214ac-1b2d-4e5b-97cd-e27514faed75	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
a77d1c9f-dd91-4a7f-ba0a-d157c1f90f0f	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
38b4f1ff-9177-437d-a124-c8514bfd1adf	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
9bed5434-3be9-4a64-b32f-b749ca0cae6a	5c1074cd-d714-4d26-9612-e3b7cd658012
9bed5434-3be9-4a64-b32f-b749ca0cae6a	d9f01075-d55c-4023-ba92-8dc49a70f976
9bed5434-3be9-4a64-b32f-b749ca0cae6a	9ae1fac3-0fd2-475e-bdfb-a916296450f1
ac2c31ef-9d50-441a-aa08-cb387199c7ff	e88a4263-f077-4766-bcdf-1b7c585d211b
ac2c31ef-9d50-441a-aa08-cb387199c7ff	a0482b48-0021-4379-9f87-f33fdea112d5
ac2c31ef-9d50-441a-aa08-cb387199c7ff	a7010a6c-d6e8-4003-887f-f6298c65c147
da9871b3-97d4-4bca-9f21-be4755a67c78	9ae1fac3-0fd2-475e-bdfb-a916296450f1
da9871b3-97d4-4bca-9f21-be4755a67c78	e2e54289-a55d-401a-a341-77e5b08023e0
d3ea78cd-2f26-4667-8a48-35a045d4e58d	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
edf616f5-cdc1-4074-b31c-adad5922351a	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
d7b46e40-8242-4f70-8996-6ba5d29bb64a	5c1074cd-d714-4d26-9612-e3b7cd658012
d7b46e40-8242-4f70-8996-6ba5d29bb64a	d9f01075-d55c-4023-ba92-8dc49a70f976
d7b46e40-8242-4f70-8996-6ba5d29bb64a	9ae1fac3-0fd2-475e-bdfb-a916296450f1
33c71273-b4ee-45fc-ae72-79048c9792b2	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
8d014e8c-c611-4440-9fd1-155064e07a27	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
ffeba2da-9089-4354-9d48-a8a1bca080c2	e88a4263-f077-4766-bcdf-1b7c585d211b
ffeba2da-9089-4354-9d48-a8a1bca080c2	a0482b48-0021-4379-9f87-f33fdea112d5
ffeba2da-9089-4354-9d48-a8a1bca080c2	a7010a6c-d6e8-4003-887f-f6298c65c147
23c78129-82ff-48fd-8dd1-3772f1afff51	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
23c78129-82ff-48fd-8dd1-3772f1afff51	805dcfc3-1e6a-438a-99dc-ba561122d404
6d8c126a-6f52-4063-b46a-e00964dbd1e7	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
76999973-8825-4e01-9101-70714a9486e5	bf3da532-c2f1-412f-9ec1-00bef471b602
76999973-8825-4e01-9101-70714a9486e5	266310e8-0287-41e8-b5b0-fd0e237d438f
a91c59b3-eb49-462f-b6a3-3a8dcc723ec5	e88a4263-f077-4766-bcdf-1b7c585d211b
a91c59b3-eb49-462f-b6a3-3a8dcc723ec5	a0482b48-0021-4379-9f87-f33fdea112d5
a91c59b3-eb49-462f-b6a3-3a8dcc723ec5	a7010a6c-d6e8-4003-887f-f6298c65c147
f58abff5-0d08-412c-96bf-244e15f8aee6	e88a4263-f077-4766-bcdf-1b7c585d211b
f58abff5-0d08-412c-96bf-244e15f8aee6	a0482b48-0021-4379-9f87-f33fdea112d5
f58abff5-0d08-412c-96bf-244e15f8aee6	a7010a6c-d6e8-4003-887f-f6298c65c147
cfdf78b2-c54b-4f90-98c6-684321fbe3a1	5c1074cd-d714-4d26-9612-e3b7cd658012
cfdf78b2-c54b-4f90-98c6-684321fbe3a1	d9f01075-d55c-4023-ba92-8dc49a70f976
cfdf78b2-c54b-4f90-98c6-684321fbe3a1	9ae1fac3-0fd2-475e-bdfb-a916296450f1
d84bc7b3-d136-4c66-a9a3-276c53978196	5c1074cd-d714-4d26-9612-e3b7cd658012
d84bc7b3-d136-4c66-a9a3-276c53978196	d9f01075-d55c-4023-ba92-8dc49a70f976
d84bc7b3-d136-4c66-a9a3-276c53978196	9ae1fac3-0fd2-475e-bdfb-a916296450f1
9c14aa8a-70ea-4be8-a8ac-e1ee8ed4f755	e88a4263-f077-4766-bcdf-1b7c585d211b
9c14aa8a-70ea-4be8-a8ac-e1ee8ed4f755	a0482b48-0021-4379-9f87-f33fdea112d5
9c14aa8a-70ea-4be8-a8ac-e1ee8ed4f755	a7010a6c-d6e8-4003-887f-f6298c65c147
d9a43bea-6187-46e9-93dd-aac0175a1708	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
8dadf3d7-623a-4b37-abad-5cbdfb76890f	5c1074cd-d714-4d26-9612-e3b7cd658012
8dadf3d7-623a-4b37-abad-5cbdfb76890f	d9f01075-d55c-4023-ba92-8dc49a70f976
8dadf3d7-623a-4b37-abad-5cbdfb76890f	9ae1fac3-0fd2-475e-bdfb-a916296450f1
67c27067-9f20-4770-991a-29426cc34ec3	5c1074cd-d714-4d26-9612-e3b7cd658012
67c27067-9f20-4770-991a-29426cc34ec3	d9f01075-d55c-4023-ba92-8dc49a70f976
67c27067-9f20-4770-991a-29426cc34ec3	9ae1fac3-0fd2-475e-bdfb-a916296450f1
49640ebf-be54-4bf8-98c7-139c8fc728c3	5c1074cd-d714-4d26-9612-e3b7cd658012
49640ebf-be54-4bf8-98c7-139c8fc728c3	d9f01075-d55c-4023-ba92-8dc49a70f976
49640ebf-be54-4bf8-98c7-139c8fc728c3	9ae1fac3-0fd2-475e-bdfb-a916296450f1
222edd9c-bbe5-4f22-b380-e3c23e92a970	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
7d447336-8fd1-4881-a2d9-d63b6c24d1ae	e88a4263-f077-4766-bcdf-1b7c585d211b
7d447336-8fd1-4881-a2d9-d63b6c24d1ae	a0482b48-0021-4379-9f87-f33fdea112d5
7d447336-8fd1-4881-a2d9-d63b6c24d1ae	a7010a6c-d6e8-4003-887f-f6298c65c147
9bfa6939-ff65-4a89-b02b-cab365544ec4	bf3da532-c2f1-412f-9ec1-00bef471b602
9bfa6939-ff65-4a89-b02b-cab365544ec4	266310e8-0287-41e8-b5b0-fd0e237d438f
9bfa6939-ff65-4a89-b02b-cab365544ec4	9ae1fac3-0fd2-475e-bdfb-a916296450f1
0c046c96-9c1b-44cd-bf7a-ea9d1f87fea6	e88a4263-f077-4766-bcdf-1b7c585d211b
0c046c96-9c1b-44cd-bf7a-ea9d1f87fea6	a0482b48-0021-4379-9f87-f33fdea112d5
0c046c96-9c1b-44cd-bf7a-ea9d1f87fea6	a7010a6c-d6e8-4003-887f-f6298c65c147
ee722a96-7146-40b7-acec-349d304ab002	5c1074cd-d714-4d26-9612-e3b7cd658012
ee722a96-7146-40b7-acec-349d304ab002	d9f01075-d55c-4023-ba92-8dc49a70f976
ee722a96-7146-40b7-acec-349d304ab002	9ae1fac3-0fd2-475e-bdfb-a916296450f1
6472804e-f258-4431-842d-6f6e2d5fef32	5c1074cd-d714-4d26-9612-e3b7cd658012
6472804e-f258-4431-842d-6f6e2d5fef32	d9f01075-d55c-4023-ba92-8dc49a70f976
6472804e-f258-4431-842d-6f6e2d5fef32	9ae1fac3-0fd2-475e-bdfb-a916296450f1
2d312578-9dbd-450f-a62a-67729f8e74db	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
65856882-88f7-4c34-983a-a66466cbbb4e	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
086a303e-3247-4a0b-8994-54ff7e666480	bf3da532-c2f1-412f-9ec1-00bef471b602
086a303e-3247-4a0b-8994-54ff7e666480	266310e8-0287-41e8-b5b0-fd0e237d438f
16c51354-2fda-48fe-85f7-0ae0e1ac75ec	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
79972b3e-04c5-43df-a4d0-2046ef79d6be	5c1074cd-d714-4d26-9612-e3b7cd658012
79972b3e-04c5-43df-a4d0-2046ef79d6be	d9f01075-d55c-4023-ba92-8dc49a70f976
79972b3e-04c5-43df-a4d0-2046ef79d6be	9ae1fac3-0fd2-475e-bdfb-a916296450f1
22e73320-3645-47b6-a9b5-0be5be8f05ad	e88a4263-f077-4766-bcdf-1b7c585d211b
22e73320-3645-47b6-a9b5-0be5be8f05ad	a0482b48-0021-4379-9f87-f33fdea112d5
22e73320-3645-47b6-a9b5-0be5be8f05ad	a7010a6c-d6e8-4003-887f-f6298c65c147
913767b4-f2bc-4711-a058-23a1dc92d6a3	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
81e40d49-4bf3-46d7-a16e-0d27f04aeeed	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
da42a843-33f4-4018-96e7-8982ed95baa0	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
c3a219ff-bce7-4c1f-a075-bac2b1d3c1bd	5c1074cd-d714-4d26-9612-e3b7cd658012
c3a219ff-bce7-4c1f-a075-bac2b1d3c1bd	d9f01075-d55c-4023-ba92-8dc49a70f976
c3a219ff-bce7-4c1f-a075-bac2b1d3c1bd	9ae1fac3-0fd2-475e-bdfb-a916296450f1
c2aa178c-b58b-4b7d-a093-af38aeea0a67	5c1074cd-d714-4d26-9612-e3b7cd658012
c2aa178c-b58b-4b7d-a093-af38aeea0a67	d9f01075-d55c-4023-ba92-8dc49a70f976
c2aa178c-b58b-4b7d-a093-af38aeea0a67	9ae1fac3-0fd2-475e-bdfb-a916296450f1
fef9641f-1ed0-48c7-9d84-72a0e5618bef	e88a4263-f077-4766-bcdf-1b7c585d211b
fef9641f-1ed0-48c7-9d84-72a0e5618bef	a0482b48-0021-4379-9f87-f33fdea112d5
fef9641f-1ed0-48c7-9d84-72a0e5618bef	a7010a6c-d6e8-4003-887f-f6298c65c147
562d34dc-09e9-4aab-859f-5a486394ff9f	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
f8c2f2a4-231e-4099-8ac2-5745326eadbd	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
af1155b0-ca5a-4a8a-9091-e6fc4312b3cb	e88a4263-f077-4766-bcdf-1b7c585d211b
af1155b0-ca5a-4a8a-9091-e6fc4312b3cb	a0482b48-0021-4379-9f87-f33fdea112d5
af1155b0-ca5a-4a8a-9091-e6fc4312b3cb	a7010a6c-d6e8-4003-887f-f6298c65c147
a3fe79d2-2a75-40be-945f-259ae87e26f3	68e2ff8f-6716-4de9-99cf-990050bc8f92
a3fe79d2-2a75-40be-945f-259ae87e26f3	24b6f710-3aef-4366-946b-e96c4ab9cee2
71a1edd8-e536-4415-9daf-1ec428ee9b73	5c1074cd-d714-4d26-9612-e3b7cd658012
71a1edd8-e536-4415-9daf-1ec428ee9b73	d9f01075-d55c-4023-ba92-8dc49a70f976
71a1edd8-e536-4415-9daf-1ec428ee9b73	9ae1fac3-0fd2-475e-bdfb-a916296450f1
908ccf06-f3a9-4ee3-89b8-c1bfab8a07db	5c1074cd-d714-4d26-9612-e3b7cd658012
908ccf06-f3a9-4ee3-89b8-c1bfab8a07db	d9f01075-d55c-4023-ba92-8dc49a70f976
908ccf06-f3a9-4ee3-89b8-c1bfab8a07db	9ae1fac3-0fd2-475e-bdfb-a916296450f1
b7bdb37a-2202-4c17-a0c8-dcf47f0ae88a	5c1074cd-d714-4d26-9612-e3b7cd658012
b7bdb37a-2202-4c17-a0c8-dcf47f0ae88a	d9f01075-d55c-4023-ba92-8dc49a70f976
b7bdb37a-2202-4c17-a0c8-dcf47f0ae88a	9ae1fac3-0fd2-475e-bdfb-a916296450f1
f3545f5d-3fc7-4be1-91e4-4d2b86150cbe	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
ffc16873-1f35-45d9-a6f2-93ae90d2b387	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
ecb5cef2-e4e8-4393-b167-d677b47f3546	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
48e6f77d-903d-4b6d-827e-55628c4c03ab	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
530800c6-b78d-4c1d-9367-7a1732ede5dc	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
6d1dd482-cd9d-456b-8de0-1b032e9e0df6	5c1074cd-d714-4d26-9612-e3b7cd658012
6d1dd482-cd9d-456b-8de0-1b032e9e0df6	d9f01075-d55c-4023-ba92-8dc49a70f976
6d1dd482-cd9d-456b-8de0-1b032e9e0df6	9ae1fac3-0fd2-475e-bdfb-a916296450f1
a48ccd0f-c3ff-4d5f-a6fe-c10848719ce5	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
eb9910da-1c69-4ef0-8e0e-5840ca04a380	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
370bb1f1-7eda-4828-93e5-88cace76098d	5c1074cd-d714-4d26-9612-e3b7cd658012
370bb1f1-7eda-4828-93e5-88cace76098d	d9f01075-d55c-4023-ba92-8dc49a70f976
370bb1f1-7eda-4828-93e5-88cace76098d	9ae1fac3-0fd2-475e-bdfb-a916296450f1
d251529b-44c7-4628-ae32-1b54f4efcc03	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
fcf19eb6-74e4-482b-862a-f3c20f0a57a2	5c1074cd-d714-4d26-9612-e3b7cd658012
fcf19eb6-74e4-482b-862a-f3c20f0a57a2	d9f01075-d55c-4023-ba92-8dc49a70f976
fcf19eb6-74e4-482b-862a-f3c20f0a57a2	9ae1fac3-0fd2-475e-bdfb-a916296450f1
8285b0f2-c2f1-4ff3-a74e-030e4cb47ffa	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
cb7028c5-583d-4505-870c-8918923e3468	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
ccecba4e-19f2-4977-a7f5-a64ba54c2de8	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
11c7b598-b577-4e5f-b988-3347839d9a96	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
7302da6b-0859-48c8-a743-8ffc73bd6ed5	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
caca1abb-0677-4801-9586-f8732d8937df	68e2ff8f-6716-4de9-99cf-990050bc8f92
caca1abb-0677-4801-9586-f8732d8937df	266310e8-0287-41e8-b5b0-fd0e237d438f
8dd1495b-7b0a-41d1-97f6-77f99adbedd9	9ae1fac3-0fd2-475e-bdfb-a916296450f1
8dd1495b-7b0a-41d1-97f6-77f99adbedd9	e2e54289-a55d-401a-a341-77e5b08023e0
ecec3822-2abb-4fe8-8a35-8f75cb5b5d00	e88a4263-f077-4766-bcdf-1b7c585d211b
ecec3822-2abb-4fe8-8a35-8f75cb5b5d00	a0482b48-0021-4379-9f87-f33fdea112d5
ecec3822-2abb-4fe8-8a35-8f75cb5b5d00	a7010a6c-d6e8-4003-887f-f6298c65c147
e1979d34-ff10-4f48-9ecc-c4d8fe3dc1d7	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
ae02e3da-e96e-4f34-8c45-33fe6327412c	5c1074cd-d714-4d26-9612-e3b7cd658012
ae02e3da-e96e-4f34-8c45-33fe6327412c	d9f01075-d55c-4023-ba92-8dc49a70f976
ae02e3da-e96e-4f34-8c45-33fe6327412c	9ae1fac3-0fd2-475e-bdfb-a916296450f1
747d5df7-daf5-47ea-9ebe-e707e21d7fd8	5c1074cd-d714-4d26-9612-e3b7cd658012
747d5df7-daf5-47ea-9ebe-e707e21d7fd8	d9f01075-d55c-4023-ba92-8dc49a70f976
747d5df7-daf5-47ea-9ebe-e707e21d7fd8	9ae1fac3-0fd2-475e-bdfb-a916296450f1
7ca6c205-ed24-4aee-a4a1-701d5926e58b	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
1b8c2b12-c017-4804-8df8-9b5e45c3f87f	5c1074cd-d714-4d26-9612-e3b7cd658012
1b8c2b12-c017-4804-8df8-9b5e45c3f87f	d9f01075-d55c-4023-ba92-8dc49a70f976
1b8c2b12-c017-4804-8df8-9b5e45c3f87f	9ae1fac3-0fd2-475e-bdfb-a916296450f1
72aac672-fcb5-4f75-8c9f-35b54c08b431	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
3e48080f-456f-4dd4-8ed3-996c4c5d1db9	bf3da532-c2f1-412f-9ec1-00bef471b602
3e48080f-456f-4dd4-8ed3-996c4c5d1db9	266310e8-0287-41e8-b5b0-fd0e237d438f
3e48080f-456f-4dd4-8ed3-996c4c5d1db9	9ae1fac3-0fd2-475e-bdfb-a916296450f1
1a14d2ed-b677-42eb-bc3e-6a78ddb1f7a8	5c1074cd-d714-4d26-9612-e3b7cd658012
1a14d2ed-b677-42eb-bc3e-6a78ddb1f7a8	d9f01075-d55c-4023-ba92-8dc49a70f976
1a14d2ed-b677-42eb-bc3e-6a78ddb1f7a8	9ae1fac3-0fd2-475e-bdfb-a916296450f1
8c1b857f-852f-4bb9-bcca-3761a46d8a78	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
ac2c6867-0a1e-4e01-8016-b09183e01db9	e88a4263-f077-4766-bcdf-1b7c585d211b
ac2c6867-0a1e-4e01-8016-b09183e01db9	a0482b48-0021-4379-9f87-f33fdea112d5
ac2c6867-0a1e-4e01-8016-b09183e01db9	a7010a6c-d6e8-4003-887f-f6298c65c147
665fe5b6-a36b-4104-883f-4400203a8976	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
d6aeba5f-5d8a-4b67-a1df-f38f28b38d41	5c1074cd-d714-4d26-9612-e3b7cd658012
d6aeba5f-5d8a-4b67-a1df-f38f28b38d41	d9f01075-d55c-4023-ba92-8dc49a70f976
d6aeba5f-5d8a-4b67-a1df-f38f28b38d41	9ae1fac3-0fd2-475e-bdfb-a916296450f1
d8e0d3f2-d01a-4d53-80f8-7d97e61c8eba	bf3da532-c2f1-412f-9ec1-00bef471b602
d8e0d3f2-d01a-4d53-80f8-7d97e61c8eba	266310e8-0287-41e8-b5b0-fd0e237d438f
d8e0d3f2-d01a-4d53-80f8-7d97e61c8eba	9ae1fac3-0fd2-475e-bdfb-a916296450f1
fc7b50ee-89c4-4622-8ac4-4e9fceaa97c8	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
af5fa9fa-03c7-4640-8c1a-3172f22ba55f	5c1074cd-d714-4d26-9612-e3b7cd658012
af5fa9fa-03c7-4640-8c1a-3172f22ba55f	d9f01075-d55c-4023-ba92-8dc49a70f976
af5fa9fa-03c7-4640-8c1a-3172f22ba55f	9ae1fac3-0fd2-475e-bdfb-a916296450f1
221e8d86-6295-4e54-826a-530f2db1c035	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
513fec1f-be49-4ef8-b19e-2202056073a0	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
0b32f06d-5edf-4077-8d6e-ff38e207961a	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
ed315038-fb94-4c41-9759-667b65c7c540	5c1074cd-d714-4d26-9612-e3b7cd658012
ed315038-fb94-4c41-9759-667b65c7c540	d9f01075-d55c-4023-ba92-8dc49a70f976
ed315038-fb94-4c41-9759-667b65c7c540	9ae1fac3-0fd2-475e-bdfb-a916296450f1
c648e155-66b6-48dd-8374-9a8b5832df45	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
fdc843e7-3df6-417b-8bb6-ca1c80b401db	e88a4263-f077-4766-bcdf-1b7c585d211b
fdc843e7-3df6-417b-8bb6-ca1c80b401db	a0482b48-0021-4379-9f87-f33fdea112d5
fdc843e7-3df6-417b-8bb6-ca1c80b401db	a7010a6c-d6e8-4003-887f-f6298c65c147
c54e0224-118c-43c2-857e-22e74330e174	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
6e013b45-a52d-46c5-b45f-542274582583	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
4f82177e-15ce-4c56-9fbf-796d7ea2804c	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
333b9948-8b96-4be6-ac07-a03e5db15c92	5c1074cd-d714-4d26-9612-e3b7cd658012
333b9948-8b96-4be6-ac07-a03e5db15c92	d9f01075-d55c-4023-ba92-8dc49a70f976
333b9948-8b96-4be6-ac07-a03e5db15c92	9ae1fac3-0fd2-475e-bdfb-a916296450f1
bb23edc9-91fb-41b1-9c1a-cffaeb05d01e	5c1074cd-d714-4d26-9612-e3b7cd658012
bb23edc9-91fb-41b1-9c1a-cffaeb05d01e	d9f01075-d55c-4023-ba92-8dc49a70f976
bb23edc9-91fb-41b1-9c1a-cffaeb05d01e	9ae1fac3-0fd2-475e-bdfb-a916296450f1
05cb7ddc-fbd5-4899-a854-dbf06ee86046	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
9a6b9e7c-7cac-4c32-b420-c71b3dfbdcfb	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
d669ef37-51a5-42ba-89c1-a3d8db0f300a	bf3da532-c2f1-412f-9ec1-00bef471b602
d669ef37-51a5-42ba-89c1-a3d8db0f300a	266310e8-0287-41e8-b5b0-fd0e237d438f
78529251-fc7e-40c4-b94f-1fe2fc676f4b	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
775ee6ae-7471-4efa-a431-321fe0d8bb1f	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
fd1fe11b-e778-4802-aa00-416ac51e5f33	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
56be8083-b5b0-4618-8d39-524ca8def7da	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
921783dc-7146-457f-b481-e0a921d0c584	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
a74cdf3d-a11b-4f17-a7c5-0b3923aa4bba	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
1a28b1f2-7ec2-4664-82d3-3c69acd79969	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
8b2a2fa1-f832-429b-a4d8-27db06cc0fdc	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
96166a20-0c85-469a-961d-8e876f98d00b	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
f42ea33a-0edc-4697-b154-7cee4faf6919	5c1074cd-d714-4d26-9612-e3b7cd658012
f42ea33a-0edc-4697-b154-7cee4faf6919	d9f01075-d55c-4023-ba92-8dc49a70f976
f42ea33a-0edc-4697-b154-7cee4faf6919	9ae1fac3-0fd2-475e-bdfb-a916296450f1
061cc62d-4530-42d2-855d-365359e7b206	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
08f2c938-7a33-48ea-a611-698f26df1195	9ae1fac3-0fd2-475e-bdfb-a916296450f1
08f2c938-7a33-48ea-a611-698f26df1195	e2e54289-a55d-401a-a341-77e5b08023e0
4310d0ed-3d59-4085-b4f1-0e7ffb31874f	68e2ff8f-6716-4de9-99cf-990050bc8f92
4310d0ed-3d59-4085-b4f1-0e7ffb31874f	24b6f710-3aef-4366-946b-e96c4ab9cee2
290f8912-5cf8-4771-a6f3-ec9da866d3e7	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
ce398622-71f1-46f4-afcc-53ae0361f631	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
f21d8987-d8bf-489e-a068-6369266d3fd0	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
af9d51dd-fe4e-479e-af77-854242f1ffff	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
31e6de7e-1e85-4565-87f1-140d98670c23	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
bf42b2ff-49f8-4ee4-9170-c54e0c427c08	5c1074cd-d714-4d26-9612-e3b7cd658012
bf42b2ff-49f8-4ee4-9170-c54e0c427c08	d9f01075-d55c-4023-ba92-8dc49a70f976
bf42b2ff-49f8-4ee4-9170-c54e0c427c08	9ae1fac3-0fd2-475e-bdfb-a916296450f1
0009d0a3-d932-417c-8e05-560e54b6505a	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
b490dbfa-1183-476d-8cff-23239c89ee4b	e88a4263-f077-4766-bcdf-1b7c585d211b
b490dbfa-1183-476d-8cff-23239c89ee4b	a0482b48-0021-4379-9f87-f33fdea112d5
b490dbfa-1183-476d-8cff-23239c89ee4b	a7010a6c-d6e8-4003-887f-f6298c65c147
d2c936f3-18c9-416d-a11b-bae4199cb449	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
cf36f9f8-4b5f-4fd7-b9d1-d123775314be	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
d9d7198c-9c55-46db-9cd0-d24b7efecf88	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
9fc934b4-373c-4e47-8e87-6bfac305f403	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
31c6baac-7966-4ff0-b0dd-912889ef431f	e88a4263-f077-4766-bcdf-1b7c585d211b
31c6baac-7966-4ff0-b0dd-912889ef431f	a0482b48-0021-4379-9f87-f33fdea112d5
31c6baac-7966-4ff0-b0dd-912889ef431f	a7010a6c-d6e8-4003-887f-f6298c65c147
d1e5b180-2da0-463f-9bfa-8170b15bcfe3	5c1074cd-d714-4d26-9612-e3b7cd658012
d1e5b180-2da0-463f-9bfa-8170b15bcfe3	d9f01075-d55c-4023-ba92-8dc49a70f976
d1e5b180-2da0-463f-9bfa-8170b15bcfe3	9ae1fac3-0fd2-475e-bdfb-a916296450f1
d3c81bd4-bd29-4236-a0d9-08b45ffacb78	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
f37905f0-a109-4420-ab95-96e97a7d31b2	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
b865cf43-8be2-42cd-9678-11d561cb94a4	f250adc5-8454-4ed3-81ff-dbde4c78bd1f
\.


--
-- Data for Name: book_reviews; Type: TABLE DATA; Schema: public; Owner: sabir
--

COPY public.book_reviews (review_id, book_id, user_id, rating, review_text, is_verified, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: book_series; Type: TABLE DATA; Schema: public; Owner: sabir
--

COPY public.book_series (series_id, series_name, description, total_books, is_completed, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: book_series_entries; Type: TABLE DATA; Schema: public; Owner: sabir
--

COPY public.book_series_entries (book_id, series_id, volume_number, volume_title) FROM stdin;
\.


--
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: sabir
--

COPY public.books (book_id, title, subtitle, description, isbn_13, isbn_10, publication_date, published_year, page_count, language, cover_image_url, cover_image_small_url, cover_image_medium_url, cover_image_large_url, edition, book_format, book_condition, dimensions, weight_grams, for_sale, for_rent, price_sale, price_rent_daily, price_rent_weekly, price_rent_monthly, stock_quantity, reserved_quantity, is_active, average_rating, total_ratings, total_reviews, publisher_id, owner_id, primary_category_id, slug, search_keywords, created_at, updated_at, created_by, last_modified_by, deleted_at, deleted_by) FROM stdin;
e9cb7006-e285-4530-9643-0a0a959305a0	House of Sky and Breath	\N	\N	9781635574074	\N	\N	\N	186	es 	https://covers.openlibrary.org/b/id/13316186-L.jpg	https://covers.openlibrary.org/b/id/13316186-S.jpg	https://covers.openlibrary.org/b/id/13316186-M.jpg	https://covers.openlibrary.org/b/id/13316186-L.jpg	\N	paperback	very_good	15 x 20 cm	541	t	f	20.44	4.91	6.56	68.65	34	0	t	4.80	2414	433	e637db04-fc38-4291-8e43-f77bcc53642d	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	house-of-sky-and-breath	{house,book}	2017-10-18 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
76999973-8825-4e01-9101-70714a9486e5	City of Ashes	\N	\N	9781416914297	\N	\N	\N	218	fr 	https://covers.openlibrary.org/b/id/1787130-L.jpg	https://covers.openlibrary.org/b/id/1787130-S.jpg	https://covers.openlibrary.org/b/id/1787130-M.jpg	https://covers.openlibrary.org/b/id/1787130-L.jpg	\N	paperback	very_good	25 x 15 cm	961	t	f	22.67	2.15	11.12	70.31	73	0	t	1.40	237	198	b4425276-c6c8-41c2-a5a4-08a8e406e149	\N	17739b35-27cb-41af-bb8d-d996f3519ee7	city-of-ashes	{city,book}	2018-09-21 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
d669ef37-51a5-42ba-89c1-a3d8db0f300a	The Hunger Games	\N	\N	9780439023481	\N	\N	\N	130	en 	https://covers.openlibrary.org/b/id/14552116-L.jpg	https://covers.openlibrary.org/b/id/14552116-S.jpg	https://covers.openlibrary.org/b/id/14552116-M.jpg	https://covers.openlibrary.org/b/id/14552116-L.jpg	\N	ebook	like_new	22 x 18 cm	262	t	f	8.76	3.72	11.79	40.17	30	0	t	3.90	4748	735	f733cf42-f539-41b9-8ee7-b51115b2a834	\N	17739b35-27cb-41af-bb8d-d996f3519ee7	the-hunger-games	{the,book}	2022-02-14 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
c8950321-9395-44ce-828c-78a732f91b37	A Conjuring of Light	\N	"A Conjuring of Light" is the third book in the Shades of Magic series and focuses on the climactic battle against a malevolent force threatening to consume all three versions of London. The story follows Lila Bard, Kell Maresh, and their allies as they navigate political intrigue, dangerous magic, and personal sacrifices to save their worlds from complete annihilation. The book explores themes of power, sacrifice, and the interconnectedness of different realities.	9780765379559	\N	\N	\N	112	pt 	https://covers.openlibrary.org/b/id/8599785-L.jpg	https://covers.openlibrary.org/b/id/8599785-S.jpg	https://covers.openlibrary.org/b/id/8599785-M.jpg	https://covers.openlibrary.org/b/id/8599785-L.jpg	\N	hardcover	acceptable	22 x 16 cm	933	t	f	19.70	3.35	24.64	73.09	13	0	t	2.60	3352	578	b31258cf-cbd7-421e-bf5a-6acce3f09fec	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	a-conjuring-of-light	{a,book}	2018-10-16 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
3b67e257-fcbb-4de4-8149-5ce9960f77b9	A Court of Mist and Fury	\N	"A Court of Mist and Fury" follows Feyre as she grapples with PTSD after the events of "A Court of Thorns and Roses" and a bargain made with Rhysand, High Lord of the Night Court. As Feyre navigates this new bond, she uncovers secrets about Rhysand and the Night Court, and must confront a growing darkness threatening Prythian.	9781619634466	\N	\N	\N	360	es 	https://covers.openlibrary.org/b/id/14315081-L.jpg	https://covers.openlibrary.org/b/id/14315081-S.jpg	https://covers.openlibrary.org/b/id/14315081-M.jpg	https://covers.openlibrary.org/b/id/14315081-L.jpg	\N	audiobook	very_good	18 x 12 cm	1080	t	t	52.90	3.30	24.47	42.52	77	0	t	1.00	3837	525	765d4730-5349-4233-81e7-f6fc88d1d9fe	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	a-court-of-mist-and-fury	{a,book}	2024-10-29 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
6ad0bc0d-310a-4cfb-bc16-5d6106f5d530	A Court of Silver Flames	\N	"A Court of Silver Flames" follows Nesta Archeron as she grapples with the trauma of the war against Hybern and struggles to find her place within the Night Court. The book explores themes of healing, self-discovery, and the forging of unexpected bonds as Nesta undergoes intense training with Cassian and confronts her inner demons.	9781681196282	\N	\N	\N	135	de 	https://covers.openlibrary.org/b/id/13316176-L.jpg	https://covers.openlibrary.org/b/id/13316176-S.jpg	https://covers.openlibrary.org/b/id/13316176-M.jpg	https://covers.openlibrary.org/b/id/13316176-L.jpg	\N	hardcover	good	18 x 11 cm	500	t	f	41.84	2.02	16.05	32.62	22	0	t	3.30	1100	80	f048df88-e21a-444e-b3f6-fc85f6a911d5	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	a-court-of-silver-flames	{a,book}	2024-10-04 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
b865cf43-8be2-42cd-9678-11d561cb94a4	Yellowface	\N	\N	9780063250833	\N	\N	\N	341	es 	https://covers.openlibrary.org/b/id/13195421-L.jpg	https://covers.openlibrary.org/b/id/13195421-S.jpg	https://covers.openlibrary.org/b/id/13195421-M.jpg	https://covers.openlibrary.org/b/id/13195421-L.jpg	\N	audiobook	like_new	25 x 11 cm	947	t	t	46.98	5.37	9.80	60.64	89	0	t	2.30	3593	792	e7ecbdcf-0cbe-43d4-bbf0-8266025ef98d	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	yellowface	{yellowface,book}	2019-09-08 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
94578ec4-205d-4644-aa91-7647bc2d9900	A Court of Thorns and Roses	\N	"A Court of Thorns and Roses" follows Feyre Archeron, a huntress who is taken to the faerie lands of Prythian as punishment for killing a wolf. Once there, she discovers that her captor is not what he seems, and she becomes entangled in a dangerous bargain that will challenge everything she thought she knew about faeries and the human world. The novel explores themes of love, sacrifice, and the blurring of boundaries between humans and faeries.	9781619635180	\N	\N	\N	403	de 	https://covers.openlibrary.org/b/id/14346851-L.jpg	https://covers.openlibrary.org/b/id/14346851-S.jpg	https://covers.openlibrary.org/b/id/14346851-M.jpg	https://covers.openlibrary.org/b/id/14346851-L.jpg	\N	paperback	very_good	18 x 16 cm	1306	t	f	30.62	5.68	11.26	60.83	34	0	t	1.80	900	943	f269a424-0ba6-442b-8864-e5a882b6a676	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	a-court-of-thorns-and-roses	{a,book}	2017-09-30 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
c3722913-0cd4-4cfb-9544-15c9b70d1f8c	Ignite Me	\N	"Ignite Me" is the third and final novel in the Shatter Me series, continuing Juliette's journey to control her deadly power and fight against the oppressive Reestablishment. She must choose between her loyalties to Warner and Adam while navigating political intrigue and a potential rebellion. Ultimately, Juliette strives to unite the resistance and overthrow the Reestablishment to build a better future.	9780062085573	\N	\N	\N	365	en 	https://covers.openlibrary.org/b/id/7272906-L.jpg	https://covers.openlibrary.org/b/id/7272906-S.jpg	https://covers.openlibrary.org/b/id/7272906-M.jpg	https://covers.openlibrary.org/b/id/7272906-L.jpg	\N	ebook	acceptable	25 x 20 cm	763	t	t	32.52	3.45	9.43	67.54	85	0	t	3.50	582	239	7606a32a-84c5-46fd-8f5b-ac9a6d390393	\N	6a151e20-73d9-45e0-94bf-be7a0f73f4cf	ignite-me	{ignite,book}	2022-11-14 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
58c809f0-4d05-4d6a-9255-f00c357a84eb	Illuminae	\N	\N	9780553499117	\N	\N	\N	715	en 	https://covers.openlibrary.org/b/id/11882491-L.jpg	https://covers.openlibrary.org/b/id/11882491-S.jpg	https://covers.openlibrary.org/b/id/11882491-M.jpg	https://covers.openlibrary.org/b/id/11882491-L.jpg	\N	paperback	new	22 x 19 cm	494	t	f	29.55	2.41	17.39	56.75	29	0	t	5.00	1489	713	52235d58-73d6-4f9f-9421-faffd7c86b98	\N	17739b35-27cb-41af-bb8d-d996f3519ee7	illuminae	{illuminae,book}	2016-09-20 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
ba70c5e9-a793-4384-992c-047ea44b45c6	Imagine Me	\N	"Imagine Me" is the sixth installment in Tahereh Mafi's Shatter Me series. It explores the evolving relationship between Juliette and Warner as they grapple with their identities, fight for a better world, and confront the powerful forces manipulating them. The novel delves into themes of power, control, and the importance of personal agency in the face of overwhelming opposition.	9780062676429	\N	\N	\N	775	es 	https://covers.openlibrary.org/b/id/9363194-L.jpg	https://covers.openlibrary.org/b/id/9363194-S.jpg	https://covers.openlibrary.org/b/id/9363194-M.jpg	https://covers.openlibrary.org/b/id/9363194-L.jpg	\N	audiobook	new	18 x 17 cm	1035	t	f	38.52	5.60	12.46	19.46	4	0	t	2.10	4737	600	08bb2523-7808-479b-af10-ae93ba6c171f	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	imagine-me	{imagine,book}	2017-03-17 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
3f197abc-a693-49d5-b0bb-406edd54c693	Insurgent	\N	"Insurgent" follows Tris Prior as she navigates the fallout from the Erudite attack on Abnegation and uncovers hidden truths about the faction sabir. The novel explores themes of trust, betrayal, and the consequences of war as Tris and Four must choose who to align with in a crumbling society while facing a new threat that challenges the very foundation of their world.	9780062024046	\N	\N	\N	107	fr 	https://covers.openlibrary.org/b/id/14831780-L.jpg	https://covers.openlibrary.org/b/id/14831780-S.jpg	https://covers.openlibrary.org/b/id/14831780-M.jpg	https://covers.openlibrary.org/b/id/14831780-L.jpg	\N	ebook	acceptable	25 x 16 cm	207	t	t	45.54	1.10	16.85	25.44	57	0	t	3.50	4574	515	d0c003ca-cbac-4072-bb6c-0e2fb213eaf0	\N	17739b35-27cb-41af-bb8d-d996f3519ee7	insurgent	{insurgent,book}	2020-08-11 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
b93913d0-c4af-46ca-a602-a31b06c816ec	A Court of Wings and Ruin	\N	"A Court of Wings and Ruin" continues Feyre's story as she rallies allies and prepares for a war against Hybern, who seeks to conquer Prythian and subjugate humans. The book focuses on themes of leadership, sacrifice, and the cost of freedom, exploring the political and personal challenges faced by Feyre and her inner circle as they navigate the impending conflict.	9781619634480	\N	\N	\N	179	fr 	https://covers.openlibrary.org/b/id/14859521-L.jpg	https://covers.openlibrary.org/b/id/14859521-S.jpg	https://covers.openlibrary.org/b/id/14859521-M.jpg	https://covers.openlibrary.org/b/id/14859521-L.jpg	\N	hardcover	good	25 x 19 cm	1434	t	f	32.39	2.12	22.81	36.25	60	0	t	1.40	1070	903	cf5cd761-4321-43f1-a0b8-f026d8cf8075	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	a-court-of-wings-and-ruin	{a,book}	2019-09-15 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
3647650f-080a-4e5e-9f10-d73c87df3a46	A Day of Fallen Night	\N	"A Day of Fallen Night" is a prequel to "The Priory of the Orange Tree," exploring the events leading up to the war against the Nameless One centuries before. The narrative follows multiple female protagonists as they grapple with political intrigue, religious conflict, and the re-emergence of dragons threatening humanity's existence. The book delves into themes of sacrifice, duty, and the complexities of power amidst a world on the brink of destruction.	9781635577921	\N	\N	\N	675	en 	https://covers.openlibrary.org/b/id/12986849-L.jpg	https://covers.openlibrary.org/b/id/12986849-S.jpg	https://covers.openlibrary.org/b/id/12986849-M.jpg	https://covers.openlibrary.org/b/id/12986849-L.jpg	\N	audiobook	new	18 x 19 cm	1067	t	f	29.22	2.26	6.76	43.81	79	0	t	4.70	1457	183	e637db04-fc38-4291-8e43-f77bcc53642d	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	a-day-of-fallen-night	{a,book}	2023-05-07 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
a30177e0-30cd-4d73-8c78-0db194465e33	A Gathering of Shadows	\N	"A Gathering of Shadows" follows Lila Bard and Kell Maresh as they travel to different Londons for the Element Games, an international magical competition. As they navigate the political intrigue and challenges of the Games, a darker force stirs, threatening the fragile balance between worlds. The story explores themes of loyalty, power, and the consequences of ambition against a backdrop of magical competition and escalating danger.	9780765379535	\N	\N	\N	342	fr 	https://covers.openlibrary.org/b/id/14440932-L.jpg	https://covers.openlibrary.org/b/id/14440932-S.jpg	https://covers.openlibrary.org/b/id/14440932-M.jpg	https://covers.openlibrary.org/b/id/14440932-L.jpg	\N	paperback	like_new	18 x 15 cm	753	t	t	16.89	4.11	10.90	53.07	97	0	t	0.20	130	116	7606a32a-84c5-46fd-8f5b-ac9a6d390393	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	a-gathering-of-shadows	{a,book}	2021-09-08 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
978985ec-1759-46ee-bb14-531c9bfcc3c7	All the Light We Cannot See	\N	"All the Light We Cannot See" follows the intertwined lives of Marie-Laure, a blind French girl, and Werner, a German orphan boy with a talent for radio technology, during World War II. Their paths converge in occupied Saint-Malo as Marie-Laure seeks refuge with her great-uncle and Werner is tasked with tracking Resistance members through radio signals, exploring themes of war, resilience, and the impact of technology.	9781501173219	\N	\N	\N	651	es 	https://covers.openlibrary.org/b/id/14559676-L.jpg	https://covers.openlibrary.org/b/id/14559676-S.jpg	https://covers.openlibrary.org/b/id/14559676-M.jpg	https://covers.openlibrary.org/b/id/14559676-L.jpg	\N	paperback	like_new	22 x 19 cm	435	t	t	17.07	2.12	9.06	66.73	83	0	t	1.90	2602	15	52235d58-73d6-4f9f-9421-faffd7c86b98	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	all-the-light-we-cannot-see	{all,book}	2018-08-25 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
c64f7799-493f-4135-abd0-e12310577760	Allegiant	\N	"Allegiant" concludes the Divergent trilogy, revealing that Tris Prior's Chicago is part of a controlled experiment. The story focuses on Tris and Tobias (Four) as they venture outside the city's fence to discover the truth about their society's origins, facing new factions and moral dilemmas that challenge their allegiances and beliefs. Ultimately, the book explores themes of genetic purity, societal control, and the sacrifices made for the greater good.	9780062024060	\N	\N	\N	708	pt 	https://covers.openlibrary.org/b/id/7276393-L.jpg	https://covers.openlibrary.org/b/id/7276393-S.jpg	https://covers.openlibrary.org/b/id/7276393-M.jpg	https://covers.openlibrary.org/b/id/7276393-L.jpg	\N	paperback	acceptable	15 x 20 cm	1330	t	t	53.69	4.65	8.62	70.95	33	0	t	0.20	3425	923	08bb2523-7808-479b-af10-ae93ba6c171f	\N	17739b35-27cb-41af-bb8d-d996f3519ee7	allegiant	{allegiant,book}	2023-11-28 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
3c2de1cd-3496-4c54-af75-df4d7b1941f2	Americanah	\N	"Americanah" tells the story of Ifemelu, a Nigerian woman who immigrates to America for college and later returns to Nigeria, and her relationship with her childhood sweetheart, Obinze, who is denied entry to the US after 9/11 and lives undocumented in London. The novel explores themes of race, identity, belonging, and the immigrant experience through the characters' observations and experiences in different countries.	9780307455925	\N	\N	\N	244	fr 	https://covers.openlibrary.org/b/id/11325624-L.jpg	https://covers.openlibrary.org/b/id/11325624-S.jpg	https://covers.openlibrary.org/b/id/11325624-M.jpg	https://covers.openlibrary.org/b/id/11325624-L.jpg	\N	paperback	new	23 x 20 cm	921	t	t	40.28	4.61	5.98	31.08	80	0	t	0.80	2000	113	d0c003ca-cbac-4072-bb6c-0e2fb213eaf0	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	americanah	{americanah,book}	2019-10-07 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
ec828ace-a3e6-4625-9a16-31f19d1b57e2	Aurora Burning	\N	"Aurora Burning" continues the story of Squad 312 as they face the consequences of their actions in the first book, now hunted by the GIA and pursued by mysterious, hostile entities connected to the ancient Raknoss. The crew must grapple with difficult choices and internal conflicts while racing to uncover the truth behind the Bloom and its devastating potential. Their survival and the fate of the galaxy depend on understanding and stopping this looming threat.	9781524720971	\N	\N	\N	780	de 	https://covers.openlibrary.org/b/id/8807620-L.jpg	https://covers.openlibrary.org/b/id/8807620-S.jpg	https://covers.openlibrary.org/b/id/8807620-M.jpg	https://covers.openlibrary.org/b/id/8807620-L.jpg	\N	hardcover	very_good	17 x 10 cm	421	t	f	23.73	4.20	13.94	58.48	33	0	t	1.10	4334	40	9fb7694b-7e2d-4c91-8fdf-b572f27ac30c	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	aurora-burning	{aurora,book}	2024-05-16 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
1ff0995a-4cd4-4ff4-bfbd-7bae9e760726	Aurora Rising	\N	"Aurora Rising" follows a squad of misfit graduates from Aurora Academy who are tasked with their first mission. Their assignment is complicated by the unexpected discovery of Aurora, a girl who has been in cryo-sleep for over two centuries, and who may hold the key to an impending interstellar war. The novel explores themes of loyalty, sacrifice, and the struggle to overcome personal flaws in the face of a universe-threatening crisis.	9781524720964	\N	\N	\N	628	en 	https://covers.openlibrary.org/b/id/8807574-L.jpg	https://covers.openlibrary.org/b/id/8807574-S.jpg	https://covers.openlibrary.org/b/id/8807574-M.jpg	https://covers.openlibrary.org/b/id/8807574-L.jpg	\N	hardcover	very_good	20 x 10 cm	868	t	f	36.06	3.02	9.82	28.21	74	0	t	4.40	924	756	4101b113-69f1-403f-b2a1-ecb2bc2b2f8d	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	aurora-rising	{aurora,book}	2020-10-21 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
198517e6-4fd4-4b5b-aec7-ac135b050bd7	Aurora’s End	\N	"Aurora's End" is the third and final installment in The Aurora Cycle series, focusing on Squad 312 as they grapple with the consequences of their past actions and a looming cosmic threat. The squad must race against time to understand and potentially stop the Ra'haam from consuming the galaxy, confronting betrayals and making difficult choices along the way.	9781524720988	\N	\N	\N	292	es 	https://covers.openlibrary.org/b/id/8621717-L.jpg	https://covers.openlibrary.org/b/id/8621717-S.jpg	https://covers.openlibrary.org/b/id/8621717-M.jpg	https://covers.openlibrary.org/b/id/8621717-L.jpg	\N	audiobook	acceptable	15 x 17 cm	935	t	t	31.48	4.81	8.07	66.80	98	0	t	1.00	827	430	748e307c-7466-4919-943b-a1e4798b0f94	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	aurora-s-end	{aurora’s,book}	2017-07-01 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
490214ac-1b2d-4e5b-97cd-e27514faed75	Babel	\N	"Babel" follows Robin Swift, a Chinese orphan raised in England, as he attends Oxford's prestigious Royal Institute of Translation, known as Babel. The novel explores themes of language, translation, colonialism, and resistance as Robin becomes entangled in Babel's role in furthering British imperial ambitions and is forced to confront his complicity in the sabir.	9780063021426	\N	\N	\N	472	pt 	https://covers.openlibrary.org/b/id/14573249-L.jpg	https://covers.openlibrary.org/b/id/14573249-S.jpg	https://covers.openlibrary.org/b/id/14573249-M.jpg	https://covers.openlibrary.org/b/id/14573249-L.jpg	\N	paperback	very_good	19 x 13 cm	1348	t	t	19.68	3.10	9.94	17.87	58	0	t	4.30	3927	799	8cc4064a-2056-49a9-8ffb-bf7749bbb96c	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	babel	{babel,book}	2024-04-06 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
a77d1c9f-dd91-4a7f-ba0a-d157c1f90f0f	Before We Were Strangers	\N	"Before We Were Strangers" tells the story of Grace and Ethan, who share a profound connection after a chance encounter and subsequent intense week together in college. Years later, Grace rediscovers Ethan's misplaced note, leading her on a quest to find him and explore the "what ifs" of their past, questioning the impact of missed opportunities and the enduring power of first love. The book explores themes of fate, regret, and second chances.	9781501105777	\N	\N	\N	699	fr 	https://covers.openlibrary.org/b/id/14851813-L.jpg	https://covers.openlibrary.org/b/id/14851813-S.jpg	https://covers.openlibrary.org/b/id/14851813-M.jpg	https://covers.openlibrary.org/b/id/14851813-L.jpg	\N	paperback	good	22 x 14 cm	385	t	f	6.51	1.13	14.59	54.67	18	0	t	3.00	2540	901	f733cf42-f539-41b9-8ee7-b51115b2a834	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	before-we-were-strangers	{before,book}	2024-04-05 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
38b4f1ff-9177-437d-a124-c8514bfd1adf	Birnam Wood	\N	"Birnam Wood" follows a guerilla gardening collective who find their plans disrupted when an American billionaire buys up a large tract of land in New Zealand after a devastating landslide. The story explores themes of environmentalism, capitalism, and the power dynamics that emerge when these forces collide, ultimately building to a suspenseful and unsettling climax.	9780374110338	\N	\N	\N	533	it 	https://covers.openlibrary.org/b/id/13328050-L.jpg	https://covers.openlibrary.org/b/id/13328050-S.jpg	https://covers.openlibrary.org/b/id/13328050-M.jpg	https://covers.openlibrary.org/b/id/13328050-L.jpg	\N	paperback	very_good	25 x 13 cm	822	t	t	53.21	1.13	15.62	66.06	14	0	t	4.60	2260	363	2e31929c-d38f-48a7-b4af-17aa20160afc	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	birnam-wood	{birnam,book}	2015-12-19 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
9bed5434-3be9-4a64-b32f-b749ca0cae6a	Blade Breaker	\N	"Blade Breaker" is the second book in the Rage of Dragons series, continuing the story of Tau, a soldier driven by vengeance after the death of his loved ones. He continues his quest to hone his fighting skills and strategically climb the ranks in a society defined by caste and warfare, seeking to challenge the established order and exact revenge.	9780062872647	\N	\N	\N	726	pt 	https://covers.openlibrary.org/b/id/13652443-L.jpg	https://covers.openlibrary.org/b/id/13652443-S.jpg	https://covers.openlibrary.org/b/id/13652443-M.jpg	https://covers.openlibrary.org/b/id/13652443-L.jpg	\N	ebook	good	18 x 11 cm	1411	t	t	48.37	1.58	15.55	63.89	64	0	t	4.70	4737	868	bf3e2477-8f5b-4cd4-8959-9fd1d7dafb9d	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	blade-breaker	{blade,book}	2018-06-22 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
ac2c31ef-9d50-441a-aa08-cb387199c7ff	Bloodmarked	\N	"Bloodmarked" continues the story of Zelie, a teen from the kingdom of Orïsha who is trying to restore magic to her people. This installment explores the consequences of her actions, including political unrest, the rise of new powers, and the moral complexities of wielding magic and fighting for freedom. Zelie and her allies must navigate these challenges to secure a future for the maji while battling both external threats and internal conflicts.	9781534441637	\N	\N	\N	534	de 	https://covers.openlibrary.org/b/id/13106031-L.jpg	https://covers.openlibrary.org/b/id/13106031-S.jpg	https://covers.openlibrary.org/b/id/13106031-M.jpg	https://covers.openlibrary.org/b/id/13106031-L.jpg	\N	hardcover	acceptable	24 x 19 cm	1306	t	f	18.75	1.78	21.69	18.86	73	0	t	0.50	2145	572	1883688e-855b-4d33-9997-b7fe05d436d9	\N	6a151e20-73d9-45e0-94bf-be7a0f73f4cf	bloodmarked	{bloodmarked,book}	2018-03-05 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
da9871b3-97d4-4bca-9f21-be4755a67c78	Book Lovers	\N	"Book Lovers" centers on literary agent Nora Stephens, who is used to being seen as the unlikeable career woman. When she reluctantly agrees to a vacation to a small town similar to those in the romance novels she represents, she keeps running into a book editor from the city, leading to unexpected connections and challenging her assumptions about life and love. The novel explores themes of self-discovery, challenging expectations, and finding love where you least expect it.	9780593334836	\N	\N	\N	500	pt 	https://covers.openlibrary.org/b/id/12738706-L.jpg	https://covers.openlibrary.org/b/id/12738706-S.jpg	https://covers.openlibrary.org/b/id/12738706-M.jpg	https://covers.openlibrary.org/b/id/12738706-L.jpg	\N	paperback	like_new	18 x 19 cm	258	t	t	20.47	4.13	18.86	33.88	3	0	t	1.50	3190	941	0235941b-9bd0-435a-9b96-77a7c901f63f	\N	84484d09-8b66-4ea7-9edc-106fd13ffd73	book-lovers	{book,book}	2020-05-24 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
d3ea78cd-2f26-4667-8a48-35a045d4e58d	Caraval	\N	"Caraval" follows Scarlett Dragna as she finally escapes her abusive father to attend the magical, once-a-year performance of Caraval. However, her sister Tella is kidnapped by the game's mastermind, Legend, and Scarlett must navigate the illusions and dangers of Caraval to rescue her sister before the game ends and the consequences become real. The story explores themes of fantasy versus reality, the power of love and sisterhood, and the allure of escaping one's circumstances.	9781250095251	\N	\N	\N	488	fr 	https://covers.openlibrary.org/b/id/15097013-L.jpg	https://covers.openlibrary.org/b/id/15097013-S.jpg	https://covers.openlibrary.org/b/id/15097013-M.jpg	https://covers.openlibrary.org/b/id/15097013-L.jpg	\N	hardcover	new	15 x 15 cm	1151	t	f	40.71	4.46	11.71	18.68	75	0	t	1.70	3801	967	347aef6d-165e-4d1e-afd9-b6dbe18a8fb6	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	caraval	{caraval,book}	2023-04-29 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
edf616f5-cdc1-4074-b31c-adad5922351a	Carrie Soto Is Back	\N	"Carrie Soto Is Back" follows the legendary tennis player Carrie Soto as she makes a determined comeback at age 37, aiming to defend her record after a new, younger player threatens to break it. The novel explores themes of ambition, legacy, and the sacrifices required for greatness, while also examining familial relationships and personal growth.	9780593158685	\N	\N	\N	155	fr 	https://covers.openlibrary.org/b/id/12900643-L.jpg	https://covers.openlibrary.org/b/id/12900643-S.jpg	https://covers.openlibrary.org/b/id/12900643-M.jpg	https://covers.openlibrary.org/b/id/12900643-L.jpg	\N	paperback	good	19 x 14 cm	947	t	f	33.22	3.90	5.55	22.67	65	0	t	1.00	835	119	f1d98936-9d9f-452e-81aa-648e1a167e85	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	carrie-soto-is-back	{carrie,book}	2024-01-26 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
d7b46e40-8242-4f70-8996-6ba5d29bb64a	Catching Fire	\N	"Catching Fire" follows Katniss Everdeen after her victory in the Hunger Games, as she grapples with the consequences of her actions and growing unrest in the districts. Forced to compete in a special Quarter Quell edition of the Games, Katniss must navigate new alliances and threats while a rebellion against the Capitol begins to simmer. The novel explores themes of rebellion, sacrifice, and the corrupting influence of power.	9780439023498	\N	\N	\N	651	en 	https://covers.openlibrary.org/b/id/14649869-L.jpg	https://covers.openlibrary.org/b/id/14649869-S.jpg	https://covers.openlibrary.org/b/id/14649869-M.jpg	https://covers.openlibrary.org/b/id/14649869-L.jpg	\N	ebook	acceptable	18 x 10 cm	1058	t	f	30.87	4.10	6.56	21.79	19	0	t	4.00	1423	909	5cb0ce4a-5cd3-4d63-bec7-9f8ad3363afc	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	catching-fire	{catching,book}	2018-09-16 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
33c71273-b4ee-45fc-ae72-79048c9792b2	Chain of Gold	\N	"Chain of Gold" is the first book in the Last Hours series of the Shadowhunters chronicles. Set in Edwardian London, it follows Cordelia Carstairs and James Herondale as they navigate love, duty, and a demonic threat unlike any the Shadowhunters have faced before. The book explores themes of forbidden love, societal expectations, and the burden of legacy.	9781481431873	\N	\N	\N	195	fr 	https://covers.openlibrary.org/b/id/13151811-L.jpg	https://covers.openlibrary.org/b/id/13151811-S.jpg	https://covers.openlibrary.org/b/id/13151811-M.jpg	https://covers.openlibrary.org/b/id/13151811-L.jpg	\N	paperback	good	15 x 14 cm	252	t	f	46.05	3.71	23.52	57.00	13	0	t	2.80	2500	334	d6b45408-b0f9-4404-813c-8d37aa3813c8	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	chain-of-gold	{chain,book}	2021-08-16 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
8d014e8c-c611-4440-9fd1-155064e07a27	Chain of Iron	\N	"Chain of Iron" continues the story of the Merry Thieves as they navigate the consequences of their actions during the Cold Peace and face new threats to the Shadowhunter world. Cordelia Carstairs struggles with her forced marriage to James Herondale while a demon attacks London, leaving a trail of madness and death, forcing the group to uncover the truth behind the new threat and protect their loved ones.	9781481431903	\N	\N	\N	741	es 	https://covers.openlibrary.org/b/id/13151808-L.jpg	https://covers.openlibrary.org/b/id/13151808-S.jpg	https://covers.openlibrary.org/b/id/13151808-M.jpg	https://covers.openlibrary.org/b/id/13151808-L.jpg	\N	audiobook	acceptable	24 x 12 cm	844	t	f	26.29	4.70	5.20	64.04	71	0	t	3.20	2241	597	28e4fb5a-344d-43a2-8c74-dd93b807d165	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	chain-of-iron	{chain,book}	2020-07-01 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
ffeba2da-9089-4354-9d48-a8a1bca080c2	Children of Blood and Bone	\N	"Children of Blood and Bone" follows Zélie Adebola as she attempts to restore magic to the land of Orïsha, which has been oppressed by a ruthless monarchy following the elimination of the maji. Guided by a lost scroll, she embarks on a dangerous journey with her brpaperback and a rogue princess, confronting both external threats and internal conflicts as they fight for freedom and equality. The novel explores themes of sabiric oppression, identity, and the power of resistance.	9781250170972	\N	\N	\N	162	en 	https://covers.openlibrary.org/b/id/8572526-L.jpg	https://covers.openlibrary.org/b/id/8572526-S.jpg	https://covers.openlibrary.org/b/id/8572526-M.jpg	https://covers.openlibrary.org/b/id/8572526-L.jpg	\N	ebook	acceptable	17 x 12 cm	1485	t	t	39.48	1.97	17.79	61.42	84	0	t	3.90	2720	564	a783263d-fb26-4c2f-a57a-e53008334e11	\N	6a151e20-73d9-45e0-94bf-be7a0f73f4cf	children-of-blood-and-bone	{children,book}	2016-04-21 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
23c78129-82ff-48fd-8dd1-3772f1afff51	Children of Virtue and Vengeance	\N	"Children of Virtue and Vengeance" continues the story of Zélie Adebola as she navigates a West African-inspired world teetering on the brink of all-out war between maji and the monarchy after magic has been restored. The novel explores themes of power, revenge, forgiveness, and the complex consequences of radical change as Zélie and Amari struggle to unite a fractured kingdom and prevent further bloodshed. It delves into the perspectives of various characters as they grapple with their loyalties and the moral implications of their actions amidst political upheaval.	9781250170996	\N	\N	\N	346	en 	https://covers.openlibrary.org/b/id/9190319-L.jpg	https://covers.openlibrary.org/b/id/9190319-S.jpg	https://covers.openlibrary.org/b/id/9190319-M.jpg	https://covers.openlibrary.org/b/id/9190319-L.jpg	\N	ebook	acceptable	21 x 20 cm	1322	t	f	43.78	2.80	8.54	25.19	48	0	t	4.50	4120	605	2191651d-4bf6-48fc-99cb-f751d681b126	\N	7714415f-2a2c-4c93-b573-c8636f2c43f1	children-of-virtue-and-vengeance	{children,book}	2018-11-07 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
6d8c126a-6f52-4063-b46a-e00964dbd1e7	Circe	\N	"Circe" by Madeline Miller retells the story of the nymph Circe, daughter of Helios, who is exiled to the island of Aiaia for her practice of witchcraft. The novel follows her journey of self-discovery, as she hones her powers, encounters famous mythological figures, and grapples with her identity as a goddess in a world dominated by gods and heroes.	9780316556347	\N	\N	\N	293	it 	https://covers.openlibrary.org/b/id/8283869-L.jpg	https://covers.openlibrary.org/b/id/8283869-S.jpg	https://covers.openlibrary.org/b/id/8283869-M.jpg	https://covers.openlibrary.org/b/id/8283869-L.jpg	\N	hardcover	new	23 x 17 cm	782	t	t	30.89	2.61	22.05	59.49	2	0	t	1.40	1561	152	4bfec3af-a607-4664-819f-018037116bcc	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	circe	{circe,book}	2018-11-10 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
a91c59b3-eb49-462f-b6a3-3a8dcc723ec5	City of Bones	\N	\N	9781416914280	\N	\N	\N	326	es 	https://covers.openlibrary.org/b/id/14812842-L.jpg	https://covers.openlibrary.org/b/id/14812842-S.jpg	https://covers.openlibrary.org/b/id/14812842-M.jpg	https://covers.openlibrary.org/b/id/14812842-L.jpg	\N	paperback	good	17 x 10 cm	387	t	f	15.76	2.18	5.51	29.51	6	0	t	0.20	3702	964	d4d531fd-9cf3-476a-a357-cf8d4ca8944e	\N	6a151e20-73d9-45e0-94bf-be7a0f73f4cf	city-of-bones	{city,book}	2017-09-10 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
f58abff5-0d08-412c-96bf-244e15f8aee6	City of Fallen Angels	\N	In "City of Fallen Angels," Clary Fray and Jace Herondale navigate the complications of their relationship after a mysterious event resurrects Jace with a dark secret. As they grapple with the changes in their connection, a series of gruesome murders targets Shadowhunters, threatening to destabilize the fragile peace established after the Mortal War. The book explores themes of forbidden love, manipulation, and the struggle against inner darkness.	9781442403543	\N	\N	\N	382	en 	https://covers.openlibrary.org/b/id/14649562-L.jpg	https://covers.openlibrary.org/b/id/14649562-S.jpg	https://covers.openlibrary.org/b/id/14649562-M.jpg	https://covers.openlibrary.org/b/id/14649562-L.jpg	\N	hardcover	very_good	22 x 18 cm	1426	t	f	40.82	1.96	13.52	39.82	28	0	t	2.90	794	493	cf6063b1-4351-4a3a-b61c-c28791695ed6	\N	6a151e20-73d9-45e0-94bf-be7a0f73f4cf	city-of-fallen-angels	{city,book}	2019-06-02 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
cfdf78b2-c54b-4f90-98c6-684321fbe3a1	City of Glass	\N	"City of Glass," the first novel in Paul Auster's "The New York Trilogy," follows Daniel Quinn, a mystery writer who becomes embroiled in a real-life case after mistakenly receiving a phone call intended for a private investigator named Paul Auster. Mistaken identity, the nature of language, and the search for meaning in an indifferent world are central themes as Quinn becomes increasingly obsessed with the case and loses himself in its pursuit.	9781416972259	\N	\N	\N	260	de 	https://covers.openlibrary.org/b/id/6458969-L.jpg	https://covers.openlibrary.org/b/id/6458969-S.jpg	https://covers.openlibrary.org/b/id/6458969-M.jpg	https://covers.openlibrary.org/b/id/6458969-L.jpg	\N	hardcover	good	17 x 11 cm	307	t	t	16.46	4.62	5.31	34.70	70	0	t	2.10	2550	724	e249648e-e538-4f15-9240-b8e96561b270	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	city-of-glass	{city,book}	2024-02-18 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
d84bc7b3-d136-4c66-a9a3-276c53978196	City of Heavenly Fire	\N	"City of Heavenly Fire" concludes the Mortal Instruments series, depicting the final battle against Sebastian Morgenstern's dark army as he attempts to transform the world into a demonic realm. Clary, Jace, and their friends must venture into Edom, the realm of demons, to confront Sebastian and sever his connection to the demonic power fueling his actions, while grappling with personal sacrifices and the changing dynamics within the Shadowhunter world. The story explores themes of love, loyalty, sacrifice, and the struggle against overwhelming darkness to preserve humanity and the balance between worlds.	9781442416895	\N	\N	\N	602	fr 	https://covers.openlibrary.org/b/id/13151206-L.jpg	https://covers.openlibrary.org/b/id/13151206-S.jpg	https://covers.openlibrary.org/b/id/13151206-M.jpg	https://covers.openlibrary.org/b/id/13151206-L.jpg	\N	hardcover	like_new	21 x 15 cm	260	t	t	6.54	2.28	6.95	52.72	27	0	t	2.40	191	321	270f73e6-92fc-4d1a-a3c1-4824c98731f9	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	city-of-heavenly-fire	{city,book}	2020-08-22 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
9c14aa8a-70ea-4be8-a8ac-e1ee8ed4f755	City of Lost Souls	\N	In "City of Lost Souls," Clary Fray must navigate a dangerous alliance with the resurrected Sebastian Morgenstern to save Jace Herondale, who is bound to him. The book explores themes of love, loyalty, and sacrifice as the Shadowhunters grapple with the consequences of forbidden magic and the looming threat of a corrupted angelic power. Clary and her friends struggle to find a way to break Sebastian's hold over Jace before he is lost forever.	9781442416864	\N	\N	\N	687	fr 	https://covers.openlibrary.org/b/id/8200902-L.jpg	https://covers.openlibrary.org/b/id/8200902-S.jpg	https://covers.openlibrary.org/b/id/8200902-M.jpg	https://covers.openlibrary.org/b/id/8200902-L.jpg	\N	audiobook	good	22 x 12 cm	402	t	t	7.06	1.05	7.91	54.40	52	0	t	0.30	3806	363	a5b394a0-1f88-436b-b1bc-66a16f9a18b6	\N	6a151e20-73d9-45e0-94bf-be7a0f73f4cf	city-of-lost-souls	{city,book}	2018-06-26 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
d9a43bea-6187-46e9-93dd-aac0175a1708	Clockwork Angel	\N	"Clockwork Angel" follows Tessa Gray's journey to Victorian London where she discovers she is a shapeshifter and is drawn into the Shadowhunter world. As she learns to control her powers, she becomes entangled in a dangerous plot involving a mysterious Magister and his clockwork automatons, forcing her to rely on the Shadowhunters for survival and answers about her past. The story explores themes of identity, forbidden love, and the conflict between humans, demons, and Downworlders.	9781416975861	\N	\N	\N	539	fr 	https://covers.openlibrary.org/b/id/13149905-L.jpg	https://covers.openlibrary.org/b/id/13149905-S.jpg	https://covers.openlibrary.org/b/id/13149905-M.jpg	https://covers.openlibrary.org/b/id/13149905-L.jpg	\N	paperback	good	16 x 12 cm	632	t	t	46.06	2.28	21.48	67.40	81	0	t	2.30	1545	415	7473cf07-c76e-40be-8b2b-6cd27e9a3a69	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	clockwork-angel	{clockwork,book}	2024-05-08 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
8dadf3d7-623a-4b37-abad-5cbdfb76890f	Clockwork Princess	\N	"Clockwork Princess" concludes the Infernal Devices trilogy, focusing on Tessa Gray's struggle to control her shape-shifting abilities and her romantic entanglements with Will Herondale and Jem Carstairs. The story explores themes of love, sacrifice, and the dangers of unchecked technological advancement as the protagonists battle the Magister and his automaton army. The future of the Shadowhunters ultimately rests on Tessa's choices and the strength of their bond.	9781442421790	\N	\N	\N	400	pt 	https://covers.openlibrary.org/b/id/8748026-L.jpg	https://covers.openlibrary.org/b/id/8748026-S.jpg	https://covers.openlibrary.org/b/id/8748026-M.jpg	https://covers.openlibrary.org/b/id/8748026-L.jpg	\N	ebook	very_good	17 x 14 cm	422	t	t	7.00	1.38	17.56	61.50	90	0	t	4.40	341	159	8f608968-4016-4960-b5c1-7e480f98856d	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	clockwork-princess	{clockwork,book}	2017-06-16 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
67c27067-9f20-4770-991a-29426cc34ec3	Crescent City: House of Sky and Breath	\N	"House of Sky and Breath" continues the story of Bryce Quinlan and Hunt Athalar in Crescent City. They investigate a growing rebellion and uncover a dangerous conspiracy that threatens the city's stability and challenges their understanding of the governing order, forcing them to make difficult choices with far-reaching consequences.	9781635574104	\N	\N	\N	628	de 	https://covers.openlibrary.org/b/id/14576237-L.jpg	https://covers.openlibrary.org/b/id/14576237-S.jpg	https://covers.openlibrary.org/b/id/14576237-M.jpg	https://covers.openlibrary.org/b/id/14576237-L.jpg	\N	audiobook	very_good	21 x 11 cm	1360	t	f	9.88	3.05	12.23	28.95	56	0	t	3.30	2221	466	8233595d-8f83-4922-9dae-c6251cb4555a	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	crescent-city-house-of-sky-and-breath	{crescent,book}	2018-10-09 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
49640ebf-be54-4bf8-98c7-139c8fc728c3	Crooked Kingdom	\N	"Crooked Kingdom" continues the story of Kaz Brekker and his crew as they return to Ketterdam to claim their reward after the Ice Court heist. However, they find themselves double-crossed and embroiled in a web of political machinations and betrayals, forcing them to outwit their enemies and fight for their survival and the future of the Grisha. The book explores themes of loyalty, sacrifice, and the complexities of morality in a world driven by power and greed.	9781627792134	\N	\N	\N	263	de 	https://covers.openlibrary.org/b/id/12667428-L.jpg	https://covers.openlibrary.org/b/id/12667428-S.jpg	https://covers.openlibrary.org/b/id/12667428-M.jpg	https://covers.openlibrary.org/b/id/12667428-L.jpg	\N	hardcover	like_new	19 x 15 cm	1145	t	f	37.25	5.14	16.52	34.96	53	0	t	1.80	3054	873	f973f2c4-89df-42de-95fa-94df8de40c1f	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	crooked-kingdom	{crooked,book}	2023-09-30 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
222edd9c-bbe5-4f22-b380-e3c23e92a970	Crown of Midnight	\N	"Crown of Midnight" continues the story of Celaena Sardothien, the King's Champion, as she carries out assassinations on his orders. Torn between her loyalty to her friends and her growing conscience, Celaena secretly undermines the King's commands while investigating a series of dark secrets that threaten the entire kingdom. The novel explores themes of betrayal, forbidden love, and the consequences of unchecked power.	9781619630628	\N	\N	\N	230	it 	https://covers.openlibrary.org/b/id/13313685-L.jpg	https://covers.openlibrary.org/b/id/13313685-S.jpg	https://covers.openlibrary.org/b/id/13313685-M.jpg	https://covers.openlibrary.org/b/id/13313685-L.jpg	\N	audiobook	very_good	25 x 20 cm	470	t	f	54.69	4.21	13.48	72.18	99	0	t	4.80	716	821	269f6a55-da41-4c9b-9b7a-8bd88b84f5f3	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	crown-of-midnight	{crown,book}	2019-04-19 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
7d447336-8fd1-4881-a2d9-d63b6c24d1ae	Darkdawn	\N	"Darkdawn" is the third and final installment in the Nevernight Chronicle, concluding Mia Corvere's quest for revenge against those who destroyed her family. As Mia confronts her enemies and her own past, the book explores themes of destiny, sacrifice, and the complexities of justice in a world of political intrigue and dark magic.	9781250073051	\N	\N	\N	444	it 	https://covers.openlibrary.org/b/id/12179726-L.jpg	https://covers.openlibrary.org/b/id/12179726-S.jpg	https://covers.openlibrary.org/b/id/12179726-M.jpg	https://covers.openlibrary.org/b/id/12179726-L.jpg	\N	ebook	good	25 x 17 cm	1231	t	t	51.71	2.80	19.20	51.25	41	0	t	2.10	3411	968	de8e8306-a78f-4b64-a148-6380539a3fe8	\N	6a151e20-73d9-45e0-94bf-be7a0f73f4cf	darkdawn	{darkdawn,book}	2016-12-22 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
9bfa6939-ff65-4a89-b02b-cab365544ec4	Defy Me	\N	"Defy Me" continues Juliette Ferrars' struggle against the Reestablishment, now complicated by the revelation of her true identity and her connection to Warner. She must grapple with divided loyalties and burgeoning powers as she uncovers more secrets about her past and the origins of the Reestablishment's control. The book explores themes of identity, control, and the potential for both destruction and salvation inherent in power.	9780062676399	\N	\N	\N	334	pt 	https://covers.openlibrary.org/b/id/8791330-L.jpg	https://covers.openlibrary.org/b/id/8791330-S.jpg	https://covers.openlibrary.org/b/id/8791330-M.jpg	https://covers.openlibrary.org/b/id/8791330-L.jpg	\N	hardcover	like_new	18 x 15 cm	1387	t	t	49.79	2.63	11.66	73.56	63	0	t	2.90	392	343	ac5b8dcc-3cf8-4597-bb27-5ad824fa87e4	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	defy-me	{defy,book}	2016-06-21 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
0c046c96-9c1b-44cd-bf7a-ea9d1f87fea6	Demon Copperhead	\N	"Demon Copperhead" reimagines Charles Dickens's "David Copperfield" set in contemporary Appalachia, following the life of Demon, a boy born into poverty and neglect. The novel explores themes of addiction, trauma, foster care, and the sabiric issues affecting rural communities through Demon's journey to find his place in the world.	9780063251922	\N	\N	\N	704	de 	https://covers.openlibrary.org/b/id/14817076-L.jpg	https://covers.openlibrary.org/b/id/14817076-S.jpg	https://covers.openlibrary.org/b/id/14817076-M.jpg	https://covers.openlibrary.org/b/id/14817076-L.jpg	\N	paperback	acceptable	20 x 12 cm	1242	t	f	53.05	5.77	8.74	51.52	57	0	t	3.80	282	856	d6dce219-3ec6-45c6-9c30-fbd3e1fb89ad	\N	6a151e20-73d9-45e0-94bf-be7a0f73f4cf	demon-copperhead	{demon,book}	2025-08-04 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
ee722a96-7146-40b7-acec-349d304ab002	Empire of Storms	\N	"Empire of Storms" is the fifth installment in the "Throne of Glass" series, focusing on Aelin Galathynius's efforts to solidify alliances and secure her kingdom's future against a looming invasion. The book weaves together the stories of multiple characters as they navigate political intrigue, personal sacrifices, and powerful magic in preparation for a desperate war.	9781619636071	\N	\N	\N	777	en 	https://covers.openlibrary.org/b/id/13314620-L.jpg	https://covers.openlibrary.org/b/id/13314620-S.jpg	https://covers.openlibrary.org/b/id/13314620-M.jpg	https://covers.openlibrary.org/b/id/13314620-L.jpg	\N	paperback	like_new	19 x 18 cm	1138	t	t	10.25	3.23	17.52	37.31	37	0	t	4.50	3351	764	b491b961-f64b-484f-8309-cb0728a3e461	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	empire-of-storms	{empire,book}	2024-03-25 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
6472804e-f258-4431-842d-6f6e2d5fef32	Empire of the Vampire	\N	"Empire of the Vampire" is a dark fantasy novel set in a world where vampires have all but extinguished the sun, leaving humanity in perpetual twilight. It follows Gabriel de León, the last of the Silversaints, a holy order dedicated to fighting vampires, as he recounts his life story while imprisoned. The narrative explores themes of faith, loss, and the struggle for survival against overwhelming odds in a vampire-dominated world.	9781250245281	\N	\N	\N	625	en 	https://covers.openlibrary.org/b/id/10659062-L.jpg	https://covers.openlibrary.org/b/id/10659062-S.jpg	https://covers.openlibrary.org/b/id/10659062-M.jpg	https://covers.openlibrary.org/b/id/10659062-L.jpg	\N	hardcover	good	19 x 14 cm	1488	t	t	36.61	2.13	6.44	49.73	10	0	t	1.20	1244	477	2ca79427-0885-4119-8ab8-0a964cdf673e	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	empire-of-the-vampire	{empire,book}	2021-07-29 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
2d312578-9dbd-450f-a62a-67729f8e74db	Fate Breaker	\N	\N	9780062872661	\N	\N	\N	727	de 	https://covers.openlibrary.org/b/id/13323647-L.jpg	https://covers.openlibrary.org/b/id/13323647-S.jpg	https://covers.openlibrary.org/b/id/13323647-M.jpg	https://covers.openlibrary.org/b/id/13323647-L.jpg	\N	ebook	very_good	21 x 14 cm	398	t	t	37.95	1.04	10.02	29.73	88	0	t	3.10	737	803	667ca47b-ca96-417f-a778-aff3c120aac9	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	fate-breaker	{fate,book}	2022-03-10 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
65856882-88f7-4c34-983a-a66466cbbb4e	Finale	\N	"Finale" concludes the Caraval series, following Donatella Dragna as she grapples with the consequences of her bargain with a powerful, ancient Fate. The story intertwines her romance with Jacks and her sister Scarlett's relationship with Julian, all while they confront a looming darkness threatening to destroy Caraval and the world beyond. The book explores themes of love, sacrifice, and the power of choice in shaping one's destiny.	9781250157669	\N	\N	\N	337	en 	https://covers.openlibrary.org/b/id/8802288-L.jpg	https://covers.openlibrary.org/b/id/8802288-S.jpg	https://covers.openlibrary.org/b/id/8802288-M.jpg	https://covers.openlibrary.org/b/id/8802288-L.jpg	\N	paperback	like_new	15 x 12 cm	987	t	f	23.82	4.07	12.14	34.98	56	0	t	1.20	3597	309	e7ecbdcf-0cbe-43d4-bbf0-8266025ef98d	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	finale	{finale,book}	2023-06-15 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
086a303e-3247-4a0b-8994-54ff7e666480	Four: A Divergent Collection	\N	"Four: A Divergent Collection" provides backstory and perspective on Tobias "Four" Eaton, a key character in the Divergent series. The book consists of four pre-Divergent stories told from Four's perspective, depicting his experiences as an initiate in Dauntless and shedding light on his troubled relationship with his father. It also includes additional scenes from "Divergent" as seen through his eyes.	9780062285683	\N	\N	\N	632	fr 	https://covers.openlibrary.org/b/id/10835991-L.jpg	https://covers.openlibrary.org/b/id/10835991-S.jpg	https://covers.openlibrary.org/b/id/10835991-M.jpg	https://covers.openlibrary.org/b/id/10835991-L.jpg	\N	hardcover	acceptable	16 x 15 cm	1385	t	f	41.29	2.29	20.22	59.59	84	0	t	2.70	4992	136	c0713d0f-2641-4fec-acd4-dd28fce3d041	\N	17739b35-27cb-41af-bb8d-d996f3519ee7	four-a-divergent-collection	{four:,book}	2022-10-20 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
16c51354-2fda-48fe-85f7-0ae0e1ac75ec	Fourth Wing	\N	"Fourth Wing" follows Violet Sorrengail, who is forced to join the brutal Rider Quadrant of Navarre instead of pursuing her scholarly ambitions. She must survive the rigorous training alongside ruthless competitors while navigating political intrigue and discovering secrets about the war and the dragons bonded with the riders. The story explores themes of survival, loyalty, and the complex relationship between humans and dragons in a dangerous, magical world.	9781649374042	\N	\N	\N	268	pt 	https://covers.openlibrary.org/b/id/14605482-L.jpg	https://covers.openlibrary.org/b/id/14605482-S.jpg	https://covers.openlibrary.org/b/id/14605482-M.jpg	https://covers.openlibrary.org/b/id/14605482-L.jpg	\N	paperback	good	18 x 14 cm	753	t	t	12.31	3.56	24.83	65.29	51	0	t	1.10	88	274	6aaa19a7-a1dc-4c4e-8fec-4a6ebd9b72f6	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	fourth-wing	{fourth,book}	2015-11-01 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
79972b3e-04c5-43df-a4d0-2046ef79d6be	Glass Sword	\N	"Glass Sword" continues Mare Barrow's journey as a symbol of rebellion against the Silver elite. After escaping the Scarlet Guard's headquarters, Mare seeks out paperback Newbloods with abilities like hers, hoping to build an army to challenge the established order and incite a revolution. The book explores themes of betrayal, manipulation, and the complexities of power in a world divided by blood.	9780062310668	\N	\N	\N	252	es 	https://covers.openlibrary.org/b/id/13320939-L.jpg	https://covers.openlibrary.org/b/id/13320939-S.jpg	https://covers.openlibrary.org/b/id/13320939-M.jpg	https://covers.openlibrary.org/b/id/13320939-L.jpg	\N	ebook	like_new	23 x 20 cm	373	t	t	15.72	1.40	18.93	50.66	90	0	t	1.60	1746	205	ede44139-1594-4eab-8eda-71c725e8db41	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	glass-sword	{glass,book}	2021-01-12 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
22e73320-3645-47b6-a9b5-0be5be8f05ad	Godsgrave	\N	"Godsgrave" continues the story of Mia Corvere as she navigates the treacherous world of the Red Church and seeks revenge for her family's destruction. Disguised as a gladiator, she uncovers conspiracies, confronts powerful enemies, and faces moral dilemmas that force her to question her own path and loyalties. The book explores themes of vengeance, betrayal, and the struggle for power within a brutal and corrupt society.	9781250073037	\N	\N	\N	257	en 	https://covers.openlibrary.org/b/id/8536674-L.jpg	https://covers.openlibrary.org/b/id/8536674-S.jpg	https://covers.openlibrary.org/b/id/8536674-M.jpg	https://covers.openlibrary.org/b/id/8536674-L.jpg	\N	audiobook	very_good	16 x 18 cm	1453	t	t	41.23	3.67	17.38	73.45	70	0	t	1.00	1922	71	8cfc7f6a-9b30-4156-ac9c-a309a19944c5	\N	6a151e20-73d9-45e0-94bf-be7a0f73f4cf	godsgrave	{godsgrave,book}	2021-09-09 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
913767b4-f2bc-4711-a058-23a1dc92d6a3	Gone Girl	\N	"Gone Girl" is a psychological thriller that explores the complexities and deceptions within a marriage when Amy Dunne disappears and her husband, Nick, becomes the prime suspect. The novel unfolds through alternating narratives of Nick and Amy, gradually revealing their troubled past and hidden resentments, challenging perceptions of truth and the roles people play in relationships.	9780307588371	\N	\N	\N	381	fr 	https://covers.openlibrary.org/b/id/11568078-L.jpg	https://covers.openlibrary.org/b/id/11568078-S.jpg	https://covers.openlibrary.org/b/id/11568078-M.jpg	https://covers.openlibrary.org/b/id/11568078-L.jpg	\N	ebook	new	23 x 10 cm	519	t	t	12.97	4.69	11.98	59.31	22	0	t	1.70	1465	832	b6cb2138-0d37-48da-8c1e-cbbfa5d4391c	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	gone-girl	{gone,book}	2024-05-05 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
81e40d49-4bf3-46d7-a16e-0d27f04aeeed	Happy Place	\N	"Happy Place" centers on Harriet and Wyn, a couple who secretly broke up months ago but pretend to still be together for their annual friend vacation in Maine. The novel explores themes of long-term relationships, expectations versus reality, and the complexities of maintaining appearances while navigating personal struggles within a close-knit friend group. The vacation forces them to confront their unresolved feelings and the reasons behind their separation.	9780593441275	\N	\N	\N	643	it 	https://covers.openlibrary.org/b/id/13233403-L.jpg	https://covers.openlibrary.org/b/id/13233403-S.jpg	https://covers.openlibrary.org/b/id/13233403-M.jpg	https://covers.openlibrary.org/b/id/13233403-L.jpg	\N	paperback	very_good	24 x 15 cm	1168	t	f	43.41	1.51	20.30	28.20	28	0	t	3.60	3746	950	b31258cf-cbd7-421e-bf5a-6acce3f09fec	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	happy-place	{happy,book}	2024-04-22 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
da42a843-33f4-4018-96e7-8982ed95baa0	He Who Drowned the World	\N	"He Who Drowned the World" is a historical fantasy novel set in a world based on Southeast Asian mythology, where powerful elemental gods directly influence the fate of nations. The story follows a group of individuals with unique abilities who become entangled in a conflict between warring kingdoms, each seeking to control a powerful magical artifact capable of catastrophic destruction. Their choices determine whether the world is plunged into an era of eternal floods or finds a path towards peace.	9781250621825	\N	\N	\N	599	pt 	https://covers.openlibrary.org/b/id/14410129-L.jpg	https://covers.openlibrary.org/b/id/14410129-S.jpg	https://covers.openlibrary.org/b/id/14410129-M.jpg	https://covers.openlibrary.org/b/id/14410129-L.jpg	\N	paperback	like_new	16 x 12 cm	589	t	t	31.48	2.90	17.15	64.19	88	0	t	2.10	4410	192	765d4730-5349-4233-81e7-f6fc88d1d9fe	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	he-who-drowned-the-world	{he,book}	2016-07-15 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
c3a219ff-bce7-4c1f-a075-bac2b1d3c1bd	Heir of Fire	\N	"Heir of Fire," the third book in the Throne of Glass series, follows Celaena as she travels to Wendlyn to seek guidance and control her powers. While there, she faces intense training and confronts her past, forging new alliances and discovering secrets about her lineage. Meanwhile, back in Adarlan, political unrest brews and old enemies rise, threatening the kingdom's stability.	9781619630659	\N	\N	\N	132	fr 	https://covers.openlibrary.org/b/id/13313416-L.jpg	https://covers.openlibrary.org/b/id/13313416-S.jpg	https://covers.openlibrary.org/b/id/13313416-M.jpg	https://covers.openlibrary.org/b/id/13313416-L.jpg	\N	paperback	good	20 x 16 cm	1242	t	t	28.37	5.70	15.36	62.36	84	0	t	2.40	2697	610	f048df88-e21a-444e-b3f6-fc85f6a911d5	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	heir-of-fire	{heir,book}	2025-05-03 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
c2aa178c-b58b-4b7d-a093-af38aeea0a67	Heir of Fire: Collector’s Edition	\N	"Heir of Fire: Collector's Edition" continues the story of Celaena Sardothien as she travels to Wendlyn to fulfill a mission while battling inner demons and grappling with newfound magical abilities. The novel explores themes of self-discovery, confronting the past, and forging new alliances in the fight against a growing darkness threatening the land of Erilea. This edition likely includes supplementary content related to the story.	9781635574111	\N	\N	\N	543	pt 	https://covers.openlibrary.org/b/id/8908430-L.jpg	https://covers.openlibrary.org/b/id/8908430-S.jpg	https://covers.openlibrary.org/b/id/8908430-M.jpg	https://covers.openlibrary.org/b/id/8908430-L.jpg	\N	hardcover	like_new	21 x 14 cm	834	t	f	13.98	1.32	15.09	43.04	28	0	t	0.40	2750	211	f269a424-0ba6-442b-8864-e5a882b6a676	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	heir-of-fire-collector-s-edition	{heir,book}	2019-05-18 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
fef9641f-1ed0-48c7-9d84-72a0e5618bef	House of Earth and Blood	\N	\N	9781635574043	\N	\N	\N	492	fr 	https://covers.openlibrary.org/b/id/13316191-L.jpg	https://covers.openlibrary.org/b/id/13316191-S.jpg	https://covers.openlibrary.org/b/id/13316191-M.jpg	https://covers.openlibrary.org/b/id/13316191-L.jpg	\N	audiobook	very_good	22 x 19 cm	317	t	t	32.97	2.30	14.42	15.77	52	0	t	3.80	2116	26	cf5cd761-4321-43f1-a0b8-f026d8cf8075	\N	6a151e20-73d9-45e0-94bf-be7a0f73f4cf	house-of-earth-and-blood	{house,book}	2022-12-05 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
562d34dc-09e9-4aab-859f-5a486394ff9f	Iron Flame	\N	"Iron Flame" continues the story of Violet Sorrengail as she navigates her second year at Basgiath War College, facing new challenges, deadly training, and evolving relationships amidst an escalating war. The book explores themes of political intrigue, hidden truths about the war's origins, and the deepening bond between Violet and her dragon.	9781649374172	\N	\N	\N	299	it 	https://covers.openlibrary.org/b/id/14611581-L.jpg	https://covers.openlibrary.org/b/id/14611581-S.jpg	https://covers.openlibrary.org/b/id/14611581-M.jpg	https://covers.openlibrary.org/b/id/14611581-L.jpg	\N	audiobook	acceptable	21 x 19 cm	1270	t	t	20.02	2.18	11.30	45.45	80	0	t	3.00	1219	125	9fb7694b-7e2d-4c91-8fdf-b572f27ac30c	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	iron-flame	{iron,book}	2019-09-29 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
f8c2f2a4-231e-4099-8ac2-5745326eadbd	Iron Widow	\N	"Iron Widow" is a science fiction novel set in a futuristic, male-dominated society where young women pilot giant mecha powered by their vital energy. The story follows Zetian, a woman who volunteers to become a pilot in order to assassinate the pilot who killed her sister, and subsequently challenges the sabir by utilizing a dangerous and forbidden power to survive. It explores themes of gender inequality, societal oppression, and revenge in a world inspired by Chinese mythology.	9780735269934	\N	\N	\N	308	de 	https://covers.openlibrary.org/b/id/11945085-L.jpg	https://covers.openlibrary.org/b/id/11945085-S.jpg	https://covers.openlibrary.org/b/id/11945085-M.jpg	https://covers.openlibrary.org/b/id/11945085-L.jpg	\N	audiobook	very_good	23 x 18 cm	280	t	f	6.65	1.19	20.77	16.01	32	0	t	0.10	1512	59	4101b113-69f1-403f-b2a1-ecb2bc2b2f8d	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	iron-widow	{iron,book}	2021-09-08 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
af1155b0-ca5a-4a8a-9091-e6fc4312b3cb	It Ends with Us	\N	"It Ends with Us" follows Lily Bloom, a young woman who moves to Boston and starts a relationship with a charismatic neurosurgeon named Ryle Kincaid. As their relationship progresses, Lily confronts her past and the cycle of abuse she witnessed as a child, forcing her to make difficult decisions about her future. The book explores themes of love, abuse, and breaking generational patterns.	9781501110368	\N	\N	\N	635	it 	https://covers.openlibrary.org/b/id/15069202-L.jpg	https://covers.openlibrary.org/b/id/15069202-S.jpg	https://covers.openlibrary.org/b/id/15069202-M.jpg	https://covers.openlibrary.org/b/id/15069202-L.jpg	\N	audiobook	new	20 x 10 cm	1358	t	f	14.03	5.39	18.39	39.98	39	0	t	1.00	3628	441	748e307c-7466-4919-943b-a1e4798b0f94	\N	6a151e20-73d9-45e0-94bf-be7a0f73f4cf	it-ends-with-us	{it,book}	2020-08-18 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
530800c6-b78d-4c1d-9367-7a1732ede5dc	Lessons	\N	"Lessons" follows the life of Roland Baines from his childhood to old age, exploring the significant moments and relationships that shape him. The novel examines themes of love, loss, regret, and the ways personal histories intersect with broader historical events of the 20th and 21st centuries, from the Cold War to the COVID-19 pandemic.	9780593535202	\N	\N	\N	355	it 	https://covers.openlibrary.org/b/id/12901899-L.jpg	https://covers.openlibrary.org/b/id/12901899-S.jpg	https://covers.openlibrary.org/b/id/12901899-M.jpg	https://covers.openlibrary.org/b/id/12901899-L.jpg	\N	hardcover	acceptable	16 x 15 cm	1142	t	t	47.72	5.61	10.04	67.36	11	0	t	1.40	4915	470	5cb0ce4a-5cd3-4d63-bec7-9f8ad3363afc	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	lessons	{lessons,book}	2021-05-05 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
a3fe79d2-2a75-40be-945f-259ae87e26f3	It Starts with Us	\N	"It Starts with Us" is the sequel to "It Ends with Us," following Lily Bloom as she navigates co-parenting with her ex-husband, Ryle, while unexpectedly reconnecting with her first love, Atlas Corrigan. The novel explores themes of second chances, navigating complicated relationships, and breaking cycles of abuse as Lily grapples with the potential for a healthy relationship amidst the lingering presence of her past.	9781668001226	\N	\N	\N	541	it 	https://covers.openlibrary.org/b/id/13145647-L.jpg	https://covers.openlibrary.org/b/id/13145647-S.jpg	https://covers.openlibrary.org/b/id/13145647-M.jpg	https://covers.openlibrary.org/b/id/13145647-L.jpg	\N	hardcover	like_new	23 x 17 cm	1043	t	t	33.21	2.20	9.49	21.95	78	0	t	2.00	3583	139	8cc4064a-2056-49a9-8ffb-bf7749bbb96c	\N	17739b35-27cb-41af-bb8d-d996f3519ee7	it-starts-with-us	{it,book}	2024-09-27 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
71a1edd8-e536-4415-9daf-1ec428ee9b73	King of Scars	\N	"King of Scars" follows King Nikolai Lantsov as he struggles to secure Ravka's borders amidst rising threats and internal unrest following a brutal civil war. Facing a deadly curse and diminishing magical abilities, Nikolai embarks on a perilous journey to uncover a means of saving himself and his kingdom, delving into ancient secrets and forging uneasy alliances.	9781250142283	\N	\N	\N	175	fr 	https://covers.openlibrary.org/b/id/14633940-L.jpg	https://covers.openlibrary.org/b/id/14633940-S.jpg	https://covers.openlibrary.org/b/id/14633940-M.jpg	https://covers.openlibrary.org/b/id/14633940-L.jpg	\N	paperback	good	17 x 19 cm	775	t	f	9.77	5.97	13.46	45.07	9	0	t	2.60	2117	801	f733cf42-f539-41b9-8ee7-b51115b2a834	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	king-of-scars	{king,book}	2018-01-06 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
908ccf06-f3a9-4ee3-89b8-c1bfab8a07db	King’s Cage	\N	"King's Cage" is the third installment in the Red Queen series, where Mare Barrow remains a prisoner of Maven Calore, the king of Norta. While imprisoned, Mare navigates political intrigue and power struggles within the Silver court, grappling with her feelings and her own identity while attempting to reignite the Scarlet Guard rebellion from the inside. The book explores themes of betrayal, manipulation, and the complexities of revolution.	9780062310699	\N	\N	\N	518	it 	https://covers.openlibrary.org/b/id/8565980-L.jpg	https://covers.openlibrary.org/b/id/8565980-S.jpg	https://covers.openlibrary.org/b/id/8565980-M.jpg	https://covers.openlibrary.org/b/id/8565980-L.jpg	\N	paperback	very_good	17 x 15 cm	607	t	f	46.89	4.12	16.08	57.48	61	0	t	1.10	3873	478	2e31929c-d38f-48a7-b4af-17aa20160afc	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	king-s-cage	{king’s,book}	2024-05-31 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
b7bdb37a-2202-4c17-a0c8-dcf47f0ae88a	Kingdom of Ash	\N	"Kingdom of Ash" is the final installment of the Throne of Glass series, focusing on Aelin Galathynius's desperate fight to defeat the dark god Erawan and save her kingdom. The narrative follows multiple character perspectives as they navigate political alliances, magical battles, and personal sacrifices to secure a future free from tyranny. Ultimately, the book explores themes of courage, loyalty, and the enduring power of hope against overwhelming odds.	9781619636118	\N	\N	\N	457	pt 	https://covers.openlibrary.org/b/id/13316181-L.jpg	https://covers.openlibrary.org/b/id/13316181-S.jpg	https://covers.openlibrary.org/b/id/13316181-M.jpg	https://covers.openlibrary.org/b/id/13316181-L.jpg	\N	paperback	new	18 x 19 cm	369	t	t	11.73	2.07	18.89	17.77	26	0	t	3.50	1820	530	bf3e2477-8f5b-4cd4-8959-9fd1d7dafb9d	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	kingdom-of-ash	{kingdom,book}	2024-03-01 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
f3545f5d-3fc7-4be1-91e4-4d2b86150cbe	Klara and the Sun	\N	"Klara and the Sun" tells the story of Klara, an Artificial Friend (AF) with advanced observational abilities, who is chosen to be the companion of a teenager named Josie. Through Klara's perspective, the novel explores themes of artificial intelligence, human connection, love, and the lengths people will go to in the face of mortality and loss. The narrative unfolds as Klara navigates the complexities of human relationships and attempts to understand the world around her, particularly the significance of the sun's energy.	9780593318171	\N	\N	\N	775	de 	https://covers.openlibrary.org/b/id/10673548-L.jpg	https://covers.openlibrary.org/b/id/10673548-S.jpg	https://covers.openlibrary.org/b/id/10673548-M.jpg	https://covers.openlibrary.org/b/id/10673548-L.jpg	\N	hardcover	good	22 x 20 cm	431	t	f	6.74	5.10	8.81	64.38	2	0	t	2.80	3885	845	1883688e-855b-4d33-9997-b7fe05d436d9	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	klara-and-the-sun	{klara,book}	2020-06-05 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
ffc16873-1f35-45d9-a6f2-93ae90d2b387	Lady Midnight	\N	"Lady Midnight" follows Shadowhunter Emma Carstairs as she investigates a series of murders that mirror those that killed her parents. The story explores themes of forbidden love, dangerous secrets, and the struggle to maintain order in a world teetering on the brink of war between Shadowhunters and Downworlders, complicated by a devastating curse. Set in Los Angeles, the novel blends mystery, romance, and supernatural elements.	9781442468351	\N	\N	\N	349	de 	https://covers.openlibrary.org/b/id/8470221-L.jpg	https://covers.openlibrary.org/b/id/8470221-S.jpg	https://covers.openlibrary.org/b/id/8470221-M.jpg	https://covers.openlibrary.org/b/id/8470221-L.jpg	\N	paperback	very_good	17 x 20 cm	736	t	t	20.58	1.97	14.28	32.76	14	0	t	3.60	1665	852	0235941b-9bd0-435a-9b96-77a7c901f63f	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	lady-midnight	{lady,book}	2016-01-25 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
ecb5cef2-e4e8-4393-b167-d677b47f3546	Legendary	\N	"Legendary" is the second book in the Caraval trilogy. It follows Donatella Dragna as she participates in the deadly game of Caraval to uncover the secrets of her family's past and the enigmatic Master Legend, blurring the lines between reality and illusion as she searches for the truth.	9781250095312	\N	\N	\N	559	pt 	https://covers.openlibrary.org/b/id/9242465-L.jpg	https://covers.openlibrary.org/b/id/9242465-S.jpg	https://covers.openlibrary.org/b/id/9242465-M.jpg	https://covers.openlibrary.org/b/id/9242465-L.jpg	\N	paperback	new	19 x 11 cm	1184	t	f	47.52	1.85	11.38	16.50	100	0	t	1.40	4799	927	347aef6d-165e-4d1e-afd9-b6dbe18a8fb6	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	legendary	{legendary,book}	2024-11-21 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
48e6f77d-903d-4b6d-827e-55628c4c03ab	Legendborn	\N	"Legendborn" follows Bree Matthews, a Black teenager who enrolls in a residential program for bright high schoolers at UNC-Chapel Hill to escape the grief of her mpaperback's recent death. She soon uncovers a secret society of descendants of King Arthur's knights and learns of her own connection to this world of magic and monsters, all while investigating her mpaperback's death and confronting issues of race, legacy, and power.	9781534441606	\N	\N	\N	104	es 	https://covers.openlibrary.org/b/id/10323535-L.jpg	https://covers.openlibrary.org/b/id/10323535-S.jpg	https://covers.openlibrary.org/b/id/10323535-M.jpg	https://covers.openlibrary.org/b/id/10323535-L.jpg	\N	audiobook	acceptable	21 x 10 cm	808	t	t	15.54	4.90	18.76	53.77	18	0	t	2.90	1043	688	f1d98936-9d9f-452e-81aa-648e1a167e85	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	legendborn	{legendborn,book}	2022-05-17 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
6d1dd482-cd9d-456b-8de0-1b032e9e0df6	Lessons in Chemistry	\N	"Lessons in Chemistry" follows Elizabeth Zott, a brilliant chemist in the 1950s who faces sexism and discrimination in her field. After being sidelined from her research, she inadvertently becomes the star of a television cooking show where she uses her scientific approach to teaching cooking, challenging societal norms and inspiring housewives. The book explores themes of gender inequality, scientific integrity, and the unexpected ways individuals can impact their world.	9780385547345	\N	\N	\N	352	es 	https://covers.openlibrary.org/b/id/13011465-L.jpg	https://covers.openlibrary.org/b/id/13011465-S.jpg	https://covers.openlibrary.org/b/id/13011465-M.jpg	https://covers.openlibrary.org/b/id/13011465-L.jpg	\N	audiobook	good	20 x 20 cm	935	t	t	54.88	2.77	23.28	22.77	56	0	t	4.00	669	16	d6b45408-b0f9-4404-813c-8d37aa3813c8	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	lessons-in-chemistry	{lessons,book}	2020-02-09 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
a48ccd0f-c3ff-4d5f-a6fe-c10848719ce5	Lightlark	\N	"Lightlark" follows Isla Crown, ruler of one of six realms cursed to die every century unless a ruler participates in the Centennial Games. In the Games, rulers fight to break their curses, navigating treacherous challenges and deadly alliances, while Isla secretly seeks to steal the life-altering secrets that could save her realm, even if it means sacrificing her own. The book explores themes of sacrifice, political intrigue, and forbidden romance amidst a high-stakes competition.	9781419760860	\N	\N	\N	144	de 	https://covers.openlibrary.org/b/id/12917631-L.jpg	https://covers.openlibrary.org/b/id/12917631-S.jpg	https://covers.openlibrary.org/b/id/12917631-M.jpg	https://covers.openlibrary.org/b/id/12917631-L.jpg	\N	hardcover	like_new	23 x 16 cm	921	t	f	23.87	3.46	8.45	67.07	15	0	t	3.10	1435	175	28e4fb5a-344d-43a2-8c74-dd93b807d165	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	lightlark	{lightlark,book}	2016-07-05 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
eb9910da-1c69-4ef0-8e0e-5840ca04a380	Lincoln in the Bardo	\N	"Lincoln in the Bardo" by George Saunders depicts Abraham Lincoln's grief over his son Willie's death during the Civil War, interwoven with the experiences of spirits inhabiting a bardo, a transitional state between life and death. The novel explores themes of loss, love, political turmoil, and the human condition through a fragmented narrative composed of historical accounts and the voices of the trapped spirits.	9780812995343	\N	\N	\N	210	pt 	https://covers.openlibrary.org/b/id/7909378-L.jpg	https://covers.openlibrary.org/b/id/7909378-S.jpg	https://covers.openlibrary.org/b/id/7909378-M.jpg	https://covers.openlibrary.org/b/id/7909378-L.jpg	\N	paperback	good	24 x 13 cm	939	t	f	26.20	3.76	16.78	15.79	75	0	t	2.90	1561	416	a783263d-fb26-4c2f-a57a-e53008334e11	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	lincoln-in-the-bardo	{lincoln,book}	2023-02-08 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
370bb1f1-7eda-4828-93e5-88cace76098d	Lord of Shadows	\N	"Lord of Shadows" continues the story of the Shadowhunters in Los Angeles as they grapple with the aftermath of the Dark War. Emma Carstairs and Julian Blackthorn struggle with their forbidden love while investigating a series of murders connected to a dark conspiracy that threatens to tear the Shadowhunter world apart.	9781442468405	\N	\N	\N	375	de 	https://covers.openlibrary.org/b/id/13151787-L.jpg	https://covers.openlibrary.org/b/id/13151787-S.jpg	https://covers.openlibrary.org/b/id/13151787-M.jpg	https://covers.openlibrary.org/b/id/13151787-L.jpg	\N	audiobook	acceptable	21 x 15 cm	726	t	f	16.86	1.58	12.27	66.60	93	0	t	0.20	1424	360	2191651d-4bf6-48fc-99cb-f751d681b126	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	lord-of-shadows	{lord,book}	2023-12-01 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
d251529b-44c7-4628-ae32-1b54f4efcc03	Malibu Rising	\N	"Malibu Rising" centers on the Riva siblings and their annual end-of-summer party in 1983 Malibu, a party that spirals out of control. As the night unfolds, family secrets are revealed, forcing each sibling to confront their personal struggles and the legacy of their famous singer father. The novel explores themes of family, identity, and the destructive power of secrets.	9781524798659	\N	\N	\N	102	pt 	https://covers.openlibrary.org/b/id/11205514-L.jpg	https://covers.openlibrary.org/b/id/11205514-S.jpg	https://covers.openlibrary.org/b/id/11205514-M.jpg	https://covers.openlibrary.org/b/id/11205514-L.jpg	\N	ebook	acceptable	17 x 12 cm	774	t	f	31.77	5.54	16.03	66.81	85	0	t	3.50	176	190	4bfec3af-a607-4664-819f-018037116bcc	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	malibu-rising	{malibu,book}	2020-06-14 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
fcf19eb6-74e4-482b-862a-f3c20f0a57a2	Mockingjay	\N	"Mockingjay" concludes the "Hunger Games" trilogy, focusing on Katniss Everdeen as she becomes the reluctant symbol of the rebellion against the Capitol. The story follows her journey through war-torn Panem as she navigates political manipulation, personal trauma, and difficult moral choices, ultimately culminating in a final confrontation that determines the future of the nation.	9780439023511	\N	\N	\N	234	fr 	https://covers.openlibrary.org/b/id/12646459-L.jpg	https://covers.openlibrary.org/b/id/12646459-S.jpg	https://covers.openlibrary.org/b/id/12646459-M.jpg	https://covers.openlibrary.org/b/id/12646459-L.jpg	\N	paperback	new	22 x 19 cm	567	t	f	33.77	3.44	18.58	62.10	84	0	t	2.60	3537	218	b4425276-c6c8-41c2-a5a4-08a8e406e149	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	mockingjay	{mockingjay,book}	2025-03-16 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
8285b0f2-c2f1-4ff3-a74e-030e4cb47ffa	My Brilliant Friend	\N	"My Brilliant Friend" chronicles the lifelong friendship between Elena Greco and Raffaella "Lila" Cerullo, two intelligent girls growing up in a poor and violent neighborhood in post-war Naples. The novel explores themes of education, social mobility, female identity, and the complexities of female friendship within a challenging social context. Through Elena's perspective, the book details their intertwined lives and the societal forces that shape their individual paths.	9781609450786	\N	\N	\N	414	it 	https://covers.openlibrary.org/b/id/14351056-L.jpg	https://covers.openlibrary.org/b/id/14351056-S.jpg	https://covers.openlibrary.org/b/id/14351056-M.jpg	https://covers.openlibrary.org/b/id/14351056-L.jpg	\N	paperback	acceptable	24 x 13 cm	270	t	t	33.39	3.38	13.64	59.79	67	0	t	1.20	963	305	d4d531fd-9cf3-476a-a357-cf8d4ca8944e	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	my-brilliant-friend	{my,book}	2016-04-25 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
cb7028c5-583d-4505-870c-8918923e3468	Never Let Me Go	\N	"Never Let Me Go" by Kazuo Ishiguro follows Kathy, Ruth, and Tommy, who grow up at Hailsham, a seemingly idyllic boarding school, and later grapple with the truth of their predetermined futures as clones raised to donate their organs. The novel explores themes of identity, memory, love, and mortality as the protagonists navigate their unique circumstances and search for meaning within their limited lives.	9781400078776	\N	\N	\N	592	fr 	https://covers.openlibrary.org/b/id/13160732-L.jpg	https://covers.openlibrary.org/b/id/13160732-S.jpg	https://covers.openlibrary.org/b/id/13160732-M.jpg	https://covers.openlibrary.org/b/id/13160732-L.jpg	\N	paperback	acceptable	18 x 19 cm	1430	t	f	30.87	3.83	22.07	45.74	83	0	t	4.60	1086	752	cf6063b1-4351-4a3a-b61c-c28791695ed6	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	never-let-me-go	{never,book}	2021-01-29 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
ccecba4e-19f2-4977-a7f5-a64ba54c2de8	Nevernight	\N	"Nevernight" follows Mia Corvere, who trains to become an assassin in a school of deadly killers seeking revenge for her family's betrayal. Set in a gritty, Roman-inspired fantasy world, the story explores themes of vengeance, loyalty, and the price of power amidst political intrigue and dangerous magic.	9781250073020	\N	\N	\N	593	it 	https://covers.openlibrary.org/b/id/10085980-L.jpg	https://covers.openlibrary.org/b/id/10085980-S.jpg	https://covers.openlibrary.org/b/id/10085980-M.jpg	https://covers.openlibrary.org/b/id/10085980-L.jpg	\N	hardcover	like_new	23 x 15 cm	287	t	f	10.25	3.76	9.13	61.29	33	0	t	3.20	74	449	e249648e-e538-4f15-9240-b8e96561b270	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	nevernight	{nevernight,book}	2023-10-21 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
11c7b598-b577-4e5f-b988-3347839d9a96	Nightbane	\N	"Nightbane" is a horror role-playing game setting centered around the premise that monstrous beings known as Nightbane can assume human form, secretly existing within our world. Players typically take on the roles of humans who have discovered their own Nightbane nature, grappling with their newfound powers and fighting against the monstrous dominion of the Nightbane Overlords. The setting explores themes of identity, hidden worlds, and the struggle against overwhelming supernatural forces.	9781419765148	\N	\N	\N	414	de 	https://covers.openlibrary.org/b/id/14782914-L.jpg	https://covers.openlibrary.org/b/id/14782914-S.jpg	https://covers.openlibrary.org/b/id/14782914-M.jpg	https://covers.openlibrary.org/b/id/14782914-L.jpg	\N	ebook	like_new	19 x 12 cm	390	t	t	53.83	5.67	12.17	70.14	7	0	t	4.30	886	152	270f73e6-92fc-4d1a-a3c1-4824c98731f9	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	nightbane	{nightbane,book}	2021-07-24 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
7302da6b-0859-48c8-a743-8ffc73bd6ed5	Normal People	\N	"Normal People" follows the complex and often turbulent relationship between Connell and Marianne, two Irish teenagers from different social strata who repeatedly find themselves drawn together despite their changing circumstances. The novel explores themes of class, social awkwardness, communication, and the challenges of navigating intimacy and identity throughout adolescence and young adulthood.	9781984822178	\N	\N	\N	336	es 	https://covers.openlibrary.org/b/id/8794265-L.jpg	https://covers.openlibrary.org/b/id/8794265-S.jpg	https://covers.openlibrary.org/b/id/8794265-M.jpg	https://covers.openlibrary.org/b/id/8794265-L.jpg	\N	audiobook	like_new	23 x 17 cm	434	t	f	22.25	3.27	21.04	17.32	14	0	t	3.00	1482	402	a5b394a0-1f88-436b-b1bc-66a16f9a18b6	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	normal-people	{normal,book}	2024-03-30 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
caca1abb-0677-4801-9586-f8732d8937df	Obsidio	\N	\N	9780553499186	\N	\N	\N	216	en 	https://covers.openlibrary.org/b/id/8738063-L.jpg	https://covers.openlibrary.org/b/id/8738063-S.jpg	https://covers.openlibrary.org/b/id/8738063-M.jpg	https://covers.openlibrary.org/b/id/8738063-L.jpg	\N	paperback	good	18 x 12 cm	1121	t	f	46.12	1.98	7.70	30.61	92	0	t	1.20	4412	252	7473cf07-c76e-40be-8b2b-6cd27e9a3a69	\N	17739b35-27cb-41af-bb8d-d996f3519ee7	obsidio	{obsidio,book}	2020-08-16 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
8dd1495b-7b0a-41d1-97f6-77f99adbedd9	Once Upon a Broken Heart	\N	"Once Upon a Broken Heart" follows Evangeline Fox as she makes a desperate deal with the Prince of Hearts, a Fate, in an attempt to stop the wedding of her stepsister to the man she loves. This decision plunges her into a dangerous game involving curses, love, and the dark side of fairy tales, ultimately forcing her to question who she can trust and the true cost of her desires.	9781250268396	\N	\N	\N	549	de 	https://covers.openlibrary.org/b/id/15076298-L.jpg	https://covers.openlibrary.org/b/id/15076298-S.jpg	https://covers.openlibrary.org/b/id/15076298-M.jpg	https://covers.openlibrary.org/b/id/15076298-L.jpg	\N	hardcover	new	16 x 10 cm	1481	t	f	17.70	1.10	7.56	44.66	71	0	t	2.80	1142	836	8f608968-4016-4960-b5c1-7e480f98856d	\N	84484d09-8b66-4ea7-9edc-106fd13ffd73	once-upon-a-broken-heart	{once,book}	2018-06-12 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
ecec3822-2abb-4fe8-8a35-8f75cb5b5d00	Our Dark Duet	\N	"Our Dark Duet" is the sequel to "This Savage Song" and continues the story of Kate Harker and August Flynn in a city overrun by monsters. As tensions rise between humans and monsters, Kate and August struggle with their own identities and powers, facing difficult choices about loyalty, morality, and the very definition of what it means to be human or monster.	9780765376732	\N	\N	\N	794	fr 	https://covers.openlibrary.org/b/id/13237797-L.jpg	https://covers.openlibrary.org/b/id/13237797-S.jpg	https://covers.openlibrary.org/b/id/13237797-M.jpg	https://covers.openlibrary.org/b/id/13237797-L.jpg	\N	audiobook	very_good	16 x 12 cm	760	t	f	54.19	5.05	6.95	37.23	99	0	t	1.10	2427	509	8233595d-8f83-4922-9dae-c6251cb4555a	\N	6a151e20-73d9-45e0-94bf-be7a0f73f4cf	our-dark-duet	{our,book}	2023-06-23 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
e1979d34-ff10-4f48-9ecc-c4d8fe3dc1d7	Project Hail Mary	\N	"Project Hail Mary" follows an amnesiac astronaut who awakens on a spaceship with a critical mission: to save Earth from an impending extinction-level event caused by a star-eating microorganism. As he struggles to recover his memories and understand his task, he encounters an alien species and forms an unlikely alliance to combat the global threat. The book explores themes of scientific problem-solving, cross-species communication, and the responsibility to protect life in the universe.	9780593135204	\N	\N	\N	511	en 	https://covers.openlibrary.org/b/id/12455001-L.jpg	https://covers.openlibrary.org/b/id/12455001-S.jpg	https://covers.openlibrary.org/b/id/12455001-M.jpg	https://covers.openlibrary.org/b/id/12455001-L.jpg	\N	ebook	acceptable	25 x 10 cm	790	t	f	39.88	5.93	14.15	47.13	42	0	t	3.60	2139	648	f973f2c4-89df-42de-95fa-94df8de40c1f	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	project-hail-mary	{project,book}	2017-03-08 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
ae02e3da-e96e-4f34-8c45-33fe6327412c	Queen of Air and Darkness	\N	\N	9781442468436	\N	\N	\N	140	es 	https://covers.openlibrary.org/b/id/13348104-L.jpg	https://covers.openlibrary.org/b/id/13348104-S.jpg	https://covers.openlibrary.org/b/id/13348104-M.jpg	https://covers.openlibrary.org/b/id/13348104-L.jpg	\N	paperback	new	16 x 19 cm	640	t	t	45.10	1.51	13.13	15.11	52	0	t	0.20	2678	599	269f6a55-da41-4c9b-9b7a-8bd88b84f5f3	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	queen-of-air-and-darkness	{queen,book}	2021-03-16 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
747d5df7-daf5-47ea-9ebe-e707e21d7fd8	Queen of Shadows	\N	"Queen of Shadows" is the fourth book in the "Throne of Glass" series. Celaena Sardothien, now openly known as Aelin Ashryver Galathynius, returns to Adarlan to confront her past and reclaim her throne while battling political enemies and supernatural threats. The story explores themes of loyalty, sacrifice, and the burden of leadership as Aelin assembles allies and makes difficult choices in her quest to liberate her kingdom.	9781619636040	\N	\N	\N	589	fr 	https://covers.openlibrary.org/b/id/13312739-L.jpg	https://covers.openlibrary.org/b/id/13312739-S.jpg	https://covers.openlibrary.org/b/id/13312739-M.jpg	https://covers.openlibrary.org/b/id/13312739-L.jpg	\N	hardcover	good	19 x 10 cm	1300	t	t	10.21	1.66	10.98	47.43	48	0	t	3.10	3669	794	de8e8306-a78f-4b64-a148-6380539a3fe8	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	queen-of-shadows	{queen,book}	2022-04-08 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
7ca6c205-ed24-4aee-a4a1-701d5926e58b	Realm Breaker	\N	"Realm Breaker" follows a group of unlikely heroes as they are thrust into a quest to seal the deadly tear in the earth that threatens to unravel their world. They must unite against warring kingdoms and face powerful magic to prevent utter destruction, exploring themes of responsibility, sacrifice, and unlikely alliances.	9780062872623	\N	\N	\N	343	pt 	https://covers.openlibrary.org/b/id/13320975-L.jpg	https://covers.openlibrary.org/b/id/13320975-S.jpg	https://covers.openlibrary.org/b/id/13320975-M.jpg	https://covers.openlibrary.org/b/id/13320975-L.jpg	\N	paperback	good	18 x 19 cm	1201	t	f	40.54	3.26	24.02	46.44	2	0	t	3.90	3620	564	ac5b8dcc-3cf8-4597-bb27-5ad824fa87e4	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	realm-breaker	{realm,book}	2018-10-11 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
1b8c2b12-c017-4804-8df8-9b5e45c3f87f	Red Queen	\N	"Red Queen" by Victoria Aveyard is a dystopian fantasy novel where society is divided by blood color: Reds are commoners, while Silvers possess supernatural abilities. Mare Barrow, a Red, discovers she also possesses powers, thrusting her into the dangerous world of Silver royalty where she becomes a symbol of rebellion and questions the established social order. The book explores themes of social inequality, power, and the consequences of revolution.	9780062310637	\N	\N	\N	756	en 	https://covers.openlibrary.org/b/id/13320815-L.jpg	https://covers.openlibrary.org/b/id/13320815-S.jpg	https://covers.openlibrary.org/b/id/13320815-M.jpg	https://covers.openlibrary.org/b/id/13320815-L.jpg	\N	audiobook	like_new	17 x 10 cm	1444	t	f	54.40	1.77	6.85	51.93	10	0	t	3.00	1093	207	d6dce219-3ec6-45c6-9c30-fbd3e1fb89ad	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	red-queen	{red,book}	2022-01-04 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
72aac672-fcb5-4f75-8c9f-35b54c08b431	Reminders of Him	\N	"Reminders of Him" centers on Kenna Rowan, a young woman recently released from prison after a tragic accident, who returns to her daughter's hometown seeking reconciliation and a relationship with the child she's never known. The novel explores themes of grief, forgiveness, and redemption as Kenna navigates the complicated emotions of those affected by the past and attempts to forge a new future.	9781542025607	\N	\N	\N	519	de 	https://covers.openlibrary.org/b/id/12589197-L.jpg	https://covers.openlibrary.org/b/id/12589197-S.jpg	https://covers.openlibrary.org/b/id/12589197-M.jpg	https://covers.openlibrary.org/b/id/12589197-L.jpg	\N	paperback	very_good	25 x 16 cm	268	t	f	23.43	2.60	6.42	36.80	80	0	t	0.50	4948	973	b491b961-f64b-484f-8309-cb0728a3e461	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	reminders-of-him	{reminders,book}	2016-05-03 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
3e48080f-456f-4dd4-8ed3-996c4c5d1db9	Restore Me	\N	"Restore Me" is the fourth novel in the Shatter Me series, continuing Juliette Ferrars' journey after becoming the Commander of Sector 45. The book explores the challenges of rebuilding society, grappling with Warner's past, and confronting new threats as Juliette questions her own identity and her ability to lead. The narrative delves into themes of power, trust, and the complexities of love amidst political turmoil.	9780062676375	\N	\N	\N	782	it 	https://covers.openlibrary.org/b/id/8797404-L.jpg	https://covers.openlibrary.org/b/id/8797404-S.jpg	https://covers.openlibrary.org/b/id/8797404-M.jpg	https://covers.openlibrary.org/b/id/8797404-L.jpg	\N	hardcover	good	21 x 12 cm	525	t	f	16.15	1.47	7.44	66.86	25	0	t	2.00	4430	351	2ca79427-0885-4119-8ab8-0a964cdf673e	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	restore-me	{restore,book}	2017-10-14 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
1a14d2ed-b677-42eb-bc3e-6a78ddb1f7a8	Ruin and Rising	\N	"Ruin and Rising" is the third and final book in the Grisha Trilogy. Alina Starkov must embrace her destiny as a Sun Summoner and hone her powers to defeat the Darkling, while facing internal conflicts and difficult choices that will determine the fate of Ravka. It explores themes of sacrifice, power, and the struggle against overwhelming darkness.	9780805094619	\N	\N	\N	251	pt 	https://covers.openlibrary.org/b/id/7383188-L.jpg	https://covers.openlibrary.org/b/id/7383188-S.jpg	https://covers.openlibrary.org/b/id/7383188-M.jpg	https://covers.openlibrary.org/b/id/7383188-L.jpg	\N	ebook	new	25 x 19 cm	222	t	f	13.60	2.52	14.41	58.85	98	0	t	4.00	3703	245	667ca47b-ca96-417f-a778-aff3c120aac9	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	ruin-and-rising	{ruin,book}	2021-03-12 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
8c1b857f-852f-4bb9-bcca-3761a46d8a78	Rule of Wolves	\N	"Rule of Wolves" continues the story of Nikolai Lantsov, the King of Ravka, as he navigates political intrigue and imminent war with a powerful Grisha General. Ravka faces threats from multiple fronts, forcing Nikolai to confront his inner demons and make difficult choices to protect his kingdom, exploring themes of sacrifice, power, and the cost of leadership.	9781250800817	\N	\N	\N	641	fr 	https://covers.openlibrary.org/b/id/11253161-L.jpg	https://covers.openlibrary.org/b/id/11253161-S.jpg	https://covers.openlibrary.org/b/id/11253161-M.jpg	https://covers.openlibrary.org/b/id/11253161-L.jpg	\N	paperback	acceptable	19 x 20 cm	438	t	t	29.49	2.62	10.93	26.59	89	0	t	0.80	1276	761	e7ecbdcf-0cbe-43d4-bbf0-8266025ef98d	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	rule-of-wolves	{rule,book}	2025-05-02 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
ac2c6867-0a1e-4e01-8016-b09183e01db9	Sea of Tranquility	\N	"Sea of Tranquility" follows several characters across different timelines, from 1912 to the far future, who experience anomalies that disrupt their sense of reality. As their experiences converge, a time-traveling investigator attempts to understand the source of these anomalies and prevent a potential disaster that threatens the fabric of time and existence. The novel explores themes of time, memory, interconnectedness, and the nature of reality.	9780593321447	\N	\N	\N	677	pt 	https://covers.openlibrary.org/b/id/11642160-L.jpg	https://covers.openlibrary.org/b/id/11642160-S.jpg	https://covers.openlibrary.org/b/id/11642160-M.jpg	https://covers.openlibrary.org/b/id/11642160-L.jpg	\N	paperback	like_new	16 x 12 cm	793	t	t	38.45	4.07	23.34	37.21	97	0	t	4.30	826	715	c0713d0f-2641-4fec-acd4-dd28fce3d041	\N	6a151e20-73d9-45e0-94bf-be7a0f73f4cf	sea-of-tranquility	{sea,book}	2025-03-07 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
665fe5b6-a36b-4104-883f-4400203a8976	Serpent & Dove	\N	\N	9781534444959	\N	\N	\N	769	fr 	https://covers.openlibrary.org/b/id/10493501-L.jpg	https://covers.openlibrary.org/b/id/10493501-S.jpg	https://covers.openlibrary.org/b/id/10493501-M.jpg	https://covers.openlibrary.org/b/id/10493501-L.jpg	\N	audiobook	acceptable	22 x 15 cm	748	t	f	22.26	2.22	15.04	42.45	43	0	t	0.10	1279	141	6aaa19a7-a1dc-4c4e-8fec-4a6ebd9b72f6	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	serpent-dove	{serpent,book}	2018-06-20 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
d6aeba5f-5d8a-4b67-a1df-f38f28b38d41	Shadow and Bone	\N	"Shadow and Bone" is a young adult fantasy novel centered on Alina Starkov, a teenage orphan who discovers she possesses a unique power that could save her war-torn country of Ravka. Drafted into an elite magical military order called the Grisha, Alina must learn to control her abilities and navigate the complex politics of the Ravkan court while confronting the dangerous Shadow Fold, a region of impenetrable darkness teeming with monsters. The book explores themes of destiny, power, and the struggle against oppressive forces.	9780805094596	\N	\N	\N	358	it 	https://covers.openlibrary.org/b/id/7382175-L.jpg	https://covers.openlibrary.org/b/id/7382175-S.jpg	https://covers.openlibrary.org/b/id/7382175-M.jpg	https://covers.openlibrary.org/b/id/7382175-L.jpg	\N	audiobook	good	19 x 13 cm	443	t	t	13.82	5.24	13.51	65.57	20	0	t	2.60	1073	377	ede44139-1594-4eab-8eda-71c725e8db41	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	shadow-and-bone	{shadow,book}	2024-03-10 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
d8e0d3f2-d01a-4d53-80f8-7d97e61c8eba	Shatter Me	\N	"Shatter Me" is a dystopian young adult novel about Juliette, a girl with a lethal touch who has been imprisoned for years. When the Reestablishment, a totalitarian regime, takes an interest in her power, Juliette is forced to confront her abilities and decide whether to use them for their gain or fight for her own freedom and a potential rebellion. The story explores themes of power, control, and self-discovery within a crumbling society.	9780062085504	\N	\N	\N	225	en 	https://covers.openlibrary.org/b/id/10509689-L.jpg	https://covers.openlibrary.org/b/id/10509689-S.jpg	https://covers.openlibrary.org/b/id/10509689-M.jpg	https://covers.openlibrary.org/b/id/10509689-L.jpg	\N	audiobook	good	18 x 10 cm	840	t	f	37.79	1.55	14.61	64.31	94	0	t	3.30	2746	159	8cfc7f6a-9b30-4156-ac9c-a309a19944c5	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	shatter-me	{shatter,book}	2022-09-22 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
fc7b50ee-89c4-4622-8ac4-4e9fceaa97c8	She Who Became the Sun	\N	"She Who Became the Sun" reimagines the rise of the Hongwu Emperor, founder of the Ming Dynasty, through the lens of a peasant girl who takes on her deceased brpaperback's identity to escape her fate and find her own greatness. The novel explores themes of gender identity, destiny versus choice, and the cost of ambition in a war-torn China.	9781250621801	\N	\N	\N	674	de 	https://covers.openlibrary.org/b/id/10709176-L.jpg	https://covers.openlibrary.org/b/id/10709176-S.jpg	https://covers.openlibrary.org/b/id/10709176-M.jpg	https://covers.openlibrary.org/b/id/10709176-L.jpg	\N	ebook	new	22 x 13 cm	293	t	t	7.73	1.58	15.86	40.64	20	0	t	2.40	2852	809	b6cb2138-0d37-48da-8c1e-cbbfa5d4391c	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	she-who-became-the-sun	{she,book}	2021-12-30 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
af5fa9fa-03c7-4640-8c1a-3172f22ba55f	Siege and Storm	\N	"Siege and Storm" follows Alina Starkov and Mal Oretsev as they seek to amplify Alina's Grisha powers after escaping Ravka, facing new dangers from both the Darkling and those who hunt Grisha. The novel explores themes of power, destiny, and moral compromise as Alina grapples with her abilities and struggles to understand who she can truly trust amidst a looming war.	9780805094602	\N	\N	\N	341	es 	https://covers.openlibrary.org/b/id/14855521-L.jpg	https://covers.openlibrary.org/b/id/14855521-S.jpg	https://covers.openlibrary.org/b/id/14855521-M.jpg	https://covers.openlibrary.org/b/id/14855521-L.jpg	\N	hardcover	acceptable	20 x 11 cm	1363	t	t	32.27	3.52	8.42	28.67	90	0	t	3.50	2455	987	b31258cf-cbd7-421e-bf5a-6acce3f09fec	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	siege-and-storm	{siege,book}	2017-08-16 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
221e8d86-6295-4e54-826a-530f2db1c035	Six of Crows	\N	"Six of Crows" follows a crew of six outcasts in Ketterdam as they attempt a seemingly impossible heist. The book explores themes of found family, redemption, and the struggle for survival in a corrupt and stratified society. Their mission, if successful, could change the balance of power in the Grishaverse.	9781627792127	\N	\N	\N	137	en 	https://covers.openlibrary.org/b/id/14813307-L.jpg	https://covers.openlibrary.org/b/id/14813307-S.jpg	https://covers.openlibrary.org/b/id/14813307-M.jpg	https://covers.openlibrary.org/b/id/14813307-L.jpg	\N	paperback	acceptable	24 x 11 cm	1445	t	f	7.44	5.40	10.72	36.11	82	0	t	3.40	2191	570	765d4730-5349-4233-81e7-f6fc88d1d9fe	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	six-of-crows	{six,book}	2018-02-23 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
513fec1f-be49-4ef8-b19e-2202056073a0	Small Things Like These	\N	"Small Things Like These" follows Bill Furlong, a coal merchant in 1985 Ireland, as he grapples with the truth about the local Magdalen Laundry. As Christmas approaches, he confronts the societal silence and the abuses inflicted upon vulnerable women in the convent, ultimately facing a moral dilemma that forces him to examine his own complicity. The book explores themes of individual responsibility, community complicity, and the power of small acts of resistance in the face of sabiric injustice.	9780802158741	\N	\N	\N	279	pt 	https://covers.openlibrary.org/b/id/15096821-L.jpg	https://covers.openlibrary.org/b/id/15096821-S.jpg	https://covers.openlibrary.org/b/id/15096821-M.jpg	https://covers.openlibrary.org/b/id/15096821-L.jpg	\N	hardcover	very_good	21 x 16 cm	1268	t	t	21.40	1.39	17.37	54.05	98	0	t	1.50	1514	42	f048df88-e21a-444e-b3f6-fc85f6a911d5	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	small-things-like-these	{small,book}	2019-10-21 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
0b32f06d-5edf-4077-8d6e-ff38e207961a	Spare	\N	"Spare" is a memoir by Prince Harry, Duke of Sussex, detailing his life from childhood to his decision to step down as a senior member of the British Royal Family. The book explores his experiences growing up in the public eye, his grief following his mpaperback's death, his military service, and his relationships with his family, particularly his brpaperback Prince William. It delves into the tensions within the Royal Family and the challenges he faced navigating his role within the institution.	9780593593806	\N	\N	\N	536	en 	https://covers.openlibrary.org/b/id/14630116-L.jpg	https://covers.openlibrary.org/b/id/14630116-S.jpg	https://covers.openlibrary.org/b/id/14630116-M.jpg	https://covers.openlibrary.org/b/id/14630116-L.jpg	\N	audiobook	very_good	25 x 15 cm	282	t	f	42.01	1.41	22.87	72.92	77	0	t	5.00	4169	229	f269a424-0ba6-442b-8864-e5a882b6a676	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	spare	{spare,book}	2019-04-03 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
ed315038-fb94-4c41-9759-667b65c7c540	The Ashes and the Star-Cursed King	\N	"The Ashes and the Star-Cursed King" follows Isolde as she attempts to break a curse threatening her kingdom by marrying the enigmatic vampire king, Adrian Aleksandr. Forced into a dangerous political marriage built on lies and fraught with peril, Isolde must navigate a world of dark magic and courtly intrigue while discovering the secrets behind Adrian's troubled past and the curse itself. The story explores themes of sacrifice, hidden identities, and forbidden love within a gothic-fantasy setting.	9781957779027	\N	\N	\N	683	de 	https://covers.openlibrary.org/b/id/13836874-L.jpg	https://covers.openlibrary.org/b/id/13836874-S.jpg	https://covers.openlibrary.org/b/id/13836874-M.jpg	https://covers.openlibrary.org/b/id/13836874-L.jpg	\N	paperback	like_new	24 x 20 cm	1343	t	t	21.29	2.95	19.90	25.14	95	0	t	3.40	544	846	cf5cd761-4321-43f1-a0b8-f026d8cf8075	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	the-ashes-and-the-star-cursed-king	{the,book}	2022-09-22 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
c648e155-66b6-48dd-8374-9a8b5832df45	The Atlas Six	\N	"The Atlas Six" follows six magically gifted individuals chosen to compete for five coveted spots in the secret Alexandrian Society. As they navigate complex moral dilemmas, treacherous alliances, and the Society's vast, often dangerous knowledge, they must grapple with the price of power and the potential corruption of their abilities. The novel explores themes of ambition, knowledge versus morality, and the consequences of controlling powerful magic.	9781250854513	\N	\N	\N	267	en 	https://covers.openlibrary.org/b/id/12070994-L.jpg	https://covers.openlibrary.org/b/id/12070994-S.jpg	https://covers.openlibrary.org/b/id/12070994-M.jpg	https://covers.openlibrary.org/b/id/12070994-L.jpg	\N	paperback	like_new	22 x 12 cm	434	t	f	15.31	3.92	9.63	32.31	41	0	t	4.60	1491	715	e637db04-fc38-4291-8e43-f77bcc53642d	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	the-atlas-six	{the,book}	2020-12-13 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
fdc843e7-3df6-417b-8bb6-ca1c80b401db	The Atlas Six: Illustrated Edition	\N	"The Atlas Six: Illustrated Edition" is a dark academia fantasy novel following six exceptionally talented magicians chosen to compete for five coveted spots in the Alexandrian Society, a secret society dedicated to preserving and expanding magical knowledge. As they navigate treacherous trials and uncover hidden agendas, the candidates grapple with moral dilemmas, the nature of knowledge and power, and the consequences of their ambition. This edition includes new illustrations bringing the world and characters to life.	9781250854568	\N	\N	\N	760	de 	https://covers.openlibrary.org/b/id/14410497-L.jpg	https://covers.openlibrary.org/b/id/14410497-S.jpg	https://covers.openlibrary.org/b/id/14410497-M.jpg	https://covers.openlibrary.org/b/id/14410497-L.jpg	\N	paperback	good	21 x 16 cm	1104	t	f	43.59	1.80	13.29	46.35	12	0	t	1.20	4940	427	7606a32a-84c5-46fd-8f5b-ac9a6d390393	\N	6a151e20-73d9-45e0-94bf-be7a0f73f4cf	the-atlas-six-illustrated-edition	{the,book}	2020-03-20 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
c54e0224-118c-43c2-857e-22e74330e174	The Ballad of Songbirds and Snakes	\N	"The Ballad of Songbirds and Snakes" is a prequel to "The Hunger Games" that follows a young Coriolanus Snow as he mentors Lucy Gray Baird, the female tribute from District 12, during the 10th Hunger Games. The story explores themes of power, control, and the origins of the Games' brutality, examining how Snow's experiences and relationships shape his future rise to tyranny.	9781338635171	\N	\N	\N	218	en 	https://covers.openlibrary.org/b/id/10242930-L.jpg	https://covers.openlibrary.org/b/id/10242930-S.jpg	https://covers.openlibrary.org/b/id/10242930-M.jpg	https://covers.openlibrary.org/b/id/10242930-L.jpg	\N	hardcover	new	24 x 13 cm	596	t	t	14.77	5.60	7.67	25.32	0	0	t	1.70	4230	63	52235d58-73d6-4f9f-9421-faffd7c86b98	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	the-ballad-of-songbirds-and-snakes	{the,book}	2022-01-11 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
6e013b45-a52d-46c5-b45f-542274582583	The Burning God	\N	"The Burning God" concludes the Poppy War trilogy, focusing on Rin's descent further into her destructive powers as she fights against the Red Empress and the invading Hesperians. The book explores themes of trauma, morality in wartime, and the complex legacy of colonialism as Rin grapples with the consequences of her choices and the true cost of liberation.	9780062662620	\N	\N	\N	204	es 	https://covers.openlibrary.org/b/id/10329759-L.jpg	https://covers.openlibrary.org/b/id/10329759-S.jpg	https://covers.openlibrary.org/b/id/10329759-M.jpg	https://covers.openlibrary.org/b/id/10329759-L.jpg	\N	hardcover	like_new	15 x 12 cm	1384	t	t	11.98	2.29	5.36	69.39	1	0	t	0.40	189	172	08bb2523-7808-479b-af10-ae93ba6c171f	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	the-burning-god	{the,book}	2020-01-29 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
4f82177e-15ce-4c56-9fbf-796d7ea2804c	The Covenant of Water	\N	"The Covenant of Water" follows three generations of a family in Kerala, South India, grappling with a mysterious affliction: one member in each generation dies by drowning. Spanning the years 1900 to 1970, the novel explores themes of family secrets, medical mysteries, love, loss, and the enduring power of human connection in the face of adversity.	9780802162175	\N	\N	\N	639	it 	https://covers.openlibrary.org/b/id/13190092-L.jpg	https://covers.openlibrary.org/b/id/13190092-S.jpg	https://covers.openlibrary.org/b/id/13190092-M.jpg	https://covers.openlibrary.org/b/id/13190092-L.jpg	\N	audiobook	good	15 x 19 cm	573	t	f	10.98	2.88	7.02	48.41	81	0	t	2.00	2229	386	d0c003ca-cbac-4072-bb6c-0e2fb213eaf0	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	the-covenant-of-water	{the,book}	2018-07-18 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
333b9948-8b96-4be6-ac07-a03e5db15c92	The Dragon Republic	\N	"The Dragon Republic" continues Rin's story as she grapples with the devastating consequences of the Poppy War, now wielding immense shamanic power and leading a fractured nation against external threats. The book explores the themes of war's cost, the burden of power, and the complexities of morality as Rin navigates political intrigue and seeks to forge a new future for the Nikara Empire.	9780062662637	\N	\N	\N	529	de 	https://covers.openlibrary.org/b/id/8539487-L.jpg	https://covers.openlibrary.org/b/id/8539487-S.jpg	https://covers.openlibrary.org/b/id/8539487-M.jpg	https://covers.openlibrary.org/b/id/8539487-L.jpg	\N	paperback	acceptable	17 x 20 cm	319	t	t	13.76	4.98	20.76	25.21	99	0	t	1.20	2417	416	9fb7694b-7e2d-4c91-8fdf-b572f27ac30c	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	the-dragon-republic	{the,book}	2020-04-17 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
bb23edc9-91fb-41b1-9c1a-cffaeb05d01e	The Glass Castle	\N	"The Glass Castle" is a memoir that recounts Jeannette Walls' unconventional and impoverished childhood, raised by parents who valued adventure and nonconformity over stability and security. It explores themes of poverty, resilience, family dysfunction, and the complex bonds that tie people together despite hardship and unconventional choices. The story details Walls' journey from a transient life in the desert to building a successful career in New York City.	9780743247542	\N	\N	\N	325	it 	https://covers.openlibrary.org/b/id/12648199-L.jpg	https://covers.openlibrary.org/b/id/12648199-S.jpg	https://covers.openlibrary.org/b/id/12648199-M.jpg	https://covers.openlibrary.org/b/id/12648199-L.jpg	\N	audiobook	new	23 x 18 cm	938	t	t	5.97	2.29	7.08	45.26	76	0	t	0.60	479	868	4101b113-69f1-403f-b2a1-ecb2bc2b2f8d	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	the-glass-castle	{the,book}	2024-09-15 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
05cb7ddc-fbd5-4899-a854-dbf06ee86046	The Goldfinch	\N	"The Goldfinch" follows the life of Theodore Decker after he survives a museum bombing as a boy, taking with him a priceless painting. The novel explores themes of loss, trauma, addiction, and the redemptive power of art as Theo navigates a life shaped by this event, from New York to Las Vegas and Amsterdam, becoming entangled in the world of art forgery and dealing.	9780316055444	\N	\N	\N	162	en 	https://covers.openlibrary.org/b/id/9159185-L.jpg	https://covers.openlibrary.org/b/id/9159185-S.jpg	https://covers.openlibrary.org/b/id/9159185-M.jpg	https://covers.openlibrary.org/b/id/9159185-L.jpg	\N	hardcover	very_good	23 x 10 cm	1277	t	t	50.75	2.31	6.05	43.91	3	0	t	3.90	695	399	748e307c-7466-4919-943b-a1e4798b0f94	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	the-goldfinch	{the,book}	2020-07-25 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
9a6b9e7c-7cac-4c32-b420-c71b3dfbdcfb	The House in the Cerulean Sea	\N	"The House in the Cerulean Sea" follows Linus Baker, a caseworker for the Department in Charge Of Magical Youth, who is assigned to investigate a remote orphanage housing six potentially dangerous magical children. He must determine if they pose a threat to society, while also confronting his own prejudices and narrow worldview. The book explores themes of acceptance, found family, and the fear of the unknown.	9781250217288	\N	\N	\N	351	it 	https://covers.openlibrary.org/b/id/9312772-L.jpg	https://covers.openlibrary.org/b/id/9312772-S.jpg	https://covers.openlibrary.org/b/id/9312772-M.jpg	https://covers.openlibrary.org/b/id/9312772-L.jpg	\N	audiobook	very_good	19 x 16 cm	1253	t	t	40.50	4.40	16.56	69.31	86	0	t	3.20	2230	632	8cc4064a-2056-49a9-8ffb-bf7749bbb96c	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	the-house-in-the-cerulean-sea	{the,book}	2022-09-19 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
78529251-fc7e-40c4-b94f-1fe2fc676f4b	The Invisible Life of Addie LaRue	\N	"The Invisible Life of Addie LaRue" follows a young woman in 18th-century France who makes a deal to live forever but is cursed to be forgotten by everyone she meets. The novel explores Addie's centuries-long struggle with loneliness and her quest to leave a mark on the world, until she unexpectedly finds someone who remembers her. It delves into themes of identity, memory, art, and the human desire for connection and purpose.	9780765387561	\N	\N	\N	423	fr 	https://covers.openlibrary.org/b/id/10092261-L.jpg	https://covers.openlibrary.org/b/id/10092261-S.jpg	https://covers.openlibrary.org/b/id/10092261-M.jpg	https://covers.openlibrary.org/b/id/10092261-L.jpg	\N	hardcover	new	15 x 10 cm	344	t	f	29.01	1.62	18.83	63.07	25	0	t	0.50	1821	889	2e31929c-d38f-48a7-b4af-17aa20160afc	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	the-invisible-life-of-addie-larue	{the,book}	2019-12-23 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
775ee6ae-7471-4efa-a431-321fe0d8bb1f	The Midnight Library	\N	"The Midnight Library" centers around Nora Seed, who, after attempting suicide, finds herself in a library filled with books representing alternate versions of her life. She is given the opportunity to explore these different lives and undo her regrets to find one where she is happy. The book explores themes of regret, choice, and the search for meaning in life.	9780525559474	\N	\N	\N	613	de 	https://covers.openlibrary.org/b/id/10313767-L.jpg	https://covers.openlibrary.org/b/id/10313767-S.jpg	https://covers.openlibrary.org/b/id/10313767-M.jpg	https://covers.openlibrary.org/b/id/10313767-L.jpg	\N	audiobook	like_new	20 x 17 cm	612	t	t	35.21	1.74	13.73	31.47	17	0	t	1.10	90	731	bf3e2477-8f5b-4cd4-8959-9fd1d7dafb9d	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	the-midnight-library	{the,book}	2022-12-11 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
fd1fe11b-e778-4802-aa00-416ac51e5f33	The Night Circus	\N	"The Night Circus" follows the intertwined lives of Celia and Marco, two young illusionists unknowingly bound to a lifelong competition set within a mysterious, nocturnal circus. As they develop their skills and fall in love, they must confront the dangerous implications of their game and the forces orchestrating it. The novel explores themes of love, destiny, magic, and the power of art.	9780385534635	\N	\N	\N	325	es 	https://covers.openlibrary.org/b/id/8750523-L.jpg	https://covers.openlibrary.org/b/id/8750523-S.jpg	https://covers.openlibrary.org/b/id/8750523-M.jpg	https://covers.openlibrary.org/b/id/8750523-L.jpg	\N	hardcover	new	23 x 13 cm	243	t	t	42.64	3.60	8.34	39.86	7	0	t	1.60	3883	677	1883688e-855b-4d33-9997-b7fe05d436d9	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	the-night-circus	{the,book}	2022-12-14 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
56be8083-b5b0-4618-8d39-524ca8def7da	The Overstory	\N	"The Overstory" follows a diverse group of characters who become deeply connected to trees and forests, ultimately becoming activists fighting to protect them. The novel explores themes of interconnectedness, the sentience of nature, and the devastating consequences of deforestation. It weaves together scientific observations with human stories to illustrate the profound importance of trees to the planet's survival.	9780393356687	\N	\N	\N	275	it 	https://covers.openlibrary.org/b/id/8809047-L.jpg	https://covers.openlibrary.org/b/id/8809047-S.jpg	https://covers.openlibrary.org/b/id/8809047-M.jpg	https://covers.openlibrary.org/b/id/8809047-L.jpg	\N	paperback	acceptable	18 x 20 cm	1377	t	f	16.79	1.39	18.47	39.63	91	0	t	4.70	3370	192	0235941b-9bd0-435a-9b96-77a7c901f63f	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	the-overstory	{the,book}	2018-10-30 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
921783dc-7146-457f-b481-e0a921d0c584	The Poppy War	\N	\N	9780062662569	\N	\N	\N	403	pt 	https://covers.openlibrary.org/b/id/11946352-L.jpg	https://covers.openlibrary.org/b/id/11946352-S.jpg	https://covers.openlibrary.org/b/id/11946352-M.jpg	https://covers.openlibrary.org/b/id/11946352-L.jpg	\N	paperback	like_new	23 x 20 cm	220	t	f	35.47	5.38	23.94	33.31	75	0	t	0.70	1585	526	347aef6d-165e-4d1e-afd9-b6dbe18a8fb6	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	the-poppy-war	{the,book}	2015-09-24 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
a74cdf3d-a11b-4f17-a7c5-0b3923aa4bba	The Priory of the Orange Tree	\N	"The Priory of the Orange Tree" is a high fantasy novel that weaves together multiple perspectives across a world on the brink of destruction due to the re-emergence of a dangerous dragon. It explores themes of religious conflict, political intrigue, and the power of uniting disparate cultures to confront a common threat. The story follows individuals from different regions who must challenge long-held beliefs and work together to save humanity.	9781635570298	\N	\N	\N	646	en 	https://covers.openlibrary.org/b/id/10093837-L.jpg	https://covers.openlibrary.org/b/id/10093837-S.jpg	https://covers.openlibrary.org/b/id/10093837-M.jpg	https://covers.openlibrary.org/b/id/10093837-L.jpg	\N	paperback	like_new	16 x 11 cm	524	t	f	29.94	4.00	9.17	26.32	93	0	t	0.90	2592	356	f1d98936-9d9f-452e-81aa-648e1a167e85	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	the-priory-of-the-orange-tree	{the,book}	2019-05-28 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
1a28b1f2-7ec2-4664-82d3-3c69acd79969	The Road	\N	"The Road" tells the story of a father and son journeying across a post-apocalyptic America, ravaged by an unnamed cataclysmic event. They struggle for survival against starvation, the elements, and the brutality of paperback survivors, clinging to their humanity and the hope for a better future. The novel explores themes of love, loss, and the essential goodness that persists even in the face of utter devastation.	9780307387899	\N	\N	\N	321	fr 	https://covers.openlibrary.org/b/id/9557220-L.jpg	https://covers.openlibrary.org/b/id/9557220-S.jpg	https://covers.openlibrary.org/b/id/9557220-M.jpg	https://covers.openlibrary.org/b/id/9557220-L.jpg	\N	audiobook	very_good	15 x 19 cm	815	t	f	40.34	5.37	22.08	36.54	61	0	t	3.80	973	441	5cb0ce4a-5cd3-4d63-bec7-9f8ad3363afc	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	the-road	{the,book}	2024-08-05 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
8b2a2fa1-f832-429b-a4d8-27db06cc0fdc	The Rose and the Dagger	\N	"The Rose and the Dagger" continues Shahrzad's story as she navigates the complex political landscape of Rey, battling enemies both internal and external while still harboring feelings for Khalid, the Caliph she initially sought to kill. Themes of love, loyalty, and the consequences of power are explored as Shahrzad fights to protect herself and her kingdom from impending war and treacherous conspiracies.	9780553538212	\N	\N	\N	360	pt 	https://covers.openlibrary.org/b/id/10220115-L.jpg	https://covers.openlibrary.org/b/id/10220115-S.jpg	https://covers.openlibrary.org/b/id/10220115-M.jpg	https://covers.openlibrary.org/b/id/10220115-L.jpg	\N	paperback	acceptable	24 x 20 cm	964	t	t	11.18	1.16	17.87	58.56	72	0	t	2.90	131	255	d6b45408-b0f9-4404-813c-8d37aa3813c8	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	the-rose-and-the-dagger	{the,book}	2021-08-14 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
96166a20-0c85-469a-961d-8e876f98d00b	The Serpent and the Wings of Night	\N	\N	9781957779003	\N	\N	\N	559	pt 	https://covers.openlibrary.org/b/id/13451855-L.jpg	https://covers.openlibrary.org/b/id/13451855-S.jpg	https://covers.openlibrary.org/b/id/13451855-M.jpg	https://covers.openlibrary.org/b/id/13451855-L.jpg	\N	hardcover	like_new	15 x 10 cm	1151	t	f	36.21	4.42	23.24	36.10	7	0	t	0.40	1893	620	28e4fb5a-344d-43a2-8c74-dd93b807d165	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	the-serpent-and-the-wings-of-night	{the,book}	2020-12-31 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
f42ea33a-0edc-4697-b154-7cee4faf6919	The Shadows Between Us	\N	"The Shadows Between Us" follows Alessandra, a woman who plans to seduce and then kill the Shadow King to take his throne. As she gets closer to him, she discovers he may not be the monster everyone believes him to be, and they form an unlikely alliance to protect the kingdom from true threats. The novel explores themes of ambition, power, and challenging perceptions of darkness and morality.	9781250142276	\N	\N	\N	276	de 	https://covers.openlibrary.org/b/id/12667431-L.jpg	https://covers.openlibrary.org/b/id/12667431-S.jpg	https://covers.openlibrary.org/b/id/12667431-M.jpg	https://covers.openlibrary.org/b/id/12667431-L.jpg	\N	paperback	like_new	20 x 14 cm	727	t	t	19.80	5.96	15.95	67.04	77	0	t	3.60	3212	912	a783263d-fb26-4c2f-a57a-e53008334e11	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	the-shadows-between-us	{the,book}	2020-07-05 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
061cc62d-4530-42d2-855d-365359e7b206	The Song of Achilles	\N	"The Song of Achilles" recounts the story of Achilles, the greatest warrior of his age, through the eyes of his devoted companion, Patroclus. The novel explores their deep and evolving relationship amidst the backdrop of the Trojan War, examining themes of love, loyalty, fate, and the destructive nature of glory. Ultimately, it grapples with the cost of heroism and the enduring power of human connection.	9780062060624	\N	\N	\N	346	pt 	https://covers.openlibrary.org/b/id/15100283-L.jpg	https://covers.openlibrary.org/b/id/15100283-S.jpg	https://covers.openlibrary.org/b/id/15100283-M.jpg	https://covers.openlibrary.org/b/id/15100283-L.jpg	\N	paperback	very_good	19 x 17 cm	693	t	f	30.61	5.45	18.70	49.30	26	0	t	0.00	2746	140	2191651d-4bf6-48fc-99cb-f751d681b126	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	the-song-of-achilles	{the,book}	2019-02-10 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
08f2c938-7a33-48ea-a611-698f26df1195	The Songbird and the Heart of Stone	\N	"The Songbird and the Heart of Stone" follows a young woman with a magical voice who is forced to flee her home after a political coup. She must navigate a dangerous world, facing prejudice and betrayal, while striving to reclaim her identity and perhaps find a way to restore her homeland. The story explores themes of resilience, the power of art, and the corrupting influence of power.	9781957779041	\N	\N	\N	592	fr 	https://covers.openlibrary.org/b/id/13764916-L.jpg	https://covers.openlibrary.org/b/id/13764916-S.jpg	https://covers.openlibrary.org/b/id/13764916-M.jpg	https://covers.openlibrary.org/b/id/13764916-L.jpg	\N	paperback	very_good	20 x 14 cm	1222	t	t	27.51	4.55	14.63	74.11	24	0	t	1.20	3883	865	4bfec3af-a607-4664-819f-018037116bcc	\N	84484d09-8b66-4ea7-9edc-106fd13ffd73	the-songbird-and-the-heart-of-stone	{the,book}	2021-07-09 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
4310d0ed-3d59-4085-b4f1-0e7ffb31874f	The Stardust Thief	\N	"The Stardust Thief" is a fantasy novel inspired by Middle Eastern folklore, following a skilled thief who is forced into a quest to hunt down pieces of a fragmented, powerful artifact. She is joined by a jinn seeking to reclaim his lost magic and a dangerous prince haunted by a dark curse, as they grapple with themes of power, destiny, and the moral complexities of ambition. The trio journey through perilous landscapes, encountering magical creatures and ancient secrets that challenge their understanding of the world.	9780316368865	\N	\N	\N	520	pt 	https://covers.openlibrary.org/b/id/13515766-L.jpg	https://covers.openlibrary.org/b/id/13515766-S.jpg	https://covers.openlibrary.org/b/id/13515766-M.jpg	https://covers.openlibrary.org/b/id/13515766-L.jpg	\N	hardcover	like_new	18 x 20 cm	852	t	t	41.97	4.25	18.16	65.95	57	0	t	3.00	313	36	b4425276-c6c8-41c2-a5a4-08a8e406e149	\N	17739b35-27cb-41af-bb8d-d996f3519ee7	the-stardust-thief	{the,book}	2021-03-05 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
290f8912-5cf8-4771-a6f3-ec9da866d3e7	The Testaments	\N	"The Testaments" is a sequel to "The Handmaid's Tale" that explores the inner workings of Gilead through the perspectives of three women: Aunt Lydia, Agnes Jemima, and Daisy. Set fifteen years after the events of the first novel, the story reveals the burgeoning resistance movement against Gilead and the secrets that could bring it down. The novel examines themes of power, survival, and the complexities of complicity in oppressive regimes.	9780385543781	\N	\N	\N	138	pt 	https://covers.openlibrary.org/b/id/12366818-L.jpg	https://covers.openlibrary.org/b/id/12366818-S.jpg	https://covers.openlibrary.org/b/id/12366818-M.jpg	https://covers.openlibrary.org/b/id/12366818-L.jpg	\N	paperback	new	25 x 15 cm	615	t	f	12.75	4.00	10.80	43.13	57	0	t	3.90	4210	477	d4d531fd-9cf3-476a-a357-cf8d4ca8944e	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	the-testaments	{the,book}	2021-11-14 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
ce398622-71f1-46f4-afcc-53ae0361f631	The Underground Railroad	\N	"The Underground Railroad" tells the story of Cora, a young slave in Georgia, who escapes north seeking freedom with the help of the Underground Railroad. The novel reimagines the Underground Railroad as a literal railroad sabir, exploring the brutal realities of slavery and the varied landscapes of America during that time. The book delves into themes of freedom, trauma, and the enduring impact of racial injustice.	9780385542364	\N	\N	\N	233	es 	https://covers.openlibrary.org/b/id/7899016-L.jpg	https://covers.openlibrary.org/b/id/7899016-S.jpg	https://covers.openlibrary.org/b/id/7899016-M.jpg	https://covers.openlibrary.org/b/id/7899016-L.jpg	\N	paperback	like_new	18 x 16 cm	1002	t	f	24.56	1.06	10.79	38.45	2	0	t	3.80	3744	208	cf6063b1-4351-4a3a-b61c-c28791695ed6	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	the-underground-railroad	{the,book}	2024-11-15 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
f21d8987-d8bf-489e-a068-6369266d3fd0	The Warmth of paperback Suns	\N	"The Warmth of paperback Suns" chronicles the Great Migration of Black Americans fleeing the Jim Crow South for better opportunities in the North and West during the 20th century. It follows the individual journeys of three protagonists, each representing a different departure era and destination, highlighting their struggles and triumphs as they build new lives while grappling with the persistent challenges of racism and discrimination. The book examines the economic, social, and political forces driving this mass exodus and its profound impact on American society.	9780679444329	\N	\N	\N	784	fr 	https://covers.openlibrary.org/b/id/14951258-L.jpg	https://covers.openlibrary.org/b/id/14951258-S.jpg	https://covers.openlibrary.org/b/id/14951258-M.jpg	https://covers.openlibrary.org/b/id/14951258-L.jpg	\N	audiobook	very_good	25 x 14 cm	361	t	f	50.91	4.65	11.05	24.63	51	0	t	3.90	4403	181	e249648e-e538-4f15-9240-b8e96561b270	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	the-warmth-of-paperback-suns	{the,book}	2023-08-05 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
af9d51dd-fe4e-479e-af77-854242f1ffff	The Wrath and the Dawn	\N	"The Wrath and the Dawn" is a YA fantasy novel inspired by "One Thousand and One Nights" where a young woman, Shahrzad, volunteers to marry a caliph who takes a new bride each day and executes her the next. Instead of meeting her fate, Shahrzad uses her storytelling skills to survive and uncover the truth behind the caliph's actions while developing a complex relationship with him.	9780553535181	\N	\N	\N	150	en 	https://covers.openlibrary.org/b/id/8858222-L.jpg	https://covers.openlibrary.org/b/id/8858222-S.jpg	https://covers.openlibrary.org/b/id/8858222-M.jpg	https://covers.openlibrary.org/b/id/8858222-L.jpg	\N	hardcover	new	16 x 13 cm	244	t	f	29.72	5.49	9.29	60.20	29	0	t	4.80	2988	843	270f73e6-92fc-4d1a-a3c1-4824c98731f9	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	the-wrath-and-the-dawn	{the,book}	2023-08-29 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
31e6de7e-1e85-4565-87f1-140d98670c23	This Savage Song	\N	"This Savage Song" is a young adult urban fantasy novel set in a city divided between monstrous factions based on the types of sins they embody. The story follows Kate Harker, daughter of a crime lord who controls monsters, and August Flynn, a monster himself struggling to maintain his humanity while working for the city's paperback faction, as they navigate a complex and dangerous relationship while their city teeters on the brink of all-out war. The book explores themes of morality, prejudice, and the blurred lines between good and evil.	9780765376718	\N	\N	\N	685	de 	https://covers.openlibrary.org/b/id/8289187-L.jpg	https://covers.openlibrary.org/b/id/8289187-S.jpg	https://covers.openlibrary.org/b/id/8289187-M.jpg	https://covers.openlibrary.org/b/id/8289187-L.jpg	\N	audiobook	acceptable	22 x 11 cm	1303	t	t	10.72	1.52	9.21	39.19	31	0	t	0.60	4077	320	a5b394a0-1f88-436b-b1bc-66a16f9a18b6	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	this-savage-song	{this,book}	2024-04-12 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
bf42b2ff-49f8-4ee4-9170-c54e0c427c08	Throne of Glass	\N	\N	9781619630345	\N	\N	\N	236	es 	https://covers.openlibrary.org/b/id/14331115-L.jpg	https://covers.openlibrary.org/b/id/14331115-S.jpg	https://covers.openlibrary.org/b/id/14331115-M.jpg	https://covers.openlibrary.org/b/id/14331115-L.jpg	\N	paperback	new	15 x 11 cm	431	t	f	24.98	5.13	6.20	60.67	20	0	t	1.80	3205	966	7473cf07-c76e-40be-8b2b-6cd27e9a3a69	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	throne-of-glass	{throne,book}	2019-02-06 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
0009d0a3-d932-417c-8e05-560e54b6505a	Tomorrow, and Tomorrow, and Tomorrow	\N	"Tomorrow, and Tomorrow, and Tomorrow" follows the decades-long, complex relationship between Sam and Sadie, two childhood friends who reunite in college and collaborate to create a successful video game. The novel explores themes of love, friendship, ambition, grief, and the transformative power of games as the duo navigates creative partnership, personal struggles, and the challenges of success.	9780593321201	\N	\N	\N	332	it 	https://covers.openlibrary.org/b/id/12816990-L.jpg	https://covers.openlibrary.org/b/id/12816990-S.jpg	https://covers.openlibrary.org/b/id/12816990-M.jpg	https://covers.openlibrary.org/b/id/12816990-L.jpg	\N	paperback	good	22 x 18 cm	596	t	f	6.42	5.34	24.42	44.88	9	0	t	4.80	3613	296	8f608968-4016-4960-b5c1-7e480f98856d	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	tomorrow-and-tomorrow-and-tomorrow	{"tomorrow,",book}	2022-09-22 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
b490dbfa-1183-476d-8cff-23239c89ee4b	Tomorrow, and Tomorrow, and Tomorrow: Collector’s Edition	\N	\N	9780593321218	\N	\N	\N	564	pt 	https://covers.openlibrary.org/b/id/14403563-L.jpg	https://covers.openlibrary.org/b/id/14403563-S.jpg	https://covers.openlibrary.org/b/id/14403563-M.jpg	https://covers.openlibrary.org/b/id/14403563-L.jpg	\N	audiobook	like_new	23 x 19 cm	959	t	t	28.29	4.89	11.51	71.82	99	0	t	4.50	2399	207	8233595d-8f83-4922-9dae-c6251cb4555a	\N	6a151e20-73d9-45e0-94bf-be7a0f73f4cf	tomorrow-and-tomorrow-and-tomorrow-collector-s-edition	{"tomorrow,",book}	2023-03-05 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
d2c936f3-18c9-416d-a11b-bae4199cb449	Tower of Dawn	\N	"Tower of Dawn" follows Chaol Westfall as he travels to the southern continent of Antica to seek healing for his injuries and forge an alliance with the powerful healers there. While recovering, Chaol becomes embroiled in the political intrigue of the southern court and uncovers a threat to the world that could jeopardize the war effort in Adarlan. He also grapples with his personal demons and finds unexpected love and redemption.	9781619636101	\N	\N	\N	578	en 	https://covers.openlibrary.org/b/id/13316180-L.jpg	https://covers.openlibrary.org/b/id/13316180-S.jpg	https://covers.openlibrary.org/b/id/13316180-M.jpg	https://covers.openlibrary.org/b/id/13316180-L.jpg	\N	hardcover	acceptable	17 x 17 cm	281	t	t	21.34	2.49	8.72	46.31	59	0	t	4.40	1221	649	f973f2c4-89df-42de-95fa-94df8de40c1f	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	tower-of-dawn	{tower,book}	2023-11-10 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
cf36f9f8-4b5f-4fd7-b9d1-d123775314be	Trust	\N	"Trust" by Hernan Diaz explores the nature of truth, wealth, and power through four interconnected narratives that examine the life and legacy of a 1920s New York financier. Each part offers a different perspective on the same central figure and events, challenging the reader to question the reliability of memory and historical accounts, particularly regarding the making of a fortune.	9780593420317	\N	\N	\N	510	it 	https://covers.openlibrary.org/b/id/12742248-L.jpg	https://covers.openlibrary.org/b/id/12742248-S.jpg	https://covers.openlibrary.org/b/id/12742248-M.jpg	https://covers.openlibrary.org/b/id/12742248-L.jpg	\N	ebook	good	23 x 16 cm	301	t	t	46.95	2.52	5.42	39.08	48	0	t	3.60	593	859	269f6a55-da41-4c9b-9b7a-8bd88b84f5f3	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	trust	{trust,book}	2015-11-26 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
d9d7198c-9c55-46db-9cd0-d24b7efecf88	Under the Whispering Door	\N	"Under the Whispering Door" follows Wallace Price, a callous lawyer who dies unexpectedly and finds himself ushered to a tea shop where he learns he is actually dead and must grapple with his life's regrets. As he spends time at the tea shop, overseen by a ferryman and his companions, Wallace explores themes of grief, acceptance, and the potential for positive transformation after death.	9781250217394	\N	\N	\N	729	de 	https://covers.openlibrary.org/b/id/11943757-L.jpg	https://covers.openlibrary.org/b/id/11943757-S.jpg	https://covers.openlibrary.org/b/id/11943757-M.jpg	https://covers.openlibrary.org/b/id/11943757-L.jpg	\N	paperback	very_good	24 x 12 cm	1423	t	f	47.00	3.43	19.21	60.96	35	0	t	1.10	2749	348	de8e8306-a78f-4b64-a148-6380539a3fe8	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	under-the-whispering-door	{under,book}	2016-03-29 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
9fc934b4-373c-4e47-8e87-6bfac305f403	Vengeful	\N	"Vengeful" is a superhero novel that explores the complex relationship between two former college roommates who develop superpowers and become enemies. The story examines themes of morality, ambition, and the dangerous consequences of seeking power as they navigate a world where extraordinary abilities exist outside of traditional superhero narratives.	9780765379610	\N	\N	\N	508	fr 	https://covers.openlibrary.org/b/id/14668091-L.jpg	https://covers.openlibrary.org/b/id/14668091-S.jpg	https://covers.openlibrary.org/b/id/14668091-M.jpg	https://covers.openlibrary.org/b/id/14668091-L.jpg	\N	audiobook	new	23 x 14 cm	262	t	t	16.03	2.15	14.61	74.46	28	0	t	4.50	3381	749	ac5b8dcc-3cf8-4597-bb27-5ad824fa87e4	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	vengeful	{vengeful,book}	2021-03-06 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
31c6baac-7966-4ff0-b0dd-912889ef431f	Verity	\N	"Verity" is a psychological thriller following Lowen Ashleigh, a struggling writer hired to complete the remaining books in a bestselling series by the injured author, Verity Crawford. While living in the Crawford home, Lowen uncovers Verity's shocking autobiography, revealing a dark and twisted version of the family's past and forcing Lowen to question the truth about Verity's condition and the fate of her children.	9781791392796	\N	\N	\N	620	es 	https://covers.openlibrary.org/b/id/8747160-L.jpg	https://covers.openlibrary.org/b/id/8747160-S.jpg	https://covers.openlibrary.org/b/id/8747160-M.jpg	https://covers.openlibrary.org/b/id/8747160-L.jpg	\N	ebook	acceptable	15 x 20 cm	610	t	t	47.96	4.51	12.76	43.35	2	0	t	4.50	446	936	d6dce219-3ec6-45c6-9c30-fbd3e1fb89ad	\N	6a151e20-73d9-45e0-94bf-be7a0f73f4cf	verity	{verity,book}	2023-07-09 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
d1e5b180-2da0-463f-9bfa-8170b15bcfe3	War Storm	\N	"War Storm" is the fourth and final installment in Victoria Aveyard's Red Queen series. It depicts the culmination of Mare Barrow's rebellion against the Nortan monarchy as she navigates alliances, betrayals, and her own developing powers in a final battle for freedom and equality. The book explores themes of power, sacrifice, and the cost of revolution.	9780062310712	\N	\N	\N	106	pt 	https://covers.openlibrary.org/b/id/8738692-L.jpg	https://covers.openlibrary.org/b/id/8738692-S.jpg	https://covers.openlibrary.org/b/id/8738692-M.jpg	https://covers.openlibrary.org/b/id/8738692-L.jpg	\N	ebook	very_good	21 x 14 cm	1155	t	t	42.85	5.87	17.30	59.82	75	0	t	4.80	3759	399	b491b961-f64b-484f-8309-cb0728a3e461	\N	43f85820-0294-49e4-953c-ea119f2eb8f9	war-storm	{war,book}	2023-03-03 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
d3c81bd4-bd29-4236-a0d9-08b45ffacb78	Where the Crawdads Sing	\N	"Where the Crawdads Sing" tells the story of Kya, a young girl abandoned by her family and raised in the marshes of North Carolina. The novel follows Kya's coming-of-age as she learns to survive in isolation and explores themes of nature, prejudice, and the search for belonging, culminating in a murder mystery that puts her life at risk.	9780735219106	\N	\N	\N	149	pt 	https://covers.openlibrary.org/b/id/10671924-L.jpg	https://covers.openlibrary.org/b/id/10671924-S.jpg	https://covers.openlibrary.org/b/id/10671924-M.jpg	https://covers.openlibrary.org/b/id/10671924-L.jpg	\N	audiobook	good	23 x 15 cm	370	t	t	39.87	1.55	22.85	25.28	57	0	t	0.00	4459	460	2ca79427-0885-4119-8ab8-0a964cdf673e	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	where-the-crawdads-sing	{where,book}	2023-04-18 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
f37905f0-a109-4420-ab95-96e97a7d31b2	Wolf Hall	\N	"Wolf Hall" follows Thomas Cromwell's rise to power in the court of Henry VIII, navigating the complex political landscape surrounding the annulment of the king's marriage to Catherine of Aragon and his subsequent marriage to Anne Boleyn. The novel explores themes of ambition, power, and survival as Cromwell manipulates events and relationships to secure his own position and serve the king's interests.	9780312429980	\N	\N	\N	692	es 	https://covers.openlibrary.org/b/id/6466510-L.jpg	https://covers.openlibrary.org/b/id/6466510-S.jpg	https://covers.openlibrary.org/b/id/6466510-M.jpg	https://covers.openlibrary.org/b/id/6466510-L.jpg	\N	paperback	good	25 x 11 cm	315	t	f	33.34	4.06	14.96	73.23	54	0	t	0.20	4369	663	667ca47b-ca96-417f-a778-aff3c120aac9	\N	9afa3511-0ba6-4c66-b2f2-169c6815d139	wolf-hall	{wolf,book}	2017-06-19 00:00:00	2025-08-20 21:09:38.649364	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	\N	\N
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: sabir
--

COPY public.categories (category_id, category_name, description, parent_category_id, is_active, created_at, updated_at) FROM stdin;
9afa3511-0ba6-4c66-b2f2-169c6815d139	Fiction	Narrative literary works rooted in imagination.	\N	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
0ed7950e-5e69-4aac-b67d-d426d8ead6fe	Non-Fiction	Books based on factual information and real events.	\N	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
17739b35-27cb-41af-bb8d-d996f3519ee7	Science Fiction	Fiction dealing with futuristic concepts and advanced technology.	\N	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
43f85820-0294-49e4-953c-ea119f2eb8f9	Fantasy	Fiction involving magical or supernatural forces and beings.	\N	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
df3f99de-178a-4afb-8d5b-1e4b1baa42c2	Mystery	Fiction focused on solving a crime or uncovering secrets.	\N	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
84484d09-8b66-4ea7-9edc-106fd13ffd73	Romance	Fiction centered on love and romantic relationships.	\N	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
ec0889c4-d73c-4fd6-bdc1-2019b30354f4	Biography	A detailed description of a person's life.	\N	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
9d63c60f-7d13-44cb-9c19-441065e52970	History	The study of past events.	\N	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
6f658bbf-f7ec-4e3c-a308-14508f6f0227	Science	Systematic study of the structure and behavior of the physical and natural world.	\N	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
16d30dff-9a95-4782-b291-6f8b94de161f	Self-Help	Books intended to instruct readers on solving personal problems.	\N	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
7d26a24b-ae3b-49bb-9548-1018a5c2fee3	Comics	Narrative art form using sequential images, often combined with text.	\N	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
7714415f-2a2c-4c93-b573-c8636f2c43f1	Kids	Books specifically targeted at children, typically aged 0-12.	\N	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
976f1dbf-8f7e-47b1-963e-1248dc8878da	Literary Fiction	Fiction prioritizing aesthetic value, character development, and thematic depth.	9afa3511-0ba6-4c66-b2f2-169c6815d139	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
0b4c28ac-7736-4224-96af-e0fbe31bfd1b	Thriller	Fiction designed to keep readers on the edge of their seats.	9afa3511-0ba6-4c66-b2f2-169c6815d139	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
6a151e20-73d9-45e0-94bf-be7a0f73f4cf	Horror	Fiction intended to scare, unsettle, or horrify the audience.	9afa3511-0ba6-4c66-b2f2-169c6815d139	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
7a6b9d3b-dece-4c9b-bb09-9353b2162b4a	Memoir	A historical account or biography written from personal knowledge.	0ed7950e-5e69-4aac-b67d-d426d8ead6fe	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
3e0912eb-37da-4b7a-b2a1-957ce7880335	Essays	A piece of writing on a particular subject, often short and informal.	0ed7950e-5e69-4aac-b67d-d426d8ead6fe	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
12a94927-a872-4f85-bb9c-18d1bd716733	Travel	Books describing experiences, observations, and information about different places.	0ed7950e-5e69-4aac-b67d-d426d8ead6fe	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
fa7e1059-7a33-4976-8bbd-2e6189548642	Space Opera	Science fiction emphasizing space warfare, melodramatic adventure, and interplanetary conflicts.	17739b35-27cb-41af-bb8d-d996f3519ee7	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
2fdbc5bc-8d2d-44ff-a310-dd8935be5f92	Cyberpunk	Science fiction characterized by advanced technology and a breakdown or radical change in the social order.	17739b35-27cb-41af-bb8d-d996f3519ee7	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
7c78a105-695c-4a82-b99a-b4d0fdcb1915	High Fantasy	Fantasy set in an alternative, fictional ("secondary") world.	43f85820-0294-49e4-953c-ea119f2eb8f9	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
48505004-1f42-4e63-8239-97f58d28695f	Urban Fantasy	Fantasy where magical and supernatural forces battle it out in contemporary, real-world settings.	43f85820-0294-49e4-953c-ea119f2eb8f9	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
4eead143-9d1a-4833-983b-dc4db5423996	Paranormal Romance	Romance with fantasy or science fiction elements combined with romantic elements.	84484d09-8b66-4ea7-9edc-106fd13ffd73	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
e7a732e2-8fa5-404f-ad92-c6a8e74e4fd5	Manga	Japanese comic books and graphic novels, typically read from right to left.	7d26a24b-ae3b-49bb-9548-1018a5c2fee3	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
d93f78b4-ac63-42e7-9948-eeaf37454f94	Picture Books	Books intended for young children, typically featuring illustrations on every page.	7714415f-2a2c-4c93-b573-c8636f2c43f1	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
813e9cc2-5251-49d4-bee0-a85fd21934f7	Early Readers	Books designed for children who are beginning to read independently.	7714415f-2a2c-4c93-b573-c8636f2c43f1	t	2025-08-13 20:35:19.087386	2025-08-13 20:35:19.087386
\.


--
-- Data for Name: genres; Type: TABLE DATA; Schema: public; Owner: sabir
--

COPY public.genres (genre_id, genre_name, description, parent_genre_id, is_active, created_at, updated_at) FROM stdin;
f250adc5-8454-4ed3-81ff-dbde4c78bd1f	Adventure	Fiction featuring exciting, unusual, or dangerous activities.	\N	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
66eb7658-e0ec-42f2-81e5-dbf2fae92a7a	Comics	Narrative art form using sequential images, often combined with text.	\N	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
bf3da532-c2f1-412f-9ec1-00bef471b602	Dystopian	Fiction set in an imagined world where oppressive societal control is maintained through corporate, bureaucratic, technological, or totalitarian control.	\N	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
5c1074cd-d714-4d26-9612-e3b7cd658012	Epic Fantasy	Fantasy characterized by brave heroes, evil villains, and grand quests, often set in vast, detailed fantasy worlds.	\N	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
fa20b252-7783-4d1b-ad94-32105fe66f65	Historical Fiction	Fiction set in the past, often featuring famous historical figures or events.	\N	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
e88a4263-f077-4766-bcdf-1b7c585d211b	Horror	Fiction intended to frighten, unsettle, or create suspense.	\N	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
805dcfc3-1e6a-438a-99dc-ba561122d404	Humor	Fiction intended to be amusing or funny.	\N	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
e1ab905f-081f-4a7d-af4e-deabbd543583	Magical Realism	Fiction where magical elements are a natural part of an otherwise mundane, realistic environment.	\N	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
d593ca2c-74ac-404a-af1b-52f38f7f325b	Manga	Japanese comic books and graphic novels.	\N	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
1e2f9b36-f664-4981-89a4-181aaee35eec	Noir	Fiction characterized by cynical, suspicious, and sexually implicit characters; stark, often seedy, urban settings; and an atmosphere of moral ambiguity.	\N	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
9ae1fac3-0fd2-475e-bdfb-a916296450f1	Romance	Fiction dealing with romantic love, especially in a sentimental or idealized way.	\N	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
68e2ff8f-6716-4de9-99cf-990050bc8f92	Science Fiction	Fiction based on futuristic concepts such as advanced science and technology, space exploration, time travel, parallel universes, and extraterrestrial life.	\N	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
90923e17-feac-40d3-b71a-765b15dbc600	Steampunk	Fiction inspired by 19th-century industrial steam-powered machinery, often set in an alternative history of the Victorian era.	\N	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
202f2f51-ada8-430d-82e0-69c842374693	Superhero	Fiction featuring characters with superhuman abilities, dedicated to protecting the public.	\N	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
d9f01075-d55c-4023-ba92-8dc49a70f976	Urban Fantasy	Fantasy where magical and supernatural forces battle it out in contemporary, real-world settings.	\N	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
266310e8-0287-41e8-b5b0-fd0e237d438f	Young Adult	Fiction written for readers from 12 to 18 years of age.	\N	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
a7010a6c-d6e8-4003-887f-f6298c65c147	Zombie Apocalypse	Fiction centered around a world overrun by zombies, focusing on survival.	\N	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
19c3f489-1c50-442f-886d-0c12b920843f	Hard Science Fiction	Science fiction based on scientific accuracy and technological detail.	68e2ff8f-6716-4de9-99cf-990050bc8f92	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
24b6f710-3aef-4366-946b-e96c4ab9cee2	Space Opera	Science fiction featuring adventure stories set mainly or entirely in outer space.	68e2ff8f-6716-4de9-99cf-990050bc8f92	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
281180bb-22f5-4d70-ad6e-1ef83ac4075f	Space Western	Science fiction that transplants themes and tropes of the American Western to a backdrop of outer space.	\N	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
e24133c2-7389-4025-ac73-f115f2d4dd26	Time Travel Romance	Romance involving travel through time as a central plot device.	9ae1fac3-0fd2-475e-bdfb-a916296450f1	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
a0482b48-0021-4379-9f87-f33fdea112d5	Dark Fantasy	Fantasy that incorporates horror elements, presenting a darker, more frightening atmosphere.	5c1074cd-d714-4d26-9612-e3b7cd658012	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
11210297-4c99-4591-91af-523b7a12cdb3	Gothic Fiction	Fiction combining romanticism, horror, and death, often set in gloomy or mysterious places.	e88a4263-f077-4766-bcdf-1b7c585d211b	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
01d76067-7374-4d66-98a8-1dbb54b9b23a	Shonen	Manga genre targeted at adolescent boys, typically featuring action, adventure, and fighting.	d593ca2c-74ac-404a-af1b-52f38f7f325b	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
8cf9b6ad-3de3-4950-ac39-b7b21f29840e	Shojo	Manga genre targeted at adolescent girls, often focusing on romance, relationships, and emotions.	d593ca2c-74ac-404a-af1b-52f38f7f325b	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
c0c8c831-40d8-4e4d-8034-bb0ab8b4c682	Seinen	Manga genre targeted at adult men, covering a wide range of topics with more mature themes.	d593ca2c-74ac-404a-af1b-52f38f7f325b	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
2e0259ae-254f-4378-9761-53e3a3797cf0	Josei	Manga genre targeted at adult women, dealing with realistic and slice-of-life themes.	d593ca2c-74ac-404a-af1b-52f38f7f325b	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
34a002a9-a810-408e-abe7-f3c6dca0283f	Superhero Comics	Comics featuring characters with superhuman abilities.	66eb7658-e0ec-42f2-81e5-dbf2fae92a7a	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
62162227-45f3-444c-84b2-facde7d49fa1	Indie Comics	Independent comics, often self-published or published by small presses.	66eb7658-e0ec-42f2-81e5-dbf2fae92a7a	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
e2e54289-a55d-401a-a341-77e5b08023e0	Coming-of-Age	Fiction focusing on the psychological and moral growth of the protagonist from youth to adulthood.	266310e8-0287-41e8-b5b0-fd0e237d438f	t	2025-08-13 20:35:19.082213	2025-08-13 20:35:19.082213
\.


--
-- Data for Name: newsletter_subscribers; Type: TABLE DATA; Schema: public; Owner: sabir
--

COPY public.newsletter_subscribers (subscriber_id, email, is_subscribed, subscribed_at, unsubscribed_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: publishers; Type: TABLE DATA; Schema: public; Owner: sabir
--

COPY public.publishers (publisher_id, publisher_name, description, founded_year, country, website_url, is_active, created_at, updated_at) FROM stdin;
b31258cf-cbd7-421e-bf5a-6acce3f09fec	Alfred A. Knopf	A prestigious American publishing house known for literary fiction, nonfiction, and translated works, Alfred A. Knopf has been a hallmark of quality since 1915.	1915	USA	https://www.alfredaaknopf.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
765d4730-5349-4233-81e7-f6fc88d1d9fe	Amulet Books	An imprint of Abrams Books, Amulet specializes in middle grade and young adult fiction, including bestselling illustrated series.	1998	USA	https://www.amuletbooks.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
f048df88-e21a-444e-b3f6-fc85f6a911d5	Atria Books	A division of Simon & Schuster, Atria publishes a wide range of fiction and nonfiction with an emphasis on strong storytelling and diverse voices.	2002	USA	https://www.atriabooks.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
f269a424-0ba6-442b-8864-e5a882b6a676	Atria/Emily Bestler Books	An Atria Books imprint led by Emily Bestler, this publisher focuses on high-quality commercial fiction and compelling nonfiction.	2011	USA	https://www.atriaemilybestlerbooks.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
cf5cd761-4321-43f1-a0b8-f026d8cf8075	Ballantine Books	A major trade paperback and hardcover publisher under Penguin Random House, known for bestselling fiction, nonfiction, and genre titles.	1952	USA	https://www.ballantinebooks.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
e637db04-fc38-4291-8e43-f77bcc53642d	Berkley	An imprint of Penguin Random House, Berkley is known for romance, mystery, thrillers, and commercial women’s fiction.	1955	USA	https://www.berkley.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
7606a32a-84c5-46fd-8f5b-ac9a6d390393	Bloomsbury Publishing	A British independent publisher best known for the Harry Potter series, Bloomsbury produces literary fiction, nonfiction, children’s, and academic works.	1986	UK	https://www.bloomsbury.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
52235d58-73d6-4f9f-9421-faffd7c86b98	Crown Publishing Group	A division of Penguin Random House, Crown publishes award-winning nonfiction, memoirs, and commercial fiction.	1933	USA	https://www.crownpublishinggroup.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
08bb2523-7808-479b-af10-ae93ba6c171f	Del Rey	Specializing in science fiction and fantasy, Del Rey is a leading imprint under Penguin Random House with a legacy of genre-defining titles.	1977	USA	https://www.delrey.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
d0c003ca-cbac-4072-bb6c-0e2fb213eaf0	Doubleday	One of America’s oldest publishers, Doubleday is known for bestselling fiction, narrative nonfiction, and influential classics.	1897	USA	https://www.doubleday.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
9fb7694b-7e2d-4c91-8fdf-b572f27ac30c	Ecco	An imprint of HarperCollins, Ecco focuses on literary fiction, poetry, and high-quality nonfiction with a distinctive voice.	1971	USA	https://www.ecco.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
4101b113-69f1-403f-b2a1-ecb2bc2b2f8d	Entangled: Red Tower Books	A fantasy-focused imprint of Entangled Publishing, Red Tower Books champions romantic fantasy and speculative fiction.	2011	USA	https://www.entangledredtowerbooks.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
748e307c-7466-4919-943b-a1e4798b0f94	Europa Editions	An independent publisher based in Italy and New York, Europa Editions is known for literary fiction and international voices in translation.	2005	Italy	https://www.europaeditions.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
8cc4064a-2056-49a9-8ffb-bf7749bbb96c	Faber and Faber	A leading independent UK publisher, Faber and Faber is renowned for literary fiction, poetry, and award-winning nonfiction.	1929	UK	https://www.faber.co.uk	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
f733cf42-f539-41b9-8ee7-b51115b2a834	Farrar, Straus and Giroux	A prestigious imprint of Macmillan, FSG is known for literary fiction, nonfiction, poetry, and Nobel Prize-winning authors.	1946	USA	https://www.farrarstrausandgiroux.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
2e31929c-d38f-48a7-b4af-17aa20160afc	Feiwel & Friends	A children’s and young adult imprint of Macmillan, Feiwel & Friends publishes bestselling middle grade and teen novels.	2006	USA	https://www.feiwelandfriends.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
bf3e2477-8f5b-4cd4-8959-9fd1d7dafb9d	Flatiron Books	An innovative imprint of Macmillan, Flatiron publishes high-quality literary and commercial fiction, nonfiction, and memoirs.	2014	USA	https://www.flatironbooks.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
1883688e-855b-4d33-9997-b7fe05d436d9	G.P. Putnam's Sons	A respected American publisher known for bestselling thrillers, literary fiction, and nonfiction across genres.	1838	USA	https://www.gpputnamsons.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
0235941b-9bd0-435a-9b96-77a7c901f63f	Grove Press	An influential independent publisher, Grove Press is known for groundbreaking literary fiction, political nonfiction, and drama.	1947	USA	https://www.grovepress.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
347aef6d-165e-4d1e-afd9-b6dbe18a8fb6	Harper	Founded in 1817, Harper is one of the oldest US publishers, producing a broad range of literary fiction, nonfiction, and classics.	1817	USA	https://www.harper.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
f1d98936-9d9f-452e-81aa-648e1a167e85	Harper Voyager	The science fiction and fantasy imprint of HarperCollins, Harper Voyager publishes top speculative fiction authors worldwide.	1995	USA	https://www.harpervoyager.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
5cb0ce4a-5cd3-4d63-bec7-9f8ad3363afc	HarperCollins	One of the “Big Five” publishers, HarperCollins releases a vast catalog of fiction, nonfiction, children’s, and academic titles.	1989	USA	https://www.harpercollins.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
d6b45408-b0f9-4404-813c-8d37aa3813c8	HarperTeen	A young adult imprint of HarperCollins, HarperTeen publishes bestselling and award-winning teen novels across all genres.	1992	USA	https://www.harperteen.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
28e4fb5a-344d-43a2-8c74-dd93b807d165	Henry Holt Books for Young Readers	A children’s and YA imprint of Macmillan, publishing high-quality illustrated books and novels for young readers.	1866	USA	https://www.henryholtbooksforyoungreaders.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
a783263d-fb26-4c2f-a57a-e53008334e11	Henry Holt and Co.	A historic American publisher, Henry Holt and Co. produces literary fiction, nonfiction, and academic works.	1866	USA	https://www.henryholtandco.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
2191651d-4bf6-48fc-99cb-f751d681b126	Hogarth	A literary imprint of Penguin Random House, Hogarth focuses on bold, contemporary fiction with international appeal.	2012	UK	https://www.hogarthbooks.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
4bfec3af-a607-4664-819f-018037116bcc	Imprint	A children’s and YA imprint dedicated to publishing innovative, diverse, and engaging books across genres.	2016	USA	https://www.imprint.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
b4425276-c6c8-41c2-a5a4-08a8e406e149	Independently Published	A self-publishing designation for authors who release their work without a traditional publishing house.	2000	USA	https://www.independentlypublished.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
d4d531fd-9cf3-476a-a357-cf8d4ca8944e	Independently published	A self-publishing designation used by independent authors distributing their work digitally and in print.	2000	USA	https://www.independentlypublished.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
cf6063b1-4351-4a3a-b61c-c28791695ed6	Jonathan Cape	A literary imprint of Penguin Random House UK, Jonathan Cape is renowned for contemporary fiction, nonfiction, and graphic novels.	1921	UK	https://www.jonathancape.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
e249648e-e538-4f15-9240-b8e96561b270	Katherine Tegen Books	An imprint of HarperCollins specializing in young adult and middle grade fiction, often with strong emotional storytelling.	2003	USA	https://www.katherinetegenbooks.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
270f73e6-92fc-4d1a-a3c1-4824c98731f9	Knopf	A distinguished American publisher within Penguin Random House, Knopf is known for award-winning literary fiction and nonfiction.	1915	USA	https://www.knopf.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
a5b394a0-1f88-436b-b1bc-66a16f9a18b6	Knopf Books for Young Readers	A children’s imprint of Knopf, publishing picture books, middle grade, and YA titles with literary merit.	1915	USA	https://www.knopfbooksforyoungreaders.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
7473cf07-c76e-40be-8b2b-6cd27e9a3a69	Little, Brown and Company	A major American publisher, Little, Brown releases acclaimed fiction, nonfiction, and children’s books.	1837	USA	https://www.littlebrown.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
8f608968-4016-4960-b5c1-7e480f98856d	Margaret K. McElderry Books	An imprint of Simon & Schuster specializing in middle grade and young adult fiction, known for beloved fantasy and adventure series.	1972	USA	https://www.margaretkmcelderrybooks.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
8233595d-8f83-4922-9dae-c6251cb4555a	Montlake	An Amazon Publishing imprint focusing on romance and relationship-driven fiction.	2011	USA	https://www.montlake.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
f973f2c4-89df-42de-95fa-94df8de40c1f	Nan A. Talese	A literary imprint of Doubleday, known for publishing distinguished fiction and nonfiction by acclaimed authors.	1990	USA	https://www.nanatalese.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
269f6a55-da41-4c9b-9b7a-8bd88b84f5f3	Orbit	An international science fiction and fantasy publisher, Orbit is recognized for bestselling and award-winning genre fiction.	1974	USA	https://www.orbitbooks.net	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
de8e8306-a78f-4b64-a148-6380539a3fe8	Penguin Teen	A Penguin Random House imprint for young adult fiction, featuring bestselling and diverse voices for teen readers.	1984	USA	https://www.penguinteen.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
ac5b8dcc-3cf8-4597-bb27-5ad824fa87e4	Putnam Juvenile	The children’s imprint of G.P. Putnam’s Sons, publishing middle grade and YA titles across genres.	1838	USA	https://www.putnamjuvenile.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
d6dce219-3ec6-45c6-9c30-fbd3e1fb89ad	Random House	One of the world’s largest publishers, Random House releases a vast array of fiction, nonfiction, and children’s books.	1927	USA	https://www.randomhouse.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
b491b961-f64b-484f-8309-cb0728a3e461	Riverhead Books	An imprint of Penguin Random House, Riverhead is known for literary fiction, narrative nonfiction, and diverse global voices.	1994	USA	https://www.riverheadbooks.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
2ca79427-0885-4119-8ab8-0a964cdf673e	Scholastic Press	The flagship imprint of Scholastic Inc., publishing bestselling children’s and YA books worldwide.	1920	USA	https://www.scholasticpress.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
667ca47b-ca96-417f-a778-aff3c120aac9	Scribner	A historic American publisher known for literary fiction, memoir, and works by classic authors like F. Scott Fitzgerald and Stephen King.	1846	USA	https://www.scribner.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
e7ecbdcf-0cbe-43d4-bbf0-8266025ef98d	Sourcebooks Casablanca	An imprint of Sourcebooks specializing in romance and women’s fiction with broad commercial appeal.	1987	USA	https://www.sourcebookscasablanca.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
c0713d0f-2641-4fec-acd4-dd28fce3d041	St. Martin's Press	A major publisher under Macmillan, St. Martin’s Press offers bestselling fiction, nonfiction, and popular genre titles.	1952	USA	https://www.stmartinspress.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
6aaa19a7-a1dc-4c4e-8fec-4a6ebd9b72f6	Tor Books	The premier science fiction and fantasy imprint of Macmillan, Tor Books publishes top genre authors and award winners.	1980	USA	https://www.tor.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
ede44139-1594-4eab-8eda-71c725e8db41	Viking	An imprint of Penguin Random House, Viking is known for literary fiction, biography, and high-quality nonfiction.	1935	USA	https://www.viking.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
8cfc7f6a-9b30-4156-ac9c-a309a19944c5	W. W. Norton & Company	An independent, employee-owned publisher producing respected fiction, nonfiction, and academic works.	1923	USA	https://www.wwnorton.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
b6cb2138-0d37-48da-8c1e-cbbfa5d4391c	William Morrow	An imprint of HarperCollins, William Morrow publishes commercial fiction, nonfiction, and memoir.	1931	USA	https://www.williammorrow.com	t	2025-08-13 20:35:19.091258+00	2025-08-13 20:35:19.091258+00
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: sabir
--

COPY public.schema_migrations (version, applied_at) FROM stdin;
001_db_setup	2025-08-13 20:35:18.431625+00
002_create_users_table	2025-08-13 20:35:18.434422+00
003_create_publishers_table	2025-08-13 20:35:18.44874+00
004_create_authors_table	2025-08-13 20:35:18.464243+00
005_create_categories_table	2025-08-13 20:35:18.475126+00
006_create_genre_table	2025-08-13 20:35:18.484564+00
007_create_book_series_table	2025-08-13 20:35:18.493456+00
008_create_books_table	2025-08-13 20:35:18.500877+00
009_create_book_authors_table	2025-08-13 20:35:18.524355+00
010_create_book_categories_table	2025-08-13 20:35:18.52958+00
011_create_book_genres_table	2025-08-13 20:35:18.534734+00
012_create_book_series_entries_table	2025-08-13 20:35:18.540445+00
013_create_book_reviews_table	2025-08-13 20:35:18.545461+00
014_add_fuzzy_search_indexes	2025-08-13 20:35:18.557444+00
015_create_user_wishlist_table	2025-08-13 20:35:18.562436+00
017_create_user_follows_authors_table	2025-08-13 20:35:18.570957+00
018_create_newsletter_subscribers_table	2025-08-13 20:35:18.579411+00
018_insert_admin_user	2025-08-13 20:35:18.58755+00
\.


--
-- Data for Name: user_follows_authors; Type: TABLE DATA; Schema: public; Owner: sabir
--

COPY public.user_follows_authors (user_id, author_id, followed_at, notifications_enabled) FROM stdin;
\.


--
-- Data for Name: user_wishlist; Type: TABLE DATA; Schema: public; Owner: sabir
--

COPY public.user_wishlist (user_id, book_id, added_at, notes) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: sabir
--

COPY public.users (user_id, username, email, hashed_password, profile_image_url, credits, loyalty_points, is_verified, role, last_login, created_at, updated_at) FROM stdin;
00000000-0000-0000-0000-000000000000	admin	admin@yourapp.com	$2a$10$xut/KtRSzMPWqtJzKtuW6OPEi/pZ0/kYViJv6viuQvi0RkMCYHHiS	https://lh3.googleusercontent.com/a/ACg8ocLLFqF_XoYIow0FiqWXDcI9GK_WJNxsJBGVHcv87JyYa35fB1I=s288-c-no	1000000	0	t	admin	\N	2025-08-13 20:35:18.58755+00	2025-08-16 15:48:52.677575+00
85ebcd21-8d77-4026-9b16-8f21a4859d96	testuser3	testuser3@example.com	$2b$10$2YDhjHkqYIXOz6nwNx2IcudVhC2qLCqwrDNeJty9L5R/OIHluSboG	https://lh3.googleusercontent.com/a/ACg8ocLLFqF_XoYIow0FiqWXDcI9GK_WJNxsJBGVHcv87JyYa35fB1I=s288-c-no	0	0	f	admin	\N	2025-08-14 20:28:30.210138+00	2025-08-18 19:16:44.274329+00
ece2a2f1-1afb-4598-9f88-e0dedbc84e29	sabir20win	sabirwin10@gmail.com	$2b$10$jnqvL1kKnbVVh3uCZKO45eMQBQQgmAD1gO5ANcyMvASKHQuVZrthS	\N	0	0	f	admin	\N	2025-08-17 01:03:00.613593+00	2025-08-18 19:16:44.274329+00
520fbff8-cd1e-4b14-a795-435d84e84c84	rime	rime@koutabi.com	$2b$10$EZDw5ZTrxUWW0skonVRXIeMD5wRUNRbTzz/6athKWD7XBr1vZQnjK	\N	0	0	f	admin	\N	2025-08-18 19:13:08.791547+00	2025-08-18 19:16:44.274329+00
ae56df41-0f6a-4214-b054-0d887be48d2b	imam	imam@koutabi.com	$2b$10$BymURbQtmCU5hxcQ6ZTM3ONZ3G7wzDDgrjYG7Onozu.K.BYWb92Tm	\N	0	0	f	admin	\N	2025-08-18 19:13:57.912987+00	2025-08-18 19:16:44.274329+00
489e54e3-043d-4e2d-97a2-100ad4e2fec9	sabir	sabir@koutabi.com	$2b$10$OfvLxZAbjjaM2WAwOZKCxe6089O/d9tsv3/WxH.ko7ci1VWQyu3R2	\N	0	0	f	admin	\N	2025-08-18 19:14:51.151848+00	2025-08-18 19:16:44.274329+00
\.


--
-- Name: authors authors_pkey; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (author_id);


--
-- Name: book_reviews book_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.book_reviews
    ADD CONSTRAINT book_reviews_pkey PRIMARY KEY (review_id);


--
-- Name: book_series book_series_pkey; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.book_series
    ADD CONSTRAINT book_series_pkey PRIMARY KEY (series_id);


--
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (book_id);


--
-- Name: categories categories_category_name_key; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_category_name_key UNIQUE (category_name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (category_id);


--
-- Name: genres genres_pkey; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (genre_id);


--
-- Name: newsletter_subscribers newsletter_subscribers_pkey; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.newsletter_subscribers
    ADD CONSTRAINT newsletter_subscribers_pkey PRIMARY KEY (subscriber_id);


--
-- Name: book_authors pk_book_authors; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.book_authors
    ADD CONSTRAINT pk_book_authors PRIMARY KEY (book_id, author_id);


--
-- Name: book_categories pk_book_categories; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.book_categories
    ADD CONSTRAINT pk_book_categories PRIMARY KEY (book_id, category_id);


--
-- Name: book_genres pk_book_genres; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.book_genres
    ADD CONSTRAINT pk_book_genres PRIMARY KEY (book_id, genre_id);


--
-- Name: book_series_entries pk_book_series_entries; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.book_series_entries
    ADD CONSTRAINT pk_book_series_entries PRIMARY KEY (book_id, series_id);


--
-- Name: user_follows_authors pk_user_follows_authors; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.user_follows_authors
    ADD CONSTRAINT pk_user_follows_authors PRIMARY KEY (user_id, author_id);


--
-- Name: user_wishlist pk_user_wishlist; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.user_wishlist
    ADD CONSTRAINT pk_user_wishlist PRIMARY KEY (user_id, book_id);


--
-- Name: publishers publishers_pkey; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.publishers
    ADD CONSTRAINT publishers_pkey PRIMARY KEY (publisher_id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users unique_email; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT unique_email UNIQUE (email);


--
-- Name: genres unique_genre_name; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT unique_genre_name UNIQUE (genre_name);


--
-- Name: books unique_isbn_10; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT unique_isbn_10 UNIQUE (isbn_10);


--
-- Name: books unique_isbn_13; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT unique_isbn_13 UNIQUE (isbn_13);


--
-- Name: newsletter_subscribers unique_newsletter_email; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.newsletter_subscribers
    ADD CONSTRAINT unique_newsletter_email UNIQUE (email);


--
-- Name: publishers unique_publisher_name; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.publishers
    ADD CONSTRAINT unique_publisher_name UNIQUE (publisher_name);


--
-- Name: book_series_entries unique_series_volume; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.book_series_entries
    ADD CONSTRAINT unique_series_volume UNIQUE (series_id, volume_number);


--
-- Name: books unique_slug; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT unique_slug UNIQUE (slug);


--
-- Name: book_reviews unique_user_book_review; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.book_reviews
    ADD CONSTRAINT unique_user_book_review UNIQUE (book_id, user_id);


--
-- Name: users unique_username; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT unique_username UNIQUE (username);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: idx_authors_birth_date; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_authors_birth_date ON public.authors USING btree (birth_date);


--
-- Name: idx_authors_created_at; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_authors_created_at ON public.authors USING btree (created_at);


--
-- Name: idx_authors_first_name_gin_trgm; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_authors_first_name_gin_trgm ON public.authors USING gin (first_name public.gin_trgm_ops);


--
-- Name: idx_authors_full_name_gin_trgm; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_authors_full_name_gin_trgm ON public.authors USING gin (((((COALESCE(first_name, ''::character varying))::text || ' '::text) || (COALESCE(last_name, ''::character varying))::text)) public.gin_trgm_ops);


--
-- Name: idx_authors_last_name; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_authors_last_name ON public.authors USING btree (last_name);


--
-- Name: idx_authors_last_name_gin_trgm; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_authors_last_name_gin_trgm ON public.authors USING gin (last_name public.gin_trgm_ops);


--
-- Name: idx_authors_nationality; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_authors_nationality ON public.authors USING btree (nationality);


--
-- Name: idx_book_authors_author_id; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_book_authors_author_id ON public.book_authors USING btree (author_id);


--
-- Name: idx_book_categories_category_id; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_book_categories_category_id ON public.book_categories USING btree (category_id);


--
-- Name: idx_book_genres_genre_id; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_book_genres_genre_id ON public.book_genres USING btree (genre_id);


--
-- Name: idx_book_reviews_book_id; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_book_reviews_book_id ON public.book_reviews USING btree (book_id);


--
-- Name: idx_book_reviews_created_at; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_book_reviews_created_at ON public.book_reviews USING btree (created_at);


--
-- Name: idx_book_reviews_rating; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_book_reviews_rating ON public.book_reviews USING btree (rating);


--
-- Name: idx_book_reviews_user_id; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_book_reviews_user_id ON public.book_reviews USING btree (user_id);


--
-- Name: idx_book_reviews_verified; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_book_reviews_verified ON public.book_reviews USING btree (is_verified);


--
-- Name: idx_books_average_rating; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_books_average_rating ON public.books USING btree (average_rating);


--
-- Name: idx_books_deleted_at; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_books_deleted_at ON public.books USING btree (deleted_at);


--
-- Name: idx_books_for_rent_active; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_books_for_rent_active ON public.books USING btree (for_rent, is_active);


--
-- Name: idx_books_for_sale_active; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_books_for_sale_active ON public.books USING btree (for_sale, is_active);


--
-- Name: idx_books_isbn_combined_gin_trgm; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_books_isbn_combined_gin_trgm ON public.books USING gin (((((COALESCE(isbn_13, ''::character varying))::text || ' '::text) || (COALESCE(isbn_10, ''::character varying))::text)) public.gin_trgm_ops);


--
-- Name: idx_books_owner_id; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_books_owner_id ON public.books USING btree (owner_id);


--
-- Name: idx_books_primary_category_id; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_books_primary_category_id ON public.books USING btree (primary_category_id);


--
-- Name: idx_books_publication_date; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_books_publication_date ON public.books USING btree (publication_date);


--
-- Name: idx_books_publisher_id; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_books_publisher_id ON public.books USING btree (publisher_id);


--
-- Name: idx_books_search_keywords; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_books_search_keywords ON public.books USING gin (search_keywords);


--
-- Name: idx_books_subtitle_gin_trgm; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_books_subtitle_gin_trgm ON public.books USING gin (subtitle public.gin_trgm_ops);


--
-- Name: idx_books_title; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_books_title ON public.books USING btree (title);


--
-- Name: idx_books_title_gin_trgm; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_books_title_gin_trgm ON public.books USING gin (title public.gin_trgm_ops);


--
-- Name: idx_books_title_subtitle_gin_trgm; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_books_title_subtitle_gin_trgm ON public.books USING gin (((((COALESCE(title, ''::character varying))::text || ' '::text) || (COALESCE(subtitle, ''::character varying))::text)) public.gin_trgm_ops);


--
-- Name: idx_categories_active; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_categories_active ON public.categories USING btree (is_active) WHERE (is_active = true);


--
-- Name: idx_categories_name_gin_trgm; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_categories_name_gin_trgm ON public.categories USING gin (category_name public.gin_trgm_ops);


--
-- Name: idx_categories_parent_id; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_categories_parent_id ON public.categories USING btree (parent_category_id) WHERE (parent_category_id IS NOT NULL);


--
-- Name: idx_genres_active; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_genres_active ON public.genres USING btree (is_active) WHERE (is_active = true);


--
-- Name: idx_genres_parent_id; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_genres_parent_id ON public.genres USING btree (parent_genre_id) WHERE (parent_genre_id IS NOT NULL);


--
-- Name: idx_is_completed; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_is_completed ON public.book_series USING btree (is_completed) WHERE (is_completed = true);


--
-- Name: idx_newsletter_subscribers_email; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_newsletter_subscribers_email ON public.newsletter_subscribers USING btree (email);


--
-- Name: idx_newsletter_subscribers_subscribed; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_newsletter_subscribers_subscribed ON public.newsletter_subscribers USING btree (is_subscribed);


--
-- Name: idx_newsletter_subscribers_subscribed_at; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_newsletter_subscribers_subscribed_at ON public.newsletter_subscribers USING btree (subscribed_at);


--
-- Name: idx_publishers_active_country; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_publishers_active_country ON public.publishers USING btree (country, is_active) WHERE ((is_active = true) AND (country IS NOT NULL));


--
-- Name: idx_publishers_country; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_publishers_country ON public.publishers USING btree (country) WHERE (country IS NOT NULL);


--
-- Name: idx_publishers_created_at; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_publishers_created_at ON public.publishers USING btree (created_at);


--
-- Name: idx_publishers_founded_year; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_publishers_founded_year ON public.publishers USING btree (founded_year) WHERE (founded_year IS NOT NULL);


--
-- Name: idx_publishers_is_active; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_publishers_is_active ON public.publishers USING btree (is_active) WHERE (is_active = true);


--
-- Name: idx_publishers_name; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_publishers_name ON public.publishers USING btree (publisher_name);


--
-- Name: idx_series_name; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_series_name ON public.book_series USING btree (series_name);


--
-- Name: idx_user_follows_authors_author_id; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_user_follows_authors_author_id ON public.user_follows_authors USING btree (author_id);


--
-- Name: idx_user_follows_authors_followed_at; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_user_follows_authors_followed_at ON public.user_follows_authors USING btree (followed_at);


--
-- Name: idx_user_follows_authors_notifications; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_user_follows_authors_notifications ON public.user_follows_authors USING btree (author_id, notifications_enabled) WHERE (notifications_enabled = true);


--
-- Name: idx_user_follows_authors_user_id; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_user_follows_authors_user_id ON public.user_follows_authors USING btree (user_id);


--
-- Name: idx_user_wishlist_added_at; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_user_wishlist_added_at ON public.user_wishlist USING btree (added_at);


--
-- Name: idx_user_wishlist_book_id; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_user_wishlist_book_id ON public.user_wishlist USING btree (book_id);


--
-- Name: idx_user_wishlist_user_id; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_user_wishlist_user_id ON public.user_wishlist USING btree (user_id);


--
-- Name: idx_users_created_at; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_users_created_at ON public.users USING btree (created_at);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: idx_users_role; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_users_role ON public.users USING btree (role);


--
-- Name: idx_users_username; Type: INDEX; Schema: public; Owner: sabir
--

CREATE INDEX idx_users_username ON public.users USING btree (username);


--
-- Name: authors update_authors_updated_at; Type: TRIGGER; Schema: public; Owner: sabir
--

CREATE TRIGGER update_authors_updated_at BEFORE UPDATE ON public.authors FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: book_reviews update_book_reviews_updated_at; Type: TRIGGER; Schema: public; Owner: sabir
--

CREATE TRIGGER update_book_reviews_updated_at BEFORE UPDATE ON public.book_reviews FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: book_series update_book_series_updated_at; Type: TRIGGER; Schema: public; Owner: sabir
--

CREATE TRIGGER update_book_series_updated_at BEFORE UPDATE ON public.book_series FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: books update_books_updated_at; Type: TRIGGER; Schema: public; Owner: sabir
--

CREATE TRIGGER update_books_updated_at BEFORE UPDATE ON public.books FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: categories update_categories_updated_at; Type: TRIGGER; Schema: public; Owner: sabir
--

CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON public.categories FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: genres update_genres_updated_at; Type: TRIGGER; Schema: public; Owner: sabir
--

CREATE TRIGGER update_genres_updated_at BEFORE UPDATE ON public.genres FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: newsletter_subscribers update_newsletter_subscribers_updated_at; Type: TRIGGER; Schema: public; Owner: sabir
--

CREATE TRIGGER update_newsletter_subscribers_updated_at BEFORE UPDATE ON public.newsletter_subscribers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: publishers update_publishers_updated_at; Type: TRIGGER; Schema: public; Owner: sabir
--

CREATE TRIGGER update_publishers_updated_at BEFORE UPDATE ON public.publishers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: users update_users_updated_at; Type: TRIGGER; Schema: public; Owner: sabir
--

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: book_authors fk_book_authors_author; Type: FK CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.book_authors
    ADD CONSTRAINT fk_book_authors_author FOREIGN KEY (author_id) REFERENCES public.authors(author_id) ON DELETE CASCADE;


--
-- Name: book_authors fk_book_authors_book; Type: FK CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.book_authors
    ADD CONSTRAINT fk_book_authors_book FOREIGN KEY (book_id) REFERENCES public.books(book_id) ON DELETE CASCADE;


--
-- Name: book_categories fk_book_categories_book; Type: FK CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.book_categories
    ADD CONSTRAINT fk_book_categories_book FOREIGN KEY (book_id) REFERENCES public.books(book_id) ON DELETE CASCADE;


--
-- Name: book_categories fk_book_categories_category; Type: FK CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.book_categories
    ADD CONSTRAINT fk_book_categories_category FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON DELETE CASCADE;


--
-- Name: book_genres fk_book_genres_book; Type: FK CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.book_genres
    ADD CONSTRAINT fk_book_genres_book FOREIGN KEY (book_id) REFERENCES public.books(book_id) ON DELETE CASCADE;


--
-- Name: book_genres fk_book_genres_genre; Type: FK CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.book_genres
    ADD CONSTRAINT fk_book_genres_genre FOREIGN KEY (genre_id) REFERENCES public.genres(genre_id) ON DELETE CASCADE;


--
-- Name: book_reviews fk_book_reviews_book; Type: FK CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.book_reviews
    ADD CONSTRAINT fk_book_reviews_book FOREIGN KEY (book_id) REFERENCES public.books(book_id) ON DELETE CASCADE;


--
-- Name: book_reviews fk_book_reviews_user; Type: FK CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.book_reviews
    ADD CONSTRAINT fk_book_reviews_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: book_series_entries fk_book_series_entries_book; Type: FK CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.book_series_entries
    ADD CONSTRAINT fk_book_series_entries_book FOREIGN KEY (book_id) REFERENCES public.books(book_id) ON DELETE CASCADE;


--
-- Name: book_series_entries fk_book_series_entries_series; Type: FK CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.book_series_entries
    ADD CONSTRAINT fk_book_series_entries_series FOREIGN KEY (series_id) REFERENCES public.book_series(series_id) ON DELETE CASCADE;


--
-- Name: books fk_books_category; Type: FK CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT fk_books_category FOREIGN KEY (primary_category_id) REFERENCES public.categories(category_id);


--
-- Name: books fk_books_created_by; Type: FK CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT fk_books_created_by FOREIGN KEY (created_by) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: books fk_books_deleted_by; Type: FK CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT fk_books_deleted_by FOREIGN KEY (deleted_by) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: books fk_books_modified_by; Type: FK CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT fk_books_modified_by FOREIGN KEY (last_modified_by) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: books fk_books_owner; Type: FK CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT fk_books_owner FOREIGN KEY (owner_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: books fk_books_publisher; Type: FK CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT fk_books_publisher FOREIGN KEY (publisher_id) REFERENCES public.publishers(publisher_id) ON DELETE SET NULL;


--
-- Name: categories fk_parent_category; Type: FK CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT fk_parent_category FOREIGN KEY (parent_category_id) REFERENCES public.categories(category_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: genres fk_parent_genre; Type: FK CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT fk_parent_genre FOREIGN KEY (parent_genre_id) REFERENCES public.genres(genre_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: user_follows_authors fk_user_follows_authors_author; Type: FK CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.user_follows_authors
    ADD CONSTRAINT fk_user_follows_authors_author FOREIGN KEY (author_id) REFERENCES public.authors(author_id) ON DELETE CASCADE;


--
-- Name: user_follows_authors fk_user_follows_authors_user; Type: FK CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.user_follows_authors
    ADD CONSTRAINT fk_user_follows_authors_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: user_wishlist fk_user_wishlist_book; Type: FK CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.user_wishlist
    ADD CONSTRAINT fk_user_wishlist_book FOREIGN KEY (book_id) REFERENCES public.books(book_id) ON DELETE CASCADE;


--
-- Name: user_wishlist fk_user_wishlist_user; Type: FK CONSTRAINT; Schema: public; Owner: sabir
--

ALTER TABLE ONLY public.user_wishlist
    ADD CONSTRAINT fk_user_wishlist_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

