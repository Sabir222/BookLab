import { z } from "zod";

export const signupSchema = z.object({
  body: z.object({
    username: z
      .string({
        error: "Username is required",
      })
      .min(3, { message: "Username must be at least 3 characters" }),
    email: z
      .string({
        error: "Email is required",
      })
      .email({ message: "Please enter a valid email" }),
    password: z
      .string({
        error: "Password is required",
      })
      .min(8, { message: "Password must be at least 8 characters" })
      .regex(/\d/, { message: "Password must contain at least one number" })
      .regex(/[A-Z]/, {
        message: "Password must contain at least one uppercase letter",
      })
      .regex(/[!@#$%^&*(),.?":{}|<>]/, {
        message: "Password must contain at least one symbol",
      }),
  }),
});

export type SignupRequest = z.infer<typeof signupSchema>;
