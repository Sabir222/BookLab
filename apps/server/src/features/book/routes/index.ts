import express from "express";
import { bookPublicActionsController } from "../controller/booksPublicActionsController.js";

const bookPublicRouter = express.Router();

// Search routes (more specific paths first)
bookPublicRouter.get("/search", bookPublicActionsController.getBooksByName);
bookPublicRouter.get(
  "/search/author",
  bookPublicActionsController.getBooksByAuthor,
);
bookPublicRouter.get(
  "/search/category",
  bookPublicActionsController.getBooksByCategory,
);
bookPublicRouter.get(
  "/search/isbn",
  bookPublicActionsController.getBooksByISBN,
);
bookPublicRouter.get(
  "/new-releases",
  bookPublicActionsController.getNewReleases,
);
bookPublicRouter.get(
  "/:id/related",
  bookPublicActionsController.getRelatedBooks,
);
bookPublicRouter.get("/filter", bookPublicActionsController.getFilteredBooks);

// General routes (less specific paths last)
bookPublicRouter.get("/", bookPublicActionsController.getAllBooksRedis);
bookPublicRouter.get("/:id", bookPublicActionsController.getBookById);

export default bookPublicRouter;
