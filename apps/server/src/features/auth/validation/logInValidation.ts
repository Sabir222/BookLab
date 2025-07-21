import { z } from "zod";

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
