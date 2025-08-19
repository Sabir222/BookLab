"use client";

import { useState, useEffect } from "react";
import { BookCarousel } from "@/components/BookCarousel";
import { SimpleBook as Book } from "@/types";
import { bookApi } from "@/lib/api/books";

export function TopRatedBooksSection() {
  const [books, setBooks] = useState<Book[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchTopRatedBooks = async () => {
      try {
        const topBooks = await bookApi.getTopRatedBooks(8);
        const simpleBooks: Book[] = topBooks.map(book => {
          let authorName = 'Unknown Author';
          if (book.author_name) {
            authorName = book.author_name;
          } else if (book.authors && book.authors.length > 0 && book.authors[0]) {
            const firstAuthor = book.authors[0];
            authorName = `${firstAuthor.first_name || ''} ${firstAuthor.last_name || ''}`.trim() || 'Unknown Author';
          }

          return {
            id: book.book_id,
            title: book.title,
            author: authorName,
            coverImage: book.cover_image_medium_url || '/placeholder-book.png',
            rating: book.average_rating ? Number(book.average_rating) : 0,
            reviewCount: book.total_ratings || 0,
            price: book.price_sale ? Number(book.price_sale) : 0,
            originalPrice: book.price_sale ? Number(book.price_sale) : 0,
            category: 'Unknown',
          };
        });
        setBooks(simpleBooks);
      } catch (error) {
        console.error("Failed to fetch top rated books:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchTopRatedBooks();
  }, []);

  if (loading) {
    return (
      <section className="w-full py-12 md:py-24 lg:py-32 bg-muted/10">
        <div className="container mx-auto px-4">
          <div className="animate-pulse">
            <div className="h-8 bg-gray-200 rounded w-1/4 mb-8"></div>
            <div className="flex space-x-4 overflow-hidden">
              {[...Array(4)].map((_, i) => (
                <div key={i} className="flex-shrink-0 w-48">
                  <div className="bg-gray-200 h-64 rounded"></div>
                  <div className="h-4 bg-gray-200 rounded w-3/4 mt-2"></div>
                  <div className="h-4 bg-gray-200 rounded w-1/2 mt-1"></div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>
    );
  }

  return (
    <section className="w-full py-12 md:py-24 lg:py-32 bg-muted/10">
      <div className="container mx-auto px-4">
        <BookCarousel title="Top Rated Books" books={books} />
      </div>
    </section>
  );
}
