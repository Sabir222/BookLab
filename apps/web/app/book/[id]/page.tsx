import {
  dehydrate,
  HydrationBoundary,
  QueryClient,
} from '@tanstack/react-query';
import { bookApi } from "@/app/api/books/books";
import { BookInfo } from "@/components/books/BookInfo";
import { Reviews } from "@/components/books/Reviews";


export default async function BookDetailPage({ params }: { params: { id: string } }) {
  const { id } = await params;
  const queryClient = new QueryClient();
  console.log(id)
  await queryClient.prefetchQuery({
    queryKey: ['book', id],
    queryFn: () => bookApi.getBookById(id),
  });

  return (
    <HydrationBoundary state={dehydrate(queryClient)}>
      <div className="pt-30 min-h-screen bg-background">
        <div className="container mx-auto px-4 py-8">
          <BookInfo bookId={id} />
        </div>
        <div className="container mx-auto px-4 mt-12">
          <Reviews bookId={id} />
        </div>
      </div>
    </HydrationBoundary>
  );
}

