import { z } from "zod";

export const getUserByIdSchema = z.object({
  params: z.object({
    id: z.uuid(),
  }),
});

export const updateUserProfileSchema = z.object({
  body: z
    .object({
      username: z
        .string()
        .min(3, { message: "Username must be at least 3 characters" })
        .max(30, { message: "Username must be at most 30 characters" })
        .optional(),
      email: z.email(),
      profileImageUrl: z.url(),
    })
    .refine((data) => Object.keys(data).length > 0, {
      message: "At least one field must be provided for update",
    }),
});

export const changePasswordSchema = z.object({
  body: z
    .object({
      currentPassword: z
        .string()
        .min(8, { message: "Current password must be at least 8 characters" }),
      newPassword: z
        .string()
        .min(8, { message: "New password must be at least 8 characters" })
        .regex(
          /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]/,
          "Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character",
        ),
      confirmNewPassword: z
        .string()
        .min(8, { message: "Confirm password must be at least 8 characters" }),
    })
    .refine((data) => data.newPassword === data.confirmNewPassword, {
      message: "New password and confirm password must match",
      path: ["confirmNewPassword"],
    }),
});

export const deleteUserSchema = z.object({
  body: z.object({
    password: z
      .string()
      .min(8, { message: "Password is required to delete account" }),
  }),
});

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

export const adminUpdateUserSchema = z.object({
  params: z.object({
    id: z.uuid(),
  }),
  body: z
    .object({
      username: z
        .string()
        .min(3, { message: "Username must be at least 3 characters" })
        .max(30, { message: "Username must be at most 30 characters" })
        .optional(),
      email: z.email(),
      profileImageUrl: z.url(),
      role: z.enum(["user", "admin", "moderator"]).optional(),
      isVerified: z.boolean().optional(),
      credits: z
        .number()
        .min(0, { message: "Credits must be non-negative" })
        .optional(),
      loyaltyPoints: z
        .number()
        .min(0, { message: "Loyalty points must be non-negative" })
        .optional(),
    })
    .refine((data) => Object.keys(data).length > 0, {
      message: "At least one field must be provided for update",
    }),
});

export const adminDeleteUserSchema = z.object({
  params: z.object({
    id: z.uuid(),
  }),
});
