import { userQueries } from "@repo/db/postgres";
import { type Request, type Response } from "express";
import jwt from "jsonwebtoken";

type JWTPayload = {
  id: string;
  email: string;
  username: string;
};

/**
 * Controller for handling requests to get the current user's information.
 * It checks for a valid access token in cookies, decodes it, retrieves user data,
 * and responds with the user information.
 *
 * @param {Request} req - The request object containing cookies with access token.
 * @param {Response} res - The response object to send back the user data or error.
 * @returns {Promise<void>} - A promise that resolves when the response is sent.
 */
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
