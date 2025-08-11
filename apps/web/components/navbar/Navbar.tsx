"use client";
import { Menu } from "lucide-react";
import { useState } from "react";

import { Button } from "@/components/ui/button";
import { SearchBar } from "./SearchBar";
import { UserMenu } from "./UserMenu";
import { MobileMenu } from "./MobileMenu";
import { BrandLogo } from "./BrandLogo";
import { NavLinks } from "./NavLinks";

export const Navbar = () => {
        const [menuState, setMenuState] = useState(false);

        const navItems = [
                { name: "Books", href: "/books" },
                { name: "Authors", href: "/authors" },
                { name: "Genres", href: "/genres" },
                { name: "Deals", href: "/deals" },
        ];

        return (
                <header className="sticky top-0 z-50 w-full bg-background border-b border-border/40">
                        {/* Bookshelf Top Border */}
                        <div className="h-1 bg-secondary w-full"></div>
                        
                        <div className="container flex h-16 items-center justify-between px-4 sm:px-6">
                                {/* Logo */}
                                <BrandLogo />

                                {/* Desktop Navigation */}
                                <div className="hidden md:flex md:items-center md:gap-1">
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
                                                className="md:hidden hover:bg-accent"
                                                onClick={() => setMenuState(!menuState)}
                                        >
                                                <Menu className="h-5 w-5" />
                                                <span className="sr-only">Toggle menu</span>
                                        </Button>
                                </div>
                        </div>

                        {/* Mobile Menu */}
                        {menuState && (
                                <MobileMenu navItems={navItems} onClose={() => setMenuState(false)} />
                        )}
                </header>
        );
};
