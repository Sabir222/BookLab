"use client";

import { useState } from "react";
import { BookCarousel } from "@/components/BookCarousel";
import { Book } from "@/types";

const sampleBooks: Book[] = [
  {
    id: "1",
    title: "The Midnight Library",
    author: "Matt Haig",
    coverImage: "/placeholder-books/book-1.svg",
    rating: 4.5,
    reviewCount: 1245,
    price: 12.99,
    originalPrice: 16.99,
    category: "Fiction",
  },
  {
    id: "2",
    title: "Project Hail Mary",
    author: "Andy Weir",
    coverImage: "/placeholder-books/book-2.svg",
    rating: 4.8,
    reviewCount: 2103,
    price: 14.99,
    category: "Sci-Fi",
  },
  {
    id: "3",
    title: "Klara and the Sun",
    author: "Kazuo Ishiguro",
    coverImage: "/placeholder-books/book-3.svg",
    rating: 4.2,
    reviewCount: 987,
    price: 13.99,
    originalPrice: 17.99,
    category: "Fiction",
  },
  {
    id: "4",
    title: "The Four Winds",
    author: "Kristin Hannah",
    coverImage: "/placeholder-books/book-4.svg",
    rating: 4.6,
    reviewCount: 1567,
    price: 11.99,
    category: "Historical",
  },
  {
    id: "5",
    title: "The Invisible Life of Addie LaRue",
    author: "V.E. Schwab",
    coverImage: "/placeholder-books/book-5.svg",
    rating: 4.7,
    reviewCount: 2341,
    price: 15.99,
    category: "Fantasy",
  },
  {
    id: "6",
    title: "The Last Thing He Told Me",
    author: "Laura Dave",
    coverImage: "/placeholder-books/book-1.svg",
    rating: 4.3,
    reviewCount: 1876,
    price: 13.49,
    category: "Mystery",
  },
  {
    id: "7",
    title: "The Midnight Library",
    author: "Matt Haig",
    coverImage: "/placeholder-books/book-2.svg",
    rating: 4.5,
    reviewCount: 1245,
    price: 12.99,
    originalPrice: 16.99,
    category: "Fiction",
  },
  {
    id: "8",
    title: "Project Hail Mary",
    author: "Andy Weir",
    coverImage: "/placeholder-books/book-3.svg",
    rating: 4.8,
    reviewCount: 2103,
    price: 14.99,
    category: "Sci-Fi",
  },
];

export function BestSellersSection() {
  const [favoriteBooks, setFavoriteBooks] = useState<Set<string>>(new Set());

  const handleToggleFavorite = (bookId: string) => {
    setFavoriteBooks(prev => {
      const newFavorites = new Set(prev);
      if (newFavorites.has(bookId)) {
        newFavorites.delete(bookId);
      } else {
        newFavorites.add(bookId);
      }
      return newFavorites;
    });
  };

  const bestsellers = [...sampleBooks].reverse().map(book => ({
    ...book,
    isFavorite: favoriteBooks.has(book.id)
  }));

  return (
    <BookCarousel
      title="Best Sellers"
      books={bestsellers}
      onToggleFavorite={handleToggleFavorite}
    />
  );
}
