import { User } from "@repo/types/types";

export interface Book {
  id: string;
  title: string;
  author: string;
  coverImage: string;
  rating: number;
  reviewCount: number;
  price: number;
  originalPrice?: number;
  isFavorite?: boolean;
  category?: string;
  description?: string;
  publishedDate?: string;
  pages?: number;
  isbn?: string;
  publisher?: string;
}

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
