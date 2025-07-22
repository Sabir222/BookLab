import { type Request, type Response } from "express";
import jwt from "jsonwebtoken";

const refreshController = (req: Request, res: Response) => {
  const { SabirAuthRefresh } = req.cookies;

  if (!SabirAuthRefresh) {
    return res.status(400).json({ message: "Refresh token is expired!" });
  }

  const decoded: any = jwt.verify(
    SabirAuthRefresh,
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
