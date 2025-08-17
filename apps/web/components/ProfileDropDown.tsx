"use client"
import { Button } from "@/components/ui/button"
import {
        DropdownMenu,
        DropdownMenuContent,
        DropdownMenuGroup,
        DropdownMenuItem,
        DropdownMenuLabel,
        DropdownMenuSeparator,
        DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { LogOut, User, Settings, Bookmark, ShoppingCart } from "lucide-react"
import { useNavbarStore } from "@/components/navbar/navbarStore"
import { useRouter } from "next/navigation"

interface ProfileDropDownProps {
        trigger?: React.ReactNode
}

export function ProfileDropDown({ trigger }: ProfileDropDownProps) {
        const { user, logout } = useNavbarStore()
        const router = useRouter()

        const handleLogout = async () => {
                logout()
                router.push("/")
        }

        if (!user) return null

        return (
                <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                                {trigger ? trigger : (
                                        <Button variant="ghost" className="relative h-8 w-8 rounded-full hover:bg-accent cursor-pointer">
                                                <Avatar className="h-8 w-8">
                                                        <AvatarImage src={user.profile_image_url || ""} alt={user.username} />
                                                        <AvatarFallback>{user.username?.charAt(0).toUpperCase()}</AvatarFallback>
                                                </Avatar>
                                        </Button>
                                )}
                        </DropdownMenuTrigger>
                        <DropdownMenuContent className="w-56" align="end" forceMount>
                                <DropdownMenuLabel className="font-normal">
                                        <div className="flex flex-col space-y-1">
                                                <p className="text-sm font-medium leading-none">{user.username}</p>
                                                <p className="text-xs leading-none text-muted-foreground">
                                                        {user.email}
                                                </p>
                                        </div>
                                </DropdownMenuLabel>
                                <DropdownMenuSeparator />
                                <DropdownMenuGroup>
                                        <DropdownMenuItem onClick={() => router.push("/profile")}>
                                                <User className="mr-2 h-4 w-4" />
                                                <span>Profile</span>
                                        </DropdownMenuItem>
                                        <DropdownMenuItem onClick={() => router.push("/wishlist")}>
                                                <Bookmark className="mr-2 h-4 w-4" />
                                                <span>Wishlist</span>
                                        </DropdownMenuItem>
                                        <DropdownMenuItem onClick={() => router.push("/cart")}>
                                                <ShoppingCart className="mr-2 h-4 w-4" />
                                                <span>Cart</span>
                                        </DropdownMenuItem>
                                        <DropdownMenuItem onClick={() => router.push("/settings")}>
                                                <Settings className="mr-2 h-4 w-4" />
                                                <span>Settings</span>
                                        </DropdownMenuItem>
                                </DropdownMenuGroup>
                                <DropdownMenuSeparator />
                                <DropdownMenuItem onClick={handleLogout}>
                                        <LogOut className="mr-2 h-4 w-4" />
                                        <span>Log out</span>
                                </DropdownMenuItem>
                        </DropdownMenuContent>
                </DropdownMenu>
        )
}
