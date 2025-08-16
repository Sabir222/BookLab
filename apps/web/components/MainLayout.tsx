import { Navbar } from "@/components/navbar/Navbar";
import { Footer } from "@/components/Footer";
import { NewsletterSection } from "./home/NewsletterSection";
import { getServerAuth } from "@/lib/auth";
import { AuthHydrator } from "./AuthHydrator";

export async function MainLayout({ children }: { children: React.ReactNode }) {

        const user = await getServerAuth()
        return (
                <>
                        <Navbar />
                        <AuthHydrator user={user} />
                        <main className="min-h-screen pt-30">
                                {children}
                        </main>
                        <NewsletterSection />
                        <Footer />
                </>
        );
}
