import { type Request, type Response } from "express";
import jwt from "jsonwebtoken";

/**
 * Controller for handling refresh token requests.
 * Validates the refresh token, generates new access and refresh tokens,
 * and sets them as cookies in the response.
 *
 * @param {Request} req - The request object containing cookies with the refresh token.
 * @param {Response} res - The response object to send back the new tokens or error.
 * @returns {Response} - A response with new access token or an error message.
 */
const refreshController = (req: Request, res: Response) => {
  const refreshTokenName =
    process.env.REFRESH_TOKEN_COOKIE_NAME || "refreshToken";
  const refreshToken = req.cookies[refreshTokenName];

  if (!refreshToken) {
    return res.status(400).json({ message: "Refresh token is expired!" });
  }

  const decoded: any = jwt.verify(
    refreshToken,
    process.env.JWT_REFRESH_SECRET!,
  );

  if (!process.env.JWT_SECRET || !process.env.JWT_REFRESH_SECRET) {
    console.error("Missing JWT secrets in environment variables");
    res.status(500).send("Server configuration error");
    return;
  }
  const jwtSecret = process.env.JWT_SECRET as string;
  const jwtRefreshSecret = process.env.JWT_REFRESH_SECRET as string;

  const access_token = jwt.sign({ id: decoded.id }, jwtSecret, {
    expiresIn: "15m",
  });

  const refresh_token = jwt.sign({ id: decoded.id }, jwtRefreshSecret, {
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

  return res.json({ access_token }).status(200);
};

export default refreshController;
