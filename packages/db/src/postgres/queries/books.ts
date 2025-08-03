import { db } from "../client.js";
import { type Book } from "../types/book-types.js";

export const bookQueries = {
  async findById(bookId: string): Promise<Book | null> {
    const result = await db.query("SELECT * FROM books WHERE book_id = $1", [
      bookId,
    ]);
    return result.rows[0] || null;
  },

  async findBooks(): Promise<Book[]> {
    const result = await db.query("SELECT * FROM books");
    return result.rows as Book[];
  },
};
