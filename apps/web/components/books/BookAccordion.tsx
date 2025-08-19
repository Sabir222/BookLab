// @ts-nocheck
"use client";

import { Accordion, AccordionContent, AccordionItem, AccordionTrigger } from "@/components/ui/accordion";
import { Book } from "@repo/types/types";

interface BookAccordionProps {
  book: Book;
}

export function BookAccordion({ book }: BookAccordionProps) {
  return (
    <Accordion type="single" collapsible className="w-full mt-6">
      <AccordionItem value="item-1">
        <AccordionTrigger>Product Details</AccordionTrigger>
        <AccordionContent>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <h4 className="font-semibold">Publisher</h4>
              <p className="text-muted-foreground">Unknown Publisher</p>
            </div>
            <div>
              <h4 className="font-semibold">Publication Date</h4>
              <p className="text-muted-foreground">
                {book.publication_date ? new Date(book.publication_date).toLocaleDateString() : "Unknown"}
              </p>
            </div>
            <div>
              <h4 className="font-semibold">Pages</h4>
              <p className="text-muted-foreground">{book.page_count || "Unknown"}</p>
            </div>
            <div>
              <h4 className="font-semibold">Language</h4>
              <p className="text-muted-foreground capitalize">{book.language || "Unknown"}</p>
            </div>
            <div>
              <h4 className="font-semibold">ISBN-13</h4>
              <p className="text-muted-foreground">{book.isbn_13 || "Not available"}</p>
            </div>
            <div>
              <h4 className="font-semibold">ISBN-10</h4>
              <p className="text-muted-foreground">{book.isbn_10 || "Not available"}</p>
            </div>
            <div>
              <h4 className="font-semibold">Format</h4>
              <p className="text-muted-foreground capitalize">{book.book_format}</p>
            </div>
            <div>
              <h4 className="font-semibold">Dimensions</h4>
              <p className="text-muted-foreground">{book.dimensions || "Not specified"}</p>
            </div>
          </div>
        </AccordionContent>
      </AccordionItem>
      <AccordionItem value="item-2">
        <AccordionTrigger>Reviews</AccordionTrigger>
        <AccordionContent>
          {book.total_reviews > 0 ? (
            <div className="space-y-4">
              <p>No reviews yet. Be the first to review this product!</p>
            </div>
          ) : (
            <p>No reviews yet. Be the first to review this product!</p>
          )}
        </AccordionContent>
      </AccordionItem>
    </Accordion>
  );
}
