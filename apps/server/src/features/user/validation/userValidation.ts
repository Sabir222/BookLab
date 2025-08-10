import { z } from "zod";

// Schema for getting a user by ID
export const getUserByIdSchema = z.object({
  params: z.object({
    id: z.string().uuid("User ID must be a valid UUID"),
  }),
});

// Schema for updating user profile
export const updateUserProfileSchema = z.object({
  body: z.object({
    username: z.string().min(3, "Username must be at least 3 characters").max(30, "Username must be at most 30 characters").optional(),
    email: z.string().email("Invalid email format").optional(),
    profileImageUrl: z.string().url("Invalid URL format").optional(),
  }).refine((data) => Object.keys(data).length > 0, {
    message: "At least one field must be provided for update",
  }),
});

// Schema for changing password
export const changePasswordSchema = z.object({
  body: z.object({
    currentPassword: z.string().min(8, "Current password must be at least 8 characters"),
    newPassword: z.string().min(8, "New password must be at least 8 characters")
      .regex(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]/, 
        "Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character"),
    confirmNewPassword: z.string().min(8, "Confirm password must be at least 8 characters"),
  }).refine((data) => data.newPassword === data.confirmNewPassword, {
    message: "New password and confirm password must match",
    path: ["confirmNewPassword"],
  }),
});

// Schema for deleting user account
export const deleteUserSchema = z.object({
  body: z.object({
    password: z.string().min(8, "Password is required to delete account"),
  }),
});

// Schema for listing users (admin only)
export const listUsersSchema = z.object({
  query: z.object({
    limit: z
      .string()
      .optional()
      .transform((val) => (val ? parseInt(val, 10) : 50))
      .refine((val) => !isNaN(val) && val >= 1 && val <= 100, {
        message: "Limit must be a number between 1 and 100",
      }),
    offset: z
      .string()
      .optional()
      .transform((val) => (val ? parseInt(val, 10) : 0))
      .refine((val) => !isNaN(val) && val >= 0, {
        message: "Offset must be a non-negative number",
      }),
    role: z.string().optional(),
  }),
});

// Schema for admin updating user
export const adminUpdateUserSchema = z.object({
  params: z.object({
    id: z.string().uuid("User ID must be a valid UUID"),
  }),
  body: z.object({
    username: z.string().min(3, "Username must be at least 3 characters").max(30, "Username must be at most 30 characters").optional(),
    email: z.string().email("Invalid email format").optional(),
    profileImageUrl: z.string().url("Invalid URL format").optional(),
    role: z.enum(["user", "admin", "moderator"]).optional(),
    isVerified: z.boolean().optional(),
    credits: z.number().min(0, "Credits must be non-negative").optional(),
    loyaltyPoints: z.number().min(0, "Loyalty points must be non-negative").optional(),
  }).refine((data) => Object.keys(data).length > 0, {
    message: "At least one field must be provided for update",
  }),
});

// Schema for admin deleting user
export const adminDeleteUserSchema = z.object({
  params: z.object({
    id: z.string().uuid("User ID must be a valid UUID"),
  }),
});