import { z } from "zod";

/**
 * Schema for validating user login data.
 * It requires a username and password, both as strings.
 * If validation fails, it provides custom error messages.
 */
export const loginSchema = z.object({
  body: z.object({
    username: z.string({
      message: "username is required!",
    }),
    password: z.string({
      message: "Password is required",
    }),
  }),
});
