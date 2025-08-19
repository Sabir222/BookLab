import { type Request, type Response, type NextFunction } from "express";
import { sendError } from "../../../utils/responseHandler.js";

export const validateNewsletter = (
  req: Request,
  res: Response,
  next: NextFunction,
) => {
  const { email } = req.body;

  if (!email) {
    return sendError(res, "Email is required", "MISSING_EMAIL", 400);
  }

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    return sendError(res, "Invalid email format", "INVALID_EMAIL", 400);
  }

  next();
};

