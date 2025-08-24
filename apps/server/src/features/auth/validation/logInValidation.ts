import { z } from "zod";

export const loginSchema = z.object({
  body: z.object({
    username: z
      .string({
        error: "Username is required",
      })
      .min(3, { message: "Username must be at least 3 characters" }),
    password: z
      .string({
        error: "Password is required",
      })
      .min(8, { message: "Password must be at least 8 characters" }),
  }),
});

export type LoginRequest = z.infer<typeof loginSchema>;
