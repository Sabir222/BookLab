// @ts-nocheck
"use client";

import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import Image from "next/image";
import { Star } from "lucide-react";
import { Book } from "@repo/types/types";

interface BookHeaderProps {
  book: Book;
}

export function BookHeader({ book }: BookHeaderProps) {
  // Format price from string to number
  const formatPrice = (priceString: string): number => {
    return parseFloat(priceString) || 0;
  };

  // Format rating from string to number
  const formatRating = (ratingString: string | null): number => {
    return parseFloat(ratingString || "0") || 0;
  };

  const price = formatPrice(book.price_sale);
  const originalPrice = book.price_rent_daily ? formatPrice(book.price_rent_daily) : null;
  const hasDiscount = originalPrice && originalPrice > price;
  const discountPercentage = hasDiscount && originalPrice 
    ? Math.round(((originalPrice - price) / originalPrice) * 100) 
    : 0;

  return (
    <Card className="overflow-hidden">
      <CardContent className="p-6">
        <div className="flex flex-col md:flex-row gap-8">
          {/* Book Cover */}
          <div className="md:w-1/3 flex justify-center">
            <div className="relative">
              {book.cover_image_medium_url ? (
                <Image
                  src={book.cover_image_medium_url}
                  alt={book.title}
                  width={200}
                  height={300}
                  className="rounded-lg shadow-md object-cover"
                  onError={(e) => {
                    const target = e.target as HTMLImageElement;
                    target.src = "/placeholder-book-cover.jpg";
                  }}
                />
              ) : (
                <div className="bg-gray-200 border-2 border-dashed rounded-xl w-[200px] h-[300px] flex items-center justify-center">
                  <span className="text-4xl">📚</span>
                </div>
              )}
            </div>
          </div>
          
          {/* Book Details */}
          <div className="md:w-2/3">
            <h1 className="text-2xl font-bold text-primary">{book.title}</h1>
            <p className="text-lg text-muted-foreground mt-1">
              by {book.publisher_id || "Unknown Author"}
            </p>
            
            {/* Rating */}
            <div className="flex items-center mt-3">
              <div className="flex">
                {[...Array(5)].map((_, i) => (
                  <Star
                    key={i}
                    className={`h-4 w-4 ${i < Math.floor(formatRating(book.average_rating)) ? "fill-yellow-400 text-yellow-400" : "text-muted"}`}
                  />
                ))}
              </div>
              <span className="ml-2 text-sm text-muted-foreground">
                {formatRating(book.average_rating).toFixed(1)} ({book.total_ratings} ratings)
              </span>
            </div>
            
            {/* Price */}
            <div className="mt-4">
              <div className="flex items-baseline gap-2">
                <span className="text-2xl font-bold text-primary">${price.toFixed(2)}</span>
                {hasDiscount && (
                  <>
                    <span className="text-lg text-muted-foreground line-through">${originalPrice?.toFixed(2)}</span>
                    <span className="bg-red-100 text-red-800 text-xs font-medium px-2 py-0.5 rounded">
                      {discountPercentage}% OFF
                    </span>
                  </>
                )}
              </div>
            </div>
            
            {/* Action Buttons */}
            <div className="flex flex-wrap gap-3 mt-6">
              <Button>Add to Cart</Button>
              <Button variant="outline">Add to Wishlist</Button>
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}