"use client";
import { Search, X } from "lucide-react";
import { useState, useRef, useEffect } from "react";

import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import { MiniBookCard } from "@/components/books/MiniBookCard";
import { useNavbarStore } from "./navbarStore";
import type { Book, ApiResponse, SearchResponse, SimpleBook } from "@/types";

interface SearchBarProps {
        className?: string;
}

export function SearchBar({ className }: SearchBarProps) {
        const { isSearchOpen, openSearch, closeSearch } = useNavbarStore();
        const [searchQuery, setSearchQuery] = useState("");
        const [searchResults, setSearchResults] = useState<SimpleBook[]>([]);
        const [isLoading, setIsLoading] = useState(false);
        const searchRef = useRef<HTMLDivElement>(null);
        const debounceTimer = useRef<NodeJS.Timeout | null>(null);

        const handleSearch = (e: React.FormEvent) => {
                e.preventDefault();
                if (searchQuery.trim()) {
                        closeSearch();
                        window.location.href = `/search?q=${encodeURIComponent(searchQuery)}`;
                }
        };

        const fetchSearchResults = async (query: string) => {
                if (!query.trim()) {
                        setSearchResults([]);
                        return;
                }

                setIsLoading(true);
                try {
                        const API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL || "";
                        const response = await fetch(
                                `${API_BASE_URL}/api/books/search-with-authors?q=${encodeURIComponent(query)}`
                        );
                        const result: ApiResponse<SearchResponse> = await response.json();

                        if (result.success && result.data?.books) {
                                const results: SimpleBook[] = result.data.books.slice(0, 8).map((book: Book & { author_name?: string }) => ({
                                        id: book.book_id,
                                        title: book.title,
                                        author: book.author_name || "Unknown Author",
                                        coverImage: book.cover_image_small_url || book.cover_image_medium_url || undefined
                                }));
                                setSearchResults(results);
                        } else {
                                setSearchResults([]);
                        }
                } catch (error) {
                        console.error("Search error:", error);
                        setSearchResults([]);
                } finally {
                        setIsLoading(false);
                }
        };

        useEffect(() => {
                if (debounceTimer.current) {
                        clearTimeout(debounceTimer.current);
                }

                if (searchQuery.trim()) {
                        debounceTimer.current = setTimeout(() => {
                                fetchSearchResults(searchQuery);
                        }, 300); // 300ms debounce
                } else {
                        setSearchResults([]);
                }

                return () => {
                        if (debounceTimer.current) {
                                clearTimeout(debounceTimer.current);
                        }
                };
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
                                                        {searchResults.map((book, index) => (
                                                                <div key={book.id}>
                                                                        <MiniBookCard
                                                                                id={book.id}
                                                                                title={book.title}
                                                                                author={book.author}
                                                                                coverImage={book.coverImage}
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

                                        {isLoading && searchQuery.trim() && (
                                                <div className="border-t border-border py-3 text-center">
                                                        <p className="text-sm text-muted-foreground">Searching...</p>
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
