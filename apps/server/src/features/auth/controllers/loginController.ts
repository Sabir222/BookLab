import pool from "../../../config/db/db";
import { comparerPassword } from "../../../utils/hashPassword";
import { type Request, type Response } from "express";
import jwt from "jsonwebtoken";

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

type JWTPayload = {
  id: number;
  email: string;
  username: string;
};

const validateEnv = () => {
  const required = ["JWT_SECRET", "JWT_REFRESH_SECRET"];
  const missing = required.filter((key) => !process.env[key]);
  if (missing.length > 0) {
    throw new Error(
      `Missing requied environment variables: ${missing.join(", ")}`,
    );
  }
};

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

const authenticateUser = async (username: string, password: string) => {
  const client = await pool.connect();

  try {
    const query = {
      text: "SELECT user_id, username, email, hashed_password FROM users WHERE username = $1",
      values: [username],
    };

    const result = await client.query(query);

    if (result.rows.length === 0) {
      throw new LoginError(400, "User not found!", "USER_NOT_FOUND");
    }

    const user = result.rows[0];
    const { user_id, hashed_password, email } = user;

    if (!comparerPassword(password, hashed_password)) {
      throw new LoginError(401, "Password is incorrect", "INVALID_PASSWORD");
    }

    return {
      id: user_id,
      username: user.username,
      email: email,
    };
  } finally {
    client.release();
  }
};

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
