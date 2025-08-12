"use client";
import { Search, X } from "lucide-react";
import { useState, useRef, useEffect } from "react";

import { Button } from "@/components/ui/button";
import { useNavbarStore } from "./navbarStore";

interface SearchBarProps {
        className?: string;
}

interface SearchResult {
        id: string;
        title: string;
        author: string;
        coverImage?: string;
}

export function SearchBar({ className }: SearchBarProps) {
        const { isSearchOpen, openSearch, closeSearch } = useNavbarStore();
        const [searchQuery, setSearchQuery] = useState("");
        const [searchResults, setSearchResults] = useState<SearchResult[]>([]);
        const searchRef = useRef<HTMLDivElement>(null);

        const handleSearch = (e: React.FormEvent) => {
                e.preventDefault();
                if (searchQuery.trim()) {
                        closeSearch();
                        window.location.href = `/search?q=${encodeURIComponent(searchQuery)}`;
                }
        };

        useEffect(() => {
                if (searchQuery.trim()) {
                        const mockResults: SearchResult[] = [
                                {
                                        id: "1",
                                        title: "The Great Gatsby",
                                        author: "F. Scott Fitzgerald"
                                },
                                {
                                        id: "2",
                                        title: "To Kill a Mockingbird",
                                        author: "Harper Lee"
                                },
                                {
                                        id: "3",
                                        title: "1984",
                                        author: "George Orwell"
                                },
                                {
                                        id: "4",
                                        title: "Pride and Prejudice",
                                        author: "Jane Austen"
                                }
                        ];
                        setSearchResults(mockResults);
                } else {
                        setSearchResults([]);
                }
        }, [searchQuery]);

        useEffect(() => {
                const handleClickOutside = (e: MouseEvent) => {
                        if (searchRef.current && !searchRef.current.contains(e.target as Node)) {
                                closeSearch();
                        }
                };

                if (isSearchOpen) {
                        document.addEventListener('mousedown', handleClickOutside);
                }
                return () => {
                        document.removeEventListener('mousedown', handleClickOutside);
                };
        }, [isSearchOpen, closeSearch]);

        return (
                <div ref={searchRef} className={`relative ${className || ''}`}>
                        {isSearchOpen ? (
                                <div className="fixed left-1/2 top-20 w-[90vw] -translate-x-1/2 md:w-[70vw] lg:w-[60vw] max-w-2xl bg-background border border-border rounded-lg shadow-xl z-50">
                                        <form onSubmit={handleSearch}>
                                                <div className="relative p-3">
                                                        <Search className="absolute left-4 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
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
                                                                className="absolute right-4 top-1/2 -translate-y-1/2 h-6 w-6"
                                                                onClick={() => setSearchQuery("")}
                                                        >
                                                                <X className="h-4 w-4" />
                                                        </Button>
                                                </div>
                                                <div className="text-xs text-muted-foreground px-3 pb-3">
                                                        Search by title, author, ISBN, or genre
                                                </div>
                                        </form>

                                        {searchResults.length > 0 && (
                                                <div className="border-t border-border mt-2 max-h-60 overflow-y-auto">
                                                        {searchResults.map((result) => (
                                                                <div
                                                                        key={result.id}
                                                                        className="px-4 py-3 hover:bg-accent cursor-pointer flex items-center gap-3"
                                                                        onClick={() => {
                                                                                closeSearch();
                                                                                window.location.href = `/book/${result.id}`;
                                                                        }}
                                                                >
                                                                        <div className="bg-muted border border-border rounded w-10 h-10 flex items-center justify-center">
                                                                                <span className="text-xs text-muted-foreground">📚</span>
                                                                        </div>
                                                                        <div>
                                                                                <div className="font-medium text-sm">{result.title}</div>
                                                                                <div className="text-xs text-muted-foreground">{result.author}</div>
                                                                        </div>
                                                                </div>
                                                        ))}
                                                        <div className="px-4 py-2 text-center border-t border-border bg-muted/50">
                                                                <button
                                                                        className="text-xs text-primary hover:underline"
                                                                        onClick={(e) => {
                                                                                e.preventDefault();
                                                                                if (searchQuery.trim()) {
                                                                                        closeSearch();
                                                                                        window.location.href = `/search?q=${encodeURIComponent(searchQuery)}`;
                                                                                }
                                                                        }}
                                                                >
                                                                        View all results for &quot;{searchQuery}&quot;
                                                                </button>
                                                        </div>
                                                </div>
                                        )}
                                </div>
                        ) : null}
                        <Button
                                variant="ghost"
                                size="icon"
                                onClick={() => isSearchOpen ? closeSearch() : openSearch()}
                                aria-label="Search"
                                className="hover:bg-accent"
                        >
                                <Search className="h-5 w-5" />
                        </Button>
                </div>
        );
}
