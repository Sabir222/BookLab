import type { Request, Response } from "express";
import { bookQueries, type Book } from "@repo/db/postgres";
import {
  getCache,
  getRedisClient,
  setCache,
  type RedisClientType,
} from "@repo/db/redis";

const getBookById = async (req: Request, res: Response) => {
  try {
    const bookId = req.params.id;
    console.log(bookId);
    if (!bookId) {
      return res.status(400).json({ error: "Missing Book id!" });
    }
    const book = await bookQueries.findById(bookId);
    console.log(book);
    if (!book) {
      return res
        .status(404)
        .json({ error: `Book with id ${bookId} not found` });
    }
    return res
      .status(200)
      .json({ message: `Books with id ${bookId} found`, book: book });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Something wrong happend!" });
  }
};

export const getAllBooks = async (_req: Request, res: Response) => {
  try {
    const books: Book[] = await bookQueries.findBooks();

    return res.status(200).json({
      success: true,
      data: books,
    });
  } catch (error) {
    console.error("Failed to fetch books:", error);

    return res.status(500).json({
      success: false,
      message: "Failed to retrieve books. Please try again later.",
    });
  }
};

const getAllBooksRedis = async (_req: Request, res: Response) => {
  const cacheKey = "books:all";
  const redis: RedisClientType = getRedisClient();
  try {
    const cachedBooks = await getCache<Book[]>(redis, cacheKey, true);
    if (cachedBooks) {
      return res.status(200).json({
        success: true,
        data: cachedBooks,
        cached: true,
      });
    }

    const books = await bookQueries.findBooks();

    await setCache(redis, cacheKey, books, 60);
    return res.status(200).json({
      success: true,
      data: books,
      cached: false,
    });
  } catch (error) {
    console.error("Error fetching books:", error);
    return res.status(500).json({
      success: false,
      message: "Failed to retrieve books",
    });
  }
};

export const bookPublicActionsController = {
  getBookById,
  getAllBooks,
  getAllBooksRedis,
};
