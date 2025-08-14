import { type Book } from "@repo/types/types"
import { BookCard } from "@/components/books/BookCard";
import { Suspense } from "react";
import { Skeleton } from "@/components/ui/skeleton";

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
  } catch (e) {
    console.error(e);
  }
  return books;
}

function BookCardSkeleton() {
  return <BookCard id="" title="" author="" price={0} isLoading={true} />;
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
  const books = await fetchBooks();

  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4">
      {books.map((book, index) => (
        <BookCard
          key={book.book_id || index}
          id={book.book_id}
          title={book.title}
          author={"Messi"}
          price={56}
          rating={4}
          reviewCount={888}
          originalPrice={59}
          category={"fiction"}
          imageUrl={book.cover_image_large_url}
        />
      ))}
    </div>
  );
}

export default function Page() {
  return (
    <div className="bg-red-200 max-w-7xl mx-auto mt-12 min-h-screen p-4">
      <Suspense fallback={<BookGridSkeleton />}>
        <BookList />
      </Suspense>
    </div>
  );
}
