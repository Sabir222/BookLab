import { type Request, type Response } from "express";
import { wishlistQueries } from "@repo/db/postgres";

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
      res.status(401).json({
        success: false,
        error: "Authentication required",
        code: "UNAUTHORIZED",
      });
      return;
    }

    const { book_id }: RemoveFromWishlistRequestBody = req.body;

    if (!book_id) {
      res.status(400).json({
        success: false,
        error: "Book ID is required",
        code: "MISSING_BOOK_ID",
      });
      return;
    }

    // Validate book_id is a valid UUID format
    const uuidRegex =
      /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(book_id)) {
      res.status(400).json({
        success: false,
        error: "Invalid book ID format",
        code: "INVALID_BOOK_ID",
      });
      return;
    }

    const removed = await removeFromWishlist(userId, book_id);

    if (removed) {
      console.log(
        `Book ${book_id} removed from wishlist for user ${userId}`,
      );

      res.status(200).json({
        success: true,
        message: "Book removed from wishlist successfully",
      });
    } else {
      // This shouldn't happen due to our validation, but just in case
      res.status(500).json({
        success: false,
        error: "Failed to remove book from wishlist",
        code: "REMOVE_FROM_WISHLIST_FAILED",
      });
    }
  } catch (error) {
    console.error("Remove from wishlist error:", error);

    if (error instanceof WishlistError) {
      res.status(error.statusCode).json({
        success: false,
        error: error.message,
        code: error.code,
      });
      return;
    }

    res.status(500).json({
      success: false,
      error: "Internal server error",
      code: "INTERNAL_ERROR",
    });
  }
};