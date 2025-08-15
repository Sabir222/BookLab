"use client";

import { Card, CardContent } from "@/components/ui/card";
import Link from "next/link";
import Image from "next/image";
import { Star } from "lucide-react";
import { Button } from "@/components/ui/button";
import { WishlistButton } from "@/components/books/LikeButton";
import { Skeleton } from "@/components/ui/skeleton";
import { useState } from "react";
import { type Book } from "@repo/types/types";

interface BookCardProps {
        book?: Book;
        isLoading?: boolean;
}

export function BookCard({ book, isLoading = false }: BookCardProps) {
        const [favorite, setFavorite] = useState(false);

        const handleToggleFavorite = () => {
                setFavorite((prev) => !prev);
        };

        const rating = !isLoading && book?.average_rating
                ? parseFloat(book.average_rating)
                : 0;

        return (
                <Card className="group relative overflow-hidden rounded-lg border border-border bg-card transition-all duration-300 hover:shadow-lg h-[440px] flex flex-col">
                        <CardContent className="p-3 flex flex-col h-full">

                                <div className="relative flex-shrink-0">
                                        {isLoading ? (
                                                <Skeleton className="w-full h-[220px] rounded-xl bg-gray-300" />
                                        ) : book?.cover_image_large_url ? (
                                                <Link href={`/book/${book.book_id}`}>
                                                        <div className="relative w-full h-[220px]">
                                                                <Image
                                                                        src={book.cover_image_large_url}
                                                                        alt={book.title}
                                                                        fill
                                                                        className="object-cover rounded-xl"
                                                                        onError={(e) => {
                                                                                const target = e.target as HTMLImageElement;
                                                                                target.src = "/placeholder-book.png";
                                                                        }}
                                                                />
                                                        </div>
                                                </Link>
                                        ) : (
                                                <div className="bg-gray-200 border-2 border-dashed rounded-xl w-full h-[220px] flex items-center justify-center">
                                                        <span className="text-4xl">📚</span>
                                                </div>
                                        )}
                                </div>

                                {/* Info */}
                                <div className="mt-3 space-y-1 flex-grow overflow-hidden">
                                        {isLoading ? (
                                                <>
                                                        <Skeleton className="h-4 w-3/4 bg-gray-300" />
                                                        <Skeleton className="h-3 w-1/2 bg-gray-300" />
                                                        <div className="flex items-center gap-1">
                                                                {[...Array(5)].map((_, i) => (
                                                                        <Skeleton key={i} className="h-3 w-3 rounded bg-gray-300" />
                                                                ))}
                                                                <Skeleton className="h-3 w-10 bg-gray-300" />
                                                        </div>
                                                        <Skeleton className="h-4 w-12 mt-1 bg-gray-300" />
                                                </>
                                        ) : book ? (
                                                <>
                                                        <h3 className="line-clamp-2 text-sm font-semibold leading-tight">
                                                                <Link href={`/book/${book.book_id}`} className="hover:text-primary">
                                                                        {book.title}
                                                                </Link>
                                                        </h3>
                                                        <p className="text-xs text-muted-foreground line-clamp-1">Author</p>
                                                        <div className="flex items-center gap-1">
                                                                <div className="flex items-center">
                                                                        {[...Array(5)].map((_, i) => (
                                                                                <Star
                                                                                        key={i}
                                                                                        className={`h-3 w-3 ${i < Math.floor(parseFloat(book.average_rating || "0")) ? "fill-yellow-400 text-yellow-400" : "text-muted"}`}
                                                                                />
                                                                        ))}
                                                                </div>
                                                                <span className="text-xs text-muted-foreground whitespace-nowrap">
                                                                        {rating.toFixed(1)} ({book.total_ratings})
                                                                </span>
                                                        </div>
                                                        <span className="text-sm font-semibold text-primary">
                                                                ${parseFloat(book.price_sale).toFixed(2)}
                                                        </span>
                                                </>
                                        ) : null}
                                </div>

                                <div className="mt-2 flex gap-2 flex-shrink-0">
                                        {isLoading ? (
                                                <>
                                                        <Skeleton className="flex-1 h-8 bg-gray-300" /> {/* Add to cart */}
                                                        <Skeleton className="h-8 w-8 rounded-full bg-gray-300" /> {/* Wishlist */}
                                                </>
                                        ) : book ? (
                                                <>
                                                        <Button className="flex-1 h-8 text-xs" size="sm">
                                                                Add to Cart
                                                        </Button>
                                                        <WishlistButton
                                                                isWishlisted={favorite}
                                                                onClick={handleToggleFavorite}
                                                                className="h-8 w-8"
                                                        />
                                                </>
                                        ) : null}
                                </div>

                        </CardContent>
                </Card>
        );
}
