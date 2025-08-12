"use client";
import { Search, X } from "lucide-react";
import { useState, useRef, useEffect } from "react";

import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import { MiniBookCard } from "@/components/books/MiniBookCard";
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
                                <div className="fixed left-1/2 top-20 w-[90vw] -translate-x-1/2 md:w-[70vw] lg:w-[60vw] max-w-2xl bg-background border border-border rounded-lg shadow-md z-50">
                                        <form onSubmit={handleSearch}>
                                                <div className="relative p-2">
                                                        <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                                                        <input
                                                                autoFocus
                                                                type="text"
                                                                placeholder="Search books..."
                                                                className="w-full rounded-md border-0 bg-background py-2 pl-9 pr-9 text-sm focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                                                                value={searchQuery}
                                                                onChange={(e) => setSearchQuery(e.target.value)}
                                                        />
                                                        <Button
                                                                type="button"
                                                                variant="ghost"
                                                                size="icon"
                                                                className="absolute right-2 top-1/2 -translate-y-1/2 h-6 w-6"
                                                                onClick={() => setSearchQuery("")}
                                                        >
                                                                <X className="h-4 w-4" />
                                                        </Button>
                                                </div>
                                        </form>

                                        {searchResults.length > 0 && (
                                                <div className="border-t border-border max-h-60 overflow-y-auto scrollbar-thin scrollbar-thumb-accent scrollbar-track-background scrollbar-thumb-rounded-full">
                                                        {searchResults.map((result, index) => (
                                                                <div key={result.id}>
                                                                        <MiniBookCard
                                                                                id={result.id}
                                                                                title={result.title}
                                                                                author={result.author}
                                                                        />
                                                                        {index < searchResults.length - 1 && <Separator className="my-0" />}
                                                                </div>
                                                        ))}
                                                        <div className="px-3 py-2 text-center border-t border-border bg-muted/10">
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
                                                                        View all results
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
                                className="hover:bg-accent cursor-pointer"
                        >
                                <Search className="h-5 w-5" />
                        </Button>
                </div>
        );
}
