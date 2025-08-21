'use client'

import { useQuery } from "@tanstack/react-query"
import { bookApi } from "../api/books/books";


export default function Books() {
        const { data, isLoading, error } = useQuery({
                queryKey: ['books'],
                queryFn: () => bookApi.getBooksTest(),
        })

        if (isLoading) return <p>Loading...</p>;
        if (error) return <p>Something went wrong</p>;
        return (
                <ul>
                        {data?.map((book) => (
                                <li key={book.book_id}>{book.title}</li>
                        ))}
                </ul>
        );
}
