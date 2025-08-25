"use client";

import { useMemo } from "react";
import { useQuery } from "@tanstack/react-query";
import { BookCarousel } from "@/components/BookCarousel";
import { SimpleBook } from "@/types";
import { bookApi } from "@/app/api/books/books";

export function NewReleasesBooksSection() {
        const { data, isLoading } = useQuery({
                queryKey: ["new-releases-books", 8],
                queryFn: () => bookApi.getNewReleases(8),
        });

        const books: SimpleBook[] = useMemo(() => {
                if (!data) return [];
                return data.map(book => {

                        const authors: string[] = [];
                        book.authors?.map(author => {
                                if (authors.includes(author.first_name + " " + author.last_name)) {
                                        return;
                                }
                                authors.push(author.first_name + " " + author.last_name);

                        })
                        let authorName = "Unknown Author"

                        if (authors.length === 1) {
                                authorName = `${authors[0]}`
                        } else if (authors.length === 2) {
                                authorName = `${authors[0]} & ${authors[1]}`
                        } else if (authors.length > 2) {
                                authorName = `${authors[0]},${authors[1]} & ${authors.length - 2} more`
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
                                category: book.primary_category?.category_name,
                        };
                });
        }, [data]);

        return (
                <section className="w-full py-6 bg-muted/10">
                        <div className="container mx-auto px-4">
                                <BookCarousel title="New Releases" books={books} isLoading={isLoading} />
                        </div>
                </section>
        );
}