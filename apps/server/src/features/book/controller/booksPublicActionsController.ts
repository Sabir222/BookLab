import type { Request, Response } from "express";
import { bookQueries, type Book } from "@repo/db/postgres";
import {
  getCache,
  setCache,
  getRedisClient,
  type RedisClientType,
} from "@repo/db/redis";

const CACHE_TTL = 60;

const sendResponse = (
  res: Response,
  status: number,
  payload: Record<string, unknown>,
) => res.status(status).json(payload);

const handleError = (
  res: Response,
  status: number,
  message: string,
  code: string,
  log?: unknown,
) => {
  if (log) console.error(message, log);
  return sendResponse(res, status, {
    success: false,
    error: message,
    code,
  });
};

const getBookById = async (req: Request, res: Response): Promise<Response> => {
  const { id: bookId } = req.params;

  try {
    const book = await bookQueries.findById(bookId);
    if (!book) {
      return handleError(
        res,
        404,
        `Book '${bookId}' not found`,
        "BOOK_NOT_FOUND",
      );
    }
    return sendResponse(res, 200, { success: true, data: { book } });
  } catch (error) {
    return handleError(
      res,
      500,
      "Failed to get book",
      "INTERNAL_SERVER_ERROR",
      error,
    );
  }
};

const getAllBooksRedis = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  const { limit } = req.query;
  const bookLimit = limit ? parseInt(limit as string, 10) : 50;

  if (isNaN(bookLimit) || bookLimit < 1 || bookLimit > 100) {
    return handleError(
      res,
      400,
      "Invalid limit parameter (1-100)",
      "INVALID_LIMIT",
    );
  }

  const cacheKey = `books:all:${bookLimit}`;
  let redis: RedisClientType | null = null;

  try {
    redis = getRedisClient();
    const cached = await getCache<Book[]>(redis, cacheKey, true);
    if (cached) {
      return sendResponse(res, 200, {
        success: true,
        data: { books: cached },
        meta: { cached: true },
      });
    }

    const books = await bookQueries.findBooks(bookLimit);
    setCache(redis, cacheKey, books, CACHE_TTL).catch(console.warn);
    return sendResponse(res, 200, {
      success: true,
      data: { books },
      meta: { cached: false },
    });
  } catch (error) {
    return handleError(
      res,
      500,
      "Failed to get books",
      "INTERNAL_SERVER_ERROR",
      error,
    );
  }
};

const getBooksByName = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  const { q } = req.query;
  if (!q || typeof q !== "string" || !q.trim()) {
    return handleError(
      res,
      400,
      "Invalid search query",
      "INVALID_SEARCH_QUERY",
    );
  }

  const normalizedQuery = q.trim();
  const cacheKey = `books:title:${normalizedQuery.toLowerCase()}`;
  let redis: RedisClientType | null = null;

  try {
    redis = getRedisClient();
    const cached = await getCache<Book[]>(redis, cacheKey, true);
    if (cached) {
      return sendResponse(res, 200, {
        success: true,
        data: { books: cached },
        meta: { cached: true },
      });
    }

    const books = await bookQueries.findBooksByName(normalizedQuery);
    setCache(redis, cacheKey, books, CACHE_TTL).catch(console.warn);
    return sendResponse(res, 200, {
      success: true,
      data: { books },
      meta: { cached: false },
    });
  } catch (error) {
    return handleError(res, 500, "Search failed", "SEARCH_ERROR", error);
  }
};

const getBooksByAuthor = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  const { q } = req.query;
  if (!q || typeof q !== "string" || !q.trim()) {
    return handleError(
      res,
      400,
      "Invalid author search query",
      "INVALID_AUTHOR_QUERY",
    );
  }

  const normalizedQuery = q.trim();
  const cacheKey = `books:author:${normalizedQuery.toLowerCase()}`;
  let redis: RedisClientType | null = null;

  try {
    redis = getRedisClient();
    const cached = await getCache<Book[]>(redis, cacheKey, true);
    if (cached) {
      return sendResponse(res, 200, {
        success: true,
        data: { books: cached },
        meta: { cached: true },
      });
    }

    const books = await bookQueries.findBooksByAuthor(normalizedQuery);
    setCache(redis, cacheKey, books, CACHE_TTL).catch(console.warn);
    return sendResponse(res, 200, {
      success: true,
      data: { books },
      meta: { cached: false },
    });
  } catch (error) {
    return handleError(
      res,
      500,
      "Author search failed",
      "AUTHOR_SEARCH_ERROR",
      error,
    );
  }
};

const getBooksByCategory = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  const { q } = req.query;
  if (!q || typeof q !== "string" || !q.trim()) {
    return handleError(
      res,
      400,
      "Invalid category search query",
      "INVALID_CATEGORY_QUERY",
    );
  }

  const normalizedQuery = q.trim();
  const cacheKey = `books:category:${normalizedQuery.toLowerCase()}`;
  let redis: RedisClientType | null = null;

  try {
    redis = getRedisClient();
    const cached = await getCache<Book[]>(redis, cacheKey, true);
    if (cached) {
      return sendResponse(res, 200, {
        success: true,
        data: { books: cached },
        meta: { cached: true },
      });
    }

    const books = await bookQueries.findBooksByCategory(normalizedQuery);
    setCache(redis, cacheKey, books, CACHE_TTL).catch(console.warn);
    return sendResponse(res, 200, {
      success: true,
      data: { books },
      meta: { cached: false },
    });
  } catch (error) {
    return handleError(
      res,
      500,
      "Category search failed",
      "CATEGORY_SEARCH_ERROR",
      error,
    );
  }
};

const getNewReleases = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  const { days, limit } = req.query;
  const dayLimit = days ? parseInt(days as string, 10) : 30;
  const bookLimit = limit ? parseInt(limit as string, 10) : 20;

  if (isNaN(dayLimit) || dayLimit < 1 || dayLimit > 365) {
    return handleError(
      res,
      400,
      "Invalid days parameter (1-365)",
      "INVALID_DAYS",
    );
  }

  if (isNaN(bookLimit) || bookLimit < 1 || bookLimit > 100) {
    return handleError(
      res,
      400,
      "Invalid limit parameter (1-100)",
      "INVALID_LIMIT",
    );
  }

  const cacheKey = `books:new:${dayLimit}:${bookLimit}`;
  let redis: RedisClientType | null = null;

  try {
    redis = getRedisClient();
    const cached = await getCache<Book[]>(redis, cacheKey, true);
    if (cached) {
      return sendResponse(res, 200, {
        success: true,
        data: { books: cached },
        meta: { cached: true },
      });
    }

    const books = await bookQueries.findNewReleases(dayLimit, bookLimit);
    setCache(redis, cacheKey, books, CACHE_TTL).catch(console.warn);
    return sendResponse(res, 200, {
      success: true,
      data: { books },
      meta: { cached: false },
    });
  } catch (error) {
    return handleError(
      res,
      500,
      "Failed to get new releases",
      "NEW_RELEASES_ERROR",
      error,
    );
  }
};

const getBooksByISBN = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  const { q } = req.query;
  if (!q || typeof q !== "string" || !q.trim()) {
    return handleError(
      res,
      400,
      "Invalid ISBN search query",
      "INVALID_ISBN_QUERY",
    );
  }

  const normalizedQuery = q.trim();
  const cacheKey = `books:isbn:${normalizedQuery.toLowerCase()}`;
  let redis: RedisClientType | null = null;

  try {
    redis = getRedisClient();
    const cached = await getCache<Book[]>(redis, cacheKey, true);
    if (cached) {
      return sendResponse(res, 200, {
        success: true,
        data: { books: cached },
        meta: { cached: true },
      });
    }

    const books = await bookQueries.findBooksByISBN(normalizedQuery);
    setCache(redis, cacheKey, books, CACHE_TTL).catch(console.warn);
    return sendResponse(res, 200, {
      success: true,
      data: { books },
      meta: { cached: false },
    });
  } catch (error) {
    return handleError(
      res,
      500,
      "ISBN search failed",
      "ISBN_SEARCH_ERROR",
      error,
    );
  }
};

const getRelatedBooks = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  const { id: bookId } = req.params;
  if (!bookId?.trim()) {
    return handleError(res, 400, "Book ID is required", "MISSING_BOOK_ID");
  }

  const cacheKey = `books:related:${bookId}`;
  let redis: RedisClientType | null = null;

  try {
    redis = getRedisClient();
    const cached = await getCache<Book[]>(redis, cacheKey, true);
    if (cached) {
      return sendResponse(res, 200, {
        success: true,
        data: { books: cached },
        meta: { cached: true },
      });
    }

    const books = await bookQueries.findRelatedBooks(bookId);
    setCache(redis, cacheKey, books, CACHE_TTL).catch(console.warn);
    return sendResponse(res, 200, {
      success: true,
      data: { books },
      meta: { cached: false },
    });
  } catch (error) {
    return handleError(
      res,
      500,
      "Failed to get related books",
      "RELATED_BOOKS_ERROR",
      error,
    );
  }
};

const getFilteredBooks = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  const {
    title,
    authorName,
    categoryName,
    minRating,
    maxPrice,
    format,
    inStock,
    forSale,
    forRent,
    language,
    publisherId,
    publishedAfter,
    publishedBefore,
    limit,
    offset,
  } = req.query;

  const parsedLimit = limit ? parseInt(limit as string, 10) : 20;
  const parsedOffset = offset ? parseInt(offset as string, 10) : 0;
  const parsedMinRating = minRating
    ? parseFloat(minRating as string)
    : undefined;
  const parsedMaxPrice = maxPrice ? parseFloat(maxPrice as string) : undefined;

  // Validate limit and offset
  if (isNaN(parsedLimit) || parsedLimit < 1 || parsedLimit > 100) {
    return handleError(
      res,
      400,
      "Invalid limit parameter (1-100)",
      "INVALID_LIMIT",
    );
  }

  if (isNaN(parsedOffset) || parsedOffset < 0) {
    return handleError(
      res,
      400,
      "Invalid offset parameter (must be >= 0)",
      "INVALID_OFFSET",
    );
  }

  const cacheKey = `books:filtered:${JSON.stringify(req.query)}`;
  let redis: RedisClientType | null = null;

  try {
    redis = getRedisClient();
    const cached = await getCache<Book[]>(redis, cacheKey, true);
    if (cached) {
      return sendResponse(res, 200, {
        success: true,
        data: { books: cached },
        meta: { cached: true },
      });
    }

    const filters: {
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
    } = {};

    if (title && typeof title === "string") filters.title = title;
    if (authorName && typeof authorName === "string")
      filters.authorName = authorName;
    if (categoryName && typeof categoryName === "string")
      filters.categoryName = categoryName;
    if (parsedMinRating !== undefined && !isNaN(parsedMinRating))
      filters.minRating = parsedMinRating;
    if (parsedMaxPrice !== undefined && !isNaN(parsedMaxPrice))
      filters.maxPrice = parsedMaxPrice;
    if (format && typeof format === "string") filters.format = format;
    if (inStock !== undefined) filters.inStock = inStock === "true";
    if (forSale !== undefined) filters.forSale = forSale === "true";
    if (forRent !== undefined) filters.forRent = forRent === "true";
    if (language && typeof language === "string") filters.language = language;
    if (publisherId && typeof publisherId === "string")
      filters.publisherId = publisherId;
    if (publishedAfter && typeof publishedAfter === "string")
      filters.publishedAfter = publishedAfter;
    if (publishedBefore && typeof publishedBefore === "string")
      filters.publishedBefore = publishedBefore;

    const books = await bookQueries.filterBooks(
      filters,
      parsedLimit,
      parsedOffset,
    );
    setCache(redis, cacheKey, books, CACHE_TTL).catch(console.warn);
    return sendResponse(res, 200, {
      success: true,
      data: { books },
      meta: { cached: false },
    });
  } catch (error) {
    return handleError(
      res,
      500,
      "Failed to filter books",
      "FILTER_BOOKS_ERROR",
      error,
    );
  }
};

export const bookPublicActionsController = {
  getBookById,
  getAllBooksRedis,
  getBooksByName,
  getBooksByAuthor,
  getBooksByCategory,
  getNewReleases,
  getBooksByISBN,
  getRelatedBooks,
  getFilteredBooks,
};
