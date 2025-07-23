import pool from "@repo/db/db";

import { type Request, type Response } from "express";
import jwt from "jsonwebtoken";

type JWTPayload = {
  id: number;
  email: string;
  username: string;
};

const meController = async (req: Request, res: Response) => {
  const { access_token } = req.cookies;

  if (!access_token) return res.status(401).json({ message: "Unauthorized!" });

  const decoded = jwt.verify(
    access_token,
    process.env.JWT_SECRET!,
  ) as JWTPayload;

  const query = {
    text: "SELECT * FROM users WHERE user_id = $1",
    values: [decoded.id],
  };

  const result = await pool.query(query);
  const { user_id, email, full_name, role, hashed_password } = result.rows[0];

  return res
    .json({ user_id, email, full_name, role, hashed_password })
    .status(200);
};
export default meController;
