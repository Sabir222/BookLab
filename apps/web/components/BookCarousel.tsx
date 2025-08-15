import { 
  Carousel, 
  CarouselContent, 
  CarouselItem, 
  CarouselNext, 
  CarouselPrevious 
} from "@/components/ui/carousel";
import { BookCard } from "@/components/books/BookCard";
import { Book as MockBook } from "@/types";
import { Book as RepoBook } from "@repo/types/types";

interface BookCarouselProps {
  title: string;
  books: MockBook[];
  onToggleFavorite?: (id: string) => void;
}

export function BookCarousel({ title, books, onToggleFavorite }: BookCarouselProps) {
  return (
    <section className="w-full py-6">
      <div className="container mx-auto px-4">
        <div className="mb-6 flex items-center justify-between">
          <h2 className="text-2xl font-bold tracking-tight">{title}</h2>
          <a href="#" className="text-sm font-medium text-primary hover:underline">
            View all
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
              {books.map((book) => (
                <CarouselItem 
                  key={book.id} 
                  className="basis-full sm:basis-1/2 md:basis-1/3 lg:basis-1/4 xl:basis-1/5"
                >
                  <BookCard 
                    book={{
                      book_id: book.id,
                      title: book.title,
                      subtitle: null,
                      description: book.description || "",
                      isbn_13: book.isbn || "",
                      isbn_10: "",
                      publication_date: book.publishedDate || "",
                      published_year: null,
                      page_count: book.pages || null,
                      language: "",
                      cover_image_url: book.coverImage,
                      cover_image_small_url: "",
                      cover_image_medium_url: "",
                      cover_image_large_url: book.coverImage,
                      edition: null,
                      book_format: "paperback",
                      book_condition: null,
                      dimensions: "",
                      weight_grams: null,
                      for_sale: true,
                      for_rent: false,
                      price_sale: book.price.toString(),
                      price_rent_daily: null,
                      price_rent_weekly: null,
                      price_rent_monthly: null,
                      stock_quantity: 10,
                      reserved_quantity: 0,
                      is_active: true,
                      average_rating: book.rating.toString(),
                      total_ratings: book.reviewCount,
                      total_reviews: 0,
                      publisher_id: null,
                      owner_id: null,
                      primary_category_id: null,
                      slug: "",
                      search_keywords: [],
                      created_at: "",
                      updated_at: "",
                      created_by: "",
                      last_modified_by: "",
                      deleted_at: null,
                      deleted_by: null,
                    }}
                  />
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
