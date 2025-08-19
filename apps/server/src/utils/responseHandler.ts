import { type Response } from "express";

// Standardized response structure
interface ApiResponse<T = unknown> {
  success: boolean;
  message?: string;
  data?: T;
  error?: string;
  code?: string;
  meta?: Record<string, unknown>;
}

// Success response helper
export const sendSuccess = <T>(
  res: Response,
  data: T,
  message?: string,
  statusCode: number = 200,
  meta?: Record<string, unknown>,
): Response => {
  const response: ApiResponse<T> = {
    success: true,
    message,
    data,
    meta,
  };

  return res.status(statusCode).json(response);
};

// Error response helper
export const sendError = (
  res: Response,
  error: string,
  code: string,
  statusCode: number = 500,
  message?: string,
): Response => {
  const response: ApiResponse = {
    success: false,
    error,
    code,
    message,
  };

  return res.status(statusCode).json(response);
};

// Specific success responses for common cases
export const sendCreated = <T>(
  res: Response,
  data: T,
  message: string = "Resource created successfully",
): Response => {
  return sendSuccess(res, data, message, 201);
};

export const sendNoContent = (res: Response): Response => {
  return res.status(204).send();
};

// Pagination metadata helper
export const createPaginationMeta = (
  limit: number,
  offset: number,
  total?: number,
): Record<string, unknown> => {
  const meta: Record<string, unknown> = {
    limit,
    offset,
  };

  if (total !== undefined) {
    meta.total = total;
  }

  return meta;
};