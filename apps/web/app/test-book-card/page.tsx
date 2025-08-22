"use client";
import { BookCard } from "@/components/books/BookCard";

export default function TestBookCardPage() {
  const testBook = {
    book_id: "test-1",
    title: "The Great Gatsby",
    author_name: "F. Scott Fitzgerald",
    categories: [{ category_id: "1", category_name: "Fiction" }],
    genres: [{ genre_id: "1", genre_name: "Classic" }],
    average_rating: "4.5",
    total_ratings: 120,
    price_sale: "12.99",
    cover_image_large_url: ""
  };

  return (
    <div className="container mx-auto p-4">
      <h1 className="text-2xl font-bold mb-4">Test Book Card</h1>
      <div className="flex justify-center">
        <BookCard book={testBook} />
      </div>
    </div>
  );
}