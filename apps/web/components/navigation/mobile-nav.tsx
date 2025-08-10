"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Sheet, SheetContent, SheetTrigger } from "@/components/ui/sheet"
import { Menu, BookOpen, ShoppingCart, User } from "lucide-react"
import Link from "next/link"

export function MobileNav() {
  const [open, setOpen] = useState(false)

  const navItems = [
    { name: "Browse", href: "/" },
    { name: "Rent", href: "/rent" },
    { name: "Sell", href: "/sell" },
    { name: "Cart", href: "/cart" },
    { name: "Account", href: "/account" },
  ]

  return (
    <div className="md:hidden border-b">
      <div className="flex items-center justify-between p-4">
        <Link href="/" className="flex items-center gap-2">
          <BookOpen className="h-6 w-6" />
          <span className="font-semibold">BookLab</span>
        </Link>
        
        <Sheet open={open} onOpenChange={setOpen}>
          <SheetTrigger asChild>
            <Button variant="ghost" size="icon" onClick={() => setOpen(true)}>
              <Menu className="h-6 w-6" />
              <span className="sr-only">Toggle menu</span>
            </Button>
          </SheetTrigger>
          <SheetContent side="right" className="w-[300px] sm:w-[400px]">
            <nav className="flex flex-col gap-4">
              {navItems.map((item) => (
                <Link
                  key={item.name}
                  href={item.href}
                  className="flex items-center gap-2 py-2 text-lg font-medium"
                  onClick={() => setOpen(false)}
                >
                  {item.name === "Cart" ? (
                    <ShoppingCart className="h-5 w-5" />
                  ) : item.name === "Account" ? (
                    <User className="h-5 w-5" />
                  ) : null}
                  {item.name}
                </Link>
              ))}
            </nav>
          </SheetContent>
        </Sheet>
      </div>
    </div>
  )
}