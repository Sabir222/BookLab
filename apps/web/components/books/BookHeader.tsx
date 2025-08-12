import { Button } from "@/components/ui/button";
import { WishlistButton } from "@/components/books/LikeButton";

interface BookHeaderProps {
  book: {
    id: string;
    title: string;
    author: string;
    format: string;
    category: string;
    price: number;
    originalPrice?: number;
    inStock: boolean;
    stockCount?: number;
    isBestseller?: boolean;
    isAwardWinner?: boolean;
  };
}

export function BookHeader({ book }: BookHeaderProps) {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
      {/* Left Column - Book Cover */}
      <div className="flex justify-center md:justify-start">
        <div className="bg-gray-200 border-2 border-dashed rounded-xl w-full max-w-md h-96 flex items-center justify-center">
          <span className="text-6xl">📚</span>
        </div>
      </div>

      {/* Right Column - Book Information */}
      <div>
        <div>
          <h1 className="text-3xl font-bold text-primary">{book.title}</h1>
          <p className="text-xl text-muted-foreground mt-2">by {book.author}</p>
        </div>

        <div className="flex flex-wrap items-center gap-2 mt-4">
          <span className="px-2 py-1 bg-secondary text-secondary-foreground text-xs font-medium rounded">
            {book.format}
          </span>
          <span className="px-2 py-1 bg-muted text-muted-foreground text-xs font-medium rounded">
            {book.category}
          </span>
          {book.isBestseller && (
            <span className="px-2 py-1 bg-primary text-primary-foreground text-xs font-medium rounded">
              BESTSELLER
            </span>
          )}
          {book.isAwardWinner && (
            <span className="px-2 py-1 bg-accent text-accent-foreground text-xs font-medium rounded">
              AWARD WINNER
            </span>
          )}
        </div>

        <div className="mt-6">
          <div className="flex items-baseline gap-3">
            <span className="text-3xl font-bold text-primary">${book.price.toFixed(2)}</span>
            {book.originalPrice && book.originalPrice > book.price && (
              <span className="text-lg text-muted-foreground line-through">
                ${book.originalPrice.toFixed(2)}
              </span>
            )}
          </div>
          
          <div className="mt-2">
            {book.inStock ? (
              <p className="text-green-600 font-medium">
                In Stock
                {book.stockCount && ` (${book.stockCount} available)`}
              </p>
            ) : (
              <p className="text-destructive font-medium">Out of Stock</p>
            )}
          </div>
        </div>

        <div className="flex items-center gap-3 mt-6">
          <div className="flex items-center border border-border rounded-md">
            <Button variant="ghost" size="icon" className="h-10 w-10 rounded-r-none">
              -
            </Button>
            <span className="px-4 py-2 text-sm font-medium">1</span>
            <Button variant="ghost" size="icon" className="h-10 w-10 rounded-l-none">
              +
            </Button>
          </div>
        </div>

        <div className="flex items-center gap-3 mt-4">
          <Button className="bg-secondary text-secondary-foreground hover:bg-secondary/90 flex-1 max-w-xs">
            Add to Cart
          </Button>
          <WishlistButton />
        </div>

        <div className="mt-4 text-sm text-muted-foreground">
          🚚 Free shipping on orders over $25
        </div>

        <div className="mt-6 text-sm text-muted-foreground">
          <p>12 people bought this in the last 24 hours</p>
        </div>
      </div>
    </div>
  );
}
