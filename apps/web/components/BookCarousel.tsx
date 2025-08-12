"use client";

import { 
  Carousel, 
  CarouselContent, 
  CarouselItem, 
  CarouselNext, 
  CarouselPrevious 
} from "@/components/ui/carousel";
import { BookCard } from "@/components/books/BookCard";
import { Book } from "@/types";

interface BookCarouselProps {
  title: string;
  books: Book[];
  onToggleFavorite?: (id: string) => void;
}

export function BookCarousel({ title, books, onToggleFavorite }: BookCarouselProps) {
  return (
    <section className="w-full py-6">
      <div className="container">
        <div className="mb-6 flex items-center justify-between">
          <h2 className="text-2xl font-bold tracking-tight">{title}</h2>
          <a href="#" className="text-sm font-medium text-primary hover:underline">
            View all
          </a>
        </div>
        
        <Carousel
          opts={{
            align: "start",
            slidesToScroll: "auto",
          }}
          className="w-full"
        >
          <CarouselContent>
            {books.map((book) => (
              <CarouselItem 
                key={book.id} 
                className="basis-full sm:basis-1/2 md:basis-1/3 lg:basis-1/4 xl:basis-1/5"
              >
                <BookCard 
                  {...book} 
                  onToggleFavorite={onToggleFavorite}
                />
              </CarouselItem>
            ))}
          </CarouselContent>
          <CarouselPrevious />
          <CarouselNext />
        </Carousel>
      </div>
    </section>
  );
}
