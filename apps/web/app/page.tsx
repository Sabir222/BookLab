"use client";

import { BestSellersSection } from "@/components/home/BestSellersSection";
import { NewReleasesSection } from "@/components/home/NewReleasesSection";
import { TrendingNowSection } from "@/components/home/TrendingNowSection";
import { FantasySciFiSection } from "@/components/home/FantasySciFiSection";
import { NewsletterSection } from "@/components/home/NewsletterSection";

export default function Home() {
        return (
                <main className="min-h-screen bg-background">
                        <div className="py-8">
                                <h1 className="mb-8 mx-4 text-3xl md:text-4xl md:mt-4 mt-0 font-bold text-center">Discover Your Next Read</h1>

                                <BestSellersSection />
                                <NewReleasesSection />
                                <TrendingNowSection />
                                <FantasySciFiSection />
                                <NewsletterSection />
                        </div>
                </main>
        );
}
