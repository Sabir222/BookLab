import { db } from "../client.js";
import { type Book } from "@repo/types/types";

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
            COALESCE(similarity(LOWER(COALESCE(b.title, '') || ' ' || COALESCE(b.subtitle, '')), si.clean_query), 0) * 0.7,
            (
              SELECT COALESCE(MAX(similarity(word_from_title, query_word)), 0) * 0.65
              FROM unnest(string_to_array(LOWER(b.title), ' ')) AS word_from_title
              CROSS JOIN unnest(si.query_words) AS query_word
              WHERE similarity(word_from_title, query_word) > 0.3
            ),
            CASE 
              WHEN LENGTH(si.clean_query) <= 15 THEN
                GREATEST(
                  CASE 
                    WHEN levenshtein(LOWER(b.title), si.clean_query) <= 3 THEN 0.6
                    WHEN levenshtein(LOWER(b.title), si.clean_query) <= 5 THEN 0.4
                    ELSE 0
                  END,
                  CASE 
                    WHEN levenshtein(LOWER(b.subtitle), si.clean_query) <= 3 THEN 0.55
                    WHEN levenshtein(LOWER(b.subtitle), si.clean_query) <= 5 THEN 0.35
                    ELSE 0
                  END
                )
              ELSE 0
            END
          ),
          CASE 
            WHEN EXISTS (
              SELECT 1 FROM unnest(si.query_words) AS word
              WHERE LOWER(b.title) LIKE '%' || word || '%'
                OR LOWER(b.subtitle) LIKE '%' || word || '%'
            ) THEN 0.5
            ELSE 0
          END,
          GREATEST(
            CASE WHEN LOWER(b.title) % si.clean_query THEN 
              similarity(LOWER(b.title), si.clean_query) * 0.4
            ELSE 0 END,
            CASE WHEN LOWER(b.subtitle) % si.clean_query THEN 
              similarity(LOWER(b.subtitle), si.clean_query) * 0.35
            ELSE 0 END,
            (
              SELECT COALESCE(MAX(
                CASE WHEN word_from_title % query_word THEN
                  similarity(word_from_title, query_word) * 0.3
                ELSE 0 END
              ), 0)
              FROM unnest(string_to_array(LOWER(b.title), ' ')) AS word_from_title
              CROSS JOIN unnest(si.query_words) AS query_word
            )
          )
        ) AS similarity_score,
        CASE 
          WHEN LENGTH(b.title) <= 50 THEN 0.05
          ELSE 0
        END AS length_bonus
      FROM books b
      CROSS JOIN search_input si
      WHERE b.is_active = true
        AND (
          LOWER(b.title) LIKE '%' || si.clean_query || '%'
          OR LOWER(b.subtitle) LIKE '%' || si.clean_query || '%'
          OR LOWER(b.title) % si.clean_query
          OR LOWER(b.subtitle) % si.clean_query
          OR COALESCE(similarity(LOWER(b.title), si.clean_query), 0) > 0.2
          OR COALESCE(similarity(LOWER(b.subtitle), si.clean_query), 0) > 0.2
          OR (LENGTH(si.clean_query) <= 15 AND (
            levenshtein(LOWER(b.title), si.clean_query) <= 5
            OR levenshtein(LOWER(b.subtitle), si.clean_query) <= 5
          ))
          OR EXISTS (
            SELECT 1 FROM unnest(si.query_words) AS word
            WHERE word != '' AND (
              LOWER(b.title) LIKE '%' || word || '%'
              OR LOWER(b.subtitle) LIKE '%' || word || '%'
              OR EXISTS (
                SELECT 1 FROM unnest(string_to_array(LOWER(b.title), ' ')) AS title_word
                WHERE similarity(title_word, word) > 0.3 OR title_word % word
              )
            )
          )
        )
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
    let query = `
      SELECT DISTINCT b.*
      FROM books b
    `;

    const joins: string[] = [];
    const whereConditions: string[] = ["b.is_active = true"];
    const queryParams: any[] = [];
    let paramCounter = 1;

    if (filters.title) {
      queryParams.push(filters.title);
      whereConditions.push(
        "(b.title % $" +
          paramCounter +
          " OR b.subtitle % $" +
          paramCounter +
          " OR (b.title || ' ' || COALESCE(b.subtitle, '')) % $" +
          paramCounter +
          ")",
      );
      paramCounter++;
    }

    if (filters.authorName) {
      joins.push(`
        INNER JOIN book_authors ba ON b.book_id = ba.book_id
        INNER JOIN authors a ON ba.author_id = a.author_id
      `);
      queryParams.push(filters.authorName);
      whereConditions.push(
        "(a.first_name % $" +
          paramCounter +
          " OR a.last_name % $" +
          paramCounter +
          " OR (a.first_name || ' ' || a.last_name) % $" +
          paramCounter +
          ")",
      );
      paramCounter++;
    }

    if (filters.categoryName) {
      joins.push(`
        INNER JOIN book_categories bc ON b.book_id = bc.book_id
        INNER JOIN categories c ON bc.category_id = c.category_id
      `);
      queryParams.push("%" + filters.categoryName + "%");
      whereConditions.push(
        "LOWER(c.category_name) LIKE LOWER($" + paramCounter + ")",
      );
      paramCounter++;
    }

    if (filters.minRating !== undefined) {
      queryParams.push(filters.minRating);
      whereConditions.push("b.average_rating >= $" + paramCounter);
      paramCounter++;
    }

    if (filters.maxPrice !== undefined) {
      queryParams.push(filters.maxPrice);
      whereConditions.push("b.price_sale <= $" + paramCounter);
      paramCounter++;
    }

    if (filters.format) {
      queryParams.push(filters.format);
      whereConditions.push("b.book_format = $" + paramCounter);
      paramCounter++;
    }

    if (filters.inStock !== undefined) {
      if (filters.inStock) {
        whereConditions.push("b.stock_quantity > b.reserved_quantity");
      } else {
        whereConditions.push("b.stock_quantity <= b.reserved_quantity");
      }
    }

    if (filters.forSale !== undefined) {
      queryParams.push(filters.forSale);
      whereConditions.push("b.for_sale = $" + paramCounter);
      paramCounter++;
    }

    if (filters.forRent !== undefined) {
      queryParams.push(filters.forRent);
      whereConditions.push("b.for_rent = $" + paramCounter);
      paramCounter++;
    }

    if (filters.language) {
      queryParams.push(filters.language);
      whereConditions.push("b.language = $" + paramCounter);
      paramCounter++;
    }

    if (filters.publisherId) {
      queryParams.push(filters.publisherId);
      whereConditions.push("b.publisher_id = $" + paramCounter);
      paramCounter++;
    }

    if (filters.publishedAfter) {
      queryParams.push(filters.publishedAfter);
      whereConditions.push("b.publication_date >= $" + paramCounter);
      paramCounter++;
    }

    if (filters.publishedBefore) {
      queryParams.push(filters.publishedBefore);
      whereConditions.push("b.publication_date <= $" + paramCounter);
      paramCounter++;
    }

    query += joins.join("\n") + "\n";

    // Add WHERE conditions
    if (whereConditions.length > 0) {
      query += "WHERE " + whereConditions.join(" AND ") + "\n";
    }

    query +=
      "ORDER BY b.created_at DESC LIMIT $" +
      paramCounter +
      " OFFSET $" +
      (paramCounter + 1);
    queryParams.push(limit, offset);

    const result = await db.query(query, queryParams);
    return parseBooks(result.rows);
  },

  async create(bookData: {
    title: string;
    subtitle?: string | null;
    description?: string | null;
    isbn13?: string | null;
    isbn10?: string | null;
    publicationDate?: string | null;
    publishedYear?: number | null;
    pageCount?: number | null;
    language?: string | null;
    coverImageUrl?: string | null;
    coverImageSmallUrl?: string | null;
    coverImageMediumUrl?: string | null;
    coverImageLargeUrl?: string | null;
    edition?: string | null;
    bookFormat: "hardcover" | "paperback" | "ebook" | "audiobook";
    bookCondition?: string | null;
    dimensions?: string | null;
    weightGrams?: number | null;
    forSale: boolean;
    forRent: boolean;
    priceSale: number;
    priceRentDaily?: number | null;
    priceRentWeekly?: number | null;
    priceRentMonthly?: number | null;
    stockQuantity: number;
    reservedQuantity?: number;
    isActive?: boolean;
    averageRating?: number | null;
    totalRatings?: number;
    totalReviews?: number;
    publisherId?: string | null;
    ownerId?: string | null;
    primaryCategoryId?: string | null;
    searchKeywords?: string[] | null;
    slug: string;
    createdBy?: string | null;
    lastModifiedBy?: string | null;
  }): Promise<Book> {
    const result = await db.query(
      `INSERT INTO books (
        title, subtitle, description, isbn_13, isbn_10, publication_date, published_year,
        page_count, language, cover_image_url, cover_image_small_url, cover_image_medium_url, cover_image_large_url,
        edition, book_format, book_condition,
        dimensions, weight_grams, for_sale, for_rent, price_sale, price_rent_daily,
        price_rent_weekly, price_rent_monthly, stock_quantity, reserved_quantity,
        is_active, average_rating, total_ratings, total_reviews, publisher_id, owner_id,
        primary_category_id, search_keywords, slug, created_by, last_modified_by
      ) VALUES (
        $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17,
        $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31, $32, $33, $34, $35, $36, $37
      ) RETURNING *`,
      [
        bookData.title,
        bookData.subtitle,
        bookData.description,
        bookData.isbn13,
        bookData.isbn10,
        bookData.publicationDate,
        bookData.publishedYear,
        bookData.pageCount,
        bookData.language,
        bookData.coverImageUrl,
        bookData.coverImageSmallUrl,
        bookData.coverImageMediumUrl,
        bookData.coverImageLargeUrl,
        bookData.edition,
        bookData.bookFormat,
        bookData.bookCondition,
        bookData.dimensions,
        bookData.weightGrams,
        bookData.forSale,
        bookData.forRent,
        bookData.priceSale,
        bookData.priceRentDaily,
        bookData.priceRentWeekly,
        bookData.priceRentMonthly,
        bookData.stockQuantity,
        bookData.reservedQuantity || 0,
        bookData.isActive !== undefined ? bookData.isActive : true,
        bookData.averageRating,
        bookData.totalRatings || 0,
        bookData.totalReviews || 0,
        bookData.publisherId,
        bookData.ownerId,
        bookData.primaryCategoryId,
        bookData.searchKeywords,
        bookData.slug,
        bookData.createdBy,
        bookData.lastModifiedBy,
      ],
    );
    return result.rows[0] as Book;
  },

  async update(
    bookId: string,
    bookData: {
      title?: string;
      subtitle?: string | null;
      description?: string | null;
      isbn13?: string | null;
      isbn10?: string | null;
      publicationDate?: string | null;
      publishedYear?: number | null;
      pageCount?: number | null;
      language?: string | null;
      coverImageUrl?: string | null;
      coverImageSmallUrl?: string | null;
      coverImageMediumUrl?: string | null;
      coverImageLargeUrl?: string | null;
      edition?: string | null;
      bookFormat?: "hardcover" | "paperback" | "ebook" | "audiobook" | "other";
      bookCondition?: string | null;
      dimensions?: string | null;
      weightGrams?: number | null;
      forSale?: boolean;
      forRent?: boolean;
      priceSale?: number;
      priceRentDaily?: number | null;
      priceRentWeekly?: number | null;
      priceRentMonthly?: number | null;
      stockQuantity?: number;
      reservedQuantity?: number;
      isActive?: boolean;
      averageRating?: number | null;
      totalRatings?: number;
      totalReviews?: number;
      publisherId?: string | null;
      ownerId?: string | null;
      primaryCategoryId?: string | null;
      searchKeywords?: string[] | null;
      slug?: string;
      lastModifiedBy?: string | null;
    },
  ): Promise<Book | null> {
    const fields: string[] = [];
    const values: any[] = [];
    let paramCounter = 1;

    const fieldMap: Record<string, string> = {
      title: "title",
      subtitle: "subtitle",
      description: "description",
      isbn13: "isbn_13",
      isbn10: "isbn_10",
      publicationDate: "publication_date",
      publishedYear: "published_year",
      pageCount: "page_count",
      language: "language",
      coverImageUrl: "cover_image_url",
      coverImageSmallUrl: "cover_image_small_url",
      coverImageMediumUrl: "cover_image_medium_url",
      coverImageLargeUrl: "cover_image_large_url",
      edition: "edition",
      bookFormat: "book_format",
      bookCondition: "book_condition",
      dimensions: "dimensions",
      weightGrams: "weight_grams",
      forSale: "for_sale",
      forRent: "for_rent",
      priceSale: "price_sale",
      priceRentDaily: "price_rent_daily",
      priceRentWeekly: "price_rent_weekly",
      priceRentMonthly: "price_rent_monthly",
      stockQuantity: "stock_quantity",
      reservedQuantity: "reserved_quantity",
      isActive: "is_active",
      averageRating: "average_rating",
      totalRatings: "total_ratings",
      totalReviews: "total_reviews",
      publisherId: "publisher_id",
      ownerId: "owner_id",
      primaryCategoryId: "primary_category_id",
      searchKeywords: "search_keywords",
      slug: "slug",
      lastModifiedBy: "last_modified_by",
    };

    Object.entries(bookData).forEach(([key, value]) => {
      if (value !== undefined && fieldMap[key]) {
        fields.push(`${fieldMap[key]} = ${paramCounter}`);
        values.push(value);
        paramCounter++;
      }
    });

    fields.push("updated_at = NOW()");

    if (fields.length === 0) return null;

    values.push(bookId);

    const result = await db.query(
      `UPDATE books SET ${fields.join(", ")} WHERE book_id = ${paramCounter} RETURNING *`,
      values,
    );
    return result.rows[0] ? (result.rows[0] as Book) : null;
  },

  async delete(bookId: string): Promise<boolean> {
    const result = await db.query("DELETE FROM books WHERE book_id = $1", [
      bookId,
    ]);
    return (result.rowCount ?? 0) > 0;
  },

  async softDelete(bookId: string, deletedBy?: string): Promise<Book | null> {
    const result = await db.query(
      "UPDATE books SET deleted_at = NOW(), deleted_by = $2, is_active = false WHERE book_id = $1 RETURNING *",
      [bookId, deletedBy || null],
    );
    return result.rows[0] ? (result.rows[0] as Book) : null;
  },

  async restore(bookId: string): Promise<Book | null> {
    const result = await db.query(
      "UPDATE books SET deleted_at = NULL, deleted_by = NULL, is_active = true WHERE book_id = $1 RETURNING *",
      [bookId],
    );
    return result.rows[0] ? (result.rows[0] as Book) : null;
  },

  async exists(bookId: string): Promise<boolean> {
    const result = await db.query("SELECT 1 FROM books WHERE book_id = $1", [
      bookId,
    ]);
    return result.rows.length > 0;
  },

  async findBySlug(slug: string): Promise<Book | null> {
    const result = await db.query(
      "SELECT * FROM books WHERE slug = $1 LIMIT 1",
      [slug],
    );
    return result.rows[0] ? (result.rows[0] as Book) : null;
  },

  async updateStock(
    bookId: string,
    newStock: number,
    reservedQuantity?: number,
  ): Promise<Book | null> {
    const result = await db.query(
      "UPDATE books SET stock_quantity = $2, reserved_quantity = COALESCE($3, reserved_quantity), updated_at = NOW() WHERE book_id = $1 RETURNING *",
      [bookId, newStock, reservedQuantity],
    );
    return result.rows[0] ? (result.rows[0] as Book) : null;
  },

  async addToStock(bookId: string, quantity: number): Promise<Book | null> {
    const result = await db.query(
      "UPDATE books SET stock_quantity = stock_quantity + $2, updated_at = NOW() WHERE book_id = $1 RETURNING *",
      [bookId, quantity],
    );
    return result.rows[0] ? (result.rows[0] as Book) : null;
  },

  async reserveBooks(bookId: string, quantity: number): Promise<Book | null> {
    const result = await db.query(
      "UPDATE books SET reserved_quantity = reserved_quantity + $2, updated_at = NOW() WHERE book_id = $1 RETURNING *",
      [bookId, quantity],
    );
    return result.rows[0] ? (result.rows[0] as Book) : null;
  },

  async releaseReservedBooks(
    bookId: string,
    quantity: number,
  ): Promise<Book | null> {
    const result = await db.query(
      "UPDATE books SET reserved_quantity = GREATEST(0, reserved_quantity - $2), updated_at = NOW() WHERE book_id = $1 RETURNING *",
      [bookId, quantity],
    );
    return result.rows[0] ? (result.rows[0] as Book) : null;
  },

  async updateRatings(
    bookId: string,
    averageRating: number,
    totalRatings: number,
  ): Promise<Book | null> {
    const result = await db.query(
      "UPDATE books SET average_rating = $2, total_ratings = $3, updated_at = NOW() WHERE book_id = $1 RETURNING *",
      [bookId, averageRating, totalRatings],
    );
    return result.rows[0] ? (result.rows[0] as Book) : null;
  },
};
