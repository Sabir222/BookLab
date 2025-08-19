import { User, Book } from "@repo/types/types";

export type ProfileUser = Pick<
  User,
  | "user_id"
  | "username"
  | "email"
  | "profile_image_url"
  | "credits"
  | "loyalty_points"
  | "is_verified"
  | "role"
  | "last_login"
>;

export type { Book } from "@repo/types/types";

export interface SimpleBook {
  id: string;
  title: string;
  author: string;
  coverImage?: string;
  description?: string;
  isbn?: string;
  publishedDate?: string;
  pages?: number;
  price?: number;
  rating?: number;
  reviewCount?: number;
  category?: string;
  originalPrice?: number;
}

export interface ApiResponse<T = unknown> {
  success: boolean;
  message?: string;
  data?: T;
  error?: string;
  code?: string;
  meta?: Record<string, unknown>;
}

export interface SearchResponse {
  books: (Book & { author_name?: string })[];
}
