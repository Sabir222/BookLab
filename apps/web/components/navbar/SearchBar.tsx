"use client";
import { Search, X } from "lucide-react";
import { useState, useRef, useEffect } from "react";

import { Button } from "@/components/ui/button";

interface SearchBarProps {
        className?: string;
}

export function SearchBar({ className }: SearchBarProps) {
        const [searchOpen, setSearchOpen] = useState(false);
        const [searchQuery, setSearchQuery] = useState("");
        const searchRef = useRef<HTMLDivElement>(null);

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
                <div ref={searchRef} className={`relative ${className || ''}`}>
                        {searchOpen ? (
                                <div className="absolute right-0 top-full mt-2 w-72 sm:w-80 p-3 bg-background border border-border rounded-lg shadow-xl z-50">
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
        );
}