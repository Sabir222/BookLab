"use client";

import { HeroSection } from "@/components/home/HeroSection";
import { MangaPromoSection } from "@/components/home/MangaPromoSection";
import { PopularBooksSection } from "@/components/home/PopularBooksSection";
import { BestSellersSection } from "@/components/home/BestSellersSection";
import { NewReleasesSection } from "@/components/home/NewReleasesSection";
import { TrendingNowSection } from "@/components/home/TrendingNowSection";
import { FantasySciFiSection } from "@/components/home/FantasySciFiSection";
import { AuthorsSection } from "@/components/home/AuthorsSection";

export default function Home() {
        return (
                <main className="min-h-screen bg-background">
                        <HeroSection />
                        <div className="py-8">
                                <TrendingNowSection />
                                <NewReleasesSection />
                                <BestSellersSection />
                                <MangaPromoSection />
                                <PopularBooksSection />
                                <FantasySciFiSection />
                                <AuthorsSection />
                        </div>
                </main>
        );
}
