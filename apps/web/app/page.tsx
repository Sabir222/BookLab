import { HeroSection } from "@/components/home/HeroSection";
import { MangaPromoSection } from "@/components/home/MangaPromoSection";
import { TopRatedBooksSection } from "@/components/home/TopRatedBooksSection";
import { NewReleasesBooksSection } from "@/components/home/NewReleasesBooksSection";
import { PopularBooksSection } from "@/components/home/PopularBooksSection";
import { AuthorsSection } from "@/components/home/AuthorsSection";

export default async function Home() {
        return (
                <main className="pt-20 min-h-screen bg-background">
                        <HeroSection />
                        <NewReleasesBooksSection />
                        <PopularBooksSection />
                        <TopRatedBooksSection />
                        <MangaPromoSection />
                        <AuthorsSection />
                </main>
        );
}
