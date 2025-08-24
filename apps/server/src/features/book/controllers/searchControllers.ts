import type { Request, Response } from "express";
import { bookService } from "../services/bookService.js";
import { sendSuccess, sendError } from "../../../utils/responseHandler.js";
import { ZodError } from "zod";
import { searchBooksByNameSchema } from "../validation/booksControllerValidations.js";
import { type BookWithDetails } from "@repo/types/types";
import { getCache, getRedisClient, type RedisClientType } from "@repo/db/redis";

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

    const books = await bookService.searchBooksByName(q);
    const normalizedQuery = q.trim();
    const cacheKey = `books:title:${normalizedQuery.toLowerCase()}`;

    // Check if response was cached
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
    console.error("Search failed:", error);
    if (error instanceof ZodError) {
      return sendError(res, "Validation failed", "VALIDATION_ERROR", 400);
    }
    return sendError(res, "Search failed", "SEARCH_ERROR", 500);
  }
};

export const searchControllers = {
  getBooksByName,
};

