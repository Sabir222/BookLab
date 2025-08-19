import { type NextFunction, type Request, type Response } from "express";
import { ZodType } from "zod";
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
      return sendError(res, "Validation error", "VALIDATION_ERROR", 400, error.message);
    }
  };