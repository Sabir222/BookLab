import express from "express";
import { validate } from "../../auth/middlewares/validate.js";
import { 
  getUserByIdSchema,
  updateUserProfileSchema,
  changePasswordSchema,
  deleteUserSchema,
  listUsersSchema,
  adminUpdateUserSchema,
  adminDeleteUserSchema
} from "../validation/userValidation.js";
import {
  getCurrentUser,
  getUserById,
  updateUserProfile,
  changePassword,
  deleteUser,
  listUsers,
  adminUpdateUser,
  adminDeleteUser
} from "../controllers/userController.js";

const userRouter = express.Router();

// Public routes
userRouter.get("/:id", validate(getUserByIdSchema), getUserById);

// Protected routes (require authentication)
userRouter.get("/me", getCurrentUser);
userRouter.put("/me", validate(updateUserProfileSchema), updateUserProfile);
userRouter.put("/me/password", validate(changePasswordSchema), changePassword);
userRouter.delete("/me", validate(deleteUserSchema), deleteUser);

// Admin routes (require admin authentication)
userRouter.get("/", validate(listUsersSchema), listUsers);
userRouter.put("/:id", validate(adminUpdateUserSchema), adminUpdateUser);
userRouter.delete("/:id", validate(adminDeleteUserSchema), adminDeleteUser);

export default userRouter;