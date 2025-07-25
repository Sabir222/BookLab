import { userQueries } from "@repo/db/database";
import { type Request, type Response } from "express";
import jwt from "jsonwebtoken";

type JWTPayload = {
  id: string;
  email: string;
  username: string;
};

const meController = async (req: Request, res: Response) => {
  const accessTokenName = process.env.ACCESS_TOKEN_COOKIE_NAME || "accessToken";
  const accessToken = req.cookies[accessTokenName];

  if (!accessToken) return res.status(401).json({ message: "Unauthorized!" });

  const decoded = jwt.verify(
    accessToken,
    process.env.JWT_SECRET!,
  ) as JWTPayload;

  const result = await userQueries.findById(decoded.id);
  //const { user_id, email, full_name, role, hashed_password } = result.rows[0];

  return (
    res
      //.json({ user_id, email, full_name, role, hashed_password })
      .json({
        result,
      })
      .status(200)
  );
};
export default meController;
