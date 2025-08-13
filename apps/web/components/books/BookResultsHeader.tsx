"use client";

import { Button } from "@/components/ui/button";

interface BookResultsHeaderProps {
  title: string;
  bookCount: number;
  hasActiveFilters: boolean;
  clearFilters: () => void;
  sortBy: string;
  setSortBy: (value: string) => void;
}

export function BookResultsHeader({
  title,
  bookCount,
  hasActiveFilters,
  clearFilters,
  sortBy,
  setSortBy
}: BookResultsHeaderProps) {
  return (
    <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
      <div>
        <h1 className="text-2xl font-bold">{title}</h1>
        <p className="text-muted-foreground">
          {bookCount} {bookCount === 1 ? 'book' : 'books'} found
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
  );
}