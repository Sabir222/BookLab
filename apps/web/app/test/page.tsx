import {
        dehydrate,
        HydrationBoundary,
        QueryClient,
} from '@tanstack/react-query'
import Books from "./books";
import { bookApi } from "../api/books/books";



export default async function Page() {
        const queryClient = new QueryClient();
        const bookId = "0b32f06d-5edf-4077-8d6e-ff38e207961a"
        await queryClient.prefetchQuery({
                queryKey: ['books', bookId],
                queryFn: () => bookApi.getBookById(bookId),
        })

        return (
                <HydrationBoundary state={dehydrate(queryClient)}>
                        <Books bookId={bookId} />
                </HydrationBoundary>
        );
}
