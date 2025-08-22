'use client'

import { useQuery } from "@tanstack/react-query"
import { bookApi } from "../api/books/books";


export default function Books({ bookId }: { bookId: string }) {
        const { data, isLoading, error } = useQuery({
                queryKey: ['books', bookId],
                queryFn: () => bookApi.getBookById(bookId),
        })
        if (isLoading) return <p>Loading...</p>;
        if (error) return <p>Something went wrong</p>;
        console.log(data)
        return (
                <ul>
                        {/* {data?.genres[0]?.genre_name} */}
                        {/* {data?.map((book) => ( */}
                        {/*         <li key={book.book_id}>{book.title}</li> */}
                        {/* ))} */}
                </ul>
        );
}
