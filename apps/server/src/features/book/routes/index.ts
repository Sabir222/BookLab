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
  createBookSchema,
  updateBookSchema,
  deleteBookSchema,
  softDeleteBookSchema,
  restoreBookSchema,
  bookExistsSchema,
  getBookBySlugSchema,
  updateBookStockSchema,
  addToBookStockSchema,
  reserveBooksSchema,
  releaseReservedBooksSchema,
  updateBookRatingsSchema,
} from "../validation/booksControllerValidations.js";

const bookPublicRouter = express.Router();

// Search routes (more specific paths first)
bookPublicRouter.get("/search", validate(searchBooksByNameSchema), bookPublicActionsController.getBooksByName);
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
bookPublicRouter.get("/filter", validate(filterBooksSchema), bookPublicActionsController.getFilteredBooks);

// General routes (less specific paths last)
bookPublicRouter.get("/", validate(getAllBooksSchema), bookPublicActionsController.getAllBooks);
bookPublicRouter.get("/:id", validate(getBookByIdSchema), bookPublicActionsController.getBookById);

// New book management routes
bookPublicRouter.post("/", validate(createBookSchema), bookPublicActionsController.createBook);
bookPublicRouter.put("/:id", validate(updateBookSchema), bookPublicActionsController.updateBook);
bookPublicRouter.delete("/:id", validate(deleteBookSchema), bookPublicActionsController.deleteBook);
bookPublicRouter.patch("/:id/soft-delete", validate(softDeleteBookSchema), bookPublicActionsController.softDeleteBook);
bookPublicRouter.patch("/:id/restore", validate(restoreBookSchema), bookPublicActionsController.restoreBook);
bookPublicRouter.get("/:id/exists", validate(bookExistsSchema), bookPublicActionsController.bookExists);
bookPublicRouter.get("/slug/:slug", validate(getBookBySlugSchema), bookPublicActionsController.getBookBySlug);
bookPublicRouter.patch("/:id/stock", validate(updateBookStockSchema), bookPublicActionsController.updateBookStock);
bookPublicRouter.patch("/:id/stock/add", validate(addToBookStockSchema), bookPublicActionsController.addToBookStock);
bookPublicRouter.patch("/:id/stock/reserve", validate(reserveBooksSchema), bookPublicActionsController.reserveBooks);
bookPublicRouter.patch("/:id/stock/release", validate(releaseReservedBooksSchema), bookPublicActionsController.releaseReservedBooks);
bookPublicRouter.patch("/:id/ratings", validate(updateBookRatingsSchema), bookPublicActionsController.updateBookRatings);

export default bookPublicRouter;