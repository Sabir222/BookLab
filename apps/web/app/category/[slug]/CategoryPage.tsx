"use client";

import React, { useState, useEffect } from "react";
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
    category: "Fiction",
    isFavorite: false,
  },
  {
    id: "4",
    title: "Pride and Prejudice",
    author: "Jane Austen",
    price: 11.99,
    rating: 4.6,
    reviewCount: 180,
    category: "Fiction",
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
    category: "Fiction",
    isFavorite: false,
  },
  {
    id: "7",
    title: "Sapiens: A Brief History of Humankind",
    author: "Yuval Noah Harari",
    price: 16.99,
    rating: 4.7,
    reviewCount: 250,
    category: "Non-Fiction",
    isFavorite: false,
  },
  {
    id: "8",
    title: "Educated",
    author: "Tara Westover",
    price: 15.99,
    rating: 4.6,
    reviewCount: 190,
    category: "Non-Fiction",
    isFavorite: true,
  },
  {
    id: "9",
    title: "Where the Crawdads Sing",
    author: "Delia Owens",
    price: 14.99,
    originalPrice: 18.99,
    rating: 4.5,
    reviewCount: 320,
    category: "Fiction",
    isFavorite: false,
  },
  {
    id: "10",
    title: "The Silent Patient",
    author: "Alex Michaelides",
    price: 13.99,
    rating: 4.4,
    reviewCount: 180,
    category: "Fiction",
    isFavorite: false,
  },
  {
    id: "11",
    title: "Becoming",
    author: "Michelle Obama",
    price: 17.99,
    rating: 4.8,
    reviewCount: 420,
    category: "Non-Fiction",
    isFavorite: true,
  },
  {
    id: "12",
    title: "The Very Hungry Caterpillar",
    author: "Eric Carle",
    price: 8.99,
    rating: 4.9,
    reviewCount: 550,
    category: "Children Books",
    isFavorite: false,
  },
  {
    id: "13",
    title: "Where the Wild Things Are",
    author: "Maurice Sendak",
    price: 9.99,
    rating: 4.8,
    reviewCount: 320,
    category: "Children Books",
    isFavorite: false,
  },
  {
    id: "14",
    title: "Goodnight Moon",
    author: "Margaret Wise Brown",
    price: 7.99,
    rating: 4.7,
    reviewCount: 410,
    category: "Children Books",
    isFavorite: true,
  },
  {
    id: "15",
    title: "The Cat in the Hat",
    author: "Dr. Seuss",
    price: 8.99,
    rating: 4.8,
    reviewCount: 380,
    category: "Children Books",
    isFavorite: false,
  },
  {
    id: "16",
    title: "Diary of a Wimpy Kid",
    author: "Jeff Kinney",
    price: 10.99,
    rating: 4.6,
    reviewCount: 290,
    category: "Kids",
    isFavorite: false,
  },
  {
    id: "17",
    title: "Dog Man Series",
    author: "Dav Pilkey",
    price: 11.99,
    rating: 4.7,
    reviewCount: 250,
    category: "Kids",
    isFavorite: true,
  },
  {
    id: "18",
    title: "Naruto Vol. 1",
    author: "Masashi Kishimoto",
    price: 9.99,
    rating: 4.9,
    reviewCount: 850,
    category: "Comics",
    isFavorite: false,
  },
  {
    id: "19",
    title: "One Piece Vol. 1",
    author: "Eiichiro Oda",
    price: 9.99,
    rating: 4.8,
    reviewCount: 720,
    category: "Comics",
    isFavorite: false,
  },
  {
    id: "20",
    title: "Attack on Titan Vol. 1",
    author: "Hajime Isayama",
    price: 10.99,
    rating: 4.9,
    reviewCount: 920,
    category: "Comics",
    isFavorite: true,
  },
  {
    id: "21",
    title: "Death Note Vol. 1",
    author: "Tsugumi Ohba",
    price: 10.99,
    rating: 4.8,
    reviewCount: 680,
    category: "Comics",
    isFavorite: false,
  },
  {
    id: "22",
    title: "Demon Slayer Vol. 1",
    author: "Koyoharu Gotouge",
    price: 9.99,
    rating: 4.9,
    reviewCount: 750,
    category: "Manga",
    isFavorite: true,
  },
  {
    id: "23",
    title: "My Hero Academia Vol. 1",
    author: "Kohei Horikoshi",
    price: 9.99,
    rating: 4.8,
    reviewCount: 620,
    category: "Manga",
    isFavorite: false,
  },
  {
    id: "24",
    title: "Jujutsu Kaisen Vol. 1",
    author: "Gege Akutami",
    price: 9.99,
    rating: 4.9,
    reviewCount: 580,
    category: "Manga",
    isFavorite: false,
  },
  {
    id: "25",
    title: "Chainsaw Man Vol. 1",
    author: "Tatsuki Fujimoto",
    price: 9.99,
    rating: 4.8,
    reviewCount: 520,
    category: "Manga",
    isFavorite: true,
  },
  {
    id: "26",
    title: "The Art of War",
    author: "Sun Tzu",
    price: 8.99,
    rating: 4.6,
    reviewCount: 320,
    category: "Education",
    isFavorite: false,
  },
  {
    id: "27",
    title: "How to Win Friends and Influence People",
    author: "Dale Carnegie",
    price: 12.99,
    rating: 4.7,
    reviewCount: 450,
    category: "Education",
    isFavorite: true,
  },
  {
    id: "28",
    title: "Atomic Habits",
    author: "James Clear",
    price: 14.99,
    rating: 4.8,
    reviewCount: 620,
    category: "Education",
    isFavorite: false,
  },
  {
    id: "29",
    title: "Thinking, Fast and Slow",
    author: "Daniel Kahneman",
    price: 16.99,
    rating: 4.6,
    reviewCount: 380,
    category: "Education",
    isFavorite: false,
  },
  {
    id: "30",
    title: "The 7 Habits of Highly Effective People",
    author: "Stephen R. Covey",
    price: 15.99,
    rating: 4.7,
    reviewCount: 420,
    category: "Education",
    isFavorite: true,
  },
  {
    id: "31",
    title: "The Joy of Cooking",
    author: "Irma S. Rombauer",
    price: 24.99,
    rating: 4.8,
    reviewCount: 280,
    category: "Lifestyle & Hobbies",
    isFavorite: false,
  },
  {
    id: "32",
    title: "The Life-Changing Magic of Tidying Up",
    author: "Marie Kondo",
    price: 13.99,
    rating: 4.5,
    reviewCount: 320,
    category: "Lifestyle & Hobbies",
    isFavorite: true,
  },
  {
    id: "33",
    title: "The Subtle Art of Not Giving a F*ck",
    author: "Mark Manson",
    price: 14.99,
    rating: 4.4,
    reviewCount: 450,
    category: "Lifestyle & Hobbies",
    isFavorite: false,
  },
  {
    id: "34",
    title: "Becoming Wild",
    author: "Carl Safina",
    price: 16.99,
    rating: 4.7,
    reviewCount: 180,
    category: "Lifestyle & Hobbies",
    isFavorite: false,
  },
];

const categories = ["Fiction", "Non-Fiction", "Children Books", "Kids", "Comics", "Manga", "Education", "Lifestyle & Hobbies"];
const ratings = [4, 3, 2, 1];

// Map URL slugs to category names
const slugToCategoryMap: Record<string, string> = {
  "fiction": "Fiction",
  "non-fiction": "Non-Fiction",
  "children-books": "Children Books",
  "kids": "Kids",
  "comics": "Comics",
  "manga": "Manga",
  "education": "Education",
  "lifestyle-hobbies": "Lifestyle & Hobbies"
};

export function CategoryPage({ params }: { params: Promise<{ slug: string }> }) {
  const [categoryName, setCategoryName] = useState("Category");
  const [searchQuery, setSearchQuery] = useState("");
  const [priceRange, setPriceRange] = useState<[number, number]>([0, 50]);
  const [selectedCategories, setSelectedCategories] = useState<string[]>([categoryName]);
  const [selectedRatings, setSelectedRatings] = useState<number[]>([]);
  const [inStockOnly, setInStockOnly] = useState(false);
  const [onSaleOnly, setOnSaleOnly] = useState(false);
  const [sortBy, setSortBy] = useState("relevance");

  const [filteredBooks, setFilteredBooks] = useState(mockBooks);

  useEffect(() => {
    const fetchCategoryName = async () => {
      const { slug: categorySlug } = await params;
      const name = slugToCategoryMap[categorySlug] || "Category";
      setCategoryName(name);
      setSelectedCategories([name]);
    };
    
    fetchCategoryName();
  }, [params]);

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

    // Filter by the current category (always applied)
    result = result.filter(book => book.category === categoryName);

    result = result.filter(book =>
      book.price >= priceRange[0] && book.price <= priceRange[1]
    );

    if (selectedCategories.length > 0) {
      result = result.filter(book =>
        selectedCategories.includes(book.category || "")
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
  }, [searchQuery, priceRange, selectedCategories, selectedRatings, inStockOnly, onSaleOnly, sortBy, categoryName]);

  // Clear all filters (except the current category)
  const clearFilters = () => {
    setSearchQuery("");
    setPriceRange([0, 50]);
    setSelectedCategories([categoryName]);
    setSelectedRatings([]);
    setInStockOnly(false);
    setOnSaleOnly(false);
    setSortBy("relevance");
  };

  // Check if any filters are active (excluding the current category)
  const hasActiveFilters =
    searchQuery !== "" ||
    priceRange[0] > 0 ||
    priceRange[1] < 50 ||
    selectedRatings.length > 0 ||
    inStockOnly ||
    onSaleOnly;

  return (
    <div className=" container mx-auto px-4 py-8">
      <div className="lg:mt-12 flex flex-col md:flex-row gap-8">
        {/* Filters sidebar */}
        <BookFilters
          searchQuery={searchQuery}
          setSearchQuery={setSearchQuery}
          priceRange={priceRange}
          setPriceRange={setPriceRange}
          selectedCategories={selectedCategories}
          setSelectedCategories={(categories) => {
            // Don't allow deselecting the current category
            if (!categories.includes(categoryName)) {
              setSelectedCategories([...categories, categoryName]);
            } else {
              setSelectedCategories(categories);
            }
          }}
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
            title={categoryName}
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
                    book_id: book.id,
                    title: book.title,
                    subtitle: null,
                    description: "",
                    isbn_13: "",
                    isbn_10: "",
                    publication_date: "",
                    published_year: null,
                    page_count: null,
                    language: "",
                    cover_image_url: "",
                    cover_image_small_url: "",
                    cover_image_medium_url: "",
                    cover_image_large_url: "",
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
                    average_rating: book.rating?.toString() || "0",
                    total_ratings: book.reviewCount || 0,
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
                    author_name: book.author || "Unknown Author",
                    categories: book.category ? [{ category_id: "1", category_name: book.category }] : [],
                    genres: [],
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