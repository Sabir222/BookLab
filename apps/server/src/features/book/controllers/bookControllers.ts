import type { Request, Response } from "express";
import { bookService } from "../services/bookService.js";
import { sendSuccess, sendError } from "../../../utils/responseHandler.js";
import { ZodError } from "zod";
import { getBookByIdSchema } from "../validation/booksControllerValidations.js";

const getBookById = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { params } = getBookByIdSchema.parse({
      params: req.params,
    });
    const { id: bookId } = params;

    const book = await bookService.getBookById(bookId);
    if (!book) {
      return sendError(
        res,
        `Book '${bookId}' not found`,
        "BOOK_NOT_FOUND",
        404,
      );
    }
    return sendSuccess(res, { book });
  } catch (error) {
    console.error("Failed to get book:", error);
    if (error instanceof ZodError) {
      return sendError(res, "Validation failed", "VALIDATION_ERROR", 400);
    }
    return sendError(res, "Failed to get book", "INTERNAL_SERVER_ERROR", 500);
  }
};

export const bookControllers = {
  getBookById,
};