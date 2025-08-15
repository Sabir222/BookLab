import { type Request, type Response } from "express";
import jwt from "jsonwebtoken";
import { userQueries } from "@repo/db/postgres";

const refreshController = async (req: Request, res: Response) => {
  try {
    const refreshTokenName =
      process.env.REFRESH_TOKEN_COOKIE_NAME || "refreshToken";
    const refreshToken = req.cookies[refreshTokenName];
    console.log(req.cookies);
    console.log(
      `Yoo someone just used refresh controller mr white what the fuck refresh toekn = ${refreshToken}`,
    );
    if (!refreshToken) {
      return res.status(400).json({
        success: false,
        error: "Refresh token is missing!",
        code: "MISSING_REFRESH_TOKEN",
      });
    }

    const decoded: any = jwt.verify(
      refreshToken,
      process.env.JWT_REFRESH_SECRET!,
    );

    if (!process.env.JWT_SECRET || !process.env.JWT_REFRESH_SECRET) {
      console.error("Missing JWT secrets in environment variables");
      return res.status(500).json({
        success: false,
        error: "Server configuration error",
        code: "SERVER_CONFIG_ERROR",
      });
    }

    const user = await userQueries.findById(decoded.id);
    if (!user) {
      return res.status(401).json({
        success: false,
        error: "User not found",
        code: "USER_NOT_FOUND",
      });
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
      sameSite: "strict",
      maxAge: Number(process.env.REFRESH_TOKEN_COOKIE_MAX_AGE),
    });

    res.cookie(process.env.ACCESS_TOKEN_COOKIE_NAME!, access_token, {
      secure: process.env.NODE_ENV === "production",
      httpOnly: true,
      sameSite: "strict",
      maxAge: Number(process.env.ACCESS_TOKEN_COOKIE_MAX_AGE),
    });

    return res.status(200).json({
      success: true,
      access_token,
      user: {
        id: user.user_id,
        email: user.email,
        username: user.username,
      },
    });
  } catch (error) {
    if (error instanceof jwt.TokenExpiredError) {
      return res.status(401).json({
        success: false,
        error: "Refresh token has expired",
        code: "TOKEN_EXPIRED",
      });
    }

    if (error instanceof jwt.JsonWebTokenError) {
      return res.status(401).json({
        success: false,
        error: "Invalid refresh token",
        code: "INVALID_TOKEN",
      });
    }

    console.error("Refresh token error:", error);
    return res.status(500).json({
      success: false,
      error: "Internal server error",
      code: "INTERNAL_ERROR",
    });
  }
};

export default refreshController;
