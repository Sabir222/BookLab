import express from "express";
import { authenticate } from "../../auth/middlewares/authenticate.js";
import { addToWishlistController } from "../controllers/addToWishlistController.js";
import { removeFromWishlistController } from "../controllers/removeFromWishlistController.js";
import { getWishlistController } from "../controllers/getWishlistController.js";

const wishlistRouter = express.Router();

wishlistRouter.use(authenticate);

wishlistRouter.post("/add", addToWishlistController);
wishlistRouter.post("/remove", removeFromWishlistController);
wishlistRouter.get("/", getWishlistController);

export default wishlistRouter;