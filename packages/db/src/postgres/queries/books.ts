import { db } from "../client.js";
import { type Book, type BookWithDetails } from "@repo/types/types";

const parseBooks = (rows: unknown[]): Book[] => rows as Book[];

export const bookQueries = {
  async findTopRatedBooks(
    limit = 50,
    minRating = 4.0,
  ): Promise<BookWithDetails[]> {
    const result = await db.query(
      `SELECT 
         b.*,
         -- Primary Category
         pc.category_id as primary_category_id,
         pc.category_name as primary_category_name,
         pc.description as primary_category_description,
         pc.parent_category_id as primary_category_parent_id,
         
         -- Publisher Information  
         p.publisher_id,
         p.publisher_name,
         p.description as publisher_description,
         p.founded_year,
         p.country as publisher_country,
         p.website_url as publisher_website,
         p.is_active as publisher_is_active,
         
         -- Authors aggregation
         COALESCE(
           json_agg(
             jsonb_build_object(
               'author_id', a.author_id,
               'first_name', a.first_name,
               'last_name', a.last_name,
               'role', ba.role,
               'order_index', ba.order_index
             ) ORDER BY ba.order_index
           ) FILTER (WHERE a.author_id IS NOT NULL), 
           '[]'::json
         ) as authors,
         
         -- Author names concatenated for backward compatibility
         STRING_AGG(CONCAT(COALESCE(a.first_name, ''), ' ', a.last_name), ', ' ORDER BY ba.order_index) as author_name,
         
         -- Categories aggregation
         COALESCE(
           json_agg(
             DISTINCT jsonb_build_object(
               'category_id', c.category_id,
               'category_name', c.category_name,
               'description', c.description,
               'parent_category_id', c.parent_category_id
             )
           ) FILTER (WHERE c.category_id IS NOT NULL), 
           '[]'::json
         ) as categories,
         
         -- Genres aggregation  
         COALESCE(
           json_agg(
             DISTINCT jsonb_build_object(
               'genre_id', g.genre_id,
               'genre_name', g.genre_name,
               'description', g.description,
               'parent_genre_id', g.parent_genre_id
             )
           ) FILTER (WHERE g.genre_id IS NOT NULL), 
           '[]'::json
         ) as genres
         
       FROM books b
       
       -- Primary Category join
       LEFT JOIN categories pc ON b.primary_category_id = pc.category_id
       
       -- Publisher join
       LEFT JOIN publishers p ON b.publisher_id = p.publisher_id
       
       -- Authors join
       LEFT JOIN book_authors ba ON b.book_id = ba.book_id
       LEFT JOIN authors a ON ba.author_id = a.author_id
       
       -- All Categories join
       LEFT JOIN book_categories bc ON b.book_id = bc.book_id
       LEFT JOIN categories c ON bc.category_id = c.category_id AND c.is_active = true
       
       -- Genres join
       LEFT JOIN book_genres bg ON b.book_id = bg.book_id
       LEFT JOIN genres g ON bg.genre_id = g.genre_id AND g.is_active = true
       
       WHERE b.average_rating IS NOT NULL 
         AND b.average_rating::FLOAT >= $2
         AND b.is_active = true
       GROUP BY 
         b.book_id, 
         pc.category_id, 
         pc.category_name, 
         pc.description, 
         pc.parent_category_id,
         p.publisher_id,
         p.publisher_name,
         p.description,
         p.founded_year,
         p.country,
         p.website_url,
         p.is_active
       ORDER BY b.average_rating::FLOAT DESC
       LIMIT $1`,
      [limit, minRating],
    );

    return result.rows.map((book) => {
      const primary_category = book.primary_category_id
        ? {
            category_id: book.primary_category_id,
            category_name: book.primary_category_name,
            description: book.primary_category_description,
            parent_category_id: book.primary_category_parent_id,
          }
        : undefined;

      const publisher = book.publisher_id
        ? {
            publisher_id: book.publisher_id,
            publisher_name: book.publisher_name,
            description: book.publisher_description,
            founded_year: book.founded_year,
            country: book.publisher_country,
            website_url: book.publisher_website,
            is_active: book.publisher_is_active,
          }
        : undefined;

      return {
        ...book,
        primary_category,
        publisher,
        authors: book.authors || [],
        categories: book.categories || [],
        genres: book.genres || [],
      };
    }) as BookWithDetails[];
  },
  async findById(bookId: string): Promise<BookWithDetails | null> {
    const result = await db.query(
      `SELECT 
         b.*,
         -- Primary Category
         pc.category_id as primary_category_id,
         pc.category_name as primary_category_name,
         pc.description as primary_category_description,
         pc.parent_category_id as primary_category_parent_id,
         
         -- Publisher Information  
         p.publisher_id,
         p.publisher_name,
         p.description as publisher_description,
         p.founded_year,
         p.country as publisher_country,
         p.website_url as publisher_website,
         p.is_active as publisher_is_active,
         
         -- Authors aggregation
         COALESCE(
           json_agg(
             jsonb_build_object(
               'author_id', a.author_id,
               'first_name', a.first_name,
               'last_name', a.last_name,
               'role', ba.role,
               'order_index', ba.order_index
             ) ORDER BY ba.order_index
           ) FILTER (WHERE a.author_id IS NOT NULL), 
           '[]'::json
         ) as authors,
         
         -- Author names concatenated for backward compatibility
         STRING_AGG(CONCAT(COALESCE(a.first_name, ''), ' ', a.last_name), ', ' ORDER BY ba.order_index) as author_name,
         
         -- Categories aggregation
         COALESCE(
           json_agg(
             DISTINCT jsonb_build_object(
               'category_id', c.category_id,
               'category_name', c.category_name,
               'description', c.description,
               'parent_category_id', c.parent_category_id
             )
           ) FILTER (WHERE c.category_id IS NOT NULL), 
           '[]'::json
         ) as categories,
         
         -- Genres aggregation  
         COALESCE(
           json_agg(
             DISTINCT jsonb_build_object(
               'genre_id', g.genre_id,
               'genre_name', g.genre_name,
               'description', g.description,
               'parent_genre_id', g.parent_genre_id
             )
           ) FILTER (WHERE g.genre_id IS NOT NULL), 
           '[]'::json
         ) as genres
         
       FROM books b
       
       -- Primary Category join
       LEFT JOIN categories pc ON b.primary_category_id = pc.category_id
       
       -- Publisher join
       LEFT JOIN publishers p ON b.publisher_id = p.publisher_id
       
       -- Authors join
       LEFT JOIN book_authors ba ON b.book_id = ba.book_id
       LEFT JOIN authors a ON ba.author_id = a.author_id
       
       -- All Categories join
       LEFT JOIN book_categories bc ON b.book_id = bc.book_id
       LEFT JOIN categories c ON bc.category_id = c.category_id AND c.is_active = true
       
       -- Genres join
       LEFT JOIN book_genres bg ON b.book_id = bg.book_id
       LEFT JOIN genres g ON bg.genre_id = g.genre_id AND g.is_active = true
       
       WHERE b.book_id = $1
       GROUP BY 
         b.book_id, 
         pc.category_id, 
         pc.category_name, 
         pc.description, 
         pc.parent_category_id,
         p.publisher_id,
         p.publisher_name,
         p.description,
         p.founded_year,
         p.country,
         p.website_url,
         p.is_active
       LIMIT 1`,
      [bookId],
    );

    if (!result.rows[0]) return null;

    const book = result.rows[0];

    const primary_category = book.primary_category_id
      ? {
          category_id: book.primary_category_id,
          category_name: book.primary_category_name,
          description: book.primary_category_description,
          parent_category_id: book.primary_category_parent_id,
        }
      : undefined;

    const publisher = book.publisher_id
      ? {
          publisher_id: book.publisher_id,
          publisher_name: book.publisher_name,
          description: book.publisher_description,
          founded_year: book.founded_year,
          country: book.publisher_country,
          website_url: book.publisher_website,
          is_active: book.publisher_is_active,
        }
      : undefined;

    return {
      ...book,
      primary_category,
      publisher,
      authors: book.authors || [],
      categories: book.categories || [],
      genres: book.genres || [],
    } as BookWithDetails;
  },

  async findBooksByName(title: string, limit = 10): Promise<BookWithDetails[]> {
    const cleanQuery = title.trim().toLowerCase();
    const queryWords = cleanQuery
      .split(/\s+/)
      .filter((word) => word.length > 0);

    const result = await db.query(
      `
  WITH search_input AS (
    SELECT 
      $1::text AS original_query,
      $3::text AS clean_query,
      $4::text[] AS query_words
  ),
  scored_books AS (
    SELECT 
      b.*,
      -- Primary Category
      pc.category_id as primary_category_id,
      pc.category_name as primary_category_name,
      pc.description as primary_category_description,
      pc.parent_category_id as primary_category_parent_id,
      
      -- Publisher Information
      p.publisher_name,
      
      -- Aggregations
      COALESCE(
        json_agg(
          jsonb_build_object(
            'author_id', a.author_id,
            'first_name', a.first_name,
            'last_name', a.last_name,
            'role', ba.role,
            'order_index', ba.order_index
          ) ORDER BY ba.order_index
        ) FILTER (WHERE a.author_id IS NOT NULL), 
        '[]'::json
      ) as authors,
      
      -- Author names concatenated
      STRING_AGG(CONCAT(COALESCE(a.first_name, ''), ' ', a.last_name), ', ' ORDER BY ba.order_index) as author_name,
      
      COALESCE(
        json_agg(
          DISTINCT jsonb_build_object(
            'category_id', c.category_id,
            'category_name', c.category_name,
            'description', c.description,
            'parent_category_id', c.parent_category_id
          )
        ) FILTER (WHERE c.category_id IS NOT NULL), 
        '[]'::json
      ) as categories,
      
      COALESCE(
        json_agg(
          DISTINCT jsonb_build_object(
            'genre_id', g.genre_id,
            'genre_name', g.genre_name,
            'description', g.description,
            'parent_genre_id', g.parent_genre_id
          )
        ) FILTER (WHERE g.genre_id IS NOT NULL), 
        '[]'::json
      ) as genres,
      
      -- Similarity scoring (your existing logic)
      GREATEST(
        CASE 
          WHEN LOWER(b.title) = si.clean_query THEN 1.0
          WHEN LOWER(b.subtitle) = si.clean_query THEN 0.95
          WHEN LOWER(COALESCE(b.title, '') || ' ' || COALESCE(b.subtitle, '')) = si.clean_query THEN 0.9
          ELSE 0
        END,
        CASE 
          WHEN LOWER(b.title) LIKE si.clean_query || '%' THEN 0.85
          WHEN LOWER(b.subtitle) LIKE si.clean_query || '%' THEN 0.8
          ELSE 0
        END,
        CASE 
          WHEN LOWER(b.title) LIKE '%' || si.clean_query || '%' THEN 0.75
          WHEN LOWER(b.subtitle) LIKE '%' || si.clean_query || '%' THEN 0.7
          WHEN LOWER(COALESCE(b.title, '') || ' ' || COALESCE(b.subtitle, '')) LIKE '%' || si.clean_query || '%' THEN 0.65
          ELSE 0
        END,
        GREATEST(
          COALESCE(similarity(LOWER(b.title), si.clean_query), 0) * 0.8,
          COALESCE(similarity(LOWER(b.subtitle), si.clean_query), 0) * 0.75,
          COALESCE(similarity(LOWER(COALESCE(b.title, '') || ' ' || COALESCE(b.subtitle, '')), si.clean_query), 0) * 0.7
        )
      ) AS similarity_score,
      CASE 
        WHEN LENGTH(b.title) <= 50 THEN 0.05
        ELSE 0
      END AS length_bonus
      
    FROM books b
    
    -- Primary Category join
    LEFT JOIN categories pc ON b.primary_category_id = pc.category_id
    
    -- Publisher join
    LEFT JOIN publishers p ON b.publisher_id = p.publisher_id
    
    -- Authors join
    LEFT JOIN book_authors ba ON b.book_id = ba.book_id
    LEFT JOIN authors a ON ba.author_id = a.author_id
    
    -- All Categories join
    LEFT JOIN book_categories bc ON b.book_id = bc.book_id
    LEFT JOIN categories c ON bc.category_id = c.category_id AND c.is_active = true
    
    -- Genres join
    LEFT JOIN book_genres bg ON b.book_id = bg.book_id
    LEFT JOIN genres g ON bg.genre_id = g.genre_id AND g.is_active = true
    
    CROSS JOIN search_input si
    WHERE b.is_active = true
      AND (
        LOWER(b.title) LIKE '%' || si.clean_query || '%'
        OR LOWER(b.subtitle) LIKE '%' || si.clean_query || '%'
        OR LOWER(b.title) % si.clean_query
        OR LOWER(b.subtitle) % si.clean_query
        OR COALESCE(similarity(LOWER(b.title), si.clean_query), 0) > 0.2
        OR COALESCE(similarity(LOWER(b.subtitle), si.clean_query), 0) > 0.2
      )
    GROUP BY 
      b.book_id, 
      si.clean_query, 
      si.query_words,
      pc.category_id, 
      pc.category_name, 
      pc.description, 
      pc.parent_category_id,
      p.publisher_name
  )
  SELECT *
  FROM scored_books
  WHERE (similarity_score + length_bonus) >= 0.08
  ORDER BY 
    (similarity_score + length_bonus) DESC,
    LENGTH(title) ASC,
    title ASC
  LIMIT $2
  `,
      [title, limit, cleanQuery, queryWords],
    );

    return result.rows.map((book) => {
      const primary_category = book.primary_category_id
        ? {
            category_id: book.primary_category_id,
            category_name: book.primary_category_name,
            description: book.primary_category_description,
            parent_category_id: book.primary_category_parent_id,
          }
        : undefined;

      return {
        ...book,
        primary_category,
        authors: book.authors || [],
        categories: book.categories || [],
        genres: book.genres || [],
      };
    }) as BookWithDetails[];
  },
  async findNewReleases(
    limit = 50,
    daysRange = 365,
  ): Promise<BookWithDetails[]> {
    const result = await db.query(
      `SELECT 
         b.*,
         -- Primary Category
         pc.category_id as primary_category_id,
         pc.category_name as primary_category_name,
         pc.description as primary_category_description,
         pc.parent_category_id as primary_category_parent_id,
         
         -- Publisher Information  
         p.publisher_id,
         p.publisher_name,
         p.description as publisher_description,
         p.founded_year,
         p.country as publisher_country,
         p.website_url as publisher_website,
         p.is_active as publisher_is_active,
         
         -- Authors aggregation
         COALESCE(
           json_agg(
             jsonb_build_object(
               'author_id', a.author_id,
               'first_name', a.first_name,
               'last_name', a.last_name,
               'role', ba.role,
               'order_index', ba.order_index
             ) ORDER BY ba.order_index
           ) FILTER (WHERE a.author_id IS NOT NULL), 
           '[]'::json
         ) as authors,
         
         -- Author names concatenated for backward compatibility
         STRING_AGG(CONCAT(COALESCE(a.first_name, ''), ' ', a.last_name), ', ' ORDER BY ba.order_index) as author_name,
         
         -- Categories aggregation
         COALESCE(
           json_agg(
             DISTINCT jsonb_build_object(
               'category_id', c.category_id,
               'category_name', c.category_name,
               'description', c.description,
               'parent_category_id', c.parent_category_id
             )
           ) FILTER (WHERE c.category_id IS NOT NULL), 
           '[]'::json
         ) as categories,
         
         -- Genres aggregation  
         COALESCE(
           json_agg(
             DISTINCT jsonb_build_object(
               'genre_id', g.genre_id,
               'genre_name', g.genre_name,
               'description', g.description,
               'parent_genre_id', g.parent_genre_id
             )
           ) FILTER (WHERE g.genre_id IS NOT NULL), 
           '[]'::json
         ) as genres
         
       FROM books b
       
       -- Primary Category join
       LEFT JOIN categories pc ON b.primary_category_id = pc.category_id
       
       -- Publisher join
       LEFT JOIN publishers p ON b.publisher_id = p.publisher_id
       
       -- Authors join
       LEFT JOIN book_authors ba ON b.book_id = ba.book_id
       LEFT JOIN authors a ON ba.author_id = a.author_id
       
       -- All Categories join
       LEFT JOIN book_categories bc ON b.book_id = bc.book_id
       LEFT JOIN categories c ON bc.category_id = c.category_id AND c.is_active = true
       
       -- Genres join
       LEFT JOIN book_genres bg ON b.book_id = bg.book_id
       LEFT JOIN genres g ON bg.genre_id = g.genre_id AND g.is_active = true
       
       WHERE b.is_active = true
         AND (
           (b.publication_date IS NOT NULL AND b.publication_date::DATE >= (CURRENT_DATE - MAKE_INTERVAL(days => $2)))
           OR
           (b.published_year IS NOT NULL AND b.published_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 1)
           OR
           (b.created_at IS NOT NULL AND b.created_at::DATE >= (CURRENT_DATE - MAKE_INTERVAL(days => $2)))
         )
       GROUP BY 
         b.book_id, 
         pc.category_id, 
         pc.category_name, 
         pc.description, 
         pc.parent_category_id,
         p.publisher_id,
         p.publisher_name,
         p.description,
         p.founded_year,
         p.country,
         p.website_url,
         p.is_active
       ORDER BY 
         COALESCE(b.publication_date, b.created_at)::DATE DESC NULLS LAST,
         b.published_year DESC NULLS LAST
       LIMIT $1`,
      [limit, daysRange],
    );

    return result.rows.map((book) => {
      const primary_category = book.primary_category_id
        ? {
            category_id: book.primary_category_id,
            category_name: book.primary_category_name,
            description: book.primary_category_description,
            parent_category_id: book.primary_category_parent_id,
          }
        : undefined;

      const publisher = book.publisher_id
        ? {
            publisher_id: book.publisher_id,
            publisher_name: book.publisher_name,
            description: book.publisher_description,
            founded_year: book.founded_year,
            country: book.publisher_country,
            website_url: book.publisher_website,
            is_active: book.publisher_is_active,
          }
        : undefined;

      return {
        ...book,
        primary_category,
        publisher,
        authors: book.authors || [],
        categories: book.categories || [],
        genres: book.genres || [],
      };
    }) as BookWithDetails[];
  },

  async findPopularBooks(limit = 50): Promise<BookWithDetails[]> {
    const result = await db.query(
      `SELECT 
         b.*,
         -- Primary Category
         pc.category_id as primary_category_id,
         pc.category_name as primary_category_name,
         pc.description as primary_category_description,
         pc.parent_category_id as primary_category_parent_id,
         
         -- Publisher Information  
         p.publisher_id,
         p.publisher_name,
         p.description as publisher_description,
         p.founded_year,
         p.country as publisher_country,
         p.website_url as publisher_website,
         p.is_active as publisher_is_active,
         
         -- Authors aggregation
         COALESCE(
           json_agg(
             jsonb_build_object(
               'author_id', a.author_id,
               'first_name', a.first_name,
               'last_name', a.last_name,
               'role', ba.role,
               'order_index', ba.order_index
             ) ORDER BY ba.order_index
           ) FILTER (WHERE a.author_id IS NOT NULL), 
           '[]'::json
         ) as authors,
         
         -- Author names concatenated for backward compatibility
         STRING_AGG(CONCAT(COALESCE(a.first_name, ''), ' ', a.last_name), ', ' ORDER BY ba.order_index) as author_name,
         
         -- Categories aggregation
         COALESCE(
           json_agg(
             DISTINCT jsonb_build_object(
               'category_id', c.category_id,
               'category_name', c.category_name,
               'description', c.description,
               'parent_category_id', c.parent_category_id
             )
           ) FILTER (WHERE c.category_id IS NOT NULL), 
           '[]'::json
         ) as categories,
         
         -- Genres aggregation  
         COALESCE(
           json_agg(
             DISTINCT jsonb_build_object(
               'genre_id', g.genre_id,
               'genre_name', g.genre_name,
               'description', g.description,
               'parent_genre_id', g.parent_genre_id
             )
           ) FILTER (WHERE g.genre_id IS NOT NULL), 
           '[]'::json
         ) as genres
         
       FROM books b
       
       -- Primary Category join
       LEFT JOIN categories pc ON b.primary_category_id = pc.category_id
       
       -- Publisher join
       LEFT JOIN publishers p ON b.publisher_id = p.publisher_id
       
       -- Authors join
       LEFT JOIN book_authors ba ON b.book_id = ba.book_id
       LEFT JOIN authors a ON ba.author_id = a.author_id
       
       -- All Categories join
       LEFT JOIN book_categories bc ON b.book_id = bc.book_id
       LEFT JOIN categories c ON bc.category_id = c.category_id AND c.is_active = true
       
       -- Genres join
       LEFT JOIN book_genres bg ON b.book_id = bg.book_id
       LEFT JOIN genres g ON bg.genre_id = g.genre_id AND g.is_active = true
       
       WHERE b.is_active = true
         AND (b.total_reviews IS NOT NULL OR b.total_ratings IS NOT NULL)
       GROUP BY 
         b.book_id, 
         pc.category_id, 
         pc.category_name, 
         pc.description, 
         pc.parent_category_id,
         p.publisher_id,
         p.publisher_name,
         p.description,
         p.founded_year,
         p.country,
         p.website_url,
         p.is_active
       ORDER BY 
         COALESCE(b.total_reviews::INTEGER, 0) + COALESCE(b.total_ratings::INTEGER, 0) DESC
       LIMIT $1`,
      [limit],
    );

    return result.rows.map((book) => {
      const primary_category = book.primary_category_id
        ? {
            category_id: book.primary_category_id,
            category_name: book.primary_category_name,
            description: book.primary_category_description,
            parent_category_id: book.primary_category_parent_id,
          }
        : undefined;

      const publisher = book.publisher_id
        ? {
            publisher_id: book.publisher_id,
            publisher_name: book.publisher_name,
            description: book.publisher_description,
            founded_year: book.founded_year,
            country: book.publisher_country,
            website_url: book.publisher_website,
            is_active: book.publisher_is_active,
          }
        : undefined;

      return {
        ...book,
        primary_category,
        publisher,
        authors: book.authors || [],
        categories: book.categories || [],
        genres: book.genres || [],
      };
    }) as BookWithDetails[];
  },

  async findBooks(limit = 50): Promise<Book[]> {
    const result = await db.query(
      `SELECT * 
     FROM books 
     WHERE average_rating IS NOT NULL
     ORDER BY average_rating::FLOAT DESC
     LIMIT $1`,
      [limit],
    );

    return parseBooks(result.rows);
  },
};
