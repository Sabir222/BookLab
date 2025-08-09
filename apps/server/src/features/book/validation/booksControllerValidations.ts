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

// Validation schema for creating a book
export const createBookSchema = z.object({
  body: z.object({
    title: z.string().min(1, "Title is required"),
    subtitle: z.string().optional(),
    description: z.string().optional(),
    isbn13: z.string().optional(),
    isbn10: z.string().optional(),
    publicationDate: z.string().optional(),
    publishedYear: z.number().optional(),
    pageCount: z.number().optional(),
    language: z.string().optional(),
    coverImageUrl: z.string().optional(),
    edition: z.string().optional(),
    bookFormat: z.enum(["hardcover", "paperback", "ebook", "audiobook", "other"]),
    bookCondition: z.string().optional(),
    dimensions: z.string().optional(),
    weightGrams: z.number().optional(),
    forSale: z.boolean(),
    forRent: z.boolean(),
    priceSale: z.number().min(0, "Price must be a positive number"),
    priceRentDaily: z.number().optional(),
    priceRentWeekly: z.number().optional(),
    priceRentMonthly: z.number().optional(),
    stockQuantity: z.number().min(0, "Stock quantity must be non-negative"),
    reservedQuantity: z.number().optional(),
    isActive: z.boolean().optional(),
    averageRating: z.number().optional(),
    totalRatings: z.number().optional(),
    totalReviews: z.number().optional(),
    publisherId: z.string().uuid().optional(),
    ownerId: z.string().uuid().optional(),
    primaryCategoryId: z.string().uuid().optional(),
    searchKeywords: z.array(z.string()).optional(),
    slug: z.string().min(1, "Slug is required"),
    createdBy: z.string().uuid().optional(),
    lastModifiedBy: z.string().uuid().optional(),
  }),
});

// Validation schema for updating a book
export const updateBookSchema = z.object({
  params: z.object({
    id: z.string().uuid("Book ID must be a valid UUID"),
  }),
  body: z.object({
    title: z.string().optional(),
    subtitle: z.string().nullable().optional(),
    description: z.string().nullable().optional(),
    isbn13: z.string().nullable().optional(),
    isbn10: z.string().nullable().optional(),
    publicationDate: z.string().nullable().optional(),
    publishedYear: z.number().nullable().optional(),
    pageCount: z.number().nullable().optional(),
    language: z.string().nullable().optional(),
    coverImageUrl: z.string().nullable().optional(),
    edition: z.string().nullable().optional(),
    bookFormat: z
      .enum(["hardcover", "paperback", "ebook", "audiobook", "other"])
      .optional(),
    bookCondition: z.string().nullable().optional(),
    dimensions: z.string().nullable().optional(),
    weightGrams: z.number().nullable().optional(),
    forSale: z.boolean().optional(),
    forRent: z.boolean().optional(),
    priceSale: z.number().min(0).optional(),
    priceRentDaily: z.number().nullable().optional(),
    priceRentWeekly: z.number().nullable().optional(),
    priceRentMonthly: z.number().nullable().optional(),
    stockQuantity: z.number().min(0).optional(),
    reservedQuantity: z.number().optional(),
    isActive: z.boolean().optional(),
    averageRating: z.number().nullable().optional(),
    totalRatings: z.number().optional(),
    totalReviews: z.number().optional(),
    publisherId: z.string().uuid().nullable().optional(),
    ownerId: z.string().uuid().nullable().optional(),
    primaryCategoryId: z.string().uuid().nullable().optional(),
    searchKeywords: z.array(z.string()).optional(),
    slug: z.string().optional(),
    lastModifiedBy: z.string().uuid().nullable().optional(),
  }),
});

// Validation schema for deleting a book
export const deleteBookSchema = z.object({
  params: z.object({
    id: z.string().uuid("Book ID must be a valid UUID"),
  }),
});

// Validation schema for soft deleting a book
export const softDeleteBookSchema = z.object({
  params: z.object({
    id: z.string().uuid("Book ID must be a valid UUID"),
  }),
  body: z.object({
    deletedBy: z.string().uuid().optional(),
  }),
});

// Validation schema for restoring a book
export const restoreBookSchema = z.object({
  params: z.object({
    id: z.string().uuid("Book ID must be a valid UUID"),
  }),
});

// Validation schema for checking if a book exists
export const bookExistsSchema = z.object({
  params: z.object({
    id: z.string().uuid("Book ID must be a valid UUID"),
  }),
});

// Validation schema for finding a book by slug
export const getBookBySlugSchema = z.object({
  params: z.object({
    slug: z.string().min(1, "Slug is required"),
  }),
});

// Validation schema for updating book stock
export const updateBookStockSchema = z.object({
  params: z.object({
    id: z.string().uuid("Book ID must be a valid UUID"),
  }),
  body: z.object({
    newStock: z.number().min(0, "Stock must be non-negative"),
    reservedQuantity: z.number().optional(),
  }),
});

// Validation schema for adding to book stock
export const addToBookStockSchema = z.object({
  params: z.object({
    id: z.string().uuid("Book ID must be a valid UUID"),
  }),
  body: z.object({
    quantity: z.number().min(1, "Quantity must be positive"),
  }),
});

// Validation schema for reserving books
export const reserveBooksSchema = z.object({
  params: z.object({
    id: z.string().uuid("Book ID must be a valid UUID"),
  }),
  body: z.object({
    quantity: z.number().min(1, "Quantity must be positive"),
  }),
});

// Validation schema for releasing reserved books
export const releaseReservedBooksSchema = z.object({
  params: z.object({
    id: z.string().uuid("Book ID must be a valid UUID"),
  }),
  body: z.object({
    quantity: z.number().min(1, "Quantity must be positive"),
  }),
});

// Validation schema for updating book ratings
export const updateBookRatingsSchema = z.object({
  params: z.object({
    id: z.string().uuid("Book ID must be a valid UUID"),
  }),
  body: z.object({
    averageRating: z.number().min(0).max(5, "Rating must be between 0 and 5"),
    totalRatings: z.number().min(0, "Total ratings must be non-negative"),
  }),
});