import { type NextFunction, type Request, type Response } from "express";
import { ZodType } from "zod";

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
    } catch (error) {
      return res.status(400).json(error);
    }
  };
