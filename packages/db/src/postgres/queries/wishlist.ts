import { db } from "../client.js";
import {
  type UserWishlistItem,
  type CreateUserWishlistItemData,
  type Book,
} from "@repo/types/types";

export const wishlistQueries = {
  async addItemToWishlist(
    wishlistData: CreateUserWishlistItemData,
  ): Promise<UserWishlistItem> {
    const result = await db.query(
      `INSERT INTO user_wishlist (user_id, book_id)
       VALUES ($1, $2)
       RETURNING *`,
      [wishlistData.user_id, wishlistData.book_id],
    );
    return result.rows[0];
  },

  async removeItemFromWishlist(
    userId: string,
    bookId: string,
  ): Promise<boolean> {
    const result = await db.query(
      "DELETE FROM user_wishlist WHERE user_id = $1 AND book_id = $2",
      [userId, bookId],
    );
    return (result.rowCount ?? 0) > 0;
  },

  async getUserWishlist(userId: string): Promise<UserWishlistItem[]> {
    const result = await db.query(
      `SELECT uw.*, b.title, b.subtitle, b.cover_image_url 
       FROM user_wishlist uw
       JOIN books b ON uw.book_id = b.book_id
       WHERE uw.user_id = $1
       ORDER BY uw.added_at DESC`,
      [userId],
    );
    return result.rows;
  },

  async getUserWishlistWithBooks(
    userId: string,
  ): Promise<(UserWishlistItem & Book)[]> {
    const result = await db.query(
      `SELECT uw.*, b.* 
       FROM user_wishlist uw
       JOIN books b ON uw.book_id = b.book_id
       WHERE uw.user_id = $1
       ORDER BY uw.added_at DESC`,
      [userId],
    );
    return result.rows;
  },

  async isBookInUserWishlist(userId: string, bookId: string): Promise<boolean> {
    const result = await db.query(
      "SELECT 1 FROM user_wishlist WHERE user_id = $1 AND book_id = $2",
      [userId, bookId],
    );
    return result.rows.length > 0;
  },

  async getUserWishlistCount(userId: string): Promise<number> {
    const result = await db.query(
      "SELECT COUNT(*) as count FROM user_wishlist WHERE user_id = $1",
      [userId],
    );
    return parseInt(result.rows[0].count, 10);
  },

  async clearUserWishlist(userId: string): Promise<boolean> {
    const result = await db.query(
      "DELETE FROM user_wishlist WHERE user_id = $1",
      [userId],
    );
    return (result.rowCount ?? 0) > 0;
  },
};

