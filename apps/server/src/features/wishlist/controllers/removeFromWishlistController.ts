import { type Request, type Response } from "express";
import { wishlistQueries } from "@repo/db/postgres";
import { sendSuccess, sendError } from "../../../utils/responseHandler.js";

class WishlistError extends Error {
  constructor(
    public statusCode: number,
    message: string,
    public code?: string,
  ) {
    super(message);
    this.name = "WishlistError";
  }
}

type RemoveFromWishlistRequestBody = {
  book_id: string;
};

/**
 * Removes a book from the user's wishlist.
 * Validates that the book is in the user's wishlist.
 *
 * @param {string} userId - The ID of the user.
 * @param {string} bookId - The ID of the book to remove from the wishlist.
 * @returns {Promise<boolean>} - Returns true if the book was removed.
 *
 * @throws {WishlistError} - If the book is not in the user's wishlist.
 */
const removeFromWishlist = async (userId: string, bookId: string) => {
  // Check if the book is in the user's wishlist
  const isAlreadyInWishlist = await wishlistQueries.isBookInUserWishlist(
    userId,
    bookId,
  );
  if (!isAlreadyInWishlist) {
    throw new WishlistError(
      404,
      "Book is not in your wishlist",
      "BOOK_NOT_IN_WISHLIST",
    );
  }

  // Remove the book from the wishlist
  const removed = await wishlistQueries.removeItemFromWishlist(userId, bookId);
  return removed;
};

/**
 * Controller for removing a book from the user's wishlist.
 * Requires authentication.
 *
 * @param {Request} req - The request object containing the book ID.
 * @param {Response} res - The response object to send back the result.
 * @returns {Promise<void>} - A promise that resolves when the response is sent.
 *
 * @throws {WishlistError} - If removing from wishlist fails or required fields are missing
 */
export const removeFromWishlistController = async (
  req: Request,
  res: Response,
): Promise<void> => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      sendError(res, "Authentication required", "UNAUTHORIZED", 401);
      return;
    }

    const { book_id }: RemoveFromWishlistRequestBody = req.body;

    if (!book_id) {
      sendError(res, "Book ID is required", "MISSING_BOOK_ID", 400);
      return;
    }

    // Validate book_id is a valid UUID format
    const uuidRegex =
      /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(book_id)) {
      sendError(res, "Invalid book ID format", "INVALID_BOOK_ID", 400);
      return;
    }

    const removed = await removeFromWishlist(userId, book_id);

    if (removed) {
      console.log(
        `Book ${book_id} removed from wishlist for user ${userId}`,
      );

      sendSuccess(res, null, "Book removed from wishlist successfully");
    } else {
      // This shouldn't happen due to our validation, but just in case
      sendError(res, "Failed to remove book from wishlist", "REMOVE_FROM_WISHLIST_FAILED", 500);
    }
  } catch (error) {
    console.error("Remove from wishlist error:", error);

    if (error instanceof WishlistError) {
      sendError(res, error.message, error.code || "WISHLIST_ERROR", error.statusCode);
      return;
    }

    sendError(res, "Internal server error", "INTERNAL_ERROR", 500);
  }
};