import { type Book } from "@repo/types/types"
import {
        dehydrate,
        HydrationBoundary,
        QueryClient,
} from '@tanstack/react-query'
import Books from "./books";
import { bookApi } from "../api/books/books";

type Books = Book[];


export default async function Page() {
        const queryClient = new QueryClient();
        await queryClient.prefetchQuery({
                queryKey: ['books'],
                queryFn: bookApi.getBooksTest
        })

        return (
                <HydrationBoundary state={dehydrate(queryClient)}>
                        <Books />
                </HydrationBoundary>
        );
}
