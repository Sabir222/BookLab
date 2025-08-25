import type { Request, Response } from "express";
import { bookService } from "../services/bookService.js";
import { sendSuccess, sendError } from "../../../utils/responseHandler.js";
import { ZodError } from "zod";
import {
  getAllBooksSchema,
  getTopRatedBooksSchema,
  getNewReleasesSchema,
  getPopularBooksSchema,
} from "../validation/booksControllerValidations.js";
import { type Book, type BookWithDetails } from "@repo/types/types";
import { getCache, getRedisClient, type RedisClientType } from "@repo/db/redis";

const getAllBooks = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { query } = getAllBooksSchema.parse({
      query: req.query,
    });
    const { limit } = query;
    const bookLimit = limit ?? 50;

    const books = await bookService.getAllBooks(bookLimit);
    const cacheKey = `books:all:${bookLimit}`;

    let redis: RedisClientType | null = null;
    let wasCached = false;

    try {
      redis = getRedisClient();
      const cached = await getCache<Book[]>(redis, cacheKey, true);
      wasCached = !!cached;
    } catch (cacheError) {
      console.warn("Failed to check cache status:", cacheError);
    }

    return sendSuccess(res, { books }, undefined, 200, {
      cached: wasCached,
    });
  } catch (error) {
    console.error("Failed to get books:", error);
    if (error instanceof ZodError) {
      return sendError(res, "Validation failed", "VALIDATION_ERROR", 400);
    }
    return sendError(res, "Failed to get books", "INTERNAL_SERVER_ERROR", 500);
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

    const books = await bookService.getTopRatedBooks(bookLimit, minimumRating);
    const cacheKey = `books:top-rated:${bookLimit}:${minimumRating}`;

    let redis: RedisClientType | null = null;
    let wasCached = false;

    try {
      redis = getRedisClient();
      const cached = await getCache<BookWithDetails[]>(redis, cacheKey, true);
      wasCached = !!cached;
    } catch (cacheError) {
      console.warn("Failed to check cache status:", cacheError);
    }

    return sendSuccess(res, { books }, undefined, 200, {
      cached: wasCached,
    });
  } catch (error) {
    console.error("Failed to get top rated books:", error);
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

const getNewReleases = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  try {
    const { query } = getNewReleasesSchema.parse({
      query: req.query,
    });
    const { limit, daysRange } = query;
    const bookLimit = limit ?? 50;
    const rangeDays = daysRange ?? 365;

    const books = await bookService.getNewReleases(bookLimit, rangeDays);
    const cacheKey = `books:new-releases:${bookLimit}:${rangeDays}`;

    let redis: RedisClientType | null = null;
    let wasCached = false;

    try {
      redis = getRedisClient();
      const cached = await getCache<BookWithDetails[]>(redis, cacheKey, true);
      wasCached = !!cached;
    } catch (cacheError) {
      console.warn("Failed to check cache status:", cacheError);
    }

    return sendSuccess(res, { books }, undefined, 200, {
      cached: wasCached,
    });
  } catch (error) {
    console.error("Failed to get new releases:", error);
    if (error instanceof ZodError) {
      return sendError(res, "Validation failed", "VALIDATION_ERROR", 400);
    }
    return sendError(
      res,
      "Failed to get new releases",
      "NEW_RELEASES_ERROR",
      500,
    );
  }
};

const getPopularBooks = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  try {
    const { query } = getPopularBooksSchema.parse({
      query: req.query,
    });
    const { limit } = query;
    const bookLimit = limit ?? 50;

    const books = await bookService.getPopularBooks(bookLimit);
    const cacheKey = `books:popular:${bookLimit}`;

    let redis: RedisClientType | null = null;
    let wasCached = false;

    try {
      redis = getRedisClient();
      const cached = await getCache<BookWithDetails[]>(redis, cacheKey, true);
      wasCached = !!cached;
    } catch (cacheError) {
      console.warn("Failed to check cache status:", cacheError);
    }

    return sendSuccess(res, { books }, undefined, 200, {
      cached: wasCached,
    });
  } catch (error) {
    console.error("Failed to get popular books:", error);
    if (error instanceof ZodError) {
      return sendError(res, "Validation failed", "VALIDATION_ERROR", 400);
    }
    return sendError(
      res,
      "Failed to get popular books",
      "POPULAR_BOOKS_ERROR",
      500,
    );
  }
};

export const booksListControllers = {
  getAllBooks,
  getTopRatedBooks,
  getNewReleases,
  getPopularBooks,
};
