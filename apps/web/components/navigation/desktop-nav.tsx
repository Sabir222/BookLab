"use client"

import Link from "next/link"
import { BookOpen, ShoppingCart, User } from "lucide-react"
import { Button } from "@/components/ui/button"

export function DesktopNav() {
  return (
    <div className="hidden md:block border-b">
      <div className="container flex items-center justify-between p-4">
        <Link href="/" className="flex items-center gap-2">
          <BookOpen className="h-6 w-6" />
          <span className="text-xl font-bold">BookLab</span>
        </Link>
        
        <nav className="flex items-center gap-8">
          <Link 
            href="/" 
            className="text-sm font-medium transition-colors hover:text-primary"
          >
            Browse
          </Link>
          <Link 
            href="/rent" 
            className="text-sm font-medium transition-colors hover:text-primary"
          >
            Rent
          </Link>
          <Link 
            href="/sell" 
            className="text-sm font-medium transition-colors hover:text-primary"
          >
            Sell
          </Link>
        </nav>
        
        <div className="flex items-center gap-2">
          <Button variant="ghost" size="icon" asChild>
            <Link href="/cart">
              <ShoppingCart className="h-5 w-5" />
              <span className="sr-only">Cart</span>
            </Link>
          </Button>
          <Button variant="ghost" size="icon" asChild>
            <Link href="/account">
              <User className="h-5 w-5" />
              <span className="sr-only">Account</span>
            </Link>
          </Button>
        </div>
      </div>
    </div>
  )
}