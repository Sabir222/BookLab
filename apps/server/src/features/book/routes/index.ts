import express from "express";
import { bookPublicActionsController } from "../controller/booksPublicActionsController";

const bookPublicRouter = express.Router();

bookPublicRouter.get("/redis", bookPublicActionsController.getAllBooksRedis);
bookPublicRouter.get("/:id", bookPublicActionsController.getBookById);
bookPublicRouter.get("/", bookPublicActionsController.getAllBooks);

export default bookPublicRouter;
