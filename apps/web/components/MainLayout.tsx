import { Navbar } from "@/components/navbar/Navbar";
import { Footer } from "@/components/Footer";
import { NewsletterSection } from "./home/NewsletterSection";

export async function MainLayout({ children }: { children: React.ReactNode }) {
        return (
                <>
                        <Navbar />
                        <main className="min-h-screen pt-30">
                                {children}
                        </main>
                        <NewsletterSection />
                        <Footer />
                </>
        );
}
