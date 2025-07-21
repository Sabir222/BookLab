import express from "express";
import { validate } from "../middlewares/validate";
import { signupSchema } from "../validation/signUpValidation";
import { signUpController } from "../controllers/signupController";
import { loginSchema } from "../validation/logInValidation";
import loginController from "../controllers/loginController";

const authRouter = express.Router();

authRouter.post("/signup", validate(signupSchema), signUpController);
authRouter.get("/login", validate(loginSchema), loginController);

export { authRouter };
