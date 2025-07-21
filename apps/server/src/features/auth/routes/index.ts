import express, { type Response, type Request } from "express";
import { validate } from "../middlewares/validate";
import { signupSchema } from "../validation/signUpValidation";
import { signUpController } from "../controllers/signupController";

const authRouter = express.Router();

authRouter.post("/signup", validate(signupSchema), signUpController);

export { authRouter };
