"use client";
import { User, ShoppingCart, Bookmark } from "lucide-react";
import Link from "next/link";

import { Button } from "@/components/ui/button";

export function UserMenu() {
        return (
                <div className="flex items-center gap-2">
                        {/* Wishlist */}
                        <Button variant="ghost" size="icon" className="relative hidden lg:flex hover:bg-accent">
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
                        <Button variant="ghost" size="icon" className="hidden lg:flex hover:bg-accent">
                                <User className="h-5 w-5" />
                                <span className="sr-only">Account</span>
                        </Button>
                        
                        {/* Sign In Button */}
                        <Button className="hidden lg:flex bg-secondary text-secondary-foreground hover:bg-secondary/90 font-medium text-sm">
                                Sign In
                        </Button>
                </div>
        );
}