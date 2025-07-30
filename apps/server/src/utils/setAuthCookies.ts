import { type Request, type Response } from "express";

/**
 * Sets authentication cookies for access and refresh tokens.
 * @param res - Express response object
 * @param accessToken - JWT access token
 * @param refreshToken - JWT refresh token
 */

const setAuthCookies = (
  res: Response,
  accessToken: string,
  refreshToken: string,
) => {
  const isProduction = process.env.NODE_ENV === "production";

  const cookieOptions = {
    secure: isProduction,
    httpOnly: true,
    sameSite: "strict" as const,
  };

  res.cookie(
    process.env.REFRESH_TOKEN_COOKIE_NAME || "refreshToken",
    refreshToken,
    {
      ...cookieOptions,
      maxAge:
        Number(process.env.REFRESH_TOKEN_COOKIE_MAX_AGE) ||
        7 * 24 * 60 * 60 * 1000,
    },
  );

  res.cookie(
    process.env.ACCESS_TOKEN_COOKIE_NAME || "accessToken",
    accessToken,
    {
      ...cookieOptions,
      maxAge: Number(process.env.ACCESS_TOKEN_COOKIE_MAX_AGE) || 15 * 60 * 1000, // 15 minutes
    },
  );
};

export default setAuthCookies;
