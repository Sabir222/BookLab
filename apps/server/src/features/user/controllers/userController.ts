import type { Request, Response } from "express";
import { userQueries } from "@repo/db/postgres";
import { hashPassword, comparerPassword } from "../../../utils/hashPassword.js";
import { sendSuccess, sendError } from "../../../utils/responseHandler.js";

export const getCurrentUser = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      return sendError(res, "Unauthorized", "UNAUTHORIZED", 401);
    }

    const user = await userQueries.findById(userId);
    if (!user) {
      return sendError(res, "User not found", "USER_NOT_FOUND", 404);
    }

    const { hashed_password, ...publicUser } = user;
    return sendSuccess(res, { user: publicUser });
  } catch (error) {
    console.error("Failed to get user profile:", error);
    return sendError(res, "Failed to get user profile", "GET_USER_ERROR", 500);
  }
};

export const getUserById = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  try {
    const { id: userId } = req.params;

    const user = await userQueries.findById(userId);
    if (!user) {
      return handleError(res, 404, "User not found", "USER_NOT_FOUND");
    }

    const { hashed_password, email, ...publicUser } = user;
    return sendResponse(res, 200, {
      success: true,
      data: { user: publicUser },
    });
  } catch (error) {
    return handleError(res, 500, "Failed to get user", "GET_USER_ERROR", error);
  }
};

export const updateUserProfile = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      return handleError(res, 401, "Unauthorized", "UNAUTHORIZED");
    }

    const { username, email, profileImageUrl } = req.body;

    const updateData: any = {};
    if (username !== undefined) updateData.username = username;
    if (email !== undefined) updateData.email = email;
    if (profileImageUrl !== undefined)
      updateData.profileImageUrl = profileImageUrl;

    const user = await userQueries.update(userId, updateData);
    if (!user) {
      return handleError(res, 404, "User not found", "USER_NOT_FOUND");
    }

    const { hashed_password, ...publicUser } = user;
    return sendResponse(res, 200, {
      success: true,
      data: { user: publicUser },
    });
  } catch (error) {
    return handleError(
      res,
      500,
      "Failed to update user profile",
      "UPDATE_USER_ERROR",
      error,
    );
  }
};

export const changePassword = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      return handleError(res, 401, "Unauthorized", "UNAUTHORIZED");
    }

    const { currentPassword, newPassword } = req.body;

    const user = await userQueries.findById(userId);
    if (!user) {
      return handleError(res, 404, "User not found", "USER_NOT_FOUND");
    }

    const isPasswordValid = comparerPassword(
      currentPassword,
      user.hashed_password,
    );
    if (!isPasswordValid) {
      return handleError(
        res,
        401,
        "Current password is incorrect",
        "INVALID_PASSWORD",
      );
    }

    //NOTE: no need to await this , i already use sync while salting in hashpw fnc
    const hashedNewPassword = hashPassword(newPassword);

    const updatedUser = await userQueries.update(userId, {
      hashedPassword: hashedNewPassword,
    });

    if (!updatedUser) {
      return handleError(res, 404, "User not found", "USER_NOT_FOUND");
    }

    return sendResponse(res, 200, {
      success: true,
      message: "Password updated successfully",
    });
  } catch (error) {
    return handleError(
      res,
      500,
      "Failed to change password",
      "CHANGE_PASSWORD_ERROR",
      error,
    );
  }
};

export const deleteUser = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      return handleError(res, 401, "Unauthorized", "UNAUTHORIZED");
    }

    const { password } = req.body;
    if (!password) {
      return handleError(
        res,
        400,
        "Password is required for account deletion",
        "PASSWORD_REQUIRED",
      );
    }

    const user = await userQueries.findById(userId);
    if (!user) {
      return handleError(res, 404, "User not found", "USER_NOT_FOUND");
    }

    const isPasswordValid = comparerPassword(password, user.hashed_password);
    if (!isPasswordValid) {
      return handleError(res, 401, "Password is incorrect", "INVALID_PASSWORD");
    }

    const deleted = await userQueries.delete(userId);
    if (!deleted) {
      return handleError(res, 404, "User not found", "USER_NOT_FOUND");
    }

    return sendResponse(res, 200, {
      success: true,
      message: "Account deleted successfully",
    });
  } catch (error: any) {
    return handleError(
      res,
      500,
      "Failed to delete account",
      "DELETE_USER_ERROR",
      error,
    );
  }
};

export const listUsers = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  try {
    if (!req.user || req.user.role !== "admin") {
      return handleError(
        res,
        403,
        "Insufficient permissions",
        "INSUFFICIENT_PERMISSIONS",
      );
    }

    const { limit = 50, offset = 0, role } = req.query;
    const parsedLimit = parseInt(limit as string, 10);
    const parsedOffset = parseInt(offset as string, 10);

    // Get all users (role filtering would need to be implemented in the database layer)
    const users = await userQueries.list(parsedLimit, parsedOffset);

    // Filter by role if specified (client-side filtering since there's no DB function)
    const filteredUsers = role
      ? users.filter((user) => user.role === role)
      : users;

    const publicUsers = filteredUsers.map((user: any) => {
      const { hashed_password, ...publicUser } = user;
      return publicUser;
    });

    return sendResponse(res, 200, {
      success: true,
      data: { users: publicUsers },
      meta: {
        limit: parsedLimit,
        offset: parsedOffset,
        total: filteredUsers.length,
      },
    });
  } catch (error) {
    return handleError(
      res,
      500,
      "Failed to list users",
      "LIST_USERS_ERROR",
      error,
    );
  }
};

export const adminUpdateUser = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  try {
    // Check if user is admin
    if (!req.user || req.user.role !== "admin") {
      return handleError(
        res,
        403,
        "Insufficient permissions",
        "INSUFFICIENT_PERMISSIONS",
      );
    }

    const { id: userId } = req.params;
    const {
      username,
      email,
      profileImageUrl,
      role,
      isVerified,
      credits,
      loyaltyPoints,
    } = req.body;

    const updateData: any = {};
    if (username !== undefined) updateData.username = username;
    if (email !== undefined) updateData.email = email;
    if (profileImageUrl !== undefined)
      updateData.profileImageUrl = profileImageUrl;
    if (role !== undefined) updateData.role = role;
    if (isVerified !== undefined) updateData.isVerified = isVerified;
    if (credits !== undefined) updateData.credits = credits;
    if (loyaltyPoints !== undefined) updateData.loyaltyPoints = loyaltyPoints;

    const user = await userQueries.update(userId, updateData);
    if (!user) {
      return handleError(res, 404, "User not found", "USER_NOT_FOUND");
    }

    // Remove sensitive information
    const { hashed_password, ...publicUser } = user;
    return sendResponse(res, 200, {
      success: true,
      data: { user: publicUser },
    });
  } catch (error) {
    return handleError(
      res,
      500,
      "Failed to update user",
      "ADMIN_UPDATE_USER_ERROR",
      error,
    );
  }
};

export const adminDeleteUser = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  try {
    // Check if user is admin
    if (!req.user || req.user.role !== "admin") {
      return handleError(
        res,
        403,
        "Insufficient permissions",
        "INSUFFICIENT_PERMISSIONS",
      );
    }

    const { id: userId } = req.params;

    const deleted = await userQueries.delete(userId);
    if (!deleted) {
      return handleError(res, 404, "User not found", "USER_NOT_FOUND");
    }

    return sendResponse(res, 200, {
      success: true,
      message: "User deleted successfully",
    });
  } catch (error: any) {
    // Handle foreign key constraint violation
    if (error.code === "23503") {
      return handleError(
        res,
        409,
        "Cannot delete user with associated records (reviews, etc.)",
        "USER_HAS_ASSOCIATED_RECORDS",
      );
    }

    return handleError(
      res,
      500,
      "Failed to delete user",
      "ADMIN_DELETE_USER_ERROR",
      error,
    );
  }
};
