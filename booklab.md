# BookLab - Full-Stack Book Rental & Sales Platform

**A production-ready, scalable full-stack application built with modern technologies to demonstrate enterprise-level development capabilities.**

## Tech Stack

- **Frontend**: Next.js 15, TypeScript, TailwindCSS, Radix UI, shadcn/ui
- **Backend**: Express.js, TypeScript, PostgreSQL, Redis
- **Architecture**: Turborepo monorepo, Docker, JWT authentication
- **Security**: Helmet.js, CORS, Rate limiting, Session management
- **Dev Tools**: Zod validation, Vitest, ESLint, Prettier

## Backend Architecture & APIs

## Tech Stack

- **Frontend**: Next.js 15, TypeScript, TailwindCSS, Radix UI, shadcn/ui
- **Backend**: Express.js, TypeScript, PostgreSQL, Redis
- **Architecture**: Turborepo monorepo, Docker, JWT authentication
- **Security**: Helmet.js, CORS, Rate limiting, Session management
- **Dev Tools**: Zod validation, Vitest, ESLint, Prettier

## Backend Architecture & APIs

### 🔐 Advanced Authentication & Security

Secure JWT-based authentication with refresh token rotation and proper cookie handling:

```typescript
// JWT token generation with proper expiration times
import jwt from "jsonwebtoken";

export type JWTPayload = {
  id: string;
  email: string;
  username: string;
};

const generateToken = (payload: JWTPayload) => {
  const jwtSecret = process.env.JWT_SECRET!;
  const jwtRefreshSecret = process.env.JWT_REFRESH_SECRET!;

  const accessToken = jwt.sign(payload, jwtSecret, {
    expiresIn: "15m", // Short-lived access token for security
  });

  const refreshToken = jwt.sign({ id: payload.id }, jwtRefreshSecret, {
    expiresIn: "7d", // Longer refresh token with secure storage
  });

  return { accessToken, refreshToken };
};

// Secure cookie configuration for cross-site requests
const setAuthCookies = (
  res: Response,
  accessToken: string,
  refreshToken: string,
) => {
  const cookieOptions = {
    secure: true, // HTTPS only
    httpOnly: true, // Prevent XSS attacks
    sameSite: "none" as const, // Enable cross-site use for production
  };

  res.cookie(
    process.env.REFRESH_TOKEN_COOKIE_NAME || "refreshToken",
    refreshToken,
    {
      ...cookieOptions,
      maxAge: 7 * 24 * 60 * 60 * 1000, // 7 days
    },
  );

  res.cookie(
    process.env.ACCESS_TOKEN_COOKIE_NAME || "accessToken",
    accessToken,
    {
      ...cookieOptions,
      maxAge: 15 * 60 * 1000, // 15 minutes
    },
  );
};
```

### 🗄️ Scalable Database Architecture

Enterprise-grade database connection pooling with health monitoring and graceful shutdown:

```typescript
// PostgreSQL connection with optimized pooling and health checks
import { Pool } from "pg";

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: Number(process.env.DB_PORT),
  max: 20, // Connection pool size
  ssl: { rejectUnauthorized: false }, // Production SSL config
  idleTimeoutMillis: 30000, // Close idle connections
  connectionTimeoutMillis: 2000, // Connection timeout
});

export const db = {
  query: (text: string, params?: any[]) => pool.query(text, params),
  getClient: () => pool.connect(),
  end: () => pool.end(),

  // Health check with timeout protection
  async getHealthStatus(): Promise<{
    healthy: boolean;
    responseTime: number;
    error?: string;
  }> {
    const startTime = Date.now();

    try {
      const timeoutPromise = new Promise((_, reject) =>
        setTimeout(() => reject(new Error("Timeout")), 5000),
      );

      await Promise.race([pool.query("SELECT 1"), timeoutPromise]);

      return {
        healthy: true,
        responseTime: Date.now() - startTime,
      };
    } catch (error: any) {
      return {
        healthy: false,
        responseTime: Date.now() - startTime,
        error: error.message,
      };
    }
  },
};

// Graceful shutdown handling
process.on("SIGINT", async () => {
  try {
    console.log("Closing database pool...");
    await pool.end();
    console.log("Database pool closed");
    process.exit(0);
  } catch (error) {
    console.error("Error closing database pool:", error);
    process.exit(1);
  }
});
```

### 🚀 Performance & Caching

Redis integration for high-performance caching and session management:

```typescript
// Redis client with connection management and shutdown handlers
import { createRedisClient, type RedisConfig } from "./config.js";

let redisClient: ReturnType<typeof createRedisClient> | null = null;

export const connectRedis = async (config?: RedisConfig) => {
  if (redisClient) {
    return redisClient;
  }

  redisClient = createRedisClient(config);

  try {
    await redisClient.connect();
    console.log("Redis connected successfully");
    return redisClient;
  } catch (error) {
    console.error("Failed to connect to Redis:", error);
    redisClient = null;
    throw error;
  }
};

export const getRedisClient = () => {
  if (!redisClient) {
    throw new Error("Redis client not initialized. Call connectRedis() first.");
  }
  return redisClient;
};

// Proper shutdown with event listeners
export const registerRedisShutdownHandlers = () => {
  const shutdown = async (signal: string) => {
    try {
      console.log(`Received ${signal}, gracefully shutting down Redis...`);
      await disconnectRedis();
      process.exit(0);
    } catch (error) {
      console.error("Error during Redis shutdown:", error);
      process.exit(1);
    }
  };

  process.on("SIGINT", () => shutdown("SIGINT"));
  process.on("SIGTERM", () => shutdown("SIGTERM"));
};
```

### 🔍 Type Safety & Validation

Zod-based schema validation ensuring data integrity at API boundaries:

```typescript
// Comprehensive validation schemas with detailed error messages
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

// Validation middleware with proper error handling
import { ZodError, type ZodType } from "zod";

export const validate = (schema: ZodType<any>) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      await schema.parseAsync({
        body: req.body,
        query: req.query,
        params: req.params,
      });
      next();
    } catch (error) {
      if (error instanceof ZodError) {
        return sendError(res, "Validation failed", "VALIDATION_ERROR", 400);
      }
      next(error);
    }
  };
};

// Usage in routes with type safety
authRouter.post(
  "/signup",
  authRateLimits.signup,
  validate(signupSchema), // Validation middleware
  signUpController,
);
```

### 📱 Modern UI/UX with TailwindCSS & shadcn/ui

Responsive, accessible UI components with smooth interactions:

```ts
// Reusable, accessible UI components with loading states
"use client";
import Link from "next/link";
import Image from "next/image";
import { Star } from "lucide-react";
import { Button } from "@/components/ui/button";
import { WishlistButton } from "@/components/books/LikeButton";
import { Skeleton } from "@/components/ui/skeleton";
import { useState } from "react";
import { SimpleBook } from "@/types";
import { Badge } from "../ui/badge";

interface BookCardProps {
  book?: SimpleBook;
  isLoading?: boolean;
}

export function BookCard({ book, isLoading = false }: BookCardProps) {
  const [favorite, setFavorite] = useState(false);

  const handleToggleFavorite = () => {
    setFavorite((prev) => !prev);
  };

  const rating = !isLoading && book?.rating ? book.rating : 0;

  return (
    <div className="group relative rounded-lg border border-gray-200 overflow-hidden transition-all duration-300 hover:shadow-lg hover:border-gray-300 w-full max-w-[220px]">
      <div className="relative w-full">
        {isLoading ? (
          <Skeleton className="w-full aspect-[3/4] bg-gray-300" />
        ) : book?.coverImage ? (
          <Link href={`/book/${book.id}`}>
            <div className="relative w-full aspect-[3/4] overflow-hidden">
              <Image
                src={book.coverImage}
                alt={book.title}
                fill
                priority={true}
                className="object-cover hover:scale-105 transition-transform duration-300"
                onError={(e) => {
                  const target = e.target as HTMLImageElement;
                  target.src = "/placeholder-book.png";
                }}
              />
            </div>
          </Link>
        ) : (
          <div className="bg-gray-100 w-full aspect-[3/4] flex items-center justify-center border-b">
            <span className="text-4xl">📚</span>
          </div>
        )}
      </div>

      <div className="p-3 flex flex-col">
        {isLoading ? (
          // Loading skeleton states for smooth UX
          <>
            <Skeleton className="h-4 w-full bg-gray-300 mb-1" />
            <Skeleton className="h-4 w-4/5 bg-gray-300 mb-2" />
            <Skeleton className="h-3 w-3/4 bg-gray-300 mb-2" />
            <div className="flex items-center gap-1 mb-2">
              {[...Array(5)].map((_, i) => (
                <Skeleton key={i} className="h-3 w-3 rounded bg-gray-300" />
              ))}
              <Skeleton className="h-3 w-8 bg-gray-300 ml-1" />
            </div>
            <Skeleton className="h-5 w-16 bg-gray-300 mb-3" />
            <div className="flex items-center gap-2">
              <Skeleton className="flex-1 h-8 bg-gray-300" />
              <Skeleton className="h-8 w-8 rounded bg-gray-300" />
            </div>
          </>
        ) : book ? (
          // Interactive content with proper accessibility
          <>
            <h3 className="text-sm font-medium leading-tight mb-1 text-gray-900 truncate">
              <Link
                href={`/book/${book.id}`}
                className="hover:text-blue-600 hover:underline"
              >
                {book.title}
              </Link>
            </h3>

            <p className="text-xs text-gray-600 mb-2 line-clamp-1">
              {book.author}
            </p>

            {book.category && (
              <div className="flex flex-wrap gap-1 mb-2">
                <Badge className="bg-gray-100 text-blue-800 rounded-sm">
                  {book.category}
                </Badge>
              </div>
            )}

            <div className="flex items-center gap-1 mb-2">
              <div className="flex items-center">
                {[...Array(5)].map((_, i) => (
                  <Star
                    key={i}
                    className={`h-3 w-3 ${i < Math.floor(rating) ? "fill-amber-400 text-amber-400" : "fill-gray-200 text-gray-200"}`}
                  />
                ))}
              </div>
              <span className="text-xs text-gray-500 ml-1">
                {rating.toFixed(1)}
              </span>
              <span className="text-xs text-gray-400">
                ({book.reviewCount})
              </span>
            </div>

            <div className="mb-3">
              <span className="text-lg font-bold text-gray-900">
                ${book.price?.toFixed(2) || "0.00"}
              </span>
            </div>

            <div className="flex items-center gap-2">
              <Button
                className="flex-1 h-8 text-xs font-medium  hover:bg-amber-500 cursor-pointer border-amber-500 hover:border-amber-600"
                size="sm"
              >
                Add to Cart
              </Button>
              <WishlistButton
                isWishlisted={favorite}
                onClick={handleToggleFavorite}
                className="h-8 w-8 border-gray-300 hover:border-gray-400 cursor-pointer"
              />
            </div>
          </>
        ) : null}
      </div>
    </div>
  );
}
```

### 🗂️ Well-Designed APIs with Optimized Database Queries

Clean API architecture with efficient database queries using PostgreSQL:

```typescript
// API Controller with validation and error handling
import type { Request, Response } from "express";
import { bookService } from "../services/bookService.js";
import { sendSuccess, sendError } from "../../../utils/responseHandler.js";
import { ZodError } from "zod";
import { getBookByIdSchema } from "../validation/booksControllerValidations.js";

const getBookById = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { params } = getBookByIdSchema.parse({
      params: req.params,
    });
    const { id: bookId } = params;

    const book = await bookService.getBookById(bookId);
    if (!book) {
      return sendError(
        res,
        `Book '${bookId}' not found`,
        "BOOK_NOT_FOUND",
        404,
      );
    }
    return sendSuccess(res, { book });
  } catch (error) {
    console.error("Failed to get book:", error);
    if (error instanceof ZodError) {
      return sendError(res, "Validation failed", "VALIDATION_ERROR", 400);
    }
    return sendError(res, "Failed to get book", "INTERNAL_SERVER_ERROR", 500);
  }
};

// Service layer with caching integration
import { bookQueries } from "@repo/db/postgres";
import { type Book, type BookWithDetails } from "@repo/types/types";
import {
  getCache,
  setCache,
  getRedisClient,
  type RedisClientType,
} from "@repo/db/redis";

const CACHE_TTL = 60;

export const bookService = {
  async getBookById(bookId: string): Promise<Book | null> {
    return await bookQueries.findById(bookId);
  },

  async getAllBooks(limit: number): Promise<Book[]> {
    const cacheKey = `books:all:${limit}`;
    let redis: RedisClientType | null = null;

    try {
      redis = getRedisClient();
      const cached = await getCache<Book[]>(redis, cacheKey, true);
      if (cached) {
        return cached;
      }

      const books = await bookQueries.findBooks(limit);
      setCache(redis, cacheKey, books, CACHE_TTL).catch(console.warn);
      return books;
    } catch (error) {
      console.error("Failed to get books from service:", error);
      throw error;
    }
  },
};

// Efficient database query with complex joins and aggregations
import { db } from "../client.js";
import { type Book, type BookWithDetails } from "@repo/types/types";

export const bookQueries = {
  async findTopRatedBooks(
    limit = 50,
    minRating = 4.0,
  ): Promise<BookWithDetails[]> {
    const result = await db.query(
      `SELECT 
         b.*,
         -- Primary Category
         pc.category_id as primary_category_id,
         pc.category_name as primary_category_name,
         pc.description as primary_category_description,
         pc.parent_category_id as primary_category_parent_id,
         
         -- Publisher Information  
         p.publisher_id,
         p.publisher_name,
         p.description as publisher_description,
         p.founded_year,
         p.country as publisher_country,
         p.website_url as publisher_website,
         p.is_active as publisher_is_active,
         
         -- Authors aggregation
         COALESCE(
           json_agg(
             jsonb_build_object(
               'author_id', a.author_id,
               'first_name', a.first_name,
               'last_name', a.last_name,
               'role', ba.role,
               'order_index', ba.order_index
             ) ORDER BY ba.order_index
           ) FILTER (WHERE a.author_id IS NOT NULL), 
           '[]'::json
         ) as authors,
         
         -- Author names concatenated for backward compatibility
         STRING_AGG(CONCAT(COALESCE(a.first_name, ''), ' ', a.last_name), ', ' ORDER BY ba.order_index) as author_name,
         
         -- Categories aggregation
         COALESCE(
           json_agg(
             DISTINCT jsonb_build_object(
               'category_id', c.category_id,
               'category_name', c.category_name,
               'description', c.description,
               'parent_category_id', c.parent_category_id
             )
           ) FILTER (WHERE c.category_id IS NOT NULL), 
           '[]'::json
         ) as categories,
         
         -- Genres aggregation  
         COALESCE(
           json_agg(
             DISTINCT jsonb_build_object(
               'genre_id', g.genre_id,
               'genre_name', g.genre_name,
               'description', g.description,
               'parent_genre_id', g.parent_genre_id
             )
           ) FILTER (WHERE g.genre_id IS NOT NULL), 
           '[]'::json
         ) as genres
         
       FROM books b
       
       -- Primary Category join
       LEFT JOIN categories pc ON b.primary_category_id = pc.category_id
       
       -- Publisher join
       LEFT JOIN publishers p ON b.publisher_id = p.publisher_id
       
       -- Authors join
       LEFT JOIN book_authors ba ON b.book_id = ba.book_id
       LEFT JOIN authors a ON ba.author_id = a.author_id
       
       -- All Categories join
       LEFT JOIN book_categories bc ON b.book_id = bc.book_id
       LEFT JOIN categories c ON bc.category_id = c.category_id AND c.is_active = true
       
       -- Genres join
       LEFT JOIN book_genres bg ON b.book_id = bg.book_id
       LEFT JOIN genres g ON bg.genre_id = g.genre_id AND g.is_active = true
       
       WHERE b.average_rating IS NOT NULL 
         AND b.average_rating::FLOAT >= $2
         AND b.is_active = true
       GROUP BY 
         b.book_id, 
         pc.category_id, 
         pc.category_name, 
         pc.description, 
         pc.parent_category_id,
         p.publisher_id,
         p.publisher_name,
         p.description,
         p.founded_year,
         p.country,
         p.website_url,
         p.is_active
       ORDER BY b.average_rating::FLOAT DESC
       LIMIT $1`,
      [limit, minRating],
    );

    return result.rows.map((book) => {
      const primary_category = book.primary_category_id
        ? {
            category_id: book.primary_category_id,
            category_name: book.primary_category_name,
            description: book.primary_category_description,
            parent_category_id: book.primary_category_parent_id,
          }
        : undefined;

      const publisher = book.publisher_id
        ? {
            publisher_id: book.publisher_id,
            publisher_name: book.publisher_name,
            description: book.publisher_description,
            founded_year: book.founded_year,
            country: book.publisher_country,
            website_url: book.publisher_website,
            is_active: book.publisher_is_active,
          }
        : undefined;

      return {
        ...book,
        primary_category,
        publisher,
        authors: book.authors || [],
        categories: book.categories || [],
        genres: book.genres || [],
      };
    }) as BookWithDetails[];
  },

  async findById(bookId: string): Promise<BookWithDetails | null> {
    // Complex query to fetch detailed book information with multiple joins
    const result = await db.query(
      `SELECT 
         b.*,
         -- Primary Category
         pc.category_id as primary_category_id,
         pc.category_name as primary_category_name,
         pc.description as primary_category_description,
         pc.parent_category_id as primary_category_parent_id,
         
         -- Publisher Information  
         p.publisher_id,
         p.publisher_name,
         p.description as publisher_description,
         p.founded_year,
         p.country as publisher_country,
         p.website_url as publisher_website,
         p.is_active as publisher_is_active,
         
         -- Authors aggregation
         COALESCE(
           json_agg(
             jsonb_build_object(
               'author_id', a.author_id,
               'first_name', a.first_name,
               'last_name', a.last_name,
               'role', ba.role,
               'order_index', ba.order_index
             ) ORDER BY ba.order_index
           ) FILTER (WHERE a.author_id IS NOT NULL), 
           '[]'::json
         ) as authors,
         
         -- Author names concatenated for backward compatibility
         STRING_AGG(CONCAT(COALESCE(a.first_name, ''), ' ', a.last_name), ', ' ORDER BY ba.order_index) as author_name,
         
         -- Categories aggregation
         COALESCE(
           json_agg(
             DISTINCT jsonb_build_object(
               'category_id', c.category_id,
               'category_name', c.category_name,
               'description', c.description,
               'parent_category_id', c.parent_category_id
             )
           ) FILTER (WHERE c.category_id IS NOT NULL), 
           '[]'::json
         ) as categories,
         
         -- Genres aggregation  
         COALESCE(
           json_agg(
             DISTINCT jsonb_build_object(
               'genre_id', g.genre_id,
               'genre_name', g.genre_name,
               'description', g.description,
               'parent_genre_id', g.parent_genre_id
             )
           ) FILTER (WHERE g.genre_id IS NOT NULL), 
           '[]'::json
         ) as genres
         
       FROM books b
       
       -- Primary Category join
       LEFT JOIN categories pc ON b.primary_category_id = pc.category_id
       
       -- Publisher join
       LEFT JOIN publishers p ON b.publisher_id = p.publisher_id
       
       -- Authors join
       LEFT JOIN book_authors ba ON b.book_id = ba.book_id
       LEFT JOIN authors a ON ba.author_id = a.author_id
       
       -- All Categories join
       LEFT JOIN book_categories bc ON b.book_id = bc.book_id
       LEFT JOIN categories c ON bc.category_id = c.category_id AND c.is_active = true
       
       -- Genres join
       LEFT JOIN book_genres bg ON b.book_id = bg.book_id
       LEFT JOIN genres g ON bg.genre_id = g.genre_id AND g.is_active = true
       
       WHERE b.book_id = $1
       GROUP BY 
         b.book_id, 
         pc.category_id, 
         pc.category_name, 
         pc.description, 
         pc.parent_category_id,
         p.publisher_id,
         p.publisher_name,
         p.description,
         p.founded_year,
         p.country,
         p.website_url,
         p.is_active
       LIMIT 1`,
      [bookId],
    );

    if (!result.rows[0]) return null;

    const book = result.rows[0];

    const primary_category = book.primary_category_id
      ? {
          category_id: book.primary_category_id,
          category_name: book.primary_category_name,
          description: book.primary_category_description,
          parent_category_id: book.primary_category_parent_id,
        }
      : undefined;

    const publisher = book.publisher_id
      ? {
          publisher_id: book.publisher_id,
          publisher_name: book.publisher_name,
          description: book.publisher_description,
          founded_year: book.founded_year,
          country: book.publisher_country,
          website_url: book.publisher_website,
          is_active: book.publisher_is_active,
        }
      : undefined;

    return {
      ...book,
      primary_category,
      publisher,
      authors: book.authors || [],
      categories: book.categories || [],
      genres: book.genres || [],
    } as BookWithDetails;
  },

  async findBooksByName(title: string, limit = 10): Promise<BookWithDetails[]> {
    const cleanQuery = title.trim().toLowerCase();
    const queryWords = cleanQuery
      .split(/\\s+/)
      .filter((word) => word.length > 0);

    const result = await db.query(
      `\n  WITH search_input AS (\n    SELECT \n      $1::text AS original_query,\n      $3::text AS clean_query,\n      $4::text[] AS query_words\n  ),\n  scored_books AS (\n    SELECT \n      b.*,\n      -- Primary Category\n      pc.category_id as primary_category_id,\n      pc.category_name as primary_category_name,\n      pc.description as primary_category_description,\n      pc.parent_category_id as primary_category_parent_id,\n      \n      -- Publisher Information\n      p.publisher_name,\n      \n      -- Aggregations\n      COALESCE(\n        json_agg(\n          jsonb_build_object(\n            'author_id', a.author_id,\n            'first_name', a.first_name,\n            'last_name', a.last_name,\n            'role', ba.role,\n            'order_index', ba.order_index\n          ) ORDER BY ba.order_index\n        ) FILTER (WHERE a.author_id IS NOT NULL), \n        '[]'::json\n      ) as authors,\n      \n      -- Author names concatenated\n      STRING_AGG(CONCAT(COALESCE(a.first_name, ''), ' ', a.last_name), ', ' ORDER BY ba.order_index) as author_name,\n      \n      COALESCE(\n        json_agg(\n          DISTINCT jsonb_build_object(\n            'category_id', c.category_id,\n            'category_name', c.category_name,\n            'description', c.description,\n            'parent_category_id', c.parent_category_id\n          )\n        ) FILTER (WHERE c.category_id IS NOT NULL), \n        '[]'::json\n      ) as categories,\n      \n      COALESCE(\n        json_agg(\n          DISTINCT jsonb_build_object(\n            'genre_id', g.genre_id,\n            'genre_name', g.genre_name,\n            'description', g.description,\n            'parent_genre_id', g.parent_genre_id\n          )\n        ) FILTER (WHERE g.genre_id IS NOT NULL), \n        '[]'::json\n      ) as genres,\n      \n      -- Similarity scoring (your existing logic)\n      GREATEST(\n        CASE \n          WHEN LOWER(b.title) = si.clean_query THEN 1.0\n          WHEN LOWER(b.subtitle) = si.clean_query THEN 0.95\n          WHEN LOWER(COALESCE(b.title, '') || ' ' || COALESCE(b.subtitle, '')) = si.clean_query THEN 0.9\n          ELSE 0\n        END,\n        CASE \n          WHEN LOWER(b.title) LIKE si.clean_query || '%' THEN 0.85\n          WHEN LOWER(b.subtitle) LIKE si.clean_query || '%' THEN 0.8\n          ELSE 0\n        END,\n        CASE \n          WHEN LOWER(b.title) LIKE '%' || si.clean_query || '%' THEN 0.75\n          WHEN LOWER(b.subtitle) LIKE '%' || si.clean_query || '%' THEN 0.7\n          WHEN LOWER(COALESCE(b.title, '') || ' ' || COALESCE(b.subtitle, '')) LIKE '%' || si.clean_query || '%' THEN 0.65\n          ELSE 0\n        END,\n        GREATEST(\n          COALESCE(similarity(LOWER(b.title), si.clean_query), 0) * 0.8,\n          COALESCE(similarity(LOWER(b.subtitle), si.clean_query), 0) * 0.75,\n          COALESCE(similarity(LOWER(COALESCE(b.title, '') || ' ' || COALESCE(b.subtitle, '')), si.clean_query), 0) * 0.7\n        )\n      ) AS similarity_score,\n      CASE \n        WHEN LENGTH(b.title) <= 50 THEN 0.05\n        ELSE 0\n      END AS length_bonus\n      \n    FROM books b\n    \n    -- Primary Category join\n    LEFT JOIN categories pc ON b.primary_category_id = pc.category_id\n    \n    -- Publisher join\n    LEFT JOIN publishers p ON b.publisher_id = p.publisher_id\n    \n    -- Authors join\n    LEFT JOIN book_authors ba ON b.book_id = ba.book_id\n    LEFT JOIN authors a ON ba.author_id = a.author_id\n    \n    -- All Categories join\n    LEFT JOIN book_categories bc ON b.book_id = bc.book_id\n    LEFT JOIN categories c ON bc.category_id = c.category_id AND c.is_active = true\n    \n    -- Genres join\n    LEFT JOIN book_genres bg ON b.book_id = bg.book_id\n    LEFT JOIN genres g ON bg.genre_id = g.genre_id AND g.is_active = true\n    \n    CROSS JOIN search_input si\n    WHERE b.is_active = true\n      AND (\n        LOWER(b.title) LIKE '%' || si.clean_query || '%'\n        OR LOWER(b.subtitle) LIKE '%' || si.clean_query || '%'\n        OR LOWER(b.title) % si.clean_query\n        OR LOWER(b.subtitle) % si.clean_query\n        OR COALESCE(similarity(LOWER(b.title), si.clean_query), 0) > 0.2\n        OR COALESCE(similarity(LOWER(b.subtitle), si.clean_query), 0) > 0.2\n      )\n    GROUP BY \n      b.book_id, \n      si.clean_query, \n      si.query_words,\n      pc.category_id, \n      pc.category_name, \n      pc.description, \n      pc.parent_category_id,\n      p.publisher_name\n  )\n  SELECT *\n  FROM scored_books\n  WHERE (similarity_score + length_bonus) >= 0.08\n  ORDER BY \n    (similarity_score + length_bonus) DESC,\n    LENGTH(title) ASC,\n    title ASC\n  LIMIT $2\n  `,
      [title, limit, cleanQuery, queryWords],
    );

    return result.rows.map((book) => {
      const primary_category = book.primary_category_id
        ? {
            category_id: book.primary_category_id,
            category_name: book.primary_category_name,
            description: book.primary_category_description,
            parent_category_id: book.primary_category_parent_id,
          }
        : undefined;

      return {
        ...book,
        primary_category,
        authors: book.authors || [],
        categories: book.categories || [],
        genres: book.genres || [],
      };
    }) as BookWithDetails[];
  },
## Frontend Architecture & UI

### 📱 Modern UI/UX with TailwindCSS & shadcn/ui
Responsive, accessible UI components with smooth interactions:

```tsx
// Reusable, accessible UI components with loading states
"use client";
import Link from "next/link";
import Image from "next/image";
import { Star } from "lucide-react";
import { Button } from "@/components/ui/button";
import { WishlistButton } from "@/components/books/LikeButton";
import { Skeleton } from "@/components/ui/skeleton";
import { useState } from "react";
import { SimpleBook } from "@/types";
import { Badge } from "../ui/badge";

interface BookCardProps {
  book?: SimpleBook;
  isLoading?: boolean;
}

export function BookCard({ book, isLoading = false }: BookCardProps) {
  const [favorite, setFavorite] = useState(false);

  const handleToggleFavorite = () => {
    setFavorite((prev) => !prev);
  };

  const rating = !isLoading && book?.rating ? book.rating : 0;

  return (
    <div className="group relative rounded-lg border border-gray-200 overflow-hidden transition-all duration-300 hover:shadow-lg hover:border-gray-300 w-full max-w-[220px]">
      <div className="relative w-full">
        {isLoading ? (
          <Skeleton className="w-full aspect-[3/4] bg-gray-300" />
        ) : book?.coverImage ? (
          <Link href={`/book/${book.id}`}>
            <div className="relative w-full aspect-[3/4] overflow-hidden">
              <Image
                src={book.coverImage}
                alt={book.title}
                fill
                priority={true}
                className="object-cover hover:scale-105 transition-transform duration-300"
                onError={(e) => {
                  const target = e.target as HTMLImageElement;
                  target.src = "/placeholder-book.png";
                }}
              />
            </div>
          </Link>
        ) : (
          <div className="bg-gray-100 w-full aspect-[3/4] flex items-center justify-center border-b">
            <span className="text-4xl">📚</span>
          </div>
        )}
      </div>

      <div className="p-3 flex flex-col">
        {isLoading ? (
          // Loading skeleton states for smooth UX
          <>
            <Skeleton className="h-4 w-full bg-gray-300 mb-1" />
            <Skeleton className="h-4 w-4/5 bg-gray-300 mb-2" />
            <Skeleton className="h-3 w-3/4 bg-gray-300 mb-2" />
            <div className="flex items-center gap-1 mb-2">
              {[...Array(5)].map((_, i) => (
                <Skeleton key={i} className="h-3 w-3 rounded bg-gray-300" />
              ))}
              <Skeleton className="h-3 w-8 bg-gray-300 ml-1" />
            </div>
            <Skeleton className="h-5 w-16 bg-gray-300 mb-3" />
            <div className="flex items-center gap-2">
              <Skeleton className="flex-1 h-8 bg-gray-300" />
              <Skeleton className="h-8 w-8 rounded bg-gray-300" />
            </div>
          </>
        ) : book ? (
          // Interactive content with proper accessibility
          <>
            <h3 className="text-sm font-medium leading-tight mb-1 text-gray-900 truncate">
              <Link
                href={`/book/${book.id}`}
                className="hover:text-blue-600 hover:underline"
              >
                {book.title}
              </Link>
            </h3>

            <p className="text-xs text-gray-600 mb-2 line-clamp-1">
              {book.author}
            </p>

            {book.category && (
              <div className="flex flex-wrap gap-1 mb-2">
                <Badge className="bg-gray-100 text-blue-800 rounded-sm">
                  {book.category}
                </Badge>
              </div>
            )}

            <div className="flex items-center gap-1 mb-2">
              <div className="flex items-center">
                {[...Array(5)].map((_, i) => (
                  <Star
                    key={i}
                    className={`h-3 w-3 ${i < Math.floor(rating) ? "fill-amber-400 text-amber-400" : "fill-gray-200 text-gray-200"}`}
                  />
                ))}
              </div>
              <span className="text-xs text-gray-500 ml-1">
                {rating.toFixed(1)}
              </span>
              <span className="text-xs text-gray-400">
                ({book.reviewCount})
              </span>
            </div>

            <div className="mb-3">
              <span className="text-lg font-bold text-gray-900">
                ${book.price?.toFixed(2) || '0.00'}
              </span>
            </div>

            <div className="flex items-center gap-2">
              <Button
                className="flex-1 h-8 text-xs font-medium  hover:bg-amber-500 cursor-pointer border-amber-500 hover:border-amber-600"
                size="sm"
              >
                Add to Cart
              </Button>
              <WishlistButton
                isWishlisted={favorite}
                onClick={handleToggleFavorite}
                className="h-8 w-8 border-gray-300 hover:border-gray-400 cursor-pointer"
              />
            </div>
          </>
        ) : null}
      </div>
    </div>
  );
}
```

## Why This Matters to Your Project

- **Security-First**: Multi-layered protection with JWT, session management, and CORS
- **Performance Optimized**: Redis caching, database connection pooling, and optimized queries
- **Maintainable Code**: TypeScript strict mode, comprehensive Zod validation, and linting
- **Production Ready**: Docker deployment, environment management, and health monitoring
- **User-Centric Design**: Responsive UI/UX with accessibility and smooth interactions
- **Scalable Infrastructure**: PostgreSQL for data persistence and Redis for caching

## Ready for Your Next Project?

This project demonstrates my ability to deliver complex, full-stack applications with enterprise-grade architecture.
Ready to discuss how these skills can solve your business challenges?

**Contact me to discuss your next project!**