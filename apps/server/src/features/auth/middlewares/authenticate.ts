import { type NextFunction, type Request, type Response } from "express";
import jwt from "jsonwebtoken";
import { userQueries } from "@repo/db/postgres";
import { sendError } from "../../../utils/responseHandler.js";

declare module "express-serve-static-core" {
  interface Request {
    user?: {
      id: string;
      email: string;
      username: string;
      role: string;
    };
  }
}

export const authenticate = async (
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> => {
  try {
    const accessTokenName =
      process.env.ACCESS_TOKEN_COOKIE_NAME || "accessToken";
    let token = req.cookies[accessTokenName];
    if (!token && req.headers.authorization) {
      const authHeader = req.headers.authorization;
      if (authHeader.startsWith("Bearer ")) {
        token = authHeader.substring(7);
      }
    }

    if (!token) {
      sendError(res, "Access token is required", "MISSING_TOKEN", 401);
      return;
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET!) as {
      id: string;
      email: string;
      username: string;
    };

    const user = await userQueries.findById(decoded.id);
    if (!user) {
      sendError(res, "Invalid token", "INVALID_TOKEN", 401);
      return;
    }

    req.user = {
      id: user.user_id,
      email: user.email,
      username: user.username!,
      role: user.role,
    };

    next();
  } catch (error) {
    if (error instanceof jwt.TokenExpiredError) {
      sendError(res, "Token has expired", "TOKEN_EXPIRED", 401);
      return;
    }

    if (error instanceof jwt.JsonWebTokenError) {
      sendError(res, "Invalid token", "INVALID_TOKEN", 401);
      return;
    }

    console.error("Authentication error:", error);
    sendError(res, "Internal server error", "INTERNAL_ERROR", 500);
  }
};

export const authorizeAdmin = (
  req: Request,
  res: Response,
  next: NextFunction,
): void => {
  if (!req.user) {
    sendError(res, "Unauthorized", "UNAUTHORIZED", 401);
    return;
  }

  if (req.user.role !== "admin") {
    sendError(res, "Insufficient permissions", "INSUFFICIENT_PERMISSIONS", 403);
    return;
  }

  next();
};