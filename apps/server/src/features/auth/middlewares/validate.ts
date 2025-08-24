import { type NextFunction, type Request, type Response } from "express";
import { ZodError, type ZodType } from "zod";
import { sendError } from "../../../utils/responseHandler.js";

export const validate =
  (schema: ZodType<any>) =>
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      await schema.parseAsync({
        body: req.body,
        query: req.query,
        params: req.params,
      });
      return next();
    } catch (error: any) {
      if (error instanceof ZodError) {
        const errorMessage = error.issues
          .map((issue) => issue.message)
          .join(", ");
        return sendError(
          res,
          "Validation error",
          "VALIDATION_ERROR",
          400,
          errorMessage,
        );
      }
      return sendError(
        res,
        "Validation error",
        "VALIDATION_ERROR",
        400,
        error.message,
      );
    }
  };
