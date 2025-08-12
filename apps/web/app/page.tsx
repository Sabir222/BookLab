"use client";

import { PopularBooksSection } from "@/components/home/PopularBooksSection";
import { BestSellersSection } from "@/components/home/BestSellersSection";
import { NewReleasesSection } from "@/components/home/NewReleasesSection";
import { TrendingNowSection } from "@/components/home/TrendingNowSection";
import { FantasySciFiSection } from "@/components/home/FantasySciFiSection";

export default function Home() {
  return (
    <main className="min-h-screen bg-background">
      <div className="py-8">
        <h1 className="mb-8 text-3xl font-bold text-center">Discover Your Next Read</h1>
        
        <PopularBooksSection />
        <BestSellersSection />
        <NewReleasesSection />
        <TrendingNowSection />
        <FantasySciFiSection />
      </div>
    </main>
  );
}
