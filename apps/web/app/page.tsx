import { HeroSection } from "@/components/home/HeroSection";
import { MangaPromoSection } from "@/components/home/MangaPromoSection";
import { BestSellersSection } from "@/components/home/BestSellersSection";
import { AuthorsSection } from "@/components/home/AuthorsSection";
import { Calendar } from "@/components/ui/calendar";

export default async function Home() {
        return (
                <main className="pt-20 min-h-screen bg-background">
                        <HeroSection />
                        <div className="py-8">
                                <BestSellersSection />
                                <MangaPromoSection />
                                <AuthorsSection />
                        </div>
                </main>
        );
}
