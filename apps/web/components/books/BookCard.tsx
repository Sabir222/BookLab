import { Card, CardContent } from "@/components/ui/card";
import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Star } from "lucide-react";
import { Button } from "@/components/ui/button";
import { WishlistButton } from "@/components/books/LikeButton";

interface BookCardProps {
  id: string;
  title: string;
  author: string;
  price: number;
  rating?: number;
  reviewCount?: number;
  originalPrice?: number;
  category?: string;
  isFavorite?: boolean;
  onToggleFavorite?: (id: string) => void;
  className?: string;
}

export function BookCard({ 
  id, 
  title, 
  author, 
  price, 
  rating = 0,
  reviewCount = 0,
  originalPrice,
  category,
  isFavorite = false,
  onToggleFavorite,
  className = "" 
}: BookCardProps) {
  return (
    <Card className={`group relative overflow-hidden rounded-lg border border-border bg-card transition-all duration-300 hover:shadow-lg h-[440px] flex flex-col ${className}`}>
      <CardContent className="p-3 flex flex-col h-full">
        <div className="relative flex-shrink-0">
          <Link href={`/book/${id}`}>
            <div className="bg-gray-200 border-2 border-dashed rounded-xl w-full h-[220px] flex items-center justify-center">
              <span className="text-4xl">📚</span>
            </div>
          </Link>
          
          {category && (
            <Badge className="absolute left-2 top-2 bg-secondary text-secondary-foreground">
              {category}
            </Badge>
          )}
        </div>
        
        <div className="mt-3 space-y-1 flex-grow overflow-hidden">
          <h3 className="line-clamp-2 text-sm font-semibold leading-tight">
            <Link href={`/book/${id}`} className="hover:text-primary">
              {title}
            </Link>
          </h3>
          
          <p className="text-xs text-muted-foreground line-clamp-1">{author}</p>
          
          <div className="flex items-center gap-1">
            <div className="flex items-center">
              {[...Array(5)].map((_, i) => (
                <Star
                  key={i}
                  className={`h-3 w-3 ${i < Math.floor(rating) ? "fill-yellow-400 text-yellow-400" : "text-muted"}`}
                />
              ))}
            </div>
            <span className="text-xs text-muted-foreground whitespace-nowrap">
              {rating.toFixed(1)} ({reviewCount})
            </span>
          </div>
          
          <div className="mt-1 flex items-center gap-1">
            {originalPrice && originalPrice > price ? (
              <>
                <span className="text-sm font-semibold text-primary">${price.toFixed(2)}</span>
                <span className="text-xs text-muted-foreground line-through">${originalPrice.toFixed(2)}</span>
              </>
            ) : (
              <span className="text-sm font-semibold text-primary">${price.toFixed(2)}</span>
            )}
          </div>
        </div>
        
        <div className="mt-2 flex gap-2 flex-shrink-0">
          <Button className="flex-1 h-8 text-xs" size="sm">
            Add to Cart
          </Button>
          <WishlistButton 
            isWishlisted={isFavorite}
            onClick={() => onToggleFavorite?.(id)}
            className="h-8 w-8"
          />
        </div>
      </CardContent>
    </Card>
  );
}