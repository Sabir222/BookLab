import express from "express";
import { validate } from "../../auth/middlewares/validate.js";
import {
  authenticate,
  authorizeAdmin,
} from "../../auth/middlewares/authenticate.js";
import {
  getUserByIdSchema,
  updateUserProfileSchema,
  changePasswordSchema,
  deleteUserSchema,
  listUsersSchema,
  adminUpdateUserSchema,
  adminDeleteUserSchema,
} from "../validation/userValidation.js";
import {
  getCurrentUser,
  getUserById,
  updateUserProfile,
  changePassword,
  deleteUser,
  listUsers,
  adminUpdateUser,
  adminDeleteUser,
} from "../controllers/userController.js";

const userRouter = express.Router();

userRouter.get("/:id", validate(getUserByIdSchema), getUserById);

userRouter.get("/me", authenticate, getCurrentUser);
userRouter.put(
  "/me",
  authenticate,
  validate(updateUserProfileSchema),
  updateUserProfile,
);
userRouter.put(
  "/me/password",
  authenticate,
  validate(changePasswordSchema),
  changePassword,
);
userRouter.delete("/me", authenticate, validate(deleteUserSchema), deleteUser);

userRouter.get(
  "/",
  authenticate,
  authorizeAdmin,
  validate(listUsersSchema),
  listUsers,
);
userRouter.put(
  "/:id",
  authenticate,
  authorizeAdmin,
  validate(adminUpdateUserSchema),
  adminUpdateUser,
);
userRouter.delete(
  "/:id",
  authenticate,
  authorizeAdmin,
  validate(adminDeleteUserSchema),
  adminDeleteUser,
);

export default userRouter;

