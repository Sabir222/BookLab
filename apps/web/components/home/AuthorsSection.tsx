"use client";

import { 
  Carousel, 
  CarouselContent, 
  CarouselItem, 
  CarouselNext, 
  CarouselPrevious 
} from "@/components/ui/carousel";

// Sample author data
const sampleAuthors = [
  {
    id: "1",
    name: "Stephen King",
    bookCount: 68,
    followers: "2.5M",
    image: "/placeholder-books/book-1.svg",
    featuredBook: "The Shining",
  },
  {
    id: "2",
    name: "J.K. Rowling",
    bookCount: 14,
    followers: "1.8M",
    image: "/placeholder-books/book-2.svg",
    featuredBook: "Harry Potter Series",
  },
  {
    id: "3",
    name: "Agatha Christie",
    bookCount: 85,
    followers: "1.2M",
    image: "/placeholder-books/book-3.svg",
    featuredBook: "Murder on the Orient Express",
  },
  {
    id: "4",
    name: "George R.R. Martin",
    bookCount: 24,
    followers: "900K",
    image: "/placeholder-books/book-4.svg",
    featuredBook: "A Game of Thrones",
  },
  {
    id: "5",
    name: "Margaret Atwood",
    bookCount: 52,
    followers: "750K",
    image: "/placeholder-books/book-5.svg",
    featuredBook: "The Handmaid's Tale",
  },
  {
    id: "6",
    name: "Neil Gaiman",
    bookCount: 38,
    followers: "680K",
    image: "/placeholder-books/book-1.svg",
    featuredBook: "American Gods",
  },
  {
    id: "7",
    name: "Toni Morrison",
    bookCount: 19,
    followers: "520K",
    image: "/placeholder-books/book-2.svg",
    featuredBook: "Beloved",
  },
  {
    id: "8",
    name: "Haruki Murakami",
    bookCount: 27,
    followers: "480K",
    image: "/placeholder-books/book-3.svg",
    featuredBook: "Norwegian Wood",
  },
];

export function AuthorsSection() {
  return (
    <section className="w-full py-6">
      <div className="container mx-auto px-4">
        <div className="mb-6 flex items-center justify-between">
          <h2 className="text-2xl font-bold tracking-tight">Popular Authors</h2>
          <a href="#" className="text-sm font-medium text-primary hover:underline">
            View all authors
          </a>
        </div>
        
        <div className="relative">
          <Carousel
            opts={{
              align: "start",
              slidesToScroll: 1,
              dragFree: false,
            }}
            className="w-full"
          >
            <CarouselContent>
              {sampleAuthors.map((author) => (
                <CarouselItem 
                  key={author.id} 
                  className="basis-full sm:basis-1/2 md:basis-1/3 lg:basis-1/4 xl:basis-1/5"
                >
                  <div className="flex flex-col items-center p-4">
                    <div className="relative">
                      <div className="bg-gray-200 border-2 border-dashed rounded-full w-32 h-32 flex items-center justify-center">
                        <span className="text-3xl">✍️</span>
                      </div>
                    </div>
                    
                    <div className="mt-4 text-center">
                      <h3 className="font-semibold text-lg text-primary">
                        {author.name}
                      </h3>
                      
                      <p className="text-sm text-muted-foreground mt-1">
                        {author.bookCount} books
                      </p>
                      
                      <p className="text-sm text-muted-foreground mt-1 line-clamp-1">
                        {author.followers} followers
                      </p>
                      
                      <button className="mt-3 text-sm py-1.5 px-4 bg-primary text-primary-foreground rounded-full hover:bg-primary/90 transition-colors">
                        Follow
                      </button>
                    </div>
                  </div>
                </CarouselItem>
              ))}
            </CarouselContent>
            <CarouselPrevious className="left-0" />
            <CarouselNext className="right-0" />
          </Carousel>
        </div>
      </div>
    </section>
  );
}