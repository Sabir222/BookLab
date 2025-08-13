import { BookHeader } from "@/components/books/BookHeader";
import { BookAccordion } from "@/components/books/BookAccordion";

const getBookById = (id: string) => {
        const books: Record<string, any> = {
                "1": {
                        id: "1",
                        title: "The Great Gatsby",
                        author: "F. Scott Fitzgerald",
                        description: "A classic American novel set in the summer of 1922, following the story of Jay Gatsby and his obsession with the beautiful Daisy Buchanan. The novel explores themes of wealth, love, the American Dream, and the decline of social values in the 1920s.",
                        price: 12.99,
                        originalPrice: 15.99,
                        rating: 4.2,
                        pages: 180,
                        publishedYear: 1925,
                        publisher: "Scribner",
                        genre: "Classic Literature",
                        isbn: "978-0-7432-7356-5",
                        dimensions: "5.5 x 0.5 x 8.2 inches",
                        weight: "0.3 pounds",
                        language: "English",
                        coverImage: "/placeholder-book-cover.jpg",
                        inStock: true,
                        stockCount: 25,
                        format: "Paperback",
                        category: "Fiction",
                        isBestseller: true,
                        reviews: [
                                {
                                        id: "1",
                                        author: "Alice Johnson",
                                        rating: 5,
                                        comment: "A masterpiece of American literature. Fitzgerald&#39;s prose is absolutely beautiful.",
                                        date: "2023-05-15"
                                },
                                {
                                        id: "2",
                                        author: "Bob Smith",
                                        rating: 4,
                                        comment: "Great story but requires some patience to get through.",
                                        date: "2023-03-22"
                                }
                        ]
                },
                "2": {
                        id: "2",
                        title: "To Kill a Mockingbird",
                        author: "Harper Lee",
                        description: "A gripping tale of racial injustice and childhood innocence in the American South. The story follows young Scout Finch as her father, attorney Atticus Finch, defends a Black man falsely accused of rape.",
                        price: 14.99,
                        rating: 4.5,
                        pages: 376,
                        publishedYear: 1960,
                        publisher: "J.B. Lippincott & Co.",
                        genre: "Fiction",
                        isbn: "978-0-06-112008-4",
                        dimensions: "6.2 x 1.5 x 9.3 inches",
                        weight: "0.8 pounds",
                        language: "English",
                        coverImage: "/placeholder-book-cover.jpg",
                        inStock: true,
                        stockCount: 18,
                        format: "Hardcover",
                        category: "Classic Literature",
                        isAwardWinner: true,
                        reviews: []
                }
        };

        return books[id] || null;
};

export default async function BookDetailPage({ params }: { params: Promise<{ id: string }> }) {
        const { id } = await params;
        const book = getBookById(id);

        if (!book) {
                return (
                        <div className="min-h-screen bg-background">
                                <div className="container mx-auto px-4 py-8">
                                        <div className="text-center py-12">
                                                <h1 className="text-2xl font-bold text-primary">Book not found</h1>
                                                <p className="text-muted-foreground mt-2">The book you&apos;re looking for doesn&apos;t exist.</p>
                                        </div>
                                </div>
                        </div>
                );
        }

        return (
                <div className="min-h-screen bg-background">
                        <div className="container mx-auto px-4 py-8">
                                <BookHeader book={book} />
                        </div>

                        {/* About Section */}
                        <div className="container mx-auto px-4 mt-12">
                                <h2 className="text-2xl font-bold text-primary">About</h2>
                                <p className="mt-4 text-muted-foreground">
                                        {book.description}
                                </p>
                        </div>

                        {/* Accordion Sections */}
                        <div className="container mx-auto px-4">
                                <BookAccordion book={book} />
                        </div>
                </div>
        );
}
