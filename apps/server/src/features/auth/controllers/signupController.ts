import pool from "../../../config/db/db";
import { hashPassword } from "../../../utils/hashPassword";
import { type Request, type Response } from "express";
import jwt from "jsonwebtoken";

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

const createUser = async (
  username: string,
  email: string,
  hashedPassword: string,
) => {
  const client = await pool.connect();

  try {
    await client.query("BEGIN");

    const existingUserQuery = {
      text: "SELECT user_id FROM users WHERE email = $1 OR username = $2",
      values: [email, username],
    };

    const existingUser = await client.query(existingUserQuery);

    if (existingUser.rows.length > 0) {
      throw new SignUpError(
        409,
        "User with this email or username already exists",
        "USER_EXISTS",
      );
    }

    const insertQuery = {
      text: "INSERT INTO users(username, email, hashed_password) VALUES($1, $2, $3) RETURNING user_id, username, email",
      values: [username, email, hashedPassword],
    };

    const result = await client.query(insertQuery);

    await client.query("COMMIT");

    return result.rows[0];
  } catch (error) {
    await client.query("ROLLBACK");
    throw error;
  } finally {
    client.release();
  }
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
      id: newUser.user_id,
      email: newUser.email,
      username: newUser.username,
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
