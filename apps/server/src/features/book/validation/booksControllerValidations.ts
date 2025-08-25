import { z } from "zod";

export const getBookByIdSchema = z.object({
  params: z.object({
    id: z.uuid(),
  }),
});

export const getAllBooksSchema = z.object({
  query: z.object({
    limit: z.coerce.number().min(1).max(100).default(50).optional(),
  }),
});

export const searchBooksByNameSchema = z.object({
  query: z.object({
    q: z.string().min(1, { message: "Search query is required" }),
  }),
});

export const getTopRatedBooksSchema = z.object({
  query: z.object({
    limit: z.coerce.number().min(1).max(100).default(50).optional(),
    minRating: z.coerce.number().min(0).max(5).default(4.0).optional(),
  }),
});

export const getNewReleasesSchema = z.object({
  query: z.object({
    limit: z.coerce.number().min(1).max(100).default(50).optional(),
    daysRange: z.coerce.number().min(1).max(365).default(365).optional(),
  }),
});

export type GetBookByIdRequest = z.infer<typeof getBookByIdSchema>;
export type GetAllBooksRequest = z.infer<typeof getAllBooksSchema>;
export type SearchBooksByNameRequest = z.infer<typeof searchBooksByNameSchema>;
export type GetTopRatedBooksRequest = z.infer<typeof getTopRatedBooksSchema>;
export type GetNewReleasesRequest = z.infer<typeof getNewReleasesSchema>;
