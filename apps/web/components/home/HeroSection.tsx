"use client";

import { Button } from "@/components/ui/button";
import Link from "next/link";

export function HeroSection() {
        return (
                <section className="w-full py-6 lg:mt-20" style={{ backgroundColor: "#113E21" }}>
                        <div className="container mx-auto px-4">
                                <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 items-center">
                                        <div className="flex flex-col justify-center text-white">
                                                <div className="space-y-4">
                                                        <h1 className="text-3xl font-bold tracking-tighter sm:text-4xl md:text-5xl lg:text-6xl">
                                                                Discover Your Next Great Read
                                                        </h1>
                                                        <p className="max-w-[700px] text-green-100 md:text-xl">
                                                                Explore thousands of books across all genres. Find your next favorite author and story.
                                                        </p>
                                                        <div className="flex flex-col sm:flex-row gap-4 pt-4">
                                                                <Button asChild size="lg" className="bg-white text-green-900 hover:bg-green-100">
                                                                        <Link href="/books">Browse Books</Link>
                                                                </Button>
                                                                <Button asChild variant="outline" size="lg" className="border-white text-white hover:bg-white/10">
                                                                        <Link href="/authors">Meet Authors</Link>
                                                                </Button>
                                                        </div>
                                                </div>
                                        </div>

                                        <div className="flex justify-center">
                                                <div className="relative w-full max-w-md">
                                                        <div className="bg-white/10 border-2 border-white/20 rounded-xl w-full h-64 flex items-center justify-center">
                                                                <span className="text-6xl text-white">📚</span>
                                                        </div>
                                                </div>
                                        </div>
                                </div>
                        </div>
                </section>
        );
}
