import { db } from "../client.js";
import { type Book } from "../types/book-types.js";

const parseBooks = (rows: unknown[]): Book[] => rows as Book[];

export const bookQueries = {
  async findById(bookId: string): Promise<Book | null> {
    const result = await db.query(
      "SELECT * FROM books WHERE book_id = $1 LIMIT 1",
      [bookId],
    );
    return result.rows[0] ? (result.rows[0] as Book) : null;
  },

  async findBooks(limit = 50): Promise<Book[]> {
    const result = await db.query(
      "SELECT * FROM books ORDER BY title ASC LIMIT $1",
      [limit],
    );
    return parseBooks(result.rows);
  },

  async findBooksByName(title: string, limit = 10): Promise<Book[]> {
    const result = await db.query(
      `SELECT *,
       GREATEST(
         COALESCE(similarity(title, $1), 0),
         COALESCE(similarity(subtitle, $1), 0),
         COALESCE(similarity(title || ' ' || COALESCE(subtitle, ''), $1), 0)
       ) AS similarity_score
       FROM books
       WHERE (title % $1 OR subtitle % $1 OR (title || ' ' || COALESCE(subtitle, '')) % $1)
       AND GREATEST(
         COALESCE(similarity(title, $1), 0),
         COALESCE(similarity(subtitle, $1), 0),
         COALESCE(similarity(title || ' ' || COALESCE(subtitle, ''), $1), 0)
       ) >= 0.2
       AND is_active = true
       ORDER BY similarity_score DESC
       LIMIT $2`,
      [title, limit],
    );
    return parseBooks(result.rows);
  },

  async findBooksByAuthor(authorName: string, limit = 20): Promise<Book[]> {
    const result = await db.query(
      `SELECT DISTINCT b.*,
       GREATEST(
         COALESCE(similarity(a.first_name, $1), 0),
         COALESCE(similarity(a.last_name, $1), 0),
         COALESCE(similarity(a.first_name || ' ' || a.last_name, $1), 0)
       ) AS similarity_score
       FROM books b
       INNER JOIN book_authors ba ON b.book_id = ba.book_id
       INNER JOIN authors a ON ba.author_id = a.author_id
       WHERE (a.first_name % $1 OR a.last_name % $1 OR (a.first_name || ' ' || a.last_name) % $1)
       AND GREATEST(
         COALESCE(similarity(a.first_name, $1), 0),
         COALESCE(similarity(a.last_name, $1), 0),
         COALESCE(similarity(a.first_name || ' ' || a.last_name, $1), 0)
       ) >= 0.2
       AND b.is_active = true
       ORDER BY similarity_score DESC
       LIMIT $2`,
      [authorName, limit],
    );
    return parseBooks(result.rows);
  },

  async findBooksByCategory(categoryName: string, limit = 20): Promise<Book[]> {
    const result = await db.query(
      `SELECT DISTINCT b.*, similarity(c.category_name, $1) AS similarity_score
       FROM books b
       INNER JOIN book_categories bc ON b.book_id = bc.book_id
       INNER JOIN categories c ON bc.category_id = c.category_id
       WHERE c.category_name % $1
       AND similarity(c.category_name, $1) >= 0.3
       AND b.is_active = true
       AND c.is_active = true
       ORDER BY similarity_score DESC
       LIMIT $2`,
      [categoryName, limit],
    );
    return parseBooks(result.rows);
  },

  async findNewReleases(days = 30, limit = 20): Promise<Book[]> {
    const result = await db.query(
      `SELECT *
       FROM books
       WHERE publication_date >= NOW() - INTERVAL '${days} days'
       AND is_active = true
       ORDER BY publication_date DESC
       LIMIT $1`,
      [limit],
    );
    return parseBooks(result.rows);
  },

  //TODO: ADD sales_rank later
  // async findBestsellers(limit = 20): Promise<Book[]> {
  //   const result = await db.query(
  //     `SELECT *
  //      FROM books
  //      WHERE sales_rank IS NOT NULL
  //      ORDER BY sales_rank ASC
  //      LIMIT $1`,
  //     [limit],
  //   );
  //   return parseBooks(result.rows);
  // },

  async findBooksByISBN(isbn: string, limit = 5): Promise<Book[]> {
    const result = await db.query(
      `SELECT *,
       GREATEST(
         COALESCE(similarity(isbn_13, $1), 0),
         COALESCE(similarity(isbn_10, $1), 0)
       ) AS similarity_score
       FROM books
       WHERE (isbn_13 % $1 OR isbn_10 % $1)
       AND GREATEST(
         COALESCE(similarity(isbn_13, $1), 0),
         COALESCE(similarity(isbn_10, $1), 0)
       ) >= 0.3
       AND is_active = true
       ORDER BY similarity_score DESC
       LIMIT $2`,
      [isbn, limit],
    );
    return parseBooks(result.rows);
  },

  async findRelatedBooks(bookId: string, limit = 10): Promise<Book[]> {
    const result = await db.query(
      `SELECT DISTINCT b.*, similarity(c.category_name, related.category_name) AS similarity_score
       FROM books b
       INNER JOIN book_categories bc ON b.book_id = bc.book_id
       INNER JOIN categories c ON bc.category_id = c.category_id
       JOIN (
         SELECT DISTINCT c2.category_name
         FROM books b2
         INNER JOIN book_categories bc2 ON b2.book_id = bc2.book_id
         INNER JOIN categories c2 ON bc2.category_id = c2.category_id
         WHERE b2.book_id = $1
       ) AS related ON c.category_name % related.category_name
       WHERE b.book_id <> $1
       AND b.is_active = true
       AND c.is_active = true
       ORDER BY similarity_score DESC
       LIMIT $2`,
      [bookId, limit],
    );
    return parseBooks(result.rows);
  },

  async findBooksByMultipleAuthors(
    authorNames: string[],
    limit = 20,
  ): Promise<Book[]> {
    const result = await db.query(
      `SELECT DISTINCT b.*,
       MAX(GREATEST(
         COALESCE(similarity(a.first_name, ANY($1::text[])), 0),
         COALESCE(similarity(a.last_name, ANY($1::text[])), 0),
         COALESCE(similarity(a.first_name || ' ' || a.last_name, ANY($1::text[])), 0)
       )) AS similarity_score
       FROM books b
       INNER JOIN book_authors ba ON b.book_id = ba.book_id
       INNER JOIN authors a ON ba.author_id = a.author_id
       WHERE EXISTS (
         SELECT 1 FROM unnest($1::text[]) AS search_term
         WHERE a.first_name % search_term OR a.last_name % search_term OR (a.first_name || ' ' || a.last_name) % search_term
       )
       AND b.is_active = true
       GROUP BY b.book_id
       ORDER BY similarity_score DESC
       LIMIT $2`,
      [authorNames, limit],
    );
    return parseBooks(result.rows);
  },

  async findBooksByMultipleCategories(
    categoryNames: string[],
    limit = 20,
  ): Promise<Book[]> {
    const result = await db.query(
      `SELECT DISTINCT b.*,
       MAX(similarity(c.category_name, ANY($1::text[]))) AS similarity_score
       FROM books b
       INNER JOIN book_categories bc ON b.book_id = bc.book_id
       INNER JOIN categories c ON bc.category_id = c.category_id
       WHERE EXISTS (
         SELECT 1 FROM unnest($1::text[]) AS search_term
         WHERE c.category_name % search_term
       )
       AND b.is_active = true
       AND c.is_active = true
       GROUP BY b.book_id
       ORDER BY similarity_score DESC
       LIMIT $2`,
      [categoryNames, limit],
    );
    return parseBooks(result.rows);
  },

  async filterBooks(
    filters: {
      title?: string;
      authorName?: string;
      categoryName?: string;
      minRating?: number;
      maxPrice?: number;
      format?: string;
      inStock?: boolean;
      forSale?: boolean;
      forRent?: boolean;
      language?: string;
      publisherId?: string;
      publishedAfter?: string;
      publishedBefore?: string;
    },
    limit = 20,
    offset = 0,
  ): Promise<Book[]> {
    // Base query with joins
    let query = `
      SELECT DISTINCT b.*
      FROM books b
    `;

    // Add conditional joins only when needed
    const joins: string[] = [];
    const whereConditions: string[] = ["b.is_active = true"];
    const queryParams: any[] = [];
    let paramCounter = 1;

    // Title filter with fuzzy search (similar to findBooksByName)
    if (filters.title) {
      queryParams.push(filters.title);
      whereConditions.push("(b.title % $" + paramCounter + " OR b.subtitle % $" + paramCounter + " OR (b.title || ' ' || COALESCE(b.subtitle, '')) % $" + paramCounter + ")");
      paramCounter++;
    }

    // Author filter with fuzzy search (similar to findBooksByAuthor)
    if (filters.authorName) {
      joins.push(`
        INNER JOIN book_authors ba ON b.book_id = ba.book_id
        INNER JOIN authors a ON ba.author_id = a.author_id
      `);
      queryParams.push(filters.authorName);
      whereConditions.push("(a.first_name % $" + paramCounter + " OR a.last_name % $" + paramCounter + " OR (a.first_name || ' ' || a.last_name) % $" + paramCounter + ")");
      paramCounter++;
    }

    // Category filter with case-insensitive partial match
    if (filters.categoryName) {
      joins.push(`
        INNER JOIN book_categories bc ON b.book_id = bc.book_id
        INNER JOIN categories c ON bc.category_id = c.category_id
      `);
      queryParams.push("%" + filters.categoryName + "%");
      whereConditions.push("LOWER(c.category_name) LIKE LOWER($" + paramCounter + ")");
      paramCounter++;
    }

    // Minimum rating filter
    if (filters.minRating !== undefined) {
      queryParams.push(filters.minRating);
      whereConditions.push("b.average_rating >= $" + paramCounter);
      paramCounter++;
    }

    // Maximum price filter
    if (filters.maxPrice !== undefined) {
      queryParams.push(filters.maxPrice);
      whereConditions.push("b.price_sale <= $" + paramCounter);
      paramCounter++;
    }

    // Format filter
    if (filters.format) {
      queryParams.push(filters.format);
      whereConditions.push("b.book_format = $" + paramCounter);
      paramCounter++;
    }

    // In stock filter
    if (filters.inStock !== undefined) {
      if (filters.inStock) {
        whereConditions.push("b.stock_quantity > b.reserved_quantity");
      } else {
        whereConditions.push("b.stock_quantity <= b.reserved_quantity");
      }
    }

    // For sale filter
    if (filters.forSale !== undefined) {
      queryParams.push(filters.forSale);
      whereConditions.push("b.for_sale = $" + paramCounter);
      paramCounter++;
    }

    // For rent filter
    if (filters.forRent !== undefined) {
      queryParams.push(filters.forRent);
      whereConditions.push("b.for_rent = $" + paramCounter);
      paramCounter++;
    }

    // Language filter
    if (filters.language) {
      queryParams.push(filters.language);
      whereConditions.push("b.language = $" + paramCounter);
      paramCounter++;
    }

    // Publisher ID filter
    if (filters.publisherId) {
      queryParams.push(filters.publisherId);
      whereConditions.push("b.publisher_id = $" + paramCounter);
      paramCounter++;
    }

    // Published after date filter
    if (filters.publishedAfter) {
      queryParams.push(filters.publishedAfter);
      whereConditions.push("b.publication_date >= $" + paramCounter);
      paramCounter++;
    }

    // Published before date filter
    if (filters.publishedBefore) {
      queryParams.push(filters.publishedBefore);
      whereConditions.push("b.publication_date <= $" + paramCounter);
      paramCounter++;
    }

    // Add joins to the query
    query += joins.join('\n') + '\n';

    // Add WHERE conditions
    if (whereConditions.length > 0) {
      query += 'WHERE ' + whereConditions.join(' AND ') + '\n';
    }

    // Add ordering and pagination
    query += 'ORDER BY b.created_at DESC LIMIT $' + paramCounter + ' OFFSET $' + (paramCounter + 1);
    queryParams.push(limit, offset);

    const result = await db.query(query, queryParams);
    return parseBooks(result.rows);
  },
};