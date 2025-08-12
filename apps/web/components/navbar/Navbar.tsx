"use client";
import { Menu } from "lucide-react";

import { Button } from "@/components/ui/button";
import { SearchBar } from "./SearchBar";
import { UserMenu } from "./UserMenu";
import { MobileMenu } from "./MobileMenu";
import { BrandLogo } from "./BrandLogo";
import { NavLinks } from "./NavLinks";
import { useNavbarStore } from "./navbarStore";
import { useState, useEffect } from "react";
import Link from "next/link";
import {
  NavigationMenu,
  NavigationMenuContent,
  NavigationMenuItem,
  NavigationMenuLink,
  NavigationMenuList,
  NavigationMenuTrigger,
} from "@/components/ui/navigation-menu";
import { cn } from "@/lib/utils";

const bookCategories = [
  {
    title: "Book Categories",
    items: [
      { title: "Fiction", href: "/categories/fiction" },
      { title: "Non-Fiction", href: "/categories/non-fiction" },
      { title: "History", href: "/categories/history" },
      { title: "Popular Genres", href: "/categories/popular" },
    ]
  }
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

export const Navbar = () => {
        const { isMenuOpen, openMenu, closeMenu } = useNavbarStore();
        const [isScrolled, setIsScrolled] = useState(false);

        const navItems = [
                { name: "Books", href: "/books" },
                { name: "Authors", href: "/authors" },
                { name: "Genres", href: "/genres" },
                { name: "Deals", href: "/deals" },
        ];

        useEffect(() => {
                const handleScroll = () => {
                        setIsScrolled(window.scrollY > 10);
                };
                window.addEventListener("scroll", handleScroll);
                return () => window.removeEventListener("scroll", handleScroll);
        }, []);

        return (
        <header className="fixed z-20 w-full px-2 group">
                <div
                        className={`mx-auto max-w-6xl transition-all duration-300 px-6 lg:px-12 rounded-2xl ${isScrolled ? "bg-accent/90 border backdrop-blur-lg mt-2" : "bg-transparent border-transparent mt-0"}`}
                >
                        <div className="relative flex flex-wrap items-center justify-between gap-6 py-3 lg:gap-0 lg:py-4">
                                {/* Logo */}
                                <BrandLogo />

                                {/* Desktop Navigation */}
                                <div className="hidden lg:flex lg:items-center lg:gap-1">
                                        <NavLinks navItems={navItems} />
                                </div>

                                {/* Right Side Actions */}
                                <div className="flex items-center gap-2">
                                        {/* Search */}
                                        <SearchBar />
                                        
                                        {/* User Menu */}
                                        <UserMenu />
                                        
                                        {/* Mobile Menu Button */}
                                        <Button 
                                                variant="ghost" 
                                                size="icon"
                                                className="lg:hidden hover:bg-accent cursor-pointer"
                                                onClick={() => isMenuOpen ? closeMenu() : openMenu()}
                                        >
                                                <Menu className="h-5 w-5" />
                                                <span className="sr-only">Toggle menu</span>
                                        </Button>
                                </div>
                        </div>
                        
                        {/* Sub-navbar for book categories - Desktop only */}
                        <div className="hidden lg:block border-t border-border/50 pt-2">
                                <NavigationMenu className="w-full">
                                        <NavigationMenuList>
                                                {bookCategories.map((category) => (
                                                        <NavigationMenuItem key={category.title}>
                                                                <NavigationMenuTrigger className="font-medium text-sm">
                                                                        {category.title}
                                                                </NavigationMenuTrigger>
                                                                <NavigationMenuContent>
                                                                        <ul className="grid w-[600px] gap-3 p-4 md:w-[500px] md:grid-cols-3 lg:w-[600px]">
                                                                                {dropdownSections.map((section) => (
                                                                                        <li key={section.title} className="row-span-3">
                                                                                                <NavigationMenuLink asChild>
                                                                                                        <div className="flex h-full w-full flex-col">
                                                                                                                <h3 className={cn(
                                                                                                                        "text-sm font-medium",
                                                                                                                        section.title.includes("Discover") 
                                                                                                                                ? "text-primary font-bold" 
                                                                                                                                : "text-muted-foreground"
                                                                                                                )}>
                                                                                                                        {section.title}
                                                                                                                </h3>
                                                                                                                <ul className="mt-2 space-y-2">
                                                                                                                        {section.items.map((item) => (
                                                                                                                                <li key={item.title}>
                                                                                                                                        <Link
                                                                                                                                                href={item.href}
                                                                                                                                                className="block rounded-md p-2 text-sm font-medium text-muted-foreground hover:bg-accent hover:text-accent-foreground transition-colors"
                                                                                                                                        >
                                                                                                                                                {item.title}
                                                                                                                                        </Link>
                                                                                                                                </li>
                                                                                                                        ))}
                                                                                                                </ul>
                                                                                                        </div>
                                                                                                </NavigationMenuLink>
                                                                                        </li>
                                                                                ))}
                                                                        </ul>
                                                                </NavigationMenuContent>
                                                        </NavigationMenuItem>
                                                ))}
                                        </NavigationMenuList>
                                </NavigationMenu>
                        </div>
                </div>

                {/* Mobile Menu */}
                {isMenuOpen && (
                        <MobileMenu navItems={navItems} onClose={closeMenu} />
                )}
        </header>
        );
};
