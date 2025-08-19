import { type Request, type Response } from "express";
import { wishlistQueries } from "@repo/db/postgres";
import { sendSuccess, sendError } from "../../../utils/responseHandler.js";

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
      sendError(res, "Authentication required", "UNAUTHORIZED", 401);
      return;
    }

    const wishlistItems = await wishlistQueries.getUserWishlistWithBooks(userId);

    sendSuccess(res, {
      wishlist: wishlistItems,
      count: wishlistItems.length,
    });
  } catch (error) {
    console.error("Get wishlist error:", error);
    sendError(res, "Internal server error", "INTERNAL_ERROR", 500);
  }
};