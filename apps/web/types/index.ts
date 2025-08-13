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