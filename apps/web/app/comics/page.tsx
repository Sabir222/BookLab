"use client";

import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { BookOpen, Zap, Star, Shield } from "lucide-react";
import Link from "next/link";

export default function ComicsPage() {
  const popularComicSeries = [
    {
      id: 1,
      title: "Spider-Man",
      publisher: "Marvel",
      issues: 150,
      rating: 4.7,
    },
    {
      id: 2,
      title: "Batman",
      publisher: "DC Comics",
      issues: 120,
      rating: 4.8,
    },
    {
      id: 3,
      title: "The Walking Dead",
      publisher: "Image Comics",
      issues: 193,
      rating: 4.6,
    },
    {
      id: 4,
      title: "Saga",
      publisher: "Image Comics",
      issues: 54,
      rating: 4.8,
    },
    {
      id: 5,
      title: "Watchmen",
      publisher: "DC Comics",
      issues: 12,
      rating: 4.9,
    },
    {
      id: 6,
      title: "Sandman",
      publisher: "DC Comics",
      issues: 75,
      rating: 4.8,
    },
  ];

  const comicPublishers = [
    { name: "Marvel", description: "Home of Spider-Man, X-Men, Avengers" },
    { name: "DC Comics", description: "Batman, Superman, Wonder Woman" },
    { name: "Image Comics", description: "Creator-owned hits like Saga, The Walking Dead" },
    { name: "Dark Horse", description: "Hellboy, Buffy the Vampire Slayer" },
    { name: "IDW Publishing", description: "Transformers, Teenage Mutant Ninja Turtles" },
  ];

  return (
    <div className="container px-4 lg:px-0 py-8 max-w-6xl mx-auto">
      {/* Hero Section */}
      <div className="text-center mb-16">
        <h1 className="text-4xl font-bold tracking-tight mb-4">Comics Collection</h1>
        <p className="text-xl text-muted-foreground max-w-2xl mx-auto mb-8">
          Explore the universe of comic books. From iconic superheroes to groundbreaking indie titles, find your next adventure.
        </p>
        <Button size="lg" asChild>
          <Link href="/category/comics">Browse Comics</Link>
        </Button>
      </div>

      {/* Coming Soon Section */}
      <div className="bg-secondary/10 rounded-xl p-8 mb-16 text-center">
        <div className="max-w-2xl mx-auto">
          <div className="bg-gray-200 border-2 border-dashed rounded-full w-24 h-24 flex items-center justify-center mx-auto mb-6">
            <Shield className="h-12 w-12 text-gray-500" />
          </div>
          <h2 className="text-3xl font-bold mb-4">Comic Store Expansion Coming Soon</h2>
          <p className="text-lg text-muted-foreground mb-6">
            We&apos;re expanding our comic book selection with rare editions, variant covers, 
            and exclusive merchandise from your favorite publishers and creators.
          </p>
          <Badge variant="secondary" className="text-lg py-1 px-4">
            Launching Soon
          </Badge>
        </div>
      </div>

      {/* Features Section */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-16">
        <Card>
          <CardHeader>
            <BookOpen className="h-10 w-10 text-secondary mb-4" />
            <CardTitle>Iconic Characters</CardTitle>
          </CardHeader>
          <CardContent>
            <CardDescription>
              Discover stories featuring Spider-Man, Batman, Superman, and thousands of other beloved characters.
            </CardDescription>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <Star className="h-10 w-10 text-secondary mb-4" />
            <CardTitle>Collector&apos;s Items</CardTitle>
          </CardHeader>
          <CardContent>
            <CardDescription>
              Find rare editions, first issues, and variant covers for your collection.
            </CardDescription>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <Zap className="h-10 w-10 text-secondary mb-4" />
            <CardTitle>Indie Gems</CardTitle>
          </CardHeader>
          <CardContent>
            <CardDescription>
              Support independent creators with groundbreaking stories from Image Comics, Dark Horse, and more.
            </CardDescription>
          </CardContent>
        </Card>
      </div>

      {/* Popular Comics Preview */}
      <div className="mb-16">
        <div className="flex items-center justify-between mb-8">
          <h2 className="text-2xl font-bold tracking-tight">Popular Comic Series</h2>
          <Button variant="outline" asChild>
            <Link href="/category/comics">View All</Link>
          </Button>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {popularComicSeries.map((comic) => (
            <Card key={comic.id} className="transition-all hover:shadow-lg">
              <div className="flex p-6">
                <div className="bg-gray-200 border-2 border-dashed rounded-lg w-24 h-32 flex-shrink-0 flex items-center justify-center mr-4">
                  <span className="text-3xl">📚</span>
                </div>
                <div>
                  <CardTitle className="mb-1">{comic.title}</CardTitle>
                  <CardDescription className="mb-2">{comic.publisher}</CardDescription>
                  <div className="flex items-center text-sm text-muted-foreground mb-2">
                    <Star className="h-4 w-4 fill-yellow-400 text-yellow-400 mr-1" />
                    <span>{comic.rating}</span>
                    <span className="mx-2">•</span>
                    <span>{comic.issues} issues</span>
                  </div>
                  <Button variant="outline" size="sm" disabled>
                    Coming Soon
                  </Button>
                </div>
              </div>
            </Card>
          ))}
        </div>
      </div>

      {/* Comic Publishers */}
      <div className="mb-16">
        <h2 className="text-2xl font-bold tracking-tight mb-8 text-center">Featured Publishers</h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
          {comicPublishers.map((publisher, index) => (
            <Card key={index} className="transition-all hover:shadow-md">
              <CardHeader>
                <CardTitle className="text-lg">{publisher.name}</CardTitle>
              </CardHeader>
              <CardContent>
                <CardDescription>{publisher.description}</CardDescription>
                <Button variant="link" className="p-0 mt-2 h-auto" disabled>
                  Explore {publisher.name}
                </Button>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>

      {/* CTA Section */}
      <div className="bg-primary text-primary-foreground rounded-xl p-8 text-center">
        <h2 className="text-2xl font-bold mb-4">Comic Book Alerts</h2>
        <p className="mb-6 max-w-2xl mx-auto">
          Sign up for notifications about new releases, exclusive variants, and 
          special promotions from your favorite comic publishers.
        </p>
        <div className="flex flex-col sm:flex-row gap-4 justify-center max-w-md mx-auto">
          <input 
            type="email" 
            placeholder="Your email address" 
            className="flex h-10 rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 flex-grow"
          />
          <Button variant="secondary">Get Alerts</Button>
        </div>
      </div>
    </div>
  );
}