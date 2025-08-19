"use client";

import { Library } from "lucide-react";

export function DashboardHeader() {
  return (
    <div className="mb-8 text-center">
      <div className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-secondary mb-4 shadow-lg">
        <Library className="w-8 h-8 text-secondary-foreground" />
      </div>
      <h1 className="text-4xl font-bold text-primary mb-2">
        BookLab Dashboard
      </h1>
      <p className="text-lg text-muted-foreground max-w-2xl mx-auto">
        Create, manage, and organize your book collection with our intuitive platform
      </p>
    </div>
  );
}