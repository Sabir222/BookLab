"use client";
import { HeroSection } from "@/components/home/HeroSection";
import { MangaPromoSection } from "@/components/home/MangaPromoSection";
import { BestSellersSection } from "@/components/home/BestSellersSection";
import { AuthorsSection } from "@/components/home/AuthorsSection";

export default function Home() {
        return (
                <main className="min-h-screen bg-background">
                        <HeroSection />
                        <div className="py-8">
                                <BestSellersSection />
                                <MangaPromoSection />
                                <AuthorsSection />
                        </div>
                </main>
        );
}
