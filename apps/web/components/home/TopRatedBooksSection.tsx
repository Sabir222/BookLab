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
                                coverImage: book.cover_image_large_url || '/placeholder-book.png',
                                rating: book.average_rating ? Number(book.average_rating) : 0,
                                reviewCount: book.total_ratings || 0,
                                price: book.price_sale ? Number(book.price_sale) : 0,
                                originalPrice: book.price_sale ? Number(book.price_sale) : 0,
                                category: 'Unknown',
                        };
                });
        }, [data]);

        return (
                <section className="w-full py-12 md:py-24 lg:py-32 bg-muted/10">
                        <div className="container mx-auto px-4">
                                <BookCarousel title="Top Rated Books" books={books} isLoading={isLoading} />
                        </div>
                </section>
        );
}
