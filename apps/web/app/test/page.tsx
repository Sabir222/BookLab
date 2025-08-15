import { type Book } from "@repo/types/types"
import { BookCard } from "@/components/books/BookCard";
import { Suspense } from "react";
import { getServerAuth } from "@/lib/auth";

type Books = Book[];

async function fetchBooks() {
        let books: Books = [];
        try {
                const response = await fetch("http://localhost:4000/api/books");
                if (!response.ok) {
                        throw new Error(`HTTP error ${response.status}`);
                }
                const data = await response.json();
                books = data.data.books.slice(0, 20);
                console.log("book cover", books[0]?.cover_image_large_url);
        } catch (e: unknown) {
                console.error(e);
        }
        return books;
}

function BookCardSkeleton() {
        return <BookCard isLoading={true} />;
}

function BookGridSkeleton() {
        return (
                <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4">
                        {Array.from({ length: 20 }).map((_, index) => (
                                <BookCardSkeleton key={index} />
                        ))}
                </div>
        );
}

async function BookList() {
        const authResponse = await getServerAuth();
        const books = await fetchBooks();

        const user = authResponse?.data?.user;

        return (
                <div>
                        <div className="mb-6">
                                {user ? (
                                        <p className="text-lg font-medium">
                                                Hello, {user.username || user.email}!
                                        </p>
                                ) : (
                                        <p className="text-lg">Welcome, Guest!</p>
                                )}
                        </div>

                        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4">
                                {books.map((book, index) => (
                                        <BookCard
                                                key={book.book_id || index}
                                                book={book}
                                        />
                                ))}
                        </div>
                </div>
        );
}

export default function Page() {
        return (
                <div className=" max-w-7xl mx-auto mt-12 min-h-screen p-4">
                        <Suspense fallback={<BookGridSkeleton />}>
                                <BookList />
                        </Suspense>
                </div>
        );
}
