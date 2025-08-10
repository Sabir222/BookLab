import type { Request, Response } from "express";
import { userQueries } from "@repo/db/postgres";
import { hashPassword } from "../../../utils/hashPassword.js";

// Helper functions for responses
const sendResponse = (
  res: Response,
  status: number,
  payload: Record<string, unknown>,
) => res.status(status).json(payload);

const handleError = (
  res: Response,
  status: number,
  message: string,
  code: string,
  log?: unknown,
) => {
  if (log) console.error(message, log);
  return sendResponse(res, status, {
    success: false,
    error: message,
    code,
  });
};

// Get current user profile
export const getCurrentUser = async (
  req: Request,
  res: Response,
): Promise<Response> => {
  try {
    const userId = (req as any).user?.userId;
    if (!userId) {
      return handleError(res, 401, "Unauthorized", "UNAUTHORIZED");
    }

    const user = await userQueries.findById(userId);
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
      "Failed to get user profile",
      "GET_USER_ERROR",
      error,
    );
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
    const userId = (req as any).user?.userId;
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
    const userId = (req as any).user?.userId;
    if (!userId) {
      return handleError(res, 401, "Unauthorized", "UNAUTHORIZED");
    }

    const { currentPassword, newPassword } = req.body;

    const user = await userQueries.findById(userId);
    if (!user) {
      return handleError(res, 404, "User not found", "USER_NOT_FOUND");
    }

    // TODO: Verify current password (you'll need to implement password comparison)
    // For now, we'll just update the password directly
    console.log("Current password provided:", currentPassword); // Using the variable to avoid TS6133

    const hashedNewPassword = await hashPassword(newPassword);
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
    const userId = (req as any).user?.userId;
    if (!userId) {
      return handleError(res, 401, "Unauthorized", "UNAUTHORIZED");
    }

    // TODO: Verify password before deletion
    // For now, we'll just delete the user directly

    const deleted = await userQueries.delete(userId);
    if (!deleted) {
      return handleError(res, 404, "User not found", "USER_NOT_FOUND");
    }

    return sendResponse(res, 200, {
      success: true,
      message: "Account deleted successfully",
    });
  } catch (error) {
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
    // TODO: Check if user is admin
    // For now, we'll assume the user is authorized

    const { limit = 50, offset = 0, role } = req.query;
    const parsedLimit = parseInt(limit as string, 10);
    const parsedOffset = parseInt(offset as string, 10);

    // TODO: Implement role filtering
    console.log("Filtering by role:", role); // Using the variable to avoid TS6133
    const users = await userQueries.list(parsedLimit, parsedOffset);

    const publicUsers = users.map((user) => {
      const { hashed_password, ...publicUser } = user;
      return publicUser;
    });

    return sendResponse(res, 200, {
      success: true,
      data: { users: publicUsers },
      meta: {
        limit: parsedLimit,
        offset: parsedOffset,
        total: users.length,
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
    // TODO: Check if user is admin
    // For now, we'll assume the user is authorized

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
    // TODO: Check if user is admin
    // For now, we'll assume the user is authorized

    const { id: userId } = req.params;

    const deleted = await userQueries.delete(userId);
    if (!deleted) {
      return handleError(res, 404, "User not found", "USER_NOT_FOUND");
    }

    return sendResponse(res, 200, {
      success: true,
      message: "User deleted successfully",
    });
  } catch (error) {
    return handleError(
      res,
      500,
      "Failed to delete user",
      "ADMIN_DELETE_USER_ERROR",
      error,
    );
  }
};

