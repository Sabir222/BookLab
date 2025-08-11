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
                                        className="px-3 py-2 text-sm font-medium text-primary/80 hover:text-secondary hover:bg-accent rounded-md transition-colors relative group"
                                >
                                        {item.name}
                                        <span className="absolute bottom-1 left-3 right-3 h-0.5 bg-secondary scale-x-0 group-hover:scale-x-100 transition-transform origin-left rounded-full"></span>
                                </Link>
                        ))}
                </nav>
        );
}