"use client";
import Link from "next/link";
import Image from "next/image";
import { Star } from "lucide-react";
import { Button } from "@/components/ui/button";
import { WishlistButton } from "@/components/books/LikeButton";
import { Skeleton } from "@/components/ui/skeleton";
import { useState } from "react";
import { SimpleBook } from "@/types";
import { Badge } from "../ui/badge";

interface BookCardProps {
        book?: SimpleBook;
        isLoading?: boolean;
}

export function BookCard({ book, isLoading = false }: BookCardProps) {
        const [favorite, setFavorite] = useState(false);

        const handleToggleFavorite = () => {
                setFavorite((prev) => !prev);
        };

        const rating = !isLoading && book?.rating ? book.rating : 0;

        return (
                <div className="group relative rounded-lg border border-gray-200 overflow-hidden transition-all duration-300 hover:shadow-lg hover:border-gray-300 w-full max-w-[220px]">

                        <div className="relative w-full">
                                {isLoading ? (
                                        <Skeleton className="w-full aspect-[3/4] bg-gray-300" />
                                ) : book?.coverImage ? (
                                        <Link href={`/book/${book.id}`}>
                                                <div className="relative w-full aspect-[3/4] overflow-hidden">
                                                        <Image
                                                                src={book.coverImage}
                                                                alt={book.title}
                                                                fill
                                                                priority={true}
                                                                className="object-cover hover:scale-105 transition-transform duration-300"
                                                                onError={(e) => {
                                                                        const target = e.target as HTMLImageElement;
                                                                        target.src = "/placeholder-book.png";
                                                                }}
                                                        />
                                                </div>
                                        </Link>
                                ) : (
                                        <div className="bg-gray-100 w-full aspect-[3/4] flex items-center justify-center border-b">
                                                <span className="text-4xl">📚</span>
                                        </div>
                                )}
                        </div>

                        <div className="p-3 flex flex-col">
                                {isLoading ? (
                                        <>
                                                <Skeleton className="h-4 w-full bg-gray-300 mb-1" />
                                                <Skeleton className="h-4 w-4/5 bg-gray-300 mb-2" />
                                                <Skeleton className="h-3 w-3/4 bg-gray-300 mb-2" />
                                                <div className="flex items-center gap-1 mb-2">
                                                        {[...Array(5)].map((_, i) => (
                                                                <Skeleton key={i} className="h-3 w-3 rounded bg-gray-300" />
                                                        ))}
                                                        <Skeleton className="h-3 w-8 bg-gray-300 ml-1" />
                                                </div>
                                                <Skeleton className="h-5 w-16 bg-gray-300 mb-3" />
                                                <div className="flex items-center gap-2">
                                                        <Skeleton className="flex-1 h-8 bg-gray-300" />
                                                        <Skeleton className="h-8 w-8 rounded bg-gray-300" />
                                                </div>
                                        </>
                                ) : book ? (
                                        <>
                                                <h3 className="text-sm font-medium leading-tight mb-1 text-gray-900 truncate">
                                                        <Link href={`/book/${book.id}`} className="hover:text-blue-600 hover:underline">
                                                                {book.title}
                                                        </Link>
                                                </h3>

                                                <p className="text-xs text-gray-600 mb-2 line-clamp-1">
                                                        {book.author}
                                                </p>

                                                {book.category && (

                                                        <div className="flex flex-wrap gap-1 mb-2">
                                                                <Badge className="bg-gray-100 text-blue-800 rounded-sm">{book.category}</Badge>
                                                        </div>
                                                )}

                                                <div className="flex items-center gap-1 mb-2">
                                                        <div className="flex items-center">
                                                                {[...Array(5)].map((_, i) => (
                                                                        <Star
                                                                                key={i}
                                                                                className={`h-3 w-3 ${i < Math.floor(rating) ? "fill-amber-400 text-amber-400" : "fill-gray-200 text-gray-200"}`}
                                                                        />
                                                                ))}
                                                        </div>
                                                        <span className="text-xs text-gray-500 ml-1">
                                                                {rating.toFixed(1)}
                                                        </span>
                                                        <span className="text-xs text-gray-400">
                                                                ({book.reviewCount})
                                                        </span>
                                                </div>

                                                <div className="mb-3">
                                                        <span className="text-lg font-bold text-gray-900">
                                                                ${book.price?.toFixed(2) || '0.00'}
                                                        </span>
                                                </div>

                                                <div className="flex items-center gap-2">
                                                        <Button
                                                                className="flex-1 h-8 text-xs font-medium  hover:bg-amber-500 cursor-pointer border-amber-500 hover:border-amber-600"
                                                                size="sm"
                                                        >
                                                                Add to Cart
                                                        </Button>
                                                        <WishlistButton
                                                                isWishlisted={favorite}
                                                                onClick={handleToggleFavorite}
                                                                className="h-8 w-8 border-gray-300 hover:border-gray-400 cursor-pointer"
                                                        />
                                                </div>
                                        </>
                                ) : null}
                        </div>

                </div>
        );
}
