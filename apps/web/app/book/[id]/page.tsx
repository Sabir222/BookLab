"use client";

import { notFound } from "next/navigation";
import { useQuery } from "@tanstack/react-query";
import { bookApi } from "@/app/api/books/books";
import { BookInfo } from "@/components/books/BookInfo";
import { Reviews } from "@/components/books/Reviews";

export default function BookDetailPage({ params }: { params: { id: string } }) {
        const { data: book, isLoading, isError } = useQuery({
                queryKey: ["book", params.id],
                queryFn: () => bookApi.getBookById(params.id),
                enabled: !!params.id,
        });

        if (isLoading) {
                return (
                        <div className="pt-30 min-h-screen bg-background">
                                <div className="container mx-auto px-4 py-8">
                                        <div className="flex flex-col md:flex-row gap-8">
                                                <div className="md:w-1/3 flex justify-center">
                                                        <div className="bg-gray-200 border-2 border-dashed rounded-xl w-full h-[450px] animate-pulse" />
                                                </div>
                                                <div className="md:w-2/3 space-y-4">
                                                        <div className="h-8 bg-gray-200 rounded w-3/4 animate-pulse" />
                                                        <div className="h-6 bg-gray-200 rounded w-1/2 animate-pulse" />
                                                        <div className="h-4 bg-gray-200 rounded w-1/4 animate-pulse" />
                                                        <div className="h-12 bg-gray-200 rounded w-1/3 animate-pulse" />
                                                        <div className="flex gap-4">
                                                                <div className="h-10 bg-gray-200 rounded w-32 animate-pulse" />
                                                                <div className="h-10 bg-gray-200 rounded w-32 animate-pulse" />
                                                        </div>
                                                </div>
                                        </div>
                                </div>
                        </div>
                );
        }

        if (isError || !book) {
                notFound();
        }

        console.log(book)

        return (
                <div className="pt-30 min-h-screen bg-background">
                        <div className="container mx-auto px-4 py-8">
                                <BookInfo book={book} />
                        </div>

                        {book.description && (
                                <div className="container mx-auto px-4 mt-12">
                                        <h2 className="text-2xl font-bold text-primary">Description</h2>
                                        <p className="mt-4 text-muted-foreground whitespace-pre-line">
                                                {book.description}
                                        </p>
                                </div>
                        )}

                        <div className="container mx-auto px-4 mt-12">
                                <Reviews book={book} />
                        </div>
                </div>
        );
}
