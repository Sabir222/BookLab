"use client"

import { DesktopNav } from "@/components/navigation/desktop-nav"
import { MobileNav } from "@/components/navigation/mobile-nav"

export function Navbar() {
  return (
    <>
      <DesktopNav />
      <MobileNav />
    </>
  )
}