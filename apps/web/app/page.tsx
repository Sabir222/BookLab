import { Navbar } from "@/components/navbar/Navbar";
import { BookCard } from "@/components/books/BookCard";

export default function Home() {
  // Mock books data for homepage
  const books = [
    {
      id: "1",
      title: "The Great Gatsby",
      author: "F. Scott Fitzgerald",
      price: 12.99,
    },
    {
      id: "2",
      title: "To Kill a Mockingbird",
      author: "Harper Lee",
      price: 14.99,
    },
    {
      id: "3",
      title: "1984",
      author: "George Orwell",
      price: 13.99,
    },
    {
      id: "4",
      title: "Pride and Prejudice",
      author: "Jane Austen",
      price: 11.99,
    },
  ];

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <div className="pt-20">
        <div className="mx-auto max-w-6xl transition-all duration-300 px-6 lg:px-12 py-8">
          <h1 className="text-3xl font-bold text-primary mb-8">Featured Books</h1>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            {books.map((book) => (
              <BookCard
                key={book.id}
                id={book.id}
                title={book.title}
                author={book.author}
                price={book.price}
              />
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
