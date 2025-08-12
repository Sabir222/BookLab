"use client";

import { useState, useEffect } from "react";
import { BookCard } from "@/components/books/BookCard";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Slider } from "@/components/ui/slider";
import { Checkbox } from "@/components/ui/checkbox";
import {
        Accordion,
        AccordionContent,
        AccordionItem,
        AccordionTrigger
} from "@/components/ui/accordion";
import { Star, Filter } from "lucide-react";

const mockBooks = [
        {
                id: "1",
                title: "The Great Gatsby",
                author: "F. Scott Fitzgerald",
                price: 12.99,
                originalPrice: 19.99,
                rating: 4.5,
                reviewCount: 120,
                category: "Fiction",
                isFavorite: false,
        },
        {
                id: "2",
                title: "To Kill a Mockingbird",
                author: "Harper Lee",
                price: 14.99,
                rating: 4.8,
                reviewCount: 95,
                category: "Fiction",
                isFavorite: true,
        },
        {
                id: "3",
                title: "1984",
                author: "George Orwell",
                price: 13.99,
                originalPrice: 16.99,
                rating: 4.7,
                reviewCount: 210,
                category: "Dystopian",
                isFavorite: false,
        },
        {
                id: "4",
                title: "Pride and Prejudice",
                author: "Jane Austen",
                price: 11.99,
                rating: 4.6,
                reviewCount: 180,
                category: "Romance",
                isFavorite: false,
        },
        {
                id: "5",
                title: "The Catcher in the Rye",
                author: "J.D. Salinger",
                price: 15.99,
                rating: 4.3,
                reviewCount: 150,
                category: "Fiction",
                isFavorite: true,
        },
        {
                id: "6",
                title: "The Hobbit",
                author: "J.R.R. Tolkien",
                price: 18.99,
                originalPrice: 24.99,
                rating: 4.9,
                reviewCount: 320,
                category: "Fantasy",
                isFavorite: false,
        },
];

const categories = ["Fiction", "Non-Fiction", "Mystery", "Romance", "Sci-Fi", "Fantasy", "Biography", "History"];
const ratings = [4, 3, 2, 1];

export default function FilterPage() {
        const [searchQuery, setSearchQuery] = useState("");
        const [priceRange, setPriceRange] = useState<[number, number]>([0, 50]);
        const [selectedCategories, setSelectedCategories] = useState<string[]>([]);
        const [selectedRatings, setSelectedRatings] = useState<number[]>([]);
        const [inStockOnly, setInStockOnly] = useState(false);
        const [onSaleOnly, setOnSaleOnly] = useState(false);
        const [sortBy, setSortBy] = useState("relevance");

        const [favorites, setFavorites] = useState<Record<string, boolean>>({});

        const [filteredBooks, setFilteredBooks] = useState(mockBooks);

        useEffect(() => {
                const initialFavorites: Record<string, boolean> = {};
                mockBooks.forEach(book => {
                        initialFavorites[book.id] = book.isFavorite;
                });
                setFavorites(initialFavorites);
        }, []);

        useEffect(() => {
                let result = [...mockBooks];

                // Apply search filter
                if (searchQuery) {
                        const query = searchQuery.toLowerCase();
                        result = result.filter(book =>
                                book.title.toLowerCase().includes(query) ||
                                book.author.toLowerCase().includes(query) ||
                                book.category?.toLowerCase().includes(query)
                        );
                }

                result = result.filter(book =>
                        book.price >= priceRange[0] && book.price <= priceRange[1]
                );

                if (selectedCategories.length > 0) {
                        result = result.filter(book =>
                                book.category && selectedCategories.includes(book.category)
                        );
                }

                if (selectedRatings.length > 0) {
                        result = result.filter(book =>
                                selectedRatings.some(rating => Math.floor(book.rating || 0) >= rating)
                        );
                }

                if (inStockOnly) {
                        // In a real app, we would filter by stock status
                        // For mock data, we'll just pass through
                }

                if (onSaleOnly) {
                        result = result.filter(book =>
                                book.originalPrice !== undefined && book.originalPrice > book.price
                        );
                }

                // Apply sorting
                switch (sortBy) {
                        case "price-low":
                                result.sort((a, b) => a.price - b.price);
                                break;
                        case "price-high":
                                result.sort((a, b) => b.price - a.price);
                                break;
                        case "rating":
                                result.sort((a, b) => (b.rating || 0) - (a.rating || 0));
                                break;
                        case "newest":
                                // For mock data, we'll keep the original order
                                break;
                        default:
                                // Relevance - keep original order
                                break;
                }

                setFilteredBooks(result);
        }, [searchQuery, priceRange, selectedCategories, selectedRatings, inStockOnly, onSaleOnly, sortBy]);

        // Handle category selection
        const toggleCategory = (category: string) => {
                setSelectedCategories(prev =>
                        prev.includes(category)
                                ? prev.filter(c => c !== category)
                                : [...prev, category]
                );
        };

        // Handle rating selection
        const toggleRating = (rating: number) => {
                setSelectedRatings(prev =>
                        prev.includes(rating)
                                ? prev.filter(r => r !== rating)
                                : [...prev, rating]
                );
        };

        // Handle favorite toggle
        const handleToggleFavorite = (id: string) => {
                setFavorites(prev => ({
                        ...prev,
                        [id]: !prev[id]
                }));
        };

        // Clear all filters
        const clearFilters = () => {
                setSearchQuery("");
                setPriceRange([0, 50]);
                setSelectedCategories([]);
                setSelectedRatings([]);
                setInStockOnly(false);
                setOnSaleOnly(false);
                setSortBy("relevance");
        };

        // Check if any filters are active
        const hasActiveFilters =
                searchQuery !== "" ||
                priceRange[0] > 0 ||
                priceRange[1] < 50 ||
                selectedCategories.length > 0 ||
                selectedRatings.length > 0 ||
                inStockOnly ||
                onSaleOnly;

        return (
                <div className=" container mx-auto px-4 py-8">
                        <div className="lg:mt-12 flex flex-col md:flex-row gap-8">
                                {/* Filters sidebar */}
                                <div className="w-full md:w-64 flex-shrink-0">
                                        <div className="sticky top-24">
                                                <div className="flex items-center justify-between mb-6">
                                                        <h2 className="text-xl font-bold flex items-center gap-2">
                                                                <Filter className="h-5 w-5" />
                                                                Filters
                                                        </h2>
                                                        {hasActiveFilters && (
                                                                <Button
                                                                        variant="ghost"
                                                                        size="sm"
                                                                        onClick={clearFilters}
                                                                        className="text-sm h-8 px-2"
                                                                >
                                                                        Clear all
                                                                </Button>
                                                        )}
                                                </div>

                                                <div className="space-y-6">
                                                        {/* Search */}
                                                        <div>
                                                                <h3 className="font-medium mb-2">Search</h3>
                                                                <Input
                                                                        placeholder="Search books..."
                                                                        value={searchQuery}
                                                                        onChange={(e) => setSearchQuery(e.target.value)}
                                                                        className="w-full"
                                                                />
                                                        </div>

                                                        {/* Price Range */}
                                                        <div>
                                                                <h3 className="font-medium mb-2">Price Range</h3>
                                                                <div className="space-y-4">
                                                                        <Slider
                                                                                min={0}
                                                                                max={50}
                                                                                step={1}
                                                                                value={priceRange}
                                                                                onValueChange={(value) => setPriceRange(value as [number, number])}
                                                                                className="w-full"
                                                                        />
                                                                        <div className="flex justify-between text-sm text-muted-foreground">
                                                                                <span>${priceRange[0]}</span>
                                                                                <span>${priceRange[1]}</span>
                                                                        </div>
                                                                </div>
                                                        </div>

                                                        {/* Categories */}
                                                        <Accordion type="single" collapsible defaultValue="categories">
                                                                <AccordionItem value="categories">
                                                                        <AccordionTrigger className="py-2 font-medium">Categories</AccordionTrigger>
                                                                        <AccordionContent className="pt-0 pb-2">
                                                                                <div className="space-y-2 max-h-60 overflow-y-auto pr-2">
                                                                                        {categories.map((category) => (
                                                                                                <div key={category} className="flex items-center">
                                                                                                        <Checkbox
                                                                                                                id={`category-${category}`}
                                                                                                                checked={selectedCategories.includes(category)}
                                                                                                                onCheckedChange={() => toggleCategory(category)}
                                                                                                        />
                                                                                                        <label
                                                                                                                htmlFor={`category-${category}`}
                                                                                                                className="ml-2 text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
                                                                                                        >
                                                                                                                {category}
                                                                                                        </label>
                                                                                                </div>
                                                                                        ))}
                                                                                </div>
                                                                        </AccordionContent>
                                                                </AccordionItem>
                                                        </Accordion>

                                                        {/* Rating */}
                                                        <Accordion type="single" collapsible defaultValue="rating">
                                                                <AccordionItem value="rating">
                                                                        <AccordionTrigger className="py-2 font-medium">Rating</AccordionTrigger>
                                                                        <AccordionContent className="pt-0 pb-2">
                                                                                <div className="space-y-2">
                                                                                        {ratings.map((rating) => (
                                                                                                <div key={rating} className="flex items-center">
                                                                                                        <Checkbox
                                                                                                                id={`rating-${rating}`}
                                                                                                                checked={selectedRatings.includes(rating)}
                                                                                                                onCheckedChange={() => toggleRating(rating)}
                                                                                                        />
                                                                                                        <label
                                                                                                                htmlFor={`rating-${rating}`}
                                                                                                                className="ml-2 text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 flex items-center"
                                                                                                        >
                                                                                                                <div className="flex items-center mr-1">
                                                                                                                        {[...Array(5)].map((_, i) => (
                                                                                                                                <Star
                                                                                                                                        key={i}
                                                                                                                                        className={`h-4 w-4 ${i < rating ? "fill-yellow-400 text-yellow-400" : "text-muted"}`}
                                                                                                                                />
                                                                                                                        ))}
                                                                                                                </div>
                                                                                                                <span>&amp; Up</span>
                                                                                                        </label>
                                                                                                </div>
                                                                                        ))}
                                                                                </div>
                                                                        </AccordionContent>
                                                                </AccordionItem>
                                                        </Accordion>

                                                        {/* Other Filters */}
                                                        <Accordion type="single" collapsible defaultValue="other">
                                                                <AccordionItem value="other">
                                                                        <AccordionTrigger className="py-2 font-medium">Other</AccordionTrigger>
                                                                        <AccordionContent className="pt-0 pb-2">
                                                                                <div className="space-y-3">
                                                                                        <div className="flex items-center">
                                                                                                <Checkbox
                                                                                                        id="in-stock"
                                                                                                        checked={inStockOnly}
                                                                                                        onCheckedChange={(checked) => setInStockOnly(checked as boolean)}
                                                                                                />
                                                                                                <label
                                                                                                        htmlFor="in-stock"
                                                                                                        className="ml-2 text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
                                                                                                >
                                                                                                        In Stock Only
                                                                                                </label>
                                                                                        </div>
                                                                                        <div className="flex items-center">
                                                                                                <Checkbox
                                                                                                        id="on-sale"
                                                                                                        checked={onSaleOnly}
                                                                                                        onCheckedChange={(checked) => setOnSaleOnly(checked as boolean)}
                                                                                                />
                                                                                                <label
                                                                                                        htmlFor="on-sale"
                                                                                                        className="ml-2 text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
                                                                                                >
                                                                                                        On Sale
                                                                                                </label>
                                                                                        </div>
                                                                                </div>
                                                                        </AccordionContent>
                                                                </AccordionItem>
                                                        </Accordion>
                                                </div>
                                        </div>
                                </div>

                                {/* Main content */}
                                <div className="flex-grow">
                                        {/* Results header */}
                                        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
                                                <div>
                                                        <h1 className="text-2xl font-bold">Books</h1>
                                                        <p className="text-muted-foreground">
                                                                {filteredBooks.length} {filteredBooks.length === 1 ? 'book' : 'books'} found
                                                                {hasActiveFilters && (
                                                                        <span className="ml-2">
                                                                                {' • '}
                                                                                <Button
                                                                                        variant="link"
                                                                                        className="h-auto p-0 ml-1 text-muted-foreground hover:text-foreground"
                                                                                        onClick={clearFilters}
                                                                                >
                                                                                        Clear filters
                                                                                </Button>
                                                                        </span>
                                                                )}
                                                        </p>
                                                </div>

                                                <div className="flex items-center gap-2">
                                                        <label htmlFor="sort" className="text-sm font-medium">
                                                                Sort by:
                                                        </label>
                                                        <select
                                                                id="sort"
                                                                value={sortBy}
                                                                onChange={(e) => setSortBy(e.target.value)}
                                                                className="border rounded-md px-3 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-ring"
                                                        >
                                                                <option value="relevance">Relevance</option>
                                                                <option value="price-low">Price: Low to High</option>
                                                                <option value="price-high">Price: High to Low</option>
                                                                <option value="rating">Top Rated</option>
                                                                <option value="newest">Newest Arrivals</option>
                                                        </select>
                                                </div>
                                        </div>

                                        {/* Results */}
                                        {filteredBooks.length > 0 ? (
                                                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                                                        {filteredBooks.map((book) => (
                                                                <BookCard
                                                                        key={book.id}
                                                                        id={book.id}
                                                                        title={book.title}
                                                                        author={book.author}
                                                                        price={book.price}
                                                                        originalPrice={book.originalPrice}
                                                                        rating={book.rating}
                                                                        reviewCount={book.reviewCount}
                                                                        category={book.category}
                                                                        isFavorite={favorites[book.id] || false}
                                                                        onToggleFavorite={handleToggleFavorite}
                                                                />
                                                        ))}
                                                </div>
                                        ) : (
                                                <div className="flex flex-col items-center justify-center py-16 text-center">
                                                        <div className="bg-gray-200 border-2 border-dashed rounded-xl w-16 h-16 flex items-center justify-center mb-4">
                                                                <span className="text-2xl">📚</span>
                                                        </div>
                                                        <h3 className="text-xl font-semibold mb-2">No books found</h3>
                                                                      <p className="text-muted-foreground mb-4">
                Try adjusting your filters to find what you&apos;re looking for
              </p>
                                                        <Button onClick={clearFilters}>Clear all filters</Button>
                                                </div>
                                        )}
                                </div>
                        </div>
                </div>
        );
}
