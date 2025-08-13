export type UserWishlistItem = {
  user_id: string;
  book_id: string;
  added_at: Date;
};

export type CreateUserWishlistItemData = {
  user_id: string;
  book_id: string;
};