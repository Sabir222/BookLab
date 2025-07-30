import rateLimit from "express-rate-limit";

/**
 * Rate limiting middleware for authentication and API endpoints.
 * This module defines rate limits for signup, login, password reset,
 * general API requests, and file uploads.
 *
 * @module authRateLimits
 */
export const authRateLimits = {
  signup: rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 3,
    message: {
      error: "Too many signup attempts, please try again later",
      retryAfter: 15 * 60,
    },
    standardHeaders: true,
    legacyHeaders: false,
  }),

  login: rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 5,
    message: {
      error: "Too many login attempts, please try again later",
      retryAfter: 15 * 60,
    },
    standardHeaders: true,
    legacyHeaders: false,
    skipSuccessfulRequests: true,
  }),

  passwordReset: rateLimit({
    windowMs: 60 * 60 * 1000,
    max: 3,
    message: {
      error: "Too many password reset attempts, please try again later",
      retryAfter: 60 * 60,
    },
    standardHeaders: true,
    legacyHeaders: false,
  }),
};

export const apiRateLimits = {
  general: rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 100,
    message: {
      error: "Too many requests, please try again later",
      retryAfter: 15 * 60,
    },
    standardHeaders: true,
    legacyHeaders: false,
  }),

  upload: rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 10,
    message: {
      error: "Too many upload attempts, please try again later",
      retryAfter: 15 * 60,
    },
    standardHeaders: true,
    legacyHeaders: false,
  }),
};
