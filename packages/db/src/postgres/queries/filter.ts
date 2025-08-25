import { BookWithDetails } from "@repo/types/types";
import { db } from "../client.js";

// Add this interface to your types file
interface BookFilterOptions {
  title?: string;
  categories?: string[]; // Array of category IDs or names
  genres?: string[]; // Array of genre IDs or names
  minRating?: number;
  maxRating?: number;
  minPrice?: number;
  maxPrice?: number;
  formats?: string[]; // Array of book formats
  limit?: number;
  offset?: number;
}

// Add this to your bookQueries object
export const filterBookQueries = {
  async findBooksWithFilters(
    filters: BookFilterOptions = {},
  ): Promise<BookWithDetails[]> {
    const {
      title,
      categories = [],
      genres = [],
      minRating,
      maxRating,
      minPrice,
      maxPrice,
      formats = [],
      limit = 50,
      offset = 0,
    } = filters;

    let whereConditions: string[] = ["b.is_active = true"];
    let params: any[] = [];
    let paramIndex = 1;

    // Title filter with fuzzy search
    if (title && title.trim()) {
      const cleanTitle = title.trim().toLowerCase();
      whereConditions.push(`(
        LOWER(b.title) LIKE $${paramIndex} 
        OR LOWER(b.subtitle) LIKE $${paramIndex}
        OR COALESCE(similarity(LOWER(b.title), $${paramIndex + 1}), 0) > 0.3
        OR COALESCE(similarity(LOWER(b.subtitle), $${paramIndex + 1}), 0) > 0.3
      )`);
      params.push(`%${cleanTitle}%`, cleanTitle);
      paramIndex += 2;
    }

    // Category filters
    if (categories.length > 0) {
      // Check if categories are UUIDs or names
      const isUUID = categories[0]?.match(
        /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i,
      );

      if (isUUID) {
        whereConditions.push(`(
          b.primary_category_id = ANY($${paramIndex})
          OR EXISTS (
            SELECT 1 FROM book_categories bc2 
            WHERE bc2.book_id = b.book_id 
            AND bc2.category_id = ANY($${paramIndex})
          )
        )`);
      } else {
        whereConditions.push(`(
          pc.category_name = ANY($${paramIndex})
          OR EXISTS (
            SELECT 1 FROM book_categories bc2 
            JOIN categories c2 ON bc2.category_id = c2.category_id
            WHERE bc2.book_id = b.book_id 
            AND c2.category_name = ANY($${paramIndex})
            AND c2.is_active = true
          )
        )`);
      }
      params.push(categories);
      paramIndex++;
    }

    // Genre filters
    if (genres.length > 0) {
      const isUUID = genres[0]?.match(
        /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i,
      );

      if (isUUID) {
        whereConditions.push(`EXISTS (
          SELECT 1 FROM book_genres bg2 
          WHERE bg2.book_id = b.book_id 
          AND bg2.genre_id = ANY($${paramIndex})
        )`);
      } else {
        whereConditions.push(`EXISTS (
          SELECT 1 FROM book_genres bg2 
          JOIN genres g2 ON bg2.genre_id = g2.genre_id
          WHERE bg2.book_id = b.book_id 
          AND g2.genre_name = ANY($${paramIndex})
          AND g2.is_active = true
        )`);
      }
      params.push(genres);
      paramIndex++;
    }

    // Rating filters
    if (minRating !== undefined) {
      whereConditions.push(`b.average_rating >= $${paramIndex}`);
      params.push(minRating);
      paramIndex++;
    }

    if (maxRating !== undefined) {
      whereConditions.push(`b.average_rating <= $${paramIndex}`);
      params.push(maxRating);
      paramIndex++;
    }

    // Price filters
    if (minPrice !== undefined) {
      whereConditions.push(`b.price_sale >= $${paramIndex}`);
      params.push(minPrice);
      paramIndex++;
    }

    if (maxPrice !== undefined) {
      whereConditions.push(`b.price_sale <= $${paramIndex}`);
      params.push(maxPrice);
      paramIndex++;
    }

    // Format filters
    if (formats.length > 0) {
      whereConditions.push(`b.book_format = ANY($${paramIndex})`);
      params.push(formats);
      paramIndex++;
    }

    // Add limit and offset parameters
    params.push(limit, offset);
    const limitParam = paramIndex;
    const offsetParam = paramIndex + 1;

    const whereClause =
      whereConditions.length > 0
        ? `WHERE ${whereConditions.join(" AND ")}`
        : "";

    const query = `
      SELECT 
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
        ) as genres,

        -- Optional: Add similarity score for title searches
        ${
          title
            ? `
        GREATEST(
          CASE 
            WHEN LOWER(b.title) = $2 THEN 1.0
            WHEN LOWER(b.subtitle) = $2 THEN 0.95
            ELSE 0
          END,
          CASE 
            WHEN LOWER(b.title) LIKE $2 || '%' THEN 0.85
            WHEN LOWER(b.subtitle) LIKE $2 || '%' THEN 0.8
            ELSE 0
          END,
          GREATEST(
            COALESCE(similarity(LOWER(b.title), $2), 0) * 0.8,
            COALESCE(similarity(LOWER(b.subtitle), $2), 0) * 0.75
          )
        ) AS title_relevance_score
        `
            : "NULL as title_relevance_score"
        }
        
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
      
      ${whereClause}
      
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
        ${title ? "title_relevance_score DESC," : ""}
        b.average_rating DESC NULLS LAST,
        b.total_ratings DESC,
        b.title ASC
      
      LIMIT $${limitParam} OFFSET $${offsetParam}
    `;

    const result = await db.query(query, params);

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

  // Helper function to get total count for pagination
  async countBooksWithFilters(
    filters: BookFilterOptions = {},
  ): Promise<number> {
    const {
      title,
      categories = [],
      genres = [],
      minRating,
      maxRating,
      minPrice,
      maxPrice,
      formats = [],
    } = filters;

    let whereConditions: string[] = ["b.is_active = true"];
    let params: any[] = [];
    let paramIndex = 1;

    // Same filter logic as above but simplified for counting
    if (title && title.trim()) {
      const cleanTitle = title.trim().toLowerCase();
      whereConditions.push(`(
        LOWER(b.title) LIKE $${paramIndex} 
        OR LOWER(b.subtitle) LIKE $${paramIndex}
        OR COALESCE(similarity(LOWER(b.title), $${paramIndex + 1}), 0) > 0.3
        OR COALESCE(similarity(LOWER(b.subtitle), $${paramIndex + 1}), 0) > 0.3
      )`);
      params.push(`%${cleanTitle}%`, cleanTitle);
      paramIndex += 2;
    }

    if (categories.length > 0) {
      const isUUID = categories[0]?.match(
        /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i,
      );

      if (isUUID) {
        whereConditions.push(`(
          b.primary_category_id = ANY($${paramIndex})
          OR EXISTS (
            SELECT 1 FROM book_categories bc2 
            WHERE bc2.book_id = b.book_id 
            AND bc2.category_id = ANY($${paramIndex})
          )
        )`);
      } else {
        whereConditions.push(`(
          EXISTS (
            SELECT 1 FROM categories pc 
            WHERE pc.category_id = b.primary_category_id 
            AND pc.category_name = ANY($${paramIndex})
          )
          OR EXISTS (
            SELECT 1 FROM book_categories bc2 
            JOIN categories c2 ON bc2.category_id = c2.category_id
            WHERE bc2.book_id = b.book_id 
            AND c2.category_name = ANY($${paramIndex})
            AND c2.is_active = true
          )
        )`);
      }
      params.push(categories);
      paramIndex++;
    }

    if (genres.length > 0) {
      const isUUID = genres[0]?.match(
        /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i,
      );

      if (isUUID) {
        whereConditions.push(`EXISTS (
          SELECT 1 FROM book_genres bg2 
          WHERE bg2.book_id = b.book_id 
          AND bg2.genre_id = ANY($${paramIndex})
        )`);
      } else {
        whereConditions.push(`EXISTS (
          SELECT 1 FROM book_genres bg2 
          JOIN genres g2 ON bg2.genre_id = g2.genre_id
          WHERE bg2.book_id = b.book_id 
          AND g2.genre_name = ANY($${paramIndex})
          AND g2.is_active = true
        )`);
      }
      params.push(genres);
      paramIndex++;
    }

    if (minRating !== undefined) {
      whereConditions.push(`b.average_rating >= $${paramIndex}`);
      params.push(minRating);
      paramIndex++;
    }

    if (maxRating !== undefined) {
      whereConditions.push(`b.average_rating <= $${paramIndex}`);
      params.push(maxRating);
      paramIndex++;
    }

    if (minPrice !== undefined) {
      whereConditions.push(`b.price_sale >= $${paramIndex}`);
      params.push(minPrice);
      paramIndex++;
    }

    if (maxPrice !== undefined) {
      whereConditions.push(`b.price_sale <= $${paramIndex}`);
      params.push(maxPrice);
      paramIndex++;
    }

    if (formats.length > 0) {
      whereConditions.push(`b.book_format = ANY($${paramIndex})`);
      params.push(formats);
      paramIndex++;
    }

    const whereClause =
      whereConditions.length > 0
        ? `WHERE ${whereConditions.join(" AND ")}`
        : "";

    const query = `
      SELECT COUNT(DISTINCT b.book_id) as total
      FROM books b
      ${whereClause}
    `;

    const result = await db.query(query, params);
    return parseInt(result.rows[0].total);
  },
};
