import { userQueries } from "@repo/db/postgres";
import { type Request, type Response } from "express";

const meController = async (req: Request, res: Response) => {
  try {
    const userId = req.user?.id;
    console.log(req.user);
    if (!userId) {
      return res.status(401).json({
        success: false,
        error: "Unauthorized!",
        code: "UNAUTHORIZED",
      });
    }

    const user = await userQueries.findById(userId);

    if (!user) {
      return res.status(404).json({
        success: false,
        error: "User not found",
        code: "USER_NOT_FOUND",
      });
    }

    const { hashed_password, ...publicUser } = user;

    return res.status(200).json({
      success: true,
      data: { user: publicUser },
    });
  } catch (error) {
    console.error("Error in meController:", error);
    return res.status(500).json({
      success: false,
      error: "Internal server error",
      code: "INTERNAL_ERROR",
    });
  }
};

export default meController;
