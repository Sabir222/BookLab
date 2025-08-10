import express from "express";
import { validate } from "../middlewares/validate.js";
import { signupSchema } from "../validation/signUpValidation.js";
import { signUpController } from "../controllers/signupController.js";
import { loginSchema } from "../validation/logInValidation.js";
import meController from "../controllers/meController.js";
import logoutController from "../controllers/logoutController.js";
import refreshController from "../controllers/refreshController.js";
import { authRateLimits } from "../middlewares/authRateLimit.js";
import { loginController } from "../controllers/loginController.js";
import { authenticate } from "../middlewares/authenticate.js";

const authRouter = express.Router();

authRouter.post(
  "/signup",
  authRateLimits.signup,
  validate(signupSchema),
  signUpController,
);
authRouter.post("/login", validate(loginSchema), loginController);
authRouter.get("/me", authenticate, meController);
authRouter.get("/logout", authenticate, logoutController);
authRouter.get("/refresh", authenticate, refreshController);

export default authRouter;
