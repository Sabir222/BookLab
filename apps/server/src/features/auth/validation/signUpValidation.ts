import { z } from "zod";

export const signupSchema = z.object({
  body: z.object({
    username: z
      .string({
        message: "Username is required",
      })
      .min(3, "Username must be at least 3 characters"),
    email: z
      .string({
        message: "Email is required",
      })
      .email("Please enter a valid email"),
    password: z
      .string({
        message: "Password is required",
      })
      .min(8, "Password must be at least 8 characters")
      .regex(/\d/, "Password must contain at least one number")

      .regex(/[A-Z]/, "Password must contain at least one uppercase letter")
      .regex(
        /[!@#$%^&*(),.?":{}|<>]/,
        "Password must contain at least one symbol",
      ),
  }),
});
