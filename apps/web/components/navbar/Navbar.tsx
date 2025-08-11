"use client";
import { Menu } from "lucide-react";
import { useState, useEffect } from "react";

import { Button } from "@/components/ui/button";
import { SearchBar } from "./SearchBar";
import { UserMenu } from "./UserMenu";
import { MobileMenu } from "./MobileMenu";
import { BrandLogo } from "./BrandLogo";
import { NavLinks } from "./NavLinks";

export const Navbar = () => {
        const [menuState, setMenuState] = useState(false);
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
                        className={`mx-auto max-w-6xl transition-all duration-300 px-6 lg:px-12 rounded-2xl ${
                                isScrolled
                                        ? "bg-accent/90 border backdrop-blur-lg mt-2"
                                        : "bg-transparent border-transparent mt-0"
                        }`}
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
                                                        className="lg:hidden hover:bg-accent"
                                                        onClick={() => setMenuState(!menuState)}
                                                >
                                                        <Menu className="h-5 w-5" />
                                                        <span className="sr-only">Toggle menu</span>
                                                </Button>
                                        </div>
                                </div>
                        </div>

                        {/* Mobile Menu */}
                        {menuState && (
                                <MobileMenu navItems={navItems} onClose={() => setMenuState(false)} />
                        )}
                </header>
        );
};
