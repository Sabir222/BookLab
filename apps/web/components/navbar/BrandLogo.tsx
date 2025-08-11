"use client";
import Link from "next/link";
import { BookOpen } from "lucide-react";

export function BrandLogo() {
        return (
                <div className="flex items-center gap-3">
                        <div className="flex items-end">
                                <div className="h-8 w-2 bg-secondary rounded-t-sm"></div>
                                <div className="h-6 w-2 bg-highlight mx-0.5 rounded-t-sm"></div>
                                <div className="h-7 w-2 bg-muted-foreground rounded-t-sm"></div>
                                <div className="h-5 w-2 bg-primary mx-0.5 rounded-t-sm"></div>
                        </div>
                        <Link href="/" className="text-xl font-bold tracking-tight text-primary">
                                BookLab
                        </Link>
                </div>
        );
}