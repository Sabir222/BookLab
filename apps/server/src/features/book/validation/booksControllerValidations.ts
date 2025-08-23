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

export const searchBooksByAuthorSchema = z.object({
  query: z.object({
    q: z.string().min(1, { message: "Author search query is required" }),
  }),
});

export const searchBooksByCategorySchema = z.object({
  query: z.object({
    q: z.string().min(1, { message: "Category search query is required" }),
  }),
});

export const getNewReleasesSchema = z.object({
  query: z.object({
    days: z.coerce.number().min(1).max(365).default(30).optional(),
    limit: z.coerce.number().min(1).max(100).default(20).optional(),
  }),
});

export const searchBooksByISBNSchema = z.object({
  query: z.object({
    q: z.string().min(1, { message: "ISBN search query is required" }),
  }),
});

export const getRelatedBooksSchema = z.object({
  params: z.object({
    id: z.uuid(),
  }),
});

export const filterBooksSchema = z.object({
  query: z.object({
    title: z.string().optional(),
    authorName: z.string().optional(),
    categoryName: z.string().optional(),
    minRating: z.coerce.number().min(0).max(5).optional(),
    maxPrice: z.coerce.number().min(0).optional(),
    format: z.string().optional(),
    inStock: z
      .enum(["true", "false"])
      .transform((val) => val === "true")
      .optional(),
    forSale: z
      .enum(["true", "false"])
      .transform((val) => val === "true")
      .optional(),
    forRent: z
      .enum(["true", "false"])
      .transform((val) => val === "true")
      .optional(),
    language: z.string().optional(),
    publisherId: z.string().optional(),
    publishedAfter: z.string().optional(),
    publishedBefore: z.string().optional(),
    limit: z.coerce.number().min(1).max(100).default(20).optional(),
    offset: z.coerce.number().min(0).default(0).optional(),
  }),
});

export const createBookSchema = z.object({
  body: z.object({
    title: z.string().min(1, { message: "Title is required" }),
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
    bookFormat: z.enum([
      "hardcover",
      "paperback",
      "ebook",
      "audiobook",
      "magazine",
      "journal",
    ]),
    bookCondition: z.string().optional(),
    dimensions: z.string().optional(),
    weightGrams: z.number().optional(),
    forSale: z.boolean(),
    forRent: z.boolean(),
    priceSale: z
      .number()
      .min(0, { message: "Price must be a positive number" }),
    priceRentDaily: z.number().optional(),
    priceRentWeekly: z.number().optional(),
    priceRentMonthly: z.number().optional(),
    stockQuantity: z
      .number()
      .min(0, { message: "Stock quantity must be non-negative" }),
    reservedQuantity: z.number().optional(),
    isActive: z.boolean().optional(),
    averageRating: z.number().optional(),
    totalRatings: z.number().optional(),
    totalReviews: z.number().optional(),
    publisherId: z.uuid().optional(),
    ownerId: z.uuid().optional(),
    primaryCategoryId: z.uuid().optional(),
    searchKeywords: z.array(z.string()).optional(),
    slug: z.string().min(1, { message: "Slug is required" }),
    createdBy: z.uuid().optional(),
    lastModifiedBy: z.uuid().optional(),
  }),
});

export const updateBookSchema = z.object({
  params: z.object({
    id: z.uuid(),
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
      .enum([
        "hardcover",
        "paperback",
        "ebook",
        "audiobook",
        "magazine",
        "journal",
      ])
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
    publisherId: z.uuid().nullable().optional(),
    ownerId: z.uuid().nullable().optional(),
    primaryCategoryId: z.uuid().nullable().optional(),
    searchKeywords: z.array(z.string()).optional(),
    slug: z.string().optional(),
    lastModifiedBy: z.uuid().nullable().optional(),
  }),
});

export const deleteBookSchema = z.object({
  params: z.object({
    id: z.uuid(),
  }),
});

export const softDeleteBookSchema = z.object({
  params: z.object({
    id: z.uuid(),
  }),
  body: z.object({
    deletedBy: z.uuid().optional(),
  }),
});

export const restoreBookSchema = z.object({
  params: z.object({
    id: z.uuid(),
  }),
});

export const bookExistsSchema = z.object({
  params: z.object({
    id: z.uuid(),
  }),
});

export const getBookBySlugSchema = z.object({
  params: z.object({
    slug: z.string().min(1, { message: "Slug is required" }),
  }),
});

export const updateBookStockSchema = z.object({
  params: z.object({
    id: z.uuid(),
  }),
  body: z.object({
    newStock: z.number().min(0, { message: "Stock must be non-negative" }),
    reservedQuantity: z.number().optional(),
  }),
});

export const addToBookStockSchema = z.object({
  params: z.object({
    id: z.uuid(),
  }),
  body: z.object({
    quantity: z.number().min(1, { message: "Quantity must be positive" }),
  }),
});

export const reserveBooksSchema = z.object({
  params: z.object({
    id: z.uuid(),
  }),
  body: z.object({
    quantity: z.number().min(1, { message: "Quantity must be positive" }),
  }),
});

export const releaseReservedBooksSchema = z.object({
  params: z.object({
    id: z.uuid(),
  }),
  body: z.object({
    quantity: z.number().min(1, { message: "Quantity must be positive" }),
  }),
});

export const updateBookRatingsSchema = z.object({
  params: z.object({
    id: z.uuid(),
  }),
  body: z.object({
    averageRating: z
      .number()
      .min(0)
      .max(5, { message: "Rating must be between 0 and 5" }),
    totalRatings: z
      .number()
      .min(0, { message: "Total ratings must be non-negative" }),
  }),
});

export const getTopRatedBooksSchema = z.object({
  query: z.object({
    limit: z.coerce.number().min(1).max(100).default(50).optional(),
    minRating: z.coerce.number().min(0).max(5).default(4.0).optional(),
  }),
});

export type GetBookByIdRequest = z.infer<typeof getBookByIdSchema>;
export type GetAllBooksRequest = z.infer<typeof getAllBooksSchema>;
export type SearchBooksByNameRequest = z.infer<typeof searchBooksByNameSchema>;
export type SearchBooksByAuthorRequest = z.infer<
  typeof searchBooksByAuthorSchema
>;
export type SearchBooksByCategoryRequest = z.infer<
  typeof searchBooksByCategorySchema
>;
export type GetNewReleasesRequest = z.infer<typeof getNewReleasesSchema>;
export type SearchBooksByISBNRequest = z.infer<typeof searchBooksByISBNSchema>;
export type GetRelatedBooksRequest = z.infer<typeof getRelatedBooksSchema>;
export type FilterBooksRequest = z.infer<typeof filterBooksSchema>;
export type CreateBookRequest = z.infer<typeof createBookSchema>;
export type UpdateBookRequest = z.infer<typeof updateBookSchema>;
export type DeleteBookRequest = z.infer<typeof deleteBookSchema>;
export type SoftDeleteBookRequest = z.infer<typeof softDeleteBookSchema>;
export type RestoreBookRequest = z.infer<typeof restoreBookSchema>;
export type BookExistsRequest = z.infer<typeof bookExistsSchema>;
export type GetBookBySlugRequest = z.infer<typeof getBookBySlugSchema>;
export type UpdateBookStockRequest = z.infer<typeof updateBookStockSchema>;
export type AddToBookStockRequest = z.infer<typeof addToBookStockSchema>;
export type ReserveBooksRequest = z.infer<typeof reserveBooksSchema>;
export type ReleaseReservedBooksRequest = z.infer<
  typeof releaseReservedBooksSchema
>;
export type UpdateBookRatingsRequest = z.infer<typeof updateBookRatingsSchema>;
export type GetTopRatedBooksRequest = z.infer<typeof getTopRatedBooksSchema>;
