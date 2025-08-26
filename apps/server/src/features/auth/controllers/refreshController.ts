import { type Request, type Response } from "express";
import jwt from "jsonwebtoken";
import { userQueries } from "@repo/db/postgres";
import { sendSuccess, sendError } from "../../../utils/responseHandler.js";

const refreshController = async (req: Request, res: Response) => {
  try {
    const refreshTokenName =
      process.env.REFRESH_TOKEN_COOKIE_NAME || "refreshToken";
    const refreshToken = req.cookies[refreshTokenName];

    if (!refreshToken) {
      return sendError(
        res,
        "Refresh token is missing!",
        "MISSING_REFRESH_TOKEN",
        400,
      );
    }

    const decoded: any = jwt.verify(
      refreshToken,
      process.env.JWT_REFRESH_SECRET!,
    );

    if (!process.env.JWT_SECRET || !process.env.JWT_REFRESH_SECRET) {
      console.error("Missing JWT secrets in environment variables");
      return sendError(
        res,
        "Server configuration error",
        "SERVER_CONFIG_ERROR",
        500,
      );
    }

    const user = await userQueries.findById(decoded.id);
    if (!user) {
      return sendError(res, "User not found", "USER_NOT_FOUND", 401);
    }

    const jwtSecret = process.env.JWT_SECRET as string;
    const jwtRefreshSecret = process.env.JWT_REFRESH_SECRET as string;

    const tokenPayload = {
      id: user.user_id,
      email: user.email,
      username: user.username,
    };

    const access_token = jwt.sign(tokenPayload, jwtSecret, {
      expiresIn: "15m",
    });

    const refresh_token = jwt.sign({ id: user.user_id }, jwtRefreshSecret, {
      expiresIn: "7d",
    });

    res.cookie(process.env.REFRESH_TOKEN_COOKIE_NAME!, refresh_token, {
      secure: process.env.NODE_ENV === "production",
      httpOnly: true,
      sameSite: "none",
      maxAge: Number(process.env.REFRESH_TOKEN_COOKIE_MAX_AGE),
    });

    res.cookie(process.env.ACCESS_TOKEN_COOKIE_NAME!, access_token, {
      secure: process.env.NODE_ENV === "production",
      httpOnly: true,
      sameSite: "none",
      maxAge: Number(process.env.ACCESS_TOKEN_COOKIE_MAX_AGE),
    });

    return sendSuccess(res, {
      access_token,
      user: {
        id: user.user_id,
        email: user.email,
        username: user.username,
      },
    });
  } catch (error) {
    if (error instanceof jwt.TokenExpiredError) {
      return sendError(res, "Refresh token has expired", "TOKEN_EXPIRED", 401);
    }

    if (error instanceof jwt.JsonWebTokenError) {
      return sendError(res, "Invalid refresh token", "INVALID_TOKEN", 401);
    }

    console.error("Refresh token error:", error);
    return sendError(res, "Internal server error", "INTERNAL_ERROR", 500);
  }
};

export default refreshController;

