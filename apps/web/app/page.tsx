import { HeroSection } from "@/components/home/HeroSection";
import { MangaPromoSection } from "@/components/home/MangaPromoSection";
import { TopRatedBooksSection } from "@/components/home/TopRatedBooksSection";
import { AuthorsSection } from "@/components/home/AuthorsSection";

export default async function Home() {
        return (
                <main className="pt-20 min-h-screen bg-background">
                        <HeroSection />
                        <div className="py-8">
                                <TopRatedBooksSection />
                                <MangaPromoSection />
                                <AuthorsSection />
                        </div>
                </main>
        );
}
