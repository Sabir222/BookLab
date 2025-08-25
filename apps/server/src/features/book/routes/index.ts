import express from "express";
import {
  bookControllers,
  booksListControllers,
  searchControllers,
} from "../controllers/index.js";
import { validate } from "../middleware/validate.js";
import {
  getBookByIdSchema,
  getAllBooksSchema,
  searchBooksByNameSchema,
  getTopRatedBooksSchema,
  getNewReleasesSchema,
  getPopularBooksSchema,
} from "../validation/booksControllerValidations.js";

const bookPublicRouter = express.Router();

bookPublicRouter.get(
  "/popular",
  validate(getPopularBooksSchema),
  booksListControllers.getPopularBooks,
);

bookPublicRouter.get(
  "/new-releases",
  validate(getNewReleasesSchema),
  booksListControllers.getNewReleases,
);

bookPublicRouter.get(
  "/top-rated",
  validate(getTopRatedBooksSchema),
  booksListControllers.getTopRatedBooks,
);

bookPublicRouter.get(
  "/search",
  validate(searchBooksByNameSchema),
  searchControllers.getBooksByName,
);

bookPublicRouter.get(
  "/",
  validate(getAllBooksSchema),
  booksListControllers.getAllBooks,
);

bookPublicRouter.get(
  "/:id",
  validate(getBookByIdSchema),
  bookControllers.getBookById,
);

export default bookPublicRouter;
