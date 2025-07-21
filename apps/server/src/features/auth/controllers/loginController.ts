import { type Request, type Response } from "express";
import jwt from "jsonwebtoken";
import pool from "../../../config/db/db";
import { comparerPassword } from "../../../utils/hashPassword";

const loginController = async (req: Request, res: Response) => {
  const { password, username } = req.body;

  try {
    const query = {
      text: "SELECT * FROM users WHERE  username = $1",
      values: [username],
    };

    const result = await pool.query(query);

    if (result.rows[0] === 0) {
      return res.status(400).json({ error: "User not found!" });
    }

    const { user_id, hashed_password } = result.rows[0];

    const jwtSecret = process.env.JWT_SECRET as string;
    const jwtRefreshSecret = process.env.JWT_REFRESH_SECRET as string;

    if (!comparerPassword(password, hashed_password)) {
      return res.json({ error: "Password is incorrect" });
    }

    if (!process.env.JWT_SECRET || !process.env.JWT_REFRESH_SECRET) {
      console.error("Missing JWT secrets in environment variables");
      res.status(500).send("Server configuration error");
      return;
    }

    const access_token = jwt.sign({ id: user_id }, jwtSecret, {
      expiresIn: "15m",
    });

    const refresh_token = jwt.sign({ id: user_id }, jwtRefreshSecret, {
      expiresIn: "7d",
    });

    res.cookie(process.env.REFRESH_TOKEN_COOKIE_NAME!, refresh_token, {
      secure: process.env.NODE_ENV === "production",
      httpOnly: true,
      sameSite: "lax",
      maxAge: Number(process.env.REFRESH_TOKEN_COOKIE_MAX_AGE),
    });

    res.cookie(process.env.ACCESS_TOKEN_COOKIE_NAME!, access_token, {
      secure: process.env.NODE_ENV === "production",
      httpOnly: true,
      sameSite: "lax",
      maxAge: Number(process.env.ACCESS_TOKEN_COOKIE_MAX_AGE),
    });

    return res
      .status(200)
      .json({ message: "Logged in successfully", access_token: access_token });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Something went wrong!" });
  }
};

export default loginController;
