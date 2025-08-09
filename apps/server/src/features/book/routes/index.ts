import express from "express";
import { bookPublicActionsController } from "../controller/booksPublicActionsController.js";
import { validate } from "../middleware/validate.js";
import {
  getBookByIdSchema,
  getAllBooksSchema,
  searchBooksByNameSchema,
  searchBooksByAuthorSchema,
  searchBooksByCategorySchema,
  getNewReleasesSchema,
  searchBooksByISBNSchema,
  getRelatedBooksSchema,
  filterBooksSchema,
} from "../validation/booksControllerValidations.js";

const bookPublicRouter = express.Router();

bookPublicRouter.get(
  "/search",
  validate(searchBooksByNameSchema),
  bookPublicActionsController.getBooksByName,
);
bookPublicRouter.get(
  "/search/author",
  validate(searchBooksByAuthorSchema),
  bookPublicActionsController.getBooksByAuthor,
);
bookPublicRouter.get(
  "/search/category",
  validate(searchBooksByCategorySchema),
  bookPublicActionsController.getBooksByCategory,
);
bookPublicRouter.get(
  "/search/isbn",
  validate(searchBooksByISBNSchema),
  bookPublicActionsController.getBooksByISBN,
);
bookPublicRouter.get(
  "/new-releases",
  validate(getNewReleasesSchema),
  bookPublicActionsController.getNewReleases,
);
bookPublicRouter.get(
  "/:id/related",
  validate(getRelatedBooksSchema),
  bookPublicActionsController.getRelatedBooks,
);
bookPublicRouter.get(
  "/filter",
  validate(filterBooksSchema),
  bookPublicActionsController.getFilteredBooks,
);

bookPublicRouter.get(
  "/",
  validate(getAllBooksSchema),
  bookPublicActionsController.getAllBooksRedis,
);
bookPublicRouter.get(
  "/:id",
  validate(getBookByIdSchema),
  bookPublicActionsController.getBookById,
);

export default bookPublicRouter;
