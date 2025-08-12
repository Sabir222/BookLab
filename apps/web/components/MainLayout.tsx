import { Navbar } from "@/components/navbar/Navbar";
import { Footer } from "@/components/Footer";

export function MainLayout({ children }: { children: React.ReactNode }) {
  return (
    <>
      <Navbar />
      <main className="pt-20 min-h-screen">
        {children}
      </main>
      <Footer />
    </>
  );
}