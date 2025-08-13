"use client";

import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { BookOpen, Heart, Users, Star, Zap } from "lucide-react";
import Link from "next/link";

export default function MangaPage() {
  const popularMangaSeries = [
    {
      id: 1,
      title: "One Piece",
      author: "Eiichiro Oda",
      volumes: 100,
      rating: 4.9,
    },
    {
      id: 2,
      title: "Naruto",
      author: "Masashi Kishimoto",
      volumes: 72,
      rating: 4.8,
    },
    {
      id: 3,
      title: "Attack on Titan",
      author: "Hajime Isayama",
      volumes: 34,
      rating: 4.9,
    },
    {
      id: 4,
      title: "Demon Slayer",
      author: "Koyoharu Gotouge",
      volumes: 23,
      rating: 4.8,
    },
    {
      id: 5,
      title: "My Hero Academia",
      author: "Kohei Horikoshi",
      volumes: 35,
      rating: 4.7,
    },
    {
      id: 6,
      title: "Jujutsu Kaisen",
      author: "Gege Akutami",
      volumes: 16,
      rating: 4.8,
    },
  ];

  const mangaGenres = [
    { name: "Shonen", description: "Action-adventure aimed at young boys" },
    { name: "Shojo", description: "Romance and relationships aimed at young girls" },
    { name: "Seinen", description: "Mature themes for adult men" },
    { name: "Josei", description: "Realistic romance for adult women" },
    { name: "Mecha", description: "Stories featuring robots and machines" },
    { name: "Isekai", description: "Transported to another world" },
  ];

  return (
    <div className="container px-4 lg:px-0 py-8 max-w-6xl mx-auto">
      {/* Hero Section */}
      <div className="text-center mb-16">
        <h1 className="text-4xl font-bold tracking-tight mb-4">Manga Collection</h1>
        <p className="text-xl text-muted-foreground max-w-2xl mx-auto mb-8">
          Dive into the vibrant world of Japanese comics. Discover epic adventures, heartfelt romances, and everything in between.
        </p>
        <Button size="lg" asChild>
          <Link href="/category/manga">Explore Manga</Link>
        </Button>
      </div>

      {/* Coming Soon Section */}
      <div className="bg-secondary/10 rounded-xl p-8 mb-16 text-center">
        <div className="max-w-2xl mx-auto">
          <div className="bg-gray-200 border-2 border-dashed rounded-full w-24 h-24 flex items-center justify-center mx-auto mb-6">
            <Zap className="h-12 w-12 text-gray-500" />
          </div>
          <h2 className="text-3xl font-bold mb-4">Expanded Manga Store Coming Soon</h2>
          <p className="text-lg text-muted-foreground mb-6">
            We're working on an enhanced manga shopping experience with exclusive editions, 
            limited releases, and a wider selection of publishers from Japan and beyond.
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
            <CardTitle>Official Translations</CardTitle>
          </CardHeader>
          <CardContent>
            <CardDescription>
              Read your favorite manga in officially translated editions from trusted publishers.
            </CardDescription>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <Star className="h-10 w-10 text-secondary mb-4" />
            <CardTitle>Latest Releases</CardTitle>
          </CardHeader>
          <CardContent>
            <CardDescription>
              Stay up to date with the newest chapters and volumes as soon as they're available.
            </CardDescription>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <Heart className="h-10 w-10 text-secondary mb-4" />
            <CardTitle>Community</CardTitle>
          </CardHeader>
          <CardContent>
            <CardDescription>
              Connect with fellow manga fans, share recommendations, and discuss your favorite series.
            </CardDescription>
          </CardContent>
        </Card>
      </div>

      {/* Popular Manga Preview */}
      <div className="mb-16">
        <div className="flex items-center justify-between mb-8">
          <h2 className="text-2xl font-bold tracking-tight">Popular Manga Series</h2>
          <Button variant="outline" asChild>
            <Link href="/category/manga">View All</Link>
          </Button>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {popularMangaSeries.map((manga) => (
            <Card key={manga.id} className="transition-all hover:shadow-lg">
              <div className="flex p-6">
                <div className="bg-gray-200 border-2 border-dashed rounded-lg w-24 h-32 flex-shrink-0 flex items-center justify-center mr-4">
                  <span className="text-3xl">📚</span>
                </div>
                <div>
                  <CardTitle className="mb-1">{manga.title}</CardTitle>
                  <CardDescription className="mb-2">by {manga.author}</CardDescription>
                  <div className="flex items-center text-sm text-muted-foreground mb-2">
                    <Star className="h-4 w-4 fill-yellow-400 text-yellow-400 mr-1" />
                    <span>{manga.rating}</span>
                    <span className="mx-2">•</span>
                    <span>{manga.volumes} volumes</span>
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

      {/* Manga Genres */}
      <div className="mb-16">
        <h2 className="text-2xl font-bold tracking-tight mb-8 text-center">Explore by Genre</h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
          {mangaGenres.map((genre, index) => (
            <Card key={index} className="transition-all hover:shadow-md">
              <CardHeader>
                <CardTitle className="text-lg">{genre.name}</CardTitle>
              </CardHeader>
              <CardContent>
                <CardDescription>{genre.description}</CardDescription>
                <Button variant="link" className="p-0 mt-2 h-auto" disabled>
                  Explore {genre.name}
                </Button>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>

      {/* CTA Section */}
      <div className="bg-primary text-primary-foreground rounded-xl p-8 text-center">
        <h2 className="text-2xl font-bold mb-4">Get Manga Updates</h2>
        <p className="mb-6 max-w-2xl mx-auto">
          Subscribe to our newsletter to receive notifications about new manga releases, 
          exclusive merchandise, and upcoming events.
        </p>
        <div className="flex flex-col sm:flex-row gap-4 justify-center max-w-md mx-auto">
          <input 
            type="email" 
            placeholder="Your email address" 
            className="flex h-10 rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 flex-grow"
          />
          <Button variant="secondary">Subscribe</Button>
        </div>
      </div>
    </div>
  );
}