import { BookAccordion } from "@/components/books/BookAccordion";
import { serverBookApi } from "@/lib/api/serverBooks";
import type { BookWithAuthor } from "@/lib/api/serverBooks";
import { notFound } from "next/navigation";
import { BookImage } from "@/components/books/BookImage";
import { Star } from "lucide-react";
import { Button } from "@/components/ui/button";

const formatPrice = (priceString: string): number => {
  return parseFloat(priceString) || 0;
};

const formatRating = (ratingString: string | null): number => {
  return parseFloat(ratingString || "0") || 0;
};

export default async function BookDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;

  const book = await serverBookApi.getBookById(id);

  if (!book) {
    notFound();
  }

  const price = formatPrice(book.price_sale);
  const originalPrice = book.price_rent_daily ? formatPrice(book.price_rent_daily) : null;
  const hasDiscount = originalPrice && originalPrice > price;
  const discountPercentage = hasDiscount && originalPrice
    ? Math.round(((originalPrice - price) / originalPrice) * 100)
    : 0;

  return (
    <div className="pt-30 min-h-screen bg-background">
      <div className="container mx-auto px-4 py-8">
        <div className="flex flex-col md:flex-row gap-8">
          <div className="md:w-1/3 flex justify-center">
            <div className="relative w-full max-w-sm">
              {book.cover_image_large_url ? (
                <BookImage
                  src={book.cover_image_large_url}
                  alt={book.title}
                  width={300}
                  height={450}
                  className="rounded-lg shadow-lg object-cover"
                />
              ) : (
                <div className="bg-gray-200 border-2 border-dashed rounded-xl w-full h-[450px] flex items-center justify-center">
                  <span className="text-6xl">📚</span>
                </div>
              )}
            </div>
          </div>

          <div className="md:w-2/3">
            <h1 className="text-3xl font-bold text-primary">{book.title}</h1>
            <p className="text-xl text-muted-foreground mt-2">
              {book.author_name || "Unknown Author"}
            </p>

            <div className="flex items-center mt-4">
              <div className="flex">
                {[...Array(5)].map((_, i) => (
                  <Star
                    key={i}
                    className={`h-5 w-5 ${i < Math.floor(formatRating(book.average_rating)) ? "fill-yellow-400 text-yellow-400" : "text-muted"}`}
                  />
                ))}
              </div>
              <span className="ml-2 text-muted-foreground">
                {formatRating(book.average_rating).toFixed(1)} ({book.total_ratings} ratings)
              </span>
            </div>

            <div className="mt-6">
              <div className="flex items-baseline gap-3">
                <span className="text-3xl font-bold text-primary">${price.toFixed(2)}</span>
                {hasDiscount && (
                  <>
                    <span className="text-xl text-muted-foreground line-through">${originalPrice?.toFixed(2)}</span>
                    <span className="bg-red-100 text-red-800 text-sm font-medium px-2.5 py-0.5 rounded">
                      {discountPercentage}% OFF
                    </span>
                  </>
                )}
              </div>
            </div>

            <div className="mt-4">
              {book.stock_quantity > 0 ? (
                <span className="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-green-100 text-green-800">
                  In Stock ({book.stock_quantity} available)
                </span>
              ) : (
                <span className="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-red-100 text-red-800">
                  Out of Stock
                </span>
              )}
            </div>

            <div className="flex flex-wrap gap-4 mt-8">
              <Button size="lg" className="px-8" disabled={book.stock_quantity === 0}>
                {book.stock_quantity > 0 ? "Add to Cart" : "Out of Stock"}
              </Button>
              <Button variant="outline" size="lg" className="px-8">
                Add to Wishlist
              </Button>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 mt-8">
              <div>
                <h3 className="font-semibold text-primary">Format</h3>
                <p className="text-muted-foreground capitalize">{book.book_format}</p>
              </div>

              {book.page_count && (
                <div>
                  <h3 className="font-semibold text-primary">Pages</h3>
                  <p className="text-muted-foreground">{book.page_count}</p>
                </div>
              )}

              {book.isbn_13 && (
                <div>
                  <h3 className="font-semibold text-primary">ISBN-13</h3>
                  <p className="text-muted-foreground">{book.isbn_13}</p>
                </div>
              )}

              {book.isbn_10 && (
                <div>
                  <h3 className="font-semibold text-primary">ISBN-10</h3>
                  <p className="text-muted-foreground">{book.isbn_10}</p>
                </div>
              )}

              {book.publication_date && (
                <div>
                  <h3 className="font-semibold text-primary">Publication Date</h3>
                  <p className="text-muted-foreground">{new Date(book.publication_date).toLocaleDateString()}</p>
                </div>
              )}

              {book.publisher_id && (
                <div>
                  <h3 className="font-semibold text-primary">Publisher</h3>
                  <p className="text-muted-foreground">Unknown Publisher</p>
                </div>
              )}

              {book.language && (
                <div>
                  <h3 className="font-semibold text-primary">Language</h3>
                  <p className="text-muted-foreground capitalize">{book.language}</p>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>

      {book.description && (
        <div className="container mx-auto px-4 mt-12">
          <h2 className="text-2xl font-bold text-primary">Description</h2>
          <p className="mt-4 text-muted-foreground whitespace-pre-line">
            {book.description}
          </p>
        </div>
      )}

      <div className="container mx-auto px-4 mt-12">
        <BookAccordion book={book} />
      </div>
    </div>
  );
}
