// whislist types
export type UserWishlistItem = {
  user_id: string;
  book_id: string;
  added_at: Date;
};

export type CreateUserWishlistItemData = {
  user_id: string;
  book_id: string;
};
// Newsletters types
export type NewsletterSubscriber = {
  subscriber_id: string;
  email: string;
  is_subscribed: boolean;
  subscribed_at: Date;
  unsubscribed_at: Date | null;
  created_at: Date;
  updated_at: Date;
};

export type CreateNewsletterSubscriberData = {
  email: string;
};

export type UpdateNewsletterSubscriberData = {
  is_subscribed?: boolean;
  unsubscribed_at?: Date | null;
};
// books type
export type Book = {
  book_id: string;
  title: string;
  subtitle: string | null;
  description: string | null;
  isbn_13: string | null;
  isbn_10: string | null;
  publication_date: string | null;
  published_year: number | null;
  page_count: number | null;
  language: string | null;
  cover_image_url: string | null;
  cover_image_small_url: string | null;
  cover_image_medium_url: string | null;
  cover_image_large_url: string | null;
  edition: string | null;
  book_format: "hardcover" | "paperback" | "ebook" | "audiobook" | "other";
  book_condition: string | null;
  dimensions: string | null;
  weight_grams: number | null;
  for_sale: boolean;
  for_rent: boolean;
  price_sale: string; // Note: string, not number
  price_rent_daily: string | null;
  price_rent_weekly: string | null;
  price_rent_monthly: string | null;
  stock_quantity: number;
  reserved_quantity: number;
  is_active: boolean;
  average_rating: string | null; // Note: string, not number
  total_ratings: number;
  total_reviews: number;
  publisher_id: string | null;
  owner_id: string | null;
  primary_category_id: string | null;
  slug: string;
  search_keywords: string[];
  created_at: string;
  updated_at: string;
  created_by: string;
  last_modified_by: string;
  deleted_at: string | null;
  deleted_by: string | null;
};
// User types
export type User = {
  user_id: string;
  username: string;
  email: string;
  hashed_password: string;
  profile_image_url?: string;
  credits: number;
  loyalty_points: number;
  is_verified: boolean;
  role: string;
  last_login?: Date;
  created_at: Date;
  updated_at: Date;
};

export type CreateUserData = {
  username?: string;
  email: string;
  hashedPassword: string;
  profileImageUrl?: string;
  credits?: number;
  loyaltyPoints?: number;
  role?: string;
};

export type UpdateUserData = {
  username?: string;
  email?: string;
  hashedPassword?: string;
  profileImageUrl?: string;
  credits?: number;
  loyaltyPoints?: number;
  isVerified?: boolean;
  role?: string;
  lastLogin?: Date;
};
