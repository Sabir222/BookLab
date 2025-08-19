import type { Request, Response } from "express";
import { bookQueries } from "@repo/db/postgres";
import { type Book } from "@repo/types/types";
import {
  getCache,
  setCache,
  getRedisClient,
  type RedisClientType,
} from "@repo/db/redis";
import {
  sendSuccess,
  sendError,
  sendCreated,
} from "../../../utils/responseHandler.js";

const CACHE_TTL = 60;

const getBookById = async (req: Request, res: Response): Promise<Response> => {
  const { id: bookId } = req.params;

  try {
    const book = await bookQueries.findById(bookId);
    if (!book) {
      return sendError(
        res,
        `Book '${bookId}' not found`,
        "BOOK_NOT_FOUND",
        404,
      );
    }
    return sendSuccess(res, { book });
  } catch (error) {
    console.error("Failed to get book:", error);
    return sendError(res, "Failed to get book", "INTERNAL_SERVER_ERROR", 500);
  }
};

const getAllBooks = async (req: Request, res: Response): Promise<Response> => {
  const { limit } = req.query;
  const bookLimit = limit ? parseInt(limit as string, 10) : 50;
  if (isNaN(bookLimit) || bookLimit < 1 || bookLimit > 100) {
    return sendError(
      res,
      "Invalid limit parameter (1-100)",
      "INVALID_LIMIT",
      400,
    );
  }

  const cacheKey = `books:all:${bookLimit}`;
  let redis: RedisClientType | null = null;

  try {
    redis = getRedisClient();
    const cached = await getCache<Book[]>(redis, cacheKey, true);
    if (cached) {
      return sendSuccess(res, { books: cached }, undefined, 200, {
        cached: true,
      });
    }

    const books = await bookQueries.findBooks(bookLimit);
    setCache(redis, cacheKey, books, CACHE_TTL).catch(console.warn);
    return sendSuccess(res, { books }, undefined, 200, { cached: false });
  } catch (error) {
    console.error("Failed to get books:", error);
    return sendError(res, "Failed to get books", "INTERNAL_SERVER_ERROR", 500);
  }
};

const getBooksByName = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  const { q } = req.query;
  if (!q || typeof q !== "string" || !q.trim()) {
    return sendError(res, "Invalid search query", "INVALID_SEARCH_QUERY", 400);
  }

  const normalizedQuery = q.trim();
  const cacheKey = `books:title:${normalizedQuery.toLowerCase()}`;
  let redis: RedisClientType | null = null;

  try {
    redis = getRedisClient();
    const cached = await getCache<Book[]>(redis, cacheKey, true);
    if (cached) {
      return sendSuccess(res, { books: cached }, undefined, 200, {
        cached: true,
      });
    }

    const books = await bookQueries.findBooksByName(normalizedQuery);
    setCache(redis, cacheKey, books, CACHE_TTL).catch(console.warn);
    return sendSuccess(res, { books }, undefined, 200, { cached: false });
  } catch (error) {
    console.error("Search failed:", error);
    return sendError(res, "Search failed", "SEARCH_ERROR", 500);
  }
};

const getBooksByAuthor = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  const { q } = req.query;
  if (!q || typeof q !== "string" || !q.trim()) {
    return sendError(
      res,
      "Invalid author search query",
      "INVALID_AUTHOR_QUERY",
      400,
    );
  }

  const normalizedQuery = q.trim();
  const cacheKey = `books:author:${normalizedQuery.toLowerCase()}`;
  let redis: RedisClientType | null = null;

  try {
    redis = getRedisClient();
    const cached = await getCache<Book[]>(redis, cacheKey, true);
    if (cached) {
      return sendSuccess(res, { books: cached }, undefined, 200, {
        cached: true,
      });
    }

    const books = await bookQueries.findBooksByAuthor(normalizedQuery);
    setCache(redis, cacheKey, books, CACHE_TTL).catch(console.warn);
    return sendSuccess(res, { books }, undefined, 200, { cached: false });
  } catch (error) {
    console.error("Author search failed:", error);
    return sendError(res, "Author search failed", "AUTHOR_SEARCH_ERROR", 500);
  }
};

const getBooksByCategory = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  const { q } = req.query;
  if (!q || typeof q !== "string" || !q.trim()) {
    return sendError(
      res,
      "Invalid category search query",
      "INVALID_CATEGORY_QUERY",
      400,
    );
  }

  const normalizedQuery = q.trim();
  const cacheKey = `books:category:${normalizedQuery.toLowerCase()}`;
  let redis: RedisClientType | null = null;

  try {
    redis = getRedisClient();
    const cached = await getCache<Book[]>(redis, cacheKey, true);
    if (cached) {
      return sendSuccess(res, { books: cached }, undefined, 200, {
        cached: true,
      });
    }

    const books = await bookQueries.findBooksByCategory(normalizedQuery);
    setCache(redis, cacheKey, books, CACHE_TTL).catch(console.warn);
    return sendSuccess(res, { books }, undefined, 200, { cached: false });
  } catch (error) {
    console.error("Category search failed:", error);
    return sendError(
      res,
      "Category search failed",
      "CATEGORY_SEARCH_ERROR",
      500,
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
    return sendError(
      res,
      "Invalid days parameter (1-365)",
      "INVALID_DAYS",
      400,
    );
  }

  if (isNaN(bookLimit) || bookLimit < 1 || bookLimit > 100) {
    return sendError(
      res,
      "Invalid limit parameter (1-100)",
      "INVALID_LIMIT",
      400,
    );
  }

  const cacheKey = `books:new:${dayLimit}:${bookLimit}`;
  let redis: RedisClientType | null = null;

  try {
    redis = getRedisClient();
    const cached = await getCache<Book[]>(redis, cacheKey, true);
    if (cached) {
      return sendSuccess(res, { books: cached }, undefined, 200, {
        cached: true,
      });
    }

    const books = await bookQueries.findNewReleases(dayLimit, bookLimit);
    setCache(redis, cacheKey, books, CACHE_TTL).catch(console.warn);
    return sendSuccess(res, { books }, undefined, 200, { cached: false });
  } catch (error) {
    console.error("Failed to get new releases:", error);
    return sendError(
      res,
      "Failed to get new releases",
      "NEW_RELEASES_ERROR",
      500,
    );
  }
};

const getBooksByISBN = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  const { q } = req.query;
  if (!q || typeof q !== "string" || !q.trim()) {
    return sendError(
      res,
      "Invalid ISBN search query",
      "INVALID_ISBN_QUERY",
      400,
    );
  }

  const normalizedQuery = q.trim();
  const cacheKey = `books:isbn:${normalizedQuery.toLowerCase()}`;
  let redis: RedisClientType | null = null;

  try {
    redis = getRedisClient();
    const cached = await getCache<Book[]>(redis, cacheKey, true);
    if (cached) {
      return sendSuccess(res, { books: cached }, undefined, 200, {
        cached: true,
      });
    }

    const books = await bookQueries.findBooksByISBN(normalizedQuery);
    setCache(redis, cacheKey, books, CACHE_TTL).catch(console.warn);
    return sendSuccess(res, { books }, undefined, 200, { cached: false });
  } catch (error) {
    console.error("ISBN search failed:", error);
    return sendError(res, "ISBN search failed", "ISBN_SEARCH_ERROR", 500);
  }
};

const getRelatedBooks = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  const { id: bookId } = req.params;
  if (!bookId?.trim()) {
    return sendError(res, "Book ID is required", "MISSING_BOOK_ID", 400);
  }

  const cacheKey = `books:related:${bookId}`;
  let redis: RedisClientType | null = null;

  try {
    redis = getRedisClient();
    const cached = await getCache<Book[]>(redis, cacheKey, true);
    if (cached) {
      return sendSuccess(res, { books: cached }, undefined, 200, {
        cached: true,
      });
    }

    const books = await bookQueries.findRelatedBooks(bookId);
    setCache(redis, cacheKey, books, CACHE_TTL).catch(console.warn);
    return sendSuccess(res, { books }, undefined, 200, { cached: false });
  } catch (error) {
    console.error("Failed to get related books:", error);
    return sendError(
      res,
      "Failed to get related books",
      "RELATED_BOOKS_ERROR",
      500,
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

  if (isNaN(parsedLimit) || parsedLimit < 1 || parsedLimit > 100) {
    return sendError(
      res,
      "Invalid limit parameter (1-100)",
      "INVALID_LIMIT",
      400,
    );
  }

  if (isNaN(parsedOffset) || parsedOffset < 0) {
    return sendError(
      res,
      "Invalid offset parameter (must be >= 0)",
      "INVALID_OFFSET",
      400,
    );
  }

  const cacheKey = `books:filtered:${JSON.stringify(req.query)}`;
  let redis: RedisClientType | null = null;

  try {
    redis = getRedisClient();
    const cached = await getCache<Book[]>(redis, cacheKey, true);
    if (cached) {
      return sendSuccess(res, { books: cached }, undefined, 200, {
        cached: true,
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
    return sendSuccess(res, { books }, undefined, 200, { cached: false });
  } catch (error) {
    console.error("Failed to filter books:", error);
    return sendError(res, "Failed to filter books", "FILTER_BOOKS_ERROR", 500);
  }
};

// Create a new book
const createBook = async (req: Request, res: Response): Promise<Response> => {
  try {
    const bookData = req.body;
    const book = await bookQueries.create(bookData);
    return sendCreated(res, { book });
  } catch (error) {
    console.error("Failed to create book:", error);
    return sendError(res, "Failed to create book", "CREATE_BOOK_ERROR", 500);
  }
};

// Update a book
const updateBook = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { id: bookId } = req.params;
    const bookData = req.body;
    const book = await bookQueries.update(bookId, bookData);

    if (!book) {
      return sendError(
        res,
        `Book '${bookId}' not found`,
        "BOOK_NOT_FOUND",
        404,
      );
    }

    return sendSuccess(res, { book });
  } catch (error) {
    console.error("Failed to update book:", error);
    return sendError(res, "Failed to update book", "UPDATE_BOOK_ERROR", 500);
  }
};

// Delete a book
const deleteBook = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { id: bookId } = req.params;
    const deleted = await bookQueries.delete(bookId);

    if (!deleted) {
      return sendError(
        res,
        `Book '${bookId}' not found`,
        "BOOK_NOT_FOUND",
        404,
      );
    }

    return sendSuccess(res, null, `Book '${bookId}' deleted successfully`);
  } catch (error) {
    console.error("Failed to delete book:", error);
    return sendError(res, "Failed to delete book", "DELETE_BOOK_ERROR", 500);
  }
};

// Soft delete a book
const softDeleteBook = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  try {
    const { id: bookId } = req.params;
    const { deletedBy } = req.body;
    const book = await bookQueries.softDelete(bookId, deletedBy);

    if (!book) {
      return sendError(
        res,
        `Book '${bookId}' not found`,
        "BOOK_NOT_FOUND",
        404,
      );
    }

    return sendSuccess(res, { book });
  } catch (error) {
    console.error("Failed to soft delete book:", error);
    return sendError(
      res,
      "Failed to soft delete book",
      "SOFT_DELETE_BOOK_ERROR",
      500,
    );
  }
};

// Restore a book
const restoreBook = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { id: bookId } = req.params;
    const book = await bookQueries.restore(bookId);

    if (!book) {
      return sendError(
        res,
        `Book '${bookId}' not found`,
        "BOOK_NOT_FOUND",
        404,
      );
    }

    return sendSuccess(res, { book });
  } catch (error) {
    console.error("Failed to restore book:", error);
    return sendError(res, "Failed to restore book", "RESTORE_BOOK_ERROR", 500);
  }
};

// Check if a book exists
const bookExists = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { id: bookId } = req.params;
    const exists = await bookQueries.exists(bookId);
    return sendSuccess(res, { exists });
  } catch (error) {
    console.error("Failed to check book existence:", error);
    return sendError(
      res,
      "Failed to check book existence",
      "BOOK_EXISTS_ERROR",
      500,
    );
  }
};

// Get book by slug
const getBookBySlug = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  try {
    const { slug } = req.params;
    const book = await bookQueries.findBySlug(slug);

    if (!book) {
      return sendError(
        res,
        `Book with slug '${slug}' not found`,
        "BOOK_NOT_FOUND",
        404,
      );
    }

    return sendSuccess(res, { book });
  } catch (error) {
    console.error("Failed to get book by slug:", error);
    return sendError(
      res,
      "Failed to get book by slug",
      "GET_BOOK_BY_SLUG_ERROR",
      500,
    );
  }
};

// Update book stock
const updateBookStock = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  try {
    const { id: bookId } = req.params;
    const { newStock, reservedQuantity } = req.body;
    const book = await bookQueries.updateStock(
      bookId,
      newStock,
      reservedQuantity,
    );

    if (!book) {
      return sendError(
        res,
        `Book '${bookId}' not found`,
        "BOOK_NOT_FOUND",
        404,
      );
    }

    return sendSuccess(res, { book });
  } catch (error) {
    console.error("Failed to update book stock:", error);
    return sendError(
      res,
      "Failed to update book stock",
      "UPDATE_BOOK_STOCK_ERROR",
      500,
    );
  }
};

// Add to book stock
const addToBookStock = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  try {
    const { id: bookId } = req.params;
    const { quantity } = req.body;
    const book = await bookQueries.addToStock(bookId, quantity);

    if (!book) {
      return sendError(
        res,
        `Book '${bookId}' not found`,
        "BOOK_NOT_FOUND",
        404,
      );
    }

    return sendSuccess(res, { book });
  } catch (error) {
    console.error("Failed to add to book stock:", error);
    return sendError(
      res,
      "Failed to add to book stock",
      "ADD_TO_BOOK_STOCK_ERROR",
      500,
    );
  }
};

// Reserve books
const reserveBooks = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { id: bookId } = req.params;
    const { quantity } = req.body;
    const book = await bookQueries.reserveBooks(bookId, quantity);

    if (!book) {
      return sendError(
        res,
        `Book '${bookId}' not found`,
        "BOOK_NOT_FOUND",
        404,
      );
    }

    return sendSuccess(res, { book });
  } catch (error) {
    console.error("Failed to reserve books:", error);
    return sendError(
      res,
      "Failed to reserve books",
      "RESERVE_BOOKS_ERROR",
      500,
    );
  }
};

// Release reserved books
const releaseReservedBooks = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  try {
    const { id: bookId } = req.params;
    const { quantity } = req.body;
    const book = await bookQueries.releaseReservedBooks(bookId, quantity);

    if (!book) {
      return sendError(
        res,
        `Book '${bookId}' not found`,
        "BOOK_NOT_FOUND",
        404,
      );
    }

    return sendSuccess(res, { book });
  } catch (error) {
    console.error("Failed to release reserved books:", error);
    return sendError(
      res,
      "Failed to release reserved books",
      "RELEASE_RESERVED_BOOKS_ERROR",
      500,
    );
  }
};

// Update book ratings
const updateBookRatings = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  try {
    const { id: bookId } = req.params;
    const { averageRating, totalRatings } = req.body;
    const book = await bookQueries.updateRatings(
      bookId,
      averageRating,
      totalRatings,
    );

    if (!book) {
      return sendError(
        res,
        `Book '${bookId}' not found`,
        "BOOK_NOT_FOUND",
        404,
      );
    }

    return sendSuccess(res, { book });
  } catch (error) {
    console.error("Failed to update book ratings:", error);
    return sendError(
      res,
      "Failed to update book ratings",
      "UPDATE_BOOK_RATINGS_ERROR",
      500,
    );
  }
};

export const bookPublicActionsController = {
  getBookById,
  getAllBooks,
  getBooksByName,
  getBooksByAuthor,
  getBooksByCategory,
  getNewReleases,
  getBooksByISBN,
  getRelatedBooks,
  getFilteredBooks,
  createBook,
  updateBook,
  deleteBook,
  softDeleteBook,
  restoreBook,
  bookExists,
  getBookBySlug,
  updateBookStock,
  addToBookStock,
  reserveBooks,
  releaseReservedBooks,
  updateBookRatings,
};

