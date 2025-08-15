"use client";

import { useState } from "react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import { BookOpen, Calendar, MapPin, Award, Users, Heart } from "lucide-react";
import Link from "next/link";

// Mock data for a single author
const authorData = {
  id: 1,
  name: "Stephen King",
  bio: "Stephen Edwin King is an American author of horror, supernatural fiction, suspense, crime, science-fiction, and fantasy novels. His books have sold more than 350 million copies, and many have been adapted into films, television series, miniseries, and comic books.",
  image: "/placeholder-books/book-1.svg",
  birthDate: "September 21, 1947",
  birthPlace: "Portland, Maine, United States",
  genres: ["Horror", "Thriller", "Fantasy", "Suspense", "Supernatural"],
  bookCount: 68,
  followers: "2.5M",
  following: 127,
  awards: 87,
  isFollowing: false,
};

// Mock data for author's books
const authorBooks = [
  {
    id: 1,
    title: "The Shining",
    cover: "/placeholder-books/book-1.svg",
    rating: 4.7,
    publishedYear: 1977,
    pages: 447,
  },
  {
    id: 2,
    title: "It",
    cover: "/placeholder-books/book-2.svg",
    rating: 4.6,
    publishedYear: 1986,
    pages: 1138,
  },
  {
    id: 3,
    title: "The Stand",
    cover: "/placeholder-books/book-3.svg",
    rating: 4.8,
    publishedYear: 1978,
    pages: 1153,
  },
  {
    id: 4,
    title: "Carrie",
    cover: "/placeholder-books/book-4.svg",
    rating: 4.3,
    publishedYear: 1974,
    pages: 199,
  },
  {
    id: 5,
    title: "The Dark Tower",
    cover: "/placeholder-books/book-5.svg",
    rating: 4.5,
    publishedYear: 1982,
    pages: 242,
  },
  {
    id: 6,
    title: "Misery",
    cover: "/placeholder-books/book-1.svg",
    rating: 4.4,
    publishedYear: 1987,
    pages: 310,
  },
];

export default function AuthorDetailPage({ params }: { params: Promise<{ id: string }> }) {
  // Using params to satisfy TypeScript, but not using the id value in this mockup
  const [isFollowing, setIsFollowing] = useState(authorData.isFollowing);

  const toggleFollow = () => {
    setIsFollowing(!isFollowing);
  };

  return (
    <div className="lg:mt-12 container px-4 lg:px-0 py-8 max-w-6xl mx-auto">
      {/* Author Header */}
      <div className="flex flex-col md:flex-row gap-8 mb-12">
        {/* Author Image */}
        <div className="md:w-1/3 flex justify-center">
          <div className="bg-gray-200 border-2 border-dashed rounded-full w-64 h-64 flex items-center justify-center">
            <span className="text-8xl">✍️</span>
          </div>
        </div>

        {/* Author Info */}
        <div className="md:w-2/3">
          <h1 className="text-4xl font-bold tracking-tight mb-4">{authorData.name}</h1>

          <div className="flex flex-wrap gap-2 mb-6">
            {authorData.genres.map((genre) => (
              <Badge key={genre} variant="outline" className="text-base py-1 px-3">
                {genre}
              </Badge>
            ))}
          </div>

          <p className="text-lg text-muted-foreground mb-6 leading-relaxed">
            {authorData.bio}
          </p>

          {/* Stats */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
            <div className="flex items-center">
              <BookOpen className="mr-2 h-5 w-5 text-muted-foreground" />
              <span className="font-medium">{authorData.bookCount} Books</span>
            </div>
            <div className="flex items-center">
              <Users className="mr-2 h-5 w-5 text-muted-foreground" />
              <span className="font-medium">{authorData.followers} Followers</span>
            </div>
            <div className="flex items-center">
              <Award className="mr-2 h-5 w-5 text-muted-foreground" />
              <span className="font-medium">{authorData.awards} Awards</span>
            </div>
            <div className="flex items-center">
              <Heart className="mr-2 h-5 w-5 text-muted-foreground" />
              <span className="font-medium">{authorData.following} Following</span>
            </div>
          </div>

          {/* Author Details */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
            <div className="flex items-center">
              <Calendar className="mr-2 h-5 w-5 text-muted-foreground" />
              <span>Born: {authorData.birthDate}</span>
            </div>
            <div className="flex items-center">
              <MapPin className="mr-2 h-5 w-5 text-muted-foreground" />
              <span>{authorData.birthPlace}</span>
            </div>
          </div>

          {/* Action Buttons */}
          <div className="flex flex-wrap gap-4">
            <Button
              onClick={toggleFollow}
              className={isFollowing ? "bg-secondary text-secondary-foreground" : ""}
              size="lg"
            >
              {isFollowing ? "Following" : "Follow Author"}
            </Button>
            <Button variant="outline" size="lg">
              Share Profile
            </Button>
          </div>
        </div>
      </div>

      <Separator className="my-8" />

      {/* Books by Author */}
      <div className="mb-12">
        <h2 className="text-2xl font-bold tracking-tight mb-6">Books by {authorData.name}</h2>

        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {authorBooks.map((book) => (
            <div
              key={book.id}
              className="border rounded-lg overflow-hidden transition-all hover:shadow-lg"
            >
              <Link href={`/book/${book.id}`} className="block">
                <div className="bg-gray-200 border-2 border-dashed rounded-t-lg w-full h-48 flex items-center justify-center">
                  <span className="text-5xl">📚</span>
                </div>

                <div className="p-4">
                  <h3 className="font-semibold text-lg mb-1 line-clamp-2">{book.title}</h3>

                  <div className="flex items-center text-sm text-muted-foreground mb-2">
                    <span>{book.publishedYear}</span>
                    <span className="mx-2">•</span>
                    <span>{book.pages} pages</span>
                  </div>

                  <div className="flex items-center">
                    <div className="flex text-yellow-500">
                      {'★'.repeat(Math.floor(book.rating))}
                      {'☆'.repeat(5 - Math.floor(book.rating))}
                    </div>
                    <span className="ml-2 text-sm">{book.rating}</span>
                  </div>
                </div>
              </Link>
            </div>
          ))}
        </div>
      </div>

      {/* Additional Sections */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-8 mb-12">
        {/* Awards & Recognition */}
        <div className="border rounded-lg p-6">
          <h3 className="text-xl font-bold mb-4 flex items-center">
            <Award className="mr-2" />
            Awards & Recognition
          </h3>
          <ul className="space-y-2">
            <li className="flex items-start">
              <span className="text-secondary mr-2">•</span>
              <span>National Book Award for Distinguished Contribution to American Letters (2003)</span>
            </li>
            <li className="flex items-start">
              <span className="text-secondary mr-2">•</span>
              <span>Bram Stoker Award for Lifetime Achievement (1989)</span>
            </li>
            <li className="flex items-start">
              <span className="text-secondary mr-2">•</span>
              <span>World Fantasy Award for Life Achievement (2004)</span>
            </li>
            <li className="flex items-start">
              <span className="text-secondary mr-2">•</span>
              <span>Edgar Award for Best Novel (1981) - &quot;The Dead Zone&quot;</span>
            </li>
          </ul>
        </div>

        {/* Similar Authors */}
        <div className="border rounded-lg p-6">
          <h3 className="text-xl font-bold mb-4">Similar Authors</h3>
          <div className="space-y-4">
            {[
              { id: 2, name: "Dean Koontz", books: 95 },
              { id: 3, name: "Peter Straub", books: 28 },
              { id: 4, name: "Joe Hill", books: 12 },
              { id: 5, name: "Owen King", books: 8 }
            ].map((author) => (
              <div key={author.id} className="flex items-center justify-between">
                <div className="flex items-center">
                  <div className="bg-gray-200 border-2 border-dashed rounded-full w-12 h-12 flex items-center justify-center mr-3">
                    <span className="text-lg">✍️</span>
                  </div>
                  <div>
                    <h4 className="font-medium">{author.name}</h4>
                    <p className="text-sm text-muted-foreground">{author.books} books</p>
                  </div>
                </div>
                <Button variant="outline" size="sm">
                  Follow
                </Button>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
