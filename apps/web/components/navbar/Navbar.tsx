"use client";
import { Menu } from "lucide-react";

import { Button } from "@/components/ui/button";
import { SearchBar } from "./SearchBar";
import { UserMenu } from "./UserMenu";
import { MobileMenu } from "./MobileMenu";
import { BrandLogo } from "./BrandLogo";
import { NavLinks } from "./NavLinks";
import { NavigationMenuComponent } from "./NavigationMenuComponent";
import { useNavbarStore } from "./navbarStore";
import { useState, useEffect } from "react";

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
                                        <BrandLogo />

                                        <div className="hidden lg:flex lg:items-center lg:gap-1">
                                                <NavLinks navItems={navItems} />
                                        </div>

                                        <div className="flex items-center gap-2">
                                                <SearchBar />
                                                <UserMenu />
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

                                <div className="hidden lg:block">
                                        <NavigationMenuComponent />
                                </div>
                        </div>

                        {isMenuOpen && (
                                <MobileMenu navItems={navItems} onClose={closeMenu} />
                        )}
                </header>
        );
};;;;;;;
