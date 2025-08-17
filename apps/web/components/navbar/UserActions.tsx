"use client";
import { User, ShoppingCart, Bookmark } from "lucide-react";
import { Button } from "@/components/ui/button";
import { usePathname, useRouter } from "next/navigation";
import { ProfileDropDown } from "@/components/ProfileDropDown";
import { useNavbarStore } from "./navbarStore";

export function UserActions() {
        const { user } = useNavbarStore();
        const router = useRouter()
        const path = usePathname()

        return (
                <div className="flex items-center gap-2">
                        <Button variant="ghost" size="icon" className="relative hidden lg:flex hover:bg-accent cursor-pointer">
                                <Bookmark className="h-5 w-5" />
                                <span className="absolute -top-1 -right-1 h-4 w-4 rounded-full bg-secondary text-[0.6rem] text-secondary-foreground flex items-center justify-center">5</span>
                                <span className="sr-only">Wishlist</span>
                        </Button>
                        <Button variant="ghost" size="icon" className="relative hover:bg-accent cursor-pointer">
                                <ShoppingCart className="h-5 w-5" />
                                <span className="absolute -top-1 -right-1 h-4 w-4 rounded-full bg-secondary text-[0.6rem] text-secondary-foreground flex items-center justify-center">2</span>
                                <span className="sr-only">Cart</span>
                        </Button>

                        {user ? (
                                <div className="hidden lg:flex items-center gap-2">
                                        <ProfileDropDown />
                                </div>
                        ) : (
                                <>
                                        <Button variant="ghost" size="icon" className="hidden lg:flex hover:bg-accent cursor-pointer">
                                                <User className="h-5 w-5" />
                                                <span className="sr-only">Account</span>
                                        </Button>
                                        <Button onClick={() => router.push("/signup")} className="hidden lg:flex bg-primary text-primary-foreground hover:bg-primary/90 font-medium text-sm cursor-pointer">
                                                Sign Up
                                        </Button>
                                        <Button onClick={() => router.push("/login")} className="hidden lg:flex bg-secondary text-secondary-foreground hover:bg-secondary/90 font-medium text-sm cursor-pointer">
                                                Login
                                        </Button>
                                </>
                        )}
                </div>
        );
}
