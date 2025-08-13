"use client";
import Link from "next/link";

import { Button } from "@/components/ui/button";
import { Bookmark, User, ChevronDown, ChevronRight } from "lucide-react";
import { useNavbarStore } from "./navbarStore";
import { useState } from "react";

const navigationItems = [
  { title: "Book Categories" },
  { title: "Comics" },
  { title: "Manga" },
  { title: "Ereaders" },
];

const bookCategories = [
  {
    title: "Main Categories",
    items: [
      { title: "Fiction", href: "/category/fiction" },
      { title: "Non-Fiction", href: "/category/non-fiction" },
      { title: "Children Books", href: "/category/children-books" },
      { title: "Kids", href: "/category/kids" },
    ]
  },
  {
    title: "Special Categories",
    items: [
      { title: "Education", href: "/category/education" },
      { title: "Lifestyle & Hobbies", href: "/category/lifestyle-hobbies" },
      { title: "All Categories", href: "/category" },
    ]
  },
  {
    title: "Popular Genres",
    items: [
      { title: "Bestsellers", href: "/bestsellers" },
      { title: "Award-Winning Books", href: "/awards" },
      { title: "Trending on BookTok", href: "/trending" },
    ]
  }
];

const comicsCategories = [
  {
    title: "Publishers",
    items: [
      { title: "Marvel", href: "/category/comics/marvel" },
      { title: "DC Comics", href: "/category/comics/dc" },
      { title: "Image Comics", href: "/category/comics/image" },
      { title: "Dark Horse", href: "/category/comics/dark-horse" },
      { title: "IDW Publishing", href: "/category/comics/idw" },
    ]
  },
  {
    title: "Genres",
    items: [
      { title: "Superhero", href: "/category/comics/genres/superhero" },
      { title: "Fantasy", href: "/category/comics/genres/fantasy" },
      { title: "Sci-Fi", href: "/category/comics/genres/sci-fi" },
      { title: "Horror", href: "/category/comics/genres/horror" },
      { title: "Manga Style", href: "/category/comics/genres/manga-style" },
    ]
  },
  {
    title: "Popular Series",
    items: [
      { title: "Spider-Man", href: "/category/comics/series/spider-man" },
      { title: "Batman", href: "/category/comics/series/batman" },
      { title: "X-Men", href: "/category/comics/series/x-men" },
      { title: "Avengers", href: "/category/comics/series/avengers" },
      { title: "Watchmen", href: "/category/comics/series/watchmen" },
    ]
  }
];

const mangaCategories = [
  {
    title: "Genres",
    items: [
      { title: "Shonen", href: "/category/manga/genres/shonen" },
      { title: "Shojo", href: "/category/manga/genres/shojo" },
      { title: "Seinen", href: "/category/manga/genres/seinen" },
      { title: "Josei", href: "/category/manga/genres/josei" },
      { title: "Kodomo", href: "/category/manga/genres/kodomo" },
    ]
  },
  {
    title: "Popular Titles",
    items: [
      { title: "One Piece", href: "/category/manga/titles/one-piece" },
      { title: "Naruto", href: "/category/manga/titles/naruto" },
      { title: "Demon Slayer", href: "/category/manga/titles/demon-slayer" },
      { title: "Attack on Titan", href: "/category/manga/titles/attack-on-titan" },
      { title: "My Hero Academia", href: "/category/manga/titles/my-hero-academia" },
    ]
  },
  {
    title: "Publishers",
    items: [
      { title: "Shueisha", href: "/category/manga/publishers/shueisha" },
      { title: "Kodansha", href: "/category/manga/publishers/kodansha" },
      { title: "Viz Media", href: "/category/manga/publishers/viz-media" },
      { title: "Dark Horse", href: "/category/manga/publishers/dark-horse" },
      { title: "Seven Seas", href: "/category/manga/publishers/seven-seas" },
    ]
  }
];

const ereaderCategories = [
  {
    title: "Ereader Devices",
    items: [
      { title: "Kindle", href: "/category/ereaders/kindle" },
      { title: "Kobo", href: "/category/ereaders/kobo" },
      { title: "Nook", href: "/category/ereaders/nook" },
      { title: "iPad", href: "/category/ereaders/ipad" },
      { title: "Android Tablets", href: "/category/ereaders/android-tablets" },
    ]
  },
  {
    title: "Ereader Accessories",
    items: [
      { title: "Cases", href: "/category/ereaders/accessories/cases" },
      { title: "Screen Protectors", href: "/category/ereaders/accessories/screen-protectors" },
      { title: "Chargers", href: "/category/ereaders/accessories/chargers" },
    ]
  }
];

interface MobileMenuProps {
  navItems: { name: string; href: string }[];
  onClose: () => void;
}

export function MobileMenu({ navItems, onClose }: MobileMenuProps) {
  const { closeMenu } = useNavbarStore();
  const [openCategory, setOpenCategory] = useState<string | null>(null);

  const handleClose = () => {
    onClose();
    closeMenu();
  };

  const toggleCategory = (title: string) => {
    setOpenCategory(openCategory === title ? null : title);
  };

  const getCategoryItems = (title: string) => {
    switch (title) {
      case "Book Categories":
        return bookCategories;
      case "Comics":
        return comicsCategories;
      case "Manga":
        return mangaCategories;
      case "Ereaders":
        return ereaderCategories;
      default:
        return [];
    }
  };

  return (
    <div className="lg:hidden bg-accent/90 rounded-2xl border backdrop-blur-sm mx-2 mt-2 animate-in slide-in-from-top-2 duration-600 ease-out max-h-[80vh] overflow-y-auto">
      <div className="container px-4 py-4">
        <nav className="flex flex-col gap-1 mb-4">
          {navItems.map((item, index) => (
            <Link
              key={index}
              href={item.href}
              className="px-3 py-3 text-base font-medium text-primary/80 hover:text-secondary hover:bg-accent rounded-md"
              onClick={handleClose}
            >
              {item.name}
            </Link>
          ))}
        </nav>

        <div className="mb-4 border-t border-border/40 pt-4">
          <h3 className="px-3 text-sm font-semibold text-secondary mb-2">Browse Books</h3>
          <div className="space-y-1">
            {navigationItems.map((category) => (
              <div key={category.title}>
                <button
                  className="flex items-center justify-between w-full px-3 py-3 text-base font-medium text-primary/80 hover:text-secondary hover:bg-accent rounded-md text-left"
                  onClick={() => toggleCategory(category.title)}
                >
                  <span>{category.title}</span>
                  {openCategory === category.title ? (
                    <ChevronDown className="h-4 w-4" />
                  ) : (
                    <ChevronRight className="h-4 w-4" />
                  )}
                </button>
                {openCategory === category.title && (
                  <div className="pl-6 pr-2 py-2 space-y-1">
                    {getCategoryItems(category.title).map((section) => (
                      <div key={section.title} className="mb-2">
                        <h4 className="text-xs font-semibold text-secondary uppercase tracking-wide mb-1">
                          {section.title}
                        </h4>
                        <ul className="space-y-1">
                          {section.items.map((item) => (
                            <li key={item.title}>
                              <Link
                                href={item.href}
                                className="block px-3 py-2 text-sm text-muted-foreground hover:text-secondary hover:bg-accent rounded-md"
                                onClick={handleClose}
                              >
                                {item.title}
                              </Link>
                            </li>
                          ))}
                        </ul>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>

        {/* Quick Links Section */}
        <div className="mb-4 border-t border-border/40 pt-4">
          <h3 className="px-3 text-sm font-semibold text-secondary mb-2">Quick Links</h3>
          <div className="space-y-1">
            <Link
              href="/comics"
              className="block px-3 py-2 text-sm font-medium text-secondary hover:text-secondary/80 hover:bg-accent rounded-md"
              onClick={handleClose}
            >
              Comics Collection
            </Link>
            <Link
              href="/manga"
              className="block px-3 py-2 text-sm font-medium text-secondary hover:text-secondary/80 hover:bg-accent rounded-md"
              onClick={handleClose}
            >
              Manga Collection
            </Link>
            <Link
              href="/ereaders"
              className="block px-3 py-2 text-sm font-medium text-secondary hover:text-secondary/80 hover:bg-accent rounded-md"
              onClick={handleClose}
            >
              Ereaders Store
            </Link>
          </div>
        </div>

        <div className="flex gap-2 pb-2 border-b border-border/40">
          <Button variant="ghost" size="icon" className="relative flex-1 hover:cursor-pointer">
            <Bookmark className="h-5 w-5" />
            <span className="ml-2">Wishlist</span>
            <span className="absolute -top-1 -right-1 h-4 w-4 rounded-full bg-secondary text-[0.6rem] text-secondary-foreground flex items-center justify-center">5</span>
          </Button>

          <Button variant="ghost" size="icon" className="relative flex-1 hover:cursor-pointer">
            <User className="h-5 w-5" />
            <span className="ml-2">Account</span>
          </Button>
        </div>

        <div className="mt-4 flex flex-col gap-2">
          <Button className="bg-secondary text-secondary-foreground hover:bg-secondary/90 font-medium text-sm w-full">
            Sign In
          </Button>
        </div>
      </div>
    </div>
  );
}
