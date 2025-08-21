"use client";

import { useMemo } from "react";
import { useQuery } from "@tanstack/react-query";
import { BookCarousel } from "@/components/BookCarousel";
import { SimpleBook as Book } from "@/types";
import { bookApi } from "@/app/api/books/books";

export function TopRatedBooksSection() {
        const { data, isLoading } = useQuery({
                queryKey: ["top-rated-books", 8],
                queryFn: () => bookApi.getTopRatedBooks(8),
        });

        const books: Book[] = useMemo(() => {
                if (!data) return [];
                return data.map(book => {
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
        }, [data]);

        if (isLoading) {
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
