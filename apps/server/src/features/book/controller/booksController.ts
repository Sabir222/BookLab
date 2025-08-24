import type { Request, Response } from "express";
import { bookQueries } from "@repo/db/postgres";
import { type Book, type BookWithDetails } from "@repo/types/types";
import {
  getCache,
  setCache,
  getRedisClient,
  type RedisClientType,
} from "@repo/db/redis";
import { sendSuccess, sendError } from "../../../utils/responseHandler.js";
import { ZodError } from "zod";
import {
  getBookByIdSchema,
  getAllBooksSchema,
  searchBooksByNameSchema,
  getTopRatedBooksSchema,
} from "../validation/booksControllerValidations.js";

const CACHE_TTL = 60;

const getBookById = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { params } = getBookByIdSchema.parse({
      params: req.params,
    });
    const { id: bookId } = params;

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
    if (error instanceof ZodError) {
      return sendError(res, "Validation failed", "VALIDATION_ERROR", 400);
    }
    return sendError(res, "Failed to get book", "INTERNAL_SERVER_ERROR", 500);
  }
};

const getAllBooks = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { query } = getAllBooksSchema.parse({
      query: req.query,
    });
    const { limit } = query;
    const bookLimit = limit ?? 50;

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
      return sendError(
        res,
        "Failed to get books",
        "INTERNAL_SERVER_ERROR",
        500,
      );
    }
  } catch (error) {
    console.error("Validation failed:", error);
    if (error instanceof ZodError) {
      return sendError(res, "Validation failed", "VALIDATION_ERROR", 400);
    }
    return sendError(res, "Failed to get books", "INTERNAL_SERVER_ERROR", 500);
  }
};

const getBooksByName = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  try {
    const { query } = searchBooksByNameSchema.parse({
      query: req.query,
    });
    const { q } = query;

    if (!q || !q.trim()) {
      return sendError(
        res,
        "Invalid search query",
        "INVALID_SEARCH_QUERY",
        400,
      );
    }

    const normalizedQuery = q.trim();
    const cacheKey = `books:title:${normalizedQuery.toLowerCase()}`;
    let redis: RedisClientType | null = null;

    try {
      redis = getRedisClient();
      const cached = await getCache<BookWithDetails[]>(redis, cacheKey, true);
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
  } catch (error) {
    console.error("Validation failed:", error);
    if (error instanceof ZodError) {
      return sendError(res, "Validation failed", "VALIDATION_ERROR", 400);
    }
    return sendError(res, "Search failed", "SEARCH_ERROR", 500);
  }
};

const getTopRatedBooks = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  try {
    const { query } = getTopRatedBooksSchema.parse({
      query: req.query,
    });
    const { limit, minRating } = query;
    const bookLimit = limit ?? 50;
    const minimumRating = minRating ?? 4.0;

    const cacheKey = `books:top-rated:${bookLimit}:${minimumRating}`;
    let redis: RedisClientType | null = null;

    try {
      redis = getRedisClient();
      const cached = await getCache<BookWithDetails[]>(redis, cacheKey, true);
      if (cached) {
        return sendSuccess(res, { books: cached }, undefined, 200, {
          cached: true,
        });
      }

      const books = await bookQueries.findTopRatedBooks(bookLimit, minimumRating);
      setCache(redis, cacheKey, books, CACHE_TTL).catch(console.warn);
      return sendSuccess(res, { books }, undefined, 200, { cached: false });
    } catch (error) {
      console.error("Failed to get top rated books:", error);
      return sendError(
        res,
        "Failed to get top rated books",
        "TOP_RATED_BOOKS_ERROR",
        500,
      );
    }
  } catch (error) {
    console.error("Validation failed:", error);
    if (error instanceof ZodError) {
      return sendError(res, "Validation failed", "VALIDATION_ERROR", 400);
    }
    return sendError(
      res,
      "Failed to get top rated books",
      "TOP_RATED_BOOKS_ERROR",
      500,
    );
  }
};
export const booksController = {
  getBookById,
  getAllBooks,
  getBooksByName,
  getTopRatedBooks,
};
