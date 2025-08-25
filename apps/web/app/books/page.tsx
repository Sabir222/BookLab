"use client";

import { useState, useEffect } from "react";
import { BookCard } from "@/components/books/BookCard";
import { BookFilters } from "@/components/books/BookFilters";
import { BookResultsHeader } from "@/components/books/BookResultsHeader";
import { EmptyBookResults } from "@/components/books/EmptyBookResults";

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

export default function BooksPage() {
  const [searchQuery, setSearchQuery] = useState("");
  const [priceRange, setPriceRange] = useState<[number, number]>([0, 50]);
  const [selectedCategories, setSelectedCategories] = useState<string[]>([]);
  const [selectedRatings, setSelectedRatings] = useState<number[]>([]);
  const [inStockOnly, setInStockOnly] = useState(false);
  const [onSaleOnly, setOnSaleOnly] = useState(false);
  const [sortBy, setSortBy] = useState("relevance");

  const [filteredBooks, setFilteredBooks] = useState(mockBooks);

  useEffect(() => {
    let result = [...mockBooks];

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

  const clearFilters = () => {
    setSearchQuery("");
    setPriceRange([0, 50]);
    setSelectedCategories([]);
    setSelectedRatings([]);
    setInStockOnly(false);
    setOnSaleOnly(false);
    setSortBy("relevance");
  };

  const hasActiveFilters =
    searchQuery !== "" ||
    priceRange[0] > 0 ||
    priceRange[1] < 50 ||
    selectedCategories.length > 0 ||
    selectedRatings.length > 0 ||
    inStockOnly ||
    onSaleOnly;

  return (
    <div className="pt-28 container mx-auto px-4 py-8">
      <div className="lg:mt-12 flex flex-col md:flex-row gap-8">
        <BookFilters
          searchQuery={searchQuery}
          setSearchQuery={setSearchQuery}
          priceRange={priceRange}
          setPriceRange={setPriceRange}
          selectedCategories={selectedCategories}
          setSelectedCategories={setSelectedCategories}
          selectedRatings={selectedRatings}
          setSelectedRatings={setSelectedRatings}
          inStockOnly={inStockOnly}
          setInStockOnly={setInStockOnly}
          onSaleOnly={onSaleOnly}
          setOnSaleOnly={setOnSaleOnly}
          hasActiveFilters={hasActiveFilters}
          clearFilters={clearFilters}
          categories={categories}
          ratings={ratings}
        />

        {/* Main content */}
        <div className="flex-grow">
          {/* Results header */}
          <BookResultsHeader
            title="Books"
            bookCount={filteredBooks.length}
            hasActiveFilters={hasActiveFilters}
            clearFilters={clearFilters}
            sortBy={sortBy}
            setSortBy={setSortBy}
          />

          {/* Results */}
          {filteredBooks.length > 0 ? (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
              {filteredBooks.map((book) => (
                <BookCard
                  key={book.id}
                  book={{
                    id: book.id,
                    title: book.title,
                    author: book.author,
                    coverImage: '/placeholder-book.png',
                    price: book.price,
                    originalPrice: book.originalPrice,
                    rating: book.rating,
                    reviewCount: book.reviewCount,
                    category: book.category
                  }}
                />
              ))}
            </div>
          ) : (
            <EmptyBookResults onClearFilters={clearFilters} />
          )}
        </div>
      </div>
    </div>
  );
}
