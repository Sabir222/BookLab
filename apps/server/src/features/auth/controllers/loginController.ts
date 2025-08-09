import { userQueries, type User } from "@repo/db/postgres";
import { comparerPassword } from "../../../utils/hashPassword.js";
import { type Request, type Response } from "express";
import type { JWTPayload } from "../../../utils/generateToken.js";
import generateToken from "../../../utils/generateToken.js";
import validateEnv from "../../../utils/validateEnv.js";
import setAuthCookies from "../../../utils/setAuthCookies.js";

class LoginError extends Error {
  constructor(
    public statusCode: number,
    message: string,
    public code?: string,
  ) {
    super(message);
    this.name = "LoginError";
  }
}

type LoginRequestBody = {
  username: string;
  password: string;
};

/**
 * Authenticates a user by checking the provided username and password.
 * Throws an error if the user is not found or if the password is incorrect.
 *
 * @param {string} username - The username of the user.
 * @param {string} password - The password of the user.
 * @returns {Promise<{ id: string; username: string; email: string }>} - Returns user data if authentication is successful.
 *
 * @throws {LoginError} - If user not found or password is incorrect.
 */

const authenticateUser = async (username: string, password: string) => {
  //TODO: make this to work if user want to login with email too
  const user: User | null = await userQueries.findByUsername(username);

  if (user === null) {
    throw new LoginError(400, "User not found!", "USER_NOT_FOUND");
  }

  const { user_id, hashed_password, email } = user;

  if (!comparerPassword(password, hashed_password)) {
    throw new LoginError(401, "Password is incorrect", "INVALID_PASSWORD");
  }

  return {
    id: user_id,
    username: user.username,
    email: email,
  };
};

/**
 * Controller for handling user login requests.
 * Validates the request, authenticates the user, generates JWT tokens,
 * sets cookies, and responds with user data and access token.
 *
 * @param {Request} req - The request object containing user credentials.
 * @param {Response} res - The response object to send back the result.
 * @returns {Promise<void>} - A promise that resolves when the response is sent.
 *
 * @throws {LoginError} - If authentication fails or required fields are missing*/

export const loginController = async (
  req: Request,
  res: Response,
): Promise<void> => {
  try {
    validateEnv();

    const { username, password }: LoginRequestBody = req.body;

    if (!username || !password) {
      res.status(400).json({
        error: "Data missing try again please!",
        code: "MISSING_FIELDS",
      });
      return;
    }

    const user = await authenticateUser(username, password);

    const tokenPayload: JWTPayload = {
      id: user.id,
      email: user.email,
      username: user.username,
    };

    const { accessToken, refreshToken } = generateToken(tokenPayload);

    setAuthCookies(res, accessToken, refreshToken);

    console.log(
      `User successfully logged in: ${user.username} (ID: ${user.id})`,
    );

    res.status(200).json({
      message: "Logged in successfully",
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
      },
      accessToken,
    });
  } catch (error) {
    console.error("Login error:", error);

    if (error instanceof LoginError) {
      res.status(error.statusCode).json({
        error: error.message,
        code: error.code,
      });
      return;
    }

    res.status(500).json({
      error: "Internal server error",
      code: "INTERNAL_ERROR",
    });
  }
};
