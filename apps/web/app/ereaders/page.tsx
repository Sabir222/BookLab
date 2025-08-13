"use client";

import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { BookOpen, Tablet, Smartphone, Battery, Sun, Download } from "lucide-react";
import Link from "next/link";

export default function EreadersPage() {
  const featuredEreaders = [
    {
      id: 1,
      name: "Kindle Paperwhite",
      description: "High-resolution display with adjustable warm light",
      features: ["300 PPI", "Waterproof", "8 weeks battery"],
      price: "$139.99",
    },
    {
      id: 2,
      name: "Kobo Clara 2E",
      description: "Sustainable ereader with ComfortLight PRO",
      features: ["300 PPI", "Eco-friendly", "8 weeks battery"],
      price: "$119.99",
    },
    {
      id: 3,
      name: "Nook GlowLight 4",
      description: "Sleek design with warm light technology",
      features: ["300 PPI", "Waterproof", "6 weeks battery"],
      price: "$129.99",
    },
  ];

  return (
    <div className="container px-4 lg:px-0 py-8 max-w-6xl mx-auto">
      {/* Hero Section */}
      <div className="text-center mb-16">
        <h1 className="text-4xl font-bold tracking-tight mb-4">Ereaders Collection</h1>
        <p className="text-xl text-muted-foreground max-w-2xl mx-auto mb-8">
          Discover the perfect ereader for your reading journey. Experience books like never before with our curated selection of devices.
        </p>
        <Button size="lg" asChild>
          <Link href="/category/ereaders">Shop All Ereaders</Link>
        </Button>
      </div>

      {/* Coming Soon Section */}
      <div className="bg-secondary/10 rounded-xl p-8 mb-16 text-center">
        <div className="max-w-2xl mx-auto">
          <div className="bg-gray-200 border-2 border-dashed rounded-full w-24 h-24 flex items-center justify-center mx-auto mb-6">
            <Tablet className="h-12 w-12 text-gray-500" />
          </div>
          <h2 className="text-3xl font-bold mb-4">Ereader Store Coming Soon</h2>
          <p className="text-lg text-muted-foreground mb-6">
            We're working hard to bring you the best selection of ereaders and accessories. 
            Our digital bookstore will feature the latest devices from Kindle, Kobo, Nook, and more.
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
            <CardTitle>Massive Library</CardTitle>
          </CardHeader>
          <CardContent>
            <CardDescription>
              Access millions of books, magazines, and newspapers from our growing digital library.
            </CardDescription>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <Sun className="h-10 w-10 text-secondary mb-4" />
            <CardTitle>Reading Anywhere</CardTitle>
          </CardHeader>
          <CardContent>
            <CardDescription>
              High-resolution displays with adjustable lighting for comfortable reading in any environment.
            </CardDescription>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <Battery className="h-10 w-10 text-secondary mb-4" />
            <CardTitle>Long Battery Life</CardTitle>
          </CardHeader>
          <CardContent>
            <CardDescription>
              Weeks of reading on a single charge, so you never miss a moment of your story.
            </CardDescription>
          </CardContent>
        </Card>
      </div>

      {/* Featured Ereaders Preview */}
      <div className="mb-16">
        <h2 className="text-2xl font-bold tracking-tight mb-8 text-center">Popular Ereaders</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {featuredEreaders.map((ereader) => (
            <Card key={ereader.id} className="overflow-hidden transition-all hover:shadow-lg">
              <div className="bg-gray-200 border-2 border-dashed w-full h-48 flex items-center justify-center">
                <Tablet className="h-16 w-16 text-gray-500" />
              </div>
              <CardHeader>
                <CardTitle>{ereader.name}</CardTitle>
                <CardDescription>{ereader.description}</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="flex flex-wrap gap-2 mb-4">
                  {ereader.features.map((feature, index) => (
                    <Badge key={index} variant="outline">
                      {feature}
                    </Badge>
                  ))}
                </div>
                <div className="flex items-center justify-between">
                  <span className="text-lg font-semibold">{ereader.price}</span>
                  <Button variant="outline" disabled>Coming Soon</Button>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>

      {/* CTA Section */}
      <div className="bg-primary text-primary-foreground rounded-xl p-8 text-center">
        <h2 className="text-2xl font-bold mb-4">Get Notified When We Launch</h2>
        <p className="mb-6 max-w-2xl mx-auto">
          Join our mailing list to be the first to know when our ereader store goes live and receive exclusive offers.
        </p>
        <div className="flex flex-col sm:flex-row gap-4 justify-center max-w-md mx-auto">
          <input 
            type="email" 
            placeholder="Your email address" 
            className="flex h-10 rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 flex-grow"
          />
          <Button variant="secondary">Notify Me</Button>
        </div>
      </div>
    </div>
  );
}