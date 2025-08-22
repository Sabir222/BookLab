import express from "express";
import { booksController } from "../controller/booksController.js";
import { validate } from "../middleware/validate.js";
import { authenticate } from "../../auth/middlewares/authenticate.js";
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

bookPublicRouter.get(
  "/search",
  validate(searchBooksByNameSchema),
  booksController.getBooksByName,
);
bookPublicRouter.get(
  "/search/author",
  validate(searchBooksByAuthorSchema),
  booksController.getBooksByAuthor,
);
bookPublicRouter.get(
  "/search/category",
  validate(searchBooksByCategorySchema),
  booksController.getBooksByCategory,
);
bookPublicRouter.get(
  "/search/isbn",
  validate(searchBooksByISBNSchema),
  booksController.getBooksByISBN,
);
bookPublicRouter.get(
  "/new-releases",
  validate(getNewReleasesSchema),
  booksController.getNewReleases,
);

bookPublicRouter.get("/top-rated", booksController.getTopRatedBooks);
bookPublicRouter.get(
  "/:id/related",
  validate(getRelatedBooksSchema),
  booksController.getRelatedBooks,
);
bookPublicRouter.get(
  "/filter",
  validate(filterBooksSchema),
  booksController.getFilteredBooks,
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

bookPublicRouter.post(
  "/",
  authenticate,
  validate(createBookSchema),
  booksController.createBook,
);
bookPublicRouter.put(
  "/:id",
  authenticate,
  validate(updateBookSchema),
  booksController.updateBook,
);
bookPublicRouter.delete(
  "/:id",
  authenticate,
  validate(deleteBookSchema),
  booksController.deleteBook,
);
bookPublicRouter.patch(
  "/:id/soft-delete",
  authenticate,
  validate(softDeleteBookSchema),
  booksController.softDeleteBook,
);
bookPublicRouter.patch(
  "/:id/restore",
  authenticate,
  validate(restoreBookSchema),
  booksController.restoreBook,
);
bookPublicRouter.get(
  "/:id/exists",
  validate(bookExistsSchema),
  booksController.bookExists,
);
bookPublicRouter.get(
  "/slug/:slug",
  validate(getBookBySlugSchema),
  booksController.getBookBySlug,
);
bookPublicRouter.patch(
  "/:id/stock",
  authenticate,
  validate(updateBookStockSchema),
  booksController.updateBookStock,
);
bookPublicRouter.patch(
  "/:id/stock/add",
  authenticate,
  validate(addToBookStockSchema),
  booksController.addToBookStock,
);
bookPublicRouter.patch(
  "/:id/stock/reserve",
  authenticate,
  validate(reserveBooksSchema),
  booksController.reserveBooks,
);
bookPublicRouter.patch(
  "/:id/stock/release",
  authenticate,
  validate(releaseReservedBooksSchema),
  booksController.releaseReservedBooks,
);
bookPublicRouter.patch(
  "/:id/ratings",
  authenticate,
  validate(updateBookRatingsSchema),
  booksController.updateBookRatings,
);

export default bookPublicRouter;
