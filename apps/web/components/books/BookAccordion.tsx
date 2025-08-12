"use client";

import {
        Accordion,
        AccordionContent,
        AccordionItem,
        AccordionTrigger,
} from "@/components/ui/accordion";
import { BookCarousel } from "@/components/BookCarousel";

interface BookAccordionProps {
        book: {
                id: string;
                isbn: string;
                pages: number;
                publishedYear: number;
                publisher: string;
                dimensions: string;
                weight: string;
                language: string;
                relatedBooks?: Array<{
                        id: string;
                        title: string;
                        author: string;
                        price: number;
                        rating?: number;
                        reviewCount?: number;
                }>;
        };
}

export function BookAccordion({ book }: BookAccordionProps) {
        // Mock related books data with rating and reviewCount for BookCarousel
        const relatedBooks = (book.relatedBooks || [
                {
                        id: "3",
                        title: "The Catcher in the Rye",
                        author: "J.D. Salinger",
                        price: 13.99,
                        rating: 4.2,
                        reviewCount: 1200,
                },
                {
                        id: "4",
                        title: "Brave New World",
                        author: "Aldous Huxley",
                        price: 12.49,
                        rating: 4.5,
                        reviewCount: 980,
                },
                {
                        id: "5",
                        title: "The Lord of the Rings",
                        author: "J.R.R. Tolkien",
                        price: 18.99,
                        rating: 4.8,
                        reviewCount: 5600,
                },
                {
                        id: "6",
                        title: "Animal Farm",
                        author: "George Orwell",
                        price: 11.99,
                        rating: 4.3,
                        reviewCount: 2300,
                },
                {
                        id: "7",
                        title: "The Great Gatsby",
                        author: "F. Scott Fitzgerald",
                        price: 14.99,
                        rating: 4.1,
                        reviewCount: 1800,
                },
                {
                        id: "8",
                        title: "To Kill a Mockingbird",
                        author: "Harper Lee",
                        price: 15.99,
                        rating: 4.6,
                        reviewCount: 3200,
                },
                {
                        id: "9",
                        title: "1984",
                        author: "George Orwell",
                        price: 13.49,
                        rating: 4.7,
                        reviewCount: 4100,
                },
                {
                        id: "10",
                        title: "Pride and Prejudice",
                        author: "Jane Austen",
                        price: 12.99,
                        rating: 4.4,
                        reviewCount: 2700,
                },
        ]).map((book, index) => ({
                ...book,
                coverImage: `/placeholder-books/book-${(index % 5) + 1}.svg`,
        }));

        return (
                <div className="mt-12">
                        <Accordion type="multiple" className="w-full" defaultValue={["item-1", "item-2", "item-3"]}>
                                <AccordionItem value="item-1">
                                        <AccordionTrigger className="text-lg font-semibold">
                                                Product Information
                                        </AccordionTrigger>
                                        <AccordionContent className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                                <div>
                                                        <h3 className="font-medium text-primary">Details</h3>
                                                        <dl className="mt-2 space-y-2">
                                                                <div className="flex justify-between">
                                                                        <dt className="text-muted-foreground">ISBN</dt>
                                                                        <dd className="font-medium">{book.isbn}</dd>
                                                                </div>
                                                                <div className="flex justify-between">
                                                                        <dt className="text-muted-foreground">Pages</dt>
                                                                        <dd className="font-medium">{book.pages}</dd>
                                                                </div>
                                                                <div className="flex justify-between">
                                                                        <dt className="text-muted-foreground">Published</dt>
                                                                        <dd className="font-medium">{book.publishedYear}</dd>
                                                                </div>
                                                                <div className="flex justify-between">
                                                                        <dt className="text-muted-foreground">Publisher</dt>
                                                                        <dd className="font-medium">{book.publisher}</dd>
                                                                </div>
                                                        </dl>
                                                </div>
                                                <div>
                                                        <h3 className="font-medium text-primary">Physical Info</h3>
                                                        <dl className="mt-2 space-y-2">
                                                                <div className="flex justify-between">
                                                                        <dt className="text-muted-foreground">Dimensions</dt>
                                                                        <dd className="font-medium">{book.dimensions}</dd>
                                                                </div>
                                                                <div className="flex justify-between">
                                                                        <dt className="text-muted-foreground">Weight</dt>
                                                                        <dd className="font-medium">{book.weight}</dd>
                                                                </div>
                                                                <div className="flex justify-between">
                                                                        <dt className="text-muted-foreground">Language</dt>
                                                                        <dd className="font-medium">{book.language}</dd>
                                                                </div>
                                                        </dl>
                                                </div>
                                        </AccordionContent>
                                </AccordionItem>

                                <AccordionItem value="item-2">
                                        <AccordionTrigger className="text-lg font-semibold">
                                                Also by This Author
                                        </AccordionTrigger>
                                        <AccordionContent>
                                                <div className="mt-2">
                                                        <div className="container mx-auto px-4">
                                                                <BookCarousel 
                                                                  title="" 
                                                                  books={relatedBooks} 
                                                                />
                                                        </div>
                                                </div>
                                        </AccordionContent>
                                </AccordionItem>

                                <AccordionItem value="item-3">
                                        <AccordionTrigger className="text-lg font-semibold">
                                                Similar Items
                                        </AccordionTrigger>
                                        <AccordionContent>
                                                <div className="mt-2">
                                                        <div className="container mx-auto px-4">
                                                                <BookCarousel 
                                                                  title="" 
                                                                  books={relatedBooks} 
                                                                />
                                                        </div>
                                                </div>
                                        </AccordionContent>
                                </AccordionItem>
                        </Accordion>
                </div>
        );
}
