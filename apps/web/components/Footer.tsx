import Link from "next/link";
import { Separator } from "@/components/ui/separator";

export function Footer() {
  return (
    <footer className="w-full border-t border-border bg-muted">
      <div className="max-w-6xl mx-auto py-12 md:py-16 lg:py-20 px-6 lg:px-12">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          <div>
            <h3 className="text-lg font-semibold mb-4">BookLab</h3>
            <p className="text-muted-foreground text-sm">
              Your one-stop destination for all kinds of books. Discover, explore, and enjoy
              reading with our vast collection.
            </p>
          </div>
          
          <div>
            <h3 className="text-lg font-semibold mb-4">Quick Links</h3>
            <ul className="space-y-2">
              <li>
                <Link href="/" className="text-muted-foreground hover:text-primary text-sm">
                  Home
                </Link>
              </li>
              <li>
                <Link href="/books" className="text-muted-foreground hover:text-primary text-sm">
                  Books
                </Link>
              </li>
              <li>
                <Link href="/categories" className="text-muted-foreground hover:text-primary text-sm">
                  Categories
                </Link>
              </li>
              <li>
                <Link href="/authors" className="text-muted-foreground hover:text-primary text-sm">
                  Authors
                </Link>
              </li>
            </ul>
          </div>
          
          <div>
            <h3 className="text-lg font-semibold mb-4">Customer Service</h3>
            <ul className="space-y-2">
              <li>
                <Link href="/contact" className="text-muted-foreground hover:text-primary text-sm">
                  Contact Us
                </Link>
              </li>
              <li>
                <Link href="/faq" className="text-muted-foreground hover:text-primary text-sm">
                  FAQ
                </Link>
              </li>
              <li>
                <Link href="/shipping" className="text-muted-foreground hover:text-primary text-sm">
                  Shipping Policy
                </Link>
              </li>
              <li>
                <Link href="/returns" className="text-muted-foreground hover:text-primary text-sm">
                  Returns & Exchanges
                </Link>
              </li>
            </ul>
          </div>
          
          <div>
            <h3 className="text-lg font-semibold mb-4">Contact</h3>
            <ul className="space-y-2 text-muted-foreground text-sm">
              <li>Email: info@booklab.com</li>
              <li>Phone: (123) 456-7890</li>
              <li>Address: 123 Book Street, Library City</li>
            </ul>
          </div>
        </div>
        
        <Separator className="my-8" />
        
        <div className="flex flex-col md:flex-row justify-between items-center gap-4">
          <p className="text-muted-foreground text-sm">
            &copy; {new Date().getFullYear()} BookLab. All rights reserved.
          </p>
          <div className="flex gap-4">
            <Link href="/privacy" className="text-muted-foreground hover:text-primary text-sm">
              Privacy Policy
            </Link>
            <Link href="/terms" className="text-muted-foreground hover:text-primary text-sm">
              Terms of Service
            </Link>
          </div>
        </div>
      </div>
    </footer>
  );
}
