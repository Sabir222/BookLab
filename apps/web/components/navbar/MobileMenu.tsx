"use client";
import Link from "next/link";

import { Button } from "@/components/ui/button";
import { Bookmark, User } from "lucide-react";

interface MobileMenuProps {
        navItems: { name: string; href: string }[];
        onClose: () => void;
}

export function MobileMenu({ navItems, onClose }: MobileMenuProps) {
        return (
                <div className="lg:hidden bg-accent/90 rounded-2xl border backdrop-blur-lg mx-2 mt-2 animate-in slide-in-from-top-2 duration-600 ease-out">
                        <div
                                className="container px-4 py-4"
                        >
                                <nav className="flex flex-col gap-1 mb-4">
                                        {navItems.map((item, index) => (
                                                <Link
                                                        key={index}
                                                        href={item.href}
                                                        className="px-3 py-3 text-base font-medium text-primary/80 hover:text-secondary hover:bg-accent rounded-md"
                                                        onClick={onClose}
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
        );
}
