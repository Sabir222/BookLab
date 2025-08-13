import { type Request, type Response } from "express";
import { wishlistQueries } from "@repo/db/postgres";

/**
 * Controller for getting the user's wishlist.
 * Requires authentication.
 *
 * @param {Request} req - The request object.
 * @param {Response} res - The response object to send back the result.
 * @returns {Promise<void>} - A promise that resolves when the response is sent.
 */
export const getWishlistController = async (
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

    const wishlistItems = await wishlistQueries.getUserWishlistWithBooks(userId);

    res.status(200).json({
      success: true,
      data: {
        wishlist: wishlistItems,
        count: wishlistItems.length,
      },
    });
  } catch (error) {
    console.error("Get wishlist error:", error);

    res.status(500).json({
      success: false,
      error: "Internal server error",
      code: "INTERNAL_ERROR",
    });
  }
};