"use client";
import Link from "next/link";

import { Button } from "@/components/ui/button";
import { Bookmark, User, ChevronDown, ChevronRight } from "lucide-react";
import { useNavbarStore } from "./navbarStore";
import { useState } from "react";

const bookCategories = [
  { title: "Book Categories" },
  { title: "Fiction" },
  { title: "Non-Fiction" },
  { title: "History" },
  { title: "Popular Genres" },
];

const dropdownSections = [
  {
    title: "New Arrivals",
    items: [
      { title: "Latest Fantasy Releases", href: "/new/fantasy" },
      { title: "New Mystery Thrillers", href: "/new/mystery" },
      { title: "Hot Nonfiction Picks", href: "/new/nonfiction" },
    ]
  },
  {
    title: "Top Categories / Genres",
    items: [
      { title: "Bestsellers", href: "/bestsellers" },
      { title: "Award-Winning Books", href: "/awards" },
      { title: "Trending on BookTok", href: "/trending" },
    ]
  },
  {
    title: "Kids & Teens (Discover Section)",
    items: [
      { title: "Children's Picture Books", href: "/kids/picture-books" },
      { title: "Middle Grade Adventures", href: "/kids/middle-grade" },
      { title: "Teen Fantasy & Romance", href: "/teens/fantasy-romance" },
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

        return (
                <div className="lg:hidden bg-accent/90 rounded-2xl border backdrop-blur-lg mx-2 mt-2 animate-in slide-in-from-top-2 duration-600 ease-out">
                        <div
                                className="container px-4 py-4"
                        >
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

                                {/* Mobile Navigation Menu */}
                                <div className="mb-4 border-t border-border/40 pt-4">
                                        <h3 className="px-3 text-sm font-semibold text-secondary mb-2">Browse Books</h3>
                                        <div className="space-y-1">
                                                {bookCategories.slice(1).map((category) => (
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
                                                                                {dropdownSections.map((section) => (
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
