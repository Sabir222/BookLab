import { z } from "zod";

export const getBookByIdSchema = z.object({
  params: z.object({
    id: z.string().uuid("Book ID must be a valid UUID"),
  }),
});

export const getAllBooksSchema = z.object({
  query: z.object({
    limit: z
      .string()
      .optional()
      .transform((val) => (val ? parseInt(val, 10) : 50))
      .refine((val) => !isNaN(val) && val >= 1 && val <= 100, {
        message: "Limit must be a number between 1 and 100",
      }),
  }),
});

export const searchBooksByNameSchema = z.object({
  query: z.object({
    q: z.string().min(1, "Search query is required"),
  }),
});

export const searchBooksByAuthorSchema = z.object({
  query: z.object({
    q: z.string().min(1, "Author search query is required"),
  }),
});

export const searchBooksByCategorySchema = z.object({
  query: z.object({
    q: z.string().min(1, "Category search query is required"),
  }),
});

export const getNewReleasesSchema = z.object({
  query: z.object({
    days: z
      .string()
      .optional()
      .transform((val) => (val ? parseInt(val, 10) : 30))
      .refine((val) => !isNaN(val) && val >= 1 && val <= 365, {
        message: "Days must be a number between 1 and 365",
      }),
    limit: z
      .string()
      .optional()
      .transform((val) => (val ? parseInt(val, 10) : 20))
      .refine((val) => !isNaN(val) && val >= 1 && val <= 100, {
        message: "Limit must be a number between 1 and 100",
      }),
  }),
});

export const searchBooksByISBNSchema = z.object({
  query: z.object({
    q: z.string().min(1, "ISBN search query is required"),
  }),
});

export const getRelatedBooksSchema = z.object({
  params: z.object({
    id: z.string().uuid("Book ID must be a valid UUID"),
  }),
});

export const filterBooksSchema = z.object({
  query: z.object({
    title: z.string().optional(),
    authorName: z.string().optional(),
    categoryName: z.string().optional(),
    minRating: z
      .string()
      .optional()
      .transform((val) => (val ? parseFloat(val) : undefined))
      .refine(
        (val) => val === undefined || (!isNaN(val) && val >= 0 && val <= 5),
        {
          message: "Minimum rating must be a number between 0 and 5",
        },
      ),
    maxPrice: z
      .string()
      .optional()
      .transform((val) => (val ? parseFloat(val) : undefined))
      .refine((val) => val === undefined || !isNaN(val), {
        message: "Maximum price must be a valid number",
      }),
    format: z.string().optional(),
    inStock: z
      .string()
      .optional()
      .transform((val) => (val ? val === "true" : undefined)),
    forSale: z
      .string()
      .optional()
      .transform((val) => (val ? val === "true" : undefined)),
    forRent: z
      .string()
      .optional()
      .transform((val) => (val ? val === "true" : undefined)),
    language: z.string().optional(),
    publisherId: z.string().optional(),
    publishedAfter: z.string().optional(),
    publishedBefore: z.string().optional(),
    limit: z
      .string()
      .optional()
      .transform((val) => (val ? parseInt(val, 10) : 20))
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
  }),
});

