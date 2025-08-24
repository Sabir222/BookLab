import express from "express";
import { booksController } from "../controller/booksController.js";
import { validate } from "../middleware/validate.js";
import {
  getBookByIdSchema,
  getAllBooksSchema,
  searchBooksByNameSchema,
  getTopRatedBooksSchema,
} from "../validation/booksControllerValidations.js";

const bookPublicRouter = express.Router();

bookPublicRouter.get(
  "/top-rated",
  validate(getTopRatedBooksSchema),
  booksController.getTopRatedBooks,
);

bookPublicRouter.get(
  "/search",
  validate(searchBooksByNameSchema),
  booksController.getBooksByName,
);

bookPublicRouter.get(
  "/",
  validate(getAllBooksSchema),
  booksController.getAllBooks,
);

bookPublicRouter.get(
  "/:id",
  validate(getBookByIdSchema),
  booksController.getBookById,
);

export default bookPublicRouter;
