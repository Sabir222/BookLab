"use client";

import { useState } from "react";
import { BookCarousel } from "@/components/BookCarousel";
import { SimpleBook as Book } from "@/types";

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
    rating: 4.3,
    reviewCount: 987,
    price: 13.99,
    category: "Fiction",
  },
  {
    id: "4",
    title: "The Four Winds",
    author: "Kristin Hannah",
    coverImage: "/placeholder-books/book-4.svg",
    rating: 4.6,
    reviewCount: 1562,
    price: 15.99,
    category: "Historical Fiction",
  },
  {
    id: "5",
    title: "The Sanatorium",
    author: "Sarah Pearse",
    coverImage: "/placeholder-books/book-5.svg",
    rating: 4.1,
    reviewCount: 876,
    price: 14.49,
    category: "Mystery",
  },
  {
    id: "6",
    title: "The Push",
    author: "Ashley Audrain",
    coverImage: "/placeholder-books/book-6.svg",
    rating: 4.0,
    reviewCount: 1023,
    price: 13.49,
    category: "Psychological Thriller",
  },
  {
    id: "7",
    title: "The Invisible Life of Addie LaRue",
    author: "V.E. Schwab",
    coverImage: "/placeholder-books/book-7.svg",
    rating: 4.4,
    reviewCount: 2109,
    price: 16.99,
    category: "Fantasy",
  },
  {
    id: "8",
    title: "The Last Thing He Told Me",
    author: "Laura Dave",
    coverImage: "/placeholder-books/book-8.svg",
    rating: 4.2,
    reviewCount: 1432,
    price: 15.49,
    category: "Mystery",
  },
];

export function BestSellersSection() {
  const [books] = useState<Book[]>(sampleBooks);

  return (
    <section className="w-full py-12 md:py-24 lg:py-32 bg-muted/10">
      <div className="container mx-auto px-4">
        <BookCarousel title="Best Sellers" books={books} />
      </div>
    </section>
  );
}
