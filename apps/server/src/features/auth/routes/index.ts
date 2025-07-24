import express from "express";
import { validate } from "../middlewares/validate";
import { signupSchema } from "../validation/signUpValidation";
import { signUpController } from "../controllers/signupController";
import { loginSchema } from "../validation/logInValidation";
import meController from "../controllers/meController";
import logoutController from "../controllers/logoutController";
import refreshController from "../controllers/refreshController";
import { authRateLimits } from "../middlewares/authRateLimit";
import { loginController } from "../controllers/loginController";

const authRouter = express.Router();

authRouter.post(
  "/signup",
  authRateLimits.signup,
  validate(signupSchema),
  signUpController,
);
authRouter.post("/login", validate(loginSchema), loginController);
authRouter.get("/me", meController);
authRouter.get("/logout", logoutController);
authRouter.get("/refresh", refreshController);

export { authRouter };
