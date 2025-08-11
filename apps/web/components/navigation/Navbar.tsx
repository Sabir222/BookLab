"use client";
import { Menu, X, Search, BookOpen, User, ShoppingCart, Bookmark } from "lucide-react";
import Link from "next/link";
import { useState, useRef, useEffect } from "react";

import { Button } from "../ui/button";

export const Navbar = () => {
        const [menuState, setMenuState] = useState(false);
        const [searchOpen, setSearchOpen] = useState(false);
        const [searchQuery, setSearchQuery] = useState("");
        const searchRef = useRef<HTMLDivElement>(null);

        const navItems = [
                { name: "Books", href: "/books" },
                { name: "Authors", href: "/authors" },
                { name: "Genres", href: "/genres" },
                { name: "Deals", href: "/deals" },
        ];

        const handleSearch = (e: React.FormEvent) => {
                e.preventDefault();
                if (searchQuery.trim()) {
                        window.location.href = `/search?q=${encodeURIComponent(searchQuery)}`;
                }
        };

        // Close search when clicking outside
        useEffect(() => {
                const handleClickOutside = (e: MouseEvent) => {
                        if (searchRef.current && !searchRef.current.contains(e.target as Node)) {
                                setSearchOpen(false);
                        }
                };

                if (searchOpen) {
                        document.addEventListener('mousedown', handleClickOutside);
                }
                return () => {
                        document.removeEventListener('mousedown', handleClickOutside);
                };
        }, [searchOpen]);

        return (
                <header className="sticky top-0 z-50 w-full bg-background border-b border-border/40">
                        {/* Bookshelf Top Border */}
                        <div className="h-1 bg-secondary w-full"></div>
                        
                        <div className="container flex h-16 items-center justify-between px-4 sm:px-6">
                                {/* Logo */}
                                <div className="flex items-center gap-3">
                                        <div className="flex items-end">
                                                <div className="h-8 w-2 bg-secondary rounded-t-sm"></div>
                                                <div className="h-6 w-2 bg-highlight mx-0.5 rounded-t-sm"></div>
                                                <div className="h-7 w-2 bg-muted-foreground rounded-t-sm"></div>
                                                <div className="h-5 w-2 bg-primary mx-0.5 rounded-t-sm"></div>
                                        </div>
                                        <Link href="/" className="text-xl font-bold tracking-tight text-primary">
                                                BookLab
                                        </Link>
                                </div>

                                {/* Desktop Navigation */}
                                <div className="hidden md:flex md:items-center md:gap-1">
                                        <nav className="flex items-center gap-2">
                                                {navItems.map((item, index) => (
                                                        <Link
                                                                key={index}
                                                                href={item.href}
                                                                className="px-3 py-2 text-sm font-medium text-primary/80 hover:text-secondary hover:bg-accent rounded-md transition-colors relative group"
                                                        >
                                                                {item.name}
                                                                <span className="absolute bottom-1 left-3 right-3 h-0.5 bg-secondary scale-x-0 group-hover:scale-x-100 transition-transform origin-left rounded-full"></span>
                                                        </Link>
                                                ))}
                                        </nav>
                                </div>

                                {/* Right Side Actions */}
                                <div className="flex items-center gap-2">
                                        {/* Search */}
                                        <div ref={searchRef} className="relative">
                                                {searchOpen ? (
                                                        <div className="absolute right-0 top-12 md:top-auto md:bottom-full md:mb-2 w-72 sm:w-80 p-3 bg-background border border-border rounded-lg shadow-xl z-50">
                                                                <form onSubmit={handleSearch}>
                                                                        <div className="relative">
                                                                                <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                                                                                <input
                                                                                        autoFocus
                                                                                        type="text"
                                                                                        placeholder="Find your next great read..."
                                                                                        className="w-full rounded-md border border-input bg-accent py-2 pl-10 pr-10 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
                                                                                        value={searchQuery}
                                                                                        onChange={(e) => setSearchQuery(e.target.value)}
                                                                                />
                                                                                <Button 
                                                                                        type="button"
                                                                                        variant="ghost" 
                                                                                        size="icon"
                                                                                        className="absolute right-1 top-1/2 -translate-y-1/2 h-6 w-6"
                                                                                        onClick={() => setSearchOpen(false)}
                                                                                >
                                                                                        <X className="h-4 w-4" />
                                                                                </Button>
                                                                        </div>
                                                                        <div className="mt-2 text-xs text-muted-foreground">
                                                                                Search by title, author, ISBN, or genre
                                                                        </div>
                                                                </form>
                                                        </div>
                                                ) : null}
                                                <Button 
                                                        variant="ghost" 
                                                        size="icon"
                                                        onClick={() => setSearchOpen(!searchOpen)}
                                                        aria-label="Search"
                                                        className="hover:bg-accent"
                                                >
                                                        <Search className="h-5 w-5" />
                                                </Button>
                                        </div>
                                        
                                        {/* Wishlist */}
                                        <Button variant="ghost" size="icon" className="relative hidden sm:flex hover:bg-accent">
                                                <Bookmark className="h-5 w-5" />
                                                <span className="absolute -top-1 -right-1 h-4 w-4 rounded-full bg-secondary text-[0.6rem] text-secondary-foreground flex items-center justify-center">5</span>
                                                <span className="sr-only">Wishlist</span>
                                        </Button>
                                        
                                        {/* Cart */}
                                        <Button variant="ghost" size="icon" className="relative hover:bg-accent">
                                                <ShoppingCart className="h-5 w-5" />
                                                <span className="absolute -top-1 -right-1 h-4 w-4 rounded-full bg-secondary text-[0.6rem] text-secondary-foreground flex items-center justify-center">2</span>
                                                <span className="sr-only">Cart</span>
                                        </Button>
                                        
                                        {/* Account */}
                                        <Button variant="ghost" size="icon" className="hidden sm:flex hover:bg-accent">
                                                <User className="h-5 w-5" />
                                                <span className="sr-only">Account</span>
                                        </Button>
                                        
                                        {/* Sign In Button */}
                                        <Button className="hidden md:flex bg-secondary text-secondary-foreground hover:bg-secondary/90 font-medium text-sm">
                                                Sign In
                                        </Button>
                                        
                                        {/* Mobile Menu Button */}
                                        <Button 
                                                variant="ghost" 
                                                size="icon"
                                                className="md:hidden hover:bg-accent"
                                                onClick={() => setMenuState(!menuState)}
                                        >
                                                {menuState ? (
                                                        <X className="h-5 w-5" />
                                                ) : (
                                                        <Menu className="h-5 w-5" />
                                                )}
                                                <span className="sr-only">Toggle menu</span>
                                        </Button>
                                </div>
                        </div>

                        {/* Mobile Menu */}
                        {menuState && (
                                <div className="md:hidden border-t border-border/40 bg-background">
                                        <div className="container px-4 py-4">
                                                {/* Mobile Search */}
                                                <div className="relative mb-4">
                                                        <form onSubmit={handleSearch}>
                                                                <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                                                                <input
                                                                        type="text"
                                                                        placeholder="Find your next great read..."
                                                                        className="w-full rounded-md border border-input bg-accent py-2 pl-10 pr-4 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
                                                                        value={searchQuery}
                                                                        onChange={(e) => setSearchQuery(e.target.value)}
                                                                />
                                                                <button
                                                                        type="submit"
                                                                        className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-primary"
                                                                >
                                                                        <Search className="h-4 w-4" />
                                                                </button>
                                                        </form>
                                                </div>
                                                
                                                {/* Mobile Navigation */}
                                                <nav className="flex flex-col gap-1 mb-4">
                                                        {navItems.map((item, index) => (
                                                                <Link
                                                                        key={index}
                                                                        href={item.href}
                                                                        className="px-3 py-3 text-base font-medium text-primary/80 hover:text-secondary hover:bg-accent rounded-md"
                                                                        onClick={() => setMenuState(false)}
                                                                >
                                                                        {item.name}
                                                                </Link>
                                                        ))}
                                                </nav>
                                                
                                                <div className="flex gap-2 pb-2 border-b border-border/40">
                                                        <Button variant="ghost" size="icon" className="relative flex-1">
                                                                <Bookmark className="h-5 w-5" />
                                                                <span className="ml-2">Wishlist</span>
                                                                <span className="absolute -top-1 -right-1 h-4 w-4 rounded-full bg-secondary text-[0.6rem] text-secondary-foreground flex items-center justify-center">5</span>
                                                        </Button>
                                                        
                                                        <Button variant="ghost" size="icon" className="relative flex-1">
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
                        )}
                </header>
        );
};
