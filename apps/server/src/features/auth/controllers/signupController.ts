import pool from "../../../config/db/db";
import { hashPassword } from "../../../utils/hashPassword";
import { type Request, type Response } from "express";
import jwt from "jsonwebtoken";

export const signUpController = async (req: Request, res: Response) => {
  const { email, username, password } = req.body;
  const hashedPassword = hashPassword(password);

  try {
    if (!email || !username || !password) {
      res.status(400).send("Data missing try again please!");
      return;
    }

    if (!process.env.JWT_SECRET || !process.env.JWT_REFRESH_SECRET) {
      console.error("Missing JWT secrets in environment variables");
      res.status(500).send("Server configuration error");
      return;
    }

    const emailLower = email.toLowerCase();
    const usernameLower = username.toLowerCase();

    const query = {
      text: "INSERT INTO users(username, email, hashed_password) VALUES($1, $2, $3) RETURNING user_id",
      values: [usernameLower, emailLower, hashedPassword],
    };

    const result = await pool.query(query);
    const userId = result.rows[0].user_id;
    const jwtSecret = process.env.JWT_SECRET as string;
    const jwtRefreshSecret = process.env.JWT_REFRESH_SECRET as string;

    const access_token = jwt.sign({ id: userId }, jwtSecret, {
      expiresIn: "15m",
    });

    const refresh_token = jwt.sign({ id: userId }, jwtRefreshSecret, {
      expiresIn: "7d",
    });

    res.cookie(
      process.env.REFRESH_TOKEN_COOKIE_NAME || "refreshToken",
      refresh_token,
      {
        secure: process.env.NODE_ENV === "production",
        httpOnly: true,
        sameSite: "lax",
        maxAge:
          Number(process.env.REFRESH_TOKEN_COOKIE_MAX_AGE) ||
          7 * 24 * 60 * 60 * 1000,
      },
    );

    res.cookie(
      process.env.ACCESS_TOKEN_COOKIE_NAME || "accessToken",
      access_token,
      {
        secure: process.env.NODE_ENV === "production",
        httpOnly: true,
        sameSite: "lax",
        maxAge:
          Number(process.env.ACCESS_TOKEN_COOKIE_MAX_AGE) || 15 * 60 * 1000,
      },
    );

    return res.status(201).json({ access_token });
  } catch (error) {
    console.error("SignUp error:", error);

    if (error && typeof error === "object" && "code" in error) {
      if (error.code === "23505") {
        return res.status(409).json({
          error: "User with this email or username already exists",
        });
      }
    }

    return res.status(500).json({
      error: "Internal server error",
    });
  }
};
