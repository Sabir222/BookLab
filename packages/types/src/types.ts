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
  // Required fields
  bookId: string;
  title: string;
  bookFormat: "hardcover" | "paperback" | "ebook" | "audiobook" | "other";
  forRent: boolean;
  priceSale: number;
  stockQuantity: number;
  reservedQuantity: number;
  slug: string;
  // Optional fields
  isActive?: boolean;
  forSale?: boolean;
  totalRatings?: number;
  totalReviews?: number;
  createdAt?: string;
  updatedAt?: string;
  subtitle?: string | null;
  description?: string | null;
  isbn13?: string | null;
  isbn10?: string | null;
  publicationDate?: string | null;
  publishedYear?: number | null;
  pageCount?: number | null;
  language?: string | null;
  coverImageUrl?: string | null;
  coverImageSmallUrl?: string | null;
  coverImageMediumUrl?: string | null;
  coverImageLargeUrl?: string | null;
  edition?: string | null;
  bookCondition?: string | null;
  dimensions?: string | null;
  weightGrams?: number | null;
  priceRentDaily?: number | null;
  priceRentWeekly?: number | null;
  priceRentMonthly?: number | null;
  averageRating?: number | null;
  publisherId?: string | null;
  ownerId?: string | null;
  primaryCategoryId?: string | null;
  searchKeywords?: string[] | null;
  createdBy?: string | null;
  lastModifiedBy?: string | null;
  deletedAt?: string | null;
  deletedBy?: string | null;
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
