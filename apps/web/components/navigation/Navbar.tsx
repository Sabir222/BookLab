"use client";
import { Menu, X, Search } from "lucide-react";
import Link from "next/link";
import { useEffect, useState } from "react";

import { cn } from "@/lib/utils";
import { Button } from "../ui/button";

export const Navbar = () => {
        const menuItems = [
                { name: "Home", href: "/", external: false },
                { name: "Books", href: "/books", external: false },
                { name: "Genres", href: "/genres", external: false },
                { name: "Authors", href: "/authors", external: false },
                { name: "About", href: "/about", external: false },
        ];
        const [menuState, setMenuState] = useState(false);
        const [isScrolled, setIsScrolled] = useState(false);
        const [searchQuery, setSearchQuery] = useState("");

        useEffect(() => {
                const handleScroll = () => {
                        setIsScrolled(window.scrollY > 50);
                };
                window.addEventListener("scroll", handleScroll);
                return () => window.removeEventListener("scroll", handleScroll);
        }, []);

        const handleSearch = (e: React.FormEvent) => {
                e.preventDefault();
                if (searchQuery.trim()) {
                        // Implement search functionality
                        console.log("Searching for:", searchQuery);
                        // You can redirect to search results page or trigger search function
                        window.location.href = `/search?q=${encodeURIComponent(searchQuery)}`;
                }
        };

        return (
                <header>
                        <nav
                                data-state={menuState && "active"}
                                className="fixed z-20 w-full px-2 group"
                        >
                                <div
                                        className={cn(
                                                "mx-auto max-w-6xl px-6 transition-all duration-300 lg:px-12 border",
                                                isScrolled
                                                        ? "bg-accent/90 mt-2 rounded-2xl border-muted/50 backdrop-blur-lg"
                                                        : "mt-2 border-transparent",
                                        )}
                                >
                                        <div className="relative flex flex-wrap items-center justify-between gap-6 py-3 lg:gap-0 lg:py-4">
                                                {/* Logo and Title */}
                                                <div className="flex w-full justify-between lg:w-auto">
                                                        <Link
                                                                href="/"
                                                                aria-label="home"
                                                                className="flex items-center space-x-2"
                                                                prefetch={true}
                                                        >
                                                                <span className="text-xl font-bold tracking-tight text-primary dark:text-accent">
                                                                        BookLab
                                                                </span>
                                                        </Link>

                                                        <button
                                                                onClick={() => setMenuState(!menuState)}
                                                                aria-label={menuState ? "Close Menu" : "Open Menu"}
                                                                className="relative z-20 -m-2.5 -mr-4 block cursor-pointer p-2.5 lg:hidden"
                                                        >
                                                                <Menu className="group-data-[state=active]:scale-0 group-data-[state=active]:opacity-0 size-6 duration-200 text-primary dark:text-accent" />
                                                                <X className="absolute inset-0 m-auto size-6 -rotate-180 scale-0 opacity-0 group-data-[state=active]:rotate-0 group-data-[state=active]:scale-100 group-data-[state=active]:opacity-100 duration-200 text-primary dark:text-accent" />
                                                        </button>
                                                </div>

                                                {/* Search Bar - Hidden on mobile, visible on desktop */}
                                                <div className="hidden lg:block flex-1 max-w-md mx-4">
                                                        <form onSubmit={handleSearch} className="relative">
                                                                <input
                                                                        type="text"
                                                                        placeholder="Search books, authors, genres..."
                                                                        className="w-full rounded-full border border-muted bg-accent py-2 pl-4 pr-10 text-sm focus:border-highlight focus:outline-none focus:ring-1 focus:ring-highlight dark:border-muted/50 dark:bg-accent/80 dark:text-primary dark:placeholder-primary/50"
                                                                        value={searchQuery}
                                                                        onChange={(e) => setSearchQuery(e.target.value)}
                                                                />
                                                                <button
                                                                        type="submit"
                                                                        className="absolute right-3 top-1/2 -translate-y-1/2 text-primary/70 hover:text-primary dark:text-primary/80 dark:hover:text-primary"
                                                                >
                                                                        <Search className="h-4 w-4" />
                                                                </button>
                                                        </form>
                                                </div>

                                                <div className="m-auto hidden size-fit lg:block">
                                                        <ul className="flex gap-8 text-sm">
                                                                {menuItems.map((item, index) => (
                                                                        <li key={index}>
                                                                                {item.external ? (
                                                                                        <a
                                                                                                href={item.href}
                                                                                                target="_blank"
                                                                                                rel="noopener noreferrer"
                                                                                                className="text-primary/80 hover:text-secondary block duration-150 px-4 py-2 dark:text-accent/80 dark:hover:text-accent"
                                                                                        >
                                                                                                {item.name}
                                                                                        </a>
                                                                                ) : (
                                                                                        <Link
                                                                                                href={item.href}
                                                                                                className="text-primary/80 hover:text-secondary block duration-150 px-4 py-2 dark:text-accent/80 dark:hover:text-accent"
                                                                                                prefetch={true}
                                                                                        >
                                                                                                {item.name}
                                                                                        </Link>
                                                                                )}
                                                                        </li>
                                                                ))}
                                                        </ul>
                                                </div>

                                                <div className="bg-background group-data-[state=active]:block lg:group-data-[state=active]:flex mb-6 hidden w-full flex-wrap items-center justify-end space-y-8 rounded-3xl border p-6 shadow-2xl shadow-zinc-300/20 md:flex-nowrap lg:m-0 lg:flex lg:w-fit lg:gap-6 lg:space-y-0 lg:border-transparent lg:bg-transparent lg:p-0 lg:shadow-none dark:shadow-none dark:lg:bg-transparent">
                                                        <div className="lg:hidden w-full">
                                                                {/* Mobile Search Bar */}
                                                                <form onSubmit={handleSearch} className="relative mb-6">
                                                                        <input
                                                                                type="text"
                                                                                placeholder="Search books, authors, genres..."
                                                                                className="w-full rounded-full border border-muted bg-accent py-2 pl-4 pr-10 text-sm focus:border-highlight focus:outline-none focus:ring-1 focus:ring-highlight dark:border-muted/50 dark:bg-accent/80 dark:text-primary dark:placeholder-primary/50"
                                                                                value={searchQuery}
                                                                                onChange={(e) => setSearchQuery(e.target.value)}
                                                                        />
                                                                        <button
                                                                                type="submit"
                                                                                className="absolute right-3 top-1/2 -translate-y-1/2 text-primary/70 hover:text-primary dark:text-primary/80 dark:hover:text-primary"
                                                                        >
                                                                                <Search className="h-4 w-4" />
                                                                        </button>
                                                                </form>

                                                                <ul className="space-y-6 text-base">
                                                                        {menuItems.map((item, index) => (
                                                                                <li key={index}>
                                                                                        {item.external ? (
                                                                                                <a
                                                                                                        href={item.href}
                                                                                                        target="_blank"
                                                                                                        rel="noopener noreferrer"
                                                                                                        className="text-primary/80 hover:text-secondary block duration-150 dark:text-accent/80 dark:hover:text-accent"
                                                                                                >
                                                                                                        {item.name}
                                                                                                </a>
                                                                                        ) : (
                                                                                                <Link
                                                                                                        href={item.href}
                                                                                                        className="text-primary/80 hover:text-secondary block duration-150 dark:text-accent/80 dark:hover:text-accent"
                                                                                                        prefetch={true}
                                                                                                >
                                                                                                        {item.name}
                                                                                                </Link>
                                                                                        )}
                                                                                </li>
                                                                        ))}
                                                                </ul>
                                                        </div>

                                                        <div className="flex w-full flex-col space-y-3 sm:flex-row sm:gap-3 sm:space-y-0 md:w-fit items-center">
                                                                <Button
                                                                        asChild
                                                                        className={cn(
                                                                                "bg-secondary text-accent hover:bg-secondary/90 font-medium w-full md:w-fit",
                                                                        )}
                                                                >
                                                                        <Link href="/login">Sign In</Link>
                                                                </Button>
                                                        </div>
                                                </div>
                                        </div>
                                </div>
                        </nav>
                </header>
        );
};
