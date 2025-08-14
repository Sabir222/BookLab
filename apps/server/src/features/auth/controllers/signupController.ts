import { hashPassword } from "../../../utils/hashPassword.js";
import { type Request, type Response } from "express";
import { userQueries } from "@repo/db/postgres";
import type { JWTPayload } from "../../../utils/generateToken.js";
import generateToken from "../../../utils/generateToken.js";
import setAuthCookies from "../../../utils/setAuthCookies.js";
import { CreateUserData, User } from "@repo/types/types";

class SignUpError extends Error {
  constructor(
    public statusCode: number,
    message: string,
    public code?: string,
  ) {
    super(message);
    this.name = "SignUpError";
  }
}

type SignUpRequestBody = {
  email: string;
  username: string;
  password: string;
};

/**
 * Creates a new user in the database after validating that the email and username
 * do not already exist. Throws an error if either already exists.
 *
 * @param {string} username - The username of the new user.
 * @param {string} email - The email of the new user.
 * @param {string} hashedPassword - The hashed password of the new user.
 * @returns {Promise<User>} - Returns the created user object.
 *
 * @throws {SignUpError} - If a user with the same email or username already exists.
 */

const createUser = async (
  username: string,
  email: string,
  hashedPassword: string,
): Promise<User> => {
  const existingEmailUser = await userQueries.findByEmail(email);
  if (existingEmailUser) {
    throw new SignUpError(
      409,
      "User with this email already exists",
      "EMAIL_EXISTS",
    );
  }

  const existingUsernameUser = await userQueries.findByUsername(username);
  if (existingUsernameUser) {
    throw new SignUpError(
      409,
      "User with this username already exists",
      "USERNAME_EXISTS",
    );
  }

  const userData: CreateUserData = {
    username,
    email,
    hashedPassword,
  };

  return await userQueries.create(userData);
};

/**
 * Controller for handling user sign-up requests.
 * Validates the request, creates a new user, generates JWT tokens,
 * sets cookies, and responds with user data and access token.
 *
 * @param {Request} req - The request object containing user credentials.
 * @param {Response} res - The response object to send back the result.
 * @returns {Promise<void>} - A promise that resolves when the response is sent.
 *
 * @throws {SignUpError} - If user creation fails or required fields are missing
 */
export const signUpController = async (
  req: Request,
  res: Response,
): Promise<void> => {
  try {
    const { email, username, password }: SignUpRequestBody = req.body;

    if (!email || !username || !password) {
      res.status(400).json({
        error: "Data missing try again please!",
        code: "MISSING_FIELDS",
      });
      return;
    }

    const hashedPassword = hashPassword(password);

    const newUser = await createUser(username, email, hashedPassword);

    const tokenPayload: JWTPayload = {
      id: newUser.user_id,
      email: newUser.email,
      username: newUser.username!,
    };

    const { accessToken, refreshToken } = generateToken(tokenPayload);

    setAuthCookies(res, accessToken, refreshToken);

    console.log(
      `User successfully registered: ${email} (ID: ${newUser.user_id})`,
    );

    res.status(201).json({
      message: "User created successfully",
      user: {
        id: newUser.user_id,
        username: newUser.username,
        email: newUser.email,
      },
      accessToken,
    });
  } catch (error) {
    console.error("SignUp error:", error);

    if (error instanceof SignUpError) {
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
