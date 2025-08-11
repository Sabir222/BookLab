"use client";
import Link from "next/link";

interface NavLinksProps {
        navItems: { name: string; href: string }[];
}

export function NavLinks({ navItems }: NavLinksProps) {
        return (
                <nav className="flex items-center gap-2">
                        {navItems.map((item, index) => (
                                <Link
                                        key={index}
                                        href={item.href}
                                        className="px-3 py-2 text-sm font-medium text-primary/80 hover:text-secondary hover:bg-accent rounded-md transition-colors"
                                >
                                        {item.name}
                                </Link>
                        ))}
                </nav>
        );
}