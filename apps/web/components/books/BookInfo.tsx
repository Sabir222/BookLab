"use client";

import { useQuery } from "@tanstack/react-query";
import { bookApi } from "@/app/api/books/books";
import { BookImage } from "@/components/books/BookImage";
import { Star } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
        Tooltip,
        TooltipContent,
        TooltipProvider,
        TooltipTrigger,
} from "@/components/ui/tooltip";

interface BookInfoProps {
        bookId: string;
}

const formatPrice = (priceString: string): number => {
        return parseFloat(priceString) || 0;
};

const formatRating = (ratingString: string | null): number => {
        return parseFloat(ratingString || "0") || 0;
};

const formatAuthors = (authors: Array<{ first_name?: string; last_name: string }> | undefined): string => {
        if (!authors || authors.length === 0) return "Unknown Author";

        const uniqueAuthors = authors.filter((author, index, self) =>
                index === self.findIndex(a =>
                        a.first_name === author.first_name &&
                        a.last_name === author.last_name
                )
        );

        return uniqueAuthors
                .map(author => `${author.first_name ? `${author.first_name} ${author.last_name}` : author.last_name}`)
                .join(", ");
};

export function BookInfo({ bookId }: BookInfoProps) {
        const { data: book, isLoading, error } = useQuery({
                queryKey: ['book', bookId],
                queryFn: () => bookApi.getBookById(bookId),
        });

        if (isLoading) return <div>Loading...</div>;
        if (error) return <div>Error loading book</div>;
        if (!book) return <div>Book not found</div>;

        const price = formatPrice(book.price_sale);
        const rentDailyPrice = book.price_rent_daily ? formatPrice(book.price_rent_daily) : null;
        const rentWeeklyPrice = book.price_rent_weekly ? formatPrice(book.price_rent_weekly) : null;
        const rentMonthlyPrice = book.price_rent_monthly ? formatPrice(book.price_rent_monthly) : null;

        const hasDiscount = rentDailyPrice && rentDailyPrice > price;
        const discountPercentage = hasDiscount && rentDailyPrice
                ? Math.round(((rentDailyPrice - price) / rentDailyPrice) * 100)
                : 0;

        const authors = book.authors;
        const authorName = authors ? formatAuthors(authors) : (book.author_name || "Unknown Author");

        const categories = book.categories || [];
        const genres = book.genres || [];

        const publisher = book.publisher || {
                publisher_name: "Unknown Publisher",
                founded_year: null,
                country: null,
                website_url: null
        };

        return (
                <div className="max-w-7xl mx-auto px-6 py-16">
                        <div className="grid lg:grid-cols-12 gap-16">
                                <div className="lg:col-span-4">
                                        <div className="sticky top-8">
                                                {book.cover_image_large_url ? (
                                                        <BookImage
                                                                src={book.cover_image_large_url}
                                                                alt={book.title}
                                                                width={400}
                                                                height={600}
                                                                className="w-full h-auto rounded-lg shadow-sm"
                                                        />
                                                ) : (
                                                        <div className="aspect-[2/3] bg-gray-50 border border-gray-200 rounded-lg flex items-center justify-center">
                                                                <span className="text-6xl text-gray-300">📚</span>
                                                        </div>
                                                )}
                                        </div>
                                </div>

                                <div className="lg:col-span-8 space-y-12">
                                        <div className="space-y-6">
                                                <div className="space-y-3">
                                                        <h1 className="text-4xl font-light text-gray-900 leading-tight">
                                                                {book.title}
                                                        </h1>
                                                        <p className="text-xl text-gray-600">
                                                                {authorName}
                                                        </p>
                                                </div>

                                                <div className="flex items-center gap-3">
                                                        <div className="flex">
                                                                {[...Array(5)].map((_, i) => (
                                                                        <Star
                                                                                key={i}
                                                                                className={`h-4 w-4 ${i < Math.floor(formatRating(book.average_rating))
                                                                                        ? "fill-gray-900 text-gray-900"
                                                                                        : "fill-gray-200 text-gray-200"}`}
                                                                        />
                                                                ))}
                                                        </div>
                                                        <span className="text-sm text-gray-600">
                                                                {formatRating(book.average_rating).toFixed(1)} · {book.total_ratings} reviews
                                                        </span>
                                                </div>

                                                <TooltipProvider>
                                                        {(categories.length > 0 || genres.length > 0) && (
                                                                <div className="flex flex-wrap gap-2">
                                                                        {categories.slice(0, 3).map((category) => (
                                                                                <Tooltip key={category.category_id}>
                                                                                        <TooltipTrigger asChild>
                                                                                                <span className="px-3 py-1 text-xs font-medium text-gray-700 bg-gray-100 rounded-full hover:bg-gray-150 transition-colors cursor-default">
                                                                                                        {category.category_name}
                                                                                                </span>
                                                                                        </TooltipTrigger>
                                                                                        <TooltipContent>
                                                                                                <p className="max-w-xs">{category.description || "No description available"}</p>
                                                                                        </TooltipContent>
                                                                                </Tooltip>
                                                                        ))}
                                                                        {genres.slice(0, 3).map((genre) => (
                                                                                <Tooltip key={genre.genre_id}>
                                                                                        <TooltipTrigger asChild>
                                                                                                <span className="px-3 py-1 text-xs font-medium text-gray-700 bg-gray-100 rounded-full hover:bg-gray-150 transition-colors cursor-default">
                                                                                                        {genre.genre_name}
                                                                                                </span>
                                                                                        </TooltipTrigger>
                                                                                        <TooltipContent>
                                                                                                <p className="max-w-xs">{genre.description || "No description available"}</p>
                                                                                        </TooltipContent>
                                                                                </Tooltip>
                                                                        ))}
                                                                </div>
                                                        )}
                                                </TooltipProvider>
                                        </div>

                                        <div className="border-t pt-8">
                                                <div className="space-y-4">
                                                        <div className="flex items-baseline gap-3">
                                                                <span className="text-3xl font-light text-gray-900">${price.toFixed(2)}</span>
                                                                {hasDiscount && (
                                                                        <>
                                                                                <span className="text-lg text-gray-400 line-through">${rentDailyPrice?.toFixed(2)}</span>
                                                                                <span className="text-sm font-medium text-red-600">
                                                                                        {discountPercentage}% off
                                                                                </span>
                                                                        </>
                                                                )}
                                                        </div>

                                                        {(book.for_rent && (rentDailyPrice || rentWeeklyPrice || rentMonthlyPrice)) && (
                                                                <div className="space-y-2">
                                                                        <p className="text-sm text-gray-600">Also available for rent:</p>
                                                                        <div className="flex gap-4 text-sm text-gray-700">
                                                                                {rentDailyPrice && (
                                                                                        <span>${rentDailyPrice.toFixed(2)}/day</span>
                                                                                )}
                                                                                {rentWeeklyPrice && (
                                                                                        <span>${rentWeeklyPrice.toFixed(2)}/week</span>
                                                                                )}
                                                                                {rentMonthlyPrice && (
                                                                                        <span>${rentMonthlyPrice.toFixed(2)}/month</span>
                                                                                )}
                                                                        </div>
                                                                </div>
                                                        )}

                                                        <div className="flex items-center gap-4 pt-2">
                                                                {book.stock_quantity > 0 ? (
                                                                        <span className="text-sm text-green-700">
                                                                                In stock ({book.stock_quantity} available)
                                                                        </span>
                                                                ) : (
                                                                        <span className="text-sm text-red-600">
                                                                                Out of stock
                                                                        </span>
                                                                )}

                                                                {book.book_condition && (
                                                                        <span className="text-sm text-gray-600">
                                                                                {book.book_condition.replace('_', ' ')} condition
                                                                        </span>
                                                                )}
                                                        </div>

                                                        <div className="flex gap-4 pt-6">
                                                                <Button
                                                                        size="lg"
                                                                        className="px-8 h-12"
                                                                        disabled={book.stock_quantity === 0}
                                                                >
                                                                        {book.stock_quantity > 0 ? "Add to Cart" : "Out of Stock"}
                                                                </Button>
                                                                <Button variant="outline" size="lg" className="px-8 h-12">
                                                                        Add to Wishlist
                                                                </Button>
                                                        </div>
                                                </div>
                                        </div>

                                        {book.description && (
                                                <div className="border-t pt-8">
                                                        <h2 className="text-lg font-medium text-gray-900 mb-4">About this book</h2>
                                                        <div className="prose prose-gray max-w-none">
                                                                <p className="text-gray-700 leading-relaxed">
                                                                        {book.description}
                                                                </p>
                                                        </div>
                                                </div>
                                        )}

                                        <div className="border-t pt-8">
                                                <h2 className="text-lg font-medium text-gray-900 mb-6">Details</h2>

                                                <dl className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-x-8 gap-y-4">
                                                        <div>
                                                                <dt className="text-sm font-medium text-gray-500">Format</dt>
                                                                <dd className="mt-1 text-sm text-gray-900 capitalize">{book.book_format}</dd>
                                                        </div>

                                                        {book.page_count && (
                                                                <div>
                                                                        <dt className="text-sm font-medium text-gray-500">Pages</dt>
                                                                        <dd className="mt-1 text-sm text-gray-900">{book.page_count}</dd>
                                                                </div>
                                                        )}

                                                        {book.isbn_13 && (
                                                                <div>
                                                                        <dt className="text-sm font-medium text-gray-500">ISBN-13</dt>
                                                                        <dd className="mt-1 text-sm text-gray-900 font-mono">{book.isbn_13}</dd>
                                                                </div>
                                                        )}

                                                        {book.isbn_10 && (
                                                                <div>
                                                                        <dt className="text-sm font-medium text-gray-500">ISBN-10</dt>
                                                                        <dd className="mt-1 text-sm text-gray-900 font-mono">{book.isbn_10}</dd>
                                                                </div>
                                                        )}

                                                        {book.publication_date && (
                                                                <div>
                                                                        <dt className="text-sm font-medium text-gray-500">Published</dt>
                                                                        <dd className="mt-1 text-sm text-gray-900">{new Date(book.publication_date).toLocaleDateString()}</dd>
                                                                </div>
                                                        )}

                                                        {book.published_year && (
                                                                <div>
                                                                        <dt className="text-sm font-medium text-gray-500">Year</dt>
                                                                        <dd className="mt-1 text-sm text-gray-900">{book.published_year}</dd>
                                                                </div>
                                                        )}

                                                        {book.dimensions && (
                                                                <div>
                                                                        <dt className="text-sm font-medium text-gray-500">Dimensions</dt>
                                                                        <dd className="mt-1 text-sm text-gray-900">{book.dimensions}</dd>
                                                                </div>
                                                        )}

                                                        {book.weight_grams && (
                                                                <div>
                                                                        <dt className="text-sm font-medium text-gray-500">Weight</dt>
                                                                        <dd className="mt-1 text-sm text-gray-900">{book.weight_grams}g</dd>
                                                                </div>
                                                        )}

                                                        {book.language && (
                                                                <div>
                                                                        <dt className="text-sm font-medium text-gray-500">Language</dt>
                                                                        <dd className="mt-1 text-sm text-gray-900 capitalize">{book.language.trim()}</dd>
                                                                </div>
                                                        )}

                                                        {publisher.publisher_name && (
                                                                <div>
                                                                        <dt className="text-sm font-medium text-gray-500">Publisher</dt>
                                                                        <dd className="mt-1 text-sm text-gray-900">
                                                                                <TooltipProvider>
                                                                                        <Tooltip>
                                                                                                <TooltipTrigger asChild>
                                                                                                        <span className="cursor-help">
                                                                                                                {publisher.publisher_name}
                                                                                                                {publisher.founded_year && ` (${publisher.founded_year})`}
                                                                                                                {publisher.country && ` · ${publisher.country}`}
                                                                                                        </span>
                                                                                                </TooltipTrigger>
                                                                                                <TooltipContent>
                                                                                                        <div className="max-w-xs">
                                                                                                                <p>{"description" in publisher && publisher.description ? publisher.description : "No description available"}</p>
                                                                                                                {publisher.website_url && (
                                                                                                                        <p className="mt-1">
                                                                                                                                <a
                                                                                                                                        href={publisher.website_url}
                                                                                                                                        target="_blank"
                                                                                                                                        rel="noopener noreferrer"
                                                                                                                                        className="text-blue-600 hover:text-blue-800 underline"
                                                                                                                                >
                                                                                                                                        Website
                                                                                                                                </a>
                                                                                                                        </p>
                                                                                                                )}
                                                                                                        </div>
                                                                                                </TooltipContent>
                                                                                        </Tooltip>
                                                                                </TooltipProvider>
                                                                        </dd>
                                                                </div>
                                                        )}
                                                </dl>
                                        </div>
                                </div>
                        </div>
                </div>
        );
}
