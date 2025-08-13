import { type Request, type Response, type NextFunction } from "express";

export const validateNewsletter = (
  req: Request,
  res: Response,
  next: NextFunction,
) => {
  const { email } = req.body;

  if (!email) {
    return res.status(400).json({
      error: "Email is required",
      code: "MISSING_EMAIL",
    });
  }

  // Basic email validation
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    return res.status(400).json({
      error: "Invalid email format",
      code: "INVALID_EMAIL",
    });
  }

  next();
};