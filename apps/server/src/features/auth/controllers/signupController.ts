import { hashPassword } from "../../../utils/hashPassword";
import { type Request, type Response } from "express";
import jwt from "jsonwebtoken";
import { userQueries, type User, type CreateUserData } from "@repo/db/database";

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

type JWTPayload = {
  id: string;
  email: string;
  username: string;
};
//TODO: add this to utils and call it here.
const validateEnv = () => {
  const required = ["JWT_SECRET", "JWT_REFRESH_SECRET"];
  const missing = required.filter((key) => !process.env[key]);
  if (missing.length > 0) {
    throw new Error(
      `Missing required environment variables: ${missing.join(", ")}`,
    );
  }
};
//TODO: add this to utils too
const generateToken = (payload: JWTPayload) => {
  const jwtSecret = process.env.JWT_SECRET!;
  const jwtRefreshSecret = process.env.JWT_REFRESH_SECRET!;

  const accessToken = jwt.sign(payload, jwtSecret, {
    expiresIn: "15m",
  });

  const refreshToken = jwt.sign({ id: payload.id }, jwtRefreshSecret, {
    expiresIn: "7d",
  });

  return { accessToken, refreshToken };
};

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
        7 * 24 * 60 * 60 * 1000, // 7 days
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

export const signUpController = async (
  req: Request,
  res: Response,
): Promise<void> => {
  try {
    validateEnv();

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
      id: newUser.user_id, // This is now a UUID string
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
