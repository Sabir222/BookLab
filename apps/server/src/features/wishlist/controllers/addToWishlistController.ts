import { type Request, type Response } from "express";
import { wishlistQueries, bookQueries } from "@repo/db/postgres";
import { sendCreated, sendError } from "../../../utils/responseHandler.js";

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

type AddToWishlistRequestBody = {
  book_id: string;
};

/**
 * Adds a book to the user's wishlist.
 * Validates that the book exists and is not already in the user's wishlist.
 *
 * @param {string} userId - The ID of the user.
 * @param {string} bookId - The ID of the book to add to the wishlist.
 * @returns {Promise<UserWishlistItem>} - Returns the wishlist item.
 *
 * @throws {WishlistError} - If the book doesn't exist or is already in the wishlist.
 */
const addToWishlist = async (userId: string, bookId: string) => {
  // Check if the book exists
  const book = await bookQueries.findById(bookId);
  if (!book) {
    throw new WishlistError(404, "Book not found", "BOOK_NOT_FOUND");
  }

  const isAlreadyInWishlist = await wishlistQueries.isBookInUserWishlist(
    userId,
    bookId,
  );
  if (isAlreadyInWishlist) {
    throw new WishlistError(
      409,
      "Book is already in your wishlist",
      "BOOK_ALREADY_IN_WISHLIST",
    );
  }

  return await wishlistQueries.addItemToWishlist({
    user_id: userId,
    book_id: bookId,
  });
};

/**
 * Controller for adding a book to the user's wishlist.
 * Requires authentication.
 *
 * @param {Request} req - The request object containing the book ID.
 * @param {Response} res - The response object to send back the result.
 * @returns {Promise<void>} - A promise that resolves when the response is sent.
 *
 * @throws {WishlistError} - If adding to wishlist fails or required fields are missing
 */
export const addToWishlistController = async (
  req: Request,
  res: Response,
): Promise<void> => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      sendError(res, "Authentication required", "UNAUTHORIZED", 401);
      return;
    }

    const { book_id }: AddToWishlistRequestBody = req.body;

    if (!book_id) {
      sendError(res, "Book ID is required", "MISSING_BOOK_ID", 400);
      return;
    }

    const uuidRegex =
      /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(book_id)) {
      sendError(res, "Invalid book ID format", "INVALID_BOOK_ID", 400);
      return;
    }

    const wishlistItem = await addToWishlist(userId, book_id);

    console.log(`Book ${book_id} added to wishlist for user ${userId}`);

    sendCreated(
      res,
      {
        wishlist_item: {
          user_id: wishlistItem.user_id,
          book_id: wishlistItem.book_id,
          added_at: wishlistItem.added_at,
        },
      },
      "Book added to wishlist successfully",
    );
  } catch (error) {
    console.error("Add to wishlist error:", error);

    if (error instanceof WishlistError) {
      sendError(
        res,
        error.message,
        error.code || "WISHLIST_ERROR",
        error.statusCode,
      );
      return;
    }

    sendError(res, "Internal server error", "INTERNAL_ERROR", 500);
  }
};

