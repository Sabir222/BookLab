"use client";

import Link from "next/link";
import { Button } from "@/components/ui/button";

const categories = [
  {
    name: "Fiction",
    slug: "fiction",
    description: "Explore captivating novels, short stories, and literary works",
    bookCount: 1245,
  },
  {
    name: "Non-Fiction",
    slug: "non-fiction",
    description: "Discover biographies, memoirs, and informative works",
    bookCount: 876,
  },
  {
    name: "Children Books",
    slug: "children-books",
    description: "Delightful stories for young readers and picture books",
    bookCount: 562,
  },
  {
    name: "Kids",
    slug: "kids",
    description: "Books for early readers and middle-grade audiences",
    bookCount: 423,
  },
  {
    name: "Comics",
    slug: "comics",
    description: "Superhero adventures, graphic novels, and illustrated stories",
    bookCount: 389,
  },
  {
    name: "Manga",
    slug: "manga",
    description: "Japanese comics and graphic novels across all genres",
    bookCount: 621,
  },
  {
    name: "Education",
    slug: "education",
    description: "Textbooks, study guides, and educational resources",
    bookCount: 298,
  },
  {
    name: "Lifestyle & Hobbies",
    slug: "lifestyle-hobbies",
    description: "Books on cooking, crafts, wellness, and personal interests",
    bookCount: 354,
  },
];

export default function CategoriesPage() {
  return (
    <div className="container mx-auto px-4 py-8">
      <div className="lg:mt-12">
        <div className="text-center mb-12">
          <h1 className="text-3xl font-bold tracking-tighter sm:text-4xl md:text-5xl">
            Book Categories
          </h1>
          <p className="mt-4 text-lg text-muted-foreground max-w-2xl mx-auto">
            Browse our extensive collection of books organized by category
          </p>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          {categories.map((category) => (
            <Link 
              key={category.slug} 
              href={`/category/${category.slug}`}
              className="group block"
            >
              <div className="rounded-xl p-6 transition-all duration-300 hover:shadow-lg border border-border bg-card">
                <div className="flex flex-col h-full">
                  <div className="flex-grow">
                    <h3 className="text-xl font-bold mb-2 group-hover:text-primary transition-colors">
                      {category.name}
                    </h3>
                    <p className="text-muted-foreground text-sm mb-4">
                      {category.description}
                    </p>
                  </div>
                  <div className="mt-4">
                    <Button 
                      variant="outline" 
                      size="sm" 
                      className="w-full group-hover:bg-primary group-hover:text-primary-foreground"
                    >
                      View {category.bookCount} books
                    </Button>
                  </div>
                </div>
              </div>
            </Link>
          ))}
        </div>
      </div>
    </div>
  );
}