import { Navbar } from "@/components/navbar/Navbar";
import { Footer } from "@/components/Footer";

export function MainLayout({ children }: { children: React.ReactNode }) {
  return (
    <>
      <Navbar />
      <main className="min-h-screen pt-20">
        {children}
      </main>
      <Footer />
    </>
  );
}
