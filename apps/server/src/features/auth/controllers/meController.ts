import { type Request, type Response } from "express";
import { userQueries } from "@repo/db/postgres";
import { sendSuccess, sendError } from "../../../utils/responseHandler.js";

const meController = async (req: Request, res: Response) => {
  try {
    const userId = req.user?.id;

    if (!userId) {
      return sendError(res, "Unauthorized!", "UNAUTHORIZED", 401);
    }

    const user = await userQueries.findById(userId);

    if (!user) {
      return sendError(res, "User not found", "USER_NOT_FOUND", 404);
    }

    const { hashed_password, ...publicUser } = user;

    return sendSuccess(res, { user: publicUser });
  } catch (error) {
    console.error("Error in meController:", error);
    return sendError(res, "Internal server error", "INTERNAL_ERROR", 500);
  }
};

export default meController;