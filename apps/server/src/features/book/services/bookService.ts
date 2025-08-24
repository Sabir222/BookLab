import { bookQueries } from "@repo/db/postgres";
import { type Book, type BookWithDetails } from "@repo/types/types";
import {
  getCache,
  setCache,
  getRedisClient,
  type RedisClientType,
} from "@repo/db/redis";

const CACHE_TTL = 60;

export const bookService = {
  async getBookById(bookId: string): Promise<Book | null> {
    return await bookQueries.findById(bookId);
  },

  async getAllBooks(limit: number): Promise<Book[]> {
    const cacheKey = `books:all:${limit}`;
    let redis: RedisClientType | null = null;

    try {
      redis = getRedisClient();
      const cached = await getCache<Book[]>(redis, cacheKey, true);
      if (cached) {
        return cached;
      }

      const books = await bookQueries.findBooks(limit);
      setCache(redis, cacheKey, books, CACHE_TTL).catch(console.warn);
      return books;
    } catch (error) {
      console.error("Failed to get books from service:", error);
      throw error;
    }
  },

  async searchBooksByName(query: string): Promise<BookWithDetails[]> {
    const normalizedQuery = query.trim();
    const cacheKey = `books:title:${normalizedQuery.toLowerCase()}`;
    let redis: RedisClientType | null = null;

    try {
      redis = getRedisClient();
      const cached = await getCache<BookWithDetails[]>(redis, cacheKey, true);
      if (cached) {
        return cached;
      }

      const books = await bookQueries.findBooksByName(normalizedQuery);
      setCache(redis, cacheKey, books, CACHE_TTL).catch(console.warn);
      return books;
    } catch (error) {
      console.error("Search failed in service:", error);
      throw error;
    }
  },

  async getTopRatedBooks(limit: number, minRating: number): Promise<BookWithDetails[]> {
    const cacheKey = `books:top-rated:${limit}:${minRating}`;
    let redis: RedisClientType | null = null;

    try {
      redis = getRedisClient();
      const cached = await getCache<BookWithDetails[]>(redis, cacheKey, true);
      if (cached) {
        return cached;
      }

      const books = await bookQueries.findTopRatedBooks(limit, minRating);
      setCache(redis, cacheKey, books, CACHE_TTL).catch(console.warn);
      return books;
    } catch (error) {
      console.error("Failed to get top rated books from service:", error);
      throw error;
    }
  }
};