"use client";

import { Button } from "@/components/ui/button";

interface EmptyBookResultsProps {
  onClearFilters: () => void;
}

export function EmptyBookResults({ onClearFilters }: EmptyBookResultsProps) {
  return (
    <div className="flex flex-col items-center justify-center py-16 text-center">
      <div className="bg-gray-200 border-2 border-dashed rounded-xl w-16 h-16 flex items-center justify-center mb-4">
        <span className="text-2xl">📚</span>
      </div>
      <h3 className="text-xl font-semibold mb-2">No books found</h3>
      <p className="text-muted-foreground mb-4">
        Try adjusting your filters to find what you&apos;re looking for
      </p>
      <Button onClick={onClearFilters}>Clear all filters</Button>
    </div>
  );
}