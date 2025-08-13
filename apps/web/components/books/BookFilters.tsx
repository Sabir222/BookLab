"use client";

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

interface BookFiltersProps {
  searchQuery: string;
  setSearchQuery: (query: string) => void;
  priceRange: [number, number];
  setPriceRange: (range: [number, number]) => void;
  selectedCategories: string[];
  setSelectedCategories: (categories: string[]) => void;
  selectedRatings: number[];
  setSelectedRatings: (ratings: number[]) => void;
  inStockOnly: boolean;
  setInStockOnly: (value: boolean) => void;
  onSaleOnly: boolean;
  setOnSaleOnly: (value: boolean) => void;
  hasActiveFilters: boolean;
  clearFilters: () => void;
  categories: string[];
  ratings: number[];
}

export function BookFilters({
  searchQuery,
  setSearchQuery,
  priceRange,
  setPriceRange,
  selectedCategories,
  setSelectedCategories,
  selectedRatings,
  setSelectedRatings,
  inStockOnly,
  setInStockOnly,
  onSaleOnly,
  setOnSaleOnly,
  hasActiveFilters,
  clearFilters,
  categories,
  ratings
}: BookFiltersProps) {
  // Handle category selection
  const toggleCategory = (category: string) => {
    setSelectedCategories(
      selectedCategories.includes(category)
        ? selectedCategories.filter(c => c !== category)
        : [...selectedCategories, category]
    );
  };

  // Handle rating selection
  const toggleRating = (rating: number) => {
    setSelectedRatings(
      selectedRatings.includes(rating)
        ? selectedRatings.filter(r => r !== rating)
        : [...selectedRatings, rating]
    );
  };

  return (
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
  );
}