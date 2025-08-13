import express from "express";
import { subscribeController } from "../controllers/subscribeController.js";
import { unsubscribeController } from "../controllers/unsubscribeController.js";

const newsletterRouter = express.Router();

newsletterRouter.post("/subscribe", subscribeController);
newsletterRouter.post("/unsubscribe", unsubscribeController);

export default newsletterRouter;