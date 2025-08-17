"use client";
import { User, ShoppingCart, Bookmark, LogOut } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useNavbarStore } from "./navbarStore";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { usePathname, useRouter } from "next/navigation";

export function UserActions() {
        const { user, logout } = useNavbarStore();
        const router = useRouter()
        const path = usePathname()

        const handleLogout = async () => {
                logout();
                router.push(path);
        };
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
                                        <Avatar className="h-8 w-8">
                                                <AvatarImage src={user.profile_image_url || ""} alt={user.username} />
                                                <AvatarFallback>{user.username?.charAt(0).toUpperCase()}</AvatarFallback>
                                        </Avatar>
                                        <Button onClick={handleLogout} variant="ghost" size="icon" className="hover:bg-accent cursor-pointer">
                                                <LogOut className="h-5 w-5" />
                                                <span className="sr-only">Logout</span>
                                        </Button>
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
